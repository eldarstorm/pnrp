include('shared.lua')

function ENT:Draw()
	self.Entity:DrawModel()
end

function VendorHUDLabel()
	local myPlayer = LocalPlayer()
	
	local tracedata = {}
	tracedata.start = myPlayer:GetShootPos()
	tracedata.endpos = tracedata.start + (myPlayer:GetAimVector() * 1000)
	tracedata.filter = myPlayer
	local trace = util.TraceLine(tracedata)
	
	if !trace.Entity:IsValid() then return end
	
	if trace.Entity:GetClass() == "tool_vendor" then
		local font = "CenterPrintText"
		local text = trace.Entity:GetNetVar("name", "")
		surface.SetFont(font)
		local tWidth, tHeight = surface.GetTextSize(text)
		
		draw.WordBox( 8, (ScrW() / 2) - (8 + (tWidth / 2)), (ScrH() / 2) - (16 + tHeight), text, font, Color(50,50,75,100), Color(255,255,255,255) )
	end
end
hook.Add( "HUDPaint", "VendorHUDLabel", VendorHUDLabel )
--710, 520
function VendorSelectMenu( len )
	local ply = LocalPlayer()
	
	local vendorENT = net.ReadEntity()
	local vendor_table = net.ReadTable()
	
	local w = 810
	local h = 520
	local title = "Vendor Selection Menu"
		
	local vendmenu_frame = vgui.Create( "DFrame" )
		vendmenu_frame:SetSize( w, h ) 
		vendmenu_frame:SetPos( ScrW() / 2 - vendmenu_frame:GetWide() / 2, ScrH() / 2 - vendmenu_frame:GetTall() / 2 )
		vendmenu_frame:SetTitle( "" )
		vendmenu_frame:SetVisible( true )
		vendmenu_frame:SetDraggable( false )
		vendmenu_frame:ShowCloseButton( true )
		vendmenu_frame:MakePopup()
		vendmenu_frame.Paint = function() 
			surface.SetDrawColor( 50, 50, 50, 0 )
		end
		
		local screenBG = vgui.Create("DImage", vendmenu_frame)
			screenBG:SetImage( "VGUI/gfx/pnrp_screen_4b.png" )
			screenBG:SetKeepAspect()
			screenBG:SizeToContents()
			screenBG:SetSize(vendmenu_frame:GetWide(), vendmenu_frame:GetTall())
			
		local ToolName = vgui.Create( "DLabel", vendmenu_frame )
			ToolName:SetPos(60,40)
			ToolName:SetColor(Color( 0, 255, 0, 255 ))
			ToolName:SetText( title )
			ToolName:SizeToContents()
		
		local pnlList = vgui.Create("DPanelList", vendmenu_frame)
			pnlList:SetPos(50, 60)
			pnlList:SetSize(vendmenu_frame:GetWide() - 400, vendmenu_frame:GetTall() - 120)
			pnlList:EnableVerticalScrollbar(true) 
			pnlList:EnableHorizontal(false) 
			pnlList:SetSpacing(1)
			pnlList:SetPadding(10)
			pnlList.Paint = function()
			
			end
			
			for k, v in pairs(vendor_table) do
				local pnlPanel = vgui.Create("DPanel")
					pnlPanel:SetTall(75)
					pnlPanel.Paint = function()
						draw.RoundedBox( 6, 0, 0, pnlPanel:GetWide(), pnlPanel:GetTall(), Color( 180, 180, 180, 80 ) )		
					end
					pnlList:AddItem(pnlPanel)
					
					pnlPanel.Icon = vgui.Create("SpawnIcon", pnlPanel)
					pnlPanel.Icon:SetModel(vendorENT:GetModel())
					pnlPanel.Icon:SetPos(3, 5)
					pnlPanel.Icon:SetToolTip( "Click to select this vendor" )
					pnlPanel.Icon.DoClick = function()
						net.Start("SetVendor")
							net.WriteEntity(vendorENT)
							net.WriteDouble(vendor_table[k]["vendorid"])
							net.WriteString(vendor_table[k]["name"])
						net.SendToServer()
						vendmenu_frame:Close()
					end	
					
					pnlPanel.Title = vgui.Create("DLabel", pnlPanel)
					pnlPanel.Title:SetPos(90, 5)
					pnlPanel.Title:SetText(vendor_table[k]["name"])
					pnlPanel.Title:SetColor(Color( 0, 0, 0, 255 ))
					pnlPanel.Title:SizeToContents() 
					pnlPanel.Title:SetContentAlignment( 5 )
					
					local vendorRes = vendor_table[k]["res"]
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
					pnlPanel.Resources:SetColor(Color( 0, 0, 0, 255 ))
					pnlPanel.Resources:SizeToContents() 
					pnlPanel.Resources:SetContentAlignment( 5 )

					
					if vendor_table[k]["inventory"] != NULL and string.len(tostring(vendor_table[k]["inventory"])) > 4 then
						pnlPanel.Inventory = vgui.Create("DLabel", pnlPanel)
						pnlPanel.Inventory:SetPos(90, 35)
						pnlPanel.Inventory:SetText("Inventory: Has Inventory")
						pnlPanel.Inventory:SetColor(Color( 0, 0, 0, 255 ))
						pnlPanel.Inventory:SizeToContents() 
						pnlPanel.Inventory:SetContentAlignment( 5 )
					else
						pnlPanel.Inventory = vgui.Create("DLabel", pnlPanel)
						pnlPanel.Inventory:SetPos(90, 35)
						pnlPanel.Inventory:SetText("Inventory: Empty")
						pnlPanel.Inventory:SetColor(Color( 0, 0, 0, 255 ))
						pnlPanel.Inventory:SizeToContents() 
						pnlPanel.Inventory:SetContentAlignment( 5 )
					end
					
					pnlPanel.DelVendorBtn = vgui.Create("DButton", pnlPanel )
					pnlPanel.DelVendorBtn:SetPos(90, 53)
					pnlPanel.DelVendorBtn:SetSize(100,18)
					pnlPanel.DelVendorBtn:SetText( "Rename Vendor" )
					pnlPanel.DelVendorBtn.DoClick = function()
						renameVendor( vendorENT, vendor_table[k]["vendorid"], vendor_table[k]["name"] )
						vendmenu_frame:Close()
					end
					
					pnlPanel.DelVendorBtn = vgui.Create("DButton", pnlPanel )
					pnlPanel.DelVendorBtn:SetPos(200, 53)
					pnlPanel.DelVendorBtn:SetSize(100,18)
					pnlPanel.DelVendorBtn:SetText( "Delete Vendor" )
					pnlPanel.DelVendorBtn.DoClick = function()
						PNRP.OptionVerify( "deleteVendor", vendor_table[k]["vendorid"], nil, vendmenu_frame )
					end
			end
			
			
		--//Menu	
		local btnHPos = 30
		local btnWPos = vendmenu_frame:GetWide()-300
		local btnHeight = 35
		local lblColor = Color( 245, 218, 210, 180 )
		
		local newVendorLbl = vgui.Create("DLabel", vendmenu_frame)
			newVendorLbl:SetPos( btnWPos,btnHPos )
			newVendorLbl:SetColor( lblColor )
			newVendorLbl:SetText( "Vendor Profile Menu" )
			newVendorLbl:SetFont("Trebuchet24")
			newVendorLbl:SizeToContents()	
			
		btnHPos = btnHPos + btnHeight + 10
		
		local newVendorBtn = vgui.Create("DImageButton", vendmenu_frame)
			newVendorBtn:SetPos( btnWPos,btnHPos )
			newVendorBtn:SetSize(30,30)
			newVendorBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
			newVendorBtn.DoClick = function() 
				vendmenu_frame:Close()
				VendorNewMenu( vendorENT )
			end
			newVendorBtn.Paint = function()
				if newVendorBtn:IsDown() then 
					newVendorBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
				else
					newVendorBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
				end
			end	
		local newVendorBtnLbl = vgui.Create("DLabel", vendmenu_frame)
			newVendorBtnLbl:SetPos( btnWPos+40,btnHPos+2 )
			newVendorBtnLbl:SetColor( lblColor )
			newVendorBtnLbl:SetText( "Create New Vendor" )
			newVendorBtnLbl:SetFont("Trebuchet24")
			newVendorBtnLbl:SizeToContents()
		
		btnHPos = btnHPos + btnHeight + 40
		
		local infoVendorLbl = vgui.Create("DLabel", vendmenu_frame)
			infoVendorLbl:SetPos( btnWPos,btnHPos )
			infoVendorLbl:SetColor( lblColor )
			infoVendorLbl:SetText( "Setup Info:" )
			infoVendorLbl:SetFont("Trebuchet24")
			infoVendorLbl:SetWide(250)
			infoVendorLbl:SetTall(30)
			infoVendorLbl:SetWrap(true)	
		btnHPos = btnHPos + btnHeight
		local infoVendorLbl = vgui.Create("DLabel", vendmenu_frame)
			infoVendorLbl:SetPos( btnWPos,btnHPos )
			infoVendorLbl:SetColor( lblColor )
			infoVendorLbl:SetText( "1. Create new Vendor Profile \n  (Press Create New Vendor)" )
			infoVendorLbl:SetFont("HudHintTextLarge")
			infoVendorLbl:SetWide(250)
			infoVendorLbl:SetTall(30)
			infoVendorLbl:SetWrap(true)	
		btnHPos = btnHPos + btnHeight
		local infoVendorLbl = vgui.Create("DLabel", vendmenu_frame)
			infoVendorLbl:SetPos( btnWPos,btnHPos )
			infoVendorLbl:SetColor( lblColor )
			infoVendorLbl:SetText( "2. Click the Vendor Icon to set the profile to the Vendor" )
			infoVendorLbl:SetFont("HudHintTextLarge")
			infoVendorLbl:SetWide(250)
			infoVendorLbl:SetTall(30)
			infoVendorLbl:SetWrap(true)	
		btnHPos = btnHPos + btnHeight + 10
		local infoVendorLbl = vgui.Create("DLabel", vendmenu_frame)
			infoVendorLbl:SetPos( btnWPos,btnHPos )
			infoVendorLbl:SetColor( lblColor )
			infoVendorLbl:SetText( "Profiles can only be set to one Vendor at a time" )
			infoVendorLbl:SetFont("HudHintTextLarge")
			infoVendorLbl:SetWide(250)
			infoVendorLbl:SetTall(30)
			infoVendorLbl:SetWrap(true)	
		btnHPos = btnHPos + btnHeight + 5
		local infoStorageLbl = vgui.Create("DLabel", vendmenu_frame)
			infoStorageLbl:SetPos( btnWPos,btnHPos )
			infoStorageLbl:SetColor( lblColor )
			infoStorageLbl:SetText( "First Profile is free" )
			infoStorageLbl:SetFont("HudHintTextLarge")
			infoStorageLbl:SetWide(250)
			infoStorageLbl:SetTall(30)
			infoStorageLbl:SetWrap(true)
		btnHPos = btnHPos + btnHeight - 5
		local costStr = string.Explode( " ", PNRP.Items[vendorENT:GetClass()].ProfileCost)
		local pScr = tostring(costStr[1])
		local pSP = tostring(costStr[2])
		local pChem = tostring(costStr[3])
		
		local infoStorageLbl = vgui.Create("DLabel", vendmenu_frame)
			infoStorageLbl:SetPos( btnWPos,btnHPos )
			infoStorageLbl:SetColor( lblColor )
			infoStorageLbl:SetText( "Cost per Profile: Scrap: "..pScr.." \n Small Parts: "..pSP.." Chemicals: "..pChem )
			infoStorageLbl:SetFont("HudHintTextLarge")
			infoStorageLbl:SetWide(250)
			infoStorageLbl:SetTall(30)
			infoStorageLbl:SetWrap(true)
		btnHPos = btnHPos + btnHeight + 10
		local infoVendorLbl = vgui.Create("DLabel", vendmenu_frame)
			infoVendorLbl:SetPos( btnWPos,btnHPos )
			infoVendorLbl:SetColor( lblColor )
			infoVendorLbl:SetText( "Warning:" )
			infoVendorLbl:SetFont("Trebuchet24")
			infoVendorLbl:SetWide(250)
			infoVendorLbl:SetTall(30)
			infoVendorLbl:SetWrap(true)	
		btnHPos = btnHPos + btnHeight
		local infoVendorLbl = vgui.Create("DLabel", vendmenu_frame)
			infoVendorLbl:SetPos( btnWPos,btnHPos )
			infoVendorLbl:SetColor( lblColor )
			infoVendorLbl:SetText( "All items in the vendor profile will be lost when the profile is deleted" )
			infoVendorLbl:SetFont("HudHintTextLarge")
			infoVendorLbl:SetWide(250)
			infoVendorLbl:SetTall(30)
			infoVendorLbl:SetWrap(true)	
		

