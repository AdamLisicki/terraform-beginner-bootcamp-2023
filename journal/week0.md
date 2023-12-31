# Terraform Beginner Bootcamp 2023 - Week 0

- [Semantic Versioning](#semantic-versioning-mage)
- [Install the Terraform CLI](#install-the-terraform-cli)
  - [Considerations with Terraform CLI changes](#considerations-with-terraform-cli-changes)
  - [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  - [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    - [Shebang Considerations](#shebang-considerations)
    - [Execution Considerations](#execution-considerations)
    - [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle (Before, Init, Command)](#gitpod-lifecycle-before-init-command)
- [Working Env Vars](#working-env-vars)
  - [env command](#env-command)
  - [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
  - [Printing Vars](#printing-vars)
  - [Scoping of Env Vars](#scoping-of-env-vars)
  - [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  - [Terraform Registry](#terraform-registry)
  - [Terraform Console](#terraform-console)
    - [Terraform Init](#terraform-init)
    - [Terraform Plan](#terraform-plan)
    - [Terraform Apply](#terraform-apply)
    - [Terraform Destroy](#terraform-destroy)
    - [Terraform Lock Files](#terraform-lock-files)
    - [Terraform State Files](#terraform-state-files)
    - [Terraform Directory](#terraform-directory)
- [Terraform Cloud](#terraform-cloud)
  - [Projects and Workspaces](#projects-and-workspaces)
  - [Migrate State To Terraform Cloud](#migrate-state-to-terraform-cloud)
  - [Issues with Terraform Cloud Login and Gitpod](#issues-with-terraform-cloud-login-and-gitpod)







## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install.


[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against Ubuntu.
Please consider checking your Linux Distribution and change accordingly to distribution needs.

[How To Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:

```
$ cat /etc/os-release 

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprecation issues we noticed that bash scripts steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI. 

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This allow us an easier to debug and execute manually Terraform CLI install.
- This will allow better portability for other projects that need to install Terraform CLI.


#### Shebang Considerations

A Shebang (pronounced Sha-bang) tells the bash script what program that will interpret the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- for portability for different OS distributions
- will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.  

eg. `source ./bin/install_terraform_cli`
 
#### Linux Permissions Considerations

In order to make our bash script executable we need to change Linux permissions for the file to be executable at user mode.

```sh
$ chmod u+x ./bin/install_terraform_cli
```

alternatively:

```sh
$ chmod 744 ./bin/install_terraform_cli
```
https://en.wikipedia.org/wiki/Chmod

## Gitpod Lifecycle (Before, Init, Command)

We need to be careful when we using Init because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

## Working Env Vars

### env command

We can list out all Environment Variables (Env Vars) using the `env` command

We can filter specific env vars using grep eg. `env | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world'`

In the terminal we unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
$ HELLO='world' ./bin/print_message
```
Within a bash script we can set env var without writing export eg.

```bash
#!/usr/bin/env bash
 
HELLO='world'
 
echo $HELLO
```
### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

### Scoping of Env Vars

When you open new bash terminals in VSCode it will not be aware of env vars that you have set in another window. 

If you want the Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`


### Persisting Env Vars in Gitpod

We can persist env vars in Gitpod by storing them in Gitpod Secrets Storage.

```sh
$ gp env HELLO='world'
```
All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.

### AWS CLI Installation

AWS CLI is installed for this project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)


We can check if our AWS credentials is configured correctly by running the following AWS CLI command:

```sh
$ aws sts get-caller-identity
```
If it is succesful you should see a json payload return that looks like this:

```json
{
    "UserId": "ABCD1EFGHIJKLMNOPRS2T",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credentials for IAM User in order to use the AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform Registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** are an interfaces to APIs that will allow to create resources in Terraform. 
- **Modules** are a way to make large amount of code modular, portable and sharable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`


#### Terraform Init

`terraform init`

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

[Terraform Init Command Documentation](https://developer.hashicorp.com/terraform/cli/commands/init)

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

[Terraform Plan Command Documentation](https://developer.hashicorp.com/terraform/cli/commands/plan)

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be execute by terraform. Apply should prompt us yes or no.

If we want to automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto-approve`

[Terraform Apply Command Documentation](https://developer.hashicorp.com/terraform/cli/commands/apply)

#### Terraform Destroy

`terraform destroy`

This will destroy resources.

You can also use the auto approve flag to skip the approve prompt eg. `terraform destroy --auto-approve`

[Terraform Destory Command Documentation](https://developer.hashicorp.com/terraform/cli/commands/destroy)

#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers and modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VCS) eg. GitHub

#### Terraform State Files

`.terraform.tfstate` contains information about current state of your infrastructure.

The Terraform State File **should <u>not</u> be committed** to your VCS.

This file can contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of Terraform providers.

## Terraform Cloud

### Projects and Workspaces

- **Workspace**: A workspace contains everything Terraform needs to manage a given collection of infrastructure, and separate workspaces function like completely separate working directories.
- **Project**: Projects let you organize your workspaces into groups.

Terraform Cloud has three workflows for managing Terraform runs:
- UI/VCS-driven run workflow - Workspaces are triggered and directly linked to a VCS repository.
- API-driven run workflow - Triggered by an API call.
- CLI-driven run workflow - uses Terraform's standard CLI tools to execute runs in Terraform Cloud

In this project we use CLI Driven run workflow.

### Migrate State To Terraform Cloud

Run `terraform login` and type `yes` and hit `Enter`

```sh
$ terraform login
Terraform will request an API token for app.terraform.io using your browser.

If login is successful, Terraform will store the token in plain text in
the following file for use by subsequent commands:
    /home/gitpod/.terraform.d/credentials.tfrc.json

Do you want to proceed?
  Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

Then go to `https://app.terraform.io/app/settings/tokens?source=terraform-login` and generate a token.

```sh
---------------------------------------------------------------------------------

Terraform must now open a web browser to the tokens page for app.terraform.io.

If a browser does not open this automatically, open the following URL to proceed:
    https://app.terraform.io/app/settings/tokens?source=terraform-login


---------------------------------------------------------------------------------
```

Copy and paste your token into console.

```sh

Generate a token using your browser, and copy-paste it into this prompt.

Terraform will store the token in plain text in the following file
for use by subsequent commands:
    /home/gitpod/.terraform.d/credentials.tfrc.json

Token for app.terraform.io:
  Enter a value: 

```

Token has been successfully retrieved and saved on our machine.

```sh
Retrieved token for user adamlisicki


---------------------------------------------------------------------------------

                                          -                                
                                          -----                           -
                                          ---------                      --
                                          ---------  -                -----
                                           ---------  ------        -------
                                             -------  ---------  ----------
                                                ----  ---------- ----------
                                                  --  ---------- ----------
   Welcome to Terraform Cloud!                     -  ---------- -------
                                                      ---  ----- ---
   Documentation: terraform.io/docs/cloud             --------   -
                                                      ----------
                                                      ----------
                                                       ---------
                                                           -----
                                                               -


   New to TFC? Follow these steps to instantly apply an example configuration:

   $ git clone https://github.com/hashicorp/tfc-getting-started.git
   $ cd tfc-getting-started
   $ scripts/setup.sh

```

Add to our `main.tf` file in `terraform` section below lines.

```tf
terraform {
  cloud {
    organization = "ORGANIZATION_NAME"

    workspaces {
      name = "WORKSPACE_NAME"
    }
}
```

Then run `terraform init` command and if you have a state file in your directory then you'll be asked to enter `yes` or `no` if you want to migrate your existing state to Terraform Cloud.

```sh
$ terraform init

Initializing Terraform Cloud...
Do you wish to proceed?
  As part of migrating to Terraform Cloud, Terraform can optionally copy your
  current workspace state to the configured Terraform Cloud workspace.
  
  Answer "yes" to copy the latest state snapshot to the configured
  Terraform Cloud workspace.
  
  Answer "no" to ignore the existing state and just activate the configured
  Terraform Cloud workspace with its existing state, if any.
  
  Should Terraform migrate your existing state?

  Enter a value: yes
```

After that Terraform Cloud has been initialized and the state has been migrated. 

```sh
Initializing provider plugins...
- Reusing previous version of hashicorp/random from the dependency lock file
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v5.17.0
- Using previously-installed hashicorp/random v3.5.1

Terraform Cloud has been successfully initialized!

You may now begin working with Terraform Cloud. Try running "terraform plan" to
see any changes that are required for your infrastructure.

If you ever set or change modules or Terraform Settings, run "terraform init"
again to reinitialize your working directory.
```

### Issues with Terraform Cloud Login and Gitpod

When attempting to run terraform login it will launch bash a wiswig view to generate a token. However it does not work expected in Gitpod VsCode in the browser.

The workaround is manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create open the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```
We have automated this workaround with the following bash script [bin/generate_tfrc_credentials](./bin/generate_tfrc_credentials)