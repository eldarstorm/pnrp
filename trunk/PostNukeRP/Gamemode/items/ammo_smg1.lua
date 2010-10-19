local ITEM = {}


ITEM.ID = "ammo_smg1"

ITEM.Name = "SMG Ammo"
ITEM.ClassSpawn = "Engineer"
ITEM.Scrap = 15
ITEM.Small_Parts = 0
ITEM.Chemicals = 15
ITEM.Chance = 100
ITEM.Info = ""
ITEM.Type = "ammo"
ITEM.Remove = true
ITEM.Energy = 75
ITEM.Ent = "ammo_smg1"
ITEM.Model = "models/items/boxmrounds.mdl"
ITEM.Script = ""
ITEM.Weight = 3


function ITEM.Use( ply )
	local ammoType = ITEM.ID
	ammoType = string.gsub(ammoType, "ammo_", "")
	ply:GiveAmmo(ITEM.Energy, ammoType)
	return true
end


PNRP.AddItem(ITEM)