end
net.Receive("vendor_select_menu", VendorSelectMenu)

function OpenVendorNewMenu( )
	local vendorENT = net:ReadEntity()
	VendorNewMenu( vendorENT )
end
function VendorNewMenu( vendorENT )
	local ply = LocalPlayer()
		
	local w = 500
	local h = 150
	local title = "New Vendor Menu"
		
	local vendmenu_frame = vgui.Create( "DFrame" )
		vendmenu_frame:SetSize( w, h ) 
		vendmenu_frame:SetPos( ScrW() / 2 - vendmenu_frame:GetWide() / 2, ScrH() / 2 - vendmenu_frame:GetTall() / 2 )
		vendmenu_frame:SetTitle( title )
		vendmenu_frame:SetVisible( true )
		vendmenu_frame:SetDraggable( false )
		vendmenu_frame:ShowCloseButton( true )
		vendmenu_frame:MakePopup()
					
		local SetNameLbl = vgui.Create( "DLabel", vendmenu_frame )
			SetNameLbl:SetPos(60,60)
			SetNameLbl:SetColor(Color( 0, 255, 0, 255 ))
			SetNameLbl:SetText( "Vendor Name" )
			SetNameLbl:SizeToContents()
		local setNameTxt = vgui.Create("DTextEntry", vendmenu_frame)
			setNameTxt:SetText(ply:Nick().."'s Vending Machine")
			setNameTxt:SetPos(150,62)
			setNameTxt:SetWide(300)
		local buttonNewVendor = vgui.Create( "DButton", vendmenu_frame )
			buttonNewVendor:SetSize( 150, 25 )
			buttonNewVendor:SetPos( 150, 90 )
			buttonNewVendor:SetText( "Create new Vendor" )
			buttonNewVendor.DoClick = function( )
				local name = setNameTxt:GetValue()
				net.Start("CreateNewVendor")
					net.WriteEntity(vendorENT)
					net.WriteString(name)
				net.SendToServer()
				vendmenu_frame:Close()
			end

