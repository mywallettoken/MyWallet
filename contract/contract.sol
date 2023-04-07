// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        unchecked {
            uint256 c = a + b;
            assert(c >= a && c >= b);
            return c;
        }
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        unchecked {
            uint256 c = a - b;
            assert(b <= a);
            return c;
        }
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        unchecked {
            uint256 c = a * b;
            assert(a == 0 || c / a == b);
            return c;
        }
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        unchecked {
            assert(b > 0);
            uint256 c = a / b;
            assert(a == b * c + (a % b));
            return c;
        }
    }
}

contract Ownable {
    address public _owner;
    
    constructor() {
        _owner = msg.sender;
    }

    modifier ownerOnly() {
        require(_owner == msg.sender);
        _;
    }
}

interface IERC1155 {
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);

    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value) external;

    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values) external;

    function balanceOf(address _owner, uint256 _id) external view returns (uint256);

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);

    function setApprovalForAll(address _operator, bool _approved) external;

    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

contract MyWallet is IERC1155, Ownable {
    using SafeMath for uint256;

    mapping (address => mapping(address => bool)) internal operators;
    mapping (address => mapping(uint256 => uint256)) internal balances;

    event MintTokens(address indexed _owner, uint256[] indexed _ids, uint256[] indexed _values);
    event BurnTokens(address indexed _owner, uint256[] indexed _ids, uint256[] indexed _values);

    constructor (uint256[] memory _ids, uint256[] memory _values) {
        require(_ids.length == _values.length);
        
        uint256 id = 0;
        uint256 value = 0;

        for (uint256 index = 0; index < _ids.length; index++) {
            id = _ids[index];
            value = _values[index];

            balances[msg.sender][id] = value;
        }
    }

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value) external {
        require((operators[msg.sender][_from] == true || _from == msg.sender), "Message sender is not approved to transfer tokens.");
        require(_value > 0, "Transfer amount must be greater than 0.");
        require(balances[_from][_id] >= _value, "Balance is insufficient.");

        balances[_from][_id] = balances[_from][_id].sub(_value);
        balances[_to][_id] = balances[_to][_id].add(_value);

        emit TransferSingle(msg.sender, _from, _to, _id, _value);
    }

    function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values) external {
        require((operators[msg.sender][_from] == true || _from == msg.sender), "Message sender is not approved to transfer tokens.");
        require(_ids.length == _values.length, "Length of IDs and values are not wqual.");

        uint256 id = 0;
        uint256 value = 0;

        for (uint256 index = 0; index < _ids.length; index++) {
            id = _ids[index];
            value = _values[index];

            require(balances[_from][id] >= value, "Balance is insufficient.");
        }

        for (uint256 index = 0; index < _ids.length; index++) {
            id = _ids[index];
            value = _values[index];

            balances[_from][id] = balances[_from][id].sub(value);
            balances[_to][id] = balances[_to][id].add(value);
        }

        emit TransferBatch(msg.sender, _from, _to, _ids, _values);
    }

    function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
        return balances[_owner][_id];
    }

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
        require(_owners.length == _ids.length, "Lengths of owners and ids are not equal.");

        uint256 length = _owners.length;
        uint256[] memory result = new uint256[](length);

        for (uint256 index = 0; index < length; index++) {
            result[index] = balances[_owners[index]][_ids[index]];
        }

        return result;
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        if (_approved == true) operators[_operator][msg.sender] = true;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return operators[_operator][_owner];
    }

    function mintTokens(uint256[] memory _ids, uint256[] memory _values) external ownerOnly {
        require(_ids.length == _values.length, "Lengths of ids and values are not equal.");

        uint256 id = 0;
        uint256 value = 0;

        for (uint256 index = 0; index < _ids.length; index++) {
            id = _ids[index];
            value = _values[index];

            balances[_owner][id] = balances[_owner][id].add(value);
        }

        emit MintTokens(_owner, _ids, _values);
    }

    function burnTokens(uint256[] memory _ids, uint256[] memory _values) external ownerOnly {
        require(_ids.length == _values.length, "Lengths of ids and values are not equal.");

        uint256 id = 0;
        uint256 value = 0;

        for (uint256 index = 0; index < _ids.length; index++) {
            id = _ids[index];
            value = _values[index];

            balances[_owner][id] = balances[_owner][id].sub(value);
        }

        emit BurnTokens(_owner, _ids, _values);
    }
}