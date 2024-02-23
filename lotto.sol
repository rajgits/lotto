// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public players;
    address payable public winner;
    uint public upperBound = 5;

    constructor(){
        manager =msg.sender;
    }
    function participate() public payable {
        require(msg.value==1 ether, "Please pay 1 ETH min");
        players.push(payable(msg.sender));
    }
    function getBalance() public view returns (uint){
        require(manager==msg.sender,"Your not the manager");
        return address(this).balance;
    }
    function random() internal view returns(uint){
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % upperBound;
        return random;
    }
    function picWinner()public{
        require(manager==msg.sender,"Your not manager");
        require(players.length>=3,"Making Players are less than 3");
        uint r = random();
        uint index = r%players.length;
        winner = players[index];
        winner.transfer(getBalance()); //transfering the balance
        players= new address payable[](0);//players arrays back to zero
    }
}