function ConSetMoney( ply, command, args, commandstring)

//BRP_SetMoney AMOUNT PLAYER

if !(ply:isRPAdmin()) then return end
if !(args[2]) then return end

	local i = 2 + string.len(args[1])
	local victim = string.sub( commandstring, i)

	local ConTarget = findRPPlayers( victim )

	if ConTarget == false then return end	
	
	ConTarget:SetMoney( args[1] )

	print( ply:GetName().." set "..victim.."'s money to " ..args[1])

end
concommand.Add("BRP_SetMoney", ConSetMoney)



function ConAddMoney( ply, command, args, commandstring)

//BRP_AddMoney AMOUNT PLAYER

if !(ply:isRPAdmin()) then return end
if !(args[2]) then return end

	local i = 2 + string.len(args[1])
	local victim = string.sub( commandstring, i)

	local ConTarget = findRPPlayers( victim )
	
	if ConTarget == false then return end
	
	ConTarget:GiveMoney( args[1] )

	print( ply:GetName().." added "..victim.."$ to " ..args[1].."'s money")

end
concommand.Add("BRP_AddMoney", ConAddMoney)



function ConTakeMoney( ply, command, args, commandstring)

//BRP_TakeMoney AMOUNT PLAYER

if !(ply:isRPAdmin()) then return end
if !(args[2]) then return end

	local i = 2 + string.len(args[1])
	local victim = string.sub( commandstring, i)

	local ConTarget = findRPPlayers( victim )
	
	if ConTarget == false then return end
	
	ConTarget:TakeMoney( args[1] )

	print( ply:GetName().." took "..args[1].."$ From " ..victim.."'s money")

end
concommand.Add("BRP_TakeMoney", ConTakeMoney)



function ConSetRole( ply, command, args, commandstring)

//BRP_SetRole ROLE PLAYER

if !(ply:isRPAdmin()) then return end
if !(args[2]) then return end

	local i = 2 + string.len(args[1])
	local victim = string.sub( commandstring, i)

	local ConTarget = findRPPlayers( victim )
	
	if ConTarget == false then return end
	
	ConTarget:SetRPRole( args[1] )

	print( ply:GetName().." set "..victim.." to " ..args[1])

end
concommand.Add("BRP_SetRole", ConSetRole)


function ConBuyDoor( ply, command, args, commandstring)

	//Buys the door you looking at

	local tr = util.GetPlayerTrace(ply)
	local trace = util.TraceLine(tr)
		
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return  end	
			
	local door = trace.Entity
			
		print(door)
			
		if door:IsOwned() then return end
			
		if (door:IsDoor()) then
					
			local targetPos = door:GetPos() + Vector(0,0,84)
			local targetDistance = math.floor((ply:GetPos():Distance( targetPos ))/40)
						
		if targetDistance < 5 then
			
			door:BuyDoor( ply ) 
			
		end
	end
	
	print( ply:GetRPName().." has bought " ..tostring(door))

end
concommand.Add("BRP_BuyDoor", ConBuyDoor)

function ConSellDoor( ply, command, args, commandstring)

	//Player sells door
	
	local tr = util.GetPlayerTrace(ply)
	local trace = util.TraceLine(tr)
		
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end	
			
	local door = trace.Entity
			
		if !(door:GetRPOwner() == ply) then return end
			
		if (door:IsDoor()) then
					
			local targetPos = door:GetPos() + Vector(0,0,84)
			local targetDistance = math.floor((ply:GetPos():Distance( targetPos ))/40)
						
			if targetDistance < 5 then
			
			door:SellDoor( ply )
			
			end
		end
	
	print( ply:GetRPName().." has sold " ..tostring(door))

end
concommand.Add("BRP_SellDoor", ConSellDoor)

function ConNameDoor( ply, command, args, commandstring)

	//Player names their door

	local tr = util.GetPlayerTrace(ply)
	local trace = util.TraceLine(tr)
		
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end	
			
	local door = trace.Entity
			
		if !(door:GetRPOwner() == ply) then return end
			
		if (door:IsDoor()) then
					
			local targetPos = door:GetPos() + Vector(0,0,84)
			local targetDistance = math.floor((ply:GetPos():Distance( targetPos ))/40)
						
			if targetDistance < 5 then
			
				door:SetNWString("DoorName", args[1]) 
			
			end
		end
	
	print( ply:GetRPName().." named their door to " ..args[1])

end
concommand.Add("BRP_NameDoor", ConNameDoor)

function RegisterPlayer(ply, command, args, commandstring)

		if ply:GetRPRole() == "dhc" then
			local tr = util.GetPlayerTrace(ply)
			local trace = util.TraceLine(tr)
			
			if (!trace.Hit) then return ply:SendLua("notification.AddLegacy(\"You must be looking at a player!\", NOTIFY_GENERIC, 5)") end
				if (!trace.HitNonWorld) then return ply:SendLua("notification.AddLegacy(\"You must be looking at a player!\", NOTIFY_GENERIC, 5)")  end	
						
					if (trace.Hit) then
						local target = trace.Entity
								
						if (target:IsPlayer()) then
							if (target:IsValid()) then
								
								local targetPos = target:GetPos() + Vector(0,0,84)
								local targetDistance = math.floor((ply:GetPos():Distance( targetPos ))/40)
										
								if targetDistance < 5 then
									
									target:Register()
									ply:SendLua("notification.AddLegacy(\"You register "..target:GetRPName().." to #"..target:GetRegister()..".\", NOTIFY_GENERIC, 5)") 
									
								
								end
								
							end
								
						end
					end
		end
		
end
concommand.Add("BRP_RegisterPlayer", RegisterPlayer)

function ConSellAllDoors( ply, command, args, commandstring)

	//Player sells all their doors

	for k, v in pairs(ents.GetAll()) do
		if v:IsDoor() then 
			if v:GetRPOwner() == ply then
			
				v:SellDoor( ply )
			
			end
		end
	end
	
	print( ply:GetRPName().." has sold all their doors. ")

end
concommand.Add("BRP_SellAllDoors", ConSellAllDoors)