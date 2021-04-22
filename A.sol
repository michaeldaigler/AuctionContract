pragma solidity ^0.8.0;

contract A {
    address public ownerA;
    constructor(address _eoa) {
        ownerA = _eoa;
    }
    function getAddr() public view returns(address)   {
        return address(this);
    }
}

contract Creators {
    address public ownerCreator;
    address[] public deployedA;
    constructor() {
        ownerCreator = msg.sender;
    }

function deployA() public {
     A new_A = new A(msg.sender);
     address new_A_addr = new_A.getAddr();
     deployedA.push(new_A_addr);
 }
}