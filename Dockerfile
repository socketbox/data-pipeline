FROM python:3.7.10-slim-buster AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV NODE_VERSION 10

RUN apt update && apt install -y git gcc

WORKDIR /project

COPY requirements.txt .
COPY transform/ transform/
COPY meltano.yml .

RUN pip3 install -r requirements.txt && meltano install

EXPOSE 5000

ENTRYPOINT ["meltano"]
CMD ["ui"]

