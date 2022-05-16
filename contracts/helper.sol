// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "./test2.sol";
contract ZombieHelper is ZombieFeeding{
    uint levelUpFee=0.001 ether;
    modifier aboveLevel(uint _level,uint  _zombieId){
        zombies[_zombieId].level>=_level;
        _;
    }
    function withdraw()external onlyOwner{
        address payable _owner=payable(address(uint160(owner()))); //explicit cast it to address payable //uint160 is size of ethereum address
        _owner.transfer(address(this).balance);
    }
    function setLevelFee(uint _fee)external onlyOwner{
          levelUpFee=_fee;
    }
    function levelUp(uint _zombieId)external payable{
        require(msg.value==levelUpFee);
        zombies[_zombieId].level=SafeMath32.add(zombies[_zombieId].level,1);
    }
    function changeName(uint _zombieId,string calldata _newName) aboveLevel(2,_zombieId) external  onlyOwnerOf(_zombieId){
       
       zombies[_zombieId].name=_newName;
    }
    function changeDna(uint _zombieId,uint  _newDna)aboveLevel(20,_zombieId)external onlyOwnerOf(_zombieId){
        zombies[_zombieId].dna=_newDna;
    }
    function getZombiesByOwner(address _owner)external view returns(uint[] memory ){
        uint[]memory result=new uint[](ownerZombieCount[_owner]);
        uint counter=0;
        for(uint i=0;i<zombies.length;i++){
            if(zombieToOwner[i]==_owner){
                result[counter]=i;
                counter++;
            }
        }
        return result;
    }
}
//view functions do not cost gas only when it is external view 
//If a view function is called internally from another function in the same contract that is not a view function, it will still cost gas. This is because the other function creates a transaction on Ethereum, and will still need to be verified from every node. So view functions are only free when they're called externally.