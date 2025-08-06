# Cloud1

Automated deployment of a WordPress website on a remote server provided by a cloud provider.

## Infrastructure

Each of this service will have it's container:

<ul>
  <li>
    <img src="https://www.svgrepo.com/show/373848/mysql.svg" alt="MySQL Logo" width="20px" /> MySQL
  </li>
  <li>
    <img src="https://www.svgrepo.com/show/473751/phpmyadmin.svg" alt="PhpMyAdmin Logo" width="20px" /> PHPmyadmin
  </li>
  <li>
    <img src="https://www.svgrepo.com/show/354115/nginx.svg" alt="Nginx Logo" width="20px" /> Nginx
  </li>
  <li>
    <img src="https://www.svgrepo.com/show/475696/wordpress-color.svg" alt="WordPress Logo" width="20px" /> WordPress
  </li>
</ul>

Technologies used in this project:

<ul>
  <li>
    <img src="https://www.svgrepo.com/show/373429/ansible.svg" alt="Ansible Logo" width="20px" /> Ansible
  </li>
  <li>
    <img src="https://www.svgrepo.com/show/331370/docker.svg" alt="Docker Logo" width="20px" /> Docker
  </li>
</ul>

## Architecture

```mermaid
---
title: Cloud1 Architecture
config:
  layout: dagre
---
flowchart TB
    WorldWideWeb@{ shape: dbl-circ, label: "🌐<br>World Wide<br>Web" }
    subgraph ControlMachine["🖥️ Control Machine"]
      subgraph AnsibleController["Ansible Controller"]
        InvFile@{ shape: doc, label: "Inventory File" }
        PLY@{ shape: doc, label: "Playbook Files" }
      end
    end
    subgraph Cloud["☁️ Cloud Instance"]
      sshAccess@{ shape: terminal, label: "SSH Access" }
      subgraph DockerEngine
        subgraph DatabaseContainer["Database Container"]
            DB@{ shape: database, label: "MySQL Database" }
        end
        subgraph PMAContainer["PHPMyAdmin Container"]
            PMA@{ shape: terminal, label: "PHPMyAdmin" }
        end
        subgraph ReverseProxyContainer["Reverse Proxy Container"]
            RVP@{ shape: procs, label: "Reverse Proxy<br>Nginx" }
        end
        subgraph WebServer1Container["Web Server 1 Container"]
            WP1@{ shape: loop-limit, label: "Apache WordPress Application" }
        end
      end
    end

    WorldWideWeb w@-->|443/HTTPS| RVP
    AnsibleController assh@-->|22/SSH| sshAccess
    sshAccess arvp@--> ReverseProxyContainer
    sshAccess aws1@--> WebServer1Container
    sshAccess adb@--> DatabaseContainer
    sshAccess apma@--> PMAContainer
    RVP rvp1@-->|/wordpress<br>80| WP1
    RVP rvp2@-->|/myadmin<br>8081| PMA
    WP1 -->|3306| DB
    PMA -->|3306| DB

    classDef files fill: #fadc89ff,color: #616161ff,stroke: #b4befe
    classDef database fill: #7575bdff,color: #ffffffff,stroke: #45475a
    classDef web fill: #88e68dff,color: #575757ff,stroke: #45475a
    classDef ansible fill: #89b4fa,color: #1e1e2e,stroke: #b4befe
    classDef webContainer fill: #a6e3a17c,color: #1e1e2e,stroke: #94e2d5
    classDef docker fill: #dff8ffff,color: #1e1e2e,stroke: #dff8ffff
    classDef web-anim stroke-dasharray: 9,5, stroke-dashoffset: 900, stroke-width: 2, stroke: #489e5dff, animation: dash 25s linear infinite;
    classDef ansible-anim stroke-dasharray: 5,5, stroke-dashoffset: 300, stroke-width: 2, stroke: #e0b25cff, animation: dash 25s linear infinite;

    class rvp1,rvp2,w web-anim
    class assh,arvp,aws1,adb,apma ansible-anim
    class InvFile,PLY files
    class DB,PMA database
    class RVP,WP1,WP2,WorldWideWeb web
    class AnsibleController ansible
    class WebServer1Container,WebServer2Container,ReverseProxyContainer webContainer
    class DockerEngine docker
```

<img src="https://www.svgrepo.com/show/373429/ansible.svg" alt="Ansible Logo" align="right" width="100px" />

