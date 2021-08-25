#!/usr/bin/python3
from brownie import Nft_Collectible_Contract, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT


address = '0x0F7aD5881387823ad1849Fd832705fd502d583c4' #select contract address
nfts_printed = 5 #Select amount of nfts purchased


def main():
    
    my_contract = Nft_Collectible_Contract.at(address)
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    token_id = my_contract.tokenCounter()
    transaction = my_contract.create_an_nft(nfts_printed, {"from": dev})
    transaction.wait(1)
    print(
        "Awesome! You can view your NFT at {}".format(
            OPENSEA_FORMAT.format(my_contract.address, token_id)
        )
    )
    print('Please give up to 20 minutes, and hit the "refresh metadata" button' )

