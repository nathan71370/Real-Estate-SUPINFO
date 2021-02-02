// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "./owner.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";



contract TheRealEstate is Owner {

    using SafeMath for uint256;
 
 uint8 commissionPercent = 10;
 
 event NewToken(uint zombieId, string name, string adress, uint16 price, string imageLink);
 
 struct Token{
     string name;
     string adress;
     uint16 price; //not uint8 because we can sell houses for more then 1 million $
     string imageLink;
 }   
 
 Token[] tokens;
 
    mapping (uint => address) public tokenToOwner;
    mapping (address => uint) ownerTokenCount;
  
      modifier onlyOwnerOf(uint _tokenId) {
        require(msg.sender == tokenToOwner[_tokenId]);
        _;
      }
 
    function _createToken(string memory _name, string memory _adress, uint16 _price, string memory _imageLink) external {
        tokens.push(Token(_name, _adress, _price, _imageLink));
        uint id = tokens.length - 1;
        tokenToOwner[id] = msg.sender;
        ownerTokenCount[msg.sender] = ownerTokenCount[msg.sender].add(1);
        emit NewToken(id, _name, _adress, _price, _imageLink);
    }
    
    
 
}