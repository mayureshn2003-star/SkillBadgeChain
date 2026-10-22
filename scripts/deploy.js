import hre from "hardhat";

async function main() {
  const registry = await hre.viem.deployContract("SkilledBadgeRegistry");
  console.log(`SkilledBadgeRegistry deployed successfully!`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});