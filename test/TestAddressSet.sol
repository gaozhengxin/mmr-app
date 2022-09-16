pragma solidity ^0.8.0;

import "../contracts/mmr/AddressSet.sol";

contract TestAddressSet {
    AddressSet ass = new AddressSet();

    function testAss() public {
        ass.insert(address(0x1111));
        ass.insert(address(0x2222));
        ass.insert(address(0x3333));
        ass.insert(address(0x4444));
        address[] memory addrs = new address[](4);
        addrs[0] = address(0x5555);
        addrs[0] = address(0x6666);
        addrs[0] = address(0x7777);
        addrs[0] = address(0x8888);
        ass.insert(addrs);
        require(ass.verify(ass.getProof(address(0x1111))));
        require(ass.verify(ass.getProof(address(0x2222))));
        require(ass.verify(ass.getProof(address(0x3333))));
        require(ass.verify(ass.getProof(address(0x4444))));
        require(ass.verify(ass.getProof(address(0x5555))));
        require(ass.verify(ass.getProof(address(0x6666))));
        require(ass.verify(ass.getProof(address(0x7777))));
        require(ass.verify(ass.getProof(address(0x8888))));
        require(!ass.verify(ass.getProof(address(0x9999))));
    }
}
