# resonite-headless
Docker image of a Resonite headless server

Use the command `/headlesscode` in Resonite to get a betakey. Steam login is required to download the client. You'll have to disable SteamGuard, so probably create a separate Steam account for your headless server.

Sample docker-compose:
```
version: "3.3"
services:
  resonite:
    image: shadowpanther/resonite-headless:latest
    container_name: resonite-headless
    tty: true
    stdin_open: true
    environment:
      STEAMBETA: see-discord-for-headless
      STEAMBETAPASSWORD: see-discord-for-headless
      STEAMLOGIN: "your_steam_login your_steam_password"
    volumes:
      - "./Config:/Config:ro"
      - "./Logs:/Logs"
      - "/etc/localtime:/etc/localtime:ro"
    restart: unless-stopped
```

Place your `Config.json` into `Config` folder. Logs would be stored in `Logs` folder.

You probably need to set `vm.max_map_count=262144` by doing `echo "vm.max_map_count=262144" >> /etc/sysctl.conf` lest you end up with frequent GC crashes.
