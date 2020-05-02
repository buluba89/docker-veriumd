# docker-veriumd

Docker image of veriumd daemon. 

## Getting Started

The easiest way to get started is using docker compose.

```yaml
version: "3"


services:
  veriumd:
    image: buluba89/veriumd:latest
    build:
      context: ./
    volumes:
      #Mount a local folder for vericoin data.This folder will be used 
      #for storing the blockchain as well as vericoin.conf and your wallet. 
      - /path/to/data:/data
      #You can copy your wallet in data folder or mount it like this:
      - /path/to/wallet.dat:/data/wallet.dat
    #This is needed for upnp to work
    network_mode: host
    #Forwarding ports is needed when using swarm mode or not settin 'network_mode:host'
    ports:
     - "36987:36987"
     - "36988:36988"
```

and run
```bash
docker-compose up -d
```

In the first run will generate a veriumd.conf with  rpcuser=vericoinrpc, a random rpcpassword and allow all ip for rpc. You can edit these later.

The image is using  /data  folder for verium's data (storing blockchain, verium.conf and wallet.dat). You must copy or mount you wallet there and/or edit verium.conf.




