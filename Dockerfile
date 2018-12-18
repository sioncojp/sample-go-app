# build stage
FROM golang:latest AS build
WORKDIR /go/src/project
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

# final stage
FROM alpine:latest
COPY --from=build /go/src/project/app /project/app
EXPOSE 8000
ENTRYPOINT ["/project/app"]