

.PHONY: build-template
build-template:
	jinja2 geoserver-pv-gke.yaml.jinja ../../gke_jinja.json --format=json > geoserver-pv-gke.yaml
	jinja2 geoserver-deployment.yaml.jinja ../../gke_jinja.json --format=json > geoserver-deployment-gke.yaml
	jinja2 geoserver-deployment.yaml.jinja ../../minikube_jinja.json --format=json > geoserver-deployment-minikube.yaml
	jinja2 geoserver-data-job.yaml.jinja ../../gke_jinja.json --format=json > geoserver-data-job-gke.yaml

.PHONY: geoserver-up-mini
geoserver-up-mini:
	kubectl create -f ./geoserver-pvc.yaml
	kubectl create -f ./geoserver-pv-minikube.yaml
	kubectl create -f ./geoserver-deployment-minikube.yaml
	kubectl create -f ./geoserver-service.yaml

.PHONY: geoserver-down-mini
geoserver-down-mini:
	kubectl delete -f ./geoserver-pvc.yaml
	kubectl delete -f ./geoserver-pv-minikube.yaml
	kubectl delete -f ./geoserver-deployment-minikube.yaml
	kubectl delete -f ./geoserver-service.yaml

.PHONY: geoserver-up-gke
geoserver-up-gke:
	kubectl create -f ./geoserver-pvc.yaml
	kubectl create -f ./geoserver-pv-gke.yaml
	kubectl create -f ./geoserver-deployment-gke.yaml
	kubectl create -f ./geoserver-service.yaml

.PHONY: geoserver-down-gke
geoserver-down-gke:
	kubectl delete -f ./geoserver-pvc.yaml
	kubectl delete -f ./geoserver-pv-gke.yaml
	kubectl delete -f ./geoserver-deployment-gke.yaml
	kubectl delete -f ./geoserver-service.yaml
