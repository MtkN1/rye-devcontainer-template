#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Reference: https://github.com/devcontainers/features/blob/203dc3f5bde1a8ca25525234757ac54e9b8da64c/src/python/install.sh

RYE_VERSION="${VERSION:-"latest"}"

USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        $COMMAND
    fi
}

# Install Rye
PYTHON_SRC=$(which python)
sudo_if "curl -sSf https://rye-up.com/get | RYE_VERSION=\"${RYE_VERSION}\" RYE_INSTALL_OPTION=\"--yes --toolchain ${PYTHON_SRC}\" bash"

USERHOME="$(sudo_if printenv HOME)"
RYE_SRC="${RYE_HOME:-${USERHOME}/.rye}/shims/rye"
sudo_if mkdir -p "${USERHOME}/.local/share/bash-completion/completions"
sudo_if "\"${RYE_SRC}\" self completion > \"${USERHOME}/.local/share/bash-completion/completions/rye.bash\""

sudo_if "${RYE_SRC}" config --set-bool behavior.use-uv=true
