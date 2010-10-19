local ITEM = {}
local WEAPON = {}


ITEM.ID = "wep_scout"

ITEM.Name = "Steyr Scout Sniper"
ITEM.ClassSpawn = "Engineer"
ITEM.Scrap = 50
ITEM.Small_Parts = 100
ITEM.Chemicals = 30
ITEM.Chance = 100
ITEM.Info = "Uses 357 Ammo."
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 10
ITEM.Ent = "wep_scout"
ITEM.Model = "models/weapons/w_snip_scout.mdl"
ITEM.Script = ""
ITEM.Weight = 8

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "357"

function ITEM.Use( ply )
	local WepName = "weapon_real_cs_scout"
	local gotWep = false
	for k, v in pairs(ply:GetWeapons()) do
		if v:GetClass() == WepName then gotWep = true end
	end
	if gotWep == false then 
		ply:Give(WepName) 
		ply:GetWeapon(WepName):SetClip1(0)
		return true
	else
		ply:ChatPrint("Weapon allready equipped.")
		return false
	end
end


PNRP.AddItem(ITEM)
PNRP.AddWeapon(WEAPON)