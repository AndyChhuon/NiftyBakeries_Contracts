from brownie import marketplace, accounts, network, config

nft_address = '0xc8a4109E71B5e80010F3Da3519E20675e5B06e04'
tokenId = 2

def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    nft_marketplace = marketplace[len(marketplace) - 1]
    nft_marketplace.setnftPrice(nft_address,tokenId,{"from": dev}) #(tokenid, nft_address)
    test= nft_marketplace.test()
    print(test)