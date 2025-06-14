package tests

import (
	"context"
	"io"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
)

var Test = struct {
	AWS_DEFAULT_REGION string
	AWS_ECR_PUBLIC_URI string
	DOCKER_IMAGE_GROUP string
	DOCKER_IMAGE       string
	DOCKER_IMAGE_TAG   string
}{
	AWS_DEFAULT_REGION: "us-east-1",
	AWS_ECR_PUBLIC_URI: "public.ecr.aws/dev1-sg",
	DOCKER_IMAGE_GROUP: "ci",
	DOCKER_IMAGE:       "test",
	DOCKER_IMAGE_TAG:   "latest",
}

func TestContainersGoPullTest(t *testing.T) {
	ctx := context.Background()
	for attempt := 0; attempt < 3; attempt++ {
		container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
			ContainerRequest: testcontainers.ContainerRequest{
				Image: Test.AWS_ECR_PUBLIC_URI + "/" + Test.DOCKER_IMAGE_GROUP + "/" + Test.DOCKER_IMAGE + ":" + Test.DOCKER_IMAGE_TAG,
			},
		})
		require.NoError(t, e)
		container.Terminate(ctx)
	}
}

func TestContainersGoExecTest(t *testing.T) {
	ctx := context.Background()
	container, err := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: testcontainers.ContainerRequest{
			Image: Test.AWS_ECR_PUBLIC_URI + "/" + Test.DOCKER_IMAGE_GROUP + "/" + Test.DOCKER_IMAGE + ":" + Test.DOCKER_IMAGE_TAG,
			Cmd:   []string{"sleep", "10"},
		},
		Started: true,
	})
	require.NoError(t, err)
	defer container.Terminate(ctx)

	commands := [][]string{
		{"echo", "Hello"},
		{"echo", "world"},
	}

	for _, cmd := range commands {
		exitCode, reader, err := container.Exec(ctx, cmd)
		require.NoError(t, err)
		require.Equal(t, 0, exitCode)

		output, err := io.ReadAll(reader)
		require.NoError(t, err)

		t.Logf("Command: %v\nOutput: %s\n", cmd, output)
		require.NotEmpty(t, output)
	}
}