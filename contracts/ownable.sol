// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
/**
* @title Ownable
* @dev The Ownable contract has an owner address, and provides basic authorization control
* functions, this simplifies the implementation of "user permissions".
*/
contract Ownable{
    address private _owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    constructor(){  //not included in the final code
        _owner=msg.sender;
        emit OwnershipTransferred(address(0),_owner);
    }
    function owner()public view returns(address){
        return _owner;
    }
    //A function modifier looks just like a function, but uses the keyword modifier instead of the keyword function. And it can't be called directly like a function can — instead we can attach the modifier's name at the end of a function definition to change that function's behavior
    modifier onlyOwner() { 
        require(isOwner()); //multiple modifiers can be stacked on a function
        _;
    }
    function isOwner()public view returns(bool){
        return msg.sender==_owner;
    }
    function renounceOwnership()public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner=address(0);
    }
    function transferOwnership(address newOwner)public onlyOwner{
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner)internal {
        require(newOwner!=address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner=newOwner;
    }
}