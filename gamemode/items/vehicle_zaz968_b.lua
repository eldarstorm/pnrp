local ITEM = {}

ITEM.ID = "vehicle_zaz968_b"

ITEM.Name = "Jalopy ZAZ 968"
ITEM.ClassSpawn = "None"
ITEM.Scrap = 200
ITEM.Small_Parts = 150
ITEM.Chemicals = 50	
ITEM.Chance = 100
ITEM.Info = "A mid sized coupe, jerry-rigged to perfection."
ITEM.Type = "vehicle"
ITEM.Remove = true
ITEM.HP = 100
ITEM.Energy = 0
ITEM.Ent = "prop_vehicle_jeep"
ITEM.EntName = "car005b"
ITEM.Model = "models/source_vehicles/car005b/vehicle.mdl"
ITEM.Script = "scripts/vehicles/rubbishcar.txt"
ITEM.Hull = "models/props_vehicles/car005b_physics.mdl"
ITEM.SeatLoc = {{Pos = Vector(20,-5,17), Ang = Angle(0,0,8)},
				{Pos = Vector(18,-45,17), Ang = Angle(0,0,8)},
				{Pos = Vector(-16,-45,17), Ang = Angle(0,0,8)}}
ITEM.SeatModel = "models/nova/jalopy_seat.mdl"
ITEM.Weight = 40
ITEM.Capacity = 125
ITEM.Tank = 12
ITEM.HasStorage = true
ITEM.CanRepair = true
ITEM.RepairClass = {TEAM_ENGINEER}
ITEM.Keys = true
ITEM.ShopHide = true
ITEM.SaveState = true

function ITEM.BuildState( ent )
	local toolHP = ITEM.HP
	local Gas = 0
	if( IsValid(ent) ) then 
		toolHP = ent:Health() 
		Gas = ent.gas
	end
	
	if Gas == "" or Gas == nil then Gas = 0 end
	return "HP="..toolHP..",Gas="..Gas
end

function ITEM.ToolCheck( p )
	return {
		["intm_engine"]=1,
		["intm_car_door"]=2,
		["intm_car_axle"]=2,
		["intm_car_muffler"]=1,
		["intm_car_tire"]=4,
		["intm_oil"]=1,
		["tool_battery"]=1}
end

function ITEM.Use( ply )
	return true	
end


function ITEM.Create( ply, class, pos, iid, angle, model )
	
	local ent = ents.Create(ITEM.Ent)
	if not angle then angle = Angle(0,0,0) end
	angle = angle+Angle(0,0,0)
	ent:SetAngles(angle)
	ent:SetPos(pos)
	
	//This fixes the seating animation for the seats
	if(ITEM.Ent == "prop_vehicle_prisoner_pod") then
		Msg("Seat fix ran. \n")
		local vname = ITEM.ID
		local VehicleList = list.Get( "Vehicles" )
		local vehicle = VehicleList[ vname ]
		
		ent:SetModel(ITEM.Model)
		
		-- Not a valid vehicle to be spawning..
		if ( vehicle ) then 
			for k, v in pairs( vehicle.KeyValues ) do
				ent:SetKeyValue( k, v )
			end	 
			ent:Spawn()
			ent:Activate()
			
			ent.VehicleName 	= vname
			ent.VehicleTable 	= vehicle
			ent.ClassOverride 	= vehicle.Class
			-- This is the main part that fixes the animation.
			if ( vehicle.Members ) then
				table.Merge( ent, vehicle.Members )
				duplicator.StoreEntityModifier( ent, "VehicleMemDupe", vehicle.Members );
			end
			
			PNRP.SetOwner(ply, ent)		
		end
	else
	
		ent:SetModel(ITEM.Model)
		ent:SetKeyValue( "actionScale", 1 ) 
		ent:SetKeyValue( "VehicleLocked", 0 ) 
		ent:SetKeyValue( "solid", 6 ) 
		ent:SetKeyValue( "vehiclescript", ITEM.Script ) 
		
		ent:SetKeyValue( "model", ITEM.Model )
		ent:Spawn()
		ent:Activate()
		PNRP.SetOwner(ply, ent)
				
	end
	
	ent.IsGasSystem = true
	ent.gas = 0
	ent.tank = ITEM.Tank
	
	if ITEM.SaveState then
		if iid then
			local stateStr = PNRP.ReturnState(iid)
			ent.gas = tonumber(PNRP.GetFromStat(stateStr, "Gas"))
		end
		
		PNRP.BuildPersistantItem(ply, ent, iid)
	end
	
	PNRP.AddWorldCache( ply,ITEM.ID,ent )
end

PNRP.AddItem(ITEM)


