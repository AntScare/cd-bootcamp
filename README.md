http-echo
=========
HTTP Echo is a small go web server that serves the contents it was started with
as an HTML page.

The default port is 5678, but this is configurable via the `-listen` flag:

```
http-echo -listen=:8080 -text="hello world"
```

Then visit http://localhost:8080/ in your browser.


# Test Dockerfile-fixed
docker build -t http-echo:test .

# Po úspěšném buildu
docker run -d --name test -p 8080:8080 http-echo:test
curl http://localhost:8080/
docker stop test
docker rm test
