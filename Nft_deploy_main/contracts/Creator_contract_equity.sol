// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract Nft_Collectible_Contract_equity is ERC721 {
    
    
    using Strings for string;
    uint public tokenCounter;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    address private _owner;
    address private my_address;
    address private affiliate_address;
    uint256 private owner_percentage;
    uint256 public nft_equity_percentage;
    uint256 public max_tokens;
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
    uint256 public last_split;
    uint256 public total_split;
    uint256 public current_split;
    uint256 public split_time=0;
    uint256 public nb_shares =0;
    bool public equity_differs = true;


    uint256[] public _equity;
    bool public locked_max = false;

    uint256[] public nft_level;

    mapping(uint256 => uint256[]) public equity_split; ///Split number to equity array 
    mapping(uint256 => uint256) public base_split; ///Split number to Wei per share for split
    mapping (uint256 => uint256) public split_id; ///Current split number for certain tokenid


    bool locked = false; ///re-entracy guard



    constructor (string memory nft_name, string memory nft_symbol, uint256 max, bool max_locked,string memory updated_uri, address affiliate, uint256 equity_shared, bool equity_varies) public ERC721 (nft_name, nft_symbol){
        tokenCounter = 0;
        my_address = 0xB9e7b422E851c2d92C1a3B0C99c930eD95693918; //Change
        affiliate_address = affiliate;
        max_tokens = max;
        locked_max = max_locked;
        equity_differs = equity_varies;
        nft_equity_percentage = equity_shared;

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

    function split_balance() public {
        require(block.timestamp >= split_time + 21 days || msg.sender == owner(), "Not enough time elapsed since last split"); 
        require(!locked, "Reentrant call detected!"); ///Prevent reentracy from Owner
        locked = true;
        current_balance =address(this).balance; 

        (bool success, ) = _owner.call{value:((current_balance-last_split)*(94-nft_equity_percentage)/100)}("");
        require(success, "Transfer failed.");

        (success, ) = my_address.call{value:((current_balance-last_split)*4/100)}("");
        require(success, "Transfer failed.");

        (success, ) = affiliate_address.call{value:((current_balance-last_split)*2/100)}("");
        require(success, "Transfer failed.");


        total_split=(current_balance-last_split)*nft_equity_percentage/100; ///Find balance minus unclaimed balance from last split. And split % to nft holders.
        last_split=address(this).balance; 

        
        equity_split[current_split] = _equity; ///Assigns equity array to equity_split mapping for current split
        base_split[current_split]=total_split/nb_shares; ///Gives amount of gwei per share for current split
        current_split++;
        split_time = block.timestamp;
        locked = false;
    }

    function separate_among_nft_hodlers() public payable{
        require(!locked, "Reentrant call detected!"); ///Prevent reentracy

        locked = true;

        uint256 balance_split = msg.value; 
        
        (bool success, ) = my_address.call{value:((balance_split)*4/100)}("");
        require(success, "Transfer failed.");

        (success, ) = affiliate_address.call{value:((balance_split)*2/100)}("");
        require(success, "Transfer failed.");

        total_split=(balance_split)*94/100; ///Find balance minus unclaimed balance from last split. And split 30% to nft holders.
        
        equity_split[current_split] = _equity; ///Assigns equity array to equity_split mapping for current split
        base_split[current_split]=total_split/nb_shares; ///Gives amount of gwei per share for current split
        current_split++;

        last_split= last_split + balance_split; 
        
        
        locked = false;
    }
    

    function withdraw_balance() public { //Called by nft owners
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

    function check_balance() public view returns(uint256){
        uint256 balance_to_withdraw =0;
        for(uint256 i=0; i<balanceOf(msg.sender); i++){
            uint256 id_token = tokenOfOwnerByIndex(msg.sender,i);
            uint256 split_id_token = split_id[id_token];

            while (split_id_token < current_split) {
                if (id_token < equity_split[split_id_token].length){
                    balance_to_withdraw += (equity_split[split_id_token][id_token])*base_split[split_id_token];
                    split_id_token++;
                }
                else{
                    split_id_token++;

                }
            }

        }
        return balance_to_withdraw;

    }




    function level_up(uint256 tokenId, uint256 incrementation) public onlyOwner{
        nft_level[tokenId] = nft_level[tokenId]+incrementation; ///Change equity to tokenid
    }

    function create_an_nft(uint256 amount) public payable {
        require(tokenCounter + amount <= max_tokens, "Max tokens were minted");
        require(msg.value >= calculate_nft_price(amount), "Not enough sent");
        for (uint256 i = 0; i<amount; i++){
            _safeMint(msg.sender, tokenCounter);
            _setTokenURI(tokenCounter,string(abi.encodePacked(token_uri,Strings.toString(tokenCounter))));
            if(equity_differs){
                if (random(tokenCounter)%100 == 0) {
                    _equity.push(100); ///If God, set initial equity to 100
                    nb_shares+=100;
                }else if (random(tokenCounter)%10 == 0) {
                    _equity.push(10);
                    nb_shares+=10;
                }else if (random(tokenCounter)%5 == 0) {
                    _equity.push(5);
                    nb_shares+=5;
                }else {
                    _equity.push(1);
                    nb_shares++;
                }
            }else{
                _equity.push(1);
                nb_shares++;
            }

            tokenCounter = tokenCounter + 1;
        }
    }

    function calculate_nft_price(uint256 amount) public view returns(uint256){
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
        return price;

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

    function random(uint randnum) public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, randnum)));
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
