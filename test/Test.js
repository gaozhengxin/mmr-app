const { expect } = require("chai");

describe("Test MMR", function () {
    it("Test MMR", async function () {
        const MMR = await ethers.getContractFactory("MMR");
        const mmr = await MMR.deploy();
        await mmr.deployed();

        const TestMMR = await ethers.getContractFactory("TestMMR", {
            libraries: {
                MMR: mmr.address,
            }
        });
        const testMMR = await TestMMR.deploy();

        await testMMR.testMMRIndex();
        await testMMR.testMerkleMountainRange();
        await testMMR.testRollUp();
    }),
    it("Test AddressSet", async function () {
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
    })
});
