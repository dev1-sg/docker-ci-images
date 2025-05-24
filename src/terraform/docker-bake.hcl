variable "AWS_ECR_PUBLIC_URI" {
  default = "public.ecr.aws/dev1-sg"
}

variable "DOCKER_IMAGE_GROUP" {
  default = "ci"
}

variable "DOCKER_IMAGE" {
  default = "terraform"
}

variable "DOCKER_IMAGE_TAG" {
  default = "latest"
}

group "default" {
  targets = ["build"]
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
  inherits = ["settings"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = []
}

target "build" {
  inherits = ["settings"]
  dockerfile = "Dockerfile"
  output   = ["type=docker"]
  tags = [
    "${AWS_ECR_PUBLIC_URI}/${DOCKER_IMAGE_GROUP}/${DOCKER_IMAGE}:latest",
    "${AWS_ECR_PUBLIC_URI}/${DOCKER_IMAGE_GROUP}/${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}",
  ]
}

target "push" {
  inherits = ["settings"]
  dockerfile = "Dockerfile"
  output   = ["type=registry"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "${AWS_ECR_PUBLIC_URI}/${DOCKER_IMAGE_GROUP}/${DOCKER_IMAGE}:latest",
    "${AWS_ECR_PUBLIC_URI}/${DOCKER_IMAGE_GROUP}/${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}",
  ]
}
