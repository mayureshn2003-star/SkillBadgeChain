import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("SkillBadgeModule", (m) => {
  const registry = m.contract("SkillBadgeRegistry");
  return { registry };
});