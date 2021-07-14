local mysql = exports.mysql

function silahListeYenile(dbid)

	local sorgu = mysql:query("SELECT * FROM gsilahlar WHERE `dbid` = '".. exports.mysql:escape_string( dbid ) .."'")
	local silahLar = {}
	while true do
		local row = mysql:fetch_assoc(sorgu) 
		if not row then break end
			local id =  row["silahno"] 
			local tarih =  row["zaman"] 
			local value =  row["value"] 
			local bolge =  row["bolge"] 
			local datatable = split( value, ":" )
			local marka = datatable[3]
			table.insert(silahLar, {id=id,tarih=tarih, marka=marka, bolge=bolge})
	end
		triggerClientEvent(source, "gsilahlar:silahGonderC", getRootElement(), silahLar)
end
addEvent("gsilahlar:silahGonderS", true)
addEventHandler("gsilahlar:silahGonderS", root, silahListeYenile)


function gYardim(thePlayer)
-- illegal birlik olayı burda başlıyor
local oyuncuBirlik = getPlayerTeam(thePlayer)
local birlikTip = getElementData(oyuncuBirlik, "type")
local birlikF = getElementData(thePlayer, "faction")
if (birlikTip) and (birlikTip == 0) or (birlikTip == 1) or  birlikF == -1  then
else
return end -- burda bitiyor
		outputChatBox("----------------------------------------------------------------------------------", thePlayer, 255, 0, 0)
		outputChatBox("==> Gömülen silahların hakkında bilgi almak için /gsilahlar --",thePlayer,255,240,240)
		outputChatBox("==> Silah ID öğrenmek için /silahlarim --",thePlayer,255,240,240)
		outputChatBox("==> Silah gömmek için /silahgom [Silah ID] --",thePlayer,255,240,240)
		outputChatBox("==> Silahı gömülü yerden çıkartman için /silahcikart [Silah ID] --",thePlayer,255,240,240)
		outputChatBox("----------------------------------------------------------------------------------", thePlayer, 255, 0, 0)
end
addCommandHandler("silahyardim", gYardim)

function silahLarim(oyuncu)
-- illegal birlik olayı burda başlıyor
local oyuncuBirlik = getPlayerTeam(oyuncu)
local birlikTip = getElementData(oyuncuBirlik, "type")
local birlikF = getElementData(oyuncu, "faction")
if (birlikTip) and (birlikTip == 0) or (birlikTip == 1) or  birlikF == -1  then
else
return end -- burda bitiyor
			local items = exports["item-system"]:getItems(oyuncu)
			outputChatBox("[!] #ffffffVarolan Silahların", oyuncu, 0, 0, 255, true)
			for i,v in pairs(items) do
				if v[1] == 115 then
					local datapacked = v[2]
					local datatable = split( datapacked, ":" )
					outputChatBox("[!]#ffffff Silah: "..datatable[3].." - ID: "..v[3], oyuncu, 0, 0, 255, true)
				end
			end
	end
addCommandHandler("silahlarim", silahLarim)

local toprak = { }
function eneseps(oyuncu,cmd, weaponid)

if not tonumber(weaponid) then
		outputChatBox("[!] #ffffffSilahını gömmek için", oyuncu, 255, 0, 0, true)
		outputChatBox("[!] #ffffff/" .. cmd .. " [Silah ID]", oyuncu, 0, 255, 0, true)		
		return end
		-- illegal birlik olayı burda başlıyor
