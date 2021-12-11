#Script get abi for contract


import json
PATH = r'C:\Users\andyc\OneDrive\Documents\Visual Studio Code-DESKTOP-UR75O5U\Nft_Creator_Website\Bakery\marketplace.json'
PATH2 = r'C:\Users\andyc\OneDrive\Documents\Visual Studio Code-DESKTOP-UR75O5U\Nft_Creator_Website\Bakery\creator_contract_equity_abi.json'

def main():
    with open("build/Contracts/marketplace.json") as f:
        info_json = json.load(f)
    abi = info_json["abi"]
    with open(PATH, 'w') as outfile:
        json.dump(abi, outfile)
    print(abi)

    with open("build/Contracts/Nft_Collectible_Contract_equity.json") as f:
        info_json = json.load(f)
    abi = info_json["abi"]
    with open(PATH2, 'w') as outfile:
        json.dump(abi, outfile)
    print(abi)


#PATH = r'C:\Users\andyc\OneDrive\Desktop\Visual Studio Code\Nft_Creator_Website\Main_Root\creator_contract_equity_abi.json'


#    with open("build/Contracts/Nft_Collectible_Contract_equity.json") as f:
