#!/bin/bash

echo ""
echo ""
echo "*** Welcome to the KEEP Random Beacon v1.2.0 testnet client install guide ***"
echo "*** Setup everything to run a testnet node without any complexity ***"
echo ""
echo ""

while true; do 
    read -rep $'Do you wish to create a keep-client folder which will contain all relevant subfolders and files ? Y/N \n' yn
    case $yn in 
        [Yy]* ) 
        mkdir -p $HOME/keep-client/config 
        mkdir -p $HOME/keep-client/keystore
        mkdir -p $HOME/keep-client/persistence; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done 

echo ""
echo ""

echo "*** We will now configure some environment variables ***"
echo "***  and make sure they remain after server restart  ***"

echo ""
echo ""

varIP=$(curl -s ipecho.net/plain)
export SERVER_IP=$varIP

read -rep $'Please enter your Infura project ID \n' infura 
export INFURA_PROJECT_ID=$infura

echo ""

read -rep $'Please enter your Ethereum wallet address \n' address 
export ETH_WALLET=$address

echo ""

read -rep $'Please enter your Ethereum wallet password. BE CAREFUL. \n' pw
export KEEP_CLIENT_ETHEREUM_PASSWORD=$pw

cat <<EOF >>$HOME/.bashrc

## Setup some environment variables
export SERVER_IP=$varIP
# Change with your ID from Infura.
export INFURA_PROJECT_ID=$infura
# Change with your ETH Wallet.
export ETH_WALLET=$address
# Enter the password in which you encrypted your wallet file with
export KEEP_CLIENT_ETHEREUM_PASSWORD=$pw

EOF

echo ""
echo ""

cd $HOME/keep-client/config
touch config.toml 

echo "*** Configuring config.toml file ***"

cat <<CONFIG >>$HOME/keep-client/config/config.toml

# Connection details of ethereum blockchain.
[ethereum]
  URL = "wss://ropsten.infura.io/ws/v3/$INFURA_PROJECT_ID"
  URLRPC = "https://ropsten.infura.io/v3/$INFURA_PROJECT_ID"


[ethereum.account]
  Address = "$ETH_WALLET"
  KeyFile = "/mnt/keep-client/keystore/keep_wallet.json"


# This address might change and need to be replaced from time to time
# if it does, the new contract address will be listed here:
# https://github.com/keep-network/keep-client/blob/master/docs/run-keep-client.adoc
[ethereum.ContractAddresses]
  KeepRandomBeaconOperator = "0xC8337a94a50d16191513dEF4D1e61A6886BF410f"
  TokenStaking = "0x234d2182B29c6a64ce3ab6940037b5C8FdAB608e"
  KeepRandomBeaconService = "0x6c04499B595efdc28CdbEd3f9ed2E83d7dCCC717"


# This addresses might change and need to be replaced from time to time
# if it does, the new contract address will be listed here:
# https://github.com/keep-network/keep-client/blob/master/docs/run-keep-client.adoc
# Addresses of applications approved by the operator.
[SanctionedApplications]
  Addresses = [
    "0xc3f96306eDabACEa249D2D22Ec65697f38c6Da69",
]

[Storage]
  DataDir = "/mnt/keep-client/persistence"
  
[LibP2P]
  Peers = ["/dns4/bootstrap-2.core.keep.test.boar.network/tcp/3001/ipfs/16Uiu2HAmQirGruZBvtbLHr5SDebsYGcq6Djw7ijF3gnkqsdQs3wK",
"/dns4/bootstrap-3.test.keep.network/tcp/3919/ipfs/16Uiu2HAm8KJX32kr3eYUhDuzwTucSfAfspnjnXNf9veVhB12t6Vf",
"/dns4/bootstrap-2.test.keep.network/tcp/3919/ipfs/16Uiu2HAmNNuCp45z5bgB8KiTHv1vHTNAVbBgxxtTFGAndageo9Dp"]
Port = 3919

 # Override the node’s default addresses announced in the network
 AnnouncedAddresses = ["/ip4/$SERVER_IP/tcp/5678"]

[TSS]
# Timeout for TSS protocol pre-parameters generation. The value
# should be provided based on resources available on the machine running the client.
# This is an optional parameter, if not provided timeout for TSS protocol
# pre-parameters generation will be set to .
  PreParamsGenerationTimeout = "2m30s"
CONFIG

echo "*** Done ***"

echo ""
echo ""


while true; do 
    read -rep $'Please manually transfer your keep_wallet.json file into the keep-client/keystore folder. Once this is done, press Y. \n' yn
    case $yn in 
        [Yy]* ) echo "Thank you."; break;;
        * ) echo "You need to transfer your keep_wallet.json file and press Y.";;
    esac
done 

echo ""
echo ""

echo "*** Congratulations, you're all set up to run a v1.2.0 Random Beacon testnet node ***"
echo "*** Please download the run_testnet_beacon_1-2-4-rc.sh script to run the node ***"
