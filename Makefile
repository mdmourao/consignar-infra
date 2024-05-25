init:
	@terraform init

doc:
	@terraform-docs markdown table --output-file README.md --output-mode inject .

validate: init
	@echo "Validating..."
	@terraform validate

plan:
	@echo "Planning..."
	@terraform plan -var-file='./environments/prod/prod.tfvars'

apply: validate
	@terraform apply -var-file='./environments/prod/prod.tfvars'

destroy:
	@terraform destroy -var-file='./environments/prod/prod.tfvars'