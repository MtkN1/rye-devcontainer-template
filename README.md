# rye-devcontainer-template

Development Container for Rye.

## Usage

The following command will download the `.devcontainer` folder of this template to the current directory.

```bash
curl -sSL https://github.com/MtkN1/rye-devcontainer-template/releases/latest/download/artifact.tar.gz | tar -xz
```

## Features

- Build a container image that automatically installs Rye.
- Install Rye using Dev Container Features.
- Configure system Python for Rye.
- Setup bash completion.
- Setup `uv` backend.
- Automatically initialize the project after opening Dev Container.
- Other features, configure extensions such as Ruff, specify appropriate Python interpreter paths, etc.

## Base Tools

### Rye

> An Experimental Package Management Solution for Python

https://github.com/mitsuhiko/rye

### Dev Containers

> Development Containers: Use a container as a full-featured development environment.

https://code.visualstudio.com/docs/devcontainers/containers
