// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract Nft_Collectible_Contract is ERC721 {
    
    
    using Strings for string;
    uint public tokenCounter;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    address private _owner;
    uint256 private max_tokens = 100; ///Change when deploying
    string public basicURI = 'https://gateway.pinata.cloud/ipfs/QmaKps84bUPFX4sxWhT5b7HrdgYtRmzH7AxvHR6HT6D7tV/JSON/json'; ///Change when deploying 
    string public godURI = 'https://gateway.pinata.cloud/ipfs/Qmdz9Y9QXUj5kSMPPCFDx5pzA1JKLyReSDYLr8iRjenPVq/Musk_test_JSON/json'; ///Change when deploying
    string public chosenURI;
    string public tokenURI;
    uint public nb_shares =0;
    uint256 public price1 = 0.01 ether; ///Deployed onto BSC, so ether means BNB (not ETH)
    uint256 public price2 = 0.02 ether;
    uint256 public price3 = 0.03 ether;
    uint256 public price4 = 0.04 ether;
    uint256 public price5 = 0.05 ether;
    uint256 public price6 = 0.06 ether;
    uint256 public price7 = 0.07 ether;
    uint256 public max_price1 = 3; ///(at this token id, change price). Same price until max-1
    uint256 public max_price2 = 5;
    uint256 public max_price3 = 7;
    uint256 public max_price4 = 9;
    uint256 public max_price5 = 11;
    uint256 public max_price6 = 13;
    uint256 public max_price7 = 15;
    uint256 public price;

    //Mapping for shares for separation of profit
    mapping (uint256 => uint256) public _equity;

    





    constructor () public ERC721 ("Picasso_Musks", "MUSK"){
        tokenCounter = 0;
        _setOwner(msg.sender);
    }


    function findtokenURI(uint _optionId) private returns (string memory) { ///don't forget to change chances
        if (random(_optionId)%2 == 0) {
            chosenURI = godURI;
            _equity[_optionId] = 100; ///If God, set initial equity to 100
            nb_shares+=100;
        }else {
            chosenURI = basicURI;
            _equity[_optionId] = 1;
            nb_shares++;
        }
        return tokenURI = string(abi.encodePacked(chosenURI,Strings.toString(_optionId)));
    }

    function random(uint randnum) public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, randnum)));
    }

    function create_an_nft(uint256 amount) public payable {
    
  
        price = 0;
        uint256 amountleft = amount;
        uint256 temptokenCounter = tokenCounter;
        ///max_price1 =5 (at this token id, change price);
        ///max_price2 =10 ;
        while(amountleft!=0){
            if (temptokenCounter<max_price1){ ///Same Price until tokenid 4 (including 4)
                if (temptokenCounter + amountleft <= max_price1){
                    price = price+(amountleft*price1);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price1){ ///Same price until tokenid 4 and move on to while loop
                    price = price + (max_price1-temptokenCounter)*price1;
                    amountleft = amountleft-(max_price1-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price1-temptokenCounter);
                }
            }else if (temptokenCounter<max_price2 && temptokenCounter>=max_price1){
                if (temptokenCounter + amountleft <= max_price2){
                    price = price+(amountleft*price2);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price2){
                    price = price + (max_price2-temptokenCounter)*price2;
                    amountleft = amountleft-(max_price2-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price2-temptokenCounter);
                }
            }else if (temptokenCounter<max_price3 && temptokenCounter>=max_price2){
                if (temptokenCounter + amountleft <= max_price3){
                    price = price+(amountleft*price3);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price3){
                    price = price + (max_price3-temptokenCounter)*price3;
                    amountleft = amountleft-(max_price3-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price3-temptokenCounter);
                }
            }else if (temptokenCounter<max_price4 && temptokenCounter>=max_price3){
                if (temptokenCounter + amountleft <= max_price4){
                    price = price+(amountleft*price4);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price4){
                    price = price + (max_price4-temptokenCounter)*price4;
                    amountleft = amountleft-(max_price4-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price4-temptokenCounter);
                }
            }else if (temptokenCounter<max_price5 && temptokenCounter>=max_price4){
                if (temptokenCounter + amountleft <= max_price5){
                    price = price+(amountleft*price5);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price5){
                    price = price + (max_price5-temptokenCounter)*price5;
                    amountleft = amountleft-(max_price5-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price5-temptokenCounter);
                }
            }else if (temptokenCounter<max_price6 && temptokenCounter>=max_price5){
                if (temptokenCounter + amountleft <= max_price6){
                    price = price+(amountleft*price6);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price6){
                    price = price + (max_price6-temptokenCounter)*price6;
                    amountleft = amountleft-(max_price6-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price6-temptokenCounter);
                }
            }else if (temptokenCounter<max_price7 && temptokenCounter>=max_price6){
                if (temptokenCounter + amountleft <= max_price7){
                    price = price+(amountleft*price7);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price7){
                    price = price + (max_price7-temptokenCounter)*price7;
                    amountleft = amountleft-(max_price7-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price7-temptokenCounter);
                }
            }
            
        }

        require(tokenCounter + amount <= max_tokens, "Max tokens were minted");
        require(msg.value >= price, "Not enough sent");
        for (uint256 i = 0; i<amount; i++){
            uint newItemId = tokenCounter;
            _safeMint(msg.sender, newItemId);
            _setTokenURI(newItemId, findtokenURI(newItemId));
            tokenCounter = tokenCounter + 1;
        }
    }


    function create_nft_at_address (uint256 amount, address receiver) public onlyOwner {
        require(tokenCounter + amount <= max_tokens, "Max tokens were minted");
        for (uint256 i = 0; i<amount; i++){
            uint newItemId = tokenCounter;
            _safeMint(receiver, newItemId);
            _setTokenURI(newItemId, findtokenURI(newItemId));
            tokenCounter = tokenCounter + 1;

        }
    }

    function return_price(uint256 amount) public returns (uint256){ ///Test purposes, remove
  
        price = 0;
        uint256 amountleft = amount;
        uint256 temptokenCounter = tokenCounter;
        ///max_price1 =5 (at this token id, change price);
        ///max_price2 =10 ;
        while(amountleft!=0){
            if (temptokenCounter<max_price1){ ///Same Price until tokenid 4 (including 4)
                if (temptokenCounter + amountleft <= max_price1){
                    price = price+(amountleft*price1);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price1){ ///Same price until tokenid 4 and move on to while loop
                    price = price + (max_price1-temptokenCounter)*price1;
                    amountleft = amountleft-(max_price1-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price1-temptokenCounter);
                }
            }else if (temptokenCounter<max_price2 && temptokenCounter>=max_price1){
                if (temptokenCounter + amountleft <= max_price2){
                    price = price+(amountleft*price2);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price2){
                    price = price + (max_price2-temptokenCounter)*price2;
                    amountleft = amountleft-(max_price2-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price2-temptokenCounter);
                }
            }else if (temptokenCounter<max_price3 && temptokenCounter>=max_price2){
                if (temptokenCounter + amountleft <= max_price3){
                    price = price+(amountleft*price3);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price3){
                    price = price + (max_price3-temptokenCounter)*price3;
                    amountleft = amountleft-(max_price3-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price3-temptokenCounter);
                }
            }else if (temptokenCounter<max_price4 && temptokenCounter>=max_price3){
                if (temptokenCounter + amountleft <= max_price4){
                    price = price+(amountleft*price4);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price4){
                    price = price + (max_price4-temptokenCounter)*price4;
                    amountleft = amountleft-(max_price4-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price4-temptokenCounter);
                }
            }else if (temptokenCounter<max_price5 && temptokenCounter>=max_price4){
                if (temptokenCounter + amountleft <= max_price5){
                    price = price+(amountleft*price5);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price5){
                    price = price + (max_price5-temptokenCounter)*price5;
                    amountleft = amountleft-(max_price5-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price5-temptokenCounter);
                }
            }else if (temptokenCounter<max_price6 && temptokenCounter>=max_price5){
                if (temptokenCounter + amountleft <= max_price6){
                    price = price+(amountleft*price6);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price6){
                    price = price + (max_price6-temptokenCounter)*price6;
                    amountleft = amountleft-(max_price6-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price6-temptokenCounter);
                }
            }else if (temptokenCounter<max_price7 && temptokenCounter>=max_price6){
                if (temptokenCounter + amountleft <= max_price7){
                    price = price+(amountleft*price7);
                    amountleft =0;
                }else if (temptokenCounter + amountleft > max_price7){
                    price = price + (max_price7-temptokenCounter)*price7;
                    amountleft = amountleft-(max_price7-temptokenCounter);
                    temptokenCounter= temptokenCounter + (max_price7-temptokenCounter);
                }
            }
            
        }

    }

    

    function update_token_uri(uint256 ItemId, string memory token_Uri) public onlyOwner{
        _setTokenURI(ItemId, token_Uri);
    }

     
    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function _msgData() internal override view virtual returns (bytes memory data) {
        return msg.data;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

}
