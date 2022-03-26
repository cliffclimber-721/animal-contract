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

    // 판매등록은 주인일 때만 실행 가능
    function giveSaleAnimalToken(uint256 _animalTokenId, uint256 _price) public {
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);

        require(animalTokenOwner == msg.sender, "Caller is not an animal token owner.");
        require(_price > 0, "Price has to be higher than zero.");
        require(animalTokenPrices[_animalTokenId] == 0, "Animal Token is on sale.");
        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner, address(this)), "Animal Token Owner hasn't been approved.");

        animalTokenPrices[_animalTokenId] = _price;

        onSaleAnimalTokenArray.push(_animalTokenId);
    }

    // animalToken 사는 함수
    function purchaseAnimalToken(uint256 _animalTokenId) public payable {
        uint256 price = animalTokenPrices[_animalTokenId]; // mapping에 있는 변수를 꺼내온다
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId);

        require(price > 0, "Animal Token is not on sale.");
        require(price <= msg.value, "Caller give the price too low."); // msg.value 는 함수를 실행할 때 보내는 코인의 양을 말한다.
        require(animalTokenOwner != msg.sender, "Send it right."); // 해당 주인이 아니여야 구입이 가능하다.
    
        payable(animalTokenOwner).transfer(msg.value); // 가격만큼의 양이 토큰 주인에게 보내진다.
        mintAnimalTokenAddress.safeTransferFrom(animalTokenOwner, msg.sender, _animalTokenId);

        animalTokenPrices[_animalTokenId] = 0; 
        // animalTokenId의 값을 0으로 초기화 시켰다는 의미
        // 판매 중인 TokenArray에서 animalTokenId 만 0이라는 뜻이고, 다른 애들은 값이 존재한다.

        for(uint256 i = 0; i < onSaleAnimalTokenArray.length; i++){
            if(animalTokenPrices[onSaleAnimalTokenArray[i]] == 0) {
                onSaleAnimalTokenArray[i] = onSaleAnimalTokenArray[onSaleAnimalTokenArray.length - 1];
                onSaleAnimalTokenArray.pop();
                // 0의 값을 가진 array 하나랑 (length - 1) 한 값을 가진 거를 교체해준다 => 이걸 i 로 보낸다.
                // 맨 뒤에 값인 (length - 1) 앞으로 땡겨지고 기존에 있던 값은 사라진다.
            }
        }
    }

    function goOnSaleAnimalTokenArrayLength() view public returns (uint256) {
        return onSaleAnimalTokenArray.length; // 길이를 통해 for 문으로 판매 중인 리스트를 가지고 올 수 있도록 한다.
    }
}