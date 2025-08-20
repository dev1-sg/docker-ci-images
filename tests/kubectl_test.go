package tests

import (
	"context"
	"io"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
)

var Kubectl = struct {
	AWS_ECR_PUBLIC_REGION           string
	AWS_ECR_PUBLIC_URI              string
	AWS_ECR_PUBLIC_REPOSITORY_GROUP string
	AWS_ECR_PUBLIC_IMAGE_NAME       string
	AWS_ECR_PUBLIC_IMAGE_TAG        string
}{
	AWS_ECR_PUBLIC_REGION:           "us-east-1",
	AWS_ECR_PUBLIC_URI:              "public.ecr.aws/dev1-sg",
	AWS_ECR_PUBLIC_REPOSITORY_GROUP: "ci",
	AWS_ECR_PUBLIC_IMAGE_NAME:       "kubectl",
	AWS_ECR_PUBLIC_IMAGE_TAG:        "latest",
}

func TestContainersGoPullKubectl(t *testing.T) {
	ctx := context.Background()
	for attempt := 0; attempt < 3; attempt++ {
		container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
			ContainerRequest: testcontainers.ContainerRequest{
				Image: Kubectl.AWS_ECR_PUBLIC_URI + "/" + Kubectl.AWS_ECR_PUBLIC_REPOSITORY_GROUP + "/" + Kubectl.AWS_ECR_PUBLIC_IMAGE_NAME + ":" + Kubectl.AWS_ECR_PUBLIC_IMAGE_TAG,
			},
		})
		require.NoError(t, e)
		container.Terminate(ctx)
	}
}

func TestContainersGoExecKubectl(t *testing.T) {
	ctx := context.Background()
	container, e := testcontainers.GenericContainer(ctx, testcontainers.GenericContainerRequest{
		ContainerRequest: testcontainers.ContainerRequest{
			Image: Kubectl.AWS_ECR_PUBLIC_URI + "/" + Kubectl.AWS_ECR_PUBLIC_REPOSITORY_GROUP + "/" + Kubectl.AWS_ECR_PUBLIC_IMAGE_NAME + ":" + Kubectl.AWS_ECR_PUBLIC_IMAGE_TAG,
			Cmd:   []string{"/bin/bash", "-c", "sleep infinity"},
		},
		Started: true,
	})
	require.NoError(t, e)
	defer container.Terminate(ctx)

	commands := [][]string{
		{"/bin/bash", "-c", "aws --version"},
		{"/bin/bash", "-c", "kubectl version --client"},
		{"/bin/bash", "-c", "helm version"},
		{"/bin/bash", "-c", "kustomize version"},
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
