import {expect} from "chai";
import {ethers} from "hardhat";
import {FlashBorrower} from "../typechain";
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";

describe("FlashBorrower", function () {
    let FlashBorrower
    let owner: SignerWithAddress
    let addr1: SignerWithAddress
    let addr2: SignerWithAddress
    let sut: FlashBorrower;
    const eth = '0x0000000000000000000000000000000000000000'
    beforeEach(async function () {
        FlashBorrower = await ethers.getContractFactory("FlashBorrower");
        [owner, addr1, addr2] = await ethers.getSigners();
        sut = await FlashBorrower.deploy();
        await sut.deployed();
    });
    it("As a owner I can withdraw all the funds", async function () {
        expect(await sut.owner()).to.equal(owner.address);
        const amount = ethers.utils.parseEther("1.0")// Sends exactly 1.0 ether
        await owner.sendTransaction({
            to: sut.address,
            gasLimit: 31000,
            value: amount,
        });
        const sutBalance = await ethers.provider.getBalance(sut.address);

        expect(sutBalance).to.equal(amount);
        const ownerBalancePre = await owner.getBalance()
        const tx = await sut.connect(owner).withdraw(eth)
        await tx.wait()
        const ownerBalancePost = await owner.getBalance()

        expect(ownerBalancePost.gt(ownerBalancePre)).to.true;
        expect(await ethers.provider.getBalance(sut.address)).to.equal(0);

    })
    it("As a no Owner i can not withdraw any  funds", async function () {
        const amount = ethers.utils.parseEther("1.0")// Sends exactly 1.0 ether
        await owner.sendTransaction({
            to: sut.address,
            gasLimit: 31000,
            value: amount,
        });
        await expect(sut.connect(addr1).withdraw(eth))
            .to.be.revertedWith("Ownable: caller is not the owner");
    })

});
