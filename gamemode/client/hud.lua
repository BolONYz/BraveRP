local tohide = { -- This is a table where the keys are the HUD items to hide
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudVoiceStatus"] = true,
	["CHudVoiceSelfStatus"] = true
}

local function HUDHider(name) -- This is a local function because all functions should be local unless another file needs to run it
	if (tohide[name]) then     -- If the HUD name is a key in the table
		return false      -- Return false.
	end
end
hook.Add("HUDShouldDraw", "HUDHider", HUDHider)

//Disable the red jelly screenq
local hudconvar = CreateClientConVar("BRP_RedHud", 1, false, false)

//Draw red jelly
function RedHUD()
	
	if !(hudconvar:GetInt() == 1) then return end
	
	local ply = LocalPlayer()
	local HP = ply:Health()
	local Armor = ply:Armor()
	
	if HP <= 0 then
		draw.RoundedBox(1, -5, -5, (ScrW()+10), (ScrH()+10), Color(0, 0, 0, 255 )  )
	end

	if HP <= 30 then
		draw.RoundedBox(1, -5, -5, (ScrW()+10), (ScrH()+10), Color(255, 0, 0, -HP + 70 )  )
	end

end
hook.Add("HUDPaint", "RedHUD", RedHUD)

//Bleach, dull colors
local bleachedhud =
	{
	 [ "$pp_colour_addr" ] = 0,
	 [ "$pp_colour_addg" ] = 0,
	 [ "$pp_colour_addb" ] = 0,
	 [ "$pp_colour_brightness" ] = 0,
	 [ "$pp_colour_contrast" ] = 1,
	 [ "$pp_colour_colour" ] = 0.3,
	 [ "$pp_colour_mulr" ] = 0,
	 [ "$pp_colour_mulg" ] = 0,
	 [ "$pp_colour_mulb" ] = 0
	}

function GM:RenderScreenspaceEffects()

 DrawColorModify( bleachedhud )

end

function StatHUD()

	local ply = LocalPlayer()

	draw.RoundedBox( 8, 10, ScrH() - 190, (300), (180), Color(0, 0, 0, 155))
	draw.SimpleText( ply:GetRegister(), "Trebuchet18", 20, ScrH()-150, Color(255,255,255,255) )
	draw.SimpleText( "CREDITS: "..ply:GetMoney().."S", "Trebuchet18", 20, ScrH()-110, Color(255,255,255,255) )
	draw.SimpleText( ply:GetRPName(), "Trebuchet24", 20, ScrH()-185, Color(255,255,255,255) )
	draw.SimpleText( GetOutfitName(ply:GetRPModel()), "Trebuchet18", 220, ScrH()-30, Color(255,255,255,255) )
	draw.SimpleText( ply:GetCaste(), "Trebuchet18", 20, ScrH()-160, team.GetColor(ply:Team()) )

end
hook.Add("HUDPaint", "StatHUD", StatHUD)

function drawFace()

	local iconmodel = vgui.Create("DModelPanel")
		iconmodel:SetModel(LocalPlayer():GetRPModel())
		iconmodel:SetPos(220, ScrH() - 110)
	    function iconmodel:LayoutEntity( Entity ) return end
		iconmodel:SetAnimated(false)
		iconmodel:SetSize(80,80)
		iconmodel:SetCamPos( Vector( 14, 4, 65))
		iconmodel:SetLookAt( Vector( 0, 0, 66.5 ) )	
		
	timer.Create("RefreshAvatar", 1, 0, function()
			if LocalPlayer():GetModel() ~= iconmodel.Entity:GetModel() then
				iconmodel:Remove()
				
				iconmodel = vgui.Create("DModelPanel")
				iconmodel:SetModel( LocalPlayer():GetModel())
				function iconmodel:LayoutEntity( Entity ) return end
				iconmodel:SetPos(220, ScrH() - 110)
				iconmodel:SetAnimated(false)
				iconmodel:SetSize(80,80)
				iconmodel:SetCamPos( Vector( 14, 4, 65))
				iconmodel:SetLookAt( Vector( 0, 0, 66.5 ) )
			end
		end)
end
hook.Add("InitPostEntity", "drawFace", drawFace)
