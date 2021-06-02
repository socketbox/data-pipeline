FROM meltano/meltano:v1.74.0-python3.7

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV NODE_VERSION 10
ENV MELTANO_PROJECT_READONLY 0

WORKDIR /project

#RUN mkdir .meltano && apt update && apt install -y git gcc
RUN apt update && apt install -y git gcc

#COPY transform/ transform/
#COPY meltano.yml .
COPY . .
VOLUME /project/.meltano/logs/elt

RUN meltano install

EXPOSE 80

ENTRYPOINT ["python", "entrypoint.py"]
