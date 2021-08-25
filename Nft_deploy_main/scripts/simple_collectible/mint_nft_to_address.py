#!/usr/bin/python3
from brownie import Nft_Collectible_Contract, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT


address = '0x0F7aD5881387823ad1849Fd832705fd502d583c4' #select contract address
nfts_printed = 5 #Select amount of nfts purchased
address_receiver = '0xADaBD2626f07370BCbD297a55d8d3C1AaE73577c' #select address to which nft is minted


def main():
    
    my_contract = Nft_Collectible_Contract.at(address)
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    token_id = my_contract.tokenCounter()
    transaction = my_contract.create_nft_at_address(nfts_printed, address_receiver,{"from": dev})
    transaction.wait(1)
    print(
        "Awesome! You can view your NFT at {}".format(
            OPENSEA_FORMAT.format(my_contract.address, token_id)
        )
    )
    print('Please give up to 20 minutes, and hit the "refresh metadata" button' )

