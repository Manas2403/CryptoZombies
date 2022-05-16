// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "./ownable.sol"; //import statements to import different contracts we make
import "./safeMath.sol";
contract ZombieFactory is Ownable {
   using SafeMath for uint256; //libraries
   using SafeMath32 for uint32;
   using SafeMath16 for uint16;
    event NewZombie(uint zombieId, string name, uint dna); //used to interact with frontend of the contract event-emit pair

    uint dnaDigits = 16;  //dna would have 16 digits
    uint dnaModulus = 10 ** dnaDigits;  //10^16 modulo 
    uint cooldownTime=1 days;
    struct Zombie {
        string name;  //struct to declare the traits of zombie it wil have  a name and dna number
        uint dna;
        uint32  level;uint32 readyTime;uint16 winCount;uint16 lossCount;
    }

    Zombie[] public zombies;  //array to store zombies

    mapping (uint => address) public zombieToOwner;  //zombie id to owner address
    mapping (address => uint) ownerZombieCount;  //number of zombies owner has

    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna,1,uint32(block.timestamp+cooldownTime),0,0));
        uint id =zombies.length -1;
        zombieToOwner[id] = msg.sender; //address of the sender connecting to  the contract
        ownerZombieCount[msg.sender]=ownerZombieCount[msg.sender].add(1);
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
