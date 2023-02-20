const { ethers } = require('hardhat');

async function main() {
    const MMR = await ethers.getContractFactory("MMR");
    const mmr = await MMR.deploy();
    await mmr.deployed();

    const TestAddressSet = await ethers.getContractFactory("TestAddressSet", {
        libraries: {
            MMR: mmr.address,
        }
    });
    const testAddressSet = await TestAddressSet.deploy();
    await testAddressSet.testAss();

    console.log(`address : ${testAddressSet.address}`);
}

main();