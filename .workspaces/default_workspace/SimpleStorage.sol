pragma solidity ^0.6.0;

contract SimpleStorage {

    // INIT AS ZERO (non declared)
    uint256 favoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;



    }
    



}