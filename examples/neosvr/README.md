# NeosVR Example
To launch NeosVR Headless-Server with shiipou/Steamcmd I'll use the docker swarm version because it better for high availability, but bassicaly you can use the docker usage of steamcmd documented in the [home page](https://github.com/shiipou/steamcmd)

## Usage


Like sayed in the home page, you first need to have a swarm cluster running, if not, you can just initialisate one using this command : 
```sh
docker swarm init
```

Now, you can create the `stackfile`, I'll name it `steam.yml`. Personnaly I put all my steamcmd servers in the same stack file. 

Here the template file you can use :

```yaml
# file: steam.yml

version: "3.7"
services:
  neosvr:
    image: nocturlab/steamcmd
    environment :
      INSTALL_APPS: 740250
      BETA_NAME: headless-client
      BETA_KEY: ****
    volumes:
      - neosvr:/steam
    command: /steam/740250/Neos.x86_64
    deploy:
      replicas: 1

volumes:
  neosvr:
```

You can refer to the home page to know how to use any options.

To run your server, you just have to run this command :
```sh
docker stack deploy -c steam.yml steam
```

You will have an error because you're not connected to steam, so the beta key can't be used.
So you can use the docker command version just for the first time to use your steam credentials (because I've SteamGuard active so I need to put one time pass)

```sh
docker run -it -v steam_gmod_test:/steam -e INSTALL_APPS=740250 -e BETA_NAME=headless-client -e BETA_KEY=**** -e FORCE_INSTALL=yes -e LOGIN=shagril nocturlab/steamcmd
```
Don't forget to change **** with your beta key.

Now you have your files in the /var/lib/docker/volumes/steam_neosvr/_data/740250/

You can edit configuration files.

Restart you Stack and Go !
