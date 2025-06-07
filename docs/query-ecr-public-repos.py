DOCS_OUTPUT = "../readme.md"
REGISTRY_ALIAS = "dev1-sg"
REGISTRY_GROUP = "ci"
REGISTRY_URI = f"public.ecr.aws/{REGISTRY_ALIAS}"
REGISTRY_ENDPOINT_REGION = "us-east-1"
REGISTRY_ENDPOINT_URL = f"https://ecr-public.{REGISTRY_ENDPOINT_REGION}.amazonaws.com"

import boto3
from botocore.config import Config
from jinja2 import Template

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
    for page in client.get_paginator("describe_repositories").paginate():
        for repo in page.get("repositories", []):
            name = repo["repositoryName"]
            if prefix is None or name.startswith(prefix):
                repos.append(repo)
    return repos

def get_latest_tags(client, repo_name):
    try:
        images = client.describe_images(repositoryName=repo_name).get("imageDetails", [])
        tags = [(tag, img.get("imagePushedAt"))
                for img in images for tag in img.get("imageTags", []) if tag.lower() != "latest"]
        tags.sort(key=lambda x: x[1], reverse=True)
        seen = set()
        unique_tags = [t for t, _ in tags if not (t in seen or seen.add(t))]
        return unique_tags or ["N/A"]
    except Exception as e:
        print(f"[Warning] Failed to fetch tags for '{repo_name}': {e}")
        return ["N/A"]

def main():
    template = Template(load_template("template.j2").strip())
    client = get_ecr_client()

    repos = sorted(get_repositories(client, prefix=REGISTRY_GROUP + "/"), key=lambda r: r["repositoryName"])

    items = []
    for i, repo in enumerate(repos, 1):
        name = repo["repositoryName"]
        items.append({
            "number": i,
            "name": name,
            "group": name.split("/")[0] if "/" in name else "-",
            "uri": f"{REGISTRY_URI}/{name}",
            "latest_tag": get_latest_tags(client, name)[0],
        })

    output = template.render(items=items)
    print(output)
    with open(DOCS_OUTPUT, "w") as f:
        f.write(output)


if __name__ == "__main__":
    main()
