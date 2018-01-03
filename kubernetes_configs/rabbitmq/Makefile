.PHONY: rabbitmq-up
rabbitmq-up:
	kubectl create -f ./rabbitmq-deployment.yaml
	kubectl create -f ./rabbitmq-service.yaml

.PHONY: rabbitmq-down
rabbitmq-down:
	kubectl delete -f ./rabbitmq-deployment.yaml
	kubectl delete -f ./rabbitmq-service.yaml