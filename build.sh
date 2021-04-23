#!/bin/bash
docker build --build-arg USER_ID=$UID --tag nvidia-ros:cuda11.1.1-noetic-desktop-full .