## [Ansible](https://docs.ansible.com/)

Ansible is a powerful open-source automation tool that can be used to deploy and manage applications and services.

```mermaid
flowchart LR
    subgraph Control["Control Node"]
        ANS["Ansible Engine"]
        PB["Playbook YAML"]
        INV["Inventory File"]
    end

    subgraph Managed["Managed Nodes"]
        MOD["Ansible Modules"]
        RES["System Resources"]
    end

    ANS -->|"Reads"| PB
    ANS -->|"References"| INV
    ANS -->|"SSH Connection"| MOD
    MOD -->|"Configures"| RES

    classDef control fill:#1976d2,color:#ffffff,stroke:#0d47a1
    classDef managed fill:#388e3c,color:#ffffff,stroke:#1b5e20

    class ANS,PB,INV control
    class MOD,RES managed
```

Ansible operates on a control node that manages one or more managed nodes. The control node runs the Ansible engine, which reads playbooks and inventories to execute tasks on the managed nodes.

### Key Components

- **Ansible Engine**: The core component that executes tasks defined in playbooks.
- **Playbooks**: YAML files that define the tasks to be executed on the managed nodes.
- **Inventory**: A file that lists the managed nodes and their connection details.
- **Ansible Modules**: Reusable scripts that perform specific tasks on the managed nodes.
- **Managed Nodes**: The servers or devices that Ansible manages.

### Inventory and Playbooks

Inventories allow you to define the managed nodes and their connection details. Ansible uses these inventories to know which nodes to target for configuration management.

Roles are a way to organize playbooks and tasks into reusable components. They can be shared and reused across different projects.

#### Example Inventory

```yaml
all:
  hosts:
    node1:
      ansible_host: node1.example.com
    node2:
      ansible_host: node2.example.com
  vars:
    ansible_user: user
```

Playbooks are YAML files that define the tasks to be executed on the managed nodes.

#### Example Playbook

```yaml
- name: MyFirstPlay
  hosts: all
  tasks:
    - name: Ping all nodes
      ansible.builtin.ping:

    - name: Print message
      ansible.builtin.debug:
        msg: "Hello from {{ inventory_hostname }}"
```

Become is used to run tasks with elevated privileges, such as root access. This is often necessary for tasks that require administrative permissions. You can specify the user to become with the `become_user` directive, like so:

```yaml
- name: Install a package with sudo
  ansible.builtin.yum:
    name: httpd
    state: present
  become: true
  become_user: root
```

#### Tags

Tags allow you to run specific parts of a playbook without executing the entire playbook. This is useful for testing or when you only want to apply certain changes.

```yaml
- name: Install a package
  ansible.builtin.yum:
    name: httpd
    state: present
  tags: install

- name: another task
  ansible.builtin.debug:
    msg: "This is another task"
  tags: other
```

When running the playbook, you can specify the tag to execute only that part:

```bash
ansible-playbook playbook.yml --tags install
# Will only run tasks with the 'install' tag, skipping others.
```

#### Roles

[Ansible Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html) are a way to organize playbooks and tasks into reusable components. They allow you to group related tasks, variables, and files together, making it easier to manage complex configurations.

### Templates

Ansible supports Jinja2 templating, allowing you to create dynamic configurations based on variables and facts collected from the managed nodes. This is useful for generating configuration files or scripts that need to be customized for each node.

### Modules

Ansible modules are the building blocks of Ansible tasks. They are reusable scripts that perform specific actions on the managed nodes, such as installing packages, managing files, or executing commands.

[Ansible Docker Compose Module](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_compose_v2_module.html)

### Parallel Execution

Ansible can execute tasks in parallel across multiple managed nodes, making it efficient for large-scale deployments. This is achieved through the use of SSH connections and the ability to run tasks concurrently.

[Ansible Parallelism](https://thelinuxcode.com/ansible-parallelism/)

## Multipass

Multipass is a lightweight VM manager that allows you to create and manage virtual machines easily. It is particularly useful for testing and development environments.

### Usage

To create a new VM with Multipass, you can use the following command:

```bash
multipass launch --name my-vm
```

To list all running VMs, use:

```bash
multipass list
```

To access a specific VM, you can use:

```bash
multipass shell my-vm
```

To delete a VM, use:

```bash
multipass delete my-vm
```
