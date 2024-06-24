# SHARE_MARKET Solidity Contract

A basic share market is implemented by this Solidity contract, allowing authorized users to purchase, sell, split, and transfer shares. The utilization of `require()`, `assert()`, and `revert()` methods for error handling and business logic enforcement is demonstrated.

## Description

The `SHARE_MARKET` contract allows authorized users to:
- Buy shares
- Sell shares
- Split shares
- Transfer shares

The agreement keeps track of approved addresses and guarantees that only authorized users are able to trade shares. Additionally, it offers tools for determining how many shares an address currently owns.

## Code Explanation

### State Variables

- `string public broker_name`: Stores the name of the broker.
- `string public share_name`: Stores the name of the share.
- `address owner`: Stores the address of the contract owner.
- `uint public price_of_one_share`: Stores the price of one share.
- `mapping(address => uint) public account_share`: Maps addresses to the number of shares they hold.
- `address[] public Share_holder_list`: An array of addresses authorized to trade shares.

### Events

- `event shares_bought(address indexed account_no, uint amount)`: Emitted when shares are bought.
- `event shares_sold(address indexed account_no, uint amount)`: Emitted when shares are sold.
- `event shares_split(uint divided_in)`: Emitted when shares are split.
- `event shares_transferred(address indexed sender, address indexed receiver, uint amount)`: Emitted when shares are transferred.

### Constructor

The constructor initializes the broker name, share name, price of one share, and sets the contract owner to the address that deploys the contract.

### Functions

#### Share_holding_allowance(address addr)

Adds the given address to the list of authorized addresses.

#### check_allowance(address addr) private view returns (bool)

Checks if the given address is in the list of authorized addresses. Returns `true` if the address is authorized, otherwise returns `false`.

#### Shares_bought(address addr, uint amount)

Allows an authorized address to buy shares. Uses `revert()` to ensure the address is authorized. Emits the `shares_bought` event.

#### Shares_sold(address addr, uint amount)

Allows an authorized address to sell shares. Uses `revert()` to ensure the address is authorized and `require()` to check if the address has enough shares to sell. Emits the `shares_sold` event.

#### Shares_split(uint split_one_share_in)

Allows the contract owner to split shares. Uses `assert()` to ensure only the owner can call this function and `require()` to ensure the split factor is not zero. Emits the `shares_split` event.

#### Share_transferred(address sender, address receiver, uint amount)

Allows an authorized address to transfer shares to another authorized address. Uses `revert()` to ensure both addresses are authorized and `require()` to check if the sender has enough shares to transfer. Emits the `shares_transferred` event.

#### get_balance(address addr) public view returns (uint)

Returns the number of shares held by the given address.

**Error Conditions:**
- If the address is not authorized, the transaction is reverted with the message "YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE".

#### Shares_sold(address addr, uint amount)

Allows an authorized address to sell shares. Uses `revert()` to ensure the address is authorized and `require()` to check if the address has enough shares to sell. Emits the `shares_sold` event.

**Error Conditions:**
- If the address is not authorized, the transaction is reverted with the message "YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE".
- If the address does not have enough shares, the transaction is reverted with the message "YOU DO NOT HAVE ENOUGH SHARES".

#### Shares_split(uint split_one_share_in)

Allows the contract owner to split shares. Uses `assert()` to ensure only the owner can call this function and `require()` to ensure the split factor is not zero. Emits the `shares_split` event.

**Error Conditions:**
- If the sender is not the owner, the transaction fails due to the `assert` statement.
- If the split factor is zero, the transaction is reverted with the message "IT CANNOT BE 0".

#### Share_transferred(address sender, address receiver, uint amount)

Allows an authorized address to transfer shares to another authorized address. Uses `revert()` to ensure both addresses are authorized and `require()` to check if the sender has enough shares to transfer. Emits the `shares_transferred` event.

