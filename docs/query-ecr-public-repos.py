import locale
from datetime import datetime

now = datetime.now().astimezone()
print(now.strftime("%c"), now.tzname(), locale.getlocale())

import boto3
from botocore.config import Config
from jinja2 import Template

INPUT_TEMPLATE = "readme_template.j2"
OUTPUT_README = "../readme.md"
REGISTRY_ALIAS = "dev1-sg"
REGISTRY_GROUP = "ci"
REGISTRY_URI = f"public.ecr.aws/{REGISTRY_ALIAS}"
REGISTRY_ENDPOINT_REGION = "us-east-1"
REGISTRY_ENDPOINT_URL = f"https://ecr-public.{REGISTRY_ENDPOINT_REGION}.amazonaws.com"

def load_template(path):
    with open(path) as f:
        return f.read()

def get_ecr_client():
    return boto3.Session().client(
        "ecr-public",
        region_name=REGISTRY_ENDPOINT_REGION,
        endpoint_url=REGISTRY_ENDPOINT_URL,
        config=Config(signature_version='v4')
    )

def get_repositories(client, prefix=None):
    repos = []
    paginator = client.get_paginator("describe_repositories")
    for page in paginator.paginate():
        for repo in page.get("repositories", []):
            name = repo["repositoryName"]
            if prefix is None or name.startswith(prefix):
                repos.append(repo)
    return repos

def get_latest_tag_and_size(client, repo_name):
    try:
        images = client.describe_images(repositoryName=repo_name).get("imageDetails", [])
        tagged_images = [
            (tag, img.get("imagePushedAt"), img.get("imageSizeInBytes", 0))
            for img in images for tag in img.get("imageTags", [])
            if tag.lower() != "latest"
        ]
        tagged_images.sort(key=lambda x: x[1], reverse=True)
        seen = set()
        for tag, pushed_at, size in tagged_images:
            if tag not in seen:
                seen.add(tag)
                return tag, size
        return "N/A", 0
    except Exception as e:
        print(f"[Warning] Failed to fetch tags for '{repo_name}': {e}")
        return "N/A", 0

def main():
    updated_time = now.strftime("%c"), now.tzname()

    template = Template(load_template(INPUT_TEMPLATE), trim_blocks=True, lstrip_blocks=True)
    client = get_ecr_client()

    repos = sorted(get_repositories(client, prefix=REGISTRY_GROUP + "/"), key=lambda r: r["repositoryName"])

    items = []
    for i, repo in enumerate(repos, 1):
        name = repo["repositoryName"]
        latest_tag, size = get_latest_tag_and_size(client, name)
        items.append({
            "number": i,
            "name": name,
            "group": name.split("/")[0] if "/" in name else "-",
            "uri": f"{REGISTRY_URI}/{name}",
            "latest_tag": latest_tag,
            "size": f"{size / (1024 * 1024):.2f} MB" if size else "N/A",
        })

    output = template.render(items=items, updated_at=updated_time)
    print(output)
    with open(OUTPUT_README, "w") as f:
        f.write(output)

if __name__ == "__main__":
    main()
