# Run local
```sh
$ make run

$ curl localhost:8000
```

# Run Docker
```sh
$ make docker

$ curl localhost:8000
```

# Build binary from local
```sh
$ make build

$ bin/sample-go-app
$ curl localhost:8000
```

# Build as linux and darwin
```sh
$ make dist

$ ls -1 bin
sample-go-app-darwin-amd64.tar.gz
sample-go-app-linux-amd64.tar.gz
```