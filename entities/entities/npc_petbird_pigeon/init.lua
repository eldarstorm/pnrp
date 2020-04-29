AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

function ENT:Initialize()
	self.Owner = nil
--	self.iNPCState = SCHED_IDLE_WANDER
	self.NPCMode = 0
	self.Waiting = false
	self.Option = 0
	--NPC Modes:
	-- 0 = Wait
	-- 1 = Wonder
	-- -1 = Stay
	-- -2 = Folow
	-- -11 = Run Away
	-- -12 = Hide
	-- -13 = Cower

	self.Pet = true
	self:SetNetVar("Pet", "yes")
	
	self:SetModel( "models/pigeon.mdl" )
	self:SetHullType( HULL_TINY );
	self:SetHullSizeNormal();
 
	self:SetSolid( SOLID_BBOX ) 
	self:SetMoveType( MOVETYPE_STEP )
 
	self:CapabilitiesAdd( CAP_MOVE_GROUND )
	self:CapabilitiesAdd( CAP_MOVE_JUMP )
	self:CapabilitiesAdd( CAP_MOVE_FLY )
	self:CapabilitiesAdd( CAP_SKIP_NAV_GROUND_CHECK )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	
	self:SetMaxYawSpeed( 5000 )
 
	self:SetHealth(100)
	
	self:SetNetVar("name", "Wild Bird")
	
	self:SelectSchedule( SCHED_IDLE_WANDER )

	self:AddRelationship("npc_floor_turret D_LI 99")
	self:AddRelationship("npc_chemgrub D_LI 99")
	self:AddRelationship("player D_LI 99")
	self:AddRelationship("npc_hdvermin D_LI 99")
	self:AddRelationship("npc_hdvermin_fast D_LI 99")
	self:AddRelationship("npc_hdvermin_poison D_LI 99")
	self:AddRelationship("npc_petbird_crow D_LI 99")
	self:AddRelationship("npc_petbird_gull D_LI 99")
	self:AddRelationship("npc_petbird_pigeon D_LI 99")
	
	for _, class in pairs(PNRP.friendlies) do
		for k, v in pairs(ents.FindByClass(class)) do
			self:AddEntityRelationship(v, D_LI, 99 )
		end
	end
	
end

function ENT:SelectSchedule( iNPCState )
	
	if iNPCState ~= nil then
		self.iNPCState = iNPCState
	end
	
	if self.iNPCState == nil then
		self.iNPCState = SCHED_IDLE_WANDER
	end
	
	self:SetSchedule( self.iNPCState )

end

function ENT:AcceptInput( name, activator, caller )
	if name == "Use" and IsValid(activator) and activator:IsPlayer() then
		local ply = activator
		if ply:KeyPressed( IN_USE ) then
			if tostring(self:GetNetVar( "Owner_UID" , "None" )) == PNRP:GetUID( ply ) then		
				self:CommandSound()
				if self.Option == 0 then
					self.Option = 1
					self.NPCMode = -2
					self:SetTarget( ply )
					self:SelectSchedule( SCHED_TARGET_FACE  )
					ply:ChatPrint("You tell your pet to follow.")
					ply:ChatPrint("Your bird looks at you in confusion.")
				elseif self.Option == 1 then
					self.Option = 2
					self.NPCMode = -1
					self:SelectSchedule( SCHED_IDLE_STAND )
					ply:ChatPrint("You tell your pet to stay.")
					timer.Create( "hdIdleSound_"..tostring(self), math.random(60), 0, function ()
						if IsValid(self) then
							self:IdleSounds()
						end
					end)
				else
					self.Option = 0
					self.NPCMode = 1
					self:SelectSchedule( SCHED_IDLE_WANDER )
					ply:ChatPrint("You tell your pet to wander.")
				end
			else
				ply:ChatPrint("This pet does not like you.")
			end
		end
	end
end

function ENT:IdleSounds()
	local soundNum = math.random(6)
	local SoundFile = nil
	
	SoundFile = "ambient/levels/canals/swamp_bird"..tostring(soundNum)..".wav"
	
	local mysound = Sound(SoundFile)
	self:EmitSound( mysound )
end

function ENT:HDAlertSound()
	local SoundFile = nil
	
	SoundFile = "ambient/levels/canals/swamp_bird1.wav"
	
	local mysound = Sound(SoundFile)
	self:EmitSound( mysound )
end

function ENT:HDPainSounds()
	local SoundFile = nil
	
	SoundFile = "ambient/levels/canals/swamp_bird4.wav"
	
	local mysound = Sound(SoundFile)
	self:EmitSound( mysound )
end

function ENT:CommandSound()
	local SoundFile = nil
	
	SoundFile = "ambient/levels/coast/coastbird7.wav"
	
	local mysound = Sound(SoundFile)
	self:EmitSound( mysound )
end

function ENT:DeathSound()
	local soundNum = math.random(2)
	local SoundFile = nil
	
	SoundFile = "npc/crow/die"..tostring(soundNum)..".wav"
	
	local mysound = Sound(SoundFile)
	self:EmitSound( mysound )
end

function ENT:ScheduleFinished()
	changePetActivity(self)
end
 
function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
	
	self:SelectSchedule( SCHED_RUN_FROM_ENEMY )
	self.NPCMode = -11
	self.Option = 0
	self:HDPainSounds()
	
	if self:Health() <= 0 then --run on death
		self:DeathSound()
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)
		
		local myID = "tool_petpigeon"
		
		local corpseGib = ents.Create("prop_ragdoll")
		corpseGib:SetModel( self:GetModel() )
		corpseGib:SetPos(self:GetPos())
		corpseGib:SetAngles(self:GetAngles())
		corpseGib:Spawn()
		corpseGib:SetSolid(SOLID_VPHYSICS)
		corpseGib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		corpseGib:Activate()
		
		--Remove From World Cache		
		local MyPlayer = nil
	
		if self:GetNetVar("Owner", "none") ~= "World" and self:GetNetVar("Owner", "none") ~= "none" then
			for k, v in pairs(player.GetAll()) do
				if v:Nick() == self:GetNetVar("Owner", "none") then
					MyPlayer = v
					break
				end
			end
		end
		if MyPlayer ~= nil then
			ItemID = PNRP.Items[myID].ID
			if ItemID then
				PNRP.TakeFromWorldCache( MyPlayer, ItemID )
			end
		end
		
		timer.Simple(10, function ()
			if IsValid(corpseGib) then
				corpseGib:Remove()
			end
		end )
		if IsValid(self) then
			self:Remove()
		end
	end
end 

function ENT:OnRemove( )

end

function ENT:PostEntityPaste(pl, Ent, CreatedEntities)
	self:Remove()
end

--SCRIPTED TASKS--
function ENT:EnemySearch( class, radius ) 

	local et =  ents.FindInSphere( self:GetPos(), radius or 512 ) 
	for k, v in ipairs( et ) do 

		if (  IsValid(v) && v != self && v:GetClass() == class  ) then 
			-- local tracedata = {}
			-- tracedata.start = self:GetShootPos()
			-- tracedata.endpos = v:GetShootPos()
			-- tracedata.filter = self
			-- local trace = util.TraceLine(tracedata)
			-- if trace.HitNonWorld and trace.Entity:IsValid() and trace.Entity == v then
			self:SetEnemy( v, true ) 
			self:UpdateEnemyMemory( v, v:GetPos() ) 
			return 
			-- end
		end
		
	end 

	self:SetEnemy( nil )
end

function ENT:PostEntityPaste(pl, Ent, CreatedEntities)
	self:Remove()
end