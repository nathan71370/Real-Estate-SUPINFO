// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;
pragma abicoder v2;

import "./therealestate.sol";

contract TokenHelper is TheRealEstate {
    
    function withdraw() external isOwner() {
        address payable owner = getOwner();
        owner.transfer(address(this).balance);
    }
    
    function changeName(uint _tokenId, string calldata _newName) external onlyOwnerOf(_tokenId) {
        tokens[_tokenId].name = _newName;
    }
    
    function changeAdress(uint _tokenId, string calldata _newAdress) external onlyOwnerOf(_tokenId) {
        tokens[_tokenId].adress = _newAdress;
    }
    
    function changePrice(uint _tokenId, uint16 _price) external onlyOwnerOf(_tokenId) {
        tokens[_tokenId].price = _price;
    }

    function changeDescription(uint _tokenId, string calldata _description) external onlyOwnerOf(_tokenId) {
        tokens[_tokenId].description = _description;
    }
    
    function changeImageLink(uint _tokenId, string calldata _newImageLink) external onlyOwnerOf(_tokenId) {
        tokens[_tokenId].imageLink = _newImageLink;
    }
    
    function changeCommission(uint8 _newCommision) external isOwner() {
        commissionPercent = _newCommision;
    }
    
    function editToken(uint _tokenId, string calldata _newName, string calldata _newAdress, string calldata _description, uint16 _price, string calldata _newImageLink) external onlyOwnerOf(_tokenId) {
        tokens[_tokenId].name = _newName;
        tokens[_tokenId].adress = _newAdress;
        tokens[_tokenId].price = _price;
        tokens[_tokenId].description = _description;
        tokens[_tokenId].imageLink = _newImageLink;
        
    }
    
    function getTokensByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerTokenCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < tokens.length; i++) {
          if (tokenToOwner[i] == _owner) {
            result[counter] = i;
            counter++;
          }
        }
        return result;
    }

    function getTokensOnSaleByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerTokenOnSaleCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < tokens.length; i++) {
          if (tokenOnSaleToOwner[i] == _owner) {
            result[counter] = i;
            counter++;
          }
        }
        return result;
    }
    
    function getAllTokensOnSale() external view returns(uint[] memory) {
        return tokensOnSale;
    }
    
    
    function getName(uint _tokenId) external view returns(string memory){
        return tokens[_tokenId].name;
    }
    
    function getAdress(uint _tokenId) external view returns(string memory){
        return tokens[_tokenId].adress;
    }
    
    function getDescription(uint _tokenId) external view returns(string memory){
        return tokens[_tokenId].description;
    }
    
    function getPrice(uint _tokenId) external view returns(uint){
        return tokens[_tokenId].price;
    }
    
    function getImageLink(uint _tokenId) external view returns(string memory){
        return tokens[_tokenId].imageLink;
    }
}