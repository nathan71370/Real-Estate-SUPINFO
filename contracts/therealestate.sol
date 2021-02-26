// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "./owner.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";


/// @title A contract to sell houses via token ERC-721
contract TheRealEstate is Owner {

    using SafeMath for uint256;
 
 uint8 commissionPercent = 10;
 
 //Event that is triggered when a new token is created
 event NewToken(uint tokenId, string name, string adress, uint16 price, string imageLink);
 
 struct Token{
     string name;
     string adress;
     uint16 price; //not uint8 because we can sell houses for more then 1 million $
     string imageLink;
 }   
 
 Token[] tokens;
 
    mapping (uint => address) public tokenToOwner;
    mapping (address => uint) ownerTokenCount;
    mapping (uint => address) public tokenOnSaleToOwner;
    mapping (address => uint) public ownerTokenOnSaleCount
  
      modifier onlyOwnerOf(uint _tokenId) {
        require(msg.sender == tokenToOwner[_tokenId]);
        _;
      }
 
 //Function to create a token 
    function _createToken(string memory _name, string memory _adress, uint16 _price, string memory _imageLink) public {
        tokens.push(Token(_name, _adress, _price, _imageLink));
        uint id = tokens.length - 1;
        tokenToOwner[id] = msg.sender;
        ownerTokenCount[msg.sender] = ownerTokenCount[msg.sender].add(1);
        emit NewToken(id, _name, _adress, _price, _imageLink);
    }
    
    
 
}