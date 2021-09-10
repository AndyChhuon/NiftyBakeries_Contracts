pragma solidity 0.6.6;


contract marketplace_test{

    bytes public test;
    mapping (address => mapping(uint256 => uint256)) public nft_marketplace; ///nft_address, tokenid, price

     constructor () public {
    }

    function buyNft(address nft_address, address addressfrom, address addressto, uint256 tokenid) public { ///Handle revert: https://ethereum.stackexchange.com/questions/80755/read-message-of-require-revert-statement-in-app-js
        (bool success1, bytes memory returnData) = nft_address.call(abi.encodeWithSignature("getApproved(uint256)",tokenid));
        require(success1, "failed");
        require(address(this) == bytesToAddress(returnData), "Token was transferred or approval was removed");
        (bool success2, bytes memory returnData2) = nft_address.call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)",addressfrom,addressto,tokenid)); /* do not leave spaces between argumets*/
        require(success2, "failed");

    }
    function setnftPrice(address nft_address, uint256 tokenId, uint256 price) public { ///Set to 0 to cancel listing
        (bool success, bytes memory returnData) = nft_address.call(abi.encodeWithSignature("ownerOf(uint256)",tokenId)); /* do not leave spaces between argumets*/
        test = returnData;
        require(success, "failed");
        require(msg.sender == bytesToAddress(returnData), "You are not the owner of this nft");
        nft_marketplace[nft_address][tokenId]= price;
         ///https://ethereum.stackexchange.com/questions/83043/can-anyone-explain-how-bytes-memory-can-be-converted-to-address-type-in-solidity (convert bytes to address)
        ///string memory test = abi.decode(returnData,(string));

    }

    function bytesToAddress(bytes memory bys) public pure returns (address addr) {

        assembly {
             addr := mload(add(add(bys, 32), 0))
       }
    }



}   
///("safeTransferFrom(address, address, uint256) ", 0xB9e7b422E851c2d92C1a3B0C99c930eD95693918, 0xADaBD2626f07370BCbD297a55d8d3C1AaE73577c, 0));