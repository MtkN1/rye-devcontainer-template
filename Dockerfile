ARG PYTHON_VERSION="3.12"
ARG DEBIAN_RELEASE="bookworm"

FROM mcr.microsoft.com/devcontainers/python:${PYTHON_VERSION}-${DEBIAN_RELEASE} AS devcontainer

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && apt-get --no-install-recommends install -y bash-completion

ARG REMOTE_USER="vscode"

RUN su ${REMOTE_USER} -c ' \
    curl -sSf https://rye-up.com/get | RYE_VERSION="latest" RYE_INSTALL_OPTION="--yes" bash \
    && echo '\''source "$HOME/.rye/env"'\'' >> ~/.bashrc \
    && source "$HOME/.rye/env" \
    && mkdir -p ~/.local/share/bash-completion/completions \
    && rye self completion > ~/.local/share/bash-completion/completions/rye.bash \
    && rye toolchain register $(env -i which python) \
    ' 2>&1
