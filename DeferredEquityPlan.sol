pragma solidity ^0.5.0;

// lvl 3: equity plan
contract DeferredEquityPlan {
    uint fakenow = now;
    
    function fastforward() public {
        fakenow += 100 days;
    }

    address human_resources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    // @TODO: Set the total shares and annual distribution
    uint total_shares = 1000;
    uint annual_distribution = 250; // Four-year vesting period (250 shares/yr. = 1000 total_shares)

    uint start_time = now; // permanently store the time this contract was initialized
    uint unlock_time = now + 365 days;
    uint public distributed_shares; // starts at 0
    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        require(unlock_time < now, "Contract must be locked for 365 Days.");
        require(distributed_shares < total_shares, "Employee has reached maximum allowance in Stock comp plan");
        unlock_time = unlock_time + 365 days;
        distributed_shares = (now - start_time) / 365 days * annual_distribution;
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }

    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    // Revert any Ether back to user (not handled in this script)
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
