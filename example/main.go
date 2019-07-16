package main

import (
	"context"
	"log"

	"github.com/antihax/optional"

	apprclient "github.com/ecordell/go-appr/client"
)

func main() {
	client := apprclient.NewAPIClient(&apprclient.Configuration{
		BasePath:      "https://quay.io/cnr",
		DefaultHeader: make(map[string]string),
		UserAgent:     "go-appr/1.0.0",
		Scheme:        "https",
	})

	packages, err := listPackages(client)
	if err != nil {
		log.Fatalf("error - %v", err)
	}

	log.Printf("success - found [%d] package(s)\n", len(packages))
}

func listPackages(client *apprclient.APIClient) ([]apprclient.Package, error) {
	packages, _, err := client.PackageApi.ListPackages(context.TODO(),
		&apprclient.ListPackagesOpts{Namespace: optional.NewString("community-operators")})
	if err != nil {
		return nil, err
	}

	return packages, nil
}
