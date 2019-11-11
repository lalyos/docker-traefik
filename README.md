[traefik](traefik.io) exposing containers with NAME.domain.com, automated https (letsencrypt) and redirect to https.

## Docker network

```
docker network create traefik
```

## startup

```
docker-compose up -d
```

## test 

```
docker run -d --network=traefik --name web -p 80 nginx
```

or run a mock json rest api with admin ui:

```
docker run -d \
  --name mock \
  --network=traefik \
  -p 3000 \
  lalyos/json-server
```