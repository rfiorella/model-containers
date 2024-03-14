

multiarch=FALSE



if [[ $multiarch == TRUE ]]
then
  # build base os container.
  docker buildx build --platform=linux/amd64,linux/arm64 --push \
    --provenance=false \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/baseos:$(date +'%Y%m%d') \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/baseos:latest \
    -f base-ubuntu/Dockerfile .

  # build e3sm container:
  docker buildx build --platform=linux/amd64,linux/arm64 --push \
    --provenance=false \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/e3sm-dev:$(date +'%Y%m%d') \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/e3sm-dev:latest \
    -f e3sm-dev/Dockerfile .

  # build wrf-base container:
  docker buildx build --platform=linux/amd64,linux/arm64 --push \
    --provenance=false \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/wrf-4.5.1-base:$(date +'%Y%m%d') \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/wrf-4.5.1-base:latest \
    -f wrf/Dockerfile ../

else
  # build base os container.
  docker build \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/baseos:$(date +'%Y%m%d') \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/baseos:latest \
    -f base-ubuntu/Dockerfile .

  # build e3sm container:
  docker build \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/e3sm-dev:$(date +'%Y%m%d') \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/e3sm-dev:latest \
    -f e3sm-dev/Dockerfile .

  # build wrf-base container:
  docker build \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/wrf-4.5.1-base:$(date +'%Y%m%d') \
    -t gitlab.lanl.gov:5050/rfiorella/model-containers/wrf-4.5.1-base:latest \
    -f wrf/Dockerfile ../

fi


