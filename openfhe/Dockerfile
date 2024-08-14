# The baseimage to use for Microsoft Code editor is:
# mcr.microsoft.com/devcontainers/base:bookworm
ARG BASEIMAGE=debian:bookworm
FROM ${BASEIMAGE}

ARG OPENFHEBUILD="Release"
ARG NATIVEBIT="128"
ARG BUILD_DATE
ARG REVISION
ARG BUILD_VERSION

LABEL \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.title="aiddprive-docker-local/bamboo" \
    org.opencontainers.image.description="OpenFHE for Python testing" \
    org.opencontainers.image.url=https://sei.cmu.edu/ \
    org.opencontainers.image.revision=$REVISION \
    org.opencontainers.image.vendor="Carnegie Mellon University" \
    org.opencontainers.image.version=$BUILD_VERSION

ENV DEBIAN_FRONTEND=noninteractive \
    repository="openfhe-development" \
    branch=main \
    NATIVEBIT=${NATIVEBIT}

#install pre-requisites for OpenFHE
RUN apt-get update && apt-get install -y \ 
    autoconf \
    build-essential \
    cmake \
    cmake-curses-gui \
    doxygen \
    g++ \
    gcc \
    gdb \
    git \
    graphviz \
    hdf5-helpers \
    hdf5-tools \
    libboost-all-dev \
    libgmp-dev \
    libhdf5-dev \
    libntl-dev \
    libomp-dev \
    libomp5 \
    libssl-dev \
    ninja-build \
    openssl \
    pkg-config \
    python3 \
    python3-certifi \
    python3-dev \
    python3-pip \
    python3-venv \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# The update-alternatives step renames python3 to python.

COPY install_openfhe.sh .
RUN /bin/bash install_openfhe.sh ${OPENFHEBUILD} ${NATIVEBIT}

COPY install_openfhe_python.sh /create_venv.sh
RUN chmod a+x /create_venv.sh

CMD ["/bin/bash", "/create_venv.sh"]
