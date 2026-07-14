# Magi cluster tutorial


## Contents

Jump to a section:

- [Overview](#Overview)
- [Setup](#Setup)
- [Projects](#Projects)
- [Sessions](#Sessions)
- [Software](#Software)
- [Magi versus Explorer](#Magi-versus-Explorer)

## Overview

The Magi cluster is a simple network-of-workstations style Beowulf cluster of commodity Mac hardware maintained by Prof. Kylie Ariel Bemis for the Vitek Lab in the Khoury College of Computer Sciences at Northeastern University. Cluster access requires lab membership, PI authorization, and a Khoury login.

Please contact the Magi cluster maintainer for login credentials.

### Nodes

Currently, the following nodes are available to Vitek Lab members:

- `Magi-01` : compute node (M2 Ultra / 16 p-cores / 8 e-cores / 192 GB)

- `Magi-02` : compute node (M2 Ultra / 16 p-cores / 8 e-cores / 192 GB)

### Storage

The following volumes may be available, depending on the node:

- `/Volumes/Local`: internal NVMe storage (size varies; Apple fabric)
- `/Volumes/Primary`: external NVMe storage (16TB; Thunderbolt)
- `/Volumes/Secondary`: external NVMe storage (16TB; Thunderbolt)

Each node has a "Local" volume dedicated to shared internal storage that should be readable and writeable by all lab members.

The "Primary" and "Secondary" volumes are external NVMe RAID0 arrays connected via Thunderbolt.

Typically, "Primary" will be attached to Magi-01, and "Secondary" will be attached to Magi-02, but this is subject to change as necessary.

It is recommended to manually duplicate projects to both "Primary" and "Secondary" volumes, and keep them on "Local" only as needed.

These should not be considered backups, but data on them may be backed up to another archival volume from time to time.

## Setup

It is strongly recommended to set up SSH key-based authentication for the intermediate Khoury login servers.

If you have not already set up SSH keys, this can be done with the following steps:

### 1. Generate a private key on your local machine:

Check if you already have a key:

```{sh}
ls ~/.ssh
```

If you see a pair of "id" files with one of them ending in ".pub" (e.g., "id_ed25519" and "id_ed25519.pub"), then you can skip this step.

If you don't already have a key, create one:

```{sh}
ssh-keygen -C "<your-name>@<host-name>"
```

Accept the defaults. The comment (`-C`) helps identify which key is associated with which user and their origin.

### 2. Copy the public key from your local machine to the Khoury servers:

Replace `<khoury-user>` with your username on the Khoury login servers:

```{sh}
ssh-copy-id <khoury-user>@login.khoury.northeastern.edu
```

You should now be able to access the Khoury servers using key-based authentication rather than using a password:

```{sh}
ssh <khoury-user>@login.khoury.northeastern.edu
```

(If you access the servers from multiple machines, you will need to do this on each machine you use.)

### 3. Copy the public key from your local machine to the Magi servers:

Replace `<magi-user>` with your username on the Magi cluser:

```{sh}
ssh-copy-id -o JumpyProxy=<khoury-user>@login.khoury.northeastern.edu <magi-user>@Magi-01
```

You should now be able to access the Khoury servers using key-based authentication rather than using a password:

```{sh}
ssh -J <khoury-user>@login.khoury.northeastern.edu <magi-user>@Magi-01
```

(Repeat this process with Magi-02, etc., if desired.)


## Projects

The `badwulf` package can be used to help manage projects and keep data synced across Magi servers and your personal computer.


### Installation

You can install `badwulf` using `uv` using the following:

```{sh}
uv tool install badwulf
```

This will install `badwulf` as a command line tool. You may need to follow the directions to update your shell's `$PATH`.

You can use the `wulf` command to use `badwulf`:

```{sh}
wulf --help
```

### Sites and environment variables

To synchronize project data, `badwulf` uses the idea of "sites", which are similar to `git` "remotes".

These can be configured with the `wulf site` command, or by writing a "badwulf-sites.json" configuration file.

This repository provides two configuration files for use with `badwulf`:

- `badwulf-sites-client.json`: for a personal computer
- `badwulf-sites-cluster.json`: for a Magi node

You can clone this git repository to your home folder, and then set the following environment variables.

For `badwulf-sites-client.json` (if on your personal computer):

```{sh}
export BADWULF_SITES="<path-to-badwulf-sites.json>"
export BADWULF_PREFIX="<path/to/database/root/>"
export MAGI_USER="<your-magi-username>"
export KHOURY_USER="<your-khoury-username>"
export EXPLORER_USER="<your-explorer-username>"
```

For `badwulf-sites-cluster.json` (if on a Magi node):

```{sh}
export BADWULF_SITES="<path-to-badwulf-sites.json>"
export EXPLORER_USER="<your-explorer-username>"
```

You should then have access to the following "sites":

- `local`: local machine
- `magi`: Magi cluster "Local" volume (only available if not on Magi)
- `primary`: Magi cluster "Primary" storage volume
- `secondary`: Magi cluster "Secondary" storage volume
- `explorer`: Explorer cluster


### Accessing projects

Projects are simply directories with a "metadata.toml" file.

At a minimum, this could look like:

```{toml}
name = "project-name"
scope = "private"
group = "viteklab"
```
Project names must be unique.

Current scopes include:

- "public": projects that are already public or MAY be shared
- "private": projects that are not sensitive but SHOULD NOT be shared without permission
- "restricted": projects that are sensitive and MUST NOT be shared without permission

Typically, project data received from collaborators should be considered "restricted" unless permission is obtained otherwise. New projects within the lab should be "private" until they are ready to be shared publicly.

Groups may refer to labs or research groups, individuals, organizations, repositories, etc.

Projects are organized under a prefix.

Each of the "Local", "Primary", and "Secondary" storage volumes on Magi have a "Data" prefix. Any subdirectories under this prefix may be a project if they contain a "metadata.toml" file. However, `badwulf` will automatically create the following directory structure:

```{sh}
/prefix
    /scopes
        /groups
            /projects
```

For example:

```{sh}
wulf add TEST --scope private --group scratch
```

If run on a Magi node, this will initialize "/Volumes/Local/Data/private/scratch/TEST/metadata.toml".

To find the path to a project, you can do:

```{sh}
wulf info TEST --path
```

To remove the project, you can do:

```{sh}
wulf remove TEST
```


### Managing projects

You can fetch a manifest of projects from "Primary" or "Secondary" storage, or a Magi node's local storage:

```{sh}
wulf fetch primary
```

To view the projects available, you can do:

```{sh}
wulf ls -S primary
```

To get a local copy of a project, you would run:

```{sh}
wulf pull primary PXD001283
```

To see projects that you have locally, you would do:

```{sh}
wulf ls
```

For additional details, see https://pypi.org/project/badwulf/.


## Sessions

To manage remote sessions, you can use `tmux` on either the Khoury login servers or on a Magi node directly.

Please be mindful of shared system resources. When running parallel jobs, please use as few workers as you need so that cores are available for other users.


### Using `tmux` on Khoury servers

Each Magi node is connected to the Khoury virtual local area network (VLAN) by physical ethernet, so disconnection from the Khoury login servers is relatively unlikely except in the event of power cycling (which would disrupt your session anyway). This means that it should be relatively reliable to use `tmux` from a Khoury login server to manage your session.

For example, you can do:

```{sh}
tmux
ssh viteklab@Magi-01
```

You can then do `C-b d` to detach the `tmux` session while still connected to the Magi node with your process running.

To continue the session, do:

```{sh}
tmux attach
```

### Using `tmux` on Magi nodes

Alternatively, you can use `tmux` on a Magi node directly.

If you are using the shared `viteklab` user account rather than an individual user account, your `tmux` sessions will be accessible to other lab members, so it is important to name your sessions.

To create a named session, you can do:

```{sh}
tmux new -s <session-name>
```

To attach a named session, do:

```{sh}
tmux attach -t <session-name>
```

You can view existing `tmux` sessions with:

```{sh}
tmux ls
```

You can view the full `tmux` manual with `man tmux`.


## Software

If you need *specific versions* of packages, please create a virtual environment using `conda create` (for multiple dependencies), `venv` (for Python packages), or `renv` (for R packages) and install packages into the virtual environment.

If you need additional software or dependencies that require administrator privileges to install, please contact the Magi cluster maintainer.

### Conda

Miniforge is installed to provide package management and environments with `conda`.

Create a `conda` environment if you need to install project-specific dependencies.

For example:

```{sh}
conda create -n test-env
conda activate test-env
```

You can then install dependencies using `conda install` (from conda-forge) or `pip install` (from PyPI).

Use `conda deactivate` to deactivate the environment.

To get a specific version of Python, you can do:

```{sh}
conda create -n python-env python=3.12
```

For additional details, see https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html.

To remove unused environments, after deactivating them, use:

```{sh
conda env remove -n test-env
conda env remove -n python-env
```

### uv

For projects requiring only Python packages, the `uv` package simplifies setting up a `venv`-compatible virtual environment.

For example:

```{sh}
uv init --bare
uv add numpy
```

This initializes the current working directory with a "pyproject.toml" and adds `numpy` to the project.

Rather than activating the virtual environment, use `uv run` to run binaries in the virtual environment:

```{sh}
uv run python3
```

For additional details, see https://docs.astral.sh/uv/.

### renv

For projects requiring only R packages, the `renv` package allows creating a `venv`-like reproducible environment of R packages.

You use `renv` from within an R session:

```{r}
renv::init()
```

This initializes the project in the current working directory.

You don't need to add R packages explicitly. Instead, R packages will be picked up automatically based on `library()` and `require()` calls in any ".R" scripts.

To create a lockfile that can be shared or used to restore the environment, you can use:

```{r}
renv::snapshot()
```

To restore from a lockfile in the current working directory, you can do:

```{r}
renv::restore()
```

For additional details, see https://rstudio.github.io/renv/articles/renv.html.

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

Environments can become quite large, so please try to keep them in a separate project than large datasets, and use symlinks to simulate data subdirectories.


## Magi versus Explorer

Northeastern University members also have access to the Explorer cluster which includes over 50,000 CPU cores and 525 GPUs.

You should use Magi if:

- You need faster single-core performance
- You need fast SSD storage for out-of-core computing
- You need less than 192 GB of memory
- You need more memory on a GPU than is available on Discovery
- You need software that is not available on Discovery
- Your data is already available on Magi

You should use Explorer if:

- You need more than 24 CPU cores
- You need more than 192 GB of memory
- You need a more powerful GPU than is available on Magi
- You need multiple CPUs with >40 Gbps interconnect bandwidth
- You need software that is not available on Magi
- Your data can be easily transfered to Explorer

