#!/usr/bin/python3
from brownie import SimpleCollectible, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT


address = '0x1efbd2dd0d2341f6445e207194f8560c7181f539' #select address


def main():
    for i in range(5):
        my_contract = SimpleCollectible.at(address)
        dev = accounts.add(config["wallets"]["from_key"])
        print(network.show_active())
        token_id = my_contract.tokenCounter()
        token_uri = 'https://gateway.pinata.cloud/ipfs/QmaKps84bUPFX4sxWhT5b7HrdgYtRmzH7AxvHR6HT6D7tV/JSON/json'+str(token_id)
        transaction = my_contract.createCollectible(token_uri, {"from": dev})
        transaction.wait(1)
        print(
            "Awesome! You can view your NFT at {}".format(
                OPENSEA_FORMAT.format(address, token_id)
            )
        )
        print('Please give up to 20 minutes, and hit the "refresh metadata" button' )

