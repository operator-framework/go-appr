$(PREREQS):
	command -v swagger || go get -u github.com/go-swagger/go-swagger/cmd/swagger

regen: $(PREREQS)
regen: appr.spec.yaml
	swagger generate client --spec=./appr.spec.yaml --name=appregistry --api-package=appr --client-package=appregistry