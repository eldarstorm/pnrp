AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.PrecacheModel ("models/items/boxmrounds.mdl")

function ENT:Initialize()
	self.Entity:SetModel("models/items/boxmrounds.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self.Entity:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Entity:PhysWake()
	
	self.Entity:SetNetworkedString("NormalAmmo", "75")
	if not self.Entity:GetNWString("Ammo") then
		self.Entity:SetNetworkedString("Ammo", "75")
	end
end

function ENT:Use( activator, caller )
	if ( activator:IsPlayer() ) then
		local sound = Sound("items/ammo_pickup.wav")
		self.Entity:EmitSound( sound )
		
		activator:ChatPrint("Ammo:  "..self.Entity:GetNWString("Ammo"))
	
		local ammo
		if self.Entity:GetNWString("Ammo") then
			ammo = tonumber(self.Entity:GetNWString("Ammo"))
		else
			self.Entity:SetNetworkedString("Ammo", "75")
			ammo = 75
		end
	
		self.Entity:Remove()
		
		activator:GiveAmmo( ammo, "smg1")
 
	end
 
end

function ENT:PostEntityPaste(pl, Ent, CreatedEntities)
	self:Remove()
end
