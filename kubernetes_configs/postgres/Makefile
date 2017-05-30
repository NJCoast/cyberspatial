

.PHONY: build-template
build-template:
	jinja2 postgres-pv-gke.yaml.jinja ../../gke_jinja.json --format=json > postgres-pv-gke.yaml
	jinja2 postgres-pv-gke.yaml.jinja ../../minikube_jinja.json --format=json > postgres-pv-minikube.yaml

.PHONY: postgres-up
postgres-up:
	kubectl create -f ./postgres-secret.yaml
	kubectl create -f ./postgres-pvc.yaml
	kubectl create -f ./postgres-pv-minikube.yaml
	kubectl create -f ./postgres-deployment.yaml
	kubectl create -f ./postgres-service.yaml

.PHONY: postgres-down
postgres-down:
	kubectl delete -f ./postgres-secret.yaml
	kubectl delete -f ./postgres-pvc.yaml
	kubectl delete -f ./postgres-pv-minikube.yaml
	kubectl delete -f ./postgres-deployment.yaml
	kubectl delete -f ./postgres-service.yamlkubectl
