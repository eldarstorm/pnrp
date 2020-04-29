local admin_frame
local pp_frame

function GM.open_admin()
	local GM = GAMEMODE
	local ply = LocalPlayer()

	local GMSettings = net.ReadTable()
	local SpawnSettings = net.ReadTable()
	local mapList = net.ReadTable()
	local importList = net.ReadTable()
	local EventsTbl = net.ReadTable()
	local EventsFunctions = net.ReadTable()
	if ply:IsAdmin() then
		admin_frame = vgui.Create( "DFrame" )
				admin_frame:SetSize( 425, 660 ) --Set the size
				admin_frame:SetPos(ScrW() / 2 - admin_frame:GetWide() / 2, ScrH() / 2 - admin_frame:GetTall() / 2) --Set the window in the middle of the players screen/game window
				admin_frame:SetTitle( "Admin Menu" ) --Set title
				admin_frame:SetVisible( true )
				admin_frame:SetDraggable( true )
				admin_frame:ShowCloseButton( true )
				admin_frame:MakePopup()
		
		local shopmenu = vgui.Create("DButton") -- Create the button
			shopmenu:SetParent( admin_frame ) -- parent the button to the frame
			shopmenu:SetText( "Admin Trade >" ) -- set the button text
			shopmenu:SetPos(20, 25) -- set the button position in the frame
			shopmenu:SetSize( 100, 20 ) -- set the button size
			shopmenu.DoClick = function() RunConsoleCommand( "pnrp_admin_trade_window" ) SCFrame=false admin_frame:Close() end 	
			
		local ppmenu = vgui.Create("DButton") -- Create the button
			ppmenu:SetParent( admin_frame ) -- parent the button to the frame
			ppmenu:SetText( "Prop Control >" ) -- set the button text
			ppmenu:SetPos(120, 25) -- set the button position in the frame
			ppmenu:SetSize( 100, 20 ) -- set the button size
			ppmenu.DoClick = function() 
				--datastream.StreamToServer( "Start_open_PropProtection" )
				net.Start("Start_open_PropProtection")
				net.SendToServer()
				SCFrame=false 
				admin_frame:Close() 
			end 
		
		local textColor = Color(200,200,200,255)
		local dListBKColor = Color(50,50,50,255)
		
		local plymenu = vgui.Create("DButton") -- Create the button
			plymenu:SetParent( admin_frame ) -- parent the button to the frame
			plymenu:SetText( "Player Control >" ) -- set the button text
			plymenu:SetPos(220, 25) -- set the button position in the frame
			plymenu:SetSize( 100, 20 ) -- set the button size
			plymenu.DoClick = function() RunConsoleCommand( "pnrp_playerAdminList" ) SCFrame=false admin_frame:Close() end
		
		local AdminTabSheet = vgui.Create( "DPropertySheet" )
			AdminTabSheet:SetParent( admin_frame )
			AdminTabSheet:SetPos( 5, 50 )
			AdminTabSheet:SetSize( admin_frame:GetWide() - 10, admin_frame:GetTall() - 90 ) 
--Server Settings
			local GModeSettingsList = vgui.Create( "DPanelList", AdminTabSheet )
				GModeSettingsList:SetPos( 10,10 )
				GModeSettingsList:SetSize( admin_frame:GetWide() - 10, admin_frame:GetTall() - 10 )
				GModeSettingsList:SetSpacing( 3 ) -- Spacing between items
				GModeSettingsList:SetPadding( 5 )
				GModeSettingsList:EnableHorizontal( false ) -- Only vertical items
				GModeSettingsList:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis	
				GModeSettingsList:SetDrawBackground( true )
				GModeSettingsList.Paint = function()
					draw.RoundedBox( 8, 0, 0, GModeSettingsList:GetWide(), GModeSettingsList:GetTall(), dListBKColor )
				end

				
				local E2RestrictLabel= vgui.Create("DLabel", GModeSettingsList)
					E2RestrictLabel:SetText("E2 Restriction: " )
					E2RestrictLabel:SetColor(textColor)
					E2RestrictLabel:SizeToContents()
				GModeSettingsList:AddItem( E2RestrictLabel )
					
				local E2RestrictSlider = vgui.Create( "DNumSlider", GModeSettingsList )
				    E2RestrictSlider:SetSize( GModeSettingsList:GetWide() - 20, 40 ) -- Keep the second number at 50
				--	E2RestrictSlider:SetWide( 50 )
				    E2RestrictSlider:SetText( "0 None, 1 Admin, 2 Eng,\n3 Eng/Sci, 4 All" )
				    E2RestrictSlider:SetMin( 0 )
				    E2RestrictSlider:SetMax( 4 )
				    E2RestrictSlider:SetDecimals( 0 )
					E2RestrictSlider.Label:SetColor(textColor)
					E2RestrictSlider:SetBGColor(textColor)
				    E2RestrictSlider:SetValue( GMSettings.E2Restrict )
					E2RestrictSlider.Label:SizeToContents()
				GModeSettingsList:AddItem( E2RestrictSlider )				
				
				local ToolRestrictLabel= vgui.Create("DLabel", GModeSettingsList)
					ToolRestrictLabel:SetText("Tool Restriction:  (Default 4)" )
					ToolRestrictLabel:SetColor(textColor)
					ToolRestrictLabel:SizeToContents()
				GModeSettingsList:AddItem( ToolRestrictLabel )
					
				local ToolRestrictSlider = vgui.Create( "DNumSlider", GModeSettingsList )
				    ToolRestrictSlider:SetSize( GModeSettingsList:GetWide() - 20, 50 ) -- Keep the second number at 50
				    ToolRestrictSlider:SetText( "0 None, 1 Admin, 2 Eng,\n3 Eng/Sci, 4 All" )
				    ToolRestrictSlider:SetMin( 0 )
				    ToolRestrictSlider:SetMax( 4 )
				    ToolRestrictSlider:SetDecimals( 0 )
					ToolRestrictSlider.Label:SetColor(textColor)
				    ToolRestrictSlider:SetValue( GMSettings.ToolLevel )
					ToolRestrictSlider.Label:SizeToContents()
				GModeSettingsList:AddItem( ToolRestrictSlider )
				
				local adminCreateAllTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					adminCreateAllTgl:SetText( "Admin can create all." )
					adminCreateAllTgl:SetTextColor(textColor)
					adminCreateAllTgl:SetValue( GMSettings.AdminCreateAll )
					adminCreateAllTgl:SizeToContents() 
				GModeSettingsList:AddItem( adminCreateAllTgl )
				
				local adminTouchAllTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					adminTouchAllTgl:SetText( "Admin can touch all." )
					adminTouchAllTgl:SetTextColor(textColor)
					adminTouchAllTgl:SetValue( GMSettings.AdminTouchAll )
					adminTouchAllTgl:SizeToContents() 
				GModeSettingsList:AddItem( adminTouchAllTgl )
				
				local adminNoCostTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					adminNoCostTgl:SetText( "Admin No-Cost." )
					adminNoCostTgl:SetTextColor(textColor)
					adminNoCostTgl:SetValue( GMSettings.AdminNoCost )
					adminNoCostTgl:SizeToContents() 
				GModeSettingsList:AddItem( adminNoCostTgl )
				
				local propBanningTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					propBanningTgl:SetText( "Use Prop Blacklist." )
					propBanningTgl:SetTextColor(textColor)
					propBanningTgl:SetValue( GMSettings.PropBanning )
					propBanningTgl:SizeToContents() 
				GModeSettingsList:AddItem( propBanningTgl )
				
				local propAllowingTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					propAllowingTgl:SetText( "Use Prop Whitelist." )
					propAllowingTgl:SetTextColor(textColor)
					propAllowingTgl:SetValue( GMSettings.PropAllowing )
					propAllowingTgl:SizeToContents() 
				GModeSettingsList:AddItem( propAllowingTgl )
				
				local propSpawnProtectTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					propSpawnProtectTgl:SetText( "Use Player Spawn Protection." )
					propSpawnProtectTgl:SetTextColor(textColor)
					propSpawnProtectTgl:SetValue( GMSettings.PropSpawnProtection )
					propSpawnProtectTgl:SizeToContents() 
				GModeSettingsList:AddItem( propSpawnProtectTgl )
				
				local plyDeathZombieTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					plyDeathZombieTgl:SetText( "Enable Player Death Zombies." )
					plyDeathZombieTgl:SetTextColor(textColor)
					plyDeathZombieTgl:SetValue( GMSettings.PlyDeathZombie )
					plyDeathZombieTgl:SizeToContents() 
				GModeSettingsList:AddItem( plyDeathZombieTgl )
				
				local PropExpTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					PropExpTgl:SetText( "Player Gains XP From Prop Kills." )
					PropExpTgl:SetTextColor(textColor)
					PropExpTgl:SetValue( GMSettings.PropExp )
					PropExpTgl:SizeToContents() 
				GModeSettingsList:AddItem( PropExpTgl )
				
				local PropPuntTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					PropPuntTgl:SetText( "Allow Gravity Gun Usage." )
					PropPuntTgl:SetTextColor(textColor)
					PropPuntTgl:SetValue( GMSettings.PropPunt )
					PropPuntTgl:SizeToContents() 
				GModeSettingsList:AddItem( PropPuntTgl )
				
				local propPayTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					propPayTgl:SetText( "Pay for Props from Q Menu (affects duplcations).." )
					propPayTgl:SetTextColor(textColor)
					propPayTgl:SetValue( GMSettings.PropPay )
					propPayTgl:SizeToContents() 
				GModeSettingsList:AddItem( propPayTgl )
				
				local propCostSlider = vgui.Create( "DNumSlider", GModeSettingsList )
				    propCostSlider:SetSize( GModeSettingsList:GetWide() - 20, 50 ) -- Keep the second number at 50
				    propCostSlider:SetText( "Q Menu Prop Cost (Default 10)" )
					propCostSlider.Label:SetColor(textColor)
				    propCostSlider:SetMin( 0 )
				    propCostSlider:SetMax( 100 )
				    propCostSlider:SetDecimals( 0 )
					propCostSlider:SetValue( GMSettings.PropCost )
					propCostSlider.Label:SizeToContents()
				GModeSettingsList:AddItem( propCostSlider )
				
				local voiceLimitTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					voiceLimitTgl:SetText( "Use Voice Range Limiter." )
					voiceLimitTgl:SetTextColor(textColor)
					voiceLimitTgl:SetValue( GMSettings.VoiceLimiter )
					voiceLimitTgl:SizeToContents() 
				GModeSettingsList:AddItem( voiceLimitTgl )
				
				local voiceLimitSlider = vgui.Create( "DNumSlider", GModeSettingsList )
				    voiceLimitSlider:SetSize( GModeSettingsList:GetWide() - 20, 50 ) -- Keep the second number at 50
				    voiceLimitSlider:SetText( "Voice Limit Range (Default 750)" )
					voiceLimitSlider.Label:SetColor(textColor)
				    voiceLimitSlider:SetMin( 0 )
				    voiceLimitSlider:SetMax( 2000 )
				    voiceLimitSlider:SetDecimals( 0 )
					voiceLimitSlider.Label:SizeToContents()
				    voiceLimitSlider:SetValue( GMSettings.VoiceDistance )
				GModeSettingsList:AddItem( voiceLimitSlider )
				
				local classCostTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					classCostTgl:SetText( "Players lose resources on Class Change." )
					classCostTgl:SetTextColor(textColor)
					classCostTgl:SetValue( GMSettings.ClassChangePay )
					classCostTgl:SizeToContents() 
					classCostTgl.Label:SizeToContents()
				GModeSettingsList:AddItem( classCostTgl )
				
				local classCostSlider = vgui.Create( "DNumSlider", GModeSettingsList )
				    classCostSlider:SetSize( GModeSettingsList:GetWide() - 20, 50 ) -- Keep the second number at 50
				    classCostSlider:SetText( "Class Change Cost (Default 10%)" )
					classCostSlider.Label:SetColor(textColor)
				    classCostSlider:SetMin( 0 )
				    classCostSlider:SetMax( 100 )
				    classCostSlider:SetDecimals( 0 )
				    classCostSlider:SetValue( GMSettings.ClassChangeCost )
					classCostSlider.Label:SizeToContents()
				GModeSettingsList:AddItem( classCostSlider )
				
				local deathCostTgl = vgui.Create( "DCheckBoxLabel", GModeSettingsList )
					deathCostTgl:SetText( "Enable Death Penalty." )
					deathCostTgl:SetTextColor(textColor)
					deathCostTgl:SetValue( GMSettings.DeathPay )
					deathCostTgl:SizeToContents() 
					deathCostTgl.Label:SizeToContents()
				GModeSettingsList:AddItem( deathCostTgl )
				
				local deathCostSlider = vgui.Create( "DNumSlider", GModeSettingsList )
				    deathCostSlider:SetSize( GModeSettingsList:GetWide() - 20, 50 ) -- Keep the second number at 50
				    deathCostSlider:SetText( "Death Penalty Cost (Default 10%)" )
					deathCostSlider.Label:SetColor(textColor)
				    deathCostSlider:SetMin( 0 )
				    deathCostSlider:SetMax( 100 )
				    deathCostSlider:SetDecimals( 0 )
				    deathCostSlider:SetValue( GMSettings.DeathCost )
					deathCostSlider.Label:SizeToContents()
				GModeSettingsList:AddItem( deathCostSlider )
				
				local ownDoorsSlider = vgui.Create( "DNumSlider", GModeSettingsList )
				    ownDoorsSlider:SetSize( GModeSettingsList:GetWide() - 20, 50 ) -- Keep the second number at 50
				    ownDoorsSlider:SetText( "Number of doors that can be owned (Default 3)" )
					ownDoorsSlider.Label:SetColor(textColor)
				    ownDoorsSlider:SetMin( 0 )
				    ownDoorsSlider:SetMax( 10 )
				    ownDoorsSlider:SetDecimals( 0 )
				    ownDoorsSlider:SetValue( GMSettings.MaxOwnDoors )
				    ownDoorsSlider.Label:SizeToContents()
				GModeSettingsList:AddItem( ownDoorsSlider )
								
			AdminTabSheet:AddSheet( "GMode Settings", GModeSettingsList, "gui/icons/brick_edit.png", false, false, "GMode Settings" )	
