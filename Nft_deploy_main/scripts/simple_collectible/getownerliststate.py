#Script gets current state of nft ownership


from brownie import Nft_Collectible_Contract, accounts, network, config

def main():

    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = Nft_Collectible_Contract[len(Nft_Collectible_Contract) - 1]
    ownernb = simple_collectible.return_equity(10, {"from": dev})
    print(ownernb)



