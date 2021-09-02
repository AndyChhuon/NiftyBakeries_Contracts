#Script gets current state of nft ownership


from brownie import Nft_Collectible_Contract, accounts, network, config

def main():

    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = Nft_Collectible_Contract[len(Nft_Collectible_Contract) - 1]
    simple_collectible.return_price(8,{"from": dev})
    ownernb = simple_collectible.price()#return_price(5,{"from": dev})
    print(ownernb)