**Error Conditions:**
- If the sender is not authorized, the transaction is reverted with the message "YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE".
- If the receiver is not authorized, the transaction is reverted with the message "YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE".
- If the sender does not have enough shares, the transaction is reverted with the message "YOU DO NOT HAVE ENOUGH SHARES".



## Getting Started

### Prerequisites

To run this contract, you need:
- A Solidity development environment like [Remix](https://remix.ethereum.org/).

### Executing the Program

1. **Create a new file**: In Remix, create a new file with a `.sol` extension (e.g., `SHARE_MARKET.sol`).

2. **Copy and paste the code**:
    ```solidity
    // SPDX-License-Identifier: MIT
    pragma solidity >=0.8.9; 

    contract SHARE_MARKET {
        string public broker_name;
        string public share_name;
        address owner;
        uint public price_of_one_share;

        constructor() {
            broker_name = "STEVE";
            share_name = "LANEMORNE";
            price_of_one_share = 1021;
            owner = msg.sender;  
        }

        mapping(address => uint) public account_share;
        address[] public Share_holder_list;

        event shares_bought(address indexed account_no, uint amount);
        event shares_sold(address indexed account_no, uint amount);
        event shares_split(uint divided_in);
        event shares_transferred(address indexed sender, address indexed receiver, uint amount);

        function Share_holding_allowance(address addr) public {
            Share_holder_list.push(addr);
        }

        function check_allowance(address addr) private view returns(bool) {
            for(uint i = 0; i < Share_holder_list.length; i++) {
                if(Share_holder_list[i] == addr) {
                    return true;
                }
            }
            return false;
        }

        function Shares_bought(address addr, uint amount) public {
            if(!check_allowance(addr)) {
                revert("YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE");
            }
            account_share[addr] += amount;
            emit shares_bought(addr, amount);
        }

        function Shares_sold(address addr, uint amount) public {
            if(!check_allowance(addr)) {
                revert("YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE");
            }
            require(account_share[addr] >= amount, "YOU DO NOT HAVE ENOUGH SHARES");
            account_share[addr] -= amount;
            emit shares_sold(addr, amount);
        }

        function Shares_split(uint split_one_share_in) public {
            assert(msg.sender == owner);
            require(split_one_share_in != 0, "IT CANNOT BE 0");
            for(uint i = 0; i < Share_holder_list.length; i++) {
                account_share[Share_holder_list[i]] *= split_one_share_in);
            }
            emit shares_split(split_one_share_in);
        }

        function Share_transferred(address sender, address receiver, uint amount) public {
            if(!check_allowance(sender)) {
                revert("YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE");
            }
            if(!check_allowance(receiver)) {
                revert("YOU ARE NOT REGISTERED TO TRADE SHARES! FIRST GET ALLOWANCE");
            }
            require(account_share[sender] >= amount, "YOU DO NOT HAVE ENOUGH SHARES");
            account_share[sender] -= amount;
            account_share[receiver] += amount;
            emit shares_transferred(sender, receiver, amount);
        }

        function get_balance(address addr) public view returns (uint) {
            return account_share[addr];
        }
    }
    ```

3. **Compile the code**:
    - Click on the "Solidity Compiler" tab in the left-hand sidebar.
    - Make sure the "Compiler" option is set to a compatible version (e.g., `0.8.9`).
    - Click on the "Compile SHARE_MARKET.sol" button.

4. **Deploy the contract**:
    - Click on the "Deploy & Run Transactions" tab in the left-hand sidebar.
    - Select the `SHARE_MARKET` contract from the dropdown menu.
    - Click on the "Deploy" button.

5. **Interact with the contract**:
    - Use the deployed contract interface in Remix to call the various functions and interact with the contract.
    - Example interactions:
        - Call `Share_holding_allowance` to authorize a new address.
        - Call `Shares_bought` to buy shares.
        - Call `Shares_sold` to sell shares.
        - Call `Shares_split` to split shares (only the owner can call this).
        - Call `Share_transferred` to transfer shares from one address to another.
        - Call `get_balance` to check the number of shares an address holds.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
