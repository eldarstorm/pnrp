
// Variables that are used on both client and server

SWEP.Author		= "LostInTheWired"
SWEP.Contact		= "N/A"
SWEP.Purpose		= "PNRP radio swep."
SWEP.Instructions	= "Left click to change channel.\nRight click to turn the radio on and off."

SWEP.ViewModel		= "models/Weapons/V_hands.mdl"
SWEP.WorldModel		= "models/props_citizen_tech/transponder.mdl"

SWEP.Spawnable      = false
SWEP.AdminSpawnable = false

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.NextLeft = 0
SWEP.NextRight = 0


/*---------------------------------------------------------
	Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

--    if (!SERVER) then return end
	
    self:SetWeaponHoldType("normal")	
						
end
	
/*---------------------------------------------------------
	Deploy
---------------------------------------------------------*/
function SWEP:Deploy()

    if (!SERVER) then return end
    self.Owner:DrawWorldModel(false)
	
end	
	
	
/*---------------------------------------------------------
	Reload 
---------------------------------------------------------*/
function SWEP:Reload()
	
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
    
	if CurTime() < self.NextLeft then return end
	
	if (!SERVER) then return end
	
	local Channel = self.Owner.Channel
	if not Channel then Channel = 400.00 end
	
	umsg.Start("radiofreq_select", self.Owner)
		umsg.String(Channel)
	umsg.End()
	
	self.NextLeft = CurTime() + 1
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	if CurTime() < self.NextRight then return end
	
	if (!SERVER) then return end
	self.Owner.RdioPower = (not self.Owner.RdioPower)
	local mystring = "Radio is now "
	
	if self.Owner.RdioPower then 
		mystring = mystring.."on."
	else
		mystring = mystring.."off."
	end
	
	self.Owner:ChatPrint(mystring)
	
	self.NextRight = CurTime() + 1
end

/*---------------------------------------------------------
	Think does nothing 
---------------------------------------------------------*/
function SWEP:Think()

end

