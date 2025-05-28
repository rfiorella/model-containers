EAMXX-wiso:
	docker run --rm -it -v /code/E3SM/EAMxx-wiso:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/scream:/home/e3smuser/output rfiorella/model-containers:e3sm-openmpi-dev-latest

EAMv2-wiso:
	docker run --rm -it -v /code/E3SM/EAMv3-wiso:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/eamv2:/home/e3smuser/output rfiorella/model-containers:e3sm-openmpi-dev-latest

EAMv3-wiso:
	docker run --rm -it -v /code/E3SM/EAMv3-wiso:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/eamv3:/home/e3smuser/output rfiorella/model-containers:e3sm-openmpi-dev-latest

NGEE-master:
	docker run --rm -it -v /code/E3SM/NGEE-master:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/ngee-master:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

NGEE-IM3-debug:
	docker run --rm -it -v /code/E3SM/IM3:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/im3:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

NGEE-IM2-debug:
	docker run --rm -it -v /code/E3SM/IM2:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/im2:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

NGEE-IM1-debug:
	docker run --rm -it -v /code/E3SM/IM1:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/im1:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

ELM-ATS:
	docker run --rm -it -v /code/E3SM/ELM-ATS:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/elm-ats:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest

interface:
	docker run --rm -it -v /code/E3SM/interface-lakes:/home/e3smuser/E3SM -v /Volumes/neon_e3sm/inputdata:/home/e3smuser/inputdata -v /data/interface:/home/e3smuser/output -v /code/E3SM/OLMT:/home/e3smuser/OLMT rfiorella/model-containers:e3sm-openmpi-dev-latest