end
net.Receive("vendor_new_menu", OpenVendorNewMenu)

function VendorMenu()
	local ply = LocalPlayer()
	
	local vendorENT = net:ReadEntity()
	local vendor_table = net.ReadTable()
	local inventoryTble = net.ReadTable()
	local avModels = net.ReadTable()	
	local Capacity = net.ReadString()
	
	local vendorInventory = vendor_table["inv"]
	local vendorRes = vendor_table["res"]
	local vendScrap = 0
	local vendSP = 0
	local vendChems = 0
	
	local invTbl = {}
	
	if string.len(tostring(vendorRes)) > 3 then
		local resSplit = string.Explode( ",", vendorRes )
		if table.Count( resSplit ) > 1 then
			vendScrap = resSplit[1]
			vendSP = resSplit[2]
			vendChems = resSplit[3]
		end
	end
	
	local w = 810
	local h = 520
	local title = "Vendor Menu"
		
	local vendmenu_frame = vgui.Create( "DFrame" )
		vendmenu_frame:SetSize( w, h ) 
		vendmenu_frame:SetPos( ScrW() / 2 - vendmenu_frame:GetWide() / 2, ScrH() / 2 - vendmenu_frame:GetTall() / 2 )
		vendmenu_frame:SetTitle( "" )
		vendmenu_frame:SetVisible( true )
		vendmenu_frame:SetDraggable( false )
		vendmenu_frame:ShowCloseButton( true )
		vendmenu_frame:MakePopup()
		vendmenu_frame.Paint = function() 
			surface.SetDrawColor( 50, 50, 50, 0 )
		end
	
		local screenBG = vgui.Create("DImage", vendmenu_frame)
			screenBG:SetImage( "VGUI/gfx/pnrp_screen_5b.png" )
			screenBG:SetKeepAspect()
			screenBG:SizeToContents()
			screenBG:SetSize(vendmenu_frame:GetWide(), vendmenu_frame:GetTall())
			
		local paneWidth = 255
		
		--//Vendor Inventory
		local VendorInvLabel = vgui.Create( "DLabel", vendmenu_frame )
			VendorInvLabel:SetText("Vendor Inventory")
			VendorInvLabel:SetPos(35, 40)
			VendorInvLabel:SetColor( Color( 0, 255, 0, 255 ) )
			VendorInvLabel:SizeToContents()
			
		local pnlLIList = vgui.Create("DPanelList", vendmenu_frame)
			pnlLIList:SetPos(30, 55)
			pnlLIList:SetSize(paneWidth, vendmenu_frame:GetTall() - 111)
			pnlLIList:EnableVerticalScrollbar(false) 
			pnlLIList:EnableHorizontal(true) 
			pnlLIList:SetSpacing(1)
			pnlLIList:SetPadding(5)
			
			--Generates the Vendor's inventory			
			if vendorInventory == nil or vendorInventory == "" or tostring(vendorInventory) == "NULL" then
				local EmptyLabel = vgui.Create( "DLabel", vendmenu_frame )
					EmptyLabel:SetText("Vendor Inventory is Empty")
					EmptyLabel:SetPos(40, 70)
					EmptyLabel:SetColor( Color( 0, 255, 0, 255 ) )
					EmptyLabel:SizeToContents()
			else
				for k, v in pairs( vendorInventory ) do
					local item = PNRP.Items[v["itemid"]]
					if item then
						local count = v["count"]
						local scrap = v["scrap"]
						local small_parts = v["sp"]
						local chems = v["chem"]
						if scrap == nil or scrap == "" then scrap = 0 end
						if small_parts == nil or small_parts == "" then small_parts = 0 end
						if chems == nil or chems == "" then chems = 0 end
						invTbl[v["itemid"]] = {oScrap=scrap, oSmall_parts=small_parts, oChems=chems}
						
						local pnlLIPanel = vgui.Create("DPanel", pnlLIList)
							pnlLIPanel:SetSize( 75, 140 )
							pnlLIPanel.Paint = function()
								draw.RoundedBox( 6, 0, 0, pnlLIPanel:GetWide(), pnlLIPanel:GetTall(), Color( 180, 180, 180, 255 ) )		
							end
							
							pnlLIList:AddItem(pnlLIPanel)
							
							local model = item.Model
							local skin = 0
							local countTxt = "Count: "..tostring(v["count"])
							if v["status_table"] == "" then								
								pnlLIPanel.NumberWang = vgui.Create( "DNumberWang", pnlLIPanel )
								pnlLIPanel.NumberWang:SetPos(pnlLIPanel:GetWide() / 2 - pnlLIPanel.NumberWang:GetWide() / 2, 75 )
								pnlLIPanel.NumberWang:SetMin( 1 )
								pnlLIPanel.NumberWang:SetMax( count )
								pnlLIPanel.NumberWang:SetDecimals( 0 )
								pnlLIPanel.NumberWang:SetValue( 1 )
							else
								local FuelLevel = PNRP.GetFromStat(v["status_table"], "FuelLevel")
								if FuelLevel then countTxt = "Fuel: "..tostring(FuelLevel) end
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
								
								local newModel = PNRP.GetFromStat(v["status_table"], "Model")
								local newSkin = PNRP.GetFromStat(v["status_table"], "Skin")
								if newModel then model = newModel end
								if newSkin then skin = tonumber(newSkin) end
							end
							local toolTip = item.Name.."\n"..countTxt.."\n".."Cost \n Scrap: "..scrap.."\n Small Parts: "..small_parts.."\n Chems: "..chems
							pnlLIPanel.Icon = vgui.Create("SpawnIcon", pnlLIPanel)
							pnlLIPanel.Icon:SetModel(model, skin)
							pnlLIPanel.Icon:SetPos(pnlLIPanel:GetWide() / 2 - pnlLIPanel.Icon:GetWide() / 2, 5 )
							pnlLIPanel.Icon:SetToolTip( toolTip )
							pnlLIPanel.Icon.DoClick = function() 
								--Remove item and place in inventory (Not Sell Item)
								local takeCount = 1
								if v["iid"] == "" then
									takeCount = math.Round(pnlLIPanel.NumberWang:GetValue())
								end
								
								if tonumber(takeCount) > tonumber(count) then
									takeCount = count
								elseif tonumber(takeCount) < 1 then
									takeCount = 1
								end
								net.Start("vendor_take")
									net.WriteEntity(vendorENT)
									net.WriteString(item.ID)
									net.WriteDouble(takeCount)
									net.WriteString(v["iid"])
								net.SendToServer()
								
								vendmenu_frame:Close()
							end	
							
							pnlLIPanel.editBtn = vgui.Create( "DButton", pnlLIPanel )
							pnlLIPanel.editBtn:SetPos(pnlLIPanel:GetWide() / 2 - pnlLIPanel.editBtn:GetWide() / 2, 100 )
							pnlLIPanel.editBtn:SetText( "Edit" )
							pnlLIPanel.editBtn:SetSize(pnlLIPanel:GetWide() - 8,17)
							pnlLIPanel.editBtn.DoClick = function()
								setSellItem(vendorENT, item, 0, "edit", v["iid"], v["status_table"])
								vendmenu_frame:Close()
							end
							
							pnlLIPanel.DispBtn = vgui.Create( "DButton", pnlLIPanel )
							pnlLIPanel.DispBtn:SetPos(pnlLIPanel:GetWide() / 2 - pnlLIPanel.editBtn:GetWide() / 2, 120 )
							pnlLIPanel.DispBtn:SetText( "Display Item" )
							pnlLIPanel.DispBtn:SetSize(pnlLIPanel:GetWide() - 8,17)
							pnlLIPanel.DispBtn.DoClick = function()
								net.Start("VendorCreateDisplayItem")
									net.WriteEntity(vendorENT)
									net.WriteString(item.ID)
									net.WriteString(v["iid"])
									net.WriteString(v["status_table"])
								net.SendToServer()
								vendmenu_frame:Close()
							end
					end
				end
			end		

		--//Player Inventory
		local PlayerInvLabel = vgui.Create( "DLabel", vendmenu_frame )
			PlayerInvLabel:SetText("Player  Inventory")
			PlayerInvLabel:SetPos(320, 40)
			PlayerInvLabel:SetColor( Color( 0, 255, 0, 255 ) )
			PlayerInvLabel:SizeToContents()
			
		local pnlUserIList = vgui.Create("DPanelList", vendmenu_frame)
			pnlUserIList:SetPos(315, 55)
			pnlUserIList:SetSize(paneWidth, vendmenu_frame:GetTall() - 111)
			pnlUserIList:EnableVerticalScrollbar(false) 
			pnlUserIList:EnableHorizontal(true) 
			pnlUserIList:SetSpacing(1)
			pnlUserIList:SetPadding(5)
			--Generates the user's inventory
			if inventoryTble != nil then
				for k, v in pairs( inventoryTble ) do
					local item = PNRP.Items[v["itemid"]]
					if item then
						local pnlUserIPanel = vgui.Create("DPanel", pnlUserIList)
							pnlUserIPanel:SetSize( 75, 100 )
							pnlUserIPanel.Paint = function()
								draw.RoundedBox( 6, 0, 0, pnlUserIPanel:GetWide(), pnlUserIPanel:GetTall(), Color( 180, 180, 180, 255 ) )		
							end
							
							pnlUserIList:AddItem(pnlUserIPanel)
							
							local model = item.Model
							local skin = 0
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
								
								local newModel = PNRP.GetFromStat(v["status_table"], "Model")
								local newSkin = PNRP.GetFromStat(v["status_table"], "Skin")
								if newModel then model = newModel end
								if newSkin then skin = tonumber(newSkin) end
							else
								pnlUserIPanel.NumberWang = vgui.Create( "DNumberWang", pnlUserIPanel )
								pnlUserIPanel.NumberWang:SetPos(pnlUserIPanel:GetWide() / 2 - pnlUserIPanel.NumberWang:GetWide() / 2, 75 )
								pnlUserIPanel.NumberWang:SetMin( 1 )
								pnlUserIPanel.NumberWang:SetMax( v["count"] )
								pnlUserIPanel.NumberWang:SetDecimals( 0 )
								pnlUserIPanel.NumberWang:SetValue( 1 )
							end
							
							pnlUserIPanel.Icon = vgui.Create("SpawnIcon", pnlUserIPanel)
							pnlUserIPanel.Icon:SetModel(model, skin)
							pnlUserIPanel.Icon:SetPos(pnlUserIPanel:GetWide() / 2 - pnlUserIPanel.Icon:GetWide() / 2, 5 )
							pnlUserIPanel.Icon:SetToolTip( item.Name.."\n"..countTxt.."\n Press Icon to move item." )
							pnlUserIPanel.Icon.DoClick = function() 
								local sellCount = 1
								if v["iid"] == "" then 
									sellCount = pnlUserIPanel.NumberWang:GetValue()
								end
								if sellCount > v["count"] then
									sellCount = v["count"]
								end                               
								if sellCount < 1 then
                                    LocalPlayer():ChatPrint("Not enough to store")
                                    return
                                end
								local foundItem = false
								local itmInfo = nil
								if invTbl[v["itemid"]] then
									local oScrap = invTbl[v["itemid"]]["oScrap"]
									local oSmall_parts = invTbl[v["itemid"]]["oSmall_parts"]
									local oChems = invTbl[v["itemid"]]["oChems"]
									
									local costTbl = {}
									costTbl["count"] = sellCount
									costTbl["scrap"] = oScrap
									costTbl["sp"] = oSmall_parts
									costTbl["chems"] = oChems
									
									net.Start("setVendorSellItem")
										net.WriteString(vendor_table["vendorid"])
										net.WriteString(item.ID)
										net.WriteTable(costTbl)
										net.WriteString("new")
										net.WriteString(v["iid"])
									net.SendToServer()
									vendmenu_frame:Close()
								else
									setSellItem(vendorENT, item, tostring(sellCount), "new", v["iid"], v["status_table"])
									vendmenu_frame:Close()
								end
							end								
					end
				end
			end
			
		--//Vendor Status			
		local lMenuList = vgui.Create( "DPanelList", vendmenu_frame )
			lMenuList:SetPos( 610,45 )
			lMenuList:SetSize( 150, 175 )
			lMenuList:SetSpacing( 5 )
			lMenuList:SetPadding(3)
			lMenuList:EnableHorizontal( false ) 
			lMenuList:EnableVerticalScrollbar( true ) 

			local vendormenuLabel = vgui.Create("DLabel", vendmenu_frame)
				vendormenuLabel:SetColor( Color( 255, 255, 255, 255 ) )
				vendormenuLabel:SetText( "Vendor Menu" )
				vendormenuLabel:SetFont("Trebuchet24")
				vendormenuLabel:SizeToContents()
				lMenuList:AddItem( vendormenuLabel )

			local NameLabel = vgui.Create("DLabel")
				NameLabel:SetColor( Color( 255, 255, 255, 255 ) )
				NameLabel:SetText( " Vendor Status" )
				NameLabel:SizeToContents()
				lMenuList:AddItem( NameLabel )
			local LDevide = vgui.Create("DShape") 
				LDevide:SetParent( stockStatusList ) 
				LDevide:SetType("Rect")
				LDevide:SetSize( 100, 2 ) 	
				lMenuList:AddItem( LDevide )	
			local ScrapLabel = vgui.Create("DLabel")
				ScrapLabel:SetColor( Color( 255, 255, 255, 255 ) )
				ScrapLabel:SetText( " Scrap: "..tostring(vendScrap) )
				ScrapLabel:SizeToContents()
				lMenuList:AddItem( ScrapLabel )
			local SPLabel = vgui.Create("DLabel")
				SPLabel:SetColor( Color( 255, 255, 255, 255 ) )
				SPLabel:SetText( " Small Parts: "..tostring(vendSP) )
				SPLabel:SizeToContents()
				lMenuList:AddItem( SPLabel )
			local ChemsLabel = vgui.Create("DLabel")
				ChemsLabel:SetColor( Color( 255, 255, 255, 255 ) )
				ChemsLabel:SetText( " Chemicals: "..tostring(vendChems) )
				ChemsLabel:SizeToContents()
				lMenuList:AddItem( ChemsLabel )
			local LCPLabel = vgui.Create("DLabel")
				LCPLabel:SetColor( Color( 255, 255, 255, 255 ) )
				LCPLabel:SetText( " Capacity: "..Capacity )
				LCPLabel:SizeToContents()
				lMenuList:AddItem( LCPLabel )
			
			--//Vendor Owner Menu Menu	
			local btnHPos = 250
			local btnWPos = vendmenu_frame:GetWide()-220
			local btnHeight = 40
			local lblColor = Color( 245, 218, 210, 180 )
					
			local viewShopBtn = vgui.Create("DImageButton", vendmenu_frame)
				viewShopBtn:SetPos( btnWPos,btnHPos )
				viewShopBtn:SetSize(30,30)
				viewShopBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
				viewShopBtn.DoClick = function() 
					net.Start("VendorOwnerShop")
						net.WriteEntity(vendorENT)
					net.SendToServer()
					vendmenu_frame:Close() 
				end
				viewShopBtn.Paint = function()
					if viewShopBtn:IsDown() then 
						viewShopBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
					else
						viewShopBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
					end
				end	
			local viewShopBtnLbl = vgui.Create("DLabel", vendmenu_frame)
				viewShopBtnLbl:SetPos( btnWPos+40,btnHPos+2 )
				viewShopBtnLbl:SetColor( lblColor )
				viewShopBtnLbl:SetText( "Open Shop" )
				viewShopBtnLbl:SetFont("Trebuchet24")
				viewShopBtnLbl:SizeToContents()
			
			btnHPos = btnHPos + btnHeight			
			local getResBtn = vgui.Create("DImageButton", vendmenu_frame)
				getResBtn:SetPos( btnWPos,btnHPos )
				getResBtn:SetSize(30,30)
				getResBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
				getResBtn.DoClick = function() 
					net.Start("VendorGetRes")
						net.WriteEntity(vendorENT)
					net.SendToServer()
					vendmenu_frame:Close()
				end
				getResBtn.Paint = function()
					if getResBtn:IsDown() then 
						getResBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
					else
						getResBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
					end
				end	
			local getResBtnLbl = vgui.Create("DLabel", vendmenu_frame)
				getResBtnLbl:SetPos( btnWPos+40,btnHPos+2 )
				getResBtnLbl:SetColor( lblColor )
				getResBtnLbl:SetText( "Get Resources" )
				getResBtnLbl:SetFont("Trebuchet24")
				getResBtnLbl:SizeToContents()	
			
			btnHPos = btnHPos + btnHeight			
			local vendRenameBtn = vgui.Create("DImageButton", vendmenu_frame)
				vendRenameBtn:SetPos( btnWPos,btnHPos )
				vendRenameBtn:SetSize(30,30)
				vendRenameBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
				vendRenameBtn.DoClick = function() 
					renameVendor( vendorENT, vendor_table["vendorid"], vendor_table["name"] )
					vendmenu_frame:Close()
				end
				vendRenameBtn.Paint = function()
					if vendRenameBtn:IsDown() then 
						vendRenameBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
					else
						vendRenameBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
					end
				end	
			local vendRenameBtnLbl = vgui.Create("DLabel", vendmenu_frame)
				vendRenameBtnLbl:SetPos( btnWPos+40,btnHPos+2 )
				vendRenameBtnLbl:SetColor( lblColor )
				vendRenameBtnLbl:SetText( "Rename Vendor" )
				vendRenameBtnLbl:SetFont("Trebuchet24")
				vendRenameBtnLbl:SizeToContents()
			
			btnHPos = btnHPos + btnHeight			
			local chModelBtn = vgui.Create("DImageButton", vendmenu_frame)
				chModelBtn:SetPos( btnWPos,btnHPos )
				chModelBtn:SetSize(30,30)
				chModelBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
				chModelBtn.DoClick = function() 
					changeVendorModelMenu(vendorENT, avModels)
					vendmenu_frame:Close()
				end
				chModelBtn.Paint = function()
					if chModelBtn:IsDown() then 
						chModelBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
					else
						chModelBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
					end
				end	
			local chModelBtnLbl = vgui.Create("DLabel", vendmenu_frame)
				chModelBtnLbl:SetPos( btnWPos+40,btnHPos+2 )
				chModelBtnLbl:SetColor( lblColor )
				chModelBtnLbl:SetText( "Change Model" )
				chModelBtnLbl:SetFont("Trebuchet24")
				chModelBtnLbl:SizeToContents()
			
			btnHPos = btnHPos + btnHeight			
			local clsDispItemsBtn = vgui.Create("DImageButton", vendmenu_frame)
				clsDispItemsBtn:SetPos( btnWPos,btnHPos )
				clsDispItemsBtn:SetSize(30,30)
				clsDispItemsBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
				clsDispItemsBtn.DoClick = function() 
					net.Start("clsDispItems")
						net.WriteEntity(vendorENT)
					net.SendToServer()
					vendmenu_frame:Close()
				end
				clsDispItemsBtn.Paint = function()
					if clsDispItemsBtn:IsDown() then 
						clsDispItemsBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
					else
						clsDispItemsBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
					end
				end	
			local clsDispItemsBtnLbl = vgui.Create("DLabel", vendmenu_frame)
				clsDispItemsBtnLbl:SetPos( btnWPos+40,btnHPos+2 )
				clsDispItemsBtnLbl:SetColor( lblColor )
				clsDispItemsBtnLbl:SetText( "Del Display Items" )
				clsDispItemsBtnLbl:SetFont("Trebuchet24")
				clsDispItemsBtnLbl:SizeToContents()
			
			btnHPos = btnHPos + btnHeight			
			local unSetBtn = vgui.Create("DImageButton", vendmenu_frame)
				unSetBtn:SetPos( btnWPos,btnHPos )
				unSetBtn:SetSize(30,30)
				unSetBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
				unSetBtn.DoClick = function() 
					net.Start("VendorReset")
						net.WriteEntity(vendorENT)
					net.SendToServer()
					vendmenu_frame:Close()
				end
				unSetBtn.Paint = function()
					if unSetBtn:IsDown() then 
						unSetBtn:SetImage( "VGUI/gfx/pnrp_button_down.png" )
					else
						unSetBtn:SetImage( "VGUI/gfx/pnrp_button.png" )
					end
				end	
			local unSetBtnLbl = vgui.Create("DLabel", vendmenu_frame)
				unSetBtnLbl:SetPos( btnWPos+40,btnHPos+2 )
				unSetBtnLbl:SetColor( lblColor )
				unSetBtnLbl:SetText( "Reset Vendor" )
				unSetBtnLbl:SetFont("Trebuchet24")
				unSetBtnLbl:SizeToContents()
