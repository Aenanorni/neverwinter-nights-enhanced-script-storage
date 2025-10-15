// bank_dialog.nss
// Dialog handlers for banker NPC/placeable (basic menu)
// Neverwinter Nights: Enhanced Edition - Banking System v1.0
// Created by Aenanorni
// NOTE: This script is provided as-is. See docs/README.txt for install/usage and limitations.
//
// Short comments are included inline. Keep scripts modular for easy edits.
#include "bank_account.nss"
#include "bank_transactions.nss"
#include "bank_vault.nss"

// Dialog hook: OnConversation with banker or placeable should call BANK_DialogHandler
void BANK_DialogHandler()
{
    object oPC = GetPCSpeaker();
    object oSelf = OBJECT_SELF;
    if (!GetIsObjectValid(oPC)) return;

    // Ensure account exists
    BANK_CreateAccount(oPC);

    // Build simple menu as dialog choices. In toolset, link actions to the text nodes that call these small helper scripts.
    // For a compact delivery, we recommend creating separate short action scripts that call the functions below,
    // and call them from "Actions Taken" in the dialog text nodes.
}

// Small example utility scripts you can call from dialog 'Actions Taken' to perform common actions.
// These are intentionally simple so you can hook them into conversation nodes.
//
// Example: Deposit 100 gp (script placed in the NPC's "Actions Taken" slot for a dialog option)
void BANK_Action_Deposit100()
{
    object oPC = GetPCSpeaker();
    BANK_DepositGold(oPC, 100);
}

// Example: Withdraw 100 gp
void BANK_Action_Withdraw100()
{
    object oPC = GetPCSpeaker();
    BANK_WithdrawGold(oPC, 100);
}

// Example: Open vault withdraw for a named resref (toolset action calls with proper text input is required)
// Note: Toolset can't pass strings into actions, so for flexible withdraws use small wrapper scripts per-template.
void BANK_Action_Withdraw_SampleSword()
{
    object oPC = GetPCSpeaker();
    BANK_Vault_Withdraw(oPC, "NW_WSWLS001", 1); // sample longsword template resref
}
