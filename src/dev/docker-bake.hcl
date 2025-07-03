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

variable "AWS_ECR_PUBLIC_IMAGE_NAME" {
  default = "dev"
}

variable "AWS_ECR_PUBLIC_IMAGE_TAG" {
  default = "dev"
}

variable "AWS_ECR_PUBLIC_IMAGE_URI" {
  default = "public.ecr.aws/dev1-sg/ci/dev:latest"
}

variable "AWS_ECR_PUBLIC_REPOSITORY_GROUP" {
  default = "ci"
}

group "default" {
  targets = ["build"]
}

target "metadata" {
  labels = {
    "org.opencontainers.image.title"       = "${AWS_ECR_PUBLIC_IMAGE_NAME}"
    "org.opencontainers.image.description" = "Default ${AWS_ECR_PUBLIC_IMAGE_NAME} ${AWS_ECR_PUBLIC_REPOSITORY_GROUP} image for internal use"
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

target "test" {
  inherits = ["settings", "metadata"]
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = []
}

target "build" {
  inherits = ["settings", "metadata"]
  dockerfile = "Dockerfile"
  output     = ["type=docker"]
  tags = [
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:latest",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:${AWS_ECR_PUBLIC_IMAGE_TAG}",
  ]
}

target "push" {
  inherits = ["settings", "metadata"]
  dockerfile = "Dockerfile"
  output     = ["type=registry"]
  platforms  = ["linux/amd64", "linux/arm64"]
  tags = [
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:latest",
    "${AWS_ECR_PUBLIC_URI}/${AWS_ECR_PUBLIC_REPOSITORY_GROUP}/${AWS_ECR_PUBLIC_IMAGE_NAME}:${AWS_ECR_PUBLIC_IMAGE_TAG}",
  ]
}
