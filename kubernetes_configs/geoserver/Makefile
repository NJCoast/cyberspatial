

.PHONY: build-template
build-template:
	jinja2 geoserver-pv-gke.yaml.jinja ../../gke_jinja.json --format=json > geoserver-pve-gke.yaml

.PHONY: geoserver-up
	kubectl create -f ./geoserver-secret.yaml
	kubectl create -f ./geoserver-pvc.yaml
	kubectl create -f ./geoserver-pv-minikube.yaml
	kubectl create -f ./geoserver-deployment.yaml
	kubectl create -f ./geoserver-service.yaml

.PHONY: geoserver-down
	kubectl delete -f ./geoserver-secret.yaml
	kubectl delete -f ./geoserver-pvc.yaml
	kubectl delete -f ./geoserver-pv-minikube.yaml
	kubectl delete -f ./geoserver-deployment.yaml
	kubectl delete -f ./geoserver-service.yamlkubectl