local oyuncuBirlik = getPlayerTeam(oyuncu)
local birlikTip = getElementData(oyuncuBirlik, "type")
local birlikF = getElementData(oyuncu, "faction")
if (birlikTip) and (birlikTip == 0) or (birlikTip == 1) or  birlikF == -1  then
else
return end -- burda bitiyor
		if  getElementData(oyuncu, "silahCik") then return end	
		if (not getElementData(oyuncu, "silahGom")) then 
				local items = exports["item-system"]:getItems(oyuncu)
				local dbid = getElementData(oyuncu,"dbid")
				local x, y, z = getElementPosition(oyuncu)
				local bolge = getZoneName(x,y,z)
				local r = getRealTime()
				local zaman = ("%04d-%02d-%02d %02d:%02d:%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour,r.minute, r.second)
			for i,v in pairs(items) do
				if v[1] == 115 then
				if v[3] == tonumber(weaponid) then
					local datatable = split( v[2], ":" )
					local value = v[2]
					local kontrol = mysql:query_fetch_assoc( "SELECT * FROM `items` WHERE `index`=" .. mysql:escape_string(weaponid) )
				if kontrol then
				setElementData(oyuncu, "silahGom", true)
				triggerClientEvent ( oyuncu, "gsilah:geriSayim", oyuncu )
				outputChatBox("[!]#ffffff Silahını gömmeye başladın. (Gömülen Silah: "..datatable[3]..")", oyuncu, 0, 0, 255, true)
				toggleAllControls(oyuncu, false, true, false)
				setElementFrozen(oyuncu, true) 
				setPedAnimation(oyuncu,"bomber", "bom_plant_loop")
				setTimer(function() toprak[oyuncu] = createObject(3048, x, y+0.80, z-0.97,0,0,90 ) setObjectScale(toprak[oyuncu],0.1) setElementCollisionsEnabled(toprak[oyuncu], false) end, 2500,1)
				exports["item-system"]:takeItem(oyuncu, v[1], v[2])
				exports.mysql:query("INSERT INTO `gsilahlar` VALUES ('" .. dbid .. "', '" .. getPlayerName(oyuncu) .. "', '" .. x .. "', '" .. y .. "', '" .. z .. "', '" .. bolge .. "', '" .. zaman .. "', '" .. value .. "', '" .. weaponid .. "')")
				setTimer(function()
				toggleAllControls(oyuncu, true, true, true)
				setElementFrozen(oyuncu, false)
				exports.global:removeAnimation(oyuncu)	
				setElementData(oyuncu, "silahGom", false)
						outputChatBox("[!]#ffffff Silahını başarıyla gömdün. (Gömülen Silah: "..datatable[3]..")", oyuncu, 0, 0, 255, true)
						destroyElement(toprak[oyuncu])
					end, 30000,1)
					-- else
						-- outputChatBox("Böyle bir silah bulunamadı")
					end
				end
			end
		end
	end
end
addCommandHandler("silahgom", eneseps)

function alep(oyuncu,cmd, weaponid)

if not tonumber(weaponid) then
		outputChatBox("[!]#ffffffSilahı almak için", oyuncu, 255, 0, 0, true)
		outputChatBox("[!]#ffffff: /" .. cmd .. " [Silah ID]", oyuncu, 255, 0, 0, true)		
		return end
					if not exports.global:hasSpaceForItem(oyuncu, 115, 1) then	outputChatBox("[!] #ffffffSilahı çıkartmak için yeterli yerin yok.", oyuncu, 255, 0, 0, true) 	return end
		-- illegal birlik olayı burda başlıyor
local oyuncuBirlik = getPlayerTeam(oyuncu)
local birlikTip = getElementData(oyuncuBirlik, "type")
local birlikF = getElementData(oyuncu, "faction")
if (birlikTip) and (birlikTip == 0) or (birlikTip == 1) or  birlikF == -1  then
else
return end -- burda bitiyor
		if  getElementData(oyuncu, "silahGom") then return end	
		if (not getElementData(oyuncu, "silahCik")) then 
				local dbid = getElementData(oyuncu,"dbid")
				local x, y, z = getElementPosition(oyuncu)

					local kontrol = mysql:query_fetch_assoc( "SELECT * FROM `gsilahlar` WHERE `silahno`=" .. mysql:escape_string(weaponid) )
			if kontrol then
					local sahibi = kontrol["dbid"]
					local px = kontrol["x"]
					local py = kontrol["y"]
					local pz = kontrol["z"]
					print(sahibi)
					local value = kontrol["value"]
					local datatable = split( value, ":" )
						local dist = getDistanceBetweenPoints3D( x,y,z,px,py,pz )
					if dist > 7 then return end
			-- if kontrol then
				if tonumber(dbid) == tonumber(sahibi) then
				setElementData(oyuncu, "silahCik", true)
				triggerClientEvent ( oyuncu, "gsilah:geriSayim", oyuncu )
				outputChatBox("[!]#ffffff Silahını gömülü yerden çıkartıyorsun. (Çıkarılan Silah: "..datatable[3]..")", oyuncu, 0, 0, 255, true)
				toggleAllControls(oyuncu, false, true, false)
				setElementFrozen(oyuncu, true) 
				setPedAnimation(oyuncu,"bomber", "bom_plant_loop")
				exports["item-system"]:giveItem(oyuncu, 115, value)
				exports.mysql:query_free("DELETE FROM gsilahlar WHERE `silahno`=".. weaponid)
			setTimer(function()
				toggleAllControls(oyuncu, true, true, true)
				setElementFrozen(oyuncu, false)
				exports.global:removeAnimation(oyuncu)	
				setElementData(oyuncu, "silahCik", false)
						outputChatBox("[!] #ffffff Silahını başarıyla gömülü yerden çıkarttın. (Çıkarılan Silah: "..datatable[3]..")", oyuncu, 0, 0, 255, true)
				end, 30000,1)
					-- else
						-- outputChatBox("Sahibi değilsin")
					end
					-- else
					-- outputChatBox("Böyle bir silah bulunamadı")
				end
			end
		end
addCommandHandler("silahcikart", alep)


-- function menesm(oyuncu)
-- local x, y, z = getElementPosition(oyuncu)
-- toprak[oyuncu] = createObject(3048, x, y+0.80, z-0.97,0,0,90 ) 
-- setObjectScale(toprak[oyuncu],0.1)
-- setElementCollisionsEnabled(toprak[oyuncu], false)
-- end
-- addCommandHandler("menes",menesm)