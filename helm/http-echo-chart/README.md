# http-echo-chart

This helm chart deploys the [`http-echo`](https://github.com/mo3m3n/http-echo) docker image in kubernetes.

## Installing the Chart

Cloning the chart repository to `<chart-directory>`:

```bash
git clone  https://github.com/Mo3m3n/http-echo-chart <chart-directory>
```

Installing the chart with the release name `my-release` located in `<chart-directory>`:

```bash
helm install --name my-release <chart-directory>
```

By default this will install the Chart via a deployment resource and expose ports `8080` and `8443` for `HTTP` and `HTTPS`
Also an ingress ressource is installed which will expose the `HTTP` service via `<my-release>.k8s.local` Hostname.


## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Docker image repository | `mo3m3n/http-echo` |
| `image.tag` | Docker image tag | `latest`
| `image.pullPolicy` | Image pull policy | `IfNotPresent`
| `replicaCount` | Number of replicas | `1`
| `service.type` | Service type | `ClusterIP`
| `service.httpPort` | Service HTTP port number | `8080`
| `service.httpsPort` | Service HTTPS port number | `8443`
| `ingress.enabled` | enable ingress ressource| `true`
| `ingress.host` | Host value of the ingress rule | `<my-release>.k8s.local`
| `ingress.servicePort` | ServicePort of the ingress rule | `http`

