#!/bin/bash -
for GOOS in darwin linux; do
    GOOS=$GOOS GOARCH=amd64 go build -o bin/sample-go-app-$GOOS-amd64 main.go
done
