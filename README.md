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

If Dockerfile defines EXPOSE you can omit port
```
docker run -d --network=traefik --name web nginx
```

```
docker run -d --network=traefik --name lunch --env=TITLE=Lunchtime -p 80 lalyos/lunch-wto
```
## Basic Auth

Adding basic auth is implemented by the `traefik.frontend.auth.basic` label:
```
docker run -d \
  --network=traefik \
  --name secret \
  --env=TITLE=TOP-Secret \
  --env=COLOR=coral \
  --label 'traefik.frontend.auth.basic=admin:$1$I5Kt8BwT$G4y6mBV3xVzyZKUECxqV61' \
    lalyos/lunch-wto
```

hint: `admin/secret`

## Automatic HTTPS - by Letsencrypt

Use the `docker-compose-acme.yaml` version:
```
export EMAIL=your@email.com
export DOMAIN=your.domain.com
docker-compose --file docker-compose-acme.yaml up -d
```

## Traefik Api

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

## Json-server
For something more "useful" run a mock json rest api with admin ui:

```
docker run -d \
  --name mock \
  --network=traefik \
  -p 3000 \
  lalyos/json-server
```