#!/bin/bash

run_script(){
    if [[  -f "$INIT_SCRIPT"  ]]; then
        echo "Waiting for daemon to come online";
        wget --retry-connrefused --tries=100 -q --wait=3 --spider localhost:58683
        echo "Running script $INIT_SCRIPT";
        eval $INIT_SCRIPT;
    fi
}

cd /data

#Download bootstrap
if [[ ! -f "blk0001.dat" ]] 
then
    echo Downloading bootstrap file;
    wget https://www.vericoin.info/downloads/bootstrap_VRM.zip;
    unzip bootstrap_VRM.zip;

    #if verium.conf exists dont overwrite it
    if [[ -f "verium.conf" ]]; then
        rm bootstrap/verium.conf;  
    fi

    mv bootstrap/* .;
    rm bootstrap_VRM.zip;
fi

#Edit vericoin.conf
if ! grep -q "rpcuser" verium.conf ;then
    echo "Adding rpcuser in verium.conf";
    echo "rpcuser=veriumrpc" >> verium.conf;
fi
if ! grep -q "rpcpassword" verium.conf ;then
    echo "Adding rpcpassword in verium.conf";
    PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "rpcpassword=$PASS" >> verium.conf;
fi
if ! grep -q "server" verium.conf ;then
    echo "Adding server in verium.conf";
    echo "server=1" >> verium.conf;
fi
if ! grep -q "rpcallowip" verium.conf ;then
    echo "Adding rpcallowip in verium.conf";
    echo "rpcallowip=*.*.*.*" >> verium.conf;
fi

run_script &

echo "Starting verium";
veriumd -datadir=/data -conf=/data/verium.conf -printtoconsole

