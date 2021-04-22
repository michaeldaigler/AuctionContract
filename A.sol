pragma solidity ^0.8.0;

contract A {
    address public ownerA;
    constructor() {
        ownerA = msg.sender;
    }
}

contract Creators {
    address public ownerCreator;
    address[] public deployedA;
    constructor() {
        ownerCreator = msg.sender;
    }

function deployA() public {
     A new_A = new A();
     address new_A_addr = new_A.ownerA();
     deployedA.push(new_A_addr);
 }
}