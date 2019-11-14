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

If Dockerfile defines EXPOSE you can omit port
```
docker run -d --network=traefik --name web nginx
```

or run a mock json rest api with admin ui:

```
docker run -d \
  --name mock \
  --network=traefik \
  -p 3000 \
  lalyos/json-server
```

## api

```
# list all docker front/backends
curl -s http://traefik.docker.localhost/api | jq '.docker'

# list all rules
curl -s http://traefik.docker.localhost/api | jq '.. | .rule? | select(type != "null")'
```

## Troubleshoot

If traefik runs with `--debug` the 2. line in the log shows the config (cli params parsed)
```
# all config
printf $(docker logs traefik|sed -n '2 {s/^.*loaded//;s/"$//;p}')|jq .

# print only entrypoint related conf
printf $(docker logs traefik|sed -n '2 {s/^.*loaded//;s/"$//;p}')|jq '{EntryPoints:.EntryPoints,DefaultEntryPoints:.DefaultEntryPoints}'
```
