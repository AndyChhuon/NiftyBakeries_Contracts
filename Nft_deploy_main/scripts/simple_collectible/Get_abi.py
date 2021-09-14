#Script get abi for contract


import json
PATH = r'C:\Users\andyc\OneDrive\Desktop\Visual Studio Code\Nft_Deployment_Website\Simple_website_preorder\Nft_Collectible_abi.json'

def main():
    with open("build/Contracts/Nft_Collectible_Contract.json") as f:
        info_json = json.load(f)
    abi = info_json["abi"]
    with open(PATH, 'w') as outfile:
        json.dump(abi, outfile)
    print(abi)