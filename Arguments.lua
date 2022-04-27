script_name('Arguments')
script_author('Cosmo')

require "moonloader"
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(80) end
    local font = renderCreateFont('Arial', 8, 5) -- Что бы изменить размер шрифта, поменяйте цифру 8 на другую
    while true do
    	if sampIsChatInputActive() then 
    		local s = sampGetChatInputText():match('^/.+%($')
    		if s then sampSetChatInputText(s..")"); sampSetChatInputCursor(s:len()) end
    	end

    	local args = sampGetChatInputText():match('^/.+%([%d%s]+%)')
    	if args and sampIsChatInputActive() then
			local strEl = getStructElement(sampGetInputInfoPtr(), 0x8, 4)
			local X = getStructElement(strEl, 0x8, 4) + 5
			local Y = getStructElement(strEl, 0xC, 4) + 50
			for a in args:gmatch('%d+') do
	        	local rstr = sampGetChatInputText():gsub('%([%d%s]+%)', '{FFD000}'..a..'{008000}')
	            renderFontDrawText(font, rstr, X, Y, 0xFF008000)
	            renderFontDrawText(font, (sampIsPlayerConnected(a) and ' -> '..sampGetPlayerNickname(a) or '{FF5050} -> Не существует!'), X + renderGetFontDrawTextLength(font, rstr), Y, 0x80AFAFAF)
	            Y = Y + 13
	        end
	    end
    wait(0)
    end
end

local se = require 'lib.samp.events'
function se.onSendCommand(cmd)
	local args = cmd:match('^/.+%([%d%s]+%)')
	if args then
		for a in args:gmatch('%d+') do
			sampSendChat( cmd:gsub('%([%d%s]+%)', a, 1) )
		end
		return false
	end
end

function sampSetChatInputCursor(start, finish)
    local finish = finish or start
    local start, finish = tonumber(start), tonumber(finish)
    local mem = require 'memory'
    local chatInfoPtr = sampGetInputInfoPtr()
    local chatBoxInfo = getStructElement(chatInfoPtr, 0x8, 4)
    mem.setint8(chatBoxInfo + 0x11E, start)
    mem.setint8(chatBoxInfo + 0x119, finish)
    return true
end