from datetime import datetime
from jinja2 import Template
from pathlib import Path

# Get current time and timezone in a readable format
now = datetime.now().astimezone()
updated_time = f"{now.strftime('%c')} {now.tzname()}"

# Prompt for Docker image values and normalize
DOCKER_IMAGE_GROUP = input("Enter DOCKER_IMAGE_GROUP: ").strip().lower()
DOCKER_IMAGE = input("Enter DOCKER_IMAGE: ").strip().lower().replace("_", "-")

# Template variables
template_vars = {
    "updated_at": updated_time,
    "DOCKER_IMAGE_GROUP": DOCKER_IMAGE_GROUP,
    "DOCKER_IMAGE": DOCKER_IMAGE,
}

# Paths
TEMPLATES_DIR = Path("templates")
OUTPUT_DIR = Path("output")
OUTPUT_DIR.mkdir(exist_ok=True)

# Load Jinja2 template from file
def load_template(filename: str) -> Template:
    with open(TEMPLATES_DIR / filename) as f:
        return Template(f.read(), trim_blocks=True, lstrip_blocks=True)

# Render template to output file
def render_to_file(template: Template, output_path: Path, context: dict):
    rendered = template.render(context)
    with open(output_path, "w") as f:
        f.write(rendered)
    print(f"Generated {output_path}")

# Generators
def generate_dockerfile():
    render_to_file(load_template("docker_dockerfile.j2"), OUTPUT_DIR / "dockerfile", template_vars)

def generate_dockerignore():
    render_to_file(load_template("docker_dockerignore.j2"), OUTPUT_DIR / ".dockerignore", template_vars)

def generate_docker_bake():
    render_to_file(load_template("docker_bake.j2"), OUTPUT_DIR / "docker-bake.hcl", template_vars)

def generate_gh_action_pr():
    output_filename = f"pr-dependabot-{DOCKER_IMAGE}.yml"
    render_to_file(load_template("gh_action_pr.j2"), OUTPUT_DIR / output_filename, template_vars)

def generate_gh_action_push():
    output_filename = f"push-{DOCKER_IMAGE}.yml"
    render_to_file(load_template("gh_action_push.j2"), OUTPUT_DIR / output_filename, template_vars)

def generate_testcontainers():
    output_filename = f"{DOCKER_IMAGE}_test.go"
    render_to_file(load_template("testcontainer.j2"), OUTPUT_DIR / output_filename, template_vars)

def main():
    print("Generating scaffold files...\n")
    generate_dockerfile()
    generate_dockerignore()
    generate_docker_bake()
    generate_gh_action_pr()
    generate_gh_action_push()
    generate_testcontainers()
    print("\nAll files generated in:", OUTPUT_DIR.resolve())

if __name__ == "__main__":
    main()
