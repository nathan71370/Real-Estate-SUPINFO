// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "./therealestate.sol";

contract TokenHelper is TheRealEstate {
    
    function withdraw() external isOwner() {
        address payable _owner = getOwner();
        _owner.transfer(address(this).balance);
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
    
}