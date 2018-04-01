pragma solidity ^0.4.13;


contract Project
{
    
    struct Info
    {
        uint count;
        address lastUser;
    }
    
    uint[] PriceList;
    mapping(uint => Info) priceMapping;
    
    uint userCount = 0;
    uint maxUser = 10;
    
    address winner; 
    uint minPrice = 9999999;
    
    function Project() public
    {
        reset();
    }
    
    function reset() internal
    {
        minPrice = 9999999;
        userCount = 0;
        if(PriceList.length > 0)
        {
            for(uint i = 0; i < PriceList.length; i++)
            {
                PriceList[i] = 0;
                priceMapping[i].count = 0;
            }
        }
    }
    
    function bet() payable public
    {
        uint price = msg.value;
        uint index = 0;
        bool finded = false;
        uint count = PriceList.length;
        if( count > 0)
        {
            for(uint i = 0; i < count; i++)
            {
                if(PriceList[i] == price)
                {
                    index = i;
                    finded = true;
                    break;
                }
            }
        }
        
        if(!finded)
        {
            index = count;
        }
        
        PriceList[index] = price;
        priceMapping[index].count++;
        priceMapping[index].lastUser = msg.sender;
        userCount ++;
        
        if(userCount == maxUser)
        {
            getWinner();
            reset();
        }
    }
    
    function getWinner() internal returns (address)
    {
        bool finded = false;
        uint count = PriceList.length;
        if( count > 0)
        {
            for(uint i = 0; i < count; i++)
            {
                if(PriceList[i] < minPrice)
                {
                    if(priceMapping[i].count == 1)
                    {
                        winner = priceMapping[i].lastUser;
                        minPrice = PriceList[i];
                        finded = true;
                    }
                }
            }
        }
        
        if(finded)
        {
            withdraw();
        }
    }
    
    function getLastWinner() public constant returns (address)
    {
        return winner;
    }
    
    function getLastWinNumber() public constant returns (uint)
    {
        return minPrice;
    }
    
    function getTotal() public constant returns (uint256)
    {
        uint256 total = this.balance;
        return total;
    }
    
    function withdraw() private {
        uint total = this.balance;
        winner.transfer(total);
    }
    
}
