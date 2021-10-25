#!/usr/bin/python3
#Script Deploys Contract

import os
from brownie import Nft_Collectible_Contract_equity, accounts, network, config

def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    publish_source = True if os.getenv("ETHERSCAN_TOKEN") else False
    Nft_Collectible_Contract_equity.deploy('test','tst',3, False,"https://gateway.pinata.cloud/ipfs/QmdZckF24SJH1KZWE3NhVdgB4VMPtfduJnu1fKGW4vUqYu/json","0xB9e7b422E851c2d92C1a3B0C99c930eD95693918",5, True, "test",{"from": dev}, publish_source=publish_source)
    

