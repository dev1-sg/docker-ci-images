package tests

import (
	"context"
	"io"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
)

var Terraform = struct {
	AWS_DEFAULT_REGION string
	AWS_ECR_PUBLIC_URI string
	DOCKER_IMAGE_GROUP string
	DOCKER_IMAGE       string
	DOCKER_IMAGE_TAG   string
}{
	AWS_DEFAULT_REGION: "us-east-1",
	AWS_ECR_PUBLIC_URI: "public.ecr.aws/f7i0q1v8",
	DOCKER_IMAGE_GROUP: "ci",
	DOCKER_IMAGE:       "terraform",
	DOCKER_IMAGE_TAG:   "latest",
}

func TestContainersGoPullTerraform(t *testing.T) {
	ctx := context.Background()
	container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: testcontainers.ContainerRequest{
			Image: Terraform.AWS_ECR_PUBLIC_URI + "/" + Terraform.DOCKER_IMAGE_GROUP + "/" + Terraform.DOCKER_IMAGE + ":" + Terraform.DOCKER_IMAGE_TAG,
		},
	})
	require.NoError(t, e)
	container.Terminate(ctx)
}

func TestContainersGoExecTerraform(t *testing.T) {
	ctx := context.Background()
	container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: testcontainers.ContainerRequest{
			Image: Terraform.AWS_ECR_PUBLIC_URI + "/" + Terraform.DOCKER_IMAGE_GROUP + "/" + Terraform.DOCKER_IMAGE + ":" + Terraform.DOCKER_IMAGE_TAG,
			Cmd:   []string{"sleep", "10"},
		},
		Started: true,
	})
	require.NoError(t, e)
	defer container.Terminate(ctx)

	exitCode, reader, e := container.Exec(ctx, []string{"terraform", "--version"})
	require.NoError(t, e)
	require.Equal(t, 0, exitCode)

	output, e := io.ReadAll(reader)
	require.NoError(t, e)

	require.Contains(t, string(output), "Terraform", "Expected output not found")
}
