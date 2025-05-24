package tests

import (
	"context"
	"io"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
)

var Python = struct {
	AWS_DEFAULT_REGION string
	AWS_ECR_PUBLIC_URI string
	DOCKER_IMAGE_GROUP string
	DOCKER_IMAGE       string
	DOCKER_IMAGE_TAG   string
}{
	AWS_DEFAULT_REGION: "us-east-1",
	AWS_ECR_PUBLIC_URI: "public.ecr.aws/dev1-sg",
	DOCKER_IMAGE_GROUP: "ci",
	DOCKER_IMAGE:       "python",
	DOCKER_IMAGE_TAG:   "latest",
}

func TestContainersGoPullPython(t *testing.T) {
	ctx := context.Background()
	container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: testcontainers.ContainerRequest{
			Image: Python.AWS_ECR_PUBLIC_URI + "/" + Python.DOCKER_IMAGE_GROUP + "/" + Python.DOCKER_IMAGE + ":" + Python.DOCKER_IMAGE_TAG,
		},
	})
	require.NoError(t, e)
	container.Terminate(ctx)
}

func TestContainersGoExecPython(t *testing.T) {
	ctx := context.Background()
	container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: testcontainers.ContainerRequest{
			Image: Python.AWS_ECR_PUBLIC_URI + "/" + Python.DOCKER_IMAGE_GROUP + "/" + Python.DOCKER_IMAGE + ":" + Python.DOCKER_IMAGE_TAG,
			Cmd:   []string{"sleep", "10"},
		},
		Started: true,
	})
	require.NoError(t, e)
	defer container.Terminate(ctx)

	exitCode, reader, e := container.Exec(ctx, []string{"python", "--version"})
	require.NoError(t, e)
	require.Equal(t, 0, exitCode)

	output, e := io.ReadAll(reader)
	require.NoError(t, e)

	require.Contains(t, string(output), "Python", "Expected output not found")
}
