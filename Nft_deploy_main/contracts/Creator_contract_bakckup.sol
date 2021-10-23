// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract Nft_Collectible_Contract_3 is ERC721 {
    
    
    using Strings for string;
    uint public tokenCounter;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    address private _owner;
    address private my_address;
    uint256 private max_tokens;
    string public token_uri = 'https://gateway.pinata.cloud/ipfs/QmdZckF24SJH1KZWE3NhVdgB4VMPtfduJnu1fKGW4vUqYu/json'; 
    uint256 public price1 = 0.05 ether; ///Deployed onto BSC, so ether means BNB (not ETH)
    uint256 public price2 = 0.10 ether;
    uint256 public price3 = 0.20 ether;
    uint256 public price4 = 0.40 ether;
    uint256 public price5 = 0.80 ether;
    uint256 public price6 = 1.60 ether;
    uint256 public price7 = 2.10 ether;
    uint256 public max_price1 = 750; ///(at this token id, change price). Same price until max-1
    uint256 public max_price2 = 2150;
    uint256 public max_price3 = 5500;
    uint256 public max_price4 = 9500;
    uint256 public max_price5 = 11400;
    uint256 public max_price6 = 11850;
    uint256 public max_price7 = 12000;
    uint256 public current_balance;
    bool locked_max = false;

    uint256[] public nft_level;


    bool locked = false; ///re-entracy guard



    constructor (string memory nft_name, string memory nft_symbol, uint256 max, bool max_locked,string memory updated_uri) public ERC721 (nft_name, nft_symbol){
        tokenCounter = 0;
        my_address = 0xB9e7b422E851c2d92C1a3B0C99c930eD95693918; //Change
        max_tokens = max;
        locked_max = max_locked;

        _setOwner(msg.sender);
        change_base_tokenuri(updated_uri);

    }

    receive() payable external {
  }

    //Extra functions for changing solidity values

    function change_base_tokenuri(string memory update_uri) public onlyOwner{
        token_uri = update_uri; 

    }

    function set_nft_price(uint256 nft_price1, uint256 nft_price2, uint256 nft_price3, uint256 nft_price4, uint256 nft_price5, uint256 nft_price6, uint256 nft_price7) public onlyOwner{ //Set prices for nfts in eth
        price1 = nft_price1; ///Needs to be set in wei, not eth
        price2 = nft_price2;
        price3 = nft_price3;
        price4 = nft_price4;
        price5 = nft_price5;
        price6 = nft_price6;
        price7 = nft_price7;
    }

    function set_nft_price_max_range(uint256 range_price1, uint256 range_price2, uint256 range_price3, uint256 range_price4, uint256 range_price5, uint256 range_price6, uint256 range_price7) public onlyOwner{
        max_price1 = range_price1; ///(at this token id, change price). Same price until max-1
        max_price2 = range_price2;
        max_price3 = range_price3;
        max_price4 = range_price4;
        max_price5 = range_price5;
        max_price6 = range_price6;
        max_price7 = range_price7;
    }

    function set_max_tokens(uint256 update_max) public onlyOwner {
        require(locked_max == false, "updating max tokens is locked");
        max_tokens = update_max;
    }

    //

    function withdraw_balance() public {
        require(!locked, "Reentrant call detected!"); ///Prevent reentracy
        locked = true;
        current_balance =address(this).balance; 

        (bool success, ) = _owner.call{value:((current_balance)*94/100)}("");
        require(success, "Transfer failed.");

        (success, ) = my_address.call{value:((current_balance)*6/100)}("");
        require(success, "Transfer failed.");



        locked = false;

    
    }

    function level_up(uint256 tokenId, uint256 incrementation) public onlyOwner{
        nft_level[tokenId] = nft_level[tokenId]+incrementation; ///Change equity to tokenid
    }

    function create_an_nft(uint256 amount) public payable {
    
  
        uint256 price = 0;
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
            _setTokenURI(newItemId,string(abi.encodePacked(token_uri,Strings.toString(newItemId))));
            tokenCounter = tokenCounter + 1;
        }
    }

    function create_nft_at_address (uint256 amount, address receiver) public onlyOwner {
        require(tokenCounter + amount <= max_tokens, "Max tokens were minted");
        for (uint256 i = 0; i<amount; i++){
            uint newItemId = tokenCounter;
            _safeMint(receiver, newItemId);
            _setTokenURI(newItemId, string(abi.encodePacked(token_uri,Strings.toString(newItemId))));
            tokenCounter = tokenCounter + 1;

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
