#!/usr/bin/python3
from brownie import Nft_Collectible_Contract, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT
import os

nfts_printed = 5 #Select amount of nfts purchased



def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = Nft_Collectible_Contract[len(Nft_Collectible_Contract) - 1]
    token_id = simple_collectible.tokenCounter()
    transaction = simple_collectible.create_an_nft(nfts_printed, {"from": dev})
    transaction.wait(1)
    print(
        "Awesome! You can view your NFT at {}".format(
            OPENSEA_FORMAT.format(simple_collectible.address, token_id)
        )
    )
    print('Please give up to 20 minutes, and hit the "refresh metadata" button' )
