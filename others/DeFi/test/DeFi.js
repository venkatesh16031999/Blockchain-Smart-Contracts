const { ethers, network } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const WETH9 = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

const WBTC_WHALE = "0x28c6c06298d514db089934071355e5743bf21d60";
const WBTC_TOKEN = "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599";
const C_WBTC_TOKEN = "0xC11b1268C1A384e55C48c2391d8d480264A3A7F4";

describe("Single Hop Swap Test Suite", () => {
    let dai;
    let weth;
    let wbtc;
    let accounts;
    let swapContract;
    let compoundContract;

    before(async ()=> {
        accounts = await ethers.getSigners();
        dai = await ethers.getContractAt('IERC20', DAI);
        weth = await ethers.getContractAt('IWETH9', WETH9);
        wbtc = await ethers.getContractAt('IERC20', WBTC_TOKEN);

        let oneEther = ethers.utils.parseUnits("1", "ether");

        swapContract = await ethers.getContractFactory("Swap");
        swapContract = await swapContract.deploy();
        await swapContract.deployed();

        await weth.connect(accounts[0]).deposit({ value: oneEther });
        await weth.connect(accounts[0]).approve(swapContract.address, oneEther);

        await swapContract.swapExactInputSingle(oneEther);

        compoundContract = await ethers.getContractFactory("Compound");
        compoundContract = await compoundContract.deploy(WBTC_TOKEN , C_WBTC_TOKEN);
        await compoundContract.deployed();
    })  

    it("Supply to compound lending contract", async () => {
        await network.provider.request({
            method: "hardhat_impersonateAccount",
            params: [WBTC_WHALE],
        });

        const whaleAccount = await ethers.getSigner(WBTC_WHALE);

        const whaleTokenBalance = await wbtc.balanceOf(whaleAccount.address);
        await wbtc.connect(whaleAccount).transfer(accounts[0].address, whaleTokenBalance);

        const tokenBalance = await wbtc.balanceOf(accounts[0].address);
        console.log("Initial Balance", tokenBalance);
        await wbtc.connect(accounts[0]).approve(compoundContract.address, tokenBalance);
        
        await compoundContract.connect(accounts[0]).supply(tokenBalance);

        const cTokenBalance = await compoundContract.cTokenBalance();

        console.log("CToken Balance", cTokenBalance);

        await network.provider.send("evm_increaseTime", [3600 * 24 * 7]);
        await network.provider.send("evm_mine");

        await compoundContract.redeem(cTokenBalance);

        const contractTokenBalance = await wbtc.balanceOf(compoundContract.address);
        console.log("Final Balance", contractTokenBalance);
    })
}) 