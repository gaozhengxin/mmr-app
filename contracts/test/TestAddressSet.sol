pragma solidity ^0.8.0;

import "../dataChain/AddressSet.sol";

contract TestAddressSet {
    AddressSet ass = new AddressSet();
    AddressSet ass2 = new AddressSet();

    function testAss() public {
        ass.insert(address(0x1111));
        ass.insert(address(0x2222));
        ass.insert(address(0x3333));
        ass.insert(address(0x4444));
        address[] memory addrs = new address[](4);
        addrs[0] = address(0x5555);
        addrs[1] = address(0x6666);
        addrs[2] = address(0x7777);
        addrs[3] = address(0x8888);
        ass.insert(addrs);
        require(ass.verify(ass.getProof(address(0x1111))));
        require(ass.verify(ass.getProof(address(0x2222))));
        require(ass.verify(ass.getProof(address(0x3333))));
        require(ass.verify(ass.getProof(address(0x4444))));
        require(ass.verify(ass.getProof(address(0x5555))));
        require(ass.verify(ass.getProof(address(0x6666))));
        require(ass.verify(ass.getProof(address(0x7777))));
        require(ass.verify(ass.getProof(address(0x8888))));
        try ass.getProof(address(0x9999)) returns (bytes memory) {
            revert("expected to revert but returned a value");
        } catch {}
        ass2.insert(address(0x9999));
        ass2.insert(address(0xaaaa));
        ass2.insert(address(0xbbbb));
        ass2.insert(address(0xcccc));
        ass2.insert(address(0xdddd));
        ass2.insert(address(0xeeee));
        ass2.insert(address(0xffff));
        require(ass2.verify(ass2.getProof(address(0xdddd))));
        require(!ass.verify(ass2.getProof(address(0xdddd))));
        require(!ass2.verify(ass.getProof(address(0x2222))));
    }
}
