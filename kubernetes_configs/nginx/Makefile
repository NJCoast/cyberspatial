

.PHONY: build-template
build-template:
	jinja2 nginx-deployment-gke.yaml.jinja ../../gke_jinja.json --format=json > nginx-deployment-gke.yaml
	jinja2 nginx-deployment-minikube.yaml.jinja ../../minikube_jinja.json --format=json > nginx-deployment-minikube.yaml

.PHONY: nginx-up
	kubectl create -f ./nginx-deployment-minikube.yaml
	kubectl create -f ./nginx-service.yaml

.PHONY: nginx-down
	kubectl delete -f ./nginx-deployment-minikube.yaml
	kubectl delete -f ./nginx-service.yaml
