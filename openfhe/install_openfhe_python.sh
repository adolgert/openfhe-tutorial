#!/bin/bash
set -x

# These are directory locations within the Docker image.
# The /workspaces directory is a mount of the host's current working directory
# If the container is run with `-v .:/workspaces`.
WORKDIR=/workspaces
SOURCEDIR=/openfhe-python

if [[ ! -d "${WORKDIR}/venv" ]]
then
    python -m venv "${WORKDIR}/venv"
    echo "export LD_LIBRARY_PATH=\"$LD_LIBRARY_PATH:/usr/local/lib\"" >> "${WORKDIR}/venv/bin/activate"
    "${WORKDIR}/venv/bin/pip" install --upgrade pip
    "${WORKDIR}/venv/bin/pip" install 'pybind11[global,stubgen]' wheel pytest
fi
source "${WORKDIR}/venv/bin/activate"
if [[ -d "${SOURCEDIR}/build" ]]
then
    rm -rf "${SOURCEDIR}/build" "${SOURCEDIR}/openfhe/openfhe.so"
fi
"${WORKDIR}/venv/bin/pip" install "${SOURCEDIR}"

# OpenFHE gang doesn't tell pip where to put the .o file so we do it.
SITE=$(python -c 'import site; print(site.getsitepackages()[0])')
cp $SOURCEDIR/openfhe/openfhe.so $SITE/openfhe
