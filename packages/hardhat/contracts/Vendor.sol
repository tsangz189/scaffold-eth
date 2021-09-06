pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  YourToken yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  event BuyTokens(address buyer, uint256 amountOfEth, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amouthOfTokens, uint256 amountOfEth);

  //ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amount = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, amount);
    emit BuyTokens(msg.sender, msg.value, amount);
  }

  //ToDo: create a sellTokens() function:
  function sellTokens(uint256 amount) public {
    require(msg.sender != address(0), "cannot be address 0x00");
    require(yourToken.balanceOf(msg.sender) > amount, "insufficient amount remaining");
    uint256 allowance = yourToken.allowance(msg.sender, address(this));
    require(allowance >= amount, "Not enough allowance");
    yourToken.transferFrom(msg.sender, address(this), amount);
    // receive back eth
    uint256 ethAmount = amount/tokensPerEth;
    address payable to = payable(msg.sender);
    to.transfer(ethAmount);
    emit SellTokens(msg.sender, amount, ethAmount);
  }

  //ToDo: create a withdraw() function that lets the owner, you can 
  //use the Ownable.sol import above:
  function withdraw() public onlyOwner {
    address payable to = payable(msg.sender);
    to.transfer(address(this).balance);
  }
}
