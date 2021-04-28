#!/bin/bash
docker build --build-arg USER_ID=$UID --tag lr-gym:cuda11.1.1-noetic-desktop-full .
