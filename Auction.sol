pragma solidity ^0.8.0;



contract AutcionCreator {
    address[] public auctions;

    function createAuction() public {
        address  newAuction = address(new Auction(msg.sender));
        auctions.push(newAuction);

    }
}

contract Auction {
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;

    enum AuctionState {Started, Running, Ended, Canceled }

    AuctionState public auctionState;

    uint public highestBindingBid;
    address public highestBidder;
    uint public bidIncrement;

    mapping(address => uint) public bids;
    constructor(address creator) {
        owner = payable(creator);
        startBlock = block.number;
        endBlock = block.number + 40230;
        ipfsHash = "";
        bidIncrement = 10;

    }

    modifier notOwner() {
        require(msg.sender != owner);
        _;
    }

    modifier afterStart() {
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd() {
        require(block.number <= endBlock);
        _;
    }

    modifier ownlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function min(uint a, uint b) pure internal returns(uint){
        if (a <= b) {
            return a;
        } else {
            return b;
        }
    }
    function placeBid() payable public notOwner afterStart beforeEnd returns(bool){
        require(auctionState == AuctionState.Running);
        require(msg.value > 0.001 ether);
        uint currentBid = bids[msg.sender] + msg.value;

        require(currentBid > highestBindingBid);
        bids[msg.sender] = currentBid;

        if(currentBid <= bids[highestBidder]) {
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        } else {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = msg.sender;
        }
        return true;

    }

    function cancelAuction() public ownlyOwner {
        auctionState = AuctionState.Canceled;
    }

    function finalizeAuction() public {
        require(auctionState == AuctionState.Canceled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);
        address payable recipient;
        uint value;

        if(auctionState == AuctionState.Canceled) {
            recipient = payable(msg.sender);
            value; bids[msg.sender];
        } else {
            if(msg.sender == owner) {
                recipient =owner;
                value = highestBindingBid;
            } else {
                if(msg.sender == highestBidder) {
                    recipient = payable(highestBidder);
                    value = bids[highestBidder];
                } else {
                    recipient =payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }

       recipient.transfer(value);

    }

}