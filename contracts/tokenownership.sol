// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

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
    
    function _transferToken(address _from, address _to, uint256 _tokenId) private {
        ownerTokenCount[_to] = ownerTokenCount[_to].add(1);
        ownerTokenCount[msg.sender] = ownerTokenCount[msg.sender].sub(1);
        tokenToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function putTokenToSale(address _owner, uint256 _tokenId) external onlyOwnerOf(_tokenId) {
        tokenOnSaleToOwner[_tokenId] = _owner;
    }
    
    function removeTokenFromSale(uint256 _tokenId) external onlyOwnerOf(_tokenId) {
        delete tokenOnSaleToOwner[_tokenId];
    }
    
    function _transferFrom(address _from, address _to, uint256 _tokenId) external payable {
      require (tokenToOwner[_tokenId] == msg.sender || tokenApprovals[_tokenId] == msg.sender);
      _transfer(_from, _to, _tokenId);
    }

  function approveTransaction(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
      tokenApprovals[_tokenId] = _approved;
      emit Approval(msg.sender, _approved, _tokenId);
    }
    
}