import platform
import shutil
import subprocess
import os
import uuid
import docker
from flask import Flask, render_template, request, redirect, url_for
import socket

app = Flask(__name__)

# Detect OS type (for future package installations)
def get_os_family():
    if os.path.exists("/etc/debian_version"):
        return "debian"
    elif os.path.exists("/etc/redhat-release"):
        return "redhat"
    else:
        return "unknown"

# Install missing package
def install_package(tool, os_family):
    try:
        if os_family == "debian":
            subprocess.run(["sudo", "apt", "update"], check=True)
            subprocess.run(["sudo", "apt", "install", "-y", tool], check=True)
        elif os_family == "redhat":
            subprocess.run(["sudo", "yum", "install", "-y", tool], check=True)
        return True, None
    except Exception as e:
        return False, str(e)

# Check if Portainer is actually installed and running (or exists as a container)
def is_portainer_installed():
    try:
        result = subprocess.run(
            ["docker", "inspect", "-f", "{{.State.Running}}", "portainer"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True
        )
        return result.stdout.strip() in ["true", "false"]
    except Exception:
        return False

# Actually run Portainer
def run_portainer():
    try:
        subprocess.run(["docker", "volume", "create", "portainer_data"], check=True)
        subprocess.run([
            "docker", "run", "-d",
            "-p", "9443:9443", "-p", "9000:9000",
            "--name", "portainer",
            "--restart=always",
            "-v", "/var/run/docker.sock:/var/run/docker.sock",
            "-v", "portainer_data:/data",
            "portainer/portainer-ce:latest"
        ], check=True)
        return True, "✅ Portainer installed successfully."
    except subprocess.CalledProcessError as e:
        return False, f"❌ Docker Error: {str(e)}"

# Routes
@app.route("/")
def home():
    return render_template("home.html")

@app.route("/install_portainer", methods=["GET", "POST"])
def install_portainer_route():
    installed = is_portainer_installed()
    portainer_url = "https://localhost:9443"
    message = None

    if request.method == "POST":
        if not installed:
            success, message = run_portainer()
            installed = success
        else:
            message = "ℹ️ Portainer is already installed."

    return render_template("portainer.html", installed=installed, message=message, url=portainer_url)

@app.route("/pre-req")
def prereq():
    tools = ["pip3", "podman", "openssl", "docker","terraform"]
    results = {}
    os_family = get_os_family()

    for tool in tools:
        if shutil.which(tool):
            results[tool] = "✅ Installed"
        else:
            success, error = install_package(tool, os_family)
            if success:
                results[tool] = "❌ Not Found → 🛠️ Installed"
            else:
                results[tool] = f"❌ Not Found → ❌ Error: {error}"
    docker_installed = shutil.which("docker") is not None
    return render_template("prereq.html", results=results, os_family=os_family, docker_installed=docker_installed)


##################ANSIBLE INSTALLATION##################

@app.route("/terraform")
def ansible_info():
    return render_template("terraform_info.html")

@app.route("/terraform/local")
def terraform_local():
    try:
        # Check if Terraform is already installed
        try:
            terraform_version = subprocess.check_output(["terraform", "-version"], stderr=subprocess.STDOUT).decode()
            return render_template("terraform_local.html", result=f"✅ Terraform is already installed:\n{terraform_version}")
        except subprocess.CalledProcessError:
            pass  # not installed yet
        except FileNotFoundError:
            pass  # terraform not found

        # Detect OS
        os_release = subprocess.check_output(["cat", "/etc/os-release"]).decode().lower()

        output_logs = ""

        if "debian" in os_release or "ubuntu" in os_release:
            os_type = "Debian-based (APT)"
            install_cmds = [
                ["sudo", "apt-get", "update"],
                ["sudo", "apt-get", "install", "-y", "gnupg", "software-properties-common", "curl"],
                ["curl", "-fsSL", "https://apt.releases.hashicorp.com/gpg", "|", "gpg", "--dearmor", "-o", "/usr/share/keyrings/hashicorp-archive-keyring.gpg"],
                ["sudo", "apt-add-repository", "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main"],
                ["sudo", "apt-get", "update"],
                ["sudo", "apt-get", "install", "-y", "terraform"]
            ]
        elif "rhel" in os_release or "centos" in os_release or "fedora" in os_release:
            os_type = "RHEL-based (YUM)"
            install_cmds = [
                ["sudo", "yum", "install", "-y", "yum-utils"],
                ["sudo", "yum-config-manager", "--add-repo", "https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo"],
                ["sudo", "yum", "install", "-y", "terraform"]
            ]
        else:
            return render_template("terraform_local.html", result="❌ Unsupported OS for automatic Terraform installation.")

        output_logs += f"🔍 Detected OS: {os_type}\n"

        for cmd in install_cmds:
            if "|" in cmd:
                # Handle command piping using shell=True
                joined_cmd = ' '.join(cmd)
                process = subprocess.run(joined_cmd, shell=True, check=True, capture_output=True, text=True)
            else:
                process = subprocess.run(cmd, check=True, capture_output=True, text=True)
            output_logs += f"\n$ {' '.join(cmd)}\n{process.stdout}"

        terraform_version = subprocess.check_output(["terraform", "-version"]).decode()
        output_logs += f"\n✅ Terraform Installed Successfully:\n{terraform_version}"

    except subprocess.CalledProcessError as e:
        output_logs = f"❌ Error during installation:\n{e}\n\n{e.stderr if hasattr(e, 'stderr') else ''}"
    except Exception as ex:
        output_logs = f"⚠️ Unexpected error: {str(ex)}"

    return render_template("terraform_local.html", result=output_logs)








####################terraform basics ###########################################


import os
import subprocess
from flask import Flask, render_template, request



@app.route("/terraform/local/tutorials", methods=["GET"])
def terraform_tutorials():
    try:
        modules = sorted(os.listdir(TERRAFORM_BASE))
        return render_template("tf_tutorials.html", modules=modules)
    except Exception as e:
        return f"<pre>❌ Error loading tutorials: {str(e)}</pre>"


TERRAFORM_BASE = os.path.abspath("terraform")



@app.route("/terraform/local/tutorials/<module>/", methods=["GET"])
def preview_module(module):
    module_path = os.path.join(TERRAFORM_BASE, module)

    try:
        main_tf = os.path.join(module_path, "main.tf")
        tfvars = os.path.join(module_path, "terraform.tfvars")

        if not os.path.exists(main_tf):
            return f"<pre>❌ main.tf not found in {module}</pre>"

        main_content = open(main_tf).read()
        var_content = open(tfvars).read() if os.path.exists(tfvars) else "No terraform.tfvars found."

        return render_template("tf_preview.html", module=module, main_tf=main_content, tfvars=var_content)

    except Exception as e:
        return f"<pre>❌ Error: {str(e)}</pre>"


@app.route("/terraform/local/tutorials/<module>/<command>", methods=["POST"])
def run_terraform_command(module, command):
    module_path = os.path.join(TERRAFORM_BASE, module)

    if not os.path.isdir(module_path):
        return f"<pre>❌ Module not found: {module_path}</pre>", 404

    os.chdir(module_path)

    # Whitelisted terraform commands
    valid_commands = {
        "plan": ["terraform", "plan"],
        "apply": ["terraform", "apply", "-auto-approve"],
        "destroy": ["terraform", "destroy", "-auto-approve"],
        "show": ["terraform", "show"],
        "output": ["terraform", "output"],
        "validate": ["terraform", "validate"],
        "fmt": ["terraform", "fmt"]
    }

    if command not in valid_commands:
        return f"<pre>❌ Unsupported command: {command}</pre>", 400

    try:
        # Always init first
        subprocess.run(["terraform", "init", "-input=false"], check=True, capture_output=True, text=True)

        # Run the actual command
        result = subprocess.run(valid_commands[command], capture_output=True, text=True)

        return render_template("tf_output.html",
                               command=f"{command}: {module}",
                               stdout=result.stdout,
                               stderr=result.stderr)

    except subprocess.CalledProcessError as e:
        return render_template("error.html", command=command, stderr=e.stderr), 500




#########################################################################################
# terraorm backend




@app.route('/terraform/local/tutorials/remote_backend/')
def remote_backend():
    return render_template('remote_backend.html')


def is_port_open(host, port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        return sock.connect_ex((host, port)) == 0



@app.route('/start_minio')
def start_minio():
    client = docker.from_env()
    volume_name = "minio_data"
    minio_port = 9990
    console_port = 9991

    # Check if ports are already used
    if is_port_open('localhost', minio_port) or is_port_open('localhost', console_port):
        return render_template("start_minio.html",
            emoji="⚠️",
            title="Ports in Use",
            message=f"Ports {minio_port} or {console_port} are already in use. Please stop the conflicting service or use different ports.",
            links=[]
        )

    # Check if MinIO container is already running
    try:
        container = client.containers.get("minio")
        if container.status == "running":
            return render_template("start_minio.html",
                emoji="✅",
                title="MinIO is already running",
                message="Access it using the links below.",
                links=[
                    {"label": "📦 MinIO Service", "url": f"http://localhost:{minio_port}"},
                    {"label": "🛠️ MinIO Console", "url": f"http://localhost:{console_port}"}
                ]
            )
    except docker.errors.NotFound:
        pass

    # Create volume if not present
    try:
        client.volumes.get(volume_name)
    except docker.errors.NotFound:
        client.volumes.create(name=volume_name)

    # Run MinIO container
    try:
        client.containers.run(
            "minio/minio",
            "server /data --console-address :9001",
            name="minio",
            ports={"9000/tcp": minio_port, "9001/tcp": console_port},
            environment={
                "MINIO_ROOT_USER": "minioadmin",
                "MINIO_ROOT_PASSWORD": "minioadmin"
            },
            volumes={volume_name: {"bind": "/data", "mode": "rw"}},
            detach=True
        )

        return render_template("start_minio.html",
            emoji="🚀",
            title="MinIO Started",
            message="MinIO was successfully launched with persistent volume.",
            links=[
                {"label": "📦 MinIO Endpoint", "url": f"http://localhost:{minio_port}"},
                {"label": "🛠️ MinIO Console", "url": f"http://localhost:{console_port}"}
            ]
        )

    except docker.errors.APIError as e:
        return render_template("start_minio.html",
            emoji="❌",
            title="Docker Error",
            message=e.explanation,
            links=[]
        )



######################################## playbooks #################################################



PLAYBOOKS_DIR = "./playbooks"
INVENTORY_FILE = os.path.join(PLAYBOOKS_DIR, "./../inventory.ini")

@app.route('/ansible/local/playbooks', methods=['GET', 'POST'])
def ansible_local_playbooks():
    # Playbook run
    if request.method == 'POST':
        selected_playbook = request.form.get('playbook')
        if selected_playbook:
            playbook_path = os.path.join(PLAYBOOKS_DIR, selected_playbook)
            try:
                result = subprocess.run(
                    ['ansible-playbook', '-i', INVENTORY_FILE, playbook_path],
                    check=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True
                )
                return render_template("playbook_output.html", output=result.stdout)
            except subprocess.CalledProcessError as e:
                return render_template("playbook_output.html", output=e.stdout)

    # List playbooks
    playbooks = [f for f in os.listdir(PLAYBOOKS_DIR)
                 if f.endswith(('.yml', '.yaml')) and os.path.isfile(os.path.join(PLAYBOOKS_DIR, f))]
    
    return render_template('playbooks_list.html', playbooks=playbooks)


from flask import Flask, render_template, request, redirect, url_for
from werkzeug.utils import secure_filename
import os
import subprocess

@app.route('/ansible/local/playbooks/view/<playbook_name>')
def view_playbook(playbook_name):
    safe_name = secure_filename(playbook_name)
    playbook_path = os.path.join(PLAYBOOKS_DIR, safe_name)

    if not os.path.exists(playbook_path):
        return f"<pre>Playbook not found: {safe_name}</pre>"

    try:
        with open(playbook_path, 'r') as f:
            content = f.read()
        return render_template('playbook_view.html', playbook_name=safe_name, content=content)
    except Exception as e:
        return f"<pre>Could not read playbook: {e}</pre>"



######################################## playbooks end  #################################################



######################### advanced playbook start #####################################################



ADVANCED_PLAYBOOKS_DIR = "./advanced-playbooks"
ADV_PLAYBOOK_FILE = os.path.join(ADVANCED_PLAYBOOKS_DIR, "playbook.yml")
ADV_INVENTORY_FILE = os.path.join(ADVANCED_PLAYBOOKS_DIR, "./../inventory.ini")
ADV_OUTPUT_FILE = os.path.join(ADVANCED_PLAYBOOKS_DIR, "advanced_playbook_output.yml")
ADV_README_FILE = os.path.join(ADVANCED_PLAYBOOKS_DIR, "README.md")


def get_directory_tree(path):
    tree = ""
    for root, dirs, files in os.walk(path):
        level = root.replace(path, "").count(os.sep)
        indent = "│   " * level + "├── "
        tree += f"{indent}{os.path.basename(root)}/\n"
        subindent = "│   " * (level + 1) + "├── "
        for f in files:
            tree += f"{subindent}{f}\n"
    return tree


@app.route('/ansible/local/playbooks/advanced-playbooks', methods=['GET', 'POST'])
def view_advanced_playbook():
    output = None
    dir_tree = None
    readme = None

    if request.method == 'POST':
        if 'run_playbook' in request.form:
            try:
                result = subprocess.run(
                    ['ansible-playbook', '-i', ADV_INVENTORY_FILE, ADV_PLAYBOOK_FILE],
                   
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    check=True
                )
                with open(ADV_OUTPUT_FILE, 'w') as f:
                    f.write(result.stdout)
                output = result.stdout
            except subprocess.CalledProcessError as e:
                output = e.stdout

        elif 'show_tree' in request.form:
            dir_tree = get_directory_tree(ADVANCED_PLAYBOOKS_DIR)

        elif 'show_readme' in request.form and os.path.exists(ADV_README_FILE):
            with open(ADV_README_FILE, 'r') as f:
                readme = f.read()

    return render_template(
        'advanced_playbook_output.html',
        dir_tree=dir_tree,
        readme=readme,
        output=output
    )

######################### advanced playbook end #####################################################

#####################################################################################################
#ansible roles start


ROLES_DIR = "./roles"
INVENTORY_FILE = "./inventory.ini"
ROLE_PLAYBOOK_FILE = "./roles/role_playbook.yml"

def get_directory_tree(path):
    tree = ""
    for root, dirs, files in os.walk(path):
        level = root.replace(path, "").count(os.sep)
        indent = "│   " * level + "├── "
        tree += f"{indent}{os.path.basename(root)}/\n"
        subindent = "│   " * (level + 1) + "├── "
        for f in files:
            tree += f"{subindent}{f}\n"
    return tree

@app.route('/ansible/local/playbooks/roles', methods=['GET', 'POST'])
def manage_roles():
    message = None
    output = None
    dir_tree = None
    readme = None

    if request.method == 'POST':
        if 'create_role' in request.form:
            role_name = request.form.get('role_name')
            if role_name:
                subprocess.run(['ansible-galaxy', 'init', os.path.join(ROLES_DIR, role_name)])
                message = f"✅ Role '{role_name}' created."
            else:
                message = "⚠️ Role name required."

        elif 'install_role' in request.form:
            role_name = request.form.get('role_name')
            if role_name:
                subprocess.run(['ansible-galaxy', 'install', role_name, '-p', ROLES_DIR])
                message = f"✅ Role '{role_name}' installed from Galaxy."
            else:
                message = "⚠️ Role name required."

        elif 'show_tree' in request.form:
            dir_tree = get_directory_tree(ROLES_DIR)

        elif 'show_readme' in request.form:
            role_name = request.form.get('role_name')
            readme_path = os.path.join(ROLES_DIR, role_name, 'README.md')
            if os.path.exists(readme_path):
                with open(readme_path) as f:
                    readme = f.read()
            else:
                readme = "README.md not found."

        elif 'run_role' in request.form:
            role_name = request.form.get('role_name')
            if role_name:
                # Create a temporary playbook using the role
                with open(ROLE_PLAYBOOK_FILE, 'w') as f:
                    f.write(f"""---
- hosts: all
  become: true
  roles:
    - {role_name}
""")
                try:
                    result = subprocess.run(
                        ['ansible-playbook', '-i', INVENTORY_FILE, ROLE_PLAYBOOK_FILE],
                        stdout=subprocess.PIPE,
                        stderr=subprocess.STDOUT,
                        text=True,
                        check=True
                    )
                    output = result.stdout
                except subprocess.CalledProcessError as e:
                    output = e.stdout
            else:
                message = "⚠️ Role name required to run playbook."

    return render_template(
        'role_manager.html',
        message=message,
        dir_tree=dir_tree,
        readme=readme,
        output=output
    )


################################### ansible role end #############################################################

########################## Ansible Tower ##########################################################


@app.route('/ansible/local/tower', methods=['GET', 'POST'])
def ansible_tower():
    output = None
    install_requested = False
    awx_cloned = os.path.exists('./awx')

    if request.method == 'POST':
        install_requested = True

        try:
            distro = platform.freedesktop_os_release().get("ID", "").lower()
            
            # 1. Install Docker if not present
            docker_check = subprocess.run(['which', 'docker'], stdout=subprocess.PIPE, text=True)
            if not docker_check.stdout.strip():
                if "ubuntu" in distro or "debian" in distro:
                    subprocess.run(['sudo', 'apt', 'update'])
                    subprocess.run(['sudo', 'apt', 'install', '-y', 'docker.io'])
                elif "centos" in distro or "rhel" in distro or "rocky" in distro or "fedora" in distro:
                    subprocess.run(['sudo', 'yum', 'install', '-y', 'docker'])
                else:
                    raise Exception(f"Unsupported distro: {distro}. Please install Docker manually.")

            # 2. Install docker-compose if not present
            compose_check = subprocess.run(['which', 'docker-compose'], stdout=subprocess.PIPE, text=True)
            if not compose_check.stdout.strip():
                subprocess.run([
                    'sudo', 'curl', '-SL',
                    'https://github.com/docker/compose/releases/download/v2.32.0/docker-compose-linux-x86_64',
                    '-o', '/usr/local/bin/docker-compose'
                ])
                subprocess.run(['sudo', 'chmod', '+x', '/usr/local/bin/docker-compose'])
                subprocess.run(['sudo', 'ln', '-sf', '/usr/local/bin/docker-compose', '/usr/bin/docker-compose'])

            # 3. Clone AWX repo and setup
            if not awx_cloned:
                subprocess.run(['git', 'clone', 'https://github.com/ansible/awx.git'])
                os.chdir('./awx')               
                os.chdir('./tools/docker-compose')
                subprocess.run(['cp', '.env.example', '.env'])

            # 4. Start AWX via docker-compose
            os.chdir('./awx/tools/docker-compose')
            subprocess.run(['docker-compose', 'up', '-d'])

            output = "✅ AWX (Ansible Tower) installed and started successfully!"
        except Exception as e:
            output = f"❌ Error during AWX setup: {str(e)}"

    return render_template(
        'ansible_tower.html',
        output=output,
        install_requested=install_requested
    )




########################## Ansible Tower  end ##########################################################
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003, debug=True)
