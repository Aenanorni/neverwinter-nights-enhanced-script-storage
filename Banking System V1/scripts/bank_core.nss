// bank_core.nss
// Core constants and helper funcs
// Neverwinter Nights: Enhanced Edition - Banking System v1.0
// Created by Aenanorni
// NOTE: This script is provided as-is. See docs/README.txt for install/usage and limitations.
//
// Short comments are included inline. Keep scripts modular for easy edits.
#ifndef BANK_CORE_NSS
#define BANK_CORE_NSS

const string BANK_PREFIX = "BANK_"; // prefix for campaign keys

// Campaign key helpers -------------------------------------------------------
// Build a campaign key name for a player-based value.
// Uses player's in-game name (GetName). See README for limitations and CD Key advice.
string BANK_GetAcctKey(string sPlayerName, string sField)
{
    return BANK_PREFIX + sPlayerName + "_" + sField;
}

// Convenience: campaign storage wrappers
void BANK_SetCampaignInt(string sKey, int nVal)
{
    SetCampaignInt(sKey, nVal);
}
int BANK_GetCampaignInt(string sKey)
{
    return GetCampaignInt(sKey);
}
void BANK_SetCampaignString(string sKey, string sVal)
{
    SetCampaignString(sKey, sVal);
}
string BANK_GetCampaignString(string sKey)
{
    return GetCampaignString(sKey);
}

#endif