end
net.Receive("vendor_menu", VendorMenu)

function changeVendorModelMenu(vendorENT, avModels)
	local ply = LocalPlayer()
	
	local w = 710
	local h = 520
	local title = "Select a new model"
		
	local vendmenu_frame = vgui.Create( "DFrame" )
		vendmenu_frame:SetSize( w, h ) 
		vendmenu_frame:SetPos( ScrW() / 2 - vendmenu_frame:GetWide() / 2, ScrH() / 2 - vendmenu_frame:GetTall() / 2 )
		vendmenu_frame:SetTitle( "" )
		vendmenu_frame:SetVisible( true )
		vendmenu_frame:SetDraggable( false )
		vendmenu_frame:ShowCloseButton( true )
		vendmenu_frame:MakePopup()
		vendmenu_frame.Paint = function() 
			surface.SetDrawColor( 50, 50, 50, 0 )
		end
	
		local screenBG = vgui.Create("DImage", vendmenu_frame)
			screenBG:SetImage( "VGUI/gfx/pnrp_screen_2b.png" )
			screenBG:SetKeepAspect()
			screenBG:SizeToContents()
			screenBG:SetSize(vendmenu_frame:GetWide(), vendmenu_frame:GetTall())
		
		local paneWidth = 255
		
		local VendorLabel = vgui.Create( "DLabel", vendmenu_frame )
			VendorLabel:SetText(title)
			VendorLabel:SetPos(55, 40)
			VendorLabel:SetColor( Color( 0, 255, 0, 255 ) )
			VendorLabel:SizeToContents()
			
		local pnlLIList = vgui.Create("DPanelList", vendmenu_frame)
			pnlLIList:SetPos(50, 55)
			pnlLIList:SetSize(paneWidth, vendmenu_frame:GetTall() - 111)
			pnlLIList:EnableVerticalScrollbar(false) 
			pnlLIList:EnableHorizontal(true) 
			pnlLIList:SetSpacing(1)
			pnlLIList:SetPadding(5)
			
			for _, model in pairs( avModels ) do
				vendIcon = vgui.Create("SpawnIcon", pnlLIList)
				vendIcon:SetModel(model)
				vendIcon:SetToolTip( "Set Model: "..model )
				vendIcon.DoClick = function() 
					net.Start("ChangeVendorModel")
						net.WriteEntity(vendorENT)
						net.WriteString(model)
					net.SendToServer()
					vendmenu_frame:Close()
				end	
				pnlLIList:AddItem(vendIcon)
			end
end

function renameVendor( vendorENT, vendorid, name )
	local ply = LocalPlayer()
		
	local w = 500
	local h = 150
	local title = "Rename Vendor Menu"
	
	name = tostring(name)
		
	local vendmenu_frame = vgui.Create( "DFrame" )
		vendmenu_frame:SetSize( w, h ) 
		vendmenu_frame:SetPos( ScrW() / 2 - vendmenu_frame:GetWide() / 2, ScrH() / 2 - vendmenu_frame:GetTall() / 2 )
		vendmenu_frame:SetTitle( title )
		vendmenu_frame:SetVisible( true )
		vendmenu_frame:SetDraggable( false )
		vendmenu_frame:ShowCloseButton( true )
		vendmenu_frame:MakePopup()
					
		local SetNameLbl = vgui.Create( "DLabel", vendmenu_frame )
			SetNameLbl:SetPos(60,60)
			SetNameLbl:SetColor(Color( 0, 255, 0, 255 ))
			SetNameLbl:SetText( "Vendor Name" )
			SetNameLbl:SizeToContents()
		local setNameTxt = vgui.Create("DTextEntry", vendmenu_frame)
			setNameTxt:SetText(name)
			setNameTxt:SetPos(150,62)
			setNameTxt:SetWide(300)
		local renameBtn = vgui.Create( "DButton", vendmenu_frame )
			renameBtn:SetSize( 150, 25 )
			renameBtn:SetPos( 150, 90 )
			renameBtn:SetText( "Rename Vendor" )
			renameBtn.DoClick = function( )
				net.Start("VendorRename")
					net.WriteEntity(vendorENT)
					net.WriteString(setNameTxt:GetValue())
				net.SendToServer()
				vendmenu_frame:Close()
			end
end

function setSellItem(vendorENT, item, count, option, iid, status_table)
	local ply = LocalPlayer()
	
	local w = 600
	local h = 100
	local title = "Set Sell Price"
	if not status_table then status_table = "" end
	
	local vendorID = vendorENT:GetNetVar("vendorid")
		
	local vendmenu_frame = vgui.Create( "DFrame" )
		vendmenu_frame:SetSize( w, h ) 
		vendmenu_frame:SetPos( ScrW() / 2 - vendmenu_frame:GetWide() / 2, ScrH() / 2 - vendmenu_frame:GetTall() / 2 )
		vendmenu_frame:SetTitle( title )
		vendmenu_frame:SetVisible( true )
		vendmenu_frame:SetDraggable( false )
		vendmenu_frame:ShowCloseButton( true )
		vendmenu_frame:MakePopup()
		
		local model = item.Model
		local skin = 0
		if status_table != "" then
			local newModel = PNRP.GetFromStat(status_table, "Model")
			local newSkin = PNRP.GetFromStat(status_table, "Skin")
			if newModel then model = newModel end
			if newSkin then skin = tonumber(newSkin) end
		end
		
		local ItemIcon = vgui.Create("SpawnIcon", vendmenu_frame)
			ItemIcon:SetPos(20,30)
			ItemIcon:SetModel(model, skin)
			ItemIcon:SetToolTip( item.Name )
		
		local scrapSlideLbl = vgui.Create( "DLabel", vendmenu_frame )
			scrapSlideLbl:SetPos(90,30)
			scrapSlideLbl:SetColor(Color( 255, 255, 255, 255 ))
			scrapSlideLbl:SetText( "Scrap" )
			scrapSlideLbl:SizeToContents()
		local scrapSlide = vgui.Create( "DNumSlider", vendmenu_frame )
			scrapSlide:SetWide( 350 )
			scrapSlide:SetPos( 60, 22 )
			scrapSlide:SetText( "" )
			scrapSlide:SetMin( 0 )
			scrapSlide:SetMax( 1000 )
			scrapSlide:SetDecimals( 0 )
			scrapSlide:SetValue( 0 )
			scrapSlide.Paint = function() -- Paint function
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
			
		local spSlideLbl = vgui.Create( "DLabel", vendmenu_frame )
			spSlideLbl:SetPos(90,50)
			spSlideLbl:SetColor(Color( 255, 255, 255, 255 ))
			spSlideLbl:SetText( "Small Parts" )
			spSlideLbl:SizeToContents()
		local spSlide = vgui.Create( "DNumSlider", vendmenu_frame )
			spSlide:SetWide( 350 )
			spSlide:SetPos( 60,42 )
			spSlide:SetText( "" )
			spSlide:SetMin( 0 )
			spSlide:SetMax( 1000 )
			spSlide:SetDecimals( 0 )
			spSlide:SetValue( 0 )
			spSlide.Paint = function() -- Paint function
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
			
		local chemSlideLbl = vgui.Create( "DLabel", vendmenu_frame )
			chemSlideLbl:SetPos(90,70)
			chemSlideLbl:SetColor(Color( 255, 255, 255, 255 ))
			chemSlideLbl:SetText( "Chemicals" )
			chemSlideLbl:SizeToContents()
		local chemSlide = vgui.Create( "DNumSlider", vendmenu_frame )
			chemSlide:SetWide( 350 )
			chemSlide:SetPos( 60,62 )
			chemSlide:SetText( "" )
			chemSlide:SetMin( 0 )
			chemSlide:SetMax( 1000 )
			chemSlide:SetDecimals( 0 )
			chemSlide:SetValue( 0 )
			chemSlide.Paint = function() -- Paint function
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
		
		local btnText = ""
		if option == "edit" then
			btnText = "Set New Price"
		else
			btnText = "Sell "..count.." Item(s)"
		end
		
		local buttonNewVendor = vgui.Create( "DButton", vendmenu_frame )
			buttonNewVendor:SetSize( 125, 20 )
			buttonNewVendor:SetPos( 450, 30 )
			buttonNewVendor:SetText( btnText )
			buttonNewVendor.DoClick = function( )
				local setScrap = math.Round(scrapSlide:GetValue())
				if setScrap < 0 then
					setScrap = 0
				end
				local setSP = math.Round(spSlide:GetValue())
				if setSP < 0 then
					setSP = 0
				end
				local setChems = math.Round(chemSlide:GetValue())
				if setChems < 0 then
					setChems = 0
				end

				local costTbl = {}
				costTbl["count"] = count
				costTbl["scrap"] = setScrap
				costTbl["sp"] = setSP
				costTbl["chems"] = setChems
				
				net.Start("setVendorSellItem")
					net.WriteString(vendorID)
					net.WriteString(item.ID)
					net.WriteTable(costTbl)
					net.WriteString(option)
					net.WriteString(iid)
				net.SendToServer()
									
				vendmenu_frame:Close()
			end
