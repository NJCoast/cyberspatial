# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

GOOGLE_CLOUD_PROJECT:=$(shell gcloud config list project --format="value(core.project)")
ZONE=$(shell gcloud config list compute/zone --format="value(compute.zone)")
CLUSTER_NAME=njcoast
COOL_DOWN=15
MIN=2
MAX=15
TARGET=50
DEPLOYMENT=njcoast
CYBERSPATIAL_POD_NAME=$(shell kubectl get pods | grep django -m 1 | awk '{print $$1}')

.PHONY: all
all: deploy


.PHONY: build-images
build-images:
	make -f ./dockerfiles/postgres/Makefile build
	make -f ./dockerfiles/nginx/Makefile build
	make -f ./dockerfiles/geoserver/Makefile build
	make -f ./dockerfiles/django/production/Makefile build

.PHONY: create-cluster
create-cluster:
	gcloud container clusters create njcoast \
		--scope "https://www.googleapis.com/auth/userinfo.email","cloud-platform" \
		--num-nodes=$(MIN)
	gcloud container clusters get-credentials njcoast

.PHONY: create-bucket
create-bucket:
	gsutil mb gs://$(GOOGLE_CLOUD_PROJECT)
	gsutil defacl set public-read gs://$(GOOGLE_CLOUD_PROJECT)

.PHONY: template
template:
	# Minikube templates
	jinja2 kubernetes_configs/cyberspatial/cyberspatial.yaml.jinja minikube_jinja.json --format=json > kubernetes_configs/cyberspatial/cyberspatial_minikube.yaml
	jinja2 kubernetes_configs/postgres/postgres.yaml.jinja minikube_jinja.json --format=json > kubernetes_configs/postgres/postgres_minikube.yaml
	jinja2 kubernetes_configs/geoserver/geoserver.yaml.jinja minikube_jinja.json --format=json > kubernetes_configs/geoserver/geoserver_minikube.yaml
	jinja2 kubernetes_configs/nginx/nginx.yaml.jinja minikube_jinja.json --format=json > kubernetes_configs/nginx/nginx_minikube.yaml
	# GKE templates
	jinja2 kubernetes_configs/cyberspatial/cyberspatial.yaml.jinja gke_jinja.json --format=json > kubernetes_configs/cyberspatial/cyberspatial_gke.yaml
	jinja2 kubernetes_configs/postgres/postgres.yaml.jinja gke_jinja.json --format=json > kubernetes_configs/postgres/postgres_gke.yaml
	jinja2 kubernetes_configs/nginx/nginx.yaml.jinja gke_jinja.json --format=json > kubernetes_configs/nginx/nginx_gke.yaml
	jinja2 kubernetes_configs/geoserver/geoserver.yaml.jinja gke_jinja.json --format=json > kubernetes_configs/geoserver/geoserver_gke.yaml

.PHONY: deploy
deploy: push template
	kubectl apply -f kubernetes_config/cyberspatial/cyberspatial-gke.yaml

.PHONY: update
update:
	kubectl rolling-update frontend --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/cyberspatial:latest

.PHONY: disk
disk:
	gcloud compute disks create pg-data  --size 200GB

.PHONY: firewall
firewall:
	gcloud compute firewall-rules create kubepostgres --allow tcp:30061

.PHONY: autoscale-on
autoscale-on:
	AUTOSCALE_GROUP=$(shell gcloud container clusters describe $(CLUSTER_NAME) --zone $(ZONE) --format yaml | grep -A 1 instanceGroupUrls | awk -F/ 'FNR ==2 {print $$NF}')
	gcloud compute instance-groups managed set-autoscaling $(AUTOSCALE_GROUP) \
	  --cool-down-period $(COOL_DOWN) \
	  --max-num-replicas $(MAX) \
	  --min-num-replicas $(MIN) \
	  --scale-based-on-cpu --target-cpu-utilization $(shell echo "scale=2; $(TARGET)/100" | bc)
	kubectl autoscale rc $(DEPLOYMENT) --min=$(MIN) --max=$(MAX) --cpu-percent=$(TARGET)

.PHONY: migrations
migrations:
	kubectl exec $(CYBERSPATIAL_POD_NAME) -- /app/manage.py migrate --noinput
	kubectl exec $(CYBERSPATIAL_POD_NAME) -- /app/manage.py loaddata sample_admin
	kubectl exec $(CYBERSPATIAL_POD_NAME) -- /app/manage.py loaddata /usr/local/src/geonode/geonode/base/fixtures/default_oauth_apps_docker.json
	kubectl exec $(CYBERSPATIAL_POD_NAME) -- /app/manage.py loaddata /usr/local/src/geonode/geonode/base/fixtures/initial_data.json

.PHONY: delete
delete:
	gcloud container clusters delete guestbook
	gcloud compute disks delete pg-data
