$(PREREQS):
	@command -v openapi-generator || echo "openapi-generator not found. Install on macOS: brew install openapi-generator"

regen: $(PREREQS)
regen: export GO_POST_PROCESS_FILE="gofmt -w"
regen: appr.spec.yaml
	@rm -rf ./client
	@openapi-generator generate -i appr.spec.yaml -g go -o ./client
	@rm -f ./client/go.mod
	@rm -f ./client/go.sum
	@go mod vendor
	@go mod tidy
	@echo "Fixing bad option names... (https://github.com/OpenAPITools/openapi-generator/pull/3206)"
	@sed -i "s/PullPackageOpts/PackagePullPackageOpts/gi" ./client/api_package.go
	@sed -i "s/PullPackageJsonOpts/PackagePullPackageJsonOpts/gi" ./client/api_package.go
	@sed -i "s/PullPackageOpts/BlobPullPackageOpts/gi" ./client/api_blobs.go
	@sed -i "s/PullPackageJsonOpts/BlobPullPackageJsonOpts/gi" ./client/api_blobs.go
	@echo Fixing missing imports...
	@goimports -w ./client
