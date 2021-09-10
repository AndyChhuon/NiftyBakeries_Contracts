pragma solidity 0.6.6;


contract marketplace{

    mapping (address => mapping(uint256 => uint256)) public nft_marketplace; ///nft_address, tokenid, price (in wei)
    bool locked = false;

     constructor () public {
    }

    function buyNft(address nft_address, address addressto, uint256 tokenid) public payable { ///Handle revert: https://ethereum.stackexchange.com/questions/80755/read-message-of-require-revert-statement-in-app-js
        require(!locked, "Reentrant call detected!"); ///Prevent reentracy
        locked = true;
        
        address addressfrom;
        require(nft_marketplace[nft_address][tokenid] > 0, "Token not for sale");
        require(msg.value >= nft_marketplace[nft_address][tokenid], "Not enough sent"); ///Require price (in wei)

        
        (bool success, bytes memory returnData) = nft_address.call(abi.encodeWithSignature("getApproved(uint256)",tokenid)); ///Check if contract has approval to transfer0
        require(success, "failed");
        require(address(this) == bytesToAddress(returnData), "Token was transferred or approval was removed");

        (success, returnData) = nft_address.call(abi.encodeWithSignature("ownerOf(uint256)",tokenid)); ///Check if contract has approval to transfer0
        require(success, "failed");
        addressfrom= bytesToAddress(returnData);

        (success, ) = addressfrom.call{value: (msg.value*92/100)}("");
        require(success, "Transfer to seller failed.");

        (success, ) = nft_address.call{value: (msg.value*8/100)}(""); ///Change for wider applications
        require(success, "Transfer to nft contract owner failed.");


        (success, ) = nft_address.call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)",addressfrom,addressto,tokenid)); /* do not leave spaces between argumets*/
        require(success, "failed");
        nft_marketplace[nft_address][tokenid] = 0;

        locked = false;
    }
    function setnftPrice(address nft_address, uint256 tokenId, uint256 price) public { ///Set to 0 to cancel listing
        (bool success, bytes memory returnData) = nft_address.call(abi.encodeWithSignature("ownerOf(uint256)",tokenId)); /* do not leave spaces between argumets*/
        require(success, "failed");
        require(msg.sender == bytesToAddress(returnData), "You are not the owner of this nft");
        nft_marketplace[nft_address][tokenId]= price;
    }

    function bytesToAddress(bytes memory bys) public pure returns (address addr) {

        assembly {
             addr := mload(add(add(bys, 32), 0))
       }
    }


}   
