pragma solidity ^0.8.0;

contract Auction {
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;

    enum AuctionState {Started, Running, Ended, Canceled }

    AuctionState public auctionState;

    uint public highestBindingBid;
    address public hihgestBidder;
    uint public bidIncrement;

    mapping(address => uint) public bids;
    constructor() {
        owner = payable(msg.sender);
        startBlock = block.number;
        endBlock = block.number + 40230;
        ipfsHash = "";
        bidIncrement = 10;

    }

}