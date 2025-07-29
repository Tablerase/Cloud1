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

## Installation

1. Clone the repository:

   ```bash
   git clone
   ```

2. Navigate to the project directory:

   ```bash
   cd 42_Cloud1
   ```

3. Install the required dependencies:

   - If you are using a virtual environment, activate it first:

     ```bash
     python3 -m venv .venv
     ```

     ```bash
     source .venv/bin/activate
     ```

   - Then install the dependencies using pip:

     ```bash
     pip install -r requirements.txt
     ```

4. Create a `.env` file in the root directory and set the required environment variables:
   ```bash
   cp .env.example .env
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

Inventories allow you to define the managed nodes and their connection details. Ansible uses these inventories to know which nodes to target for configuration management.

Playbooks are YAML files that define the tasks to be executed on the managed nodes.
