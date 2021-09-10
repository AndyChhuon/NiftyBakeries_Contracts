// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract Nft_Collectible_Contract is ERC721 {
    
    
    using Strings for string;
    uint public tokenCounter;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    address private _owner;
    uint256 private max_tokens = 12000; ///Change when deploying
    string public basicURI1 = 'https://gateway.pinata.cloud/ipfs/QmdZckF24SJH1KZWE3NhVdgB4VMPtfduJnu1fKGW4vUqYu/json'; ///Change when deploying 
    string public basicURI2 = 'https://gateway.pinata.cloud/ipfs/QmVTqmKsTgMMLp7VyzTYxcgu925Aj5Gx2Kru7UiYNFCjgo/json'; 
    string public basicURI3 = 'https://gateway.pinata.cloud/ipfs/QmPDJuJ9rFGgrFJcr7YY1eWt63jrbHgzY9GGBKevdCTprx/json'; 
    string public godURI = 'https://gateway.pinata.cloud/ipfs/QmWwBi8D56n6zNkJUEMLXPBZEfxd2EAFKweKAXtYEt4pk9/json'; ///Change when deploying
    string public chosenURI;
    string public tokenURI;
    uint public nb_shares =0;
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
    uint256 public price;
    uint256 public current_balance;
    uint256 public last_split;
    uint256 public total_split;
    uint256 public current_split;
    uint256 public split_time;

    uint256[] public _equity;


    bool locked = false; ///re-entracy guard

    ///Call tokenUri(tokenid) to get tokenuri (check ierc721 metadata)

    //Mapping for shares for separation of profit

    mapping(uint256 => uint256[]) public equity_split; ///Split number to equity array 
    mapping(uint256 => uint256) public base_split; ///Split number to Wei per share for split
    mapping (uint256 => uint256) public split_id; ///Current split number for certain tokenid
    mapping (uint256 => uint256) public marketplace_nft_price;



    constructor () public ERC721 ("Picasso_Musks", "MUSK"){
        tokenCounter = 0;
        last_split=0;
        current_split=0;
        split_time= block.timestamp;
        _setOwner(msg.sender);
    }

    receive() payable external {
  }

    function setnftPrice(uint256 tokenId, uint256 token_price, address to) public { ///token_price in BNB and approve escrow contract
        require(msg.sender == ownerOf(tokenId), "You do not own this token");
        marketplace_nft_price[tokenId] = token_price;
        approve(to, tokenId);

    }

    function split_balance() public {
        require(block.timestamp >= split_time + 21 days || msg.sender == owner(), "Not enough time elapsed since last split"); 
        require(!locked, "Reentrant call detected!"); ///Prevent reentracy from Owner
        locked = true;
        current_balance =address(this).balance; 
        (bool success, ) = _owner.call{value:((current_balance-last_split)*7/10)}("");
        require(success, "Transfer failed.");


        total_split=(current_balance-last_split)*3/10; ///Find balance minus unclaimed balance from last split. And split 30% to nft holders.
        last_split=address(this).balance; 

        
        equity_split[current_split] = _equity; ///Assigns equity array to equity_split mapping for current split
        base_split[current_split]=total_split/nb_shares; ///Gives amount of gwei per share for current split
        current_split++;
        split_time = block.timestamp;
        locked = false;
    }
    

    function withdraw_balance() public {
        require(!locked, "Reentrant call detected!"); ///Prevent reentracy
        locked = true;
        uint256 balance_to_withdraw =0;
        for(uint256 i=0; i<balanceOf(msg.sender); i++){
            uint256 id_token = tokenOfOwnerByIndex(msg.sender,i);
            while (split_id[id_token] < current_split) {
                if (id_token < equity_split[split_id[id_token]].length){
                    balance_to_withdraw += (equity_split[split_id[id_token]][id_token])*base_split[split_id[id_token]];
                    split_id[id_token] ++;
                }
                else{
                    split_id[id_token] ++;

                }
            }

        }
        (bool success, ) = msg.sender.call{value:balance_to_withdraw}("");
        require(success, "Transfer failed.");
        last_split= last_split - balance_to_withdraw;
        locked = false;
    }

    function add_equity(uint256 tokenId, uint256 incrementation) public onlyOwner{
        _equity[tokenId] = _equity[tokenId]+incrementation; ///Change equity to tokenid
        nb_shares+=incrementation;
    }

    function findtokenURI(uint _optionId) private returns (string memory) { ///don't forget to change chances
        if (random(_optionId)%100 == 0) {
            chosenURI = godURI;
            _equity.push(100); ///If God, set initial equity to 100
            nb_shares+=100;
        }else if (random(_optionId)%3 == 0) {
            chosenURI = basicURI1;
            _equity.push(1);
            nb_shares++;
        }else if (random(_optionId)%2 == 0) {
            chosenURI = basicURI2;
            _equity.push(1);
            nb_shares++;
        }else {
            chosenURI = basicURI3;
            _equity.push(1);
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
