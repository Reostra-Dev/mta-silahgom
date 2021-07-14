
local screenW, screenH = guiGetScreenSize()
silahPanel = guiCreateWindow((screenW - 508) / 2, (screenH - 267) / 2, 508, 267, "Alkan Roleplay Gömülen Silahlar - ©Lauren", false)
guiWindowSetSizable(silahPanel, false)
guiSetVisible(silahPanel, false)

GridList = guiCreateGridList(9, 19, 489, 210, false, silahPanel)
silahid = guiGridListAddColumn(GridList, "ID", 0.15)
tarih = guiGridListAddColumn(GridList, "Tarih", 0.3)
marka = guiGridListAddColumn(GridList, "Marka", 0.2)
bolge = guiGridListAddColumn(GridList, "Bölge", 0.3)
kapatBtn = guiCreateButton(427, 233, 71, 24, "Kapat", false, silahPanel)



addCommandHandler("gsilahlar", function()
		-- if exports.integration:isPlayerScripter(localPlayer) then
-- illegal birlik olayı burda başlıyor
local oyuncuBirlik = getPlayerTeam(localPlayer)
local birlikTip = getElementData(oyuncuBirlik, "type")
local birlikF = getElementData(localPlayer, "faction")
if (birlikTip) and (birlikTip == 0) or (birlikTip == 1) or  birlikF == -1  then
else
return end -- burda bitiyor
	guiSetVisible(silahPanel, not guiGetVisible(silahPanel))
	showCursor(guiGetVisible(silahPanel))
	if guiGetVisible(silahPanel) then
		guiSetInputMode("no_binds_when_editing")
		local dbid = getElementData(localPlayer,"dbid")
		triggerServerEvent("gsilahlar:silahGonderS", localPlayer,dbid)
	end	
	
end	)
	
addEventHandler("onClientGUIClick", guiRoot, function ()
	if source == kapatBtn then
		guiSetVisible(silahPanel,false)
		showCursor(false)
	end
end)
	
	
	
addEvent("gsilahlar:silahGonderC", true)
addEventHandler("gsilahlar:silahGonderC", root, function(silahLar)
	guiGridListClear(GridList)
	for a,b in pairs(silahLar) do
		local row = guiGridListAddRow(GridList)
		guiGridListSetItemText(GridList, row, silahid, b.id, false, false)
		guiGridListSetItemText(GridList, row, tarih, b.tarih, false, false)
		guiGridListSetItemText(GridList, row, marka, b.marka, false, false)
		guiGridListSetItemText(GridList, row, bolge, b.bolge, false, false)
		end
end)	

----------------------------------------
local baslangic = nil
addEvent( "gsilah:geriSayim", true )
function startProgress()
	baslangic = getTickCount()
	saniye = 30
	addEventHandler("onClientRender",root,render)

end
addEventHandler( "gsilah:geriSayim", localPlayer, startProgress )

function render()
	local suan = getTickCount()
	if suan - baslangic >= 1000 then
		baslangic = getTickCount()
		saniye = saniye -1
		if saniye < 1 then
			removeEventHandler("onClientRender",root,render)
		end
	end
	dxDrawText(convertTime(saniye),3,2,screenH,screenW, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "center", false, false, true, false, false)
	dxDrawText(convertTime(saniye),0,2,screenH,screenW, tocolor(255, 255, 255, 255), 2.00, "pricedown", "center", "center", false, false, true, false, false)
end



--util
function convertTime ( time ) 
  local min = math.floor ( time / 60 ) 
  local sec = ( time %60 )
  return string.format("%02d:%02d", min, sec) 
end 