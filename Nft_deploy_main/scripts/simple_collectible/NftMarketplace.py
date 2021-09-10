from brownie import marketplace, accounts, network, config
from web3 import Web3

nft_address = '0xc8a4109E71B5e80010F3Da3519E20675e5B06e04'
tokenId = 16
price = 0.45
buy_addressto = '0xADaBD2626f07370BCbD297a55d8d3C1AaE73577c'

def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    nft_marketplace = marketplace[len(marketplace) - 1]
    #nft_marketplace.setnftPrice(nft_address,tokenId,price*1000000000000000000,{"from": dev}) #set price in wei
    nft_marketplace.buyNft(nft_address, buy_addressto,tokenId,{"from": dev, "value":Web3.toWei(price, "ether")}) #Set value of eth sent
    test = nft_marketplace.nft_marketplace('0xc8a4109E71B5e80010F3Da3519E20675e5B06e04', tokenId)
    print(test)
    

    #0x7148E661C6bf5124a49c9aEc1C5338969C8B99B7 (contract address)