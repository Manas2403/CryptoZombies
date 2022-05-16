// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
//a token is just a contract that keeps track of who owns how much of that token and some functions so those users can transfer their tokens to other addresses
import "./battle.sol";
import "./erc721.sol";
 contract zombieOwnership is ZombieAttack,ERC721{
     using SafeMath for uint256;
     mapping(uint=>address)zombieApprovals;
   function balanceOf(address _owner)override external view returns (uint256){
       return ownerZombieCount[_owner];
   }
   function ownerOf(uint256 _tokenId)override external view returns(address){
       return zombieToOwner[_tokenId];
   }
   function _transfer(address _from,address _to,uint256 _tokenId)private{
      ownerZombieCount[_to]= ownerZombieCount[_to].add(1);
      ownerZombieCount[_from]= ownerZombieCount[_from].sub(1);
       zombieToOwner[_tokenId]=_to;
      emit Transfer(_from, _to, _tokenId);
   }
   function transferFrom(address _from, address _to,uint256 _tokenId)override external payable{
       require(zombieToOwner[_tokenId]==msg.sender|| zombieApprovals[_tokenId]==msg.sender);
       _transfer(_from, _to, _tokenId);
   }
   function approve(address _approved,uint256 _tokenId)override external payable onlyOwnerOf(_tokenId){
       zombieApprovals[_tokenId]=_approved;
       emit Approval(msg.sender, _approved, _tokenId);
   }
}