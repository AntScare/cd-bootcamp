http-echo
=========
HTTP Echo is a small go web server that serves the contents it was started with
as an HTML page.

The default port is 5678, but this is configurable via the `-listen` flag:

```
http-echo -listen=:8080 -text="hello world"
```

Then visit http://localhost:8080/ in your browser.


# How to build Dockerfile?
docker build -t http-echo:test .

# How to test locally?
docker run -d --name test -p 8080:8080 http-echo:test
curl http://localhost:8080/
docker stop test
docker rm test

# How to trigger GitHub Actions Pipeline?
1) by creating a pull request
   - sha short tag is added to container registry
2) by pushing a tag
   - tag is added to container registry
       git tag v1.0.0
       git push origin v1.0.0
3) by direct push to main
    - tag of "main" is added to container registry
    git checkout main
    <edit your file>
    git add <file>
    git commit -m <commit message>
    git push
# How to get ArgoCD credentials?
username: admin
password using: 

PS:
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | %{ [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
Linux:
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode