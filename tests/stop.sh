#!/bin/bash
#
# Copyright (C) 2019 Intel Corporation.
#
# SPDX-License-Identifier: BSD-3-Clause
#

echo "Stopping video analytics serving containers"
docker stop $(docker ps -f name=video-analytics-serving) 2> /dev/null || echo "No containers to stop"

echo "Removing video analytics serving containers"
docker rm $(docker ps -f name=video-analytics-serving) 2> /dev/null || echo "No containers to remove"

function show_help {
  echo "usage: ./stop.sh"
  echo "  [ --remove : remove video analytics serving images ]"
  echo "  [ --clean-shared-memory : remove files in /dev/shm to clean up shared memory ]"
}

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -h | -\? | --help)
      show_help
      exit
      ;;
    --remove)
      echo "Removing video analytics serving images"
      docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'video-analytics-serving') 2> /dev/null || echo "No images to remove"
      shift
      ;;
    --clean-shared-memory)
      echo "Removing all files in /dev/shm"
      rm /dev/shm/*
      shift
      ;;
    *)
      break
      ;;
  esac

  shift
done
echo "Exiting"
exit 0