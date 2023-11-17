// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether,"Minimum entry fee is 0.01 ether");
        players.push(msg.sender);
    }

    function pickWinner() public restricted {
        uint256 index = random() % players.length;
        payable(players[index]).transfer(address(this).balance);

        delete players; // Clears the players array
    }

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players)));
    }

    function getPlayerCount() public view returns (uint256) {
        return players.length;
    }

    function getPlayerAtIndex(uint256 index) public view returns (address) {
        require(index < players.length, "Index out of range");
        return players[index];
    }

}
