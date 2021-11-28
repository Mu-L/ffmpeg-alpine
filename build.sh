#!/bin/sh
cd dependencies
docker build --rm -t yveshield/ffmpeg-alpine:4.4-dependencies .
docker push yveshield/ffmpeg-alpine:4.4-dependencies
cd ../build-stage
docker build --rm -t yveshield/ffmpeg-alpine:4.4-buildstage .
docker push yveshield/ffmpeg-alpine:4.4-buildstage
cd ../runtime
docker build --rm -t yveshield/ffmpeg-alpine:4.4-runtime .
docker push yveshield/ffmpeg-alpine:4.4-runtime
cd ../custom/alpine
docker build --rm -t yveshield/ffmpeg-alpine:4.4 .
docker push yveshield/ffmpeg-alpine:4.4
cd ../golang
docker build --rm -t yveshield/ffmpeg-alpine:4.4-golang .
docker push yveshield/ffmpeg-alpine:4.4-golang
docker build --rm -t yveshield/ffmpeg-alpine:4.4-golang-1.15 .
docker push yveshield/ffmpeg-alpine:4.4-golang-1.15
cd ../../example/ffmepg-cli
docker build --rm -t yveshield/ffmpeg-alpine:example .
docker push yveshield/ffmpeg-alpine:example
