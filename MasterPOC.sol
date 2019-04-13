pragma solidity ^0.4.25;

contract MasterPOC {

    // @notice Assignment defines details of an assignment
    struct Assignment {
      address assignor;
      address assignee;
      uint priceInEth;
      uint numTransferred;
      bool confirmed;
    }

    event AssignmentExecuted (
      address assignor,
      address assignee,
      uint priceInEth,
      uint numTransferred
    );

    address[] public contracts;
    // @notice ERC20 address -> Assignment number -> Assignment
    mapping (address => mapping(uint => Assignment)) public assignmentHistory;

    // @notice ERC20 address -> user address -> # tokens owned
    mapping (address => mapping(address => tokensOwned)) public tokensByOwner;

    // @notice ERC20 address -> Assignment index (defaults to 0)
    mapping (address => uint) public currAssignment; 

    address public lastContractAddress;
    address private owner;
    
    event newProofClaimContract (
       address contractAddress
    );

    constructor()
        public
    {
        owner = msg.sender;
    }

    modifier onlyOwner(address _owner) {
      require (msg.sender == _owner);
    }

    function getContractCount()
        public
        constant
        returns(uint contractCount)
    {
        return contracts.length;
    }

    function newProofClaim(string symbol, string name, address owner)
        public
        returns(address newContract)
    {
        uint supply = 100000000000000000000;
        ProofClaim c = new ProofClaim(symbol, name, owner, supply);
        contracts.push(address(c));
        lastContractAddress = address(c);

        tokensByOwner[address(c)][owner] = supply;
        emit newProofClaimContract(c);
        return c;
    }

    function seeProofClaim(uint pos)
        public
        constant
        returns(address contractAddress)
    {
        return address(contracts[pos]);
    }

    function recordAssignment(address _contract, address _assignor, address _assignee, uint _priceInEth, uint _numTransferred) public onlyOwner (msg.sender) {
      Assignment memory _assignment = Assignment({
        assignor: _assignor,
        assignee: _assignee,
        priceInEth: _priceInEth,
        numTransferred: _numTransferred,
        confirmed: false
      });
      
      assignmentHistory[_contract][currAssignment[_contract]++] = _assignment;
    }

    function executeAssignment(address _contract, uint _assignmentNum) {
      // require ERC20 balance of Assignee to be > than _numtransferred 
      uint assignorTokens = ProofClaim(_contract).balanceOf(msg.sender);
      Assignment memory _assignment = assignmentHistory[_contract][msg.sender];
      require (msg.sender == _assignment.assignor);
      require (assignoreTokens >= assignment.numTransferred);

      ProofClaim(_contract).transfer(_assignment.assignee, _assignment.numTransferred);

      emit AssignmentExecuted(
      _assignment.assignor,
      _assignment.assignee,
      _assignment.priceInEth,
      _assignment.numTransferred
      );      
    }
}

contract SafeMath {
	function safeAdd(uint a, uint b) public pure returns (uint c) {
    	c = a + b;
    	require(c >= a);
	}
	function safeSub(uint a, uint b) public pure returns (uint c) {
    	require(b <= a);
    	c = a - b;
	}
	function safeMul(uint a, uint b) public pure returns (uint c) {
    	c = a * b;
    	require(a == 0 || c / a == b);
	}
	function safeDiv(uint a, uint b) public pure returns (uint c) {
    	require(b > 0);
    	c = a / b;
	}
}

contract ERC20Interface {
	function totalSupply() public constant returns (uint);
	function balanceOf(address tokenOwner) public constant returns (uint balance);
	function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
	function transfer(address to, uint tokens) public returns (bool success);
	function approve(address spender, uint tokens) public returns (bool success);
	function transferFrom(address from, address to, uint tokens) public returns (bool success);

	event Transfer(address indexed from, address indexed to, uint tokens);
	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ApproveAndCallFallBack {
	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

contract Owned {
	address public owner;
	address public newOwner;

	event OwnershipTransferred(address indexed _from, address indexed _to);

	constructor() public {
    	owner = msg.sender;
	}

	modifier onlyOwner {
    	require(msg.sender == owner);
    	_;
	}

	function transferOwnership(address _newOwner) public onlyOwner {
    	newOwner = _newOwner;
	}
	function acceptOwnership() public {
    	require(msg.sender == newOwner);
    	emit OwnershipTransferred(owner, newOwner);
    	owner = newOwner;
    	newOwner = address(0);
	}
}

contract ProofClaim is ERC20Interface, Owned, SafeMath {
	string public symbol;
	string public  name;
	uint8 public decimals;
	uint public _totalSupply;

	mapping(address => uint) balances;
	mapping(address => mapping(address => uint)) allowed;
    
constructor(string _symbol, string _name, address _owner, _supply) public {
    	symbol = _symbol;
    	name = _name;
    	decimals = 18;
    	_totalSupply = _supply;
    	balances[_owner] = _totalSupply;
    	emit Transfer(address(0), _owner, _totalSupply);
}


function totalSupply() public constant returns (uint) {
    	return _totalSupply  - balances[address(0)];
}

function balanceOf(address tokenOwner) public constant returns (uint balance) {
    	return balances[tokenOwner];
}

function transfer(address to, uint tokens) public returns (bool success) {
    	balances[msg.sender] = safeSub(balances[msg.sender], tokens);
    	balances[to] = safeAdd(balances[to], tokens);
    	emit Transfer(msg.sender, to, tokens);
    	return true;
}

function approve(address spender, uint tokens) public returns (bool success) {
    	allowed[msg.sender][spender] = tokens;
    	emit Approval(msg.sender, spender, tokens);
    	return true;
}

function transferFrom(address from, address to, uint tokens) public returns (bool success) {
    	balances[from] = safeSub(balances[from], tokens);
    	allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
    	balances[to] = safeAdd(balances[to], tokens);
    	emit Transfer(from, to, tokens);
    	return true;
}

function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
    	return allowed[tokenOwner][spender];
}

function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
    	allowed[msg.sender][spender] = tokens;
    	emit Approval(msg.sender, spender, tokens);
    	ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
    	return true;
}

function () public payable {
    	revert();
}

function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
    	return ERC20Interface(tokenAddress).transfer(owner, tokens);
	}
}