--Build Inventory Window

--MyCarInventory = {}

local inventory_frame
-- local PropertySheet = vgui.Create( "DPropertySheet" )

--function GM.car_inventory_window(ply)
function GM.car_inventory_window( handler, id, encoded, decoded )
	local MyCarInventory = decoded[1]		
	local CurCarInvWeight = decoded[2]	
	local ply = LocalPlayer()			 		
	inventory_frame = vgui.Create( "DFrame" )
		inventory_frame:SetSize( 700, 700 ) --Set the size
		inventory_frame:SetPos(ScrW() / 2 - inventory_frame:GetWide() / 2, ScrH() / 2 - inventory_frame:GetTall() / 2) --Set the window in the middle of the players screen/game window
		inventory_frame:SetTitle( "Car Inventory Menu" ) --Set title
		inventory_frame:SetVisible( true )
		inventory_frame:SetDraggable( true )
		inventory_frame:ShowCloseButton( true )
		inventory_frame:MakePopup()
		
		PNRP.buildMenu(inventory_frame)
		
	local PropertySheet = vgui.Create( "DPropertySheet" )
			PropertySheet:SetParent( inventory_frame )
			PropertySheet:SetPos( 5, 50 )
			PropertySheet:SetSize( inventory_frame:GetWide() - 10 , inventory_frame:GetTall() - 60 )
			PropertySheet:SetFadeTime( 0.5 )
			
			local weaponPanel = PNRP.build_car_inv_List(ply, "weapon", inventory_frame, PropertySheet, MyCarInventory)
			local ammoPanel = PNRP.build_car_inv_List(ply, "ammo", inventory_frame, PropertySheet, MyCarInventory)
			local medicalPanel = PNRP.build_car_inv_List(ply, "medical", inventory_frame, PropertySheet, MyCarInventory)
			local foodPanel = PNRP.build_car_inv_List(ply, "food", inventory_frame, PropertySheet, MyCarInventory)
			local toolsPanel = PNRP.build_car_inv_List(ply, "tool", inventory_frame, PropertySheet, MyCarInventory)
						
			PropertySheet:AddSheet( "Weapons", weaponPanel, "gui/silkicons/bomb", false, false, "Build Weapons" )
			PropertySheet:AddSheet( "Ammo", ammoPanel, "gui/silkicons/box", false, false, "Create Ammo" )
			PropertySheet:AddSheet( "Medical", medicalPanel, "gui/silkicons/heart", false, false, "Medical Items" )
			PropertySheet:AddSheet( "Food and Drink", foodPanel, "gui/silkicons/brick_add", false, false, "Food and Drink Items" )
			PropertySheet:AddSheet( "Tools", toolsPanel, "gui/silkicons/wrench", false, false, "Make Tools - Still in Development" )
			
			
	local InvWeight = vgui.Create("DLabel", inventory_frame)		
			InvWeight:SetPos(570, 55 )
			local maxCarWeight	
			maxCarWeight = tostring(CurCarMaxWeight)
			
			InvWeight:SetText("Current Weight: "..tostring(CurCarInvWeight).."/"..tostring(maxCarWeight))
--			InvWeight:SetColor(Color( 0, 0, 0, 255 ))
			InvWeight:SizeToContents() 
end

