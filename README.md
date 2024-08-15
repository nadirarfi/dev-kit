# dev-kit

Welcome to my personal development environment setup! This is just a collection of scripts and configurations that I use to quickly set up my dev environment on Ubuntu (especially useful for WSL). It takes care of installing the packages I need, sets up Zsh as my go-to shell, and installs and configures `asdf` for managing various tool versions via a simple YAML config file.

## What's Included

### 1. Essential Ubuntu Packages

- These scripts will automatically install a bunch of essential packages I use regularly. This way, I don't have to worry about missing tools when starting a new project or setting up a fresh system.

### 2. Zsh Setup

- I prefer using Zsh as my default shell, so this script will install Zsh if it’s not already installed and make it the default.
- If Zsh is already there, it skips the installation and just sets things up the way I like, including adding some cool plugins and themes like Oh My Zsh.

### 3. `asdf` Version Manager

- I use `asdf` to manage multiple versions of programming languages and other tools. This script installs `asdf` and sets it up for my user.

### 4. `asdf` Plugins & Versions

- I've got a `config.yaml` file where I list the programming languages and tool versions I need for my projects.
- The script reads this file and automatically installs the required `asdf` plugins and versions. This way, my environment is always set up exactly how I need it.

## What You Need Before You Start

Before you run these scripts, make sure:

- You’re on a compatible version of Ubuntu (I'm usually on the latest one).
- You’ve got `curl` and `git` installed. If not, you can easily install them with:

  ```bash
  sudo apt update && sudo apt install curl git -y
  ```

## How to Set It Up

1. **Clone This Repo**:
   Just grab the repository and navigate into it:

   ```bash
   git clone https://github.com/nadirarfi/dev-kit.git
   cd dev-kit
   ```

2. **Run the Setup Script**:
   Fire up the main setup script. This will handle everything from installing packages, setting up Zsh, to configuring `asdf`:

   ```bash
   bash setup.sh
   ```

3. **Tweak the YAML Config**:

   - If you need to adjust the programming languages or versions, just edit the `config.yaml` file.
   - The script will pick up the changes and install whatever you need.

4. **Apply Zsh as Default**:
   - Once everything is set up, you might need to log out and log back in to make sure Zsh is your default shell.

## Example `config.yaml`

Here’s an example of what my `config.yaml` might look like:

```yaml
asdf:
  tools:
    - name: python
      git: https://github.com/asdf-community/asdf-python
      versions:
        - 3.8.10
        - 3.9.6
        - 3.11.0
        - 3.11.6
      default: 3.11.0
    - name: terraform
      git: https://github.com/asdf-community/asdf-hashicorp
      versions:
        - 1.5.6
      default: 1.5.6
    - name: terragrunt
      git: https://github.com/ohmer/asdf-terragrunt
      versions:
        - 0.50.4
      default: 0.50.4
    - name: kubectl
      git: https://github.com/asdf-community/asdf-kubectl
      versions:
        - 1.28.1
      default: 1.28.1
    - name: k9s
      git: https://github.com/looztra/asdf-k9s
      versions:
        - 0.27.0
      default: 0.27.0

ubuntu:
  apt:
    packages:
      - yq
      - unzip
      - xclip
      - jq
      - wget
      - curl
      - make
      - build-essential
      - libssl-dev
      - zlib1g-dev
      - libbz2-dev
      - libreadline-dev
      - libsqlite3-dev
      - llvm
      - libncursesw5-dev
      - xz-utils
      - tk-dev
      - libxml2-dev
      - libxmlsec1-dev
      - libffi-dev
      - liblzma-dev
```

5. **Setup SSH access to Github**:
- This script also automates the creation and setup of an SSH key for GitHub.
- When generating the SSH key, make sure to export your personal address before running the script. 
  ```bash
  export EMAIL_ADDRESS="example@metallica.com"
  ```

## Enjoy!

Feel free to tweak it, fork it, or just use it as-is. This setup works great for me, and I hope it helps you get up and running faster too!
