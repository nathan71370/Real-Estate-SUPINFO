// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;
pragma abicoder v2;

import "./owner.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";


/// @title A contract to sell houses via token ERC-721
contract TheRealEstate is Owner {

 using SafeMath for uint256;
 
 uint8 commissionPercent = 10;
 
 //Event that is triggered when a new token is created
 event NewToken(uint tokenId, string name, string description, string adress, uint16 price, string imageLink);
 
 struct Token{
     string name;
     string adress;
     string description;
     uint16 price; //not uint8 because we can sell houses for more then 1 million $
     string imageLink;
 }   
 
 Token[] tokens;
 uint[] tokensOnSale;

 
    mapping (uint => address) public tokenToOwner;
    mapping (address => uint) public ownerTokenCount;
    mapping (uint => address) public tokenOnSaleToOwner;
    mapping (address => uint) public ownerTokenOnSaleCount;
  
      modifier onlyOwnerOf(uint _tokenId) {
        require(msg.sender == tokenToOwner[_tokenId]);
        _;
      }
 
 //Function to create a token 
    function _createToken(string memory _name, string memory _adress, string memory _description, uint16 _price, string memory _imageLink) public {
        tokens.push(Token(_name, _adress, _description, _price, _imageLink));
        uint id = tokens.length - 1;
        tokenToOwner[id] = msg.sender;
        ownerTokenCount[msg.sender] = ownerTokenCount[msg.sender].add(1);
        emit NewToken(id, _name, _adress, _description, _price, _imageLink);
    }
    
    function getToken(uint _tokenId) external view returns(Token memory) {
        return tokens[_tokenId];
    }
    
    function getAllTokens() external view returns (Token[] memory) {
        return tokens;
    }
 
}