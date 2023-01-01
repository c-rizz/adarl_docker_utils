#!/bin/bash
docker build --build-arg USER_ID=$UID --tag lr-gym:cuda11.7.1-humble-desktop-full .
