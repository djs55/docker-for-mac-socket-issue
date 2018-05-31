# Docker For Mac CLOSE_WAIT Socket Reproduction

Reproduction of https://github.com/docker/for-mac/issues/1132

This repository starts a simple HAProxy server in a container reaching out to the host for TCP health checks. These connections get stuck in CLOSE_WAIT status, eventually causing the VM to become inoperable with EPIPE errors.

Interestingly, changing the TCP health check to an HTTP one works around the issue.

#### Running

```bash
./run.sh
```

The `run.sh` script will start a local server on port 8000, HAProxy inside the Docker For Mac VM on port 8001, and watch open sockets.

#### Requirements

* `docker-compose`
* `node`

#### Results

Sockets increase at a rate of 5 per second.

Example output of lsof after running this script for about 10 seconds:

```
$ lsof -i -P -n | grep com.dock | wc -l
    149
$ lsof -i -P -n | grep com.dock
com.docke 95037 user  145u  IPv4 0xabc1ee0a8fd8ff93      0t0  TCP 127.0.0.1:59807->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  146u  IPv4 0xabc1ee0a8ecfdbb3      0t0  TCP 127.0.0.1:59810->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  147u  IPv4 0xabc1ee0a6c406f93      0t0  TCP 127.0.0.1:59812->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  148u  IPv4 0xabc1ee0a8a211f93      0t0  TCP 127.0.0.1:59817->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  149u  IPv4 0xabc1ee0a9002869b      0t0  TCP 127.0.0.1:60389->127.0.0.1:8000 (CLOSE_WAIT)
com.docke 95037 user  150u  IPv4 0xabc1ee0a8fcf69c3      0t0  TCP 127.0.0.1:59979->127.0.0.1:8000 (CLOSE_WAIT)
com.docke 95037 user  151u  IPv4 0xabc1ee0a8fd8d2bb      0t0  TCP 127.0.0.1:59983->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  152u  IPv4 0xabc1ee0a8f26ada3      0t0  TCP 127.0.0.1:59986->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  153u  IPv4 0xabc1ee0a7b99a4ab      0t0  TCP 127.0.0.1:59990->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  154u  IPv4 0xabc1ee0a90fe34ab      0t0  TCP 127.0.0.1:59991->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  155u  IPv4 0xabc1ee0a8c6599c3      0t0  TCP 127.0.0.1:59992->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  156u  IPv4 0xabc1ee0a8ff8d69b      0t0  TCP 127.0.0.1:60393->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  157u  IPv4 0xabc1ee0a8ff504ab      0t0  TCP 127.0.0.1:60394->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  158u  IPv4 0xabc1ee0a8fcd92bb      0t0  TCP 127.0.0.1:60399->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  159u  IPv4 0xabc1ee0a8fd3df93      0t0  TCP 127.0.0.1:60402->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  160u  IPv4 0xabc1ee0a8fed1bb3      0t0  TCP 127.0.0.1:60403->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  162u  IPv4 0xabc1ee0a8fd6fbb3      0t0  TCP 127.0.0.1:61555->127.0.0.1:8000 (CLOSE_WAIT)
com.docke 95037 user  163u  IPv4 0xabc1ee0a8fd649c3      0t0  TCP 127.0.0.1:61556->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  164u  IPv4 0xabc1ee0a8fd5bf93      0t0  TCP 127.0.0.1:61558->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  165u  IPv4 0xabc1ee0a8ff612bb      0t0  TCP 127.0.0.1:61562->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  166u  IPv4 0xabc1ee0a8f6b74ab      0t0  TCP 127.0.0.1:61563->127.0.0.1:8000 (CLOSED)
com.docke 95037 user  167u  IPv4 0xabc1ee0a903aebb3      0t0  TCP 127.0.0.1:61567->127.0.0.1:8000 (CLOSED)
```
