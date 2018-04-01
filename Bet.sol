pragma solidity ^0.4.13;

contract BetProject
{
    struct betInfo
    {
        uint price;
        uint count;
        address lastUser;
    }
    
    betInfo[] bets;
    
    uint userCount;
    uint constant userMax = 3;
    
    address winner; 
    uint lastNumber = 0;
    
    function BetProject() public 
    {
        reset();
    }
    
    function reset() internal
    {
        userCount = 0;
        
        uint count = bets.length;
        for (uint i = 0; i < count; i++)
        {
            delete bets[i];
        }
    }
    
    function bet() public payable
    {
        uint price = msg.value;
        bool finded = false;
        uint count = bets.length;
        for (uint i = 0; i < count; i++)
        {
            if(bets[i].price == price)
            {
                bets[i].count++;
                bets[i].lastUser = msg.sender;
                finded = true;
                break;
            }
        }
        
        if (!finded)
        {
            bets.push(betInfo(price,1,msg.sender));
        }
        
        userCount ++;
        
        if(userCount == userMax)
        {
            getWinner();
        }
    }
    
    function getWinner() internal returns (address)
    {
        bool finded = false;
        uint count = bets.length;
        uint minPrice = 999999 ether;
        for (uint i = 0; i < count; i++)
        {
            if (bets[i].price < minPrice && bets[i].count == 1)
            {
                winner = bets[i].lastUser;
                minPrice = bets[i].price;
                finded = true;
            }
        }
        
        reset();
        
        if (finded)
        {
            lastNumber = minPrice;
            withdraw(); 
        }
        else
        {
            lastNumber = 0;
        }
        
        return winner;
    }
    
    function getLastWinner() public constant returns (address)
    {
        return winner;
    }
    
    function getLastWinNumber() public constant returns (uint)
    {
        return lastNumber;
    }
    
    function getTotal() public constant returns (uint256)
    {
        uint256 total = address(this).balance;
        return total;
    }
    
    function withdraw() private {
        uint total = address(this).balance;
        winner.transfer(total);
    }
}
