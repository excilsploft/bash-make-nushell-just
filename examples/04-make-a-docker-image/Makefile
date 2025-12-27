imagename := py-get-services
imagetag := 1

default: dockerrun

iid_file: requirements.txt get-services.py
	docker build --iidfile $@ -t  $(imagename):$(imagetag) .

dockerrun: iid_file
	@docker run -it --rm --name "py-get-services" $(imagename):$(imagetag)
