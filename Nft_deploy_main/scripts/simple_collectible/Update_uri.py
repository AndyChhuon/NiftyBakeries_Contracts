#!/usr/bin/python3
#Script changes uri of any nft

from brownie import Nft_Collectible_Contract, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT

address = '0x9a439e757c4944403170101d202c431ad926b474' #select contract address
itemId= 1 #set Id of nft to change
tokenUri = 'https://gateway.pinata.cloud/ipfs/QmaKps84bUPFX4sxWhT5b7HrdgYtRmzH7AxvHR6HT6D7tV/JSON/json0' #set tokenUri


def main():
    my_contract = Nft_Collectible_Contract.at(address)
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    transaction = my_contract.update_token_uri(itemId,tokenUri,{"from": dev})
    transaction.wait(1)
    print(
        "Awesome! You can view your NFT at {}".format(
            OPENSEA_FORMAT.format(my_contract.address, itemId)
        )
    )