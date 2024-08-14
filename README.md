# OpenFHE Development

## Goal

The goal of this repository is to give you a way to run OpenFHE-Python on your machine with the editor of your choice. Installation of OpenFHE-Python is fragile, so we will put it into a Docker container. The setup will have three parts.

 * A Docker container on your computer containing Python that can run OpenFHE.

 * Your development directory containing Python files you edit and run.

 * A Python virtual environment, called `venv`, which is stored inside your development directory but used by the Python within the Docker container. This will allow you to install any Python modules you want as you work.


## Steps to Install

1. Download Docker for your computer. On my Mac, it's at docker.com. On Linux, use apt or yum to install Docker and Compose.

2. Ask Docker Compose to build a container for you by running a command in the same directory as this README.md file:

    docker compose build

docker compose build". This command will read compose.yaml, which tells it to build the container described in the openfhe/ directory.


## How it's used

Here are the steps for you to use this during development.

1. Create a directory for the code you want to write or edit. Here, we refer to this directory as `$DEV`. Then `cd $DEV`.

2. Create a Python virtual environment that has OpenFHE-python installed.

    docker run --rm -v .:/workspaces -w /workspaces openfhe-tutorial /create_venv.sh

   You should now see a subdirectory called "venv".

3. Make a Python file to edit. For instance, you could copy this file from the OpenFHE-Python examples:

    curl -o integers-bgv.py https://raw.githubusercontent.com/openfheorg/openfhe-python/main/examples/pke/simple-integers-bgvrns.py

3. In order to run your Python code, open a terminal in the Docker container.

    docker run -it --rm -v .:/workspaces -w /workspaces openfhe-tutorial /bin/bash
    source venv/bin/activate

   When the terminal starts, you will see the current directory on your host machine because it is mounted in the Docker container by the `-v` flag.
   The `source` commands tells the Docker shell that you want to use the Python
   `venv` virtual environment.

4. Within that terminal, use Python to run the files you create. Those files can include `import openfhe as fhe` because they are running within the Docker container.

    python integers-bgv.py
