#!/usr/bin/env bash
# check if we're in test
echo "PID of docker-compose-up.sh script: $$"
if [[ $PWD = */test && -f docker-compose.test.yml ]];
then
  cp -a ../meltano.yml ../transform ../orchestrate ../analyze .
  docker-compose -f docker-compose.test.yml up -d
fi
#cleanup
rm -rf meltano.yml ./transform ./orchestrate ./analyze
