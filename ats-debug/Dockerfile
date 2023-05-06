# ATS from ubuntu


FROM ubuntu:focal

# EDIT THESE!
ENV ATS_BASE=/home/ats
ENV ATS_BUILD_TYPE=Release
ENV ATS_VERSION=ats-1.4.1
ENV OPENMPI_DIR=/usr
# END EDIT THESE!

ENV AMANZI_TPLS_BUILD_DIR=${ATS_BASE}/amanzi_tpls-build-${ATS_VERSION}-${ATS_BUILD_TYPE}
ENV AMANZI_TPLS_DIR=${ATS_BASE}/amanzi_tpls-install-${ATS_VERSION}-${ATS_BUILD_TYPE}

ENV AMANZI_SRC_DIR=${ATS_BASE}/repos/amanzi
ENV AMANZI_BUILD_DIR=${ATS_BASE}/amanzi-build-${ATS_VERSION}-${ATS_BUILD_TYPE}
ENV AMANZI_DIR=${ATS_BASE}/amanzi-install-${ATS_VERSION}-${ATS_BUILD_TYPE}

ENV ATS_SRC_DIR=${AMANZI_SRC_DIR}/src/physics/ats
ENV ATS_DIR=${AMANZI_DIR}

ENV PATH=${ATS_DIR}/bin:${PATH}
ENV PATH=${AMANZI_TPLS_DIR}/bin:${PATH}
ENV PYTHONPATH=${ATS_SRC_DIR}/tools/utils:${PYTHONPATH}
ENV PYTHONPATH=${AMANZI_TPLS_DIR}/SEACAS/lib:${PYTHONPATH}

# update os and isntall required packages:
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
    cmake \
    git \
    gcc \ 
    g++ \
    curl \
    libcurl4-openssl-dev \
    gfortran \
    wget \
    vim \
    libopenmpi-dev \
    openmpi-bin \
    libblas-dev \
    liblapack-doc \
    liblapack-dev \
    python3 \
    python3-pip \
    python-is-python3 \
    rsync \
    zlib1g-dev \
    make \
    m4 \
    emacs \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean all

# clone AMANZI
RUN mkdir -p ${ATS_BASE} \
    && cd ${ATS_BASE} \
    && git clone -b amanzi-1.4.1 http://github.com/amanzi/amanzi $AMANZI_SRC_DIR \
    && cd ${AMANZI_SRC_DIR} \
#    && git checkout tags/${ATS_VERSION} \
    && . ${AMANZI_SRC_DIR}/build_ATS_generic.sh
