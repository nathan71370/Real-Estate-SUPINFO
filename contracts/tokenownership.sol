// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;
pragma abicoder v2;

import "./tokenhelper.sol";

contract TokenOwnership is TokenHelper, ERC721 {
    using SafeMath for uint256;
    
    constructor() ERC721("The Real Estate Token", "TRET") {}

    mapping (uint => address) tokenApprovals;
    
    function _balanceOf(address _owner) external view returns (uint256) {
    return ownerTokenCount[_owner];
  }

  function _ownerOf(uint256 _tokenId) external view returns (address) {
    return tokenToOwner[_tokenId];
  }
    
    function _transferToken(address _to, uint256 _tokenId) private {
        ownerTokenCount[_to] = ownerTokenCount[_to].add(1);
        ownerTokenCount[tokenToOwner[_tokenId]] = ownerTokenCount[tokenToOwner[_tokenId]].sub(1);
        delete tokenOnSaleToOwner[_tokenId];
         for (uint j = 0; j < tokensOnSale.length; j++) {
            if(tokensOnSale[j] == _tokenId) {
                tokensOnSale[j] = tokensOnSale[tokensOnSale.length-1];
                tokensOnSale.pop();
            }
        }
        ownerTokenOnSaleCount[tokenToOwner[_tokenId]] = ownerTokenOnSaleCount[tokenToOwner[_tokenId]].sub(1);
        emit Transfer(tokenToOwner[_tokenId], _to, _tokenId);
        tokenToOwner[_tokenId] = _to;
    }

    function putTokenToSale(uint256 _tokenId) external onlyOwnerOf(_tokenId) {
        tokenOnSaleToOwner[_tokenId] = tokenToOwner[_tokenId];
        tokensOnSale.push(_tokenId);
        ownerTokenOnSaleCount[msg.sender] = ownerTokenOnSaleCount[msg.sender].add(1);
    }
    
    function removeTokenFromSale(uint256 _tokenId) external onlyOwnerOf(_tokenId) {
        delete tokenOnSaleToOwner[_tokenId];
        for (uint j = 0; j < tokensOnSale.length - 1; j++) {
            if(tokensOnSale[j] == _tokenId) {
                tokensOnSale[j] = tokensOnSale[tokensOnSale.length-1];
                tokensOnSale.pop();
            }
        }
        ownerTokenOnSaleCount[msg.sender] = ownerTokenOnSaleCount[msg.sender].sub(1);
    }
    
    function _transferFrom(address payable _to, uint256 _tokenId) external payable {
      require(tokenToOwner[_tokenId] != _to);
      //require (tokenToOwner[_tokenId] == msg.sender || tokenApprovals[_tokenId] == msg.sender);
      //address payable owner = getOwner();
      //owner.transfer((msg.value * commissionPercent) / 100);
      _to.transfer(msg.value);
      _transferToken(_to, _tokenId);
    }

  function approveTransaction(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
      tokenApprovals[_tokenId] = _approved;
      emit Approval(msg.sender, _approved, _tokenId);
    }

    
}