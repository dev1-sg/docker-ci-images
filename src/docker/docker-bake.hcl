variable "AWS_ECR_PUBLIC_ALIAS" {
  default = "dev1-sg"
}

variable "AWS_ECR_PUBLIC_REGION" {
  default = "us-east-1"
}

variable "AWS_ECR_PUBLIC_URI" {
  default = "public.ecr.aws/dev1-sg"
}

variable "AWS_ECR_PUBLIC_URL" {
  default = "https://ecr-public.us-east-1.amazonaws.com"
}

variable "AWS_ECR_PUBLIC_REPOSITORY_GROUP" {
  default = "ci"
}

variable "AWS_ECR_PUBLIC_IMAGE_NAME" {
  default = "docker"
}

variable "AWS_ECR_PUBLIC_IMAGE_TAG" {
  default = "latest"
}

variable "AWS_ECR_PUBLIC_IMAGE_TAG_CLI" {
  default = "latest"
}

variable "AWS_ECR_PUBLIC_IMAGE_TAG_DIND" {
  default = "latest"
}

variable "AWS_ECR_PUBLIC_IMAGE_URI" {
  default = "public.ecr.aws/dev1-sg/ci/docker:latest"
}

target "metadata" {
  labels = {
    "org.opencontainers.image.title"       = "${AWS_ECR_PUBLIC_IMAGE_NAME}"
    "org.opencontainers.image.description" = "Minimal ${AWS_ECR_PUBLIC_IMAGE_NAME} ${AWS_ECR_PUBLIC_REPOSITORY_GROUP} image for internal use"
    "org.opencontainers.image.url"         = "https://gitlab.com/dev1-sg/public/docker-${AWS_ECR_PUBLIC_REPOSITORY_GROUP}-images/-/tree/main/src/${AWS_ECR_PUBLIC_IMAGE_NAME}"
    "org.opencontainers.image.source"      = "https://gitlab.com/dev1-sg/public/docker-${AWS_ECR_PUBLIC_REPOSITORY_GROUP}-images"
    "org.opencontainers.image.version"     = "${AWS_ECR_PUBLIC_IMAGE_TAG}"
  }
}

target "settings" {
  context = "."
  cache-from = [
    "type=gha"
  ]
  cache-to = [
    "type=gha,mode=max"
  ]
}

target "test-cli" {
  inherits = ["settings", "metadata"]
  dockerfile = "Dockerfile.cli"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = []
}

target "test-dind" {
  inherits = ["settings", "metadata"]
  dockerfile = "Dockerfile.dind"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = []
}

target "build-cli" {
  inherits = ["settings", "metadata"]
  dockerfile = "Dockerfile.cli"
  output     = ["type=docker"]
  tags = [
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:cli",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:${AWS_ECR_PUBLIC_IMAGE_TAG_CLI}-cli",
  ]
}

target "build-dind" {
  inherits = ["settings", "metadata"]
  dockerfile = "Dockerfile.dind"
  output     = ["type=docker"]
  tags = [
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:latest",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:dind",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:${AWS_ECR_PUBLIC_IMAGE_TAG_DIND}-dind",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:${AWS_ECR_PUBLIC_IMAGE_TAG_DIND}",
  ]
}

target "push-cli" {
  inherits = ["settings", "metadata"]
  dockerfile = "Dockerfile.cli"
  output     = ["type=registry"]
  platforms  = ["linux/amd64", "linux/arm64"]
  tags = [
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:cli",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:${AWS_ECR_PUBLIC_IMAGE_TAG_CLI}-cli",
  ]
}

target "push-dind" {
  inherits = ["settings", "metadata"]
  dockerfile = "Dockerfile.dind"
  output     = ["type=registry"]
  platforms  = ["linux/amd64", "linux/arm64"]
  tags = [
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:latest",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:dind",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:${AWS_ECR_PUBLIC_IMAGE_TAG_DIND}-dind",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:${AWS_ECR_PUBLIC_IMAGE_TAG_DIND}",
  ]
}

group "default" {
  targets = ["test-dind"]
}

group "test" {
  targets = ["test-dind"]
}

group "build" {
  targets = ["build-cli", "build-dind"]
}

group "push" {
  targets = ["push-cli", "push-dind"]
}
