pragma solidity 0.4.22;

import "./interface/IERC165.sol";

contract ValidaERC165 is IERC165 {
    mapping (bytes4 => bool) internal supportedInterfaces;

    constructor() public {
        supportedInterfaces[this.supportsInterface.selector] = true;
    }
   
    function supportsInterface(bytes4 interfaceID) external view returns (bool){
        return supportedInterfaces[interfaceID];
    }
}
