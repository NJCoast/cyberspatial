


.PHONY: rabbitmq-up
	kubectl create -f ./rabbitmq-deployment-minikube.yaml
	kubectl create -f ./rabbitmq-service.yaml

.PHONY: rabbitmq-down
	kubectl delete -f ./rabbitmq-deployment-minikube.yaml
	kubectl delete -f ./rabbitmq-service.yaml
