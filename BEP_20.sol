// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "./SafeMath.sol";
interface IBEP20 {
  
  function totalSupply() external view returns (uint256);

 
  function decimals() external view returns (uint8);

 
  function symbol() external view returns (string memory);

  
  function name() external view returns (string memory);

  
  function getOwner() external view returns (address);

 
  function balanceOf(address account) external view returns (uint256);


  function transfer(address recipient, uint256 amount) external returns (bool);


  function allowance(address _owner, address spender) external view returns (uint256);


  function approve(address spender, uint256 amount) external returns (bool);


  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


  event Transfer(address indexed from, address indexed to, uint256 value);


  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Context {
  
//   constructor () internal {

//   }

  function _msgSender() internal view returns (address) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; 
    return msg.data;
  }
}

contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  
  constructor () {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  
  function owner() public view returns (address) {
    return _owner;
  }

  
  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

 
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract BEP20Token is Context, IBEP20, Ownable {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _totalSupply;
  uint8 private _decimals;
  string private _symbol;
  string private _name;

  constructor() {
    _name = "Satoshi_Nakamoto";
    _symbol = "ST";
    _decimals = 7;
    _totalSupply = 21000000;
    _balances[msg.sender] = 21000000;
    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  
  function getOwner() external view returns (address) {
    return owner();
  }

  
  function decimals() external view returns (uint8) {
    return _decimals;
  }

  
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  
  function name() external view returns (string memory) {
    return _name;
  }

  
  function totalSupply() external view returns (uint256) {
      return _totalSupply;
  }

  
  function balanceOf(address account) external view returns (uint256) {
    return _balances[account];
  }

  
  function transfer(address recipient, uint256 amount) external onlyOwner returns (bool) {
    //check amount owner
    require(amount <= _balances[msg.sender]);
    _balances[msg.sender] -= amount;
    _balances[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount);
    return true;
  }

  
  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
  }

  
  function approve(address spender, uint256 amount) external returns (bool) {
    _allowances [msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;     
  }

  
  function transferFrom(address sender, address recipient, uint256 amount) public  returns (bool) {
    //check amount spender
    require(amount <= _balances[sender]);
    //check allowed value
    require(amount <= _allowances[sender][msg.sender]);
    _balances[recipient] -= amount;
    _allowances[sender][msg.sender] -= amount;
    _balances[recipient] += amount;
    emit Transfer(sender,recipient, amount);
    return true;
  }
  
  function mint(uint256 amount) public onlyOwner returns (bool) {
    _totalSupply +=amount;
    return true;
  }

  function burn(address account, uint256 amount) internal  onlyOwner{
    transferFrom(account , address(0),amount);
  }

 
  function burnFrom(address account, uint256 amount) internal {
    transferFrom(account , address(0),amount);
  }
}