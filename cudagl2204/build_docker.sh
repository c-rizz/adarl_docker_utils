#!/bin/bash
cd "$(dirname "$0")"
docker build --tag crizzard/lr-gym:2204-cudagl-basic .
