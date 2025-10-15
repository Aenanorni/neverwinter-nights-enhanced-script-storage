// bank_security.nss
// Simple security and checks
// Neverwinter Nights: Enhanced Edition - Banking System v1.0
// Created by Aenanorni
// NOTE: This script is provided as-is. See docs/README.txt for install/usage and limitations.
//
// Short comments are included inline. Keep scripts modular for easy edits.
// Simple security checks for v1.0. Keep these light.
//
// - Prevent access during combat
// - Prevent access while polymorphed
// - Basic per-action cooldown could be added later.

int BANK_SecurityCheck(object oPC)
{
    if (!GetIsObjectValid(oPC)) return FALSE;
    // In combat? disallow
    if (GetIsInCombat(oPC)) 
    {
        FloatingTextStringOnCreature("You cannot use the bank while in combat.", oPC, FALSE);
        return FALSE;
    }
    // Polymorphed? disallow
    if (GetIsPolymorphed(oPC))
    {
        FloatingTextStringOnCreature("You cannot use the bank while polymorphed.", oPC, FALSE);
        return FALSE;
    }
    // Passed simple checks
    return TRUE;
}