function PNRP.build_car_inv_List(ply, itemtype, parent_frame, PropertySheet, MyCarInventory)

	local sc = 0
	local sp = 0
	local ch = 0

	local pnlList = vgui.Create("DPanelList", PropertySheet)
		pnlList:SetPos(20, 80)
		pnlList:SetSize(parent_frame:GetWide() - 40, parent_frame:GetTall() - 100)
		pnlList:EnableVerticalScrollbar(true) 
		pnlList:EnableHorizontal(false) 
		pnlList:SetSpacing(1)
		pnlList:SetPadding(10)
				
		
		for itemname, item in pairs(PNRP.Items) do
			if item.Type == tostring( itemtype ) then
				for k, v in pairs( MyCarInventory ) do
		
					if k == itemname then
						local pnlPanel = vgui.Create("DPanel")
						pnlPanel:SetTall(75)
						pnlPanel.Paint = function()
						
							draw.RoundedBox( 6, 0, 0, pnlPanel:GetWide(), pnlPanel:GetTall(), Color( 180, 180, 180, 255 ) )		
					
						end
						pnlList:AddItem(pnlPanel)
						
						pnlPanel.Icon = vgui.Create("SpawnIcon", pnlPanel)
						pnlPanel.Icon:SetModel(item.Model)
						pnlPanel.Icon:SetPos(3, 5)
						pnlPanel.Icon:SetToolTip( nil )
						pnlPanel.Icon.DoClick = function()
								RunConsoleCommand("carinventory_drop", itemname)
								parent_frame:Close()
						end	
						
						pnlPanel.Title = vgui.Create("DLabel", pnlPanel)
						pnlPanel.Title:SetPos(90, 5)
						pnlPanel.Title:SetText(item.Name)
						pnlPanel.Title:SetColor(Color( 0, 0, 0, 255 ))
						pnlPanel.Title:SizeToContents() 
				 		pnlPanel.Title:SetContentAlignment( 5 )
				 		
				 		if item.Scrap != nil then sc = item.Scrap else sc = 0 end
				 		if item.SmallParts != nil then sp = item.SmallParts else sp = 0 end
				 		if item.Chemicals != nil then ch = item.Chemicals else ch = 0 end
				 		
				 		pnlPanel.Count = vgui.Create("DLabel", pnlPanel)		
						pnlPanel.Count:SetPos(90, 55)
						pnlPanel.Count:SetText("Count: "..tostring(v))
						pnlPanel.Count:SetColor(Color( 0, 0, 0, 255 ))
						pnlPanel.Count:SizeToContents() 
				 		pnlPanel.Count:SetContentAlignment( 5 )	
				 		
				 		pnlPanel.ClassBuild = vgui.Create("DLabel", pnlPanel)		
						pnlPanel.ClassBuild:SetPos(250, 5)
						pnlPanel.ClassBuild:SetText("Required Class for Creation: "..item.ClassSpawn)
						pnlPanel.ClassBuild:SetColor(Color( 0, 0, 0, 255 ))
						pnlPanel.ClassBuild:SizeToContents() 
				 		pnlPanel.ClassBuild:SetContentAlignment( 5 )
				 		
				 		pnlPanel.ClassBuild = vgui.Create("DLabel", pnlPanel)		
						pnlPanel.ClassBuild:SetPos(90, 40)
						pnlPanel.ClassBuild:SetText(item.Info)
						pnlPanel.ClassBuild:SetColor(Color( 0, 0, 0, 255 ))
						pnlPanel.ClassBuild:SizeToContents() 
				 		pnlPanel.ClassBuild:SetContentAlignment( 5 )	
				 		
				 		pnlPanel.ItemWeight = vgui.Create("DLabel", pnlPanel)		
						pnlPanel.ItemWeight:SetPos(350, 55)
						pnlPanel.ItemWeight:SetText("Weight: "..item.Weight)
						pnlPanel.ItemWeight:SetColor(Color( 0, 0, 0, 255 ))
						pnlPanel.ItemWeight:SizeToContents() 
				 		pnlPanel.ItemWeight:SetContentAlignment( 5 )
				 		
				 		pnlPanel.sendToInv = vgui.Create("DButton", pnlPanel )
				 		pnlPanel.sendToInv:SetPos(420, 55)
				 		pnlPanel.sendToInv:SetSize(115,18)
				    	pnlPanel.sendToInv:SetText( "Send to To Inventory" )
--				    	pnlPanel.sendToInv:SizeToContents() 
				    	pnlPanel.sendToInv.DoClick = function()
				    	
							RunConsoleCommand("pnrp_addtoinvfromcar",item.ID)
							parent_frame:Close()
							
						end	
						
						if item.Type == "tool" or item.Type == "junk" then
							--Since GMod does not like Not or's
						else
							pnlPanel.bulkSlider = vgui.Create( "DNumSlider", pnlPanel )
							pnlPanel.bulkSlider:SetPos(435, 5)
							pnlPanel.bulkSlider:SetSize( 100, 50 ) 
							pnlPanel.bulkSlider:SetText( " " )
							pnlPanel.bulkSlider:SetMin( 1 )
							pnlPanel.bulkSlider:SetMax( v )
							pnlPanel.bulkSlider:SetDecimals( 0 )
							pnlPanel.bulkSlider:SetValue( 1 )
							
							pnlPanel.BulkBtn = vgui.Create("DButton", pnlPanel )
							pnlPanel.BulkBtn:SetPos(540, 5)
							pnlPanel.BulkBtn:SetSize(100,17)
							pnlPanel.BulkBtn:SetText( "Drop Bulk" )
							pnlPanel.BulkBtn.DoClick = function() 
								datastream.StreamToServer( "DropBulkCrateCar", {itemname, pnlPanel.bulkSlider:GetValue() } )
								parent_frame:Close()
							end
						end
						
						pnlPanel.salvageItem = vgui.Create("DButton", pnlPanel )
						pnlPanel.salvageItem:SetPos(540, 55)
				 		pnlPanel.salvageItem:SetSize(100,17)
				    	pnlPanel.salvageItem:SetText( "Salvage Item" )
				    	pnlPanel.salvageItem.DoClick = function() PNRP.OptionVerify( "pnrp_docarsalvage", item.ID, nil) parent_frame:Close() end
				 	end
				end
			end
		end	
	
	return pnlList

end

datastream.Hook( "pnrp_OpenCarInvWindow", GM.car_inventory_window )

function GM.initCarInventory(ply)

	RunConsoleCommand("pnrp_OpenCarInventory")

end
concommand.Add( "pnrp_carinv",  GM.initCarInventory )

--concommand.Add( "pnrp_carinv", GM.car_inventory_window )

--EOF