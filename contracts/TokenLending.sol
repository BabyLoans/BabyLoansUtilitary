// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "./LoansToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenLending is Ownable {
    mapping(string => LoansToken) public loansTokens;
    mapping(string => bool) public existingLoansTokens;

    /** Admin functions */

    function addLoansToken(
        address underlyingContract,
        string memory name,
        string memory symbol,
        uint8 decimals
    ) external onlyOwner {
        LoansToken loansToken = new LoansToken(underlyingContract, name, symbol, decimals);
        loansTokens[name] = loansToken;
        existingLoansTokens[name] = true;
    }

    /** Users functions */

    /**
     * @notice supply token to a given address
     */
    function mint(string memory entry, uint256 amount) external {
        LoansToken loansToken = getLoansToken(entry);

        bool success = loansToken.mint(amount);
        require(success);
    }

    function redeem(string memory entry, uint256 amount) external {
        LoansToken loansToken = getLoansToken(entry);

        bool success = loansToken.burn(amount);
        require(success);
    }

    /** Private function */
    function getLoansToken(string memory entry) private view returns (LoansToken) {
        require(existingLoansTokens[entry]);
        return loansTokens[entry];
    }
}
