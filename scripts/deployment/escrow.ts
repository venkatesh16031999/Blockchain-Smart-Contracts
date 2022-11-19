import { ethers } from "hardhat";

async function main() {
  const EscrowPayment = await ethers.getContractFactory("EscrowPayment");
  const escrowPayment = await EscrowPayment.deploy();

  await escrowPayment.deployed();

  console.log("Owner Address", await escrowPayment.owner());
  console.log("Contract Address", await escrowPayment.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
