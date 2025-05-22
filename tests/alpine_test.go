package tests

import (
	"context"
	"io"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
)

var Alpine = struct {
	AWS_DEFAULT_REGION string
	AWS_ECR_PUBLIC_URI string
	DOCKER_IMAGE_GROUP string
	DOCKER_IMAGE       string
	DOCKER_IMAGE_TAG   string
}{
	AWS_DEFAULT_REGION: "us-east-1",
	AWS_ECR_PUBLIC_URI: "public.ecr.aws/dev1-sg",
	DOCKER_IMAGE_GROUP: "ci",
	DOCKER_IMAGE:       "alpine",
	DOCKER_IMAGE_TAG:   "latest",
}

func TestContainersGoPullAlpine(t *testing.T) {
	ctx := context.Background()
	container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: testcontainers.ContainerRequest{
			Image: Alpine.AWS_ECR_PUBLIC_URI + "/" + Alpine.DOCKER_IMAGE_GROUP + "/" + Alpine.DOCKER_IMAGE + ":" + Alpine.DOCKER_IMAGE_TAG,
		},
	})
	require.NoError(t, e)
	container.Terminate(ctx)
}

func TestContainersGoExecAlpine(t *testing.T) {
	ctx := context.Background()
	container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: testcontainers.ContainerRequest{
			Image: Alpine.AWS_ECR_PUBLIC_URI + "/" + Alpine.DOCKER_IMAGE_GROUP + "/" + Alpine.DOCKER_IMAGE + ":" + Alpine.DOCKER_IMAGE_TAG,
			Cmd:   []string{"sleep", "10"},
		},
		Started: true,
	})
	require.NoError(t, e)
	defer container.Terminate(ctx)

	exitCode, reader, e := container.Exec(ctx, []string{"echo", "Hello, World!"})
	require.NoError(t, e)
	require.Equal(t, 0, exitCode)

	output, e := io.ReadAll(reader)
	require.NoError(t, e)

	require.Contains(t, string(output), "Hello, World!", "Expected output not found")
}
