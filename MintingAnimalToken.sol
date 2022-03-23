// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintingAnimalToken is ERC721Enumerable {
    constructor() ERC721("AniToken", "ANI") {}

    mapping(uint256 => uint256) public animalTypes; // 앞 uint256은 밑에 animalTokenId를 가리키고, 뒤 uint256은 animalTypes를 가리킨다.

    function mintAnimalToken() public {
        uint256 animalTokenId = totalSupply() + 1;

        uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, animalTokenId))) % 5 + 1; // 랜덤값 생성
        
        animalTypes[animalTokenId] = animalType;
        
        _mint(msg.sender, animalTokenId);
    }
}