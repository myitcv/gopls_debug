## `gopls_debug`

Docker setup for debugging [`gopls`](https://github.com/golang/tools/blob/master/gopls/README.md) using Jaeger et al.

### Running interactively

```
docker run --rm -i -t -v /var/run/docker.sock:/var/run/docker.sock myitcv/gopls_debug
```

_(For now we advise an interactive `docker run` so you can easily inspect the output in case of any issues)_

Start `gopls` with the following flag:

```
-ocagent=http://localhost:55678
```

Then visit:

* [http://localhost:16686/](http://localhost:16686/) for the Jaeger trace viewer
* [http://localhost:3000/](http://localhost:3000/) for the Grafana metrics viewer

`Ctrl-c` will gracefully stop everything when you're done.

### Running as a daemon

As a one off:

```
docker run -d --name gopls_debug -v /var/run/docker.sock:/var/run/docker.sock myitcv/gopls_debug
```

Then you can use `docker start gopls_debug` and `docker stop gopls_debug`.

Follow the same instructions as above for setting `gopls` flags etc.

### Building

If you are interesting in helping to improve this image:

```
git clone https://github.com/myitcv/gopls_debug
cd gopls_debug
docker build -t myitcv/gopls_debug .
```
