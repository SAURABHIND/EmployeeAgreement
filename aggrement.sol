pragma solidity ^0.4.21;

// -----------------------------------------------------------------------------------------------------------
// Ownable function
// -----------------------------------------------------------------------------------------------------------
contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}

// -----------------------------------------------------------------------------------------------------------
// Owner function through which owner can issue the certificate and bond 
// -----------------------------------------------------------------------------------------------------------
contract OwnerIssue is Ownable{
    
    string whitepaper;
    
    struct User{
        bytes32[] employeeName;
        bytes32[] degination;
        uint[] salary;
        bytes32[] dateofjoining;
        uint[] yearofbond;
    }
    
    mapping(bytes32 => User) UserAggreement;
    // UserAggreement mapping is for Struct User

    mapping(address => bytes32) employeeaddress;
    // useraddress for checking address with employeeid.
    
    mapping(bytes32 => bool) checkIssueBond;
    // checkIssueBond is used for regret issue if existance Aggrement was present.
    
    mapping(bytes32 => bool) accept;
    // aaccept for checking employee accept the Aggrement or not
    
    // -----------------------------------------------------------------------------------------------------------
    // IssueAgreement only by Owner 
    // -----------------------------------------------------------------------------------------------------------
    function IssueAgreement(address _address,bytes32 _employeeId,bytes32 _employeename,bytes32 _degination,uint _salary,bytes32 _dateofjoining,uint _yearofbond) public onlyOwner payable
    {
        require(checkIssueBond[_employeeId]==false);
        
        UserAggreement[_employeeId].employeeName.push(_employeename);
        UserAggreement[_employeeId].degination.push(_degination);
        UserAggreement[_employeeId].salary.push(_salary);
        UserAggreement[_employeeId].dateofjoining.push(_dateofjoining);
        UserAggreement[_employeeId].yearofbond.push(_yearofbond);
        checkIssueBond[_employeeId]=true;
        accept[_employeeId]=false;
        employeeaddress[_address] = _employeeId;
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // owner can see the Aggrement when employee accept the Aggrement.
    // -----------------------------------------------------------------------------------------------------------
    function employeedetails(bytes32 _employeeId) public onlyOwner constant returns(bytes32 EmployeeId ,bytes32 employeeName, bytes32 Degination, uint Salary, bytes32 DateOfJoining, uint YearOfBond)
    {
        require(accept[_employeeId]==true);
        for(uint i=0;i<UserAggreement[_employeeId].employeeName.length;i++)
        {
            return (_employeeId,UserAggreement[_employeeId].employeeName[i],UserAggreement[_employeeId].degination[i],UserAggreement[_employeeId].salary[i],UserAggreement[_employeeId].dateofjoining[i],UserAggreement[_employeeId].yearofbond[i]);
        }
    }
}


contract Aggrement is OwnerIssue
{
    // -----------------------------------------------------------------------------------------------------------
    // Constructor
    // -----------------------------------------------------------------------------------------------------------
    constructor(string _whitepaper) payable public{
        
        whitepaper = _whitepaper;
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // Read Aggrement by user
    // -----------------------------------------------------------------------------------------------------------
    function ReadAgrement(bytes32 _employeeId) public constant returns(string, bytes32 Name, bytes32 Degination, uint Salary, bytes32 DateOfJoining, uint YearOfBond)
    {
        require(checkIssueBond[_employeeId]==true);
        require(employeeaddress[msg.sender] == _employeeId);
        
        for(uint i=0;i<UserAggreement[_employeeId].employeeName.length;i++)
        {
            return(whitepaper,UserAggreement[_employeeId].employeeName[i],UserAggreement[_employeeId].degination[i],UserAggreement[_employeeId].salary[i],UserAggreement[_employeeId].dateofjoining[i],UserAggreement[_employeeId].yearofbond[i]);
        }
    }
    
    
    // -----------------------------------------------------------------------------------------------------------
    // Accept Aggrement
    // -----------------------------------------------------------------------------------------------------------
    function AcceptAggrement(bytes32 _employeeId) public payable returns(bool status,bytes32 employeeName,bytes32 degination,uint salary,bytes32 dateofjoining,uint yearofbond)
    {
        require(checkIssueBond[_employeeId]==true);
        require(accept[_employeeId]==false);
        require(employeeaddress[msg.sender] == _employeeId);
        
        accept[_employeeId]=true;
        for(uint i=0;i<UserAggreement[_employeeId].employeeName.length;i++)
        {
            return(true,UserAggreement[_employeeId].employeeName[i],UserAggreement[_employeeId].degination[i],UserAggreement[_employeeId].salary[i],UserAggreement[_employeeId].dateofjoining[i],UserAggreement[_employeeId].yearofbond[i]);
        }
    }
}


