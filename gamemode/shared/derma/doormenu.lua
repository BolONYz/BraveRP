if SERVER then

	util.AddNetworkString("doormenu")
	
	concommand.Add( "BRP_DoorMenu", DoorMenu )
	
	hook.Add("ShowSpare1", "Door Menu", DoorMenu)
	
	function DoorMenu( ply )
	
		local tr = util.GetPlayerTrace(ply)
		local trace = util.TraceLine(tr)
				
		if !(trace.Entity:IsDoor()) then
			ply:ConCommand("BRP_RegisterPlayer")
		return end
		
		local tar = trace.Entity
		local b = tar:IsOwned()
		local e = tar:GetRPOwner() == ply
		if math.floor((ply:GetPos():Distance( tar:GetPos() ))/40) > 5 then return end		
		
		net.Start("doormenu")
		net.WriteBool(b)
		net.WriteBit(e)
		net.Send(ply)
	end

elseif CLIENT then

	function openDoorMenu( owned, you )
		
		local byu = false
		
		if you == 1 then
			byu = true
		end
		
		print(byu)
		
		local ply = LocalPlayer()
	
		local DoorFrame = vgui.Create( "DFrame" )
			DoorFrame:SetSize( 185, 495 )
			DoorFrame:SetTitle( "Door Menu" )
			DoorFrame:SetVisible( true )
			DoorFrame:SetDraggable( false )
			DoorFrame:ShowCloseButton( true )
			DoorFrame:Center()
			DoorFrame:MakePopup()	
			DoorFrame.Paint = function(self,w,h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 25, 68, 131, 75 ) )
			end

		local BuyBtn = vgui.Create( "DButton", DoorFrame )
			BuyBtn:SetText( "Buy Door" )
			BuyBtn:SetPos( 10, 35 )
			BuyBtn:SetSize( 165, 105 )
			BuyBtn:SetEnabled(!owned)
			BuyBtn:SetColor(color_black)
			BuyBtn.Paint = function (self, w ,h)
				draw.RoundedBox( 4, 0, 0, w, h, color_white )
				if owned then draw.RoundedBox( 4, 0, 0, w, h, Color(155,155,155,255) ) end
			end
			BuyBtn.DoClick = function ()
				RunConsoleCommand("BRP_BuyDoor")
				DoorFrame:Close()
			end	
			
			
		local SellBtn = vgui.Create( "DButton", DoorFrame )
			SellBtn:SetText( "Sell Door" )
			SellBtn:SetPos( 10, 150 )
			SellBtn:SetSize( 165, 105 )
			SellBtn:SetEnabled(byu)
			SellBtn:SetColor(color_black)

			SellBtn.Paint = function (self, w ,h)
				draw.RoundedBox( 4, 0, 0, w, h, color_white )
				if !byu then draw.RoundedBox( 4, 0, 0, w, h, Color(155,155,155,255) ) end
			end
			SellBtn.DoClick = function ()	
				RunConsoleCommand("BRP_SellDoor")	
				DoorFrame:Close()				
			end
			
			
		local ChangeNameBtn = vgui.Create( "DButton", DoorFrame )
			ChangeNameBtn:SetText( "Change Door Name" )
			ChangeNameBtn:SetPos( 10, 265 )
			ChangeNameBtn:SetSize( 165, 105 )
			ChangeNameBtn:SetColor(color_black)
			ChangeNameBtn:SetEnabled(byu)
			ChangeNameBtn.Paint = function (self, w ,h)
				draw.RoundedBox( 4, 0, 0, w, h, color_white )
				if !byu then draw.RoundedBox( 4, 0, 0, w, h, Color(155,155,155,255) ) end
			end
			ChangeNameBtn.DoClick = function ()	
				openNameMenu()
				DoorFrame:Close()
			end			

		local GroupNameBtn = vgui.Create( "DButton", DoorFrame )
			GroupNameBtn:SetText( "Set Permissions" )
			GroupNameBtn:SetPos( 10, 380 )
			GroupNameBtn:SetSize( 165, 105 )
			GroupNameBtn:SetColor(color_black)
			GroupNameBtn:SetEnabled(byu)
			GroupNameBtn.Paint = function (self, w ,h)
				draw.RoundedBox( 4, 0, 0, w, h, color_white )
				if !byu then draw.RoundedBox( 4, 0, 0, w, h, Color(155,155,155,255) ) end
			end
			GroupNameBtn.DoClick = function ()	
				openDoorPerm()
				DoorFrame:Close()
			end			
		

		
	end	
	
	function openNameMenu()
	
		local TitleFrame = vgui.Create( "DFrame" )
			TitleFrame:SetSize( 300, 150 )
			TitleFrame:SetTitle( "Change Door Name" )
			TitleFrame:SetVisible( true )
			TitleFrame:SetDraggable( false )
			TitleFrame:ShowCloseButton( true )
			TitleFrame.Paint = function(self,w,h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 25, 68, 131, 75 ) )
			end			
			TitleFrame:Center()
			TitleFrame:MakePopup()		
	
		local DermaText = vgui.Create("DTextEntry", TitleFrame )		
			DermaText:SetPos( 75, 50 )
			DermaText:SetTall( 20 )
			DermaText:SetWide( 150 )		
			
		local TitleButton = vgui.Create( "DButton", TitleFrame )
			TitleButton:SetText( "Door Name!" )
			TitleButton:SetPos( 100, 100 )
			TitleButton:SetSize( 100, 25 )	
			TitleButton:SetColor(color_black)
			TitleButton.Paint = function (self, w ,h)
				draw.RoundedBox( 4, 0, 0, w, h, color_white )
			end			
			TitleButton.DoClick = function ()
				TitleFrame:Close()
				RunConsoleCommand("BRP_NameDoor",DermaText:GetValue())
				//notification.AddLegacy( "You have changed your title to: "..DermaText:GetValue()..".", NOTIFY_HINT, 5 )
			end				

	
	end	
	
	function openDoorPerm()
	
		local Frame = vgui.Create( "DFrame" )
			Frame:SetSize( 300, 300 )
			Frame:SetTitle( "Change Door Permissions" )
			Frame:SetVisible( true )
			Frame:SetDraggable( false )
			Frame:ShowCloseButton( true )
			Frame.Paint = function(self,w,h)
				draw.RoundedBox( 8, 0, 0, w, h, Color( 25, 68, 131, 75 ) )
			end			
			Frame:Center()
			Frame:MakePopup()		
		
		local BuddyList = vgui.Create( "DListView", Frame )
			BuddyList:Dock( FILL )
			BuddyList:DockMargin(2,2,2,40)
			BuddyList:AddColumn("Player")
			BuddyList:AddColumn("Allowed?")

			local tr = util.GetPlayerTrace(LocalPlayer())
			local trace = util.TraceLine(tr)
			
			for k,v in pairs(player.GetAll()) do
				BuddyList:AddLine( v:GetRPName(), IsPerm(trace.Entity, v:GetRPName(), true) )
			end
			
			BuddyList.DoDoubleClick = function()
				AddPerm(trace.Entity, LocalPlayer())
			end
			
		local CloseBtn = vgui.Create( "DButton", Frame )
			CloseBtn:SetText( "Close" )
			CloseBtn:SetPos( 100, 265 )
			CloseBtn:SetSize( 100, 25 )	
			CloseBtn:SetColor(color_black)
			CloseBtn.Paint = function (self, w ,h)
				draw.RoundedBox( 4, 0, 0, w, h, color_white )
			end			
			CloseBtn.DoClick = function ()
				Frame:Close()
			end				

	
	end		
	
	
	net.Receive( "doormenu", function(len)
		openDoorMenu( net.ReadBool(), net.ReadBit() )
	end)
	
	
end	