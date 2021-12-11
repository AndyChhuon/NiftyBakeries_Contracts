pragma solidity 0.6.6;


contract marketplace{

    mapping (address => mapping(uint256 => uint256)) public nft_marketplace; //nft_address, tokenid, price (in wei)
    mapping (address => uint256) public balances; //nft address to its current unclaimed secondary sales
    mapping (address => uint256) public secondary_fees; //address to its set fee in percentage for secondary market
    mapping (address => uint256) public seller_balances; //balance of seller to value claimable
    address public owner = 0x88D1342C25EA5f95B4CB83A5C133bbD3Adb2A503;
    uint256 public owner_balance;


    bool locked = false;

     constructor () public {
    }

    //Set Secondary fees for NFT Collection (default 5%)
    function set_secondary_fees(uint256 fee, address nft_address) public{ 
        require(!locked, "Reentrant call detected!"); //Prevent reentracy
        locked = true;

        require(fee>0 && fee<= 95, "invalid set fee");
        (bool success, bytes memory returnData) = nft_address.call(abi.encodeWithSignature("owner()")); 
        require(success, "couldn't find owner");
        require(msg.sender == bytesToAddress(returnData), "You are not the owner of this contract");
        secondary_fees[nft_address] = fee;  

        locked = false;


    }

    //Withdraw NFT Contract's share of secondary fees
    function withdraw_to_nft_address(address nft_address) public{ 
        require(!locked, "Reentrant call detected!"); //Prevent reentracy
        locked = true;

        require(balances[nft_address]>0, "Balance is 0");

        (bool success, ) = nft_address.call{value: balances[nft_address]}("");
        require(success, "Transfer failed.");

        balances[nft_address] = 0;
        locked = false;
        
    }

    //Withdraw to nft seller
    function withdraw_to_seller() public{ 
        require(!locked, "Reentrant call detected!"); //Prevent reentracy
        locked = true;

        require(seller_balances[msg.sender]>0, "Balance is 0");

        (bool success, ) = msg.sender.call{value: seller_balances[msg.sender]}("");
        require(success, "Transfer failed.");

        seller_balances[msg.sender] = 0;
        locked = false;

    }

    //Withdraw niftybakeries' balance (2% fee)
    function withdraw_owner() public{ 
        require(!locked, "Reentrant call detected!"); //Prevent reentracy

        locked = true;
        (bool success, ) = owner.call{value: owner_balance}("");
        require(success, "Transfer failed.");
        owner_balance = 0;
        locked = false;


    }

    //Purchase NFT from Marketplace
    function buyNft(address nft_address, uint256 tokenid) public payable { 
        require(!locked, "Reentrant call detected!"); //Prevent reentracy
        locked = true;

        if(secondary_fees[nft_address] == 0){
            secondary_fees[nft_address] = 5;
        }
        
        address addressfrom;
        require(nft_marketplace[nft_address][tokenid] > 0, "Token not for sale");
        require(msg.value >= nft_marketplace[nft_address][tokenid], "Not enough sent"); //Require price (in wei)

        
        (bool success, bytes memory returnData) = nft_address.call(abi.encodeWithSignature("getApproved(uint256)",tokenid)); //Check if contract has approval to transfer0
        require(success, "failed");
        require(address(this) == bytesToAddress(returnData), "Token was transferred or approval was removed");

        (success, returnData) = nft_address.call(abi.encodeWithSignature("ownerOf(uint256)",tokenid)); //Check if contract has approval to transfer0
        require(success, "failed");
        addressfrom= bytesToAddress(returnData);



        (success, ) = nft_address.call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)",addressfrom,msg.sender,tokenid)); /* do not leave spaces between argumets*/
        require(success, "failed");

        
        seller_balances[addressfrom] += (msg.value*(100-secondary_fees[nft_address]-2)/100);
        owner_balance+= (msg.value *2/100);
        balances[nft_address] += (secondary_fees[nft_address]*msg.value/100);
        nft_marketplace[nft_address][tokenid] = 0;

        locked = false;
    }

    //List or unnlist NFT for sale (set to 0 to unlist)
    function setnftPrice(address nft_address, uint256 tokenId, uint256 price) public { 
        require(!locked, "Reentrant call detected!"); //Prevent reentracy
        locked = true;

        (bool success, bytes memory returnData) = nft_address.call(abi.encodeWithSignature("ownerOf(uint256)",tokenId)); /* do not leave spaces between argumets*/
        require(success, "failed");
        require(msg.sender == bytesToAddress(returnData), "You are not the owner of this nft");
        nft_marketplace[nft_address][tokenId]= price;

        locked = false;

    }

    //Converts returnData to address
    function bytesToAddress(bytes memory bys) public pure returns (address addr) { 

        assembly {
             addr := mload(add(add(bys, 32), 0))
       }
    }


}   
