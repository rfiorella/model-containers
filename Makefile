.PHONY: EAMXX-wiso EAMv2-wiso EAMv3-wiso NGEE-master NGEE-IM3-debug NGEE-IM2-debug NGEE-IM1-debug ELM-ATS ELM-ATS-debug interface

EAMXX-wiso:
	docker run --rm -it -v /code/build-models/eamxx:/home/e3smuser/scripts -v /data/scream/baselines:/home/e3smuser/baselines -v /code/E3SM/EAMxx-wiso:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/scream/output:/home/e3smuser/output rfiorella/model-containers:e3sm-openmpi-dev-latest

EAMv2-wiso:
	docker run --rm -it -v /code/E3SM/EAMv2-wiso:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/eamv2:/home/e3smuser/output rfiorella/model-containers:e3sm-openmpi-dev-latest

EAMv3-wiso:
	docker run --rm -it -v /code/E3SM/EAMv3-wiso:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/eamv3:/home/e3smuser/output rfiorella/model-containers:e3sm-openmpi-dev-latest

NGEE-master:
	docker run --rm -it -v /code/E3SM/NGEE-Arctic-E3SM:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/ngee-master:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

NGEE-IM3-debug:
	docker run --rm -it -v /code/E3SM/IM3:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/im3:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

NGEE-IM2-debug:
	docker run --rm -it -v /code/E3SM/IM2:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/im2:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

NGEE-IM1-debug:
	docker run --rm -it -v /code/E3SM/IM1:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/im1:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

ELM-ATS:
	docker run --rm -it -e ELM_ATS_SRC_DIR=/home/amanziuser/E3SM -e E3SM_WORK_DIR=/home/amanziuser -v /code/E3SM/ELM-ATS:/home/amanziuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/amanziuser/inputdata -v /data/elm-ats:/home/amanziuser/output -v /code/E3SM/OLMT:/home/amanziuser/OLMT metsi/compass-elm-ats:latest

ELM-ATS-debug:
	docker run --rm -it -e GITHUB_ACTIONS=FALSE -e MACHINE_NAME=docker -e COMPILER_NAME=gnu -e ELM_ATS_SRC_DIR=/home/e3smuser/E3SM -e E3SM_WORK_DIR=/home/e3smuser -v /code/COMPASS-ELM-ATS:/home/e3smuser/COMPASS-ELM-ATS -v /code/E3SM/ELM-ATS:/home/e3smuser/E3SM -v /code/E3SM/pt-e3sm-inputdata:/home/e3smuser/inputdata -v /data/elm-ats:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

interface:
	docker run --rm -it -v /code/E3SM/interface-lakes:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/interface:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest
