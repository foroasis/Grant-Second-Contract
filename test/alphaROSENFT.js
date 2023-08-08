const {expect} = require("chai");


describe("alphaROSENFT contract", function () {

    it("mint nft test", async function () {
        const [owner] = await ethers.getSigners();

        const alphaROSENFT = await ethers.getContractFactory("alphaROSENFT");

        const hardhatToken = await alphaROSENFT.deploy();

        //mint nft
        await hardhatToken.mint(1357);

        // get owner nft balance
        const ownerBalance = await hardhatToken.balanceOf(owner.address, 1357);

        //check balance equal 1
        expect(1).to.equal(ownerBalance);
    });
});