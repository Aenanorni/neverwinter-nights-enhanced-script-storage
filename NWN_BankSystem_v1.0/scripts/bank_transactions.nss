// bank_transactions.nss
// Deposit/withdraw/transfer functions
// Neverwinter Nights: Enhanced Edition - Banking System v1.0
// Created by Aenanorni
// NOTE: This script is provided as-is. See docs/README.txt for install/usage and limitations.
//
// Short comments are included inline. Keep scripts modular for easy edits.
#include "bank_account.nss"
#include "bank_security.nss"

// Deposit gold from player's inventory into their bank account.
// Returns TRUE on success, FALSE on failure.
// NOTE: this removes gold from the PC and adds to account balance.
int BANK_DepositGold(object oPC, int nAmount)
{
    if (!GetIsObjectValid(oPC)) return FALSE;
    if (nAmount <= 0) return FALSE;
    // Security checks (combat/polymorph/etc)
    if (!BANK_SecurityCheck(oPC)) return FALSE;

    int nPlayerGold = GetGold(oPC);
    if (nPlayerGold < nAmount) return FALSE;

    // Remove gold from player and credit account
    TakeGoldFromCreature(nAmount, oPC, TRUE); // TRUE destroys the gold (does not transfer to NPC)
    BANK_AdjustBalance(oPC, nAmount);

    // Feedback
    FloatingTextStringOnCreature("Deposited " + IntToString(nAmount) + " gp.", oPC, FALSE);

    return TRUE;
}

// Withdraw gold from account and give to player.
// Returns TRUE on success, FALSE if insufficient funds.
int BANK_WithdrawGold(object oPC, int nAmount)
{
    if (!GetIsObjectValid(oPC)) return FALSE;
    if (nAmount <= 0) return FALSE;
    if (!BANK_SecurityCheck(oPC)) return FALSE;

    int nBal = BANK_GetBalance(oPC);
    if (nBal < nAmount) return FALSE;

    // Deduct and give gold
    BANK_AdjustBalance(oPC, -nAmount);
    GiveGoldToCreature(nAmount, oPC);

    FloatingTextStringOnCreature("Withdrew " + IntToString(nAmount) + " gp.", oPC, FALSE);
    return TRUE;
}

// Transfer funds from one player to another (both must have accounts)
// Returns TRUE on success
int BANK_Transfer(object oFrom, object oTo, int nAmount)
{
    if (!GetIsObjectValid(oFrom) || !GetIsObjectValid(oTo)) return FALSE;
    if (nAmount <= 0) return FALSE;
    if (!BANK_SecurityCheck(oFrom)) return FALSE;

    int nBalFrom = BANK_GetBalance(oFrom);
    if (nBalFrom < nAmount) return FALSE;

    BANK_AdjustBalance(oFrom, -nAmount);
    BANK_AdjustBalance(oTo, nAmount);

    FloatingTextStringOnCreature("Transferred " + IntToString(nAmount) + " gp to " + GetName(oTo) + ".", oFrom, FALSE);
    FloatingTextStringOnCreature("Received " + IntToString(nAmount) + " gp from " + GetName(oFrom) + ".", oTo, FALSE);
    return TRUE;
}
