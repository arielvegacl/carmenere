pragma solidity 0.4.22;

import "./Carmenere.sol";
import "./interface/IERC721Enumerable.sol";

contract CarmenereEnumerable is Carmenere, IERC721Enumerable {

    mapping(address => uint[]) internal ownerTokenIndexes;
    mapping(uint => uint) internal tokenTokenIndexes;
    uint[] internal tokenIndexes;
    mapping(uint => uint) internal indexTokens;

    constructor(uint _initialSupply) public Carmenere(_initialSupply){
        for(uint i = 0; i < _initialSupply; i++){
            tokenTokenIndexes[i+1] = i;
            ownerTokenIndexes[creator].push(i+1);
            tokenIndexes.push(i+1);
            indexTokens[i + 1] = i;
        }

        supportedInterfaces[
            this.totalSupply.selector ^
            this.tokenByIndex.selector ^
            this.tokenOfOwnerByIndex.selector
        ] = true;
    }

    function totalSupply() external view returns (uint256){
        return tokenIndexes.length;
    }

    function tokenByIndex(uint256 _index) external view returns(uint256){
        require(_index < tokenIndexes.length);
        return tokenIndexes[_index];
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
        require(_index < balances[_owner]);
        return ownerTokenIndexes[_owner][_index];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
 
        address owner = ownerOf(_tokenId);

        require ( owner == msg.sender 
            || allowance[_tokenId] == msg.sender
            || authorised[owner][msg.sender] 
        );
        require(owner == _from);
        require(_to != 0x0);

        emit Transfer(_from, _to, _tokenId);

        owners[_tokenId] = _to;
        balances[_from]--;
        balances[_to]++;

        if(allowance[_tokenId] != 0x0){
            delete allowance[_tokenId];
        }

        uint oldIndex = tokenTokenIndexes[_tokenId];

        if(oldIndex != ownerTokenIndexes[_from].length - 1){
            ownerTokenIndexes[_from][oldIndex] = ownerTokenIndexes[_from][ownerTokenIndexes[_from].length - 1];
            tokenTokenIndexes[ownerTokenIndexes[_from][oldIndex]] = oldIndex;
        }
        ownerTokenIndexes[_from].length--;
        tokenTokenIndexes[_tokenId] = ownerTokenIndexes[_to].length;
        ownerTokenIndexes[_to].push(_tokenId);
    }

    function issueTokens(uint256 _extraTokens) public{
        require(msg.sender == creator);
        balances[msg.sender] = balances[msg.sender].add(_extraTokens);

        uint thisId;
        for(uint i = 0; i < _extraTokens; i++){
            thisId = maxId.add(i).add(1);
            tokenTokenIndexes[thisId] = ownerTokenIndexes[creator].length;
            ownerTokenIndexes[creator].push(thisId);

            indexTokens[thisId] = tokenIndexes.length;
            tokenIndexes.push(thisId);


            emit Transfer(0x0, creator, thisId);
        }

        maxId = maxId.add(_extraTokens);
    }

    function burnToken(uint256 _tokenId) external{
        address owner = ownerOf(_tokenId);
        require ( owner == msg.sender 
            || allowance[_tokenId] == msg.sender
            || authorised[owner][msg.sender]
        );
        burned[_tokenId] = true;
        balances[owner]--;

        uint oldIndex = tokenTokenIndexes[_tokenId];
        if(oldIndex != ownerTokenIndexes[owner].length - 1){
            ownerTokenIndexes[owner][oldIndex] = ownerTokenIndexes[owner][ownerTokenIndexes[owner].length - 1];
            tokenTokenIndexes[ownerTokenIndexes[owner][oldIndex]] = oldIndex;
        }
        ownerTokenIndexes[owner].length--;
        delete tokenTokenIndexes[_tokenId];


        oldIndex = indexTokens[_tokenId];
        if(oldIndex != tokenIndexes.length - 1){
            tokenIndexes[oldIndex] = tokenIndexes[tokenIndexes.length - 1];
            indexTokens[ tokenIndexes[oldIndex] ] = oldIndex;
        }
        tokenIndexes.length--;
        delete indexTokens[_tokenId];

        emit Transfer(owner, 0x0, _tokenId);
    }
}
