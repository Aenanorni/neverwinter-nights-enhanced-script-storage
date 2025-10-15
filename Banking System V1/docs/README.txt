Neverwinter Nights: EE - Banking System v1.0
Author: Aenanorni

Overview
--------
This package provides a modular banking system for NWN:EE modules. Version 1.0 includes:
- Player accounts (persistent via campaign variables)
- Deposit / Withdraw gold
- Transfer between player accounts
- A simple item 'vault' that stores item template resrefs (see limitations)
- Dialog/action-ready helper scripts to hook into NPCs or placeables

Important limitations (v1.0)
----------------------------
- Accounts are identified by the PC's display name (GetName). If players change display names, their account may appear separate.
  Recommended: enable server option to bind player names to CD keys, or adapt scripts to use CD key-based identifiers.
- Vault stores **item template resrefs** (blueprint) and stack counts only. Item enchantments, custom properties, and unique states are NOT preserved.
  For full object persistence, use NWNX/NWNXEE plugins (object serialization) or adapt the vault to use those plugins.
- Vault deposit via dialog is intentionally simplified: module builders should call BANK_DepositItemFromObject(oPC, oItem) from custom scripts or create small wrapper scripts per-item template for dialog actions.

Installation (quick)
--------------------
1. Copy the /scripts/*.nss files into your module's scripts folder (Toolset -> Scripts).
2. Compile them in the toolset (or let the toolset compile on module load).
3. Place an NPC or placeable to act as a banker. In its OnSpawn, set script to bank_init.nss (optional).
4. Create a Conversation resource (or add dialog text nodes) that calls simple action scripts (see bank_dialog.nss for examples).
   - For deposit/withdraw, create dialog options whose 'Actions Taken' run small wrappers:
     - To deposit 100 gp: call script BANK_Action_Deposit100 (or create your own wrappers calling BANK_DepositGold with custom amounts).
5. (Optional) For admin tasks, you can call functions from the included scripts using DM console or small admin wrappers.

Usage examples
--------------
- Deposit 50gp from dialog: create an "Actions Taken" script on the dialog option that calls:
  BANK_DepositGold(GetPCSpeaker(), 50);

- Withdraw an item by template via dialog (example wrapper provided):
  BANK_Action_Withdraw_SampleSword()

Customization notes
-------------------
- To change storage from player name to CD key, replace GetName(oPC) usage with a CD key getter and update keys accordingly.
- To keep full item fidelity in the vault, integrate NWNX_Object_Serialize/NWNX_Object_Deserialize (requires NWNX/NWNX:EE server plugins).

Support & Credits
-----------------
See CREDITS.txt for authorship and contact. This package is intended as a starting point — please adapt for your server's persistence policy and custom content.
