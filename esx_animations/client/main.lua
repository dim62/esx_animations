local inAnim = false

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
		RemoveAnimDict(lib)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

function OpenAnimationsMenu()
    local CMenu = {
		id = 'Animations_menu',
		title = 'Animations'
	}
    local elements = {}

	for i=1, #Config.Animations, 1 do
		elements[Config.Animations[i].label] = {
			arrow = true,
			onSelect = function(args)
				local value = Config.Animations[i].name
				OpenAnimationsSubMenu(value)
			end,
		}
	end
	CMenu.options = elements
    lib.registerContext(CMenu)
    lib.showContext('Animations_menu')
end

function OpenAnimationsSubMenu(menu)
	local title    = nil
	local elements = {}
    local CMenu = {
		id = 'Animations2_menu',
		title = 'Animations'
	}
	for i=1, #Config.Animations, 1 do
		if Config.Animations[i].name == menu then
			title = Config.Animations[i].label
			for j=1, #Config.Animations[i].items, 1 do
				elements[Config.Animations[i].items[j].label] = {
					arrow = false,
					onSelect = function(type)
						local label = Config.Animations[i].items[j].label
						local type  = Config.Animations[i].items[j].type
						local value = Config.Animations[i].items[j].data
						--local type = type
						local lib  = value.lib
						local anim = value.anim
						if type == 'scenario' then
							startScenario(anim)
						elseif type == 'attitude' then
							startAttitude(lib, anim)
						elseif type == 'anim' then
							startAnim(lib, anim)
						end
					end,
				}
			end
			break
		end
	end
	CMenu.options = elements
    lib.registerContext(CMenu)
    lib.showContext('Animations2_menu')
end

-- Key Controls
RegisterCommand('animmenu', function()
	if not ESX.PlayerData.dead then
		OpenAnimationsMenu()
	end
end, false)

RegisterCommand('cleartasks', function()
	if not ESX.PlayerData.dead then
	ClearPedTasks(PlayerPedId())
	end
end, false)

RegisterKeyMapping('animmenu', 'Open Animations Menu', 'keyboard', 'f4')
RegisterKeyMapping('cleartasks', 'Stop Anmimation', 'keyboard', 'z')
