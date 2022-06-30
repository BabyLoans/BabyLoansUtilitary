pragma solidity ^0.8.2;
import "remix_tests.sol";
import "remix_accounts.sol";
import "../contracts/Token.sol";

contract TestLoansToken is Loans(20000) {

    function checkContractOwner() public {
        Assert.equal(TestsAccounts.getAccount(0), getContarctOwner(), "the instantiated owner should be the contract owner");
    }

    function checkCorrectTotalSupply() public {
        Assert.equal(totalSupply(), uint(20000), "totalSupply should be equal 20000 passed to consstructor");
        Assert.equal(balanceOf(DAO_address), uint(20000), "totalSupply should be equal 20000 passed to constructor");
    }
}