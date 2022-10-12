// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address, uint) external returns (bool);

    function transferFrom(
        address,
        address,
        uint
    ) external returns (bool);
}


/** @title A simple TokenWallet
 *  @author TG
 *  @notice with this contract you can deposit,transfer and withdraw ether
 */

 contract TokenWallet{

     IERC20 public immutable token;
     address payable owner;

     constructor(address _token){
         token = IERC20(_token);
         owner = payable(msg.sender); 
     }

     modifier onlyOwner{
         require(msg.sender == owner, "You are not owner");
         _;
     }

     /** @dev Function to receive Ether. msg.data must be empty **/
    receive() external payable {}

    function deposit(uint _amount) public{
        require(_amount < msg.sender.balance, "Amount greater than balance");
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function transfer(uint _amount, address payable _recipient) public{
        require(_amount < address(this).balance, "Amount greater than balance");
        _recipient.transfer(_amount);
    }

    function withdraw(uint _amount) external onlyOwner{ 
        payable(msg.sender).transfer(_amount);
    }

    /** @dev Fallback function is called when msg.data is not empty **/
    fallback() external payable {}

    /** @dev get balance of smart contract **/
    function getBalance() public view returns(uint){
        return address(this).balance;
    }


 }