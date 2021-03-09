FROM meltano/meltano:v1.70.0-python3.7

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV NODE_VERSION 10

RUN apt update && apt install -y git gcc 

WORKDIR /project

COPY transform/ transform/
COPY meltano.yml .

RUN meltano install

EXPOSE 5000

ENTRYPOINT ["meltano"]
CMD ["ui"]

