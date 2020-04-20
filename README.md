# steamcmd
Steamcmd allow you to create server for games that use the steam api. Basically, it download the game in CLI.

## Usage

You can use Docker or Docker Swarm to use this image.

### Docker

You first need to create a volume to persiste the game data.
In this example, we will install the gmod server.

```sh
docker volume create steam_gmod
```

Now, you have your gmod volume you can start the server by running this command :

```sh
docker run -it --rm -v steam_gmod:/steam \
                    -e INSTALL_APPS=4020,232330,220 \
                    --restart always \
                    --name gmod-server
                    --entrypoint /entrypoint.sh \
           nocturlab/steamcmd \
           /steam/4020/srcds_run -game garrysmod \
                                 -norestart \
                                 -port 27015 \
                                 -console \
                                 -secure \
                                 +maxplayers 16 \
                                 +hostname "My Sandbox Server" \
                                 +gamemode sandbox \
                                 +map gm_construct \
                                 +host_workshop_collection **** \
                                 +authkey **** \
                                 +sv_setsteamaccount ****
```

To explain what it does, it's pretty simple.

- The -v arg will say where to persiste the directory /steam, this directory will contain the game data downloaded and the server informations
- The -e INSTALL_APPS will be an array of each game that will be installed before launching the main commands.
- The --restart always is to automatically restart the server if it was shutdown.
- The --name gmod-server is to give a name to our container.
- The -p 27015:27015 is to open your computer port to the docker, only this one can be accessed from the outside (security)
- The nocturlab/steamcmd:latest is the docker image hosted in the docker hub repository. This image was build directly using this git repository.
- All after the image name was the custom command you want to run. 

---

- The game was gmod of course.
- The norestart option is because Docker will restart it automaticaly. I think this better.
- The port is to change the port you use.
- The console option is to access to the console from the terminal. You can detach the terminal by pressing CTRL+P + CTRL+Q (Do not release CTRL) To reattach the console, just do docker attach gmod-server.
- The secure option is to use VAC. Use -insecure if you want to disable it instead.

---

- The maxplayer is the numbers of slot you want.
- The hostname is the server name.
- The gamemode is the gmod gamemode you want to use (darkrp for example).
- The map is the map name you want to load at start.
- The host_workshop_collection is the id of the collection of addons to load.
- The authkey is the [steam auth key](https://steamcommunity.com/dev/apikey).
- The sv_setsteamaccount link your steam account to your server, get it [here](https://steamcommunity.com/dev/managegameservers).


### Docker-Swarm

TODO: Write the model stack file
