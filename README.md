# Docker For Mac CLOSE_WAIT Socket Reproduction

Reproduction of https://github.com/docker/for-mac/issues/1132

This repository starts a simple HAProxy server in a container reaching out to the host for TCP health checks. These connections get stuck in CLOSE_WAIT status, eventually causing the VM to become inoperable with EPIPE errors.

Interestingly, changing the TCP health check to an HTTP one works around the issue.

#### Running

```bash
./run.sh
```

The `run.sh` script will start a local server on port 8000, HAProxy inside the Docker For Mac VM on port 8001, and watch open sockets. You should see them rise at a rate of roughly 5 per second.

#### Requirements

* `docker-compose`
* `python2`
