#Script get abi for contract


import json
PATH = r'C:\Users\andyc\OneDrive\Desktop\Visual Studio Code\Nft_Creator_Website\creator_contract_equity_bytecode.json'

def main():
    with open("build/Contracts/Nft_Collectible_Contract_equity.json") as f:
        info_json = json.load(f)
    bytecode = info_json["bytecode"]
    with open(PATH, 'w') as outfile:
        json.dump(bytecode, outfile)
    print(bytecode)