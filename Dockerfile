FROM meltano/meltano:v1.77.0-python3.7

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV NODE_VERSION 10
ENV MELTANO_PROJECT_READONLY 1

WORKDIR /project
#TODO: more secure
#RUN adduser meltano

#TODO: remove psql install in prod
RUN apt update && apt install -y git gcc postgresql-client

#TODO: more secure
#COPY --chown=meltano:meltano . .
COPY . .

VOLUME /project/.meltano/logs/elt

EXPOSE 80

ENTRYPOINT ["python", "entrypoint.py"]
