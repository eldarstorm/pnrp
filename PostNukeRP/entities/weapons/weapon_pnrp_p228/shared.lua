
SWEP.Author		= "LostInTheWired"
SWEP.Contact		= "LostInTheWired@gmail.com"
SWEP.Purpose		= "Well-survived P228 from before hell-on-earth,\n  it'll keep you alive.  As long as you can aim."
SWEP.Instructions	= "Right click for iron sights.\nWALK-Right click to hold passive."

SWEP.ViewModel		= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel		= "models/weapons/w_pist_p228.mdl"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true
SWEP.DrawCrosshair 		= false

SWEP.Base 				= "weapon_base"

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models

SWEP.Primary.Sound 			= Sound("Weapon_P228.Single")
SWEP.Primary.Recoil 		= 1.4
SWEP.Primary.Damage 		= 20
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.017
SWEP.Primary.ClipSize 		= 13
SWEP.Primary.Delay 			= 0.15
SWEP.Primary.DefaultClip 	= 13
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "pistol"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.HoldType				= "pistol"
SWEP.ViewModelFlip			= true

SWEP.IronSightsPos = Vector (4.7578, 0, 2.801)
SWEP.IronSightsAng = Vector (0, 0, 0)


function SWEP:Initialize()
	util.PrecacheModel( self.ViewModel )
	util.PrecacheModel( self.WorldModel )
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheSound("Weapon_P228.Reload")
    self:SetWeaponHoldType(self.HoldType)
	self.LastIrons = 0
end

function SWEP:SetupDataTables()
	self:DTVar("Bool", 0, "Holsted")
	self:DTVar("Bool", 1, "Ironsights")
end 

function SWEP:Equip()
	-- self.Weapon:SetNWBool("IronSights", false)
	-- self.Weapon:SetNWBool("IsPassive", false)
	self.Weapon:SetDTBool(0, false)
	self.Weapon:SetDTBool(1, false)
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() or self.Owner:WaterLevel() > 2 then return end
	if self.Weapon:GetDTBool(0) or self.Owner:KeyDown( IN_SPEED ) then return end
	
	self.Weapon:EmitSound(self.Primary.Sound)
	self:TakePrimaryAmmo(self.Primary.NumShots)
	
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	local handlingSkill = self.Owner:GetSkill("Weapon Handling")
	
	if self.Weapon:GetDTBool(1) then
		self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil - (0.1 * handlingSkill)), math.Rand(-1,1) * ((self.Primary.Recoil - (0.1 * handlingSkill)) / 2), 0))
		self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, (self.Primary.Cone - (0.0005 * handlingSkill)) / 2, (self.Primary.Recoil - (0.1 * handlingSkill)) / 2 )
	else
		self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil - (0.1 * handlingSkill)), math.Rand(-1,1) * (self.Primary.Recoil - (0.1 * handlingSkill)), 0))
		self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, (self.Primary.Cone - (0.0005 * handlingSkill)), (self.Primary.Recoil - (0.1 * handlingSkill)) )
	end
	
	self.LastShoot = CurTime()
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown( IN_WALK ) then
		-- local savedBool = (not self.Weapon:GetNWBool("IsPassive", false))
		local savedBool = (not self.Weapon:GetDTBool(0))
		--self.Weapon:SetNWBool("IsPassive", (not self.Weapon:GetNWBool("IsPassive", false)))
		
		if (SERVER) then
			self.Weapon:SetDTBool(0, (not self.Weapon:GetDTBool(0)))
			self.Owner:EmitSound("npc/combine_soldier/gear4.wav")
		end
		
		if savedBool then
			self:SetWeaponHoldType("normal")
			self.Owner:SetFOV( 0, 0.15 )
			--self.Weapon:SetNWBool("IronSights", false)
			self.Weapon:SetDTBool(1, false)
		else
			self:SetWeaponHoldType(self.HoldType)
		end
	else
		--if self.Weapon:GetNWBool("IsPassive", false) then return end
		if self.Weapon:GetDTBool(0) then return end
		-- local savedBool = (not self.Weapon:GetNWBool("IronSights", false))
		local savedBool = (not self.Weapon:GetDTBool(1))
		-- self.Weapon:SetNWBool("IronSights", (not self.Weapon:GetNWBool("IronSights", false))) 
		self.Weapon:SetDTBool(1, (not self.Weapon:GetDTBool(1)))
		
		if savedBool then
			self.Owner:SetFOV( 65, 0.15 )
		else
			self.Owner:SetFOV( 0, 0.15 )
		end
	end
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
	--self.LastIrons = CurTime()
end

function SWEP:Reload()
	if self.Weapon:Clip1() < self.Primary.ClipSize then
		-- self.Weapon:SetNWBool("IronSights", false)
		self.Weapon:SetDTBool(1, false)
		self.Owner:SetFOV( 0, 0.15 )
		
		-- self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
		-- self.Weapon:SetNextSecondaryFire(CurTime() + 1.5)
		self.Weapon:SetWeaponHoldType(self.HoldType)
		self.Weapon:DefaultReload(ACT_VM_RELOAD) 
		self.Weapon:EmitSound("Weapon_P228.Reload")
		
	end
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	-- self.Owner:SetNWBool("IronSights", false)
	-- self.Weapon:SetNWBool("IsPassive", false)
	
	self.Weapon:SetDTBool(0, false)
	self.Weapon:SetDTBool(1, false)

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	return true
end

function SWEP:Think()
	-- if self.Weapon:GetDTBool(0) or self.Owner:KeyDown( IN_SPEED ) then
		-- self:SetWeaponHoldType("normal")
	-- elseif self.Weapon:GetDTBool(1) then
		-- self:SetWeaponHoldType("revolver")
	-- else
		-- self:SetWeaponHoldType(self.HoldType)
	-- end
end

-- Ironsights code, based on CSS Realistic
local IRONSIGHT_TIME = 0.15

function SWEP:GetViewModelPosition(pos, ang)
	
	if self.Weapon:GetDTBool(0) or self.Owner:KeyDown( IN_SPEED ) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		-37.2258)
		ang:RotateAroundAxis(ang:Up(), 		1.7237)
		ang:RotateAroundAxis(ang:Forward(), 	0)
		
		local Offset = Vector(1.6428, 0, 6.2286)
		local Right 	= ang:Right()
		local Up 		= ang:Up()
		local Forward 	= ang:Forward()
		
		pos = pos + Offset.x * Right
		pos = pos + Offset.y * Forward
		pos = pos + Offset.z * Up
		return pos, ang
	end
	
	if (not self.IronSightsPos) then return pos, ang end

	local bIron = self.Weapon:GetDTBool(1)

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()
		
		if (bIron) then
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end

	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end
	
	local Offset	= self.IronSightsPos
	
	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
end

function SWEP:ShootBullet( damage, num_bullets, aimcone, recoil )
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()	-- Source
	bullet.Dir 		= self.Owner:GetAimVector()	-- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )		-- Aim Cone
	bullet.Tracer	= 4	-- Show a tracer on every x bullets 
        bullet.TracerName = "Tracer" -- what Tracer Effect should be used
	bullet.Force	= 1	-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "smg1"
 
	if SERVER then self.Owner:LagCompensation( true ) end
		self.Owner:FireBullets( bullet )
	if SERVER then self.Owner:LagCompensation( false ) end
	
	self:ShootEffects()
	
	if ((game.SinglePlayer() and SERVER) or (not game.SinglePlayer() and CLIENT)) then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end
	
end

function SWEP:ShootEffects()
 
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	-- View model animation
	self.Owner:MuzzleFlash()				-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )		-- 3rd Person Animation
 
end
