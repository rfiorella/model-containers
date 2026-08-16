# ----------------------------------------------------------------------
# Microsoft Aurora (https://github.com/microsoft/aurora)
#
# Two stages:
#   builder  - clones the source and builds a wheel (hatch-vcs needs the
#              full git history/tags to derive the version)
#   runtime  - installs torch from the selected wheel index, then the
#              locally built aurora wheel
#
# Build (CPU, matches the multi-arch pattern used elsewhere in this repo):
#   docker build -t rfiorella/model-containers:aurora-latest ai-models/aurora
#
# Build (CUDA 12.4):
#   docker build \
#     --build-arg BASE_IMAGE=nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04 \
#     --build-arg TORCH_INDEX_URL=https://download.pytorch.org/whl/cu124 \
#     -t rfiorella/model-containers:aurora-cuda-latest ai-models/aurora
#
# Note: the CUDA base ships its own python; PYTHON_VERSION is ignored there.
# ----------------------------------------------------------------------

ARG PYTHON_VERSION=3.11
ARG BASE_IMAGE=python:${PYTHON_VERSION}-slim-bookworm

# ---------------------------------------------------------------- builder
FROM ${BASE_IMAGE} AS builder

ARG AURORA_REPO=https://github.com/microsoft/aurora.git
# A tag (v2.0.1), branch (main), or commit SHA.
ARG AURORA_VERSION=v2.0.1

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        python3 \
        python3-pip \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --break-system-packages --upgrade pip build hatchling hatch-vcs \
    || python3 -m pip install --upgrade pip build hatchling hatch-vcs

WORKDIR /src

# Full clone on purpose: hatch-vcs reads git tags to stamp aurora/_version.py,
# and a shallow clone loses them for anything but an exact tag checkout.
RUN git clone "${AURORA_REPO}" aurora \
    && cd aurora \
    && git checkout "${AURORA_VERSION}" \
    && git log -1 --pretty="commit %H (%d)"

RUN cd /src/aurora && python3 -m build --wheel --outdir /wheels \
    && ls -l /wheels

# ---------------------------------------------------------------- runtime
FROM ${BASE_IMAGE} AS runtime

LABEL org.opencontainers.image.title="microsoft-aurora" \
      org.opencontainers.image.source="https://github.com/microsoft/aurora" \
      org.opencontainers.image.licenses="MIT"

# https://download.pytorch.org/whl/cpu | .../cu124 | .../cu121
ARG TORCH_INDEX_URL=https://download.pytorch.org/whl/cpu
# Leave empty to take whatever torch version aurora resolves to.
ARG TORCH_VERSION=
# Set to "true" to bake the ~5 GB IFS-HRES-T0 checkpoint into the image.
ARG PREFETCH_CHECKPOINT=false
ARG USERNAME=aurora
ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    HF_HOME=/opt/hf-cache \
    OMP_NUM_THREADS=1

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        libgomp1 \
        python3 \
        python3-pip \
        python3-venv \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

# Virtualenv keeps us off the distro python and out of PEP 668's way.
RUN python3 -m venv /opt/venv
ENV VIRTUAL_ENV=/opt/venv \
    PATH=/opt/venv/bin:$PATH

RUN pip install --upgrade pip setuptools wheel

# torch first, from the chosen index, so the aurora install does not pull the
# default (CUDA) wheel from PyPI and blow up the image.
#
# torchvision has to come from the same index in the same resolve: aurora -> timm
# imports torchvision unconditionally, and torchvision ships compiled ops linked
# against one exact torch build. Letting pip satisfy timm's torchvision dep from
# PyPI pairs a PyPI torchvision with the +cpu torch installed here and the import
# dies with "RuntimeError: operator torchvision::nms does not exist".
RUN if [ -n "${TORCH_VERSION}" ]; then \
        pip install --index-url "${TORCH_INDEX_URL}" "torch==${TORCH_VERSION}" torchvision; \
    else \
        pip install --index-url "${TORCH_INDEX_URL}" torch torchvision; \
    fi

COPY --from=builder /wheels /tmp/wheels
RUN pip install /tmp/wheels/microsoft_aurora-*.whl \
    && rm -rf /tmp/wheels

# Fail the build here rather than at runtime if the install is broken.
# The aurora package exposes no __version__ attribute (hatch-vcs writes
# aurora/_version.py but __init__.py never re-exports it), so read the version
# off the installed distribution instead.
RUN python -c "import aurora, torch, torchvision; \
from importlib.metadata import version; \
print('aurora', version('microsoft-aurora')); \
print('torch', torch.__version__, 'torchvision', torchvision.__version__, 'cuda', torch.cuda.is_available()); \
from aurora import Aurora, AuroraSmallPretrained, Batch, Metadata, rollout"

RUN mkdir -p ${HF_HOME} \
    && if [ "${PREFETCH_CHECKPOINT}" = "true" ]; then \
         python -c "from aurora import Aurora; Aurora().load_checkpoint()"; \
       fi

RUN groupadd -g ${GID} ${USERNAME} \
    && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
    && mkdir -p /home/${USERNAME}/work /home/${USERNAME}/data /home/${USERNAME}/output \
    && chown -R ${UID}:${GID} /home/${USERNAME} ${HF_HOME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}/work

CMD ["python"]
