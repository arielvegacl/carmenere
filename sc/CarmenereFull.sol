pragma solidity 0.4.22;

import "./CarmenereEnumerable.sol";
import "./CarmenereMetadata.sol";

contract CarmenereFull is CarmenereMetadata, CarmenereEnumerable{
    constructor(uint _initialSupply, string _name, string _symbol, string _uriBase) public CarmenereMetadata(_initialSupply, _name, _symbol, _uriBase) CarmenereEnumerable(_initialSupply){
    }
}
