pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  //event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
 event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  YourToken public yourToken;
  // Token Price
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint amountOfTokens = tokensPerEth * msg.value; 
    yourToken.transfer(msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {

    // get the amount of Ether stored in this contract
        uint amount = address(this).balance;
        address owner=msg.sender;
        require(amount>0, "no enough eth");
        // send all Ether to owner
        // Owner can receive Ether since the address of owner is payable
        (bool success,) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");


  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amount) public {
     uint256 theAmount = amount/tokensPerEth;
    yourToken.transferFrom(msg.sender, address(this), amount);
     (bool sent, bytes memory data) = msg.sender.call{value: theAmount}("");
    emit SellTokens(msg.sender, amount, theAmount);
  }


}
