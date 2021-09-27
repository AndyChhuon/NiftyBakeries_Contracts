#Script get abi for contract


import json
PATH = r'C:\Users\andyc\OneDrive\Desktop\Visual Studio Code\Nft_Creator_Website\Nft_Collectible_abi.json'

def main():
    with open("build/Contracts/Nft_Collectible_Contract_2.json") as f:
        info_json = json.load(f)
    abi = info_json["abi"]
    with open(PATH, 'w') as outfile:
        json.dump(abi, outfile)
    print(abi)