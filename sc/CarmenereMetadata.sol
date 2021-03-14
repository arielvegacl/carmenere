pragma solidity 0.4.22;

import "./Carmenere.sol";
import "./interface/IERC721Metadata.sol";

contract CarmenereMetadata is Carmenere, IERC721Metadata {

    constructor(uint _initialSupply, string _name, string _symbol, string _uriBase) public Carmenere(_initialSupply){
        __name = _name;
        __symbol = _symbol;
        __uriBase = bytes(_uriBase);

        supportedInterfaces[
            this.name.selector ^
            this.symbol.selector ^
            this.tokenURI.selector
        ] = true;
    }

    bytes private __uriBase;
    string private __name;
    string private __symbol;

    function tokenURI(uint256 _tokenId) public view returns (string){

        require(isValidToken(_tokenId));

        uint maxLength = 100;
        bytes memory reversed = new bytes(maxLength);
        uint i = 0;
        while (_tokenId != 0) {
            uint remainder = _tokenId % 10;
            _tokenId /= 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(__uriBase.length + i);
        uint j;
        for (j = 0; j < __uriBase.length; j++) {
            s[j] = __uriBase[j];
        }
        for (j = 0; j < i; j++) {
            s[j + __uriBase.length] = reversed[i - 1 - j];
        }
        return string(s);
    }

    function name() external view returns (string _name){
        _name = __name;
    }

    function symbol() external view returns (string _symbol){
        _symbol = __symbol;
    }
}
