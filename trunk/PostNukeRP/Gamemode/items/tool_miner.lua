local ITEM = {}


ITEM.ID = "tool_miner"

ITEM.Name = "Automated Sonic Miner"
ITEM.ClassSpawn = "Scavenger"
ITEM.Scrap = 250
ITEM.Small_Parts = 175
ITEM.Chemicals = 75
ITEM.Chance = 100
ITEM.Info = "Gives antlions one hell of a head ache."
ITEM.Type = "tool"
ITEM.Remove = true
ITEM.Energy = 0
ITEM.Ent = "tool_miner"
ITEM.Model = "models/props_combine/combinethumper002.mdl"
ITEM.Script = ""
ITEM.Weight = 20

function ITEM.ToolCheck( p )
	-- This one returns required items.
	return {["intm_sensorpod"]=1, ["intm_elecboard"]=2, ["intm_servo"]=2}
end

function ITEM.Create( ply, class, pos )
	local ent = ents.Create(class)
	ent:SetAngles(Angle(0,0,0))
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	--ent:SetNetworkedString("Owner", ply:Nick())
	PNRP.SetOwner(ply, ent)
	
	PNRP.AddWorldCache( ply,ITEM.ID )
end


function ITEM.Use( ply )
	return true	
end


PNRP.AddItem(ITEM)