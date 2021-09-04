#Script gets current state of nft ownership


from brownie import Nft_Collectible_Contract, accounts, network, config

def main():

    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = Nft_Collectible_Contract[len(Nft_Collectible_Contract) - 1]
    simple_collectible. assign_equity({"from": dev})
    test=simple_collectible._equity(0)
    print(test)
    test2=simple_collectible.equity_split(0,1)
    print(test2)
    test3 = simple_collectible.nb_shares()
    print(test3)
    test4 = simple_collectible._test_({"from": dev})
    print(test4)






'''''
def main():

    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = Nft_Collectible_Contract[len(Nft_Collectible_Contract) - 1]
    simple_collectible.return_price(8,{"from": dev})
    ownernb = simple_collectible.price()#return_price(5,{"from": dev})
    print(ownernb)

def main():

    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = Nft_Collectible_Contract[len(Nft_Collectible_Contract) - 1]
    simple_collectible.split_balance({"from": dev})
    test=simple_collectible.base_split()
    print(test)
    test2 = simple_collectible.nb_shares()
    print(test2)


'''''
