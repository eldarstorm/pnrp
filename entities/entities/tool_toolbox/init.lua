AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.PrecacheModel ("models/weapons/w_models/w_toolbox.mdl")

function ENT:Initialize()
	self.Entity:SetModel("models/weapons/w_models/w_toolbox.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self.Entity:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Entity:PhysWake()
end

function ENT:Use( activator, caller )
	PlayerPickupObject( activator, self )
end

function ENT:PostEntityPaste(pl, Ent, CreatedEntities)
	self:Remove()
end
