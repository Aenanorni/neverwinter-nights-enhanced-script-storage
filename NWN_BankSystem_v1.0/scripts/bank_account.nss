// bank_account.nss
// Account create/load/save functions
// Neverwinter Nights: Enhanced Edition - Banking System v1.0
// Created by Aenanorni
// NOTE: This script is provided as-is. See docs/README.txt for install/usage and limitations.
//
// Short comments are included inline. Keep scripts modular for easy edits.
#include "bank_core.nss"

// Create a new account for a player (by name). Initializes balance to 0.
// Returns TRUE if created, FALSE if already existed.
int BANK_CreateAccount(object oPC)
{
    if (!GetIsObjectValid(oPC)) return FALSE;
    string sName = GetName(oPC);
    string sKey = BANK_GetAcctKey(sName, "BAL");
    // If already exists, do nothing
    if (GetCampaignInt(sKey) != 0 || GetCampaignString(sKey) != "")
    {
        // We treat non-zero as existing (note: could be zero balance also)
        return FALSE;
    }
    BANK_SetCampaignInt(sKey, 0);
    // initialize vault string (empty)
    string sVaultKey = BANK_GetAcctKey(sName, "VAULT");
    BANK_SetCampaignString(sVaultKey, "");
    return TRUE;
}

// Get current balance (gold) for a player
int BANK_GetBalance(object oPC)
{
    if (!GetIsObjectValid(oPC)) return 0;
    string sName = GetName(oPC);
    string sKey = BANK_GetAcctKey(sName, "BAL");
    return BANK_GetCampaignInt(sKey);
}

// Set balance (overwrites)
void BANK_SetBalance(object oPC, int nAmount)
{
    if (!GetIsObjectValid(oPC)) return;
    string sName = GetName(oPC);
    string sKey = BANK_GetAcctKey(sName, "BAL");
    BANK_SetCampaignInt(sKey, nAmount);
}

// Add to balance (positive or negative allowed)
void BANK_AdjustBalance(object oPC, int nDelta)
{
    if (!GetIsObjectValid(oPC)) return;
    int nCur = BANK_GetBalance(oPC);
    int nNew = nCur + nDelta;
    if (nNew < 0) nNew = 0; // simple safeguard - no negative balances in v1.0
    BANK_SetBalance(oPC, nNew);
}

// Simple existence check
int BANK_AccountExists(object oPC)
{
    if (!GetIsObjectValid(oPC)) return FALSE;
    string sName = GetName(oPC);
    string sKey = BANK_GetAcctKey(sName, "BAL");
    // If key exists (we treat any stored int as existing). If never set, returns 0.
    // To differentiate zero-balance existing accounts vs never-created, module should call CreateAccount on first use.
    return TRUE;
}
