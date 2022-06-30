pragma solidity ^0.8.2;

contract Token {

    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;

    uint public constant MAX_REWARDS =1e18

//totalsupply is to huge because is a utility token 
    uint public totalSupply = 10000000000000;
    string public name = "Loans";
    string public symbol = "LO";
    uint public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event Mint(address indexed address, uint value);
    event Burn(address indexed account, uint value);
    event rewardTo(address indexed to, uint value);
    event rewardEmpty();

    constructor() {
        balances[msg.sender] = totalSupply;
    }

//input address for show how many LoansToken have
    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    }

//Trade some LoansToken to another user
    function transfer(address to, uint value) public returns(bool) {
        require(balanceOf(msg.sender) >= value, 'balanceOf too low');
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns(bool) {
        require(balances(from) >= value, 'balance to low');
        require(allowance[from][msg.sender] >= value, 'allowance to low');
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint value) public returns(bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

//generate LoansToken
    function mint(address account, uint value) public returns(bool) {
        require(balances(account));
        balances[account] += value;
        emit Mint(account, value);
        return true;
    }

//burn LoansToken
    function burn(address account, uint value) public returns(bool) {
        require(balances(account) =< value);
        balances[account] -= value;
        emit Burn(account, value);
        return true;        
    }

//claimReward 
    function claimRewards(address payable to, uint value) public returns(uint) {
        uint balances = value < address(this).balance ? value : address(this).balance;
        if (balances > MAX_REWARDS) {
            balances = MAX_REWARDS;
        }
        if (balances > 0) {
            to.transfer(balances);
            emit rewardTo(to, balances)
        } else {
            emit rewardEmpty();
        }
        return balances
    }
}