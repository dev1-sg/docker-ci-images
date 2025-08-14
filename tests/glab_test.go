package tests

import (
	"context"
	"io"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
)

var Glab = struct {
	AWS_ECR_PUBLIC_REGION           string
	AWS_ECR_PUBLIC_URI              string
	AWS_ECR_PUBLIC_REPOSITORY_GROUP string
	AWS_ECR_PUBLIC_IMAGE_NAME       string
	AWS_ECR_PUBLIC_IMAGE_TAG        string
}{
	AWS_ECR_PUBLIC_REGION:           "us-east-1",
	AWS_ECR_PUBLIC_URI:              "public.ecr.aws/dev1-sg",
	AWS_ECR_PUBLIC_REPOSITORY_GROUP: "ci",
	AWS_ECR_PUBLIC_IMAGE_NAME:       "glab",
	AWS_ECR_PUBLIC_IMAGE_TAG:        "latest",
}

func TestContainersGoPullGlab(t *testing.T) {
	ctx := context.Background()
	for attempt := 0; attempt < 3; attempt++ {
		container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
			ContainerRequest: testcontainers.ContainerRequest{
				Image: Glab.AWS_ECR_PUBLIC_URI + "/" + Glab.AWS_ECR_PUBLIC_REPOSITORY_GROUP + "/" + Glab.AWS_ECR_PUBLIC_IMAGE_NAME + ":" + Glab.AWS_ECR_PUBLIC_IMAGE_TAG,
			},
		})
		require.NoError(t, e)
		container.Terminate(ctx)
	}
}

func TestContainersGoExecGlab(t *testing.T) {
	ctx := context.Background()
	container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: testcontainers.ContainerRequest{
			Image: Glab.AWS_ECR_PUBLIC_URI + "/" + Glab.AWS_ECR_PUBLIC_REPOSITORY_GROUP + "/" + Glab.AWS_ECR_PUBLIC_IMAGE_NAME + ":" + Glab.AWS_ECR_PUBLIC_IMAGE_TAG,
			Cmd:   []string{"sleep", "10"},
		},
		Started: true,
	})
	require.NoError(t, e)
	defer container.Terminate(ctx)

	commands := [][]string{
		{"aws", "--version"},
		{"glab", "--version"},
	}

	for _, cmd := range commands {
		exitCode, reader, e := container.Exec(ctx, cmd)
		require.NoError(t, e)
		require.Equal(t, 0, exitCode)

		output, e := io.ReadAll(reader)
		require.NoError(t, e)

		t.Logf("Command: %v\nOutput: %s\n", cmd, output)
		require.NotEmpty(t, output)
	}
}
