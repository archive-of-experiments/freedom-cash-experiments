// SPDX-License-Identifier: GNU AFFERO GENERAL PUBLIC LICENSE Version 3

pragma solidity 0.8.19;

interface IFreedomCash {
    function getBuyPrice(uint256 ethBalance, uint256 underway) external pure returns(uint256);
    function getSellPrice(uint256 ethBalance, uint256 underway) external pure returns(uint256);
    function buyFreedomCash(address receiver, uint256 requestAmount) external payable;
    function sellFreedomCash(uint256 amount) external;
    function getAmountOfETHForFC(uint256 fCPrice, uint256 fCAmount) external view returns(uint256);
    function getUnderway() external view returns(uint256);
}