--Mob Spawning Settings				
			local SpawnerList = vgui.Create( "DPanelList", AdminTabSheet )
				SpawnerList:SetPos( 10,10 )
				SpawnerList:SetSize( admin_frame:GetWide() - 10, admin_frame:GetTall() - 10 )
				SpawnerList:SetSpacing( 5 ) -- Spacing between items
				SpawnerList:EnableHorizontal( false ) -- Only vertical items
				SpawnerList:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis		  
				 	
			  local MobSpawnerSettingsCats = vgui.Create("DCollapsibleCategory", SpawnerList)
					MobSpawnerSettingsCats:SetSize( SpawnerList:GetWide()-4, 50 ) -- Keep the second number at 50
					MobSpawnerSettingsCats:SetExpanded( 0 ) -- Expanded when popped up
					MobSpawnerSettingsCats:SetLabel( "Mob Spawner Settings" )
					 
					MobCategoryList = vgui.Create( "DPanelList" )
					MobCategoryList:SetAutoSize( true )
					MobCategoryList:SetSpacing( 5 )
					MobCategoryList:EnableHorizontal( false )
					MobCategoryList:EnableVerticalScrollbar( true )
					MobCategoryList.Paint = function()
						draw.RoundedBox( 8, 0, 0, MobCategoryList:GetWide(), MobCategoryList:GetTall(), Color( 50, 50, 50, 255 ) )
					end
					
					MobSpawnerSettingsCats:SetContents( MobCategoryList )
				
				local countMobsBTN = vgui.Create("DButton", MobCategoryList )
				    countMobsBTN:SetText( "Count Mobs" )
				    countMobsBTN.DoClick = function()
				        RunConsoleCommand( "pnrp_countmobs" )
				    end
				MobCategoryList:AddItem( countMobsBTN )	
					
				local clearMobsBTN = vgui.Create("DButton", MobCategoryList )
				    clearMobsBTN:SetText( "Clear Mobs" )
				    clearMobsBTN.DoClick = function()
				        RunConsoleCommand( "pnrp_clearmobs" )
				    end
				MobCategoryList:AddItem( clearMobsBTN )
				
				local mobSpawnerTgl = vgui.Create( "DCheckBoxLabel", MobCategoryList )
					mobSpawnerTgl:SetText( "Mob Spawner" )
					mobSpawnerTgl.Label:SetColor(textColor)
					mobSpawnerTgl:SetValue( SpawnSettings.SpawnMobs )
					mobSpawnerTgl:SizeToContents() 
				MobCategoryList:AddItem( mobSpawnerTgl )
				
				local maxZombiesSlider = vgui.Create( "DNumSlider", MobCategoryList )
				    maxZombiesSlider:SetSize( MobSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    maxZombiesSlider:SetText( "Max Zombies (Default 30)" )
					maxZombiesSlider.Label:SetColor(textColor)
				    maxZombiesSlider:SetMin( 0 )
				    maxZombiesSlider:SetMax( 100 )
				    maxZombiesSlider:SetDecimals( 0 )
				    maxZombiesSlider:SetValue( SpawnSettings.MaxZombies )
					maxZombiesSlider.Label:SizeToContents()
				MobCategoryList:AddItem( maxZombiesSlider )
				
				local maxFastZombiesSlider = vgui.Create( "DNumSlider", MobCategoryList )
				    maxFastZombiesSlider:SetSize( MobSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    maxFastZombiesSlider:SetText( "Max Fast Zombies (Default 5)" )
					maxFastZombiesSlider.Label:SetColor(textColor)
				    maxFastZombiesSlider:SetMin( 0 )
				    maxFastZombiesSlider:SetMax( 100 )
				    maxFastZombiesSlider:SetDecimals( 0 )
				    maxFastZombiesSlider:SetValue( SpawnSettings.MaxFastZombies )
					maxFastZombiesSlider.Label:SizeToContents()
				MobCategoryList:AddItem( maxFastZombiesSlider )
				
				local maxPoisonZombiesSlider = vgui.Create( "DNumSlider", MobCategoryList )
				    maxPoisonZombiesSlider:SetSize( MobSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    maxPoisonZombiesSlider:SetText( "Max Poison Zombies (Default 2)" )
					maxPoisonZombiesSlider.Label:SetColor(textColor)
				    maxPoisonZombiesSlider:SetMin( 0 )
				    maxPoisonZombiesSlider:SetMax( 100 )
				    maxPoisonZombiesSlider:SetDecimals( 0 )
				    maxPoisonZombiesSlider:SetValue( SpawnSettings.MaxPoisonZombs )
					maxPoisonZombiesSlider.Label:SizeToContents()
				MobCategoryList:AddItem( maxPoisonZombiesSlider )
				
				local maxAntlionsSlider = vgui.Create( "DNumSlider", MobCategoryList )
				    maxAntlionsSlider:SetSize( MobSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    maxAntlionsSlider:SetText( "Max Antlions (Default 10)" )
					maxAntlionsSlider.Label:SetColor(textColor)
				    maxAntlionsSlider:SetMin( 0 )
				    maxAntlionsSlider:SetMax( 100 )
				    maxAntlionsSlider:SetDecimals( 0 )
				    maxAntlionsSlider:SetValue( SpawnSettings.MaxAntlions )
					maxAntlionsSlider.Label:SizeToContents()
				MobCategoryList:AddItem( maxAntlionsSlider )
				
				local maxAntGuardSlider = vgui.Create( "DNumSlider", MobCategoryList )
				    maxAntGuardSlider:SetSize( MobSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    maxAntGuardSlider:SetText( "Max Antlion Guards (Default 1)" )
					maxAntGuardSlider.Label:SetColor(textColor)
				    maxAntGuardSlider:SetMin( 0 )
				    maxAntGuardSlider:SetMax( 100 )
				    maxAntGuardSlider:SetDecimals( 0 )
				    maxAntGuardSlider:SetValue( SpawnSettings.MaxAntGuards )
					maxAntGuardSlider.Label:SizeToContents()
				MobCategoryList:AddItem( maxAntGuardSlider )
				
				SpawnerList:AddItem( MobSpawnerSettingsCats )
		--End Mob Spawn Settings
		--Start Mound Settings
				local MoundSpawnerSettingsCats = vgui.Create("DCollapsibleCategory", SpawnerList)
					MoundSpawnerSettingsCats:SetSize( SpawnerList:GetWide()-4, 50 ) -- Keep the second number at 50
					MoundSpawnerSettingsCats:SetExpanded( 0 ) -- Expanded when popped up
					MoundSpawnerSettingsCats:SetLabel( "Antlion Mound Spawner Settings" )
					 
					MoundCategoryList = vgui.Create( "DPanelList" )
					MoundCategoryList:SetAutoSize( true )
					MoundCategoryList:SetSpacing( 3 )
					MoundCategoryList:EnableHorizontal( false )
					MoundCategoryList:EnableVerticalScrollbar( true )
					MoundCategoryList.Paint = function()
						draw.RoundedBox( 8, 0, 0, MoundCategoryList:GetWide(), MoundCategoryList:GetTall(), Color( 50, 50, 50, 255 ) )
					end
					 
					MoundSpawnerSettingsCats:SetContents( MoundCategoryList )
					
				local clearMoundsBTN = vgui.Create("DButton", MobCategoryList )
				    clearMoundsBTN:SetText( "Clear Antlion Mounds" )
				    clearMoundsBTN.DoClick = function()
				        RunConsoleCommand( "pnrp_clearmounds" )
				    end
				MoundCategoryList:AddItem( clearMoundsBTN )
				
				local maxMounds = vgui.Create( "DNumSlider", MoundCategoryList )
				    maxMounds:SetSize( MoundSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    maxMounds:SetText( "Max Antlion Mounds (Default 1)" )
					maxMounds.Label:SetColor(textColor)
				    maxMounds:SetMin( 0 )
				    maxMounds:SetMax( 100 )
				    maxMounds:SetDecimals( 0 )
				    maxMounds:SetValue( SpawnSettings.MaxAntMounds )
					maxMounds.Label:SizeToContents()
				MoundCategoryList:AddItem( maxMounds )
				
				local moundSpawnRate = vgui.Create( "DNumSlider", MoundCategoryList )
				    moundSpawnRate:SetSize( MoundSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    moundSpawnRate:SetText( "Mound Spawn Rate (Default 5 minutes)" )
					moundSpawnRate.Label:SetColor(textColor)
				    moundSpawnRate:SetMin( 0 )
				    moundSpawnRate:SetMax( 100 )
				    moundSpawnRate:SetDecimals( 0 )
				    moundSpawnRate:SetValue( SpawnSettings.AntMoundRate )
					moundSpawnRate.Label:SizeToContents()
				MoundCategoryList:AddItem( moundSpawnRate )
				
				local moundSpawnChance = vgui.Create( "DNumSlider", MoundCategoryList )
				    moundSpawnChance:SetSize( MoundSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    moundSpawnChance:SetText( "Mound Spawn Chance (Default 15%)" )
					moundSpawnChance.Label:SetColor(textColor)
				    moundSpawnChance:SetMin( 0 )
				    moundSpawnChance:SetMax( 100 )
				    moundSpawnChance:SetDecimals( 0 )
				    moundSpawnChance:SetValue( SpawnSettings.AntMoundChance )
					moundSpawnChance.Label:SizeToContents()
				MoundCategoryList:AddItem( moundSpawnChance )
				
				local moundMaxAntlions = vgui.Create( "DNumSlider", MoundCategoryList )
				    moundMaxAntlions:SetSize( MoundSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    moundMaxAntlions:SetText( "Max Mound Antlions (Default 10)" )
					moundMaxAntlions.Label:SetColor(textColor)
				    moundMaxAntlions:SetMin( 0 )
				    moundMaxAntlions:SetMax( 100 )
				    moundMaxAntlions:SetDecimals( 0 )
				    moundMaxAntlions:SetValue( SpawnSettings.MaxMoundAntlions )
					moundMaxAntlions.Label:SizeToContents()
				MoundCategoryList:AddItem( moundMaxAntlions )
				
				local moundAntlionsPerCycle = vgui.Create( "DNumSlider", MoundCategoryList )
				    moundAntlionsPerCycle:SetSize( MoundSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    moundAntlionsPerCycle:SetText( "Mound Antlions Spawned Per Cycle (Default 5)" )
					moundAntlionsPerCycle.Label:SetColor(textColor)
				    moundAntlionsPerCycle:SetMin( 0 )
				    moundAntlionsPerCycle:SetMax( 100 )
				    moundAntlionsPerCycle:SetDecimals( 0 )
				    moundAntlionsPerCycle:SetValue( SpawnSettings.MoundAntlionsPerCycle )
					moundAntlionsPerCycle.Label:SizeToContents()
				MoundCategoryList:AddItem( moundAntlionsPerCycle )
				
				local moundMaxAntlionGuards = vgui.Create( "DNumSlider", MoundCategoryList )
				    moundMaxAntlionGuards:SetSize( MoundSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    moundMaxAntlionGuards:SetText( "Max Mound Antlion Guards (Default 1)" )
					moundMaxAntlionGuards.Label:SetColor(textColor)
				    moundMaxAntlionGuards:SetMin( 0 )
				    moundMaxAntlionGuards:SetMax( 100 )
				    moundMaxAntlionGuards:SetDecimals( 0 )
				    moundMaxAntlionGuards:SetValue( SpawnSettings.MaxMoundGuards )
					moundMaxAntlionGuards.Label:SizeToContents()
				MoundCategoryList:AddItem( moundMaxAntlionGuards )
				
				local moundMobRate = vgui.Create( "DNumSlider", MoundCategoryList )
				    moundMobRate:SetSize( MoundSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    moundMobRate:SetText( "Mound NPC Spawn Rate (Default 5 minutes)" )
					moundMobRate.Label:SetColor(textColor)
				    moundMobRate:SetMin( 0 )
				    moundMobRate:SetMax( 100 )
				    moundMobRate:SetDecimals( 0 )
				    moundMobRate:SetValue( SpawnSettings.AntMoundMobRate )
					moundMobRate.Label:SizeToContents()
				MoundCategoryList:AddItem( moundMobRate )
				
				local moundGuardChance = vgui.Create( "DNumSlider", MoundCategoryList )
				    moundGuardChance:SetSize( MoundSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    moundGuardChance:SetText( "Mound Antlion Guard Spawn Chance (Default 10%)" )
					moundGuardChance.Label:SetColor(textColor)
				    moundGuardChance:SetMin( 0 )
				    moundGuardChance:SetMax( 100 )
				    moundGuardChance:SetDecimals( 0 )
				    moundGuardChance:SetValue( SpawnSettings.MoundGuardChance )
					moundGuardChance.Label:SizeToContents()
				MoundCategoryList:AddItem( moundGuardChance )
				
				SpawnerList:AddItem( MoundSpawnerSettingsCats )
		--End Mound Settings
		--Start Resource Settings
				local RecSpawnerSettingsCats = vgui.Create("DCollapsibleCategory", SpawnerList)
					RecSpawnerSettingsCats:SetSize( SpawnerList:GetWide()-4, 50 ) -- Keep the second number at 50
					RecSpawnerSettingsCats:SetExpanded( 0 ) -- Expanded when popped up
					RecSpawnerSettingsCats:SetLabel( "Resource Spawner Settings" )
					 
					RecCategoryList = vgui.Create( "DPanelList" )
					RecCategoryList:SetAutoSize( true )
					RecCategoryList:SetSpacing( 5 )
					RecCategoryList:EnableHorizontal( false )
					RecCategoryList:EnableVerticalScrollbar( true )
					RecCategoryList.Paint = function()
						draw.RoundedBox( 8, 0, 0, RecCategoryList:GetWide(), RecCategoryList:GetTall(), Color( 50, 50, 50, 255 ) )
					end
					  
					RecSpawnerSettingsCats:SetContents( RecCategoryList )
				
				local countRecsBTN = vgui.Create("DButton", RecCategoryList )
				    countRecsBTN:SetText( "Count Resources" )
				    countRecsBTN.DoClick = function()
				        RunConsoleCommand( "pnrp_countres" )
				    end
				RecCategoryList:AddItem( countRecsBTN )
				
				local clearRecsBTN = vgui.Create("DButton", RecCategoryList )
				    clearRecsBTN:SetText( "Clear Resources" )
				    clearRecsBTN.DoClick = function()
				        RunConsoleCommand( "pnrp_clearres" )
				    end
				RecCategoryList:AddItem( clearRecsBTN )
				
				local recSpawnerTgl = vgui.Create( "DCheckBoxLabel", RecCategoryList )
					recSpawnerTgl:SetText( "Resource Spawner" )
					recSpawnerTgl:SetValue( SpawnSettings.ReproduceRes )
					recSpawnerTgl:SizeToContents() 
				RecCategoryList:AddItem( recSpawnerTgl )
				
				local maxReproducedRes = vgui.Create( "DNumSlider", RecCategoryList )
				    maxReproducedRes:SetSize( MobSpawnerSettingsCats:GetWide() - 20, 50 ) -- Keep the second number at 50
				    maxReproducedRes:SetText( "Max Resource Piles (Default 20)" )
					maxReproducedRes.Label:SetColor(textColor)
				    maxReproducedRes:SetMin( 0 )
				    maxReproducedRes:SetMax( 100 )
				    maxReproducedRes:SetDecimals( 0 )
				    maxReproducedRes:SetValue( SpawnSettings.MaxReproducedRes )
					maxReproducedRes.Label:SizeToContents()
				RecCategoryList:AddItem( maxReproducedRes )
				
				SpawnerList:AddItem( RecSpawnerSettingsCats )
		
		AdminTabSheet:AddSheet( "Spawn Settings", SpawnerList, "gui/icons/bug_add.png", false, false, "Spawn Settings" )
-- Event Settings EventsTbl
		local EventsList = vgui.Create( "DPanelList", AdminTabSheet )
				EventsList:SetPos( 10,10 )
				EventsList:SetSize( admin_frame:GetWide() - 10, admin_frame:GetTall() - 10 )
				EventsList:SetSpacing( 5 ) -- Spacing between items
				EventsList:EnableHorizontal( false ) -- Only vertical items
				EventsList:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis	

		for event, var in pairs(EventsTbl) do
			local EventsSettingsCats = buildEventList(event, var, EventsFunctions, EventsList)
			EventsList:AddItem( EventsSettingsCats )
		end
		AdminTabSheet:AddSheet( "Events", EventsList, "gui/icons/cog.png", false, false, "Events" )
		
-- Mob Grid Settings		
		local mobGridRange = 1000
		
		local mobGridSetup = vgui.Create( "DPanelList", AdminTabSheet )
				mobGridSetup:SetPos( 10,10 )
				mobGridSetup:SetSize( admin_frame:GetWide() - 10, admin_frame:GetTall() - 10 )
				mobGridSetup:SetSpacing( 5 ) -- Spacing between items
				mobGridSetup:EnableHorizontal( false ) -- Only vertical items
				mobGridSetup:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
				
			local mSGridBTN = vgui.Create("DButton", mobGridSetup )
				    mSGridBTN:SetText( "Save Grid" )
				    mSGridBTN.DoClick = function()
				        RunConsoleCommand("pnrp_savegrid" )
				    end
				mobGridSetup:AddItem( mSGridBTN )
				
			local mLGridBTN = vgui.Create("DButton", mobGridSetup )
				    mLGridBTN:SetText( "Load Grid" )
				    mLGridBTN.DoClick = function()
				        RunConsoleCommand("pnrp_loadgrid" )
				    end
				mobGridSetup:AddItem( mLGridBTN )
			
			local mSPGridBTN = vgui.Create("DButton", mobGridSetup )
				    mSPGridBTN:SetText( "Edit Grid" )
				    mSPGridBTN.DoClick = function()
				        RunConsoleCommand("pnrp_editgrid" )
				    end
				mobGridSetup:AddItem( mSPGridBTN )
			
			local mDLGridBTN = vgui.Create("DButton", mobGridSetup )
				    mDLGridBTN:SetText( "Remove Grid Entities" )
				    mDLGridBTN.DoClick = function()
				        RunConsoleCommand("pnrp_clearspawnnodes" )
				    end
				mobGridSetup:AddItem( mDLGridBTN )
			
			local mgDBLabel = vgui.Create("DLabel", mobGridSetup)
				--	mgDBLabel:SetPos(10, 25)
					mgDBLabel:SetText("Map Grids in Database")
					mgDBLabel:SizeToContents() 
				mobGridSetup:AddItem( mgDBLabel )
				
			local MapExpListView = vgui.Create( "DListView", mobGridSetup )
					MapExpListView:SetSize( mobGridSetup:GetWide(), 150 )
					MapExpListView:SetMultiSelect( false ) -- <removed sarcastic and useless comment>
					MapExpListView:AddColumn("Map Name")
					MapExpListView:AddColumn("Saved Nodes")
					for k, v in pairs( mapList ) do
						MapExpListView:AddLine( v["map"], v["nodes"] )
					end
				mobGridSetup:AddItem( MapExpListView )
			
			local mapExpBTN = vgui.Create("DButton", mobGridSetup )
				    mapExpBTN:SetText( "Export Map Grid" )
				    mapExpBTN.DoClick = function()
						if MapExpListView:GetSelectedLine() then
							local mapName = MapExpListView:GetLine(MapExpListView:GetSelectedLine()):GetValue(1)
							net.Start( "exportMapGrid" )
								net.WriteString(mapName)
							net.SendToServer()
						end
						admin_frame:Close() 
				    end
				mobGridSetup:AddItem( mapExpBTN )
				
			local mapDelBTN = vgui.Create("DButton", mobGridSetup )
				    mapDelBTN:SetText( "Delete Map Grid" )
				    mapDelBTN.DoClick = function()
						if MapExpListView:GetSelectedLine() then
							local mapName = MapExpListView:GetLine(MapExpListView:GetSelectedLine()):GetValue(1)
							net.Start( "deleteMapGrid" )
								net.WriteString(mapName)
							net.SendToServer()
						end
						admin_frame:Close() 
				    end
				mobGridSetup:AddItem( mapDelBTN )
			
			local mgIELabel = vgui.Create("DLabel", mobGridSetup)
				--	mgIELabel:SetPos(10, 25)
					mgIELabel:SetText("Map Grid Import / Export List")
					mgIELabel:SizeToContents() 
				mobGridSetup:AddItem( mgIELabel )
				
			local MapImpListView = vgui.Create( "DListView", mobGridSetup )
					MapImpListView:SetSize( mobGridSetup:GetWide(), 150 )
					MapImpListView:SetMultiSelect( false ) -- <removed sarcastic and useless comment>
					MapImpListView:AddColumn("Map Name")
					MapImpListView:AddColumn("Saved Nodes")
					for k, v in pairs( importList ) do
						MapImpListView:AddLine( v[1], v[2] )
					end
				
				mobGridSetup:AddItem( MapImpListView )
				
			local mapImpBTN = vgui.Create("DButton", mobGridSetup )
				    mapImpBTN:SetText( "Import Map Grid" )
				    mapImpBTN.DoClick = function()
						if MapImpListView:GetSelectedLine() then
							local impMapName = MapImpListView:GetLine(MapImpListView:GetSelectedLine()):GetValue(1)
							net.Start( "importMapGrid" )
								net.WriteString(impMapName)
							net.SendToServer()
						end
						admin_frame:Close() 
				    end
				mobGridSetup:AddItem( mapImpBTN )	
		AdminTabSheet:AddSheet( "Mob Grid Settings", mobGridSetup, "gui/icons/bug_edit.png", false, false, "Mob Grid Settings" )

				
		local saveBtn = vgui.Create("DButton") -- Create the button
			saveBtn:SetParent( admin_frame ) -- parent the button to the frame
			saveBtn:SetText( "Save Settings" ) -- set the button text
			saveBtn:SetPos(5, admin_frame:GetTall() - 30) -- set the button position in the frame
			saveBtn:SetSize( admin_frame:GetWide() - 10, 20 ) -- set the button size
			saveBtn.DoClick = function()  
			
				GMSettings.E2Restrict = tonumber(E2RestrictSlider:GetValue())
				GMSettings.ToolLevel = tonumber(ToolRestrictSlider:GetValue())
				GMSettings.AdminCreateAll = toIntfromBool(adminCreateAllTgl:GetChecked())
				GMSettings.AdminTouchAll = toIntfromBool(adminTouchAllTgl:GetChecked())
				GMSettings.AdminNoCost = toIntfromBool(adminNoCostTgl:GetChecked())
				GMSettings.PropBanning = toIntfromBool(propBanningTgl:GetChecked())
				GMSettings.PropAlowing = toIntfromBool(propAllowingTgl:GetChecked())
				GMSettings.PropSpawnProtection = toIntfromBool(propSpawnProtectTgl:GetChecked())
				GMSettings.PlyDeathZombie = toIntfromBool(plyDeathZombieTgl:GetChecked())
				GMSettings.PropPunt = toIntfromBool(PropPuntTgl:GetChecked())
				GMSettings.PropExp = toIntfromBool(PropExpTgl:GetChecked())
				GMSettings.PropPay = toIntfromBool(propPayTgl:GetChecked())
				GMSettings.PropCost = tonumber(propCostSlider:GetValue())
				GMSettings.VoiceLimiter = toIntfromBool(voiceLimitTgl:GetChecked())
				GMSettings.VoiceDistance = tonumber(voiceLimitSlider:GetValue())
				GMSettings.ClassChangePay = toIntfromBool(classCostTgl:GetChecked())
				GMSettings.ClassChangeCost = tonumber(classCostSlider:GetValue())
				GMSettings.DeathPay = toIntfromBool(deathCostTgl:GetChecked())
				GMSettings.DeathCost = tonumber(deathCostSlider:GetValue())
				GMSettings.MaxOwnDoors = tonumber(ownDoorsSlider:GetValue())
				
				SpawnSettings.SpawnMobs = toIntfromBool(mobSpawnerTgl:GetChecked())
				SpawnSettings.MaxZombies = tonumber(maxZombiesSlider:GetValue())
				SpawnSettings.MaxFastZombies = tonumber(maxFastZombiesSlider:GetValue())
				SpawnSettings.MaxPoisonZombs = tonumber(maxPoisonZombiesSlider:GetValue())
				SpawnSettings.MaxAntlions = tonumber(maxAntlionsSlider:GetValue())
				SpawnSettings.MaxAntGuards = tonumber(maxAntGuardSlider:GetValue())
				SpawnSettings.MaxAntMounds = tonumber(maxMounds:GetValue())
				SpawnSettings.AntMoundRate = tonumber(moundSpawnRate:GetValue())
				SpawnSettings.AntMoundChance = tonumber(moundSpawnChance:GetValue())
				SpawnSettings.MaxMoundAntlions = tonumber(moundMaxAntlions:GetValue())
				SpawnSettings.MoundAntlionsPerCycle = tonumber(moundAntlionsPerCycle:GetValue())
				SpawnSettings.MaxMoundGuards = tonumber(moundMaxAntlionGuards:GetValue())
				SpawnSettings.AntMoundMobRate = tonumber(moundMobRate:GetValue())
				SpawnSettings.MoundGuardChance = tonumber(moundGuardChance:GetValue())
				SpawnSettings.ReproduceRes = toIntfromBool(recSpawnerTgl:GetChecked())
				SpawnSettings.MaxReproducedRes = tonumber(maxReproducedRes:GetValue())
				
				--datastream.StreamToServer( "UpdateFromAdminMenu", { ["GMSettings"] = GMSettings, ["SpawnSettings"] = SpawnSettings })
				net.Start( "UpdateFromAdminMenu" )
					net.WriteTable(GMSettings)
					net.WriteTable(SpawnSettings)
				net.SendToServer()
			end 
	else
		ply:ChatPrint("You are not an admin on this server!")
	end
end
net.Receive( "pnrp_OpenAdminWindow", GM.open_admin )

function buildEventList(event, var, funcs, parent)
	local EventsSettingsCats = vgui.Create("DCollapsibleCategory", parent)
			EventsSettingsCats:SetSize( parent:GetWide()-4, 50 ) -- Keep the second number at 50
			EventsSettingsCats:SetExpanded( 0 ) -- Expanded when popped up
			EventsSettingsCats:SetLabel( event )
			 
			EventsSettingsList = vgui.Create( "DPanelList" )
			EventsSettingsList:SetAutoSize( true )
			EventsSettingsList:SetSpacing( 5 )
			EventsSettingsList:EnableHorizontal( false )
			EventsSettingsList:EnableVerticalScrollbar( true )
			
			EventsSettingsCats:SetContents( EventsSettingsList )
			
			for name, value in pairs(var) do
				local varPanel = vgui.Create( "DPanel", EventsSettingsList )
					varPanel:SetPos( 0,0 ) -- Set the position of the panel
					varPanel:SetSize( EventsSettingsCats:GetWide() - 20, 25 )
				
					local DLabel = vgui.Create( "DLabel", varPanel )
						DLabel:SetPos( 5, 5 ) -- Set the position of the label
						DLabel:SetText( name ) --  Set the text of the label
						DLabel:SizeToContents() -- Size the label to fit the text in it
						DLabel:SetDark( 1 )
					
					if string.Trim(tostring(value)) == "true" or string.Trim(tostring(value)) == "false" then
						local valueCheckBox = vgui.Create( "DCheckBoxLabel", varPanel )
							valueCheckBox:SetText( "" ) 
							valueCheckBox:SetPos(varPanel:GetWide() - 90, 5 )
							if string.Trim(tostring(value)) == "true" then
								value = 1
							else
								value = 0
							end
							valueCheckBox:SetValue( value )
						local DLabel = vgui.Create( "DLabel", varPanel )
							DLabel:SetPos( varPanel:GetWide() - 130, 5 ) -- Set the position of the label
							DLabel:SetText( "Enable" ) --  Set the text of the label
							DLabel:SizeToContents() -- Size the label to fit the text in it
							DLabel:SetDark( 1 )
							
						local funcSetBTN = vgui.Create("DButton", varPanel )
							funcSetBTN:SetPos(varPanel:GetWide() - 65, 2.5 )
							funcSetBTN:SetText( "Set" )
							funcSetBTN.DoClick = function()
								local sValue = valueCheckBox:GetValue()
								if sValue == 1 then sValue = "true"
								else sValue = "false" end	
								RunConsoleCommand( "pnrp_ev_setvar", event, name, sValue, "bool")
							end
					else
						local valueNWang = vgui.Create( "DNumberWang", varPanel )
							valueNWang:SetMin( 0 )
							valueNWang:SetMax( 10000 )
							valueNWang:SetDecimals( 0 )
							valueNWang:SetPos(varPanel:GetWide() - 135, 2 )
							valueNWang:SetValue( value )
						
						local funcSetBTN = vgui.Create("DButton", varPanel )
							funcSetBTN:SetPos(varPanel:GetWide() - 65, 2.5 )
							funcSetBTN:SetText( "Set" )
							funcSetBTN.DoClick = function()
								local sValue = valueNWang:GetValue()
								RunConsoleCommand( "pnrp_ev_setvar", event, name, sValue, "number")
							end
					end
						
						
					
						
				EventsSettingsList:AddItem( varPanel )
			end
			
			for _, fName in pairs(funcs[event]) do
				local funcBTN = vgui.Create("DButton", EventsSettingsList )
				    funcBTN:SetText( fName )
				    funcBTN.DoClick = function()
						RunConsoleCommand( "pnrp_ev_runfunc", event, fName)
						admin_frame:Close()
				    end
				EventsSettingsList:AddItem( funcBTN )	
			end
	return EventsSettingsCats
end

function GM.initAdmin(ply)
	if ply:IsAdmin() then	
		RunConsoleCommand("pnrp_OpenAdmin")
	else
		ply:ChatPrint("You are not an admin on this server!")
	end

end
concommand.Add( "pnrp_admin_window",  GM.initAdmin )

-----------------------------------------------------------------------------
function GM.OpenPropProtectWindow( )
	local BannedPropList = net.ReadTable()
	local AllowedPropList = net.ReadTable()
	local GM = GAMEMODE
	local ply = LocalPlayer()
	local tr = ply:TraceFromEyes(400)
	local ent = tr.Entity
	local model
	if ply:IsAdmin() then	
		pp_frame = vgui.Create( "DFrame" )
				pp_frame:SetSize( 500, 450 ) --Set the size
				pp_frame:SetPos(ScrW() / 2 - pp_frame:GetWide() / 2, ScrH() / 2 - pp_frame:GetTall() / 2) --Set the window in the middle of the players screen/game window
				pp_frame:SetTitle( " " ) --Set title
				pp_frame:SetVisible( true )
				pp_frame:SetDraggable( true )
				pp_frame:ShowCloseButton( false )
				pp_frame:MakePopup()
				pp_frame.Paint = function() -- Paint function
					surface.SetDrawColor( 50, 50, 50, 0 )
				end
			
		local pp_TabSheet = vgui.Create( "DPropertySheet" )
			pp_TabSheet:SetParent( pp_frame )
			pp_TabSheet:SetPos( 5, 25 )
			pp_TabSheet:SetSize( pp_frame:GetWide() - 10, pp_frame:GetTall() - 55 )
			
			local pBanPanel = vgui.Create( "DPanel", pp_TabSheet )
				pBanPanel:SetPos( 5, 5 )
				pBanPanel:SetSize( pp_TabSheet:GetWide(), pp_TabSheet:GetTall() )
				pBanPanel.Paint = function() -- Paint function
					surface.SetDrawColor( 50, 50, 50, 0 )
				end
			--//Banned Prop List//--
			local pnlBList = vgui.Create("DPanelListOld", pBanPanel)
				pnlBList:SetPos(5, 5)
				pnlBList:SetSize(pBanPanel:GetWide() - 125, pBanPanel:GetTall() - 40)
				pnlBList:EnableVerticalScrollbar(false) 
				pnlBList:EnableHorizontal(true) 
				pnlBList:SetSpacing(1)
				pnlBList:SetPadding(10)
				if BannedPropList != nil then
					for k, v in pairs( BannedPropList ) do		
						
						local slot = vgui.Create("SpawnIcon", pBanPanel)

						slot:SetModel(v)
						slot:SetToolTip(v)
						slot.DoClick = function()
							PNRP.RemoveItemVerify(v, 1)
						end
						
						pnlBList:AddItem(slot)
					end
				end
			local pp_add = vgui.Create("DButton") 
					pp_add:SetParent( pBanPanel ) 
					pp_add:SetText( "Add Item" ) 
					pp_add:SetPos(pnlBList:GetWide() + 15, 5)
					pp_add:SetSize( 100, 20 ) 
					pp_add.DoClick = function() 
						if tostring(ent) == "[NULL Entity]" or ent == nil or ent:IsWorld() then 
							pp_frame:Close()
							ply:ChatPrint("You are not looking at anything.")
						else
							model = tostring(ent:GetModel())
							ply:ChatPrint(model)

							net.Start("PropProtect_AddItem")
								net.WriteString(model)
								net.WriteDouble(1)
							net.SendToServer()
							pp_frame:Close()
							
							net.Start("Start_open_PropProtection")
							net.SendToServer()
						end
						
					end	
			local ppb_exit = vgui.Create("DButton") 
					ppb_exit:SetParent( pBanPanel ) 
					ppb_exit:SetText( "Exit" ) 
					ppb_exit:SetPos(pnlBList:GetWide() + 15, pnlBList:GetTall() - 20)
					ppb_exit:SetSize( 100, 20 ) 
					ppb_exit.DoClick = function() 
						pp_frame:Close()						
					end	
			pp_TabSheet:AddSheet( "Banned Props List", pBanPanel, "gui/icons/brick_add.png", false, false, "Banned Props List" )
			
			--//Allowed Prop List//--
			local pAllowedPanel = vgui.Create( "DPanel", pp_TabSheet )
				pAllowedPanel:SetPos( 5, 5 )
				pAllowedPanel:SetSize( pp_TabSheet:GetWide(), pp_TabSheet:GetTall() )
				pAllowedPanel.Paint = function() -- Paint function
					surface.SetDrawColor( 50, 50, 50, 0 )
				end
			local pnlAList = vgui.Create("DPanelListOld", pAllowedPanel)
				pnlAList:SetPos(5, 5)
				pnlAList:SetSize(pAllowedPanel:GetWide() - 125, pAllowedPanel:GetTall() - 40)
				pnlAList:EnableVerticalScrollbar(false) 
				pnlAList:EnableHorizontal(true) 
				pnlAList:SetSpacing(1)
				pnlAList:SetPadding(10)
				if AllowedPropList != nil then
					for k, v in pairs( AllowedPropList ) do		
						
						local slot = vgui.Create("SpawnIcon", pAllowedPanel)

						slot:SetModel(v)
						slot:SetToolTip(v)
						slot.DoClick = function()
							PNRP.RemoveItemVerify(v, 2)
						end
						
						pnlAList:AddItem(slot)
					end
				end
			local ppa_add = vgui.Create("DButton") 
					ppa_add:SetParent( pAllowedPanel ) 
					ppa_add:SetText( "Add Item" ) 
					ppa_add:SetPos(pnlAList:GetWide() + 15, 5)
					ppa_add:SetSize( 100, 20 ) 
					ppa_add.DoClick = function() 
						if tostring(ent) == "[NULL Entity]" or ent == nil or ent:IsWorld() then 
							pp_frame:Close()
							ply:ChatPrint("You are not looking at anything.")
						else
							model = tostring(ent:GetModel())
							ply:ChatPrint(model)
							
							net.Start("PropProtect_AddItem")
								net.WriteString(model)
								net.WriteDouble(2)
							net.SendToServer()
							pp_frame:Close()
							
							net.Start("Start_open_PropProtection")
							net.SendToServer()
						end
						
					end	
			local ppa_exit = vgui.Create("DButton") 
					ppa_exit:SetParent( pAllowedPanel ) 
					ppa_exit:SetText( "Exit" ) 
					ppa_exit:SetPos(pnlAList:GetWide() + 15, pnlAList:GetTall() - 20)
					ppa_exit:SetSize( 100, 20 ) 
					ppa_exit.DoClick = function() 
						pp_frame:Close()						
					end	
			pp_TabSheet:AddSheet( "Allowed Props List", pAllowedPanel, "gui/icons/brick_add.png", false, false, "Allowed Props List" )
	end
end
net.Receive( "pnrp_OpenPropProtectWindow", GM.OpenPropProtectWindow )

function PNRP.RemoveItemVerify(model, switch)
	local ply = LocalPlayer()
	if ply:IsAdmin() then	
		local ppv_frame = vgui.Create( "DFrame" )
				ppv_frame:SetSize( 175, 85 ) --Set the size
				ppv_frame:SetPos(ScrW() / 2 - ppv_frame:GetWide() / 2, ScrH() / 2 - ppv_frame:GetTall() / 2) --Set the window in the middle of the players screen/game window
				ppv_frame:SetTitle( "Prop Protection Menu" ) --Set title
				ppv_frame:SetVisible( true )
				ppv_frame:SetDraggable( true )
				ppv_frame:ShowCloseButton( true )
				ppv_frame:MakePopup()
				
			local ppvLabel = vgui.Create("DLabel", ppv_frame)
				ppvLabel:SetPos(15, 30)
				ppvLabel:SetColor( Color( 0, 0, 0, 255 ) )
				ppvLabel:SetText( "Delete this item from the list?" )
				ppvLabel:SizeToContents()
				
				local ppv_yes = vgui.Create("DButton") -- Create the button
					ppv_yes:SetParent( ppv_frame ) -- parent the button to the frame
					ppv_yes:SetText( "Yes" ) -- set the button text
					ppv_yes:SetPos(30, 50) -- set the button position in the frame
					ppv_yes:SetSize( 50, 20 ) -- set the button size
					ppv_yes.DoClick = function() 
						
						net.Start("PropProtect_RemoveItem")
							net.WriteString(model)
							net.WriteDouble(switch)
						net.SendToServer()
						ppv_frame:Close() 
						pp_frame:Close() 
						
						net.Start("Start_open_PropProtection")
						net.SendToServer()
					end 
				
				local ppv_no = vgui.Create("DButton") -- Create the button
					ppv_no:SetParent( ppv_frame ) -- parent the button to the frame
					ppv_no:SetText( "No" ) -- set the button text
					ppv_no:SetPos(85, 50) -- set the button position in the frame
					ppv_no:SetSize( 50, 20 ) -- set the button size
					ppv_no.DoClick = function() ppv_frame:Close() end
					
	end
end

local plyADM_frame
local plyADMSearchBody_Frame
local profileADM_frame
function GM.OpenPlyAdminLstWindow( )
	local GM = GAMEMODE
	local ply = LocalPlayer()
	local Players =  net.ReadTable()
	
	plyADM_frame = PNRP.PNRP_Frame()
	if not plyADM_frame then return end

	plyADM_frame:SetSize( 575, 265 ) 
	plyADM_frame:SetPos(ScrW() / 2 - plyADM_frame:GetWide() / 2, ScrH() / 2 - plyADM_frame:GetTall() / 2)
	plyADM_frame:SetTitle( " " )
	plyADM_frame:SetVisible( true )
	plyADM_frame:SetDraggable( false )
	plyADM_frame:ShowCloseButton( true )
	plyADM_frame:MakePopup()
	plyADM_frame.Paint = function() 
		surface.SetDrawColor( 50, 50, 50, 0 )
	end
	
	local screenBG = vgui.Create("DImage", plyADM_frame)
		screenBG:SetImage( "VGUI/gfx/pnrp_screen_6b.png" )
		screenBG:SetSize(plyADM_frame:GetWide(), plyADM_frame:GetTall())	
	
	--Creates the body to keep it from beeing nil
	plyADMSearchBody_Frame = vgui.Create( "DPanel", plyADM_frame )
		plyADMSearchBody_Frame:SetPos( 30, 33 ) -- Set the position of the panel
		plyADMSearchBody_Frame:SetSize( plyADM_frame:GetWide() - 250, plyADM_frame:GetTall() - 40)
		plyADMSearchBody_Frame.Paint = function() 
		--	surface.SetDrawColor( 50, 50, 50, 0 )
		end
	plyADMBTN_Panel = vgui.Create( "DPanel", plyADM_frame )
		plyADMBTN_Panel:SetPos( plyADM_frame:GetWide() - 215, plyADM_frame:GetTall() - 100 )
		plyADMBTN_Panel:SetSize( 250, 100 )
		plyADMBTN_Panel.Paint = function() 
		--	surface.SetDrawColor( 50, 50, 50, 0 )
		end
		
	--Search Bar
		plyADMSearchPanel = vgui.Create( "DPanel", plyADM_frame )
			plyADMSearchPanel:SetPos( 370, 35 ) -- Set the position of the panel
			plyADMSearchPanel:SetSize( 155, 100 )
			plyADMSearchPanel.Paint = function() 
				surface.SetDrawColor( 50, 50, 50, 0 )
			end
		local DLabel = vgui.Create( "DLabel", plyADMSearchPanel )
			DLabel:SetPos( 5, 5 )
			DLabel:SetText( "ADM Player Search" )
			DLabel:SizeToContents()		
		local plyADMNameTxt = vgui.Create("DTextEntry", plyADMSearchPanel)
			plyADMNameTxt:SetText("")
			plyADMNameTxt:SetPos(5,25)
			plyADMNameTxt:SetWide(150)
			plyADMNameTxt.OnEnter = function()
				plyADMSearchBody_Frame:Remove()
				net.Start("SND_plyADMSearch")
					net.WriteString(plyADMNameTxt:GetValue())
					net.WriteString("name")
				net.SendToServer()
			end
		local DButton = vgui.Create( "DButton", plyADMSearchPanel )
			 DButton:SetPos( 5, 55 )
			 DButton:SetText( "Search Name" )
			 DButton:SetSize( 150, 20 )
			 DButton.DoClick = function()
				plyADMSearchBody_Frame:Remove()
				net.Start("SND_plyADMSearch")
					net.WriteString(plyADMNameTxt:GetValue())
					net.WriteString("name")
				net.SendToServer()
			 end
		local SButton = vgui.Create( "DButton", plyADMSearchPanel )
			 SButton:SetPos( 5, 75 )
			 SButton:SetText( "Search SteamID" )
			 SButton:SetSize( 150, 20 )
			 SButton.DoClick = function()
				plyADMSearchBody_Frame:Remove()
				net.Start("SND_plyADMSearch")
					net.WriteString(plyADMNameTxt:GetValue())
					net.WriteString("steamid")
				net.SendToServer()
			 end
	
end
net.Receive( "pnrp_OpenPlyAdminLstWindow", GM.OpenPlyAdminLstWindow )

function plyADMDispResults()
	local result = net.ReadTable()
	local ply = LocalPlayer()
	
	if not plyADM_frame then return end
	
	if !ply:IsAdmin() then
		ply:ChatPrint("You are not an admin on this server!")
		return
	end

	plyADMSearchBody_Frame = vgui.Create( "DPanel", plyADM_frame )
		plyADMSearchBody_Frame:SetPos( 25, 40 ) -- Set the position of the panel
		plyADMSearchBody_Frame:SetSize( plyADM_frame:GetWide() - 260, plyADM_frame:GetTall() - 40)
		plyADMSearchBody_Frame.Paint = function() 
		--	surface.SetDrawColor( 50, 50, 50, 0 )
		end
		
	local plyList = vgui.Create("DPanelList", plyADMSearchBody_Frame)
		plyList:SetPos(0, 0)
		plyList:SetSize(plyADMSearchBody_Frame:GetWide() - 5, plyADMSearchBody_Frame:GetTall() - 40)
		plyList:EnableVerticalScrollbar(true) 
		plyList:EnableHorizontal(false) 
		plyList:SetSpacing(1)
		plyList:SetPadding(10)
	
		for k, v in pairs(result) do
			local plyPanel = vgui.Create("DPanel")
				plyPanel:SetTall(25)
				plyPanel.Paint = function()
					draw.RoundedBox( 6, 0, 0, plyPanel:GetWide(), plyPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
				end
				plyList:AddItem(plyPanel)
					
				local textCom = tostring(v["name"])
				
				plyPanel.Name = vgui.Create("DLabel", plyPanel)
				plyPanel.Name:SetPos(5, 5)
				plyPanel.Name:SetText(textCom)
				plyPanel.Name:SetColor(Color( 0, 255, 0, 255 ))
				plyPanel.Name:SizeToContents() 
				plyPanel.Name:SetContentAlignment( 5 )
				
				local DButton = vgui.Create( "DButton", plyPanel )
					DButton:SetPos( 225 , 3 )
					DButton:SetText( "Select" )
					DButton:SetSize( 50, 20 )
					DButton.DoClick = function()
						plyADMSearchBody_Frame:Remove()

						net.Start("SND_plyADMSelSID")
							net.WriteString(v["steamid"])
						net.SendToServer()
					end
		end
	
end
net.Receive("C_SND_plyADMSearchResults", plyADMDispResults)

function PlyAdminDispPlayer()
	local playerTBL = net.ReadTable()
	local profileTBL = net.ReadTable()
	local CommunityTBL = net.ReadTable()
	local ply = LocalPlayer()
	playerTBL = playerTBL[1]
	
	if not plyADM_frame then return end
	
	if !ply:IsAdmin() then
		ply:ChatPrint("You are not an admin on this server!")
		return
	end

	plyADMSearchBody_Frame = vgui.Create( "DPanel", plyADM_frame )
		plyADMSearchBody_Frame:SetPos( 25, 35 ) -- Set the position of the panel
		plyADMSearchBody_Frame:SetSize( plyADM_frame:GetWide() - 270, plyADM_frame:GetTall() - 30)
		plyADMSearchBody_Frame.Paint = function() 
		--	surface.SetDrawColor( 50, 50, 50, 0 )
		end
		
		local plyADMPanel = vgui.Create("DPanel", plyADMSearchBody_Frame)
			plyADMPanel:SetPos( 0, 0 )
			plyADMPanel:SetSize(plyADMSearchBody_Frame:GetWide() - 5, plyADMSearchBody_Frame:GetTall() - 40)
			plyADMPanel.Paint = function()
			--	draw.RoundedBox( 6, 0, 0, plyADMPanel:GetWide(), plyADMPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
			end

			local plyName = vgui.Create("DLabel", plyADMPanel)
				plyName:SetPos(10, 5)
				plyName:SetText("Name: "..tostring(playerTBL["name"]))
				plyName:SetColor(Color( 0, 255, 0, 255 ))
				plyName:SizeToContents() 
				plyName:SetContentAlignment( 5 )
			local steamIDTxt = vgui.Create("DLabel", plyADMPanel)
				steamIDTxt:SetPos(10, 20)
				steamIDTxt:SetText("SteamID:")
				steamIDTxt:SetColor(Color( 0, 255, 0, 255 ))
				steamIDTxt:SizeToContents() 
				steamIDTxt:SetContentAlignment( 5 )
			local TextSteamID = vgui.Create( "DTextEntry", plyADMPanel )
				TextSteamID:SetPos( 50, 20 )
				TextSteamID:SetSize( 115, 15 )
				TextSteamID:SetText( tostring(playerTBL["steamid"]) )
			local ipTxt = vgui.Create("DLabel", plyADMPanel)
				ipTxt:SetPos(10, 35)
				ipTxt:SetText("IP:")
				ipTxt:SetColor(Color( 0, 255, 0, 255 ))
				ipTxt:SizeToContents() 
				ipTxt:SetContentAlignment( 5 )
			local TextIP = vgui.Create( "DTextEntry", plyADMPanel )
				TextIP:SetPos( 35, 35 )
				TextIP:SetSize( 115, 15 )
				TextIP:SetText( tostring(playerTBL["ip"]) )
			local FirstOnTxt = vgui.Create("DLabel", plyADMPanel)
				FirstOnTxt:SetPos(165, 20)
				FirstOnTxt:SetText("Joined: "..tostring(playerTBL["first_joined"]))
				FirstOnTxt:SetColor(Color( 0, 255, 0, 255 ))
				FirstOnTxt:SizeToContents() 
				FirstOnTxt:SetContentAlignment( 5 )
			local LastOnTxt = vgui.Create("DLabel", plyADMPanel)
				LastOnTxt:SetPos(160, 35)
				LastOnTxt:SetText("Last On: "..tostring(playerTBL["last_joined"]))
				LastOnTxt:SetColor(Color( 0, 255, 0, 255 ))
				LastOnTxt:SizeToContents() 
				LastOnTxt:SetContentAlignment( 5 )
			
			local profilePanel = vgui.Create( "DPanel", plyADMPanel )
				profilePanel:SetPos( 10, 50 )
				profilePanel:SetSize( plyADMPanel:GetWide(), plyADMPanel:GetTall() - 50 )
				profilePanel.Paint = function() -- Paint function
				--	surface.SetDrawColor( 50, 50, 50, 0 )
					draw.RoundedBox( 1, 0, 0, profilePanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
					draw.RoundedBox( 1, 0, profilePanel:GetTall()-1, profilePanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
				end			
			local profileList = vgui.Create("DPanelList", profilePanel)
				profileList:SetPos(-10, 0)
				profileList:SetSize(profilePanel:GetWide()-5, profilePanel:GetTall()-2)
				profileList:EnableVerticalScrollbar(true) 
				profileList:EnableHorizontal(false) 
				profileList:SetSpacing(1)
				profileList:SetPadding(10)
				profileList.Paint = function()
				--	draw.RoundedBox( 8, 0, 0, profileList:GetWide(), profileList:GetTall(), Color( 50, 50, 50, 255 ) )
				end
				
				for k, v in pairs(profileTBL) do
					local pPanel = vgui.Create("DPanel")
						pPanel:SetTall(40)
						pPanel.Paint = function()
						--	draw.RoundedBox( 6, 0, 0, pPanel:GetWide(), pPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
							draw.RoundedBox( 1, 0, 0, pPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
							draw.RoundedBox( 1, 0, pPanel:GetTall()-1, pPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
						end
						profileList:AddItem(pPanel)
						
						pPanel.Icon = vgui.Create("SpawnIcon", pPanel)
						pPanel.Icon:SetSize( 35, 35 )
						pPanel.Icon:SetModel(v["model"])
						pPanel.Icon:SetPos(10, 2)
						pPanel.Icon:SetToolTip( "Last On: "..tostring(v["lastlog"]) )
						pPanel.Icon.DoClick = function()
							net.Start("SND_plyADMSelProfile")
								net.WriteString(v["pid"])
							net.SendToServer()
							
							if profileADM_frame then profileADM_frame:Remove() end
						end
						
						pPanel.Name = vgui.Create("DLabel", pPanel)
						pPanel.Name:SetPos(50, 3)
						pPanel.Name:SetText("Name: "..tostring(v["nick"]))
						pPanel.Name:SetColor(Color( 0, 255, 0, 255 ))
						pPanel.Name:SizeToContents() 
						pPanel.Name:SetContentAlignment( 5 )
						
						pPanel.Class = vgui.Create("DLabel", pPanel)
						pPanel.Class:SetPos(50, 14)
						pPanel.Class:SetText("Class: "..team.GetName(tonumber(v["class"])))
						pPanel.Class:SetColor(Color( 0, 255, 0, 255 ))
						pPanel.Class:SizeToContents() 
						pPanel.Class:SetContentAlignment( 5 )

						if CommunityTBL[v["pid"]] then
							local comInfo = CommunityTBL[v["pid"]]
							
							pPanel.Community = vgui.Create("DLabel", pPanel)
							pPanel.Community:SetPos(50, 25)
							pPanel.Community:SetText("Community: "..tostring(comInfo["cname"]))
							pPanel.Community:SetColor(Color( 0, 255, 0, 255 ))
							pPanel.Community:SizeToContents() 
							pPanel.Community:SetContentAlignment( 5 )
							
							pPanel.Rank = vgui.Create("DLabel", pPanel)
							pPanel.Rank:SetPos(225, 3)
							pPanel.Rank:SetText("Rank: "..tostring(comInfo["rank"]))
							pPanel.Rank:SetColor(Color( 0, 255, 0, 255 ))
							pPanel.Rank:SizeToContents() 
							pPanel.Rank:SetContentAlignment( 5 )
							
							pPanel.Title = vgui.Create("DLabel", pPanel)
							pPanel.Title:SetPos(150, 14)
							pPanel.Title:SetText("Title: "..tostring(comInfo["title"]))
							pPanel.Title:SetColor(Color( 0, 255, 0, 255 ))
							pPanel.Title:SizeToContents() 
							pPanel.Title:SetContentAlignment( 5 )
						end
				end
	
end
net.Receive("C_SND_PlyAdminSelResult", PlyAdminDispPlayer)

local Inventory_DPanel
local Inventory_TabSheet
local pnlUserInv_DPanel
local pnlUserInvList
local storageADM_frame
local vendorADM_frame
function PlyAdminProfileView()
	local playerTBL = net.ReadTable()
	local inventoryTBL = net.ReadTable()
	local communityTBL = net.ReadTable()
	local storageTBL = net.ReadTable()
	local vendorTBL = net.ReadTable()
	local ply = LocalPlayer()
	
	if !ply:IsAdmin() then
		ply:ChatPrint("You are not an admin on this server!")
		return
	end
	
	local playerOnline, targetPly
	for _, p in pairs(player.GetAll()) do
		if tostring(p:GetNetVar("pid", nil)) == tostring(playerTBL["pid"]) then
			playerOnline = true
			targetPly = p
		end
	end
	
	profileADM_frame = vgui.Create( "DFrame" )
	profileADM_frame:SetSize( 710, 510 ) --Set the size Extra 40 must be from the top bar
		--Set the window in the middle of the players screen/game window
		profileADM_frame:SetPos(ScrW() / 2 - profileADM_frame:GetWide() / 2, ScrH() / 2 - profileADM_frame:GetTall() / 2) 
		profileADM_frame:SetTitle( "Player Info" ) --Set title
		profileADM_frame:SetVisible( true )
		profileADM_frame:SetDraggable( true )
		profileADM_frame:ShowCloseButton( true )
		profileADM_frame:MakePopup()
		profileADM_frame.Paint = function() 
			surface.SetDrawColor( 50, 50, 50, 0 )
		end
		
		local screenBG = vgui.Create("DImage", profileADM_frame)
			screenBG:SetImage( "VGUI/gfx/pnrp_screen_2b.png" )
			screenBG:SetSize(profileADM_frame:GetWide(), profileADM_frame:GetTall())
		
		local onlineTxt = "Offline"
		local onlineColor = Color( 170, 10, 0, 255 )
		if playerOnline then
			onlineTxt = "Online"
			onlineColor = Color( 0, 200, 0, 255 )
		end
		local isOnlineTxt = vgui.Create( "DLabel", profileADM_frame)
			isOnlineTxt:SetPos(50, 35)
			isOnlineTxt:SetText(onlineTxt)
			isOnlineTxt:SetColor(onlineColor)
			isOnlineTxt:SetFont("Trebuchet24")
			isOnlineTxt:SizeToContents()

					
		local mdl = vgui.Create( "DModelPanel", profileADM_frame )
			mdl:SetSize( 350, 740 )
			mdl:SetPos(-60,-125)
			mdl.Angles = Angle( 0, 0, 0 )			
			mdl:SetFOV( 36 )
			mdl:SetCamPos( Vector( 0, 0, 0 ) )
			mdl:SetDirectionalLight( BOX_RIGHT, Color( 255, 160, 80, 255 ) )
			mdl:SetDirectionalLight( BOX_LEFT, Color( 80, 160, 255, 255 ) )
			mdl:SetAmbientLight( Vector( -64, -64, -64 ) )
			mdl:SetAnimated( true )
			mdl:SetLookAt( Vector( -100, 0, -22 ) )
			
			mdl:SetModel( playerTBL["model"] ) -- you can only change colors on playermodels
		--	function mdl.Entity:GetPlayerColor() return Vector( GetConVarString( "cl_playercolor" ) ) end
			
			mdl.Entity:SetPos( Vector( -100, 0, -61 ) )
	
			-- Hold to rotate
			function mdl:DragMousePress()
				self.PressX, self.PressY = gui.MousePos()
				self.Pressed = true
			end

			function mdl:DragMouseRelease() self.Pressed = false end

			function mdl:LayoutEntity( Entity )

				if ( self.Pressed ) then
					local mx, my = gui.MousePos()
					self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
					
					self.PressX, self.PressY = gui.MousePos()
				end

				Entity:SetAngles( self.Angles )
			end
			
		local profileAdm_TabSheet = vgui.Create( "DPropertySheet" )
			profileAdm_TabSheet:SetParent( profileADM_frame )
			profileAdm_TabSheet:SetPos( 200, 45 )
			profileAdm_TabSheet:SetSize( profileADM_frame:GetWide() - 250, profileADM_frame:GetTall() - 90 )
			profileAdm_TabSheet.Paint = function() -- Paint function
				surface.SetDrawColor( 50, 50, 50, 0 )
			end
			
			local pInfoPanel = vgui.Create( "DPanel", profileAdm_TabSheet )
				pInfoPanel:SetPos( 5, 5 )
				pInfoPanel:SetSize( profileAdm_TabSheet:GetWide(), profileAdm_TabSheet:GetTall() )
				pInfoPanel.Paint = function() -- Paint function
					surface.SetDrawColor( 50, 50, 50, 0 )
				end
			
				local name = vgui.Create("DLabel", pInfoPanel)
					name:SetPos(0, 10)
					name:SetText("Name: ")
					name:SetColor(Color( 0, 200, 0, 255 ))
					name:SetFont("Trebuchet24")
					name:SizeToContents()
				local TextName = vgui.Create( "DTextEntry", pInfoPanel )
					TextName:SetPos( 60, 12 )
					TextName:SetSize( 175, 22 )
					TextName:SetText( playerTBL["nick"] )
					TextName.OnEnter = function( self )
						
					end
				local NameChangeBtn = vgui.Create("DButton", pInfoPanel )
					NameChangeBtn:SetPos(250, 12)
					NameChangeBtn:SetSize(90,20)
					NameChangeBtn:SetText( "Change Name" )
					NameChangeBtn.DoClick = function()
						net.Start("SND_AdmEditPlayer")
							net.WriteString("changeName")
							net.WriteString(playerTBL["pid"])
							net.WriteString(TextName:GetValue())
						net.SendToServer()
					end
					
				function chName(newName)
					net.Start("PNRP_ChangeRPName")
						net.WriteString(TextName:GetValue())
					net.SendToServer()
				end
				
				local class = vgui.Create("DLabel", pInfoPanel)
					class:SetPos(0, 40)
					class:SetText("Class: "..team.GetName(tonumber(playerTBL["class"])))
					class:SetColor(Color( 0, 255, 0, 255 ))
					class:SetFont("HudHintTextLarge")
					class:SizeToContents() 
				local community = vgui.Create("DLabel", pInfoPanel)
					community:SetPos(0, 65)
					community:SetText("Member of "..tostring(communityTBL["cname"]))
					community:SetColor(Color( 0, 255, 0, 255 ))
					community:SetFont("HudHintTextLarge")
					community:SizeToContents() 
				local rank = vgui.Create("DLabel", pInfoPanel)
					rank:SetPos(0, 80)
					rank:SetText("Rank: "..tostring(communityTBL["rank"]))
					rank:SetColor(Color( 0, 200, 0, 255 ))
					rank:SetFont("HudHintTextLarge")
					rank:SizeToContents() 
				local title = vgui.Create("DLabel", pInfoPanel)
					title:SetPos(0, 95)
					title:SetText("Title: "..tostring(communityTBL["title"]))
					title:SetColor(Color( 0, 200, 0, 255 ))
					title:SetFont("HudHintTextLarge")
					title:SizeToContents()
					
				--Player Resources
				local res = string.Explode(",", playerTBL["res"])
				local scrapLbl = vgui.Create("DLabel", pInfoPanel)
					scrapLbl:SetPos(0, 120)
					scrapLbl:SetText("Scrap: ")
					scrapLbl:SetColor(Color( 0, 200, 0, 255 ))
					scrapLbl:SetFont("HudHintTextLarge")
					scrapLbl:SizeToContents()
				local scrapTxt = vgui.Create( "DTextEntry", pInfoPanel )
					scrapTxt:SetPos( 60, 120 )
					scrapTxt:SetSize( 50, 15 )
					scrapTxt:SetText( res[1] )
				local spLbl = vgui.Create("DLabel", pInfoPanel)
					spLbl:SetPos(0, 137)
					spLbl:SetText("SP: ")
					spLbl:SetColor(Color( 0, 200, 0, 255 ))
					spLbl:SetFont("HudHintTextLarge")
					spLbl:SizeToContents()
				local spText = vgui.Create( "DTextEntry", pInfoPanel )
					spText:SetPos( 60, 137 )
					spText:SetSize( 50, 15 )
					spText:SetText( res[2] )
				local chemLbl = vgui.Create("DLabel", pInfoPanel)
					chemLbl:SetPos(0, 155)
					chemLbl:SetText("Chems: ")
					chemLbl:SetColor(Color( 0, 200, 0, 255 ))
					chemLbl:SetFont("HudHintTextLarge")
					chemLbl:SizeToContents()
				local chemTxt = vgui.Create( "DTextEntry", pInfoPanel )
					chemTxt:SetPos( 60, 155 )
					chemTxt:SetSize( 50, 15 )
					chemTxt:SetText( res[3] )
				local UpdateResBtn = vgui.Create("DButton", pInfoPanel )
					UpdateResBtn:SetPos(110, 120)
					UpdateResBtn:SetSize(75,15)
					UpdateResBtn:SetText( "Update Res" )
					UpdateResBtn.DoClick = function()
						if playerOnline then 
							openTradeToMenu(ply, targetPly, "admin_trade")
							profileADM_frame:Remove()
						else
							local resStr = scrapTxt:GetValue()..","..spText:GetValue()..","..chemTxt:GetValue()
							net.Start("SND_AdmEditPlayer")
								net.WriteString("editRes")
								net.WriteString(playerTBL["pid"])
								net.WriteString(resStr)
							net.SendToServer()
						end
					end
					if playerOnline then
						UpdateResBtn:SetText( "Admin Trade" )
						scrapTxt:SetDisabled(true) 
						spText:SetDisabled(true) 
						chemTxt:SetDisabled(true) 
					end
					
				local lastlogTxt = vgui.Create("DLabel", pInfoPanel)
					lastlogTxt:SetPos(175, 40)
					lastlogTxt:SetText("Last Logged On: "..playerTBL["lastlog"])
					lastlogTxt:SetColor(Color( 0, 200, 0, 255 ))
					lastlogTxt:SetFont("HudHintTextLarge")
					lastlogTxt:SizeToContents()
					
				local SteamIDLbl = vgui.Create("DLabel", pInfoPanel)
					SteamIDLbl:SetPos(235, 55)
					SteamIDLbl:SetText("SteamID: ")
					SteamIDLbl:SetColor(Color( 0, 200, 0, 255 ))
					SteamIDLbl:SetFont("HudHintTextLarge")
					SteamIDLbl:SizeToContents()
				local SteamIDTxt = vgui.Create( "DTextEntry", pInfoPanel )
					SteamIDTxt:SetPos( 300, 55 )
					SteamIDTxt:SetSize( 125, 15 )
					SteamIDTxt:SetDisabled(true) 
					SteamIDTxt:SetText( playerTBL["steamid"] )
				local ipTxt = vgui.Create("DLabel", pInfoPanel)
					ipTxt:SetPos(235, 70)
					ipTxt:SetText("IP: "..playerTBL["ip"])
					ipTxt:SetColor(Color( 0, 200, 0, 255 ))
					ipTxt:SetFont("HudHintTextLarge")
					ipTxt:SizeToContents()
				
				local healthLbl = vgui.Create("DLabel", pInfoPanel)
					healthLbl:SetPos(235, 105)
					healthLbl:SetText("HP: "..tostring(playerTBL["health"]))
					healthLbl:SetColor(Color( 0, 200, 0, 255 ))
					healthLbl:SetFont("HudHintTextLarge")
					healthLbl:SizeToContents()
				local powerLbl = vgui.Create("DLabel", pInfoPanel)
					powerLbl:SetPos(235, 120)
					powerLbl:SetText("Power: "..tostring(playerTBL["armor"]))
					powerLbl:SetColor(Color( 0, 200, 0, 255 ))
					powerLbl:SetFont("HudHintTextLarge")
					powerLbl:SizeToContents()
				local endLbl = vgui.Create("DLabel", pInfoPanel)
					endLbl:SetPos(235, 135)
					endLbl:SetText("End: "..tostring(playerTBL["endurance"]))
					endLbl:SetColor(Color( 0, 200, 0, 255 ))
					endLbl:SetFont("HudHintTextLarge")
					endLbl:SizeToContents()
				local hungerLbl = vgui.Create("DLabel", pInfoPanel)
					hungerLbl:SetPos(235, 150)
					hungerLbl:SetText("Hunger: "..tostring(playerTBL["hunger"]))
					hungerLbl:SetColor(Color( 0, 200, 0, 255 ))
					hungerLbl:SetFont("HudHintTextLarge")
					hungerLbl:SizeToContents()
				
				--Player Equipped Weapons
				local EqWepTxt = vgui.Create("DLabel", pInfoPanel)
					EqWepTxt:SetPos(5, 175)
					EqWepTxt:SetText("Equiped Weapons:")
					EqWepTxt:SetColor(Color( 0, 255, 0, 255 ))
					EqWepTxt:SetFont("HudHintTextLarge")
					EqWepTxt:SizeToContents()				
				local wepList = vgui.Create("DPanelList", pInfoPanel)
					wepList:SetPos(0, 190)
					wepList:SetSize(200, 195)
					wepList:EnableVerticalScrollbar(true) 
					wepList:EnableHorizontal(false) 
					wepList:SetSpacing(1)
					wepList:SetPadding(10)
					wepList.Paint = function()	end
					
					local weaponsTbl = string.Explode(",", playerTBL["weapons"])
					if playerOnline then weaponsTbl = targetPly:GetWeapons() end
					for _, v in pairs(weaponsTbl) do
						if playerOnline then v = tostring(v:GetClass()) end
						for itemname, item in pairs( PNRP.Items ) do
							if v == item.Ent then
								local pPanel = vgui.Create("DPanel")
									pPanel:SetTall(40)
									pPanel.Paint = function()
									--	draw.RoundedBox( 6, 0, 0, pPanel:GetWide(), pPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
										draw.RoundedBox( 1, 0, 0, pPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
										draw.RoundedBox( 1, 0, pPanel:GetTall()-1, pPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
									end
									wepList:AddItem(pPanel)
									
									pPanel.Icon = vgui.Create("SpawnIcon", pPanel)
									pPanel.Icon:SetSize( 35, 35 )
									pPanel.Icon:SetModel(item.Model)
									pPanel.Icon:SetPos(10, 2)
									pPanel.Icon:SetToolTip( nil )
									pPanel.Icon.DoClick = function()
									end
									pPanel.Name = vgui.Create("DLabel", pPanel)
									pPanel.Name:SetPos(55, 3)
									pPanel.Name:SetText(item.Name)
									pPanel.Name:SetColor(Color( 0, 255, 0, 255 ))
									pPanel.Name:SizeToContents() 
									pPanel.Name:SetContentAlignment( 5 )
									pPanel.remWep = vgui.Create("DImageButton", pPanel )
									pPanel.remWep:SetPos(150, 20)
									pPanel.remWep:SetSize(16,16)
									pPanel.remWep:SetImage( "gui/icons/delete.png" )
									pPanel.remWep:SetToolTip("Remove")
									pPanel.remWep.DoClick = function()
										net.Start("SND_AdmEditPlayer")
											net.WriteString("rem_weapon")
											net.WriteString(playerTBL["pid"])
											net.WriteString(v)
										net.SendToServer()
										profileADM_frame:Remove()
									end
							end
						end
					end
				--Player Equipped Ammo
				local EqAmmoTxt = vgui.Create("DLabel", pInfoPanel)
					EqAmmoTxt:SetPos(210, 175)
					EqAmmoTxt:SetText("Equiped Ammo:")
					EqAmmoTxt:SetColor(Color( 0, 255, 0, 255 ))
					EqAmmoTxt:SetFont("HudHintTextLarge")
					EqAmmoTxt:SizeToContents()		
				local ammoList = vgui.Create("DPanelList", pInfoPanel)
					ammoList:SetPos(210, 190)
					ammoList:SetSize(200, 195)
					ammoList:EnableVerticalScrollbar(true) 
					ammoList:EnableHorizontal(false) 
					ammoList:SetSpacing(1)
					ammoList:SetPadding(10)
					ammoList.Paint = function() end
					
					local ammoTbl = string.Explode(" ", playerTBL["ammo"])
					for _, v in pairs(ammoTbl) do
						for itemname, item in pairs( PNRP.Items ) do
							local ammoTbl2 = string.Explode(",", v)
							local ammoname = "ammo_"..ammoTbl2[1]
							
							if ammoname == item.Ent then
								local pPanel = vgui.Create("DPanel")
									pPanel:SetTall(40)
									pPanel.Paint = function()
									--	draw.RoundedBox( 6, 0, 0, pPanel:GetWide(), pPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
										draw.RoundedBox( 1, 0, 0, pPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
										draw.RoundedBox( 1, 0, pPanel:GetTall()-1, pPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
									end
									ammoList:AddItem(pPanel)
									
									pPanel.Icon = vgui.Create("SpawnIcon", pPanel)
									pPanel.Icon:SetSize( 35, 35 )
									pPanel.Icon:SetModel(item.Model)
									pPanel.Icon:SetPos(10, 2)
									pPanel.Icon:SetToolTip( nil )
									pPanel.Icon.DoClick = function()
									end
									pPanel.Name = vgui.Create("DLabel", pPanel)
									pPanel.Name:SetPos(55, 3)
									pPanel.Name:SetText(item.Name)
									pPanel.Name:SetColor(Color( 0, 255, 0, 255 ))
									pPanel.Name:SizeToContents() 
									pPanel.Name:SetContentAlignment( 5 )
									
									pPanel.Count = vgui.Create("DLabel", pPanel)
									pPanel.Count:SetPos(55, 20)
									pPanel.Count:SetText("Count: "..ammoTbl2[2])
									pPanel.Count:SetColor(Color( 0, 255, 0, 255 ))
									pPanel.Count:SizeToContents() 
									pPanel.Count:SetContentAlignment( 5 )
									pPanel.remAmmo = vgui.Create("DImageButton", pPanel )
									pPanel.remAmmo:SetPos(150, 20)
									pPanel.remAmmo:SetSize(16,16)
									pPanel.remAmmo:SetImage( "gui/icons/delete.png" )
									pPanel.remAmmo:SetToolTip("Remove")
									pPanel.remAmmo.DoClick = function()
										net.Start("SND_AdmEditPlayer")
											net.WriteString("rem_ammo")
											net.WriteString(playerTBL["pid"])
											net.WriteString(ammoTbl2[1])
										net.SendToServer()
										profileADM_frame:Remove()
									end
							end
						end
					end
		profileAdm_TabSheet:AddSheet( "Player Info", pInfoPanel, "gui/icons/user.png", false, false, "Player Info" )
			
			Inventory_DPanel = vgui.Create( "DPanel", profileAdm_TabSheet )
				Inventory_DPanel:SetPos( 5, 5 )
				Inventory_DPanel:SetSize( profileAdm_TabSheet:GetWide(), profileAdm_TabSheet:GetTall() - 5 )
				Inventory_DPanel.Paint = function() -- Paint function
					surface.SetDrawColor( 50, 50, 50, 0 )
				end
			Inventory_TabSheet = vgui.Create( "DPropertySheet" )
				Inventory_TabSheet:SetParent( Inventory_DPanel )
				Inventory_TabSheet:SetPos( 0, 0 )
				Inventory_TabSheet:SetSize( Inventory_DPanel:GetWide() - 15, Inventory_DPanel:GetTall() - 25 )
				Inventory_TabSheet.Paint = function() -- Paint function
					surface.SetDrawColor( 50, 50, 50, 0 )
				end
				
				--Player Invnetory
				pnlUserInv_DPanel = vgui.Create( "DPanel", Inventory_TabSheet )
					pnlUserInv_DPanel:SetPos( 0, 0 )
					pnlUserInv_DPanel:SetSize( Inventory_TabSheet:GetWide(), Inventory_TabSheet:GetTall() - 5 )
					pnlUserInv_DPanel.Paint = function() end
					local AddItemBtn = vgui.Create("DButton", pnlUserInv_DPanel )
						AddItemBtn:SetPos(0, 0)
						AddItemBtn:SetSize(115,15)
						AddItemBtn:SetText( "Add Item" )
						AddItemBtn.DoClick = function()
							openAddItem(playerTBL["pid"])
						end
					local warningLabel = vgui.Create("DLabel", pnlUserInv_DPanel)
						warningLabel:SetPos(200, 0)
						warningLabel:SetColor( Color( 255, 255, 0, 255 ) )
						warningLabel:SetText( "Warning: Clicking Icon will delete item." )
						warningLabel:SizeToContents()
					
				pnlUserInvList = vgui.Create("DPanelList", pnlUserInv_DPanel)
					pnlUserInvList:SetPos(0, 15)
					pnlUserInvList:SetSize(pnlUserInv_DPanel:GetWide()-15, pnlUserInv_DPanel:GetTall() -45 )
					pnlUserInvList:EnableVerticalScrollbar(false) 
					pnlUserInvList:EnableHorizontal(true) 
					pnlUserInvList:SetSpacing(1)
					pnlUserInvList:SetPadding(0)
					
					--Generates the user's inventory
					if inventoryTBL != nil then
						for k, v in pairs( inventoryTBL ) do
							local item = PNRP.Items[v["itemid"]]
							if item then
								local pnlUserIPanel = vgui.Create("DPanel", pnlUserInvList)
									pnlUserIPanel:SetSize( 75, 100 )
									pnlUserIPanel.Paint = function()
										draw.RoundedBox( 6, 0, 0, pnlUserIPanel:GetWide(), pnlUserIPanel:GetTall(), Color( 180, 180, 180, 255 ) )		
									end
									
									pnlUserInvList:AddItem(pnlUserIPanel)
									
									local countTxt = "Count: "..tostring(v["count"])
									if v["status_table"] != "" then
										local FuelLevel = PNRP.GetFromStat(v["status_table"], "FuelLevel")
										if FuelLevel then countTxt = "Fuel: "..tostring(FuelLevel) end
										local HPText = ""
										local HPLevel = PNRP.GetFromStat(v["status_table"], "HP")
										local Charge = PNRP.GetFromStat(v["status_table"], "PowerLevel")
										if HPLevel then HPText = "HP: "..HPLevel
										elseif Charge then HPText = "Charge: "..tostring(math.Round(Charge/100)).."% " end
										pnlUserIPanel.HP = vgui.Create("DLabel", pnlUserIPanel)		
										pnlUserIPanel.HP:SetPos( 10, 75 )
										pnlUserIPanel.HP:SetText(HPText)
										pnlUserIPanel.HP:SetColor(Color( 0, 0, 0, 255 ))
										pnlUserIPanel.HP:SizeToContents() 
										pnlUserIPanel.HP:SetContentAlignment( 5 )
									else
										pnlUserIPanel.NumberWang = vgui.Create( "DNumberWang", pnlUserIPanel )
										pnlUserIPanel.NumberWang:SetPos(pnlUserIPanel:GetWide() / 2 - pnlUserIPanel.NumberWang:GetWide() / 2, 75 )
										pnlUserIPanel.NumberWang:SetMin( 1 )
										pnlUserIPanel.NumberWang:SetMax( v["count"] )
										pnlUserIPanel.NumberWang:SetDecimals( 0 )
										pnlUserIPanel.NumberWang:SetValue( 1 )
									end
															
									pnlUserIPanel.Icon = vgui.Create("SpawnIcon", pnlUserIPanel)
									pnlUserIPanel.Icon:SetModel(item.Model)
									pnlUserIPanel.Icon:SetPos(pnlUserIPanel:GetWide() / 2 - pnlUserIPanel.Icon:GetWide() / 2, 5 )
									
									pnlUserIPanel.Icon:SetToolTip( item.Name.."\n"..countTxt.."\n Press Icon to move item." )
									pnlUserIPanel.Icon.DoClick = function()
										local count = v["count"]
										local takeCount = 1
										if v["iid"] == "" then
											takeCount = math.Round(pnlUserIPanel.NumberWang:GetValue())
										end
										if tonumber(takeCount) > tonumber(count) then
											takeCount = count
										elseif tonumber(takeCount) < 1 then
											takeCount = 1
										end
										net.Start("admDelInvItem")
											net.WriteString("player")
											net.WriteString("")
											net.WriteString(item.ID)
											net.WriteDouble(takeCount)
											net.WriteString(v["iid"])
											net.WriteString(tostring(playerTBL["pid"]))
										net.SendToServer()
									end								
							end
						end
					end
				Inventory_TabSheet:AddSheet( "Player Inventory", pnlUserInv_DPanel, "gui/icons/box.png", false, false, "Player Invnetory" )
					--End User Inv

				storageADM_frame = vgui.Create("DPanel", Inventory_TabSheet)
					storageADM_frame:SetPos( 0, 0 )
					storageADM_frame:SetSize(Inventory_TabSheet:GetWide(), Inventory_TabSheet:GetTall())
					storageADM_frame.Paint = function() end
					
						local pnlUserStorList = vgui.Create("DPanelList", storageADM_frame)
							pnlUserStorList:SetPos(5, 0)
							pnlUserStorList:SetSize(storageADM_frame:GetWide(), storageADM_frame:GetTall())
							pnlUserStorList:EnableVerticalScrollbar(true) 
							pnlUserStorList:EnableHorizontal(false) 
							pnlUserStorList:SetSpacing(1)
							pnlUserStorList:SetPadding(10)
							pnlUserStorList.Paint = function() end
							
							for k, v in pairs(storageTBL) do
								local pnlPanel = vgui.Create("DPanel")
									pnlPanel:SetTall(75)
									pnlPanel.Paint = function()
										draw.RoundedBox( 1, 0, 0, pnlPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
										draw.RoundedBox( 1, 0, pnlPanel:GetTall()-1, pnlPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
									end
									pnlUserStorList:AddItem(pnlPanel)
						
									pnlPanel.Icon = vgui.Create("SpawnIcon", pnlPanel)
									pnlPanel.Icon:SetModel("models/props_c17/Lockers001a.mdl")
									pnlPanel.Icon:SetPos(3, 5)
									pnlPanel.Icon:SetToolTip( "Click to select this storage" )
									pnlPanel.Icon.DoClick = function()
										net.Start("SND_AdmSVSelID")
											net.WriteString(storageTBL[k]["storageid"])
											net.WriteString("storage")
										net.SendToServer()
									end	
									pnlPanel.Title = vgui.Create("DLabel", pnlPanel)
									pnlPanel.Title:SetPos(90, 5)
									pnlPanel.Title:SetText(storageTBL[k]["name"])
									pnlPanel.Title:SetColor(Color( 0, 255, 0, 255 ))
									pnlPanel.Title:SizeToContents() 
									pnlPanel.Title:SetContentAlignment( 5 )
									
									local storageRes = storageTBL[k]["res"]
									local vendScrap = 0
									local vendSP = 0
									local vendChems = 0
									
									if string.len(tostring(storageRes)) > 3 then
										local resSplit = string.Explode( ",", storageRes )
										if table.Count( resSplit ) > 1 then
											vendScrap = resSplit[1]
											vendSP = resSplit[2]
											vendChems = resSplit[3]
										end
									end
										
									pnlPanel.Resources = vgui.Create("DLabel", pnlPanel)
									pnlPanel.Resources:SetPos(90, 20)
									pnlPanel.Resources:SetText("")
									pnlPanel.Resources:SetColor(Color( 0, 0, 0, 255 ))
									pnlPanel.Resources:SizeToContents() 
									pnlPanel.Resources:SetContentAlignment( 5 )
									local stoStatusTxt = ""
									if storageTBL[k]["inventory"] != NULL and string.len(tostring(storageTBL[k]["inventory"])) > 4 then
										stoStatusTxt = "Status: Has Inventory"
									else
										stoStatusTxt = "Status: Empty"
									end
									pnlPanel.Inventory = vgui.Create("DLabel", pnlPanel)
									pnlPanel.Inventory:SetPos(90, 35)
									pnlPanel.Inventory:SetText(stoStatusTxt)
									pnlPanel.Inventory:SetColor(Color( 0, 255, 0, 255 ))
									pnlPanel.Inventory:SizeToContents() 
									pnlPanel.Inventory:SetContentAlignment( 5 )
							end				
							
				Inventory_TabSheet:AddSheet( "Player Storage", storageADM_frame, "gui/icons/briefcase.png", false, false, "Player Storage" )
				
				vendorADM_frame = vgui.Create("DPanel", Inventory_TabSheet)
					vendorADM_frame:SetPos( 0, 0 )
					vendorADM_frame:SetSize(Inventory_TabSheet:GetWide(), Inventory_TabSheet:GetTall())
					vendorADM_frame.Paint = function() end
					
						local pnlUserVendList = vgui.Create("DPanelList", vendorADM_frame)
							pnlUserVendList:SetPos(5, 0)
							pnlUserVendList:SetSize(vendorADM_frame:GetWide(), vendorADM_frame:GetTall())
							pnlUserVendList:EnableVerticalScrollbar(true) 
							pnlUserVendList:EnableHorizontal(false) 
							pnlUserVendList:SetSpacing(1)
							pnlUserVendList:SetPadding(10)
							pnlUserVendList.Paint = function() end
							
							for k, v in pairs(vendorTBL) do
								local pnlPanel = vgui.Create("DPanel")
									pnlPanel:SetTall(75)
									pnlPanel.Paint = function()
										draw.RoundedBox( 1, 0, 0, pnlPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
										draw.RoundedBox( 1, 0, pnlPanel:GetTall()-1, pnlPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
									end
									pnlUserVendList:AddItem(pnlPanel)
									
									pnlPanel.Icon = vgui.Create("SpawnIcon", pnlPanel)
									pnlPanel.Icon:SetModel( "models/props/cs_office/vending_machine.mdl")
									pnlPanel.Icon:SetPos(3, 5)
									pnlPanel.Icon:SetToolTip( "Click to select this vendor" )
									pnlPanel.Icon.DoClick = function()
										net.Start("SND_AdmSVSelID")
											net.WriteString(vendorTBL[k]["vendorid"])
											net.WriteString("vendor")
										net.SendToServer()
									end	
									
									pnlPanel.Title = vgui.Create("DLabel", pnlPanel)
									pnlPanel.Title:SetPos(90, 5)
									pnlPanel.Title:SetText(vendorTBL[k]["name"])
									pnlPanel.Title:SetColor(Color( 0, 255, 0, 255 ))
									pnlPanel.Title:SizeToContents() 
									pnlPanel.Title:SetContentAlignment( 5 )
									
									local vendorRes = vendorTBL[k]["res"]
									local vendScrap = 0
									local vendSP = 0
									local vendChems = 0
									
									if string.len(tostring(vendorRes)) > 3 then
										local resSplit = string.Explode( ",", vendorRes )
										if table.Count( resSplit ) > 1 then
											vendScrap = resSplit[1]
											vendSP = resSplit[2]
											vendChems = resSplit[3]
										end
									end
										
									pnlPanel.Resources = vgui.Create("DLabel", pnlPanel)
									pnlPanel.Resources:SetPos(90, 20)
									pnlPanel.Resources:SetText("Resources- Scrap: "..vendScrap.." Small Parts: "..vendSP.." Chemicals: "..vendChems)
									pnlPanel.Resources:SetColor(Color( 0, 200, 0, 255 ))
									pnlPanel.Resources:SizeToContents() 
									pnlPanel.Resources:SetContentAlignment( 5 )

									local vendStatusTxt = ""
									if vendorTBL[k]["inventory"] != NULL and string.len(tostring(vendorTBL[k]["inventory"])) > 4 then
										vendStatusTxt = "Status: Has Invnetory"
									else
										vendStatusTxt = "Status: Empty"
									end
									pnlPanel.Inventory = vgui.Create("DLabel", pnlPanel)
									pnlPanel.Inventory:SetPos(90, 35)
									pnlPanel.Inventory:SetText(vendStatusTxt)
									pnlPanel.Inventory:SetColor(Color( 0, 255, 0, 255 ))
									pnlPanel.Inventory:SizeToContents() 
									pnlPanel.Inventory:SetContentAlignment( 5 )
							end
					
				Inventory_TabSheet:AddSheet( "Player Vendor", vendorADM_frame, "gui/icons/cart.png", false, false, "Player Vendor" )
			
			profileAdm_TabSheet:AddSheet( "Inventory", Inventory_DPanel, "gui/icons/box.png", false, false, "Inventory" )	
		
			local Skills_DPanel = vgui.Create( "DPanel", profileAdm_TabSheet )
				Skills_DPanel:SetPos( 5, 5 )
				Skills_DPanel:SetSize( profileAdm_TabSheet:GetWide(), profileAdm_TabSheet:GetTall() - 70 )
				Skills_DPanel.Paint = function() -- Paint function
					surface.SetDrawColor( 50, 50, 50, 0 )
				end
				
				Skills_DPanel.XP = vgui.Create("DLabel", Skills_DPanel)
				Skills_DPanel.XP:SetPos(5, 10)
				Skills_DPanel.XP:SetText("Current Experience: "..playerTBL["xp"])
				Skills_DPanel.XP:SetColor( Color( 255, 255, 255, 255 ) )
				Skills_DPanel.XP:SizeToContents() 
				Skills_DPanel.XP:SetContentAlignment( 5 )
											
				local maxWeight
				if playerTBL["class"] == TEAM_SCAVENGER then
					maxWeight = GetConVar("pnrp_packCapScav"):GetInt() + (GetSkill("Backpacking")*10)
				else
					maxWeight = GetConVar("pnrp_packCap"):GetInt() + (GetSkill("Backpacking")*10)
				end
				Skills_DPanel.BackPk = vgui.Create("DLabel", Skills_DPanel)
				Skills_DPanel.BackPk:SetPos(325, 20)
				Skills_DPanel.BackPk:SetText("Backpack Size: "..maxWeight)
				Skills_DPanel.BackPk:SetColor( Color( 255, 255, 255, 255 ) )
				Skills_DPanel.BackPk:SizeToContents() 
				Skills_DPanel.BackPk:SetContentAlignment( 5 )
				
				local SkillScrollPanel = vgui.Create( "DScrollPanel", Skills_DPanel)
					SkillScrollPanel:SetSize( Skills_DPanel:GetWide()-20, Skills_DPanel:GetTall()-15 )
					SkillScrollPanel:SetPos( 0, 50 )
					
				--Skills Section
				local SkillsTblEx = string.Explode(" ", playerTBL["skills"])
				local SkillsTbl = {}
				for k, v in pairs(SkillsTblEx) do
					local SkillsExp2 = string.Explode(",", v)
					SkillsTbl[SkillsExp2[1]] = SkillsExp2[2]
				end
				
				local skillYLoc = 5
				SkillScrollPanel.SKBLabel = vgui.Create("DLabel", SkillScrollPanel)
				SkillScrollPanel.SKBLabel:SetPos(10, skillYLoc)
				SkillScrollPanel.SKBLabel:SetText("Base Skills:")
				SkillScrollPanel.SKBLabel:SetColor( Color( 255, 255, 255, 255 ) )
				SkillScrollPanel.SKBLabel:SizeToContents() 
				SkillScrollPanel.SKBLabel:SetContentAlignment( 5 )
				
				skillYLoc = skillYLoc + 20
				local btnXLoc = SkillScrollPanel:GetWide() - 118
				
				for skillname, skill in pairs( PNRP.Skills ) do
					if skill.class == nil then
						local skillLevel = SkillsTbl[skill.name]
						if not skillLevel then skillLevel = 0 end
						SkillScrollPanel.Skill = vgui.Create("DLabel", SkillScrollPanel)
						SkillScrollPanel.Skill:SetPos(10, skillYLoc+2)
						SkillScrollPanel.Skill:SetText(skill.name.." (Max Level "..skill.maxlvl..")")
						SkillScrollPanel.Skill:SetColor( Color( 255, 255, 255, 255 ) )
						SkillScrollPanel.Skill:SizeToContents() 
						SkillScrollPanel.Skill:SetContentAlignment( 5 )
					--	ProfileUpSkillBtn(skill.name, btnXLoc, skillYLoc, SkillScrollPanel, profile_frame)
						SKlevel_Bar(skill.name, skillLevel, 10, skillYLoc+20, SkillScrollPanel)
					
						skillYLoc = skillYLoc + 40
					end
				end
				
				skillYLoc = skillYLoc + 10
				SkillScrollPanel.ClsSKLabel = vgui.Create("DLabel", SkillScrollPanel)
				SkillScrollPanel.ClsSKLabel:SetPos(10, skillYLoc)
				SkillScrollPanel.ClsSKLabel:SetText("Class Skill:")
				SkillScrollPanel.ClsSKLabel:SetColor( Color( 255, 255, 255, 255 ) )
				SkillScrollPanel.ClsSKLabel:SizeToContents() 
				SkillScrollPanel.ClsSKLabel:SetContentAlignment( 5 )
				
				skillYLoc = skillYLoc + 20 --Adjusts for the for loop
				for skillname, skill in pairs( PNRP.Skills ) do
					if skill.class != nil then
						for classname, class in pairs( PNRP.Skills[skill.name].class ) do
							if tostring(ply:Team()) == tostring(class) then
								local skillLevel = SkillsTbl[skill.name]
								if not skillLevel then skillLevel = 0 end
								SkillScrollPanel.ClsSkill = vgui.Create("DLabel", SkillScrollPanel, profile_frame)
								SkillScrollPanel.ClsSkill:SetPos(10, skillYLoc+2)
								SkillScrollPanel.ClsSkill:SetText(skill.name.." (Max Level "..skill.maxlvl..")")
								SkillScrollPanel.ClsSkill:SetColor( Color( 255, 255, 255, 255 ) )
								SkillScrollPanel.ClsSkill:SizeToContents() 
								SkillScrollPanel.ClsSkill:SetContentAlignment( 5 )
							--	ProfileUpSkillBtn(skill.name, btnXLoc, skillYLoc, SkillScrollPanel)
								SKlevel_Bar(skill.name, skillLevel, 10, skillYLoc+20, SkillScrollPanel)
							
								skillYLoc = skillYLoc + 40
							end
						end
					else
					
						
					end
				end	

		profileAdm_TabSheet:AddSheet( "Skills", Skills_DPanel, "gui/icons/wrench.png", false, false, "Skills" )
--[[		
			local pModelPanel = vgui.Create( "DPanel", profileAdm_TabSheet )
				pModelPanel:SetPos( 5, 5 )
				pModelPanel:SetSize( profileAdm_TabSheet:GetWide(), profileAdm_TabSheet:GetTall() )
				pModelPanel.Paint = function() -- Paint function
					surface.SetDrawColor( 50, 50, 50, 0 )
				end
				
				local ModelChangeBtn = vgui.Create("DButton", pModelPanel )
					ModelChangeBtn:SetPos(10, 10)
					ModelChangeBtn:SetSize(150,25)
					ModelChangeBtn:SetText( "Update Player Model" )
					ModelChangeBtn.DoClick = function()
					--	updateModel()
					end
					
				local ModelScrollPanel = vgui.Create( "DScrollPanel", pModelPanel)
					ModelScrollPanel:SetSize( pModelPanel:GetWide()-20, pModelPanel:GetTall()-100 )
					ModelScrollPanel:SetPos( 0, 50 )
					
					local List	= vgui.Create( "DIconLayout", ModelScrollPanel )
						List:SetSize( ModelScrollPanel:GetWide(), ModelScrollPanel:GetTall() )
						List:SetPos( 0, 0 )
						List:SetSpaceY( 5 )
						List:SetSpaceX( 5 )
						
						local mdlList = player_manager.AllValidModels( )
						for name, model in pairs( mdlList ) do
							local ListItem = List:Add( "SpawnIcon" )
							ListItem:SetSize( 64, 64 ) 
							ListItem:SetModel( model )
							ListItem:SetTooltip( name )
							ListItem.DoClick = function()
								mdl:SetModel( model )
								newModel = model
								function mdl.Entity:GetPlayerColor() return Vector( GetConVarString( "cl_playercolor" ) ) end
								mdl.Entity:SetPos( Vector( -100, 0, -61 ) )
							--	RunConsoleCommand( "cl_playermodel", tostring( model ) )
							end 
						end
			
		profileAdm_TabSheet:AddSheet( "Player Model", pModelPanel, "gui/icons/user_edit.png", false, false, "Player Model" )
]]--		
			
end
net.Receive("C_SND_PlyAdminProfileView", PlyAdminProfileView)

function openAddItem( pid )
	local admAddItem_frame = vgui.Create( "DFrame" )
		admAddItem_frame:SetSize( 710, 510 ) --Set the size Extra 40 must be from the top bar
		--Set the window in the middle of the players screen/game window
		admAddItem_frame:SetPos(ScrW() / 2 - admAddItem_frame:GetWide() / 2, ScrH() / 2 - admAddItem_frame:GetTall() / 2) 
		admAddItem_frame:SetTitle( "Player Info" ) --Set title
		admAddItem_frame:SetVisible( true )
		admAddItem_frame:SetDraggable( true )
		admAddItem_frame:ShowCloseButton( true )
		admAddItem_frame:MakePopup()
		admAddItem_frame.Paint = function() 
			surface.SetDrawColor( 50, 50, 50, 0 )
		end
		local screenBG = vgui.Create("DImage", admAddItem_frame)
			screenBG:SetImage( "VGUI/gfx/pnrp_screen_2b.png" )
			screenBG:SetSize(admAddItem_frame:GetWide(), admAddItem_frame:GetTall())
			
		local admAddInv_DPanel = vgui.Create( "DPanel", admAddItem_frame )
			admAddInv_DPanel:SetPos( 40, 40 )
			admAddInv_DPanel:SetSize( admAddItem_frame:GetWide()-75, admAddItem_frame:GetTall() - 40 )
			admAddInv_DPanel.Paint = function() end
			
			admAddInvList = vgui.Create("DPanelList", admAddInv_DPanel)
				admAddInvList:SetPos(0, 0)
				admAddInvList:SetSize(admAddInv_DPanel:GetWide()-15, admAddInv_DPanel:GetTall() -45 )
				admAddInvList:EnableVerticalScrollbar(false) 
				admAddInvList:EnableHorizontal(true) 
				admAddInvList:SetSpacing(1)
				admAddInvList:SetPadding(0)
				
				for k, item in pairs( PNRP.Items ) do
					if item.Type ~= "junk" then
						local pnlUserIPanel = vgui.Create("DPanel", admAddInvList)
							pnlUserIPanel:SetSize( 75, 75 )
							pnlUserIPanel.Paint = function()
							--	draw.RoundedBox( 6, 0, 0, pnlUserIPanel:GetWide(), pnlUserIPanel:GetTall(), Color( 180, 180, 180, 255 ) )		
							end
							
							admAddInvList:AddItem(pnlUserIPanel)
							
							pnlUserIPanel.Icon = vgui.Create("SpawnIcon", pnlUserIPanel)
							pnlUserIPanel.Icon:SetModel(item.Model)
							pnlUserIPanel.Icon:SetSize(pnlUserIPanel:GetWide(), pnlUserIPanel:GetTall())
							pnlUserIPanel.Icon:SetPos(pnlUserIPanel:GetWide() / 2 - pnlUserIPanel.Icon:GetWide() / 2, 5 )
							pnlUserIPanel.Icon:SetToolTip( item.Name )
							pnlUserIPanel.Icon.DoClick = function()
								net.Start("admAddInvItem")
									net.WriteString(tostring(pid))
									net.WriteString(item.ID)
								net.SendToServer()
								admAddItem_frame:Remove()
							end
					end
				end
end

function AdmViewRefreshPlyInv()
	local ply = LocalPlayer()
	local pid = net.ReadString()
	local inventoryTBL = net.ReadTable()
	
	if !ply:IsAdmin() then
		ply:ChatPrint("You are not an admin on this server!")
		return
	end
	
	if pnlUserInvList then pnlUserInvList:Remove() end
	
	pnlUserInvList = vgui.Create("DPanelList", pnlUserInv_DPanel)
		pnlUserInvList:SetPos(0, 15)
		pnlUserInvList:SetSize(pnlUserInv_DPanel:GetWide()-15, pnlUserInv_DPanel:GetTall() -45 )
		pnlUserInvList:EnableVerticalScrollbar(false) 
		pnlUserInvList:EnableHorizontal(true) 
		pnlUserInvList:SetSpacing(1)
		pnlUserInvList:SetPadding(0)
		--Generates the user's inventory
		if inventoryTBL != nil then
			for k, v in pairs( inventoryTBL ) do
				local item = PNRP.Items[v["itemid"]]
				if item then
					local pnlUserIPanel = vgui.Create("DPanel", pnlUserInvList)
						pnlUserIPanel:SetSize( 75, 100 )
						pnlUserIPanel.Paint = function()
							draw.RoundedBox( 6, 0, 0, pnlUserIPanel:GetWide(), pnlUserIPanel:GetTall(), Color( 180, 180, 180, 255 ) )		
						end
						
						pnlUserInvList:AddItem(pnlUserIPanel)
						
						local countTxt = "Count: "..tostring(v["count"])
						if v["status_table"] != "" then
							local FuelLevel = PNRP.GetFromStat(v["status_table"], "FuelLevel")
							if FuelLevel then countTxt = "Fuel: "..tostring(FuelLevel) end
							local HPText = ""
							local HPLevel = PNRP.GetFromStat(v["status_table"], "HP")
							local Charge = PNRP.GetFromStat(v["status_table"], "PowerLevel")
							if HPLevel then HPText = "HP: "..HPLevel
							elseif Charge then HPText = "Charge: "..tostring(math.Round(Charge/100)).."% " end
							pnlUserIPanel.HP = vgui.Create("DLabel", pnlUserIPanel)		
							pnlUserIPanel.HP:SetPos( 10, 75 )
							pnlUserIPanel.HP:SetText(HPText)
							pnlUserIPanel.HP:SetColor(Color( 0, 0, 0, 255 ))
							pnlUserIPanel.HP:SizeToContents() 
							pnlUserIPanel.HP:SetContentAlignment( 5 )
						else
							pnlUserIPanel.NumberWang = vgui.Create( "DNumberWang", pnlUserIPanel )
							pnlUserIPanel.NumberWang:SetPos(pnlUserIPanel:GetWide() / 2 - pnlUserIPanel.NumberWang:GetWide() / 2, 75 )
							pnlUserIPanel.NumberWang:SetMin( 1 )
							pnlUserIPanel.NumberWang:SetMax( v["count"] )
							pnlUserIPanel.NumberWang:SetDecimals( 0 )
							pnlUserIPanel.NumberWang:SetValue( 1 )
						end
												
						pnlUserIPanel.Icon = vgui.Create("SpawnIcon", pnlUserIPanel)
						pnlUserIPanel.Icon:SetModel(item.Model)
						pnlUserIPanel.Icon:SetPos(pnlUserIPanel:GetWide() / 2 - pnlUserIPanel.Icon:GetWide() / 2, 5 )
						
						pnlUserIPanel.Icon:SetToolTip( item.Name.."\n"..countTxt.."\n Press Icon to move item." )
						pnlUserIPanel.Icon.DoClick = function()
							local count = v["count"]
							local takeCount = 1
							if v["iid"] == "" then
								takeCount = math.Round(pnlUserIPanel.NumberWang:GetValue())
							end
							if tonumber(takeCount) > tonumber(count) then
								takeCount = count
							elseif tonumber(takeCount) < 1 then
								takeCount = 1
							end
							net.Start("admDelInvItem")
								net.WriteString("player")
								net.WriteString("")
								net.WriteString(item.ID)
								net.WriteDouble(takeCount)
								net.WriteString(v["iid"])
								net.WriteString(tostring(pid))
							net.SendToServer()
						end								
				end
			end
		end
end
net.Receive("C_SND_AdmViewRefreshPlyInv", AdmViewRefreshPlyInv)

function AdmVewSV()
	local id = net.ReadString()
	local Tbl = net.ReadTable()
	local option = net.ReadString()
	local ply = LocalPlayer()
	
	if !ply:IsAdmin() then
		ply:ChatPrint("You are not an admin on this server!")
		return
	end
	
	if not Inventory_DPanel then return end
	if Inventory_TabSheet then Inventory_TabSheet:Hide() end
	
	local invTbl = {}
	if option == "vendor" then
		invTbl = Tbl["inv"]
	else
		invTbl = Tbl
	end
	
	local resStr = ""
	if string.len(tostring(Tbl["res"])) > 4 then
		local resTbl = string.Explode(",", tostring(Tbl["res"]))
		resStr = "Scrap: "..tostring(resTbl[1]).." | SP: "..tostring(resTbl[2]).." | Chems: "..tostring(resTbl[3])
	end
	
	local showInv_DPanel = vgui.Create( "DPanel", Inventory_DPanel )
		showInv_DPanel:SetPos( 0, 0 )
		showInv_DPanel:SetSize( Inventory_DPanel:GetWide(), Inventory_DPanel:GetTall() - 5 )
		showInv_DPanel.Paint = function() end
		
	local warningLabel = vgui.Create("DLabel", showInv_DPanel)
		warningLabel:SetPos(200, 0)
		warningLabel:SetColor( Color( 255, 255, 0, 255 ) )
		warningLabel:SetText( "Warning: Clicking Icon will delete item." )
		warningLabel:SizeToContents()
		
	local resLabel = vgui.Create("DLabel", showInv_DPanel)
		resLabel:SetPos(0, 15)
		resLabel:SetColor( Color( 0, 255, 0, 255 ) )
		resLabel:SetText( resStr )
		resLabel:SizeToContents()
	
	local BackBtn = vgui.Create("DButton", showInv_DPanel )
		BackBtn:SetPos(0, 0)
		BackBtn:SetSize(75,15)
		BackBtn:SetText( "Back" )
		BackBtn.DoClick = function()
			Inventory_TabSheet:Show()
			showInv_DPanel:Remove()
		end
	
	local pnlLIList = vgui.Create("DPanelList", showInv_DPanel)
		pnlLIList:SetPos(0, 25)
		pnlLIList:SetSize( showInv_DPanel:GetWide() - 15, showInv_DPanel:GetTall() - 25 )
		pnlLIList:EnableVerticalScrollbar(false) 
		pnlLIList:EnableHorizontal(true) 
		pnlLIList:SetSpacing(1)
		pnlLIList:SetPadding(5)
		
		if invTbl == nil then
			local EmptyLabel = vgui.Create( "DLabel", showInv_DPanel )
				EmptyLabel:SetText("Storage Inventory is Empty")
				EmptyLabel:SetPos(10, 10)
				EmptyLabel:SetColor( Color( 0, 255, 0, 255 ) )
				EmptyLabel:SizeToContents()
		else
		
			for k, v in pairs( invTbl ) do
				local item = PNRP.Items[v["itemid"]]
				if item then
					local count = v["count"]
					local toolTip = item.Name.."\n".."Count: "..count
					local pnlLIPanel = vgui.Create("DPanel", pnlLIList)
						pnlLIPanel:SetSize( 75, 100 )
						pnlLIPanel.Paint = function()
							draw.RoundedBox( 6, 0, 0, pnlLIPanel:GetWide(), pnlLIPanel:GetTall(), Color( 180, 180, 180, 255 ) )		
						end
						
						pnlLIList:AddItem(pnlLIPanel)
						
						local countTxt = "Count: "..tostring(v["count"])
						if v["status_table"] != "" then
							local FuelLevel = PNRP.GetFromStat(v["status_table"], "FuelLevel")
							if FuelLevel then toolTip = toolTip.."\nFuel: "..tostring(FuelLevel) end
							local HPText = ""
							local HPLevel = PNRP.GetFromStat(v["status_table"], "HP")
							local Charge = PNRP.GetFromStat(v["status_table"], "PowerLevel")
							if HPLevel then HPText = "HP: "..HPLevel
							elseif Charge then HPText = "Charge: "..tostring(math.Round(Charge/100)).."% " end
							pnlLIPanel.HP = vgui.Create("DLabel", pnlLIPanel)		
							pnlLIPanel.HP:SetPos( 10, 75 )
							pnlLIPanel.HP:SetText(HPText)
							pnlLIPanel.HP:SetColor(Color( 0, 0, 0, 255 ))
							pnlLIPanel.HP:SizeToContents() 
							pnlLIPanel.HP:SetContentAlignment( 5 )
						else
							pnlLIPanel.NumberWang = vgui.Create( "DNumberWang", pnlLIPanel )
							pnlLIPanel.NumberWang:SetPos(pnlLIPanel:GetWide() / 2 - pnlLIPanel.NumberWang:GetWide() / 2, 75 )
							pnlLIPanel.NumberWang:SetMin( 1 )
							pnlLIPanel.NumberWang:SetMax( count )
							pnlLIPanel.NumberWang:SetDecimals( 0 )
							pnlLIPanel.NumberWang:SetValue( 1 )
						end
						
						pnlLIPanel.Icon = vgui.Create("SpawnIcon", pnlLIPanel)
						pnlLIPanel.Icon:SetModel(item.Model)
						pnlLIPanel.Icon:SetPos(pnlLIPanel:GetWide() / 2 - pnlLIPanel.Icon:GetWide() / 2, 5 )
						pnlLIPanel.Icon:SetToolTip( toolTip )
						pnlLIPanel.Icon.DoClick = function()
							local takeCount = 1
							if v["iid"] == "" then
								takeCount = math.Round(pnlLIPanel.NumberWang:GetValue())
							end
							if tonumber(takeCount) > tonumber(count) then
								takeCount = count
							elseif tonumber(takeCount) < 1 then
								takeCount = 1
							end
							net.Start("admDelInvItem")
								net.WriteString(option)
								net.WriteString(id)
								net.WriteString(item.ID)
								net.WriteDouble(takeCount)
								net.WriteString(v["iid"])
							net.SendToServer()
							Inventory_TabSheet:Show()
							showInv_DPanel:Remove()
						end	
				end
			end
		end		
end
net.Receive("C_SND_AdmVewSV", AdmVewSV)

local communityAdmin_frame
function GM.communityAdminMenu()
	local communityTable = net.ReadTable()
	communityAdmin_frame = vgui.Create( "DFrame" )
		communityAdmin_frame:SetSize( 710, 520 ) 
		communityAdmin_frame:SetPos(ScrW() / 2 - communityAdmin_frame:GetWide() / 2, ScrH() / 2 - communityAdmin_frame:GetTall() / 2)
		communityAdmin_frame:SetTitle( " " )
		communityAdmin_frame:SetVisible( true )
		communityAdmin_frame:SetDraggable( false )
		communityAdmin_frame:ShowCloseButton( true )
		communityAdmin_frame:MakePopup()
		communityAdmin_frame.Paint = function() 
			surface.SetDrawColor( 50, 50, 50, 0 )
		end
		
		local screenBG = vgui.Create("DImage", communityAdmin_frame)
			screenBG:SetImage( "VGUI/gfx/pnrp_screen_3b.png" )
			screenBG:SetSize(communityAdmin_frame:GetWide(), communityAdmin_frame:GetTall())
		
		local PaneLabel = vgui.Create("DLabel", communityAdmin_frame)
			PaneLabel:SetPos(50,40)
			PaneLabel:SetColor( Color( 255, 255, 255, 255 ) )
			PaneLabel:SetText( "Communities on the Server" )
			PaneLabel:SizeToContents()
					
		local comList = vgui.Create("DPanelList", communityAdmin_frame)
			comList:SetPos(40, 70)
			comList:SetSize(communityAdmin_frame:GetWide() - 225, communityAdmin_frame:GetTall() - 120)
			comList:EnableVerticalScrollbar(true) 
			comList:EnableHorizontal(false) 
			comList:SetSpacing(1)
			comList:SetPadding(10)
			
			for k, v in pairs( communityTable ) do
				local comPanel = vgui.Create("DPanel")
					comPanel:SetTall(75)
					comPanel.Paint = function()			
						draw.RoundedBox( 6, 0, 0, comPanel:GetWide(), comPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
					end
					comList:AddItem(comPanel)
					
					comPanel.Title = vgui.Create("DLabel", comPanel)
					comPanel.Title:SetPos(5, 5)
					comPanel.Title:SetText(v["cname"])
					comPanel.Title:SetColor(Color( 255, 255, 255, 255 ))
					comPanel.Title:SizeToContents() 
					comPanel.Title:SetContentAlignment( 5 )
					
					comPanel.Founded = vgui.Create("DLabel", comPanel)
					comPanel.Founded:SetPos(5, 25)
					comPanel.Founded:SetText("Founded: "..v["founded"])
					comPanel.Founded:SetColor(Color( 255, 255, 255, 255 ))
					comPanel.Founded:SizeToContents() 
					comPanel.Founded:SetContentAlignment( 5 )
					
					comPanel.EditBtn = vgui.Create("DButton", comPanel )
					comPanel.EditBtn:SetPos(345, 5)
					comPanel.EditBtn:SetSize(100,17)
					comPanel.EditBtn:SetText( "Edit Community" )
					comPanel.EditBtn.DoClick = function() 
						RunConsoleCommand( "pnrp_AdmEditCom", v["cid"] )
						communityAdmin_frame:Close() 
					end
					
					comPanel.DelteBtn = vgui.Create("DButton", comPanel )
					comPanel.DelteBtn:SetPos(345, 25)
					comPanel.DelteBtn:SetSize(100,17)
					comPanel.DelteBtn:SetText( "Delete Community" )
					comPanel.DelteBtn.DoClick = function() 
						PNRP.OptionVerify( "pnrp_AdminDelCom", v["cid"], "pnrp_communityAdmin", communityAdmin_frame ) 
					end
			end
end
net.Receive( "pnrp_OpenCommAdminWindow", GM.communityAdminMenu )

local communityEdit_frame
local comEditFrame = false
--Main Community Menu
function GM.communityEdit_window( )
	if comEditFrame then return end 
	local communityTable = net.ReadTable()
	local communityPending = net.ReadTable()
	local cid = net.ReadString()
	local wars = net.ReadTable()
	local allies = net.ReadTable()
	
	local communityName = communityTable["name"]

	local communityUsers = communityTable["users"]
	local communityCount
	local CommuntityError = false
	comEditFrame = true
	communityCount = "none"

	if communityName then
		communityCount = 0
		communityName = " Editing Community: "..communityName
	else
		communityName = "Error Pulling Community Data"
		CommuntityError = true
	end
	
	communityEdit_frame = vgui.Create( "DFrame" )
		communityEdit_frame:SetSize( 710, 520 ) 
		communityEdit_frame:SetPos(ScrW() / 2 - communityEdit_frame:GetWide() / 2, ScrH() / 2 - communityEdit_frame:GetTall() / 2)
		communityEdit_frame:SetTitle( " " )
		communityEdit_frame:SetVisible( true )
		communityEdit_frame:SetDraggable( false )
		communityEdit_frame:ShowCloseButton( true )
		communityEdit_frame:MakePopup()
		communityEdit_frame.Paint = function() 
			surface.SetDrawColor( 50, 50, 50, 0 )
		end
		
		local screenBG = vgui.Create("DImage", communityEdit_frame)
			screenBG:SetImage( "VGUI/gfx/pnrp_screen_4b.png" )
			screenBG:SetSize(communityEdit_frame:GetWide(), communityEdit_frame:GetTall())	
		
			
			local UCommunityNameLabel = vgui.Create("DLabel", communityEdit_frame)
					UCommunityNameLabel:SetPos(50,40)
					UCommunityNameLabel:SetColor( Color( 255, 255, 255, 255 ) )
					UCommunityNameLabel:SetText( communityName )
					UCommunityNameLabel:SizeToContents()
			
			local UCommunityIDLabel = vgui.Create("DLabel", communityEdit_frame)
					UCommunityIDLabel:SetPos(54,54)
					UCommunityIDLabel:SetColor( Color( 255, 255, 255, 255 ) )
					UCommunityIDLabel:SetText( "Community ID [CID]: "..tostring(cid) )
					UCommunityIDLabel:SizeToContents()
			
			if CommuntityError then
			
			
			else
				local communityEdit_TabSheet = vgui.Create( "DPropertySheet" )
					communityEdit_TabSheet:SetParent( communityEdit_frame )
					communityEdit_TabSheet:SetPos( 40, 70 )
					communityEdit_TabSheet:SetSize( communityEdit_frame:GetWide() - 340, communityEdit_frame:GetTall() - 120 )
					communityEdit_TabSheet.Paint = function() -- Paint function
						surface.SetDrawColor( 50, 50, 50, 0 )
					end
					
				--//List of Current Members	
				local cMemberPanel = vgui.Create( "DPanel", communityEdit_TabSheet )
					cMemberPanel:SetPos( 5, 5 )
					cMemberPanel:SetSize( communityEdit_TabSheet:GetWide(), communityEdit_TabSheet:GetTall() )
					cMemberPanel.Paint = function() -- Paint function
						surface.SetDrawColor( 50, 50, 50, 0 )
					end
				local cMemberList = vgui.Create("DPanelList", cMemberPanel)
					cMemberList:SetPos(0, 0)
					cMemberList:SetSize(cMemberPanel:GetWide() - 15, cMemberPanel:GetTall() - 40)
					cMemberList:EnableVerticalScrollbar(true) 
					cMemberList:EnableHorizontal(false) 
					cMemberList:SetSpacing(1)
					cMemberList:SetPadding(10)

					if communityName != "none" then
						for k, v in pairs( communityUsers ) do		
								
							local MemberPanel = vgui.Create("DPanel")
							MemberPanel:SetTall(75)
							MemberPanel.Paint = function()
								draw.RoundedBox( 6, 0, 0, MemberPanel:GetWide(), MemberPanel:GetTall(), Color( 180, 180, 180, 80 ) )
							end
							cMemberList:AddItem(MemberPanel)
							
							MemberPanel.Icon = vgui.Create("SpawnIcon", MemberPanel)
							MemberPanel.Icon:SetModel(v["model"])
							MemberPanel.Icon:SetPos(3, 3)
							MemberPanel.Icon:SetToolTip( nil )
							
							MemberPanel.Title = vgui.Create("DLabel", MemberPanel)
							MemberPanel.Title:SetPos(90, 5)
							MemberPanel.Title:SetText(v["name"])
							MemberPanel.Title:SetColor(Color( 0, 0, 0, 255 ))
							MemberPanel.Title:SizeToContents() 
							MemberPanel.Title:SetContentAlignment( 5 )
							
							MemberPanel.Rank = vgui.Create("DLabel", MemberPanel)
							MemberPanel.Rank:SetPos(90, 25)
							MemberPanel.Rank:SetText("Rank: Level "..v["rank"])
							MemberPanel.Rank:SetColor(Color( 0, 0, 0, 255 ))
							MemberPanel.Rank:SizeToContents() 
							MemberPanel.Rank:SetContentAlignment( 5 )
							
							MemberPanel.LastOn = vgui.Create("DLabel", MemberPanel)
							MemberPanel.LastOn:SetPos(90, 55)
							MemberPanel.LastOn:SetText("Last On: "..v["lastlog"])
							MemberPanel.LastOn:SetColor(Color( 0, 0, 0, 255 ))
							MemberPanel.LastOn:SizeToContents() 
							MemberPanel.LastOn:SetContentAlignment( 5 )
														
							MemberPanel.PromoteBtn = vgui.Create("DButton", MemberPanel )
							MemberPanel.PromoteBtn:SetPos(245, 5)
							MemberPanel.PromoteBtn:SetSize(75,17)
							MemberPanel.PromoteBtn:SetText( "Promote" )
							MemberPanel.PromoteBtn.DoClick = function() 
								RunConsoleCommand( "pnrp_rankcomm", v["name"], v["rank"] + 1 )
								communityEdit_frame:Close() 
								RunConsoleCommand( "pnrp_AdmEditCom", cid )
							end
							if tonumber(v["rank"]) == 3 then 
								MemberPanel.PromoteBtn:SetDisabled( true )
							else
								MemberPanel.PromoteBtn:SetDisabled( false )
							end
							
							MemberPanel.DemoteBtn = vgui.Create("DButton", MemberPanel )
							MemberPanel.DemoteBtn:SetPos(245, 25)
							MemberPanel.DemoteBtn:SetSize(75,17)
							MemberPanel.DemoteBtn:SetText( "Demote" )
							MemberPanel.DemoteBtn.DoClick = function() 
								RunConsoleCommand( "pnrp_rankcomm", v["name"], v["rank"] - 1 )
								communityEdit_frame:Close() 
								RunConsoleCommand( "pnrp_AdmEditCom", cid )
							end
							if tonumber(v["rank"]) == 1 then 
								MemberPanel.DemoteBtn:SetDisabled( true )
							else
								MemberPanel.DemoteBtn:SetDisabled( false )
							end
							
							MemberPanel.BootBtn = vgui.Create("DButton", MemberPanel )
							MemberPanel.BootBtn:SetPos(245, 45)
							MemberPanel.BootBtn:SetSize(75,17)
							MemberPanel.BootBtn:SetText( "Remove" )
							MemberPanel.BootBtn.DoClick = function() 
								RunConsoleCommand( "pnrp_remcomm", v["name"] )
								communityEdit_frame:Close() 
								RunConsoleCommand( "pnrp_OpenCommunity" )
							end	
							
							communityCount = communityCount + 1
						end
					end
				
				local UCommunityCountLabel = vgui.Create("DLabel", communityEdit_frame)
					UCommunityCountLabel:SetPos(275,55)
					UCommunityCountLabel:SetColor( Color( 255, 255, 255, 255 ) )
					UCommunityCountLabel:SetText( "Member Count: "..communityCount )
					UCommunityCountLabel:SizeToContents()
				
				communityEdit_TabSheet:AddSheet( "Members", cMemberPanel, "gui/icons/group.png", false, false, "Community Member List" )
				-- Wars
				local cWarPanel = vgui.Create( "DPanel", communityEdit_TabSheet )
					cWarPanel:SetPos( 5, 5 )
					cWarPanel:SetSize( communityEdit_TabSheet:GetWide(), communityEdit_TabSheet:GetTall() )
					cWarPanel.Paint = function() 
						surface.SetDrawColor( 50, 50, 50, 0 )
					end
					
					local cWarsList = vgui.Create("DPanelList", cWarPanel)
					cWarsList:SetPos(-5, 5)
					cWarsList:SetSize(cWarPanel:GetWide() - 10, cWarPanel:GetTall() - 40)
					cWarsList:EnableVerticalScrollbar(true) 
					cWarsList:EnableHorizontal(false) 
					cWarsList:SetSpacing(1)
					cWarsList:SetPadding(10)
					
					for wOCID, wOName in pairs(wars) do
						local warsPanel = vgui.Create("DPanel")
							warsPanel:SetTall(25)
							warsPanel.Paint = function()
								draw.RoundedBox( 6, 0, 0, warsPanel:GetWide(), warsPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
							end
							cWarsList:AddItem(warsPanel)
							
							warsPanel.Name = vgui.Create("DLabel", warsPanel)
							warsPanel.Name:SetPos(10, 5)
							warsPanel.Name:SetText(tostring(wOName))
							warsPanel.Name:SetColor(Color( 0, 255, 0, 255 ))
							warsPanel.Name:SizeToContents() 
							warsPanel.Name:SetContentAlignment( 5 )
							
							local warCancelButton = vgui.Create( "DButton", warsPanel )
								warCancelButton:SetPos( 240 , 3 )
								warCancelButton:SetText( "Cancel War" )
								warCancelButton:SetSize( 75, 20 )
								warCancelButton.DoClick = function()
									net.Start("SND_AdmDelComDep")
										net.WriteString(tostring(cid))
										net.WriteString(tostring(wOCID))
									net.SendToServer()
									communityEdit_frame:Close()
									RunConsoleCommand( "pnrp_AdmEditCom", cid )
								end	
					end
				communityEdit_TabSheet:AddSheet( "Wars", cWarPanel, "gui/icons/flag_red.png", false, false, "Communities at war with" )	
				--Allys
				local cAllyPanel = vgui.Create( "DPanel", communityEdit_TabSheet )
					cAllyPanel:SetPos( 5, 5 )
					cAllyPanel:SetSize( communityEdit_TabSheet:GetWide(), communityEdit_TabSheet:GetTall() )
					cAllyPanel.Paint = function() 
						surface.SetDrawColor( 50, 50, 50, 0 )
					end
					
					local cAlliesList = vgui.Create("DPanelList", cAllyPanel)
					cAlliesList:SetPos(-5, 5)
					cAlliesList:SetSize(cAllyPanel:GetWide() - 10, cAllyPanel:GetTall() - 40)
					cAlliesList:EnableVerticalScrollbar(true) 
					cAlliesList:EnableHorizontal(false) 
					cAlliesList:SetSpacing(1)
					cAlliesList:SetPadding(10)
					
					for aOCID, aOName in pairs(allies) do
						local alliesPanel = vgui.Create("DPanel")
							alliesPanel:SetTall(25)
							alliesPanel.Paint = function()
								draw.RoundedBox( 6, 0, 0, alliesPanel:GetWide(), alliesPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
							end
							cAlliesList:AddItem(alliesPanel)
							
							alliesPanel.Name = vgui.Create("DLabel", alliesPanel)
							alliesPanel.Name:SetPos(10, 5)
							alliesPanel.Name:SetText(tostring(aOName))
							alliesPanel.Name:SetColor(Color( 0, 255, 0, 255 ))
							alliesPanel.Name:SizeToContents() 
							alliesPanel.Name:SetContentAlignment( 5 )
							
							local allyCancelButton = vgui.Create( "DButton", alliesPanel )
								allyCancelButton:SetPos( 240 , 3 )
								allyCancelButton:SetText( "Cancel Ally" )
								allyCancelButton:SetSize( 75, 20 )
								allyCancelButton.DoClick = function()
									net.Start("SND_AdmDelComDep")
										net.WriteString(tostring(cid))
										net.WriteString(tostring(aOCID))
									net.SendToServer()
									communityEdit_frame:Close()
									RunConsoleCommand( "pnrp_AdmEditCom", cid )
								end	
					end
					
				communityEdit_TabSheet:AddSheet( "Allies", cAllyPanel, "gui/icons/flag_blue.png", false, false, "Communities allied with" )	
				--Pending
				local cPendingPanel = vgui.Create( "DPanel", communityEdit_TabSheet )
					cPendingPanel:SetPos( 5, 5 )
					cPendingPanel:SetSize( communityEdit_TabSheet:GetWide(), communityEdit_TabSheet:GetTall() )
					cPendingPanel.Paint = function() 
						surface.SetDrawColor( 50, 50, 50, 0 )
					end
					
				local cPendingList = vgui.Create("DPanelList", cPendingPanel)
					cPendingList:SetPos(-5, 5)
					cPendingList:SetSize(cPendingPanel:GetWide() - 10, cPendingPanel:GetTall() - 40)
					cPendingList:EnableVerticalScrollbar(true) 
					cPendingList:EnableHorizontal(false) 
					cPendingList:SetSpacing(1)
					cPendingList:SetPadding(10)
					
					for _, pItem in pairs(communityPending) do
						local admPendingPanel = vgui.Create("DPanel")
							admPendingPanel:SetTall(75)
							admPendingPanel.Paint = function()
								draw.RoundedBox( 6, 0, 0, admPendingPanel:GetWide(), admPendingPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
							end
							cPendingList:AddItem(admPendingPanel)
							
							local dataTbl = {}
							local dataSplit = string.Explode(" ", pItem["data"])
							
							for _, item in pairs(dataSplit) do
								local splitData = string.Explode(",", item)
								dataTbl[splitData[1]] = splitData[2]
							end
							
							local msgTxt = tostring(dataTbl["info"])
							if msgTxt == "msg" then msgTxt = "Message" end
							
							local txtMStatus = tostring(dataTbl["status"])
							if txtMStatus == "nil" then
								txtMStatus = ""
							end
							
							admPendingPanel.Status = vgui.Create("DLabel", admPendingPanel)
							admPendingPanel.Status:SetPos(10, 5)
							admPendingPanel.Status:SetText("Pending Action: "..msgTxt.." "..txtMStatus)
							admPendingPanel.Status:SetColor(Color( 0, 255, 0, 255 ))
							admPendingPanel.Status:SizeToContents() 
							admPendingPanel.Status:SetContentAlignment( 5 )
							
							local timeBreak = string.Explode(" ", pItem["time"])
							local timeString = timeBreak[1].." "..timeBreak[2]
							
							admPendingPanel.Time = vgui.Create("DLabel", admPendingPanel)
							admPendingPanel.Time:SetPos(190, 5)
							admPendingPanel.Time:SetText("Time: "..timeString)
							admPendingPanel.Time:SetColor(Color( 0, 255, 0, 255 ))
							admPendingPanel.Time:SizeToContents()
							admPendingPanel.Time:SetContentAlignment( 5 )
							
							admPendingPanel.MSG = vgui.Create("DLabel", admPendingPanel)
							admPendingPanel.MSG:SetPos(10, 24)
							admPendingPanel.MSG:SetText(pItem["msg"])
							admPendingPanel.MSG:SetColor(Color( 0, 255, 0, 255 ))
							admPendingPanel.MSG:SizeToContents() 
							admPendingPanel.MSG:SetWrap(true)
							admPendingPanel.MSG:SetWide(cPendingList:GetWide()-40)
							admPendingPanel.MSG:SetAutoStretchVertical( true )
							admPendingPanel.MSG:SetContentAlignment( 5 )
							
							admPendingPanel.okButton = vgui.Create( "DButton", admPendingPanel )
								admPendingPanel.okButton:SetPos( 10 , 55 )
								admPendingPanel.okButton:SetText( "Delete" )
								admPendingPanel.okButton:SetSize( 100, 15 )
								admPendingPanel.okButton.DoClick = function()
									net.Start("SND_DelPending")
										net.WriteString(pItem["cid"])
										net.WriteString(tostring(pItem["time"]))
										net.WriteString(tostring(pItem["time"]))
									net.SendToServer()
									communityEdit_frame:Close()
									RunConsoleCommand( "pnrp_AdmEditCom", cid )
								end	
								
						if msgTxt ~= "Message" then
							admPendingPanel.fYesBtn = vgui.Create( "DButton", admPendingPanel )
								admPendingPanel.fYesBtn:SetPos( 110, 55 )
								admPendingPanel.fYesBtn:SetText( "Force Acept" )
								admPendingPanel.fYesBtn:SetSize( 75, 15 )
								admPendingPanel.fYesBtn.DoClick = function()
									RunConsoleCommand( "pnrp_acptpending", dataTbl["cid"], dataTbl["info"], "force", cid) 
									communityEdit_frame:Close()
									RunConsoleCommand( "pnrp_AdmEditCom", cid )
								end				
							admPendingPanel.fNoBtn = vgui.Create( "DButton", admPendingPanel )
								admPendingPanel.fNoBtn:SetPos( 185 , 55 )
								admPendingPanel.fNoBtn:SetText( "Force Cancel" )
								admPendingPanel.fNoBtn:SetSize( 75, 15 )
								admPendingPanel.fNoBtn.DoClick = function()
									RunConsoleCommand( "pnrp_dclnpending", dataTbl["cid"], dataTbl["info"], "force", cid ) 
									communityEdit_frame:Close()
									RunConsoleCommand( "pnrp_AdmEditCom", cid )
								end	
						end	
					end	
				communityEdit_TabSheet:AddSheet( "Pending", cPendingPanel, "gui/icons/information.png", false, false, "Pending Actions" )
			end
		--//Community Main Menu
								
					local btnHPos = 50
					local btnHeight = 40
					local lblColor = Color( 245, 218, 210, 180 )
							
										
					local disbandBtn = vgui.Create("DImageButton", communityEdit_frame)
						disbandBtn:SetPos( communityEdit_frame:GetWide()-260,btnHPos )
						disbandBtn:SetSize(30,30)
						disbandBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
						disbandBtn.DoClick = function() 
							PNRP.OptionVerify( "pnrp_AdminDelCom", cid, "pnrp_communitysearch", communityEdit_frame ) 
						end	
						disbandBtn.Paint = function()
							if disbandBtn:IsDown() then 
								disbandBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
							else
								disbandBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
							end
						end
						
					local disbandBtnLbl = vgui.Create("DLabel", communityEdit_frame)
						disbandBtnLbl:SetPos( communityEdit_frame:GetWide()-210,btnHPos+2 )
						disbandBtnLbl:SetColor( lblColor )
						disbandBtnLbl:SetText( "Disband Community" )
						disbandBtnLbl:SetFont("Trebuchet24")
						disbandBtnLbl:SizeToContents()	
						
					btnHPos = btnHPos + btnHeight --Blank Space
					
					btnHPos = btnHPos + btnHeight
					local editStockBtn = vgui.Create("DImageButton", communityEdit_frame)
						editStockBtn:SetPos( communityEdit_frame:GetWide()-260,btnHPos )
						editStockBtn:SetSize(30,30)
						if CommuntityError then
							editStockBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
						else
							editStockBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
							editStockBtn.DoClick = function() 
								communityEdit_frame:Close()
							end
							editStockBtn.Paint = function()
								if editStockBtn:IsDown() then 
									editStockBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
								else
									editStockBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
								end
							end
						end
					local editStockBtnLbl = vgui.Create("DLabel", communityEdit_frame)
						editStockBtnLbl:SetPos( communityEdit_frame:GetWide()-210,btnHPos+2 )
						editStockBtnLbl:SetColor( lblColor )
						editStockBtnLbl:SetText( "Edit Stockpile" )
						editStockBtnLbl:SetFont("Trebuchet24")
						editStockBtnLbl:SizeToContents()
						
					btnHPos = btnHPos + btnHeight
					local editLockerBtn = vgui.Create("DImageButton", communityEdit_frame)
						editLockerBtn:SetPos( communityEdit_frame:GetWide()-260,btnHPos )
						editLockerBtn:SetSize(30,30)
						if CommuntityError then
							editLockerBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
						else
							editLockerBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
							editLockerBtn.DoClick = function() 
									communityEdit_frame:Close()
							end
							editLockerBtn.Paint = function()
								if editLockerBtn:IsDown() then 
									editLockerBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
								else
									editLockerBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
								end
							end
						end
					local editLockerBtnLbl = vgui.Create("DLabel", communityEdit_frame)
						editLockerBtnLbl:SetPos( communityEdit_frame:GetWide()-210,btnHPos+2 )
						editLockerBtnLbl:SetColor( lblColor )
						editLockerBtnLbl:SetText( "Edit Locker" )
						editLockerBtnLbl:SetFont("Trebuchet24")
						editLockerBtnLbl:SizeToContents()
					
					btnHPos = btnHPos + btnHeight --Blank Space
					
					btnHPos = btnHPos + btnHeight
					local comAdminBtn = vgui.Create("DImageButton", communityEdit_frame)
						comAdminBtn:SetPos( communityEdit_frame:GetWide()-260,btnHPos )
						comAdminBtn:SetSize(30,30)
						comAdminBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
						comAdminBtn.DoClick = function() 
							RunConsoleCommand( "pnrp_communitysearch" ) 
							communityEdit_frame:Close()
						end	
						comAdminBtn.Paint = function()
							if comAdminBtn:IsDown() then 
								comAdminBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
							else
								comAdminBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
							end
						end
					local comAdminBtnLbl = vgui.Create("DLabel", communityEdit_frame)
						comAdminBtnLbl:SetPos( communityEdit_frame:GetWide()-210,btnHPos+2 )
						comAdminBtnLbl:SetColor( lblColor )
						comAdminBtnLbl:SetText( "Communities Search" )
						comAdminBtnLbl:SetFont("Trebuchet24")
						comAdminBtnLbl:SizeToContents()	
						
					
	function communityEdit_frame:Close()                  
		comEditFrame = false                  
		self:SetVisible( false )                  
		self:Remove()          
	end 
end
net.Receive( "pnrp_OpenEditCommunityWindow", GM.communityEdit_window )

function GM.initPlyAdminLst(ply)
	if ply:IsAdmin() then	
		RunConsoleCommand("pnrp_OpenPlyAdminLst")
	else
		ply:ChatPrint("You are not an admin on this server!")
	end

end
concommand.Add( "pnrp_playerAdminList",  GM.initPlyAdminLst )

local sqlADM_frame
local sqlADM_body
local sqlADM_return
local sqlReturnTxt
function GM.SQLAdminWindow()
	local ply = LocalPlayer()
	if not ply:IsAdmin() then	
		ply:ChatPrint("You are not an admin on this server!")
		return
	end
	 
	if sqlADM_frame then sqlADM_frame:Remove() end
	
	sqlADM_frame = vgui.Create( "DFrame" )
		sqlADM_frame:SetSize( 710, 510 ) 
		sqlADM_frame:SetPos(ScrW() / 2 - sqlADM_frame:GetWide() / 2, ScrH() / 2 - sqlADM_frame:GetTall() / 2) 
		sqlADM_frame:SetTitle( "" ) 
		sqlADM_frame:SetVisible( true )
		sqlADM_frame:SetDraggable( true )
		sqlADM_frame:ShowCloseButton( true )
		sqlADM_frame:MakePopup()
		sqlADM_frame.Paint = function() 
			surface.SetDrawColor( 50, 50, 50, 0 )
		end
		
		local screenBG = vgui.Create("DImage", sqlADM_frame)
			screenBG:SetImage( "VGUI/gfx/pnrp_screen_2b.png" )
			screenBG:SetSize(sqlADM_frame:GetWide(), sqlADM_frame:GetTall())
		
		local queryTxt = vgui.Create("DTextEntry", sqlADM_frame)
				queryTxt:SetPos(60,55)
				queryTxt:SetWide(sqlADM_frame:GetWide()-125)
				queryTxt.OnEnter = function()
					local queryStr = queryTxt:GetValue()
					if queryStr == "" then return end
					net.Start("pnrp_RecAdminSQL")
						net.WriteString(queryStr)
					net.SendToServer()
				end
		
		local queryBtn = vgui.Create( "DButton", sqlADM_frame )
			queryBtn:SetSize( 150, 15 )
			queryBtn:SetPos( sqlADM_frame:GetWide()-215, 76 )
			queryBtn:SetText( "Submit Query" )
			queryBtn.DoClick = function( )
				local queryStr = queryTxt:GetValue()
				if queryStr == "" then return end
				net.Start("pnrp_RecAdminSQL")
					net.WriteString(queryStr)
				net.SendToServer()
				
			end
			
		sqlADM_body = vgui.Create( "DPanel", sqlADM_frame )
			sqlADM_body:SetPos( 60, 100 ) -- Set the position of the panel
			sqlADM_body:SetSize( sqlADM_frame:GetWide() - 125, sqlADM_frame:GetTall() - 150)
			sqlADM_body.Paint = function() end
			
			sqlReturnTxt = vgui.Create("DTextEntry", sqlADM_body)
				sqlReturnTxt:SetMultiline(true)
				sqlReturnTxt:SetVerticalScrollbarEnabled(true)
				sqlReturnTxt:SetText("SQL Editor\nMake sure you know what you are doing before using this.")
				sqlReturnTxt:SetPos(0,0)
				sqlReturnTxt:SetSize(sqlADM_body:GetWide(),sqlADM_body:GetTall())	
end
concommand.Add( "pnrp_sqlWindow",  GM.SQLAdminWindow )

function sqlAdmnReturnTxt( )
	local ply = LocalPlayer()
	local result = net.ReadString()
	
	if !ply:IsAdmin() then
		ply:ChatPrint("You are not an admin on this server!")
		return
	end
	
	if not sqlADM_frame and sqlReturnTxt then return end
		
	sqlReturnTxt:SetText(tostring(result))
end
net.Receive("pnrp_sqlAdmnReturnTxt", sqlAdmnReturnTxt)
--EOF