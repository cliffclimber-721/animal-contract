// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "MintingAnimalToken.sol";

contract SellAnimalToken {
    MintingAnimalToken public mintAnimalTokenAddress;

    constructor (address _mintAnimalTokenAddress) {
        mintAnimalTokenAddress = MintingAnimalToken(_mintAnimalTokenAddress);
    }

    mapping(uint256 => uint256) public animalTokenPrices;

    uint256[] public onSaleAnimalTokenArray;

    function giveSaleAnimalToken(uint256 _animalTokenId, uint256 _price) public {
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);

        require(animalTokenOwner == msg.sender, "Caller is not an animal token owner.");
        require(_price > 0, "Price has to be higher than zero.");
        require(animalTokenPrices[_animalTokenId] == 0, "Animal Token is on sale.");
        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner, address(this)), "Animal Token Owner hasn't been approved.");

        animalTokenPrices[_animalTokenId] = _price;

        onSaleAnimalTokenArray.push(_animalTokenId);
    }
}