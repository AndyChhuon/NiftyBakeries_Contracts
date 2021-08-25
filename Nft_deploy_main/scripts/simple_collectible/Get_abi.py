import json

with open("build/Contracts/SimpleCollectible.json") as f:
    info_json = json.load(f)
abi = info_json["abi"]

print(abi)