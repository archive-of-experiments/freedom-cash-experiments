/* SPDX-License-Identifier: GNU AFFERO GENERAL PUBLIC LICENSE Version 3

Utility:        Freedom Cash is the currency for Freedom Treasuries, Freedom Players, Freedom Workers, ...
                Freedom Cash supports peer to peer collaboration while preventing pump and dump frauds.  
                Freedom Cash reduces dependencies from exchanges by adding a buy and sell function within the smart contract itself.
                This allows to define a reasonable pricing algorithm and ensures that people do not need to waste 
                gas-, liquidity provider- and exchange fees.  

Liquidity:      The total supply of Freedom Cash is minted not to the developer or 
                deployer but to the smart contract itself (see constructor address(this)). 
                ETH liquidity is accrued automatically (see buy and sell function + freedom tribunals + freedom workers, ...). 

"Regulators":   Please think for yourself about the following while you go for a walk offline: 
                The crimes of the "governments" you worked for, seem much more dangerous to humanity 
                than the crimes which might seem to abuse freedom and privacy of public money. 
                We believe in peace over war. We believe in freedom over totalitarianism.
                We believe in reasonable good police officers over kyc and total surveillance.
                We believe in free humans.
                You have proved that all your kyc, censorship, propaganda and visions of 
                totalitarian state money called CBDC do not succeed. 
                
Wish:           Everyone who reads this with the best of intentions shall always have enough 
                Freedom Cash stored within self hosted paperwallets which shall be utilized 
                for fruitful and respectful exploration of truth and peer to peer collaboration. 
                Start small, explore and talk about freedom. */    

pragma solidity 0.8.19;
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.4/contracts/token/ERC20/ERC20.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.4/contracts/utils/math/Math.sol";

contract FreedomCash is ERC20 {

    error CheckInput();
    error TransferOfETHFailed();   
    error FosterDecentralization();

    constructor() ERC20("Freedom Cash", "FREE") {
        _mint(address(this), 360000000 * 10 ** decimals()); // total supply to contract itself 
    }
    function getBuyPrice(uint256 ethBalance, uint256 underway) public pure returns(uint256) {
        return getSellPrice(ethBalance, underway) + (271828183 * 9);
    }
    function getSellPrice(uint256 ethBalance, uint256 underway) public pure returns(uint256) {
        if (underway == 0) { return 0; }
        return Math.mulDiv(ethBalance, 10**18, underway);
    }     
    function buyFreedomCash(address receiver, uint256 requestAmount) public payable {
        if (requestAmount > 2718*(10**18)) { revert FosterDecentralization(); }
        uint256 ethAmountBeforeBuy = address(this).balance - msg.value;
        uint256 buyPrice = getBuyPrice(ethAmountBeforeBuy, getUnderway());
        uint256 amount = Math.mulDiv(msg.value, 10**decimals(), buyPrice);
        if (amount < requestAmount || requestAmount % 9 * (10**18) != 0) { revert CheckInput(); }
        this.transfer(receiver, amount);        
    }
    function sellFreedomCash(uint256 amount) public {
        if (amount % 9 * (10**18) != 0) { revert CheckInput(); }
        uint256 amountOfETH = getAmountOfETHForFC(getSellPrice(address(this).balance, getUnderway()), amount);
        if (allowance(msg.sender, address(this)) < amount) { approve(address(this), amount); }
        IERC20(address(this)).transferFrom(msg.sender, address(this), amount);
        (bool sent, ) = msg.sender.call{value: amountOfETH}("Freedom Cash");
        if (sent == false || amountOfETH == 0) { revert TransferOfETHFailed(); }
    }
    function getAmountOfETHForFC(uint256 fCPrice, uint256 fCAmount) public view returns(uint256) {
        return Math.mulDiv(fCPrice, fCAmount, 10**decimals() );
    }
    function getUnderway() public view returns(uint256) {
        return totalSupply() - balanceOf(address(this));
    }
}