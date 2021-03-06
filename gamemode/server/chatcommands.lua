
//Find player by Name
function findPlayers( str )

	local matches = {}
	
		ply = str:lower()
	
	for k, v in pairs( player.GetAll() ) do
	
		if ( v:GetName():lower():match( ply:lower() ) ) then
		
			table.insert( matches, v )
			print("found player")
		
		end
		
		if ( table.Count( matches ) == 0 ) then
		
			MsgN( "No players found." )
			return false
		
		end
		
		if ( table.Count( matches ) > 1 ) then
		
			MsgN( "Multiple players found!" )
			return false
		
		end
		
		return matches[1]
			
	end

end

//Find ply by RPName
function findRPPlayers( str )

	local matches = {}
	
	name = str:lower()
	
	for k, v in pairs( player.GetAll() ) do
	
		if v:GetRPName():lower() == name then
		
			table.insert( matches, v )
		
		end
		
	end	

		if ( table.Count( matches ) == 0 ) then
		
			MsgN( "No players found." )
			return false
		
		end
		
		if ( table.Count( matches ) > 1 ) then
		
			MsgN( "Multiple players found!" )
			return false
		
		end
		
		return matches[1]
	
	
end


	//Player Chat Commands
	hook.Add('PlayerSay', 'AdminCommands', function(ply, text, isteam )
		
		if !(ply:isRPAdmin()) then return end
		
		local text = string.lower(text)
		local command = string.Explode( " ", text )
		
		
		//Set player Admin
		if ( command[1] == "!admin" ) then
		
			local victim = string.sub( text, 8)
			print(victim)
			
			local target = findRPPlayers( victim )
			
			if ( target:IsValid() ) then
			
				target:makeRPAdmin()
				
			end
			
			return ""
			
		end
		
		//Set target role
		//!role [role] [Player]
		if ( command[1] == "!role" ) then
			local victim = string.gsub( text,"!role "..command[2].." ", "" )
			
			local target = findRPPlayers( victim )			
			
			if ( IsValid( target ) ) then
			
				local roleName = ""
					for k, v in pairs(RPRoles) do
						if k == command[2] then roleName = v.name end
					end	
			
				ply:SendLua("notification.AddLegacy(\"You have promoted "..target:GetRPName().." to "..roleName.."\", NOTIFY_GENERIC, 5)")
				target:SetRPRole(command[2])
				
			end
			
			return ""
			
		end		
		
		
		//Kick player
		if (command[1] == "!kick" ) then
			
			local victim = string.sub( text, 7)
			
			local target = findRPPlayers( victim )
			
			if ( IsValid( target ) ) then
			
				target:Kick("You have been kicked!")	
				
				print(target:GetName().." has been kicked.")
				
			end
			
			return ""
			
		end
	
	end)