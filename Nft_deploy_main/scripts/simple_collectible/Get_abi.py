import json

with open("build/Contracts/Nft_Collectible_Contract.json") as f:
    info_json = json.load(f)
abi = info_json["abi"]

print(abi)