    //Creating a smart contract that uses require(), assert() and revert()
        
    // SPDX-License-Identifier: MIT
    pragma solidity >=0.8.9; 

    contract SHARE_MARKET
    {
        // Crearting our public Variables that stores the information regarding our share
        string public broker_name;
        string public share_name;
        address owner;
        uint public price_of_one_share;

        // This constructor initializes the metatags of our share
        constructor() 
        {
            broker_name = "STEVE";
            share_name = "LANEMORNE";
            price_of_one_share = 1021;
            owner = msg.sender;  
        }

        //In this our key is address of share holder account and its value is 
        //the amount of shares it hold
        mapping(address => uint) public account_share;

        //This array holds allowed holders' addresses for our share 
        address[] public Share_holder_list;

        //These are the events that will emit when shares are bought, shares are sold, shares are split
        //and when shares are transferred
        event shares_bought(address indexed account_no, uint amount);
        event shares_sold(address indexed account_no, uint amount);
        event shares_split(uint divided_in);
        event shares_transferred(address indexed sender, address indexed reciever, uint amount);

        //This function gives allowance to the new account addresses
        function Share_holding_allowance(address addr) public
        {
            Share_holder_list.push(addr);
        }

        //This function is for checking that the submitted address has allowance to trade 
        //shares or not
        function check_allowance(address addr) private view returns(bool)  
        {
            for(uint i = 0; i < Share_holder_list.length; i++)
            {
                if(Share_holder_list[i] == addr)
                {
                    return true;
                }
            }

            return false;
        }

        //this function is to buy shares
        function Shares_bought(address addr, uint amount) public
        {
            
            if(!check_allowance(addr)) // condition to check that the address has allowance 
                                 //or not
            {
                //HERE WE ARE USING REVERT TO RETURN ERROR WHEN THE ADDRESS IS NOT
                //FILED IN THE LIST OF AUTHORIZED traders WHICH IS OUR ARRAY
                revert("YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE");
            }

            account_share[addr] += amount;
            emit shares_bought(addr,amount); // emits when shares are bought
        }

        function Shares_sold(address addr, uint amount) public  
        {
            if(!check_allowance(addr)) // condition to check that the address has allowance 
                                 //or not
            {
                //HERE WE ARE USING REVERT TO RETURN ERROR WHEN THE ADDRESS IS NOT
                //FILED IN THE LIST OF AUTHORIZED BUYERS WHICH IS OUR ARRAY
                revert("YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE");
            }
        
            //Here we are using require() to check if person selling
            //holds more or equal amount of shares than they are trying
            //to sell 
            require(account_share[addr] >= amount, "YOU DO NOT HAVE ENOUGH SHARES");

            account_share[addr] -= amount;
            emit shares_sold(addr,amount); // EMIT WHEN SHARES ARE SOLD
        }

        function Shares_split(uint split_one_share_in) public
        {
            // using an assert function when to only allow the usage of this function
            // by authorised person only and if someone tries to breach it they will loose 
            // their gas 
            assert(msg.sender == owner);

            //Using a require condition to make sure the splitting factor is not 0
            require(split_one_share_in != 0, "IT CANNOT BE 0");

            //code to split
            for(uint i = 0; i < Share_holder_list.length; i++)
            {
                account_share[Share_holder_list[i]] *= split_one_share_in;
            }
            //emit when shares are split
            emit shares_split(split_one_share_in);
        }

        function Share_transferred(address sender, address reciever, uint amount) public 
        {
            if(!check_allowance(sender)) // condition to check that the address has allowance 
                                 //or not
            {
                //HERE WE ARE USING REVERT TO RETURN ERROR WHEN THE ADDRESS IS NOT
                //FILED IN THE LIST OF AUTHORIZED traders WHICH IS OUR ARRAY
                revert("YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE");
            }

            if(!check_allowance(reciever)) // condition to check that the address has allowance 
                                 //or not
            {
                //HERE WE ARE USING REVERT TO RETURN ERROR WHEN THE ADDRESS IS NOT
                //FILED IN THE LIST OF AUTHORIZED traders WHICH IS OUR ARRAY
                revert("YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE");
            }

            //Here we are using require() to check if person selling
            //holds more or equal amount of shares than they are trying
            //to sell 
            require(account_share[sender] >= amount, "YOU DO NOT HAVE ENOUGH SHARES");

            account_share[sender] -= amount;
            account_share[reciever] += amount;

            //emit when shares are transferred
            emit shares_transferred(sender, reciever, amount); 
        } 

            //function to check no. of shares
        function get_balance(address addr) public view returns (uint)
        {
            return account_share[addr];
        }

    }

