#Script gets current state of nft ownership


from brownie import Nft_Collectible_Contract, accounts, network, config

def main():

    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = Nft_Collectible_Contract[len(Nft_Collectible_Contract) - 1]
    #simple_collectible.approve('0xF513252c8852f341f784EDbB34c6Be661Cffc4fB',0,{"from": dev})
    #simple_collectible.approve('0x9EFAd97a5Cb8C3d62f68f96Da52d04Ca62f3C36F',1,{"from": dev})
    test = simple_collectible.ownerOf(2)
    print(test)





#0x42a70c389b989d35a02616E593A602043203E144



'''''

def main():

    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = Nft_Collectible_Contract[len(Nft_Collectible_Contract) - 1]
    test7= simple_collectible.balance()
    print(test7)
    test=simple_collectible.current_split()
    print(test)
    test2=simple_collectible.base_split(2)
    print(test2)
    test3= simple_collectible.nb_shares()
    print(test3)
    test4 = simple_collectible.last_split()
    print(test4)
    test5 = simple_collectible.split_id(4)
    print(test5)
    test6 = simple_collectible.split_id(5)
    print(test6)

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


        test2=simple_collectible.equity_split(0,1)
    print(test2)
    test3 = simple_collectible.nb_shares()
    print(test3)
    test4 = simple_collectible._test_({"from": dev})
    print(test4)


'''''
