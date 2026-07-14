# Magi cluster tutorial


## Contents

Jump to a section:

- [Overview](#Overview)
- [Accessing the cluster](#Accessing-the-cluster)
- [Accessing data](#Accessing-data)
- [File management](#File-management)
- [Session management](#Session-management)
- [Software](#Software)
- [Magi versus Discovery](#Magi-versus-Discovery)

## Overview

The data described in this repository is hosted on the Magi cluster. The Magi cluster is a simple network-of-workstations style Beowulf cluster of commodity Mac hardware maintained by Prof. Kylie Ariel Bemis for the Vitek Lab in the Khoury College of Computer Sciences at Northeastern University. Cluster access requires lab membership, PI authorization, and a Khoury login.



## Accessing the cluster

Currently, the following nodes are available to `viteklab` members:

- `Magi-01` : compute node (M2 Ultra / 16 p-cores / 8 e-cores / 192 GB)

- `Magi-02` : compute node (M2 Ultra / 16 p-cores / 8 e-cores / 192 GB)

Please contact the Magi cluster maintainer for `viteklab` credentials.


### SSH setup

It is strongly recommended to set up SSH key-based authentication for the intermediate Khoury login servers.

If you have not already set up SSH keys, this can be done with the following steps:

#### 1. Generate a private key on your local machine:

Check if you already have a key:

`ls ~/.ssh`

If you see a pair of "id" files with one of them ending in ".pub" (e.g., "id_ed25519" and "id_ed25519.pub"), then you can skip this step.

If you don't already have a key, create one:

`ssh-keygen -C "<your-name>@<host-name>"`

Accept the defaults. The comment (`-C`) helps identify which key is associated with which user and their origin.

#### 2. Copy the public key from your local machine to the Khoury servers:

Replace `<khoury-user>` with your username on the Khoury login servers:

`ssh-copy-id <khoury-user>@login.khoury.northeastern.edu`

You should now be able to access the Khoury servers using key-based authentication rather than using a password:

`ssh <khoury-user>@login.khoury.northeastern.edu`

(If you access the servers from multiple machines, you will need to do this on each machine you use.)

#### 3. Copy the public key from your local machine to the Magi servers:

Replace `<magi-user>` with your username on the Magi cluser:

`ssh-copy-id -o JumpyProxy=<khoury-user>@login.khoury.northeastern.edu <magi-user>@Magi-01`

You should now be able to access the Khoury servers using key-based authentication rather than using a password:

`ssh -J <khoury-user>@login.khoury.northeastern.edu <magi-user>@Magi-01`

(Repeat this process with Magi-02, etc., if desired.)


### Installation




## Accessing data

All Magi nodes have network access to the lab's research datasets.

Please use the `magidb` command line utility to search experimental metadata and sync datasets to a node's local NVMe storage.

From a shell session on any Magi node, you can do:

```
magidb --help
```

The following subcommands are provided:

- `magidb ls`
    + list all datasets
- `magidb ls-cache`
    + list cached datasets
- `magidb search`
    + search all datasets
- `magidb search-cache`
    + search cached datasets
- `magidb prune-cache`
    + remove cached datasets
- `magidb describe`
    + describe a dataset
- `magidb sync`
    + sync a dataset to local cache
- `magidb status`
    + check cache versus manifest

You can see positional arguments and options for subcommand with the `--help` or `-h` flags.

For example:

```
msi search --help
```



## File management

Due to the small number of users, lab members use shared `viteklab` credentials to simplify cluster management.

Please do not upload large datasets without permission. Home directory storage is intended for processed data and analysis results. Contact the Magi cluster maintainer to add datasets to the cluster's research data manifest.


### Magi user directories

The following network directories are provided:

- `~/Datasets/`
    + Includes locally cached research datasets
    + Manage using `magidb` command line utility

- `~/Modules/`
    + Network storage for modules and environments
    + Manage using `conda create -n` and `conda env remove -n`

- `~/Projects/`
    + Network storage for research projects
    + Create subdirectories for each project
    + Stable storage that will not be removed without notification

- `~/Scratch/`
    + Network temporary storage for working files
    + May be deleted without warning

Please give your subdirectories in `Projects` clear, descriptive names within these directories.

*For access to a node's local NVMe storage, use a standard library function for requesting a safe temporary directory, e.g., `tempfile.gettempdir()` in Python or `base::tempdir()` in R.*


### Copying files

Files and directories can be copied from any Magi node to any host visible to the Khoury network, including the Discovery/Explorer cluster, using `rsync`.

Copying files and directories to machines not visible to the Northeastern University network requires SSH tunneling.

The `magi` command line utility (see installation instructions earlier in this document) will set up the SSH tunnel for you, copy files or directories using `rsync`, and close the connection automatically after the file transfer is done.

For example, on your personal computer:

```
touch ~/Scratch/test
magi upload -x ~/Scratch/test Scratch/test
magi download -x Scratch/test ~/Scratch/test-copy
```

This will copy the `test` file to/from your `Scratch/` directory on Magi via the cluster's xfer node (`-x`).


### Best practices for files

All lab members share the same home directory, so avoid cluttering the `~/Projects/` directory with too many projects. Use descriptive subdirectory names to clearly label research projects so they can be easily identified. Use the `~/Scratch` directory for any files that are not important or can be re-generated.



## Session management

To manage remote sessions, you can use `tmux` on either the Khoury login servers or on a Magi node directly.

Please be mindful of shared system resources. When running parallel jobs, please use as few workers as you need so that cores are available for other users.


### Using `tmux` on Khoury servers

Each Magi node is connected by ethernet, so disconnection from the Khoury login servers is relatively unlikely, except in the event of power cycling (which would disrupt your session anyway). This means that it should be relatively reliable to use `tmux` from a Khoury login server to manage your session.

For example, you can do:

```
tmux
ssh viteklab@Magi-01
```

You can then do `C-b d` to detach the `tmux` session while still connected to the Magi node with your process running.

To continue the session, do:

```
tmux attach
```

### Using `tmux` on Magi nodes

Alternatively, you can use `tmux` on a Magi node directly.

If you are using shared `viteklab` credentials, your `tmux` sessions will be accessible to other lab members, so it is important to name your sessions.

To create a named session, you can do:

```
tmux new -s <session-name>
```

To attach a named session, do:

```
tmux attach -t <session-name>
```

You can view existing `tmux` sessions with:

```
tmux ls
```

### Best practices for sessions

Please name any sessions on Magi nodes with your name and/or description.

*If you are using shared `viteklab` credentials, your sessions can be attached by other `viteklab` members.*

This is useful for sharing an ongoing task among lab members, but please be careful not to attach another user's session without permission.



## Software

If you need *specific versions* of packages, please create a virtual environment using `conda create` (for multiple dependencies), `venv` (for Python packages), or `renv` (for R packages) and install packages into the virtual environment.

If you need additional software or dependencies that require administrator privileges to install, please contact the Magi cluster maintainer.


### Conda

Miniforge is installed to provide package management and environments with `conda`.

While the system R and Python are available for ad-hoc scripts, more specific environment needs are best handled using `conda`.

Create a `conda` environment if you need to install project-specific dependencies.

For example:

```
conda create -n test-env
conda activate test-env
```

You can then install dependencies using `conda install` or `pip install`.

To get a specific version of Python, you can do:

```
conda create -n python-env python=3.12
```

To get an environment with `tensorflow-metal`:

```
conda create -n tf-env python=3.10
conda activate tf-env
pip install tensorflow
pip install tensorflow-metal
```

To get an environment with `pytorch-nightly`:

```
conda create -n torch-env numpy pytorch torchvision torchaudio -c pytorch-nightly
```

For additional details, please see https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html.

To remove unused environments, after deactivating them, use:

```
conda env remove -n test-env
conda env remove -n python-env
conda env remove -n tf-env
conda env remove -n torch-env
```

### Homebrew

Additional system dependencies are handled via Homebrew.

You can see available Homebrew packages by using:

```
brew list
```

Homebrew packages require administrator permission to install.

Please contact the Magi cluster maintainer if you need additional system dependencies installed.


### Best practices for software

Please use virtual environments as needed to avoid creating conflicts in the system environment.

It should generally be safe to install additional R packages with `install.packages()`.

Please install Python packages to a virtual environment instead.

Environments can become quite large, so please try to re-use your environments as much as possible, and remove unused environments.

For shared projects, it is recommended to create a single `conda` environment to be used by multiple lab members.

Please name your `conda` environments so their purposes are clear to other users.



## Magi versus Discovery

Northeastern University members also have access to the Discovery cluster which includes over 50,000 CPU cores and 525 GPUs.

You should use Magi if:

- You need faster single-core performance
- You need fast SSD storage for out-of-core computing
- You need less than 192 GB of memory
- You need more memory on a GPU than is available on Discovery
- You need software that is not available on Discovery
- Your data is already available on Magi

You should use Discovery if:

- You need more than 24 CPU cores
- You need more than 192 GB of memory
- You need a more powerful GPU than is available on Magi
- You need multiple CPUs with >40 Gbps interconnect bandwidth
- You need software that is not available on Magi
- Your data can be easily transfered to Discovery
