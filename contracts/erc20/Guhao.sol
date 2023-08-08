// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC20.sol";
import "./Owned.sol";
import "./SafeMath.sol";

contract GuHao is IERC20 , Owned, SafeMath {

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public override totalSupply;

    constructor(){
        symbol = "kkb Token";
        name = "kkb";
        decimals = 18;
        totalSupply = 100000000000000000000000000;
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    function transfer(address recipient, uint amount) external override returns (bool) {
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],amount);
        balanceOf[recipient] = safeAdd(balanceOf[recipient], amount);
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool) {
        allowance[sender][msg.sender] = safeSub(allowance[sender][msg.sender], amount);
        balanceOf[sender] = safeSub(balanceOf[sender],amount) ;
        balanceOf[recipient] = safeAdd(balanceOf[recipient], amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external onlyOwner {
        balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);
        totalSupply = safeAdd(totalSupply, amount);
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external onlyOwner {
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],amount);
        totalSupply = safeSub(totalSupply,amount);
        emit Transfer(msg.sender, address(0), amount);
    }

}