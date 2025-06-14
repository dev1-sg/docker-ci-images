import locale
from datetime import datetime

now = datetime.now().astimezone()
print(now.strftime("%c"), now.tzname(), locale.getlocale())

import docker
from jinja2 import Template

INPUT_TEMPLATE = "templates/meta.j2"
OUTPUT_README = "src/ansible/readme.md"
IMAGE_URI = "public.ecr.aws/dev1-sg/ci/ansible:latest"

def pull_image(client, image_name):
    print(f"Pulling image: {image_name}")
    return client.images.pull(image_name)

def get_image_architecture(client, image):
    image_details = client.images.get(image.id)
    return image_details.attrs.get("Architecture", "unknown")

def run_container_command(client, image_name, command, arch):
    output = client.containers.run(
        image=image_name,
        command=command,
        remove=True,
        platform=f"linux/{arch}"
    )
    return output.decode("utf-8")

def parse_key_value_output(output):
    result = {}
    for line in output.strip().splitlines():
        if "=" in line:
            key, value = line.split("=", 1)
            result[key] = value.strip('"')
    return result

def main():
    updated_time = now.strftime("%c"), now.tzname()

    client = docker.from_env()
    image_name = IMAGE_URI

    image = pull_image(client, image_name)
    arch = get_image_architecture(client, image)

    os_release_str = run_container_command(client, image_name, "cat /etc/os-release", arch)
    os_release_info = parse_key_value_output(os_release_str)

    env_output_str = run_container_command(client, image_name, "env", arch)
    env_vars = env_output_str.strip().splitlines()

    pkg_output_str = run_container_command(client, image_name, "apk info", arch)
    pkg_vars = pkg_output_str.strip().splitlines()

    local_output_str = run_container_command(client, image_name, "ls -1 /usr/local/bin", arch)
    pkg_local = local_output_str.strip().splitlines()

    with open(INPUT_TEMPLATE) as tpl_file:
        template_content = tpl_file.read()
    template = Template(template_content, trim_blocks=True, lstrip_blocks=True)

    context = {
        "image": image_name,
        "arch": arch,
        "os_name": os_release_info.get("NAME"),
        "os_version_id": os_release_info.get("VERSION_ID"),
        "os_id": os_release_info.get("ID"),
        "env_vars": env_vars,
        "pkg_vars": pkg_vars,
        "pkg_local": pkg_local,
    }

    output = template.render(context=context, updated_at=updated_time)

    print(output)

    with open(OUTPUT_README, "w") as f:
        f.write(output)

if __name__ == "__main__":
    main()
