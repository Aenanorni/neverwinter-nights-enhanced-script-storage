// bank_init.nss
// Init script to attach to banker NPCs/placeables (OnSpawn/OnHeartbeat)
// Neverwinter Nights: Enhanced Edition - Banking System v1.0
// Created by Aenanorni
// NOTE: This script is provided as-is. See docs/README.txt for install/usage and limitations.
//
// Short comments are included inline. Keep scripts modular for easy edits.
#include "bank_core.nss"

// Attach this script to bank NPCs/placeables as OnSpawn to set their dialog tag or other initial settings.
// For v1.0 we simply ensure a tag is present.
void main()
{
    // Tag suggestion: BANKER_NPC or BANK_PLACEABLE
    if (GetTag(OBJECT_SELF) == "") 
    {
        SetTag(OBJECT_SELF, "BANKER_AUTO");
    }
}
