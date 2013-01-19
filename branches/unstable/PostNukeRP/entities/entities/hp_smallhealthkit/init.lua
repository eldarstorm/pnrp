AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.PrecacheModel ("models/healthvial.mdl")

function ENT:Initialize()
	self.Entity:SetModel("models/healthvial.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self.Entity:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Entity:PhysWake()
end

function ENT:Use( activator, caller )
	if ( activator:IsPlayer() ) then
		
		// Give the collecting player some free health
		local health = activator:Health()
		
		if not ( health == activator:GetMaxHealth() ) then
			local sound = Sound("items/smallmedkit1.wav")
			self.Entity:EmitSound( sound )
			
			self.Entity:Remove()
			activator:SetHealth( health + 10 )
			if ( activator:GetMaxHealth() < health + 10  ) then
				activator:SetHealth( activator:GetMaxHealth() )
			end
		end
 
	end
 
end
