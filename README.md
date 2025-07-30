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
    WorldWideWeb@{ shape: dbl-circ, label: "World Wide Web" }
    subgraph Cloud["Cloud Instance"]
      subgraph DockerEngine
        subgraph AnsibleContainer["Ansible Container"]
            InvFile@{ shape: doc, label: "Inventory File" }
            PLY@{ shape: doc, label: "Playbook Files" }
        end
        subgraph DatabaseContainer["Database Container"]
            DB@{ shape: database, label: "MySQL Database" }
        end
        subgraph PMAContainer["PHPMyAdmin Container"]
            PMA@{ shape: terminal, label: "PHPMyAdmin" }
        end
        subgraph LoadBalancerContainer["Load Balancer Container"]
            LB@{ shape: procs, label: "Load Balancer<br>Nginx" }
        end
        subgraph WebServer1Container["Web Server 1 Container"]
            WP1@{ shape: loop-limit, label: "Apache WordPress Application" }
        end
        subgraph WebServer2Container["Web Server 2 Container"]
            WP2@{ shape: loop-limit, label: "Apache WordPress Application" }
        end
      end
    end

    WorldWideWeb w@-->|443/HTTPS| LB
    AnsibleContainer alb@--> LB
    AnsibleContainer aws1@--> WebServer1Container
    AnsibleContainer aws2@--> WebServer2Container
    AnsibleContainer adb@--> DatabaseContainer
    AnsibleContainer apma@--> PMAContainer
    LB lb1@-->|Routes Traffic| WP1
    LB lb2@-->|Routes Traffic| WP2
    WP1 --> DB
    WP2 --> DB
    PMA --> DB

    classDef files fill: #fadc89ff,color: #616161ff,stroke: #b4befe
    classDef database fill: #7575bdff,color: #ffffffff,stroke: #45475a
    classDef web fill: #88e68dff,color: #575757ff,stroke: #45475a
    classDef ansible fill: #89b4fa,color: #1e1e2e,stroke: #b4befe
    classDef webContainer fill: #a6e3a17c,color: #1e1e2e,stroke: #94e2d5
    classDef docker fill: #dff8ffff,color: #1e1e2e,stroke: #dff8ffff
    classDef web-anim stroke-dasharray: 9,5, stroke-dashoffset: 900, stroke-width: 2, stroke: #489e5dff, animation: dash 25s linear infinite;
    classDef ansible-anim stroke-dasharray: 5,5, stroke-dashoffset: 300, stroke-width: 2, stroke: #e0b25cff, animation: dash 25s linear infinite;

    class lb1,lb2,w web-anim
    class alb,aws1,aws2,adb,apma ansible-anim
    class InvFile,PLY files
    class DB,PMA database
    class LB,WP1,WP2,WorldWideWeb web
    class AnsibleContainer ansible
    class WebServer1Container,WebServer2Container,LoadBalancerContainer webContainer
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

### Example Inventory

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
