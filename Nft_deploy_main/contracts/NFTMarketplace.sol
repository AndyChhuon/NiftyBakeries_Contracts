pragma solidity 0.6.6;


contract marketplace{

    string public test;

     constructor () public {
    }

    function buyNft(address nft_address, address addressfrom, address addressto, uint256 tokenid) public { ///Use javascript to check approved() at button click before allowing this functions. If not this contract, remove from sql
        (bool success, bytes memory returnData) = nft_address.call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)",addressfrom,addressto,tokenid)); /* do not leave spaces between argumets*/
        require(success, "failed");

    }
    function setnftPrice(address nft_address, uint256 tokenId) public { ///approve in simplecollectible contract. If success (using web3): setnftprice
        (bool success, bytes memory returnData) = nft_address.call(abi.encodeWithSignature("ownerOf(uint256)",tokenId)); /* do not leave spaces between argumets*/
        require(success, "failed");
        require(msg.sender == bytesToAddress(returnData), "You are not the owner of this nft");
        test = "yes";
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