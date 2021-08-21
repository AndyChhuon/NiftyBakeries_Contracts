#!/usr/bin/python3
from brownie import SimpleCollectible, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT
import os




def main():
    for i in range(5):
        token_uri = 'https://gateway.pinata.cloud/ipfs/QmaKps84bUPFX4sxWhT5b7HrdgYtRmzH7AxvHR6HT6D7tV/JSON/json'+str(i)
        dev = accounts.add(config["wallets"]["from_key"])
        print(network.show_active())
        simple_collectible = SimpleCollectible[len(SimpleCollectible) - 1]
        token_id = simple_collectible.tokenCounter()
        transaction = simple_collectible.createCollectible(token_uri, {"from": dev})
        transaction.wait(1)
        print(
            "Awesome! You can view your NFT at {}".format(
                OPENSEA_FORMAT.format(simple_collectible.address, token_id)
            )
        )
        print('Please give up to 20 minutes, and hit the "refresh metadata" button' )