end

function VendorShopMenu()
	local ply = LocalPlayer()
	
	local vendorENT = net:ReadEntity()
	local vendor_table = net.ReadTable()
	local inventoryTble = net.ReadTable()	
	
	local vendorInventory = vendor_table["inv"]
	
	local w = 610
	local h = 620
	local title = "Vendor Shop Menu"
		
	local vendmenu_frame = vgui.Create( "DFrame" )
		vendmenu_frame:SetSize( w, h ) 
		vendmenu_frame:SetPos( ScrW() / 2 - vendmenu_frame:GetWide() / 2, ScrH() / 2 - vendmenu_frame:GetTall() / 2 )
		vendmenu_frame:SetTitle( "" )
		vendmenu_frame:SetVisible( true )
		vendmenu_frame:SetDraggable( false )
		vendmenu_frame:ShowCloseButton( true )
		vendmenu_frame:MakePopup()
		vendmenu_frame.Paint = function() 
			surface.SetDrawColor( 50, 50, 50, 0 )
		end
	
		local screenBG = vgui.Create("DImage", vendmenu_frame)
			screenBG:SetImage( "VGUI/gfx/pnrp_screen_1b.png" )
			screenBG:SetKeepAspect()
			screenBG:SizeToContents()
			screenBG:SetSize(vendmenu_frame:GetWide(), vendmenu_frame:GetTall())
			
		local VendorShopLabel = vgui.Create( "DLabel", vendmenu_frame )
			VendorShopLabel:SetText(vendor_table["name"])
			VendorShopLabel:SetPos(55, 40)
			VendorShopLabel:SetColor( Color( 0, 255, 0, 255 ) )
			VendorShopLabel:SizeToContents()
		
		local pnlList = vgui.Create("DPanelList", vendmenu_frame)
			pnlList:SetPos(45, 60)
			pnlList:SetSize(vendmenu_frame:GetWide() - 90, vendmenu_frame:GetTall() - 110)
			pnlList:EnableVerticalScrollbar(true) 
			pnlList:EnableHorizontal(false) 
			pnlList:SetSpacing(1)
			pnlList:SetPadding(10)
				
		--Shop Item List
		if vendorInventory == nil or vendorInventory == "" or tostring(vendorInventory) == "NULL" then
			local EmptyLabel = vgui.Create( "DLabel", vendmenu_frame )
				EmptyLabel:SetText("Vendor Inventory is Empty")
				EmptyLabel:SetPos(40, 70)
				EmptyLabel:SetColor( Color( 0, 255, 0, 255 ) )
				EmptyLabel:SizeToContents()
		else
			for k, v in pairs( vendorInventory ) do
				local item = PNRP.Items[v["itemid"]]
				if item then
					local count = v["count"]
					local scrap = v["scrap"]
					local small_parts = v["sp"]
					local chems = v["chem"]
					if scrap == nil or scrap == "" then scrap = 0 end
					if small_parts == nil or small_parts == "" then small_parts = 0 end
					if chems == nil or chems == "" then chems = 0 end
					
					local pnlPanel = vgui.Create("DPanel")
						pnlPanel:SetTall(75)
						pnlPanel.Paint = function()
							draw.RoundedBox( 1, 0, 0, pnlPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
							draw.RoundedBox( 1, 0, pnlPanel:GetTall()-1, pnlPanel:GetWide(), 1, Color( 0, 255, 0, 80 ) )
						end
						pnlList:AddItem(pnlPanel)
													
						pnlPanel.Title = vgui.Create("DLabel", pnlPanel)
						pnlPanel.Title:SetPos(90, 5)
						pnlPanel.Title:SetText(item.Name)
						pnlPanel.Title:SetColor(Color( 0, 255, 0, 255 ))
						pnlPanel.Title:SizeToContents() 
						pnlPanel.Title:SetContentAlignment( 5 )
						
						pnlPanel.Cost = vgui.Create("DLabel", pnlPanel)		
						pnlPanel.Cost:SetPos(90, 55)
						pnlPanel.Cost:SetText("Cost: Scrap "..tostring(scrap).." | Small Parts "..tostring(small_parts).." | Chemicals "..tostring(chems))
						pnlPanel.Cost:SetColor(Color( 0, 255, 0, 255 ))
						pnlPanel.Cost:SizeToContents() 
						pnlPanel.Cost:SetContentAlignment( 5 )
						
						pnlPanel.InStock = vgui.Create("DLabel", pnlPanel)		
						pnlPanel.InStock:SetPos(340, 5)
						pnlPanel.InStock:SetText("In Stock: "..count)
						pnlPanel.InStock:SetColor(Color( 0, 250, 0, 255 ))
						pnlPanel.InStock:SizeToContents() 
						pnlPanel.InStock:SetContentAlignment( 5 )
						
						pnlPanel.ItmInfo = vgui.Create("DLabel", pnlPanel)		
						pnlPanel.ItmInfo:SetPos(90, 25)
						pnlPanel.ItmInfo:SetText(item.Info)
						pnlPanel.ItmInfo:SetColor(Color( 0, 200, 0, 255 ))
						pnlPanel.ItmInfo:SetWide(250)
						pnlPanel.ItmInfo:SetTall(25)
						pnlPanel.ItmInfo:SetWrap(true)
						pnlPanel.ItmInfo:SetContentAlignment( 5 )	
						
						pnlPanel.ItemWeight = vgui.Create("DLabel", pnlPanel)		
						pnlPanel.ItemWeight:SetPos(340, 55)
						pnlPanel.ItemWeight:SetText("Weight: "..item.Weight)
						pnlPanel.ItemWeight:SetColor(Color( 0, 200, 0, 255 ))
						pnlPanel.ItemWeight:SizeToContents() 
						pnlPanel.ItemWeight:SetContentAlignment( 5 )
						
						local model = item.Model
						local skin = 0
						if v["status_table"] == "" then
							pnlPanel.ItemAmount = vgui.Create("DLabel", pnlPanel)		
							pnlPanel.ItemAmount:SetPos(340, 30)
							pnlPanel.ItemAmount:SetText("Buy amount: ")
							pnlPanel.ItemAmount:SetColor(Color( 0, 245, 0, 255 ))
							pnlPanel.ItemAmount:SizeToContents() 
							pnlPanel.ItemAmount:SetContentAlignment( 5 )
						
							pnlPanel.NumberWang = vgui.Create( "DNumberWang", pnlPanel )
							pnlPanel.NumberWang:SetPos(410, 25 )
							pnlPanel.NumberWang:SetMin( 1 )
							pnlPanel.NumberWang:SetMax( count )
							pnlPanel.NumberWang:SetDecimals( 0 )
							pnlPanel.NumberWang:SetValue( 1 )
						else
							local HPTxt = ""
							local HP = PNRP.GetFromStat(v["status_table"], "HP")
							if HP then 	HPTxt = "HP: "..HP end
							local PowerLevel = PNRP.GetFromStat(v["status_table"], "PowerLevel")
							if PowerLevel then 	HPTxt = HPTxt.." Charge: "..tostring(math.Round(PowerLevel/100)).."% " end
							local FuelLevel = PNRP.GetFromStat(v["status_table"], "FuelLevel")
							if FuelLevel then HPTxt = HPTxt.." Fuel: "..tostring(FuelLevel) end
							
							pnlPanel.HP = vgui.Create("DLabel", pnlPanel)		
							pnlPanel.HP:SetPos(340, 30)
							pnlPanel.HP:SetText(HPTxt)
							pnlPanel.HP:SetColor(Color( 0, 255, 0, 255 ))
							pnlPanel.HP:SizeToContents() 
							pnlPanel.HP:SetContentAlignment( 5 )
							
							local newModel = PNRP.GetFromStat(v["status_table"], "Model")
							local newSkin = PNRP.GetFromStat(v["status_table"], "Skin")
							if newModel then model = newModel end
							if newSkin then skin = tonumber(newSkin) end
						end
					
						pnlPanel.Icon = vgui.Create("SpawnIcon", pnlPanel)
						pnlPanel.Icon:SetModel(model, skin)
						pnlPanel.Icon:SetPos(10, 5)
						pnlPanel.Icon:SetToolTip( "Click to buy" )
						pnlPanel.Icon.DoClick = function()
							local buyAmount = 1
							if v["iid"] == "" then
								buyAmount = math.Round(pnlPanel.NumberWang:GetValue())
							end
							
							if tonumber(buyAmount) <= 0 then
								buyAmount = 1
							elseif tonumber(buyAmount) > tonumber(count) then
								buyAmount = count
							end
							local itemCost = {scrap,small_parts,chems}
							net.Start("BuyFromVendor")
								net.WriteEntity(vendorENT)
								net.WriteDouble(tonumber(buyAmount))
								net.WriteString(item.ID)
								net.WriteTable(itemCost)
								net.WriteString(v["iid"])
							net.SendToServer()
							vendmenu_frame:Close()
						end	
				end
			end
		end
end
net.Receive("vendor_shop_menu", VendorShopMenu)
