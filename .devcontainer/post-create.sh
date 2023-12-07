#/usr/bin/env bash

if [ ! -f ./pyproject.toml ]; then
    rye init --min-py $PYTHON_VERSION -p $PYTHON_VERSION .
elif [ "$(<./.python-version)" != "$PYTHON_VERSION" ]; then
    rye pin $PYTHON_VERSION
fi

rye sync
