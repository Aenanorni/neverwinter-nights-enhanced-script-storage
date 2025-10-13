
# 🛠️ Setup Instructions for Banking System v1.0

## 📁 Script Import
1. Open NWN Toolset
2. Go to `Tools > Script Editor`
3. Import all `.nss` files from `/scripts`
4. Save each script

## 📦 Chest Setup
1. In `Palette > Placeables > Containers`, drag a chest into your area
2. Right-click > Properties
3. Under `Events`:
   - `OnOpen`: `retrieve_items_from_db`
   - `OnClose`: `store_items_to_db`

## 🧑‍💼 Banker NPC Setup
1. In `Palette > Creatures > Humanoid > Commoner`, drag NPC into area
2. Right-click > Properties
3. Under `Conversation`: assign `banker_conversation.dlg`
4. Under `Scripts`:
   - `OnConversation`: `banker_conversation.nss`

## 🗃️ SQL Setup
Use NWNX or Beamdog SQLite interface to run `schema.sql`:
```sql
CREATE TABLE bank_items (player_id TEXT, item_tag TEXT);
CREATE TABLE bank_gold (player_id TEXT, gold INTEGER);
```

## 🛡️ Admin Tools
Assign `admin_tools.nss` to DM-only item or NPC. Use local variables:
- `target_player_id`
- `admin_action`

## ✅ Final Steps
- Save your module
- Test in-game by interacting with banker and chest
