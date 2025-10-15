// bank_vault.nss
// Item vault helpers (simple serialization by resref)
// Neverwinter Nights: Enhanced Edition - Banking System v1.0
// Created by Aenanorni
// NOTE: This script is provided as-is. See docs/README.txt for install/usage and limitations.
//
// Short comments are included inline. Keep scripts modular for easy edits.
#include "bank_core.nss"

// Vault storage format (string):
// semicolon-separated entries of "resref:stack" e.g. "nw_longsw:1;nw_bread:5"
// v1.0 limitation: complex item properties, custom item properties, and unique IDs are NOT preserved.
// Use this as a simple item template vault (good for standard items).
// Module builders: to deposit rich/custom items, consider using NWNX object serialization plugins (not required here).

// Helper: get vault string key for player
string BANK_GetVaultKey(object oPC)
{
    if (!GetIsObjectValid(oPC)) return "";
    string sName = GetName(oPC);
    return BANK_GetAcctKey(sName, "VAULT");
}

// Deposit an item template (by resref) into the player's vault.
// This function is intended to be called from an external script that passes the resref and amount,
// OR module builders can call BANK_DepositItemFromObject to deposit an actual item object (see note).
void BANK_Vault_AddTemplate(object oPC, string sResRef, int nStack)
{
    if (!GetIsObjectValid(oPC) || sResRef == "" || nStack <= 0) return;
    string sKey = BANK_GetVaultKey(oPC);
    string sVault = BANK_GetCampaignString(sKey);
    string sEntry = sResRef + ":" + IntToString(nStack);

    if (sVault == "")
    {
        sVault = sEntry;
    }
    else
    {
        sVault = sVault + ";" + sEntry;
    }
    BANK_SetCampaignString(sKey, sVault);
}

// NOTE: simple helper for module builders - deposit an actual item object into the vault by resref.
// This will record the item's base resref and stack size where applicable, then destroy the object.
// Limitation: item-specific properties and charges/enchantments will be lost.
void BANK_DepositItemFromObject(object oPC, object oItem)
{
    if (!GetIsObjectValid(oPC) || !GetIsObjectValid(oItem)) return;
    string sRes = GetResRef(oItem);
    int nStack = GetItemStackSize(oItem);
    // add to vault
    BANK_Vault_AddTemplate(oPC, sRes, nStack);
    // remove item from world
    DestroyObject(oItem);
    FloatingTextStringOnCreature("Item stored in vault.", oPC, FALSE);
}

// Withdraw a template item from the vault (creates the item on the PC). Returns TRUE on success.
int BANK_Vault_Withdraw(object oPC, string sResRef, int nStack)
{
    if (!GetIsObjectValid(oPC) || sResRef == "" || nStack <= 0) return FALSE;
    string sKey = BANK_GetVaultKey(oPC);
    string sVault = BANK_GetCampaignString(sKey);
    if (sVault == "") return FALSE;

    // parse vault entries, find a matching resref with enough quantity
    string sNewVault = "";
    int nFound = 0;

    string sCur = sVault;
    while (sCur != "")
    {
        int nPos = FindSubString(sCur, ";");
        string sEntry = sCur;
        if (nPos > -1)
        {
            sEntry = Left(sCur, nPos);
            sCur = Right(sCur, SizeOfString(sCur) - (nPos + 1));
        }
        else
        {
            sCur = "";
        }

        int nCol = FindSubString(sEntry, ":");
        string sR = sEntry;
        int nQ = 1;
        if (nCol > -1)
        {
            sR = Left(sEntry, nCol);
            nQ = StringToInt(Right(sEntry, SizeOfString(sEntry) - (nCol + 1)));
        }

        if (sR == sResRef && nQ >= nStack && nFound == 0)
        {
            // consume quantity
            nQ = nQ - nStack;
            nFound = 1;
        }

        if (nQ > 0)
        {
            if (sNewVault == "")
                sNewVault = sR + ":" + IntToString(nQ);
            else
                sNewVault = sNewVault + ";" + sR + ":" + IntToString(nQ);
        }
    }

    if (nFound == 0) return FALSE;

    // save updated vault
    BANK_SetCampaignString(sKey, sNewVault);

    // create the item(s) on player
    CreateItemOnObject(sResRef, oPC, nStack);

    FloatingTextStringOnCreature("Withdrew item from vault.", oPC, FALSE);
    return TRUE;
}
