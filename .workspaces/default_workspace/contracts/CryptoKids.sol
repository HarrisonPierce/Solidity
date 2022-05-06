//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

contract CryptoKids{
    // Owner Dad
    address owner;

    event LogKidFundingReceived(address addr, uint amount, uint contractBalance); //fires when a kid recieves money
    
    constructor() {
        owner = msg.sender; //assign address to owner(dad)
            

    }
        //define Kid
    struct Kid{ 
        address payable walletAddress;
        string firstName;
        string lastName;
        uint releaseTime; //time in .sol used uint!
        uint amount;    
        bool canWithdraw;
    }

    Kid[] public kids;

    modifier onlyOwner() { //avoid redundancy and simplify code
        require (msg.sender == owner, "only owner is able to add kids");
        _;
    }
    //add Kid to a contact
    function addKid(address payable walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner{
        kids.push(Kid(
            walletAddress,
            firstName,
            lastName,
            releaseTime,
            amount,
            canWithdraw
        ));
    }

    function balanceOf() public view returns(uint) { // only executable locally (view) uses 0 gas
        return address(this).balance;
    
    }

    //deposit funds to a contract, kids account specific
    function deposit(address walletAddress) payable public {
        addToKidsBalance(walletAddress);
}
    
    function addToKidsBalance(address walletAddress) private {
        for(uint i = 0; i < kids.length; i++ ) {                //just like java except for uint
            if(kids[i].walletAddress == walletAddress) {        //loop goes through all the potential kids wallet address and finds the one that equals desired addr.
                kids[i].amount += msg.value;                    //adds funds to desired kids wallet
            emit LogKidFundingReceived(walletAddress, msg.value, balanceOf());
            }

        }

    }
 
    function getIndex(address walletAddress) view private returns(uint) {
        for(uint i = 0; i < kids.length; i++) {
            if (kids[i].walletAddress == walletAddress) {
                return i;

            }
        }
        return 50; //returns a uint to avoid error. also never having that many kids lol

    } //gets inded of kid we want
 
    // kid able or not to withdraw money or not
    function ableToWithdraw(address walletAddress) public returns(bool) {
        uint i = getIndex(walletAddress);
        require(block.timestamp > kids[i].releaseTime, "Unable to withdraw yet!");
        if(block.timestamp > kids[i].releaseTime){ //timestamp can be potentia fraud issue when small amounts of time matter. This is years, not an issue
            kids[i].canWithdraw = true;
            return true;
        } 
        else{ 
            return false;
        
            }
        } 



    //withdraw money
    function withdraw(address payable walletAddress) payable public {
        uint i = getIndex(walletAddress);
        require(msg.sender == kids[i].walletAddress, "You must be the kid to withdraw");        //make sure each kid cannot withdraw each others $$$
        require(kids[i].canWithdraw == true, "you are not able to withdraw at this time");
        kids[i].walletAddress.transfer(kids[i].amount);
    }


}
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, "jane", "doe", 1651705349, 0, false
//0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, "jim", "doe", 1651705349, 0, false