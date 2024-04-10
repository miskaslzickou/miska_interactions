
ESX = exports["es_extended"]:getSharedObject()
lib.locale()

function hasaSharpWeapon()
    for i =1,#Config.SharpWeapons  do
        local hashOfASharpWeapon = joaat(Config.SharpWeapons[i])
      
       
        if hashOfASharpWeapon == cache.weapon then

            return true 
        end
    end
end

exports.ox_target:addGlobalPlayer(
{
{
    icon = 'fa-solid fa-magnifying-glass',
    label = locale('search'),
    canInteract = function (entity)
       
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
        if Player(targetPlayerId).state.isHandCuffed == true or Player(targetPlayerId).state.isZiptied == true or IsPedDeadOrDying(entity) == 1 or IsEntityPlayingAnim(entity,Config.HandsUp.Dict,Config.HandsUp.Anim,3) then            
            return true
        else 
            return false
        end
        end,
    distance = 3,
    onSelect = function (data)
        if IsPedDeadOrDying(cache.ped,true) == false then
        if lib.progressBar({  
        duration = 4000,
        label = locale('searching'),
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true
        },
        anim = {
            dict = 'anim@gangops@morgue@table@',
            clip = 'player_search'
        },}) then
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
        exports.ox_inventory:openInventory('player',targetPlayerId)
        end
    end
    end
},
{
    icon = 'fa-solid fa-handcuffs',
    label = locale('cuff_with_zipties'),
    items = Config.Items.ziptiesItem,
    canInteract = function (entity)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
        
        if Player(targetPlayerId).state.isHandCuffed == true or Player(targetPlayerId).state.isZiptied == true then
            return false
        else
            return true
        end

    end,
    distance = 2,
    onSelect = function (data)
        if IsPedDeadOrDying(cache.ped,true) == false then
            exports.ox_target:disableTargeting(true)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
        lib.requestAnimDict('mp_arrest_paired',200)
       
        TriggerServerEvent('miska_interactions:ziptie_detainee:detain',targetPlayerId)
        Wait(300)
        TaskPlayAnim(cache.ped,'mp_arrest_paired','cop_p2_back_right',8.0, -8, 4000, 0, 0, false, false, false )
        RemoveAnimDict('mp_arrest_paired')
        Wait(3000)
        exports.ox_target:disableTargeting(false)
        end
    end
},
{
    icon = 'fa-solid fa-scissors',
    label = locale('cut_zipties'),
    distance = 2,
    canInteract = function (entity)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
        if Player(targetPlayerId).state.isZiptied == true then
            return true
        else
            return false
        end
    end,
    onSelect = function (data)
        if IsPedDeadOrDying(cache.ped,true) == false then
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)) 
        exports.ox_target:disableTargeting(true)
        if hasaSharpWeapon() == true then
           
            if LocalPlayer.state.Dragging == targetPlayerId then
                TriggerServerEvent('miska_interactions:stop_carry',targetPlayerId)
                LocalPlayer.state.Dragging = nil
            end
            lib.requestAnimDict('mp_arresting')
            TaskPlayAnim(cache.ped,'mp_arresting','a_uncuff',8.0,-8,3000,0,0.0,false,false,false)
            TriggerServerEvent('miska_interactions:ziptie_free',targetPlayerId)
            Wait(3000)
            RemoveAnimDict('mp_arresting')
            exports.ox_target:disableTargeting(false)
        else
            lib.notify({
                id = 'cannot_cut_zipties',
                title =locale('cant_cut_zipties'),
                description = locale('you_arent_holding_anything_sharp'),
                postion = 'top-right',
                type = 'error'
                
            
            })
        end
    end
    end
       
},
{
    icon = 'fa-solid fa-handcuffs',
    label = locale('cuff_with_handcuffs'),
    items = Config.Items.handcuffsItem,
    canInteract = function (entity)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
        
        if Player(targetPlayerId).state.isZiptied == true or Player(targetPlayerId).state.isHandCuffed == true then
            return false
        else
            return true
        end

    end,
    distance = 2,
    onSelect = function (data)
        if IsPedDeadOrDying(cache.ped,true) == false then
            exports.ox_target:disableTargeting(true)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
        lib.requestAnimDict('mp_arrest_paired',200)
       
        TriggerServerEvent('miska_interactions:handcuff_detainee:detain',targetPlayerId)
        Wait(300)
        TaskPlayAnim(cache.ped,'mp_arrest_paired','cop_p2_back_right',8.0, -8, 4000, 0, 0, false, false, false )
        RemoveAnimDict('mp_arrest_paired')
        if Player(targetPlayerId).state.hasBagOnHead  == true then
            TriggerEvent('miska_interactions:put_bag_off',targetPlayerId)
        end
        Wait(3000)
        exports.ox_target:disableTargeting(false)
        end
    end
},
{
    icon = 'fa-solid fa-key',
    label = locale('unlock_handcuffs'),
    distance = 2,
    items = Config.Items.handcuffkeysItem,
    canInteract = function (entity)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
        if Player(targetPlayerId).state.isHandCuffed == true then
            return true
        else
            return false
        end
    end,
    onSelect = function (data)
          if IsPedDeadOrDying(cache.ped,true) == false then
            exports.ox_target:disableTargeting(true)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)) 
            if LocalPlayer.state.Dragging == targetPlayerId then
                TriggerServerEvent('miska_interactions:stop_carry',targetPlayerId)
                LocalPlayer.state.Dragging = nil
            end
        
            lib.requestAnimDict('mp_arresting')
           
            TriggerServerEvent('miska_interactions:handcuff_free',targetPlayerId)
            Wait(200)
            TaskPlayAnim(cache.ped,'mp_arresting','a_uncuff',8.0,-8,3000,0,0.0,false,false,false)
            if Player(targetPlayerId).state.hasBagOnHead  == true then
                TriggerEvent('miska_interactions:put_bag_off',targetPlayerId)
            end
            Wait(3000)
            RemoveAnimDict('mp_arresting')
            exports.ox_target:disableTargeting(false)
        end
    end

},
{
    icon = 'fa-solid fa-people-pulling',
    label = locale('take_person'),
    distance = 2,
    canInteract = function (entity)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
        if  LocalPlayer.state.Dragging ==  nil and Player(targetPlayerId).state.isBeingDragged == nil  and Player(targetPlayerId).state.isHandCuffed == true or Player(targetPlayerId).state.isZiptied == true or IsPedDeadOrDying(cache.ped)==1 then
            return true
      
           
        elseif LocalPlayer.state.Dragging ~= nil then
            return false
        end
    end,
    onSelect = function (data)
  
        if IsPedDeadOrDying(cache.ped,true) == false then
      
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)) 
        LocalPlayer.state.Dragging = targetPlayerId
        TriggerServerEvent('miska_interactions:dragging',targetPlayerId,PedToNet(PlayerPedId()))
        end
    end

},
{
    icon = 'fa-solid fa-people-pulling',
    label = locale('stop_dragging'),
    distance = 2,
    canInteract = function (entity)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
        if LocalPlayer.state.Dragging == targetPlayerId and Player(targetPlayerId).state.isBeingDragged == true   then
            return true
        else
            return false
        end
    end,
    onSelect = function (data)
        if IsPedDeadOrDying(cache.ped,true) == false then
        
        LocalPlayer.state.Dragging = nil
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)) 
        TriggerServerEvent('miska_interactions:stop_dragging',targetPlayerId)
        end
    end

},
{
    icon = 'fa-solid fa-people-pulling',
    label =locale('put_into_car'),
    distance = 2,
    canInteract = function (entity)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
        if Player(targetPlayerId).state.isZiptied == true or Player(targetPlayerId).state.isHandCuffed == true then
            return true
        else
            return false
        end
    end,
    onSelect = function (data)
        if IsPedDeadOrDying(cache.ped,true) == false then
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
     if LocalPlayer.state.Dragging == targetPlayerId  or Player(targetPlayerId).state.isBeingDragged == nil and LocalPlayer.state.Dragging == nil  then
        if targetPlayerId == LocalPlayer.state.Dragging then
            TriggerServerEvent('miska_interactions:stop_carry',targetPlayerId)
            LocalPlayer.state.Dragging = nil
        end
        local vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped), 7.0, true)
      
        if vehicle then
        TriggerServerEvent('miska_interactions:put_into_car',targetPlayerId,VehToNet(vehicle)) 
        end
    end
    end
    end
},
{
    icon = 'fa-solid fa-sack-xmark',
    label = locale('put_bag_on_head'),
    items = Config.Items.bagItem,
    canInteract =  function (entity)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
        if (Player(targetPlayerId).state.isZiptied == true or Player(targetPlayerId).state.isHandCuffed ==true or IsPedDeadOrDying(entity,true) ) and Player(targetPlayerId).state.hasBagOnHead == nil then
            return true
        else
            return false
        end
    end,
    onSelect = function (data)
        if IsPedDeadOrDying(cache.ped,true) == false then
            if lib.progressBar({
                duration = 4000,
                label = locale('putting_bag_on_head'),
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true
                },
               

            }) then
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            
            TriggerServerEvent('miska_interactions:put_bag_on',targetPlayerId)
            end
        end
    end
},
{
    icon='fa-solid fa-hand',
    label = locale('take_bag_off'),
    canInteract = function (entity)
        local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
        if Player(targetPlayerId).state.hasBagOnHead == true then
            return true
        else
            return false
        end
    end,
    onSelect = function (data)
            if IsPedDeadOrDying(cache.ped,true) == false then
                if lib.progressBar({
                    duration = 4000,
                    label = locale('take_bag_off'),
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true
                    },
                

                }) then
            local targetPlayerId= GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))

            TriggerServerEvent('miska_interactions:put_bag_off',targetPlayerId)
                end
            end        
        end
}
}
)

exports.ox_target:addGlobalVehicle({
    {
        icon = 'fa-solid fa-car',
        label = locale('take_out_of_car'),
        distance = 2,
        onSelect = function (data)
            if IsPedDeadOrDying(cache.ped,true) == false then
            for i = 0, 6 do
                local ped = GetPedInVehicleSeat(data.entity,i) 
                local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
                if ped == nil then return end
                if Player(targetPlayerId).state.isHandCuffed == true or Player(targetPlayerId).state.isZiptied == true or IsPedDeadOrDying(ped,true) then
                    TriggerServerEvent('miska_interactions:leave_car',targetPlayerId)
                end               
            end
        end
        end
    },
    {   
        icon ='fa-solid fa-car',
        label = locale('tow_car_away'),
        distance =2,
        onSelect = function (data)
        if lib.progressBar({
            duration = 5000,
            label=locale('towing_car_away'),
            useWhileDead = false,
            canCancel= true,
            disable = {
                car = true,
                move = true
            },
            anim ={scenario = 'WORLD_HUMAN_MOBILE_FILM_SHOCKING'}
        })then
            if IsPedDeadOrDying(cache.ped,true) == false then
            ESX.Game.DeleteVehicle(data.entity)
            end
        end
        end
    },
    -- {
    --     icon ='fa-solid fa-truck-ramp-box',
    --     label = locale('take_out_of_trunk'),
    --     distance = 1,
    --     canInteract = function(entity)
        
    --     end,
    --     onSelect = function(data)
        
    --     end,

    -- }
})

RegisterNetEvent('miska_interactions:ziptie_detainee:detaincli',function ()
    LocalPlayer.state.canUseWeapons = false
    LocalPlayer.state.invBusy = true
    exports.ox_target:disableTargeting(true)
    lib.requestAnimDict('mp_arrest_paired',100)
    TaskPlayAnim(cache.ped,'mp_arrest_paired','crook_p2_back_right',8.0,-8,4000,0,0.0,false,false,false)
    Wait(4000)
 
    while LocalPlayer.state.isZiptied == true do
        Wait(0)

			
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 37, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 288,  true)
			DisableControlAction(0, 289, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 167, true)
			DisableControlAction(0, 0, true)
			DisableControlAction(0, 26, true)
			DisableControlAction(0, 73, true)
			DisableControlAction(2, 199, true)
			DisableControlAction(0, 59, true)
			DisableControlAction(0, 71, true)
			DisableControlAction(0, 72, true)
			DisableControlAction(2, 36, true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(27, 75, true)
        if IsPedSwimming(cache.ped) then
                SetPedToRagdoll(cache.ped, 1000, 1000, 0, false, false, false)
        end
      
        if LocalPlayer.state.canUseWeapons ==  true then
        LocalPlayer.state.canUseWeapons = false
        end
        if LocalPlayer.state.invBusy == false then
            LocalPlayer.state.invBusy = true 
        end
        if IsEntityPlayingAnim(cache.ped, 'mp_arresting', 'idle', 3) ~= 1 then
                lib.requestAnimDict('mp_arresting')
                TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                RemoveAnimDict('mp_arresting')
        end
    end
    LocalPlayer.state.canUseWeapons = true
    LocalPlayer.state.invBusy = false
    lib.requestAnimDict('mp_arresting')
    TaskPlayAnim(cache.ped,'mp_arresting','b_uncuff',8.0,-8,3000,0,0.0,false,false,false)
    Wait(3000)
    RemoveAnimDict('mp_arresting')
    ClearPedTasks(cache.ped)
    exports.ox_target:disableTargeting(false)
   
end)


RegisterNetEvent('miska_interactions:handcuff_detainee:detaincli',function ()
    LocalPlayer.state.canUseWeapons = false
    LocalPlayer.state.invBusy = true
    exports.ox_target:disableTargeting(true)
    lib.requestAnimDict('mp_arrest_paired',100)
    TaskPlayAnim(cache.ped,'mp_arrest_paired','crook_p2_back_right',8.0,-8,4000,0,0.0,false,false,false)
    Wait(4000)
    local cuffModel = 'ba_prop_battle_cuffs'
    lib.requestModel(cuffModel)
    local cuffEntity =CreateObject(joaat(cuffModel),0,0,0,true,true,false)
    AttachEntityToEntity(cuffEntity, PlayerPedId(),42, 0.024147452582042, 0.060595231810598, 0.036692805193156, 10.09303755519, -65.134356240468, -116.79441831032, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(cuffModel)
    while LocalPlayer.state.isHandCuffed == true do
        Wait(0)

			
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 37, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 288,  true)
			DisableControlAction(0, 289, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 167, true)
			DisableControlAction(0, 0, true)
			DisableControlAction(0, 26, true)
			DisableControlAction(0, 73, true)
			DisableControlAction(2, 199, true)
			DisableControlAction(0, 59, true)
			DisableControlAction(0, 71, true)
			DisableControlAction(0, 72, true)
			DisableControlAction(2, 36, true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(27, 75, true)
       
        if LocalPlayer.state.canUseWeapons ==  true then
        LocalPlayer.state.canUseWeapons = false
        end
        if LocalPlayer.state.invBusy == false then
            LocalPlayer.state.invBusy = true 
        end
        if IsEntityPlayingAnim(cache.ped, 'mp_arresting', 'idle', 3) ~= 1 then
                lib.requestAnimDict('mp_arresting')
                TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                RemoveAnimDict('mp_arresting')
        end
    end
    LocalPlayer.state.canUseWeapons = true
    LocalPlayer.state.invBusy = false
    lib.requestAnimDict('mp_arresting')
    TaskPlayAnim(cache.ped,'mp_arresting','b_uncuff',8.0,-8,3000,0,0.0,false,false,false)
    Wait(3000)
    RemoveAnimDict('mp_arresting')
    
  
    ESX.Game.DeleteObject(cuffEntity)
    ClearPedTasks(cache.ped)
    exports.ox_target:disableTargeting(false)
end)
RegisterNetEvent('miska_interactions:drag',function (dragger)
    local dragger = NetToPed(dragger)
      AttachEntityToEntity(cache.ped,dragger,11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, true, true, 2, true)
end)
RegisterNetEvent('miska_interactions:stop_dragging',function ()

DetachEntity(cache.ped,true,true)
end)

RegisterNetEvent('miska_interactions:put_into_carcl',function (vehicle)
    local vehicle = NetToVeh(vehicle)
    local numberOfSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    if numberOfSeats == 1 then
        if IsVehicleSeatFree(vehicle,0) then
            seatIndex =0 
        end
    elseif numberOfSeats ==3 then
        if IsVehicleSeatFree(vehicle,1) then
            seatIndex = 1
        elseif IsVehicleSeatFree(vehicle,2) then
            seatIndex = 2
        end
    elseif numberOfSeats > 3 then
        if IsVehicleSeatFree(vehicle,1) then
            seatIndex = 1
        elseif IsVehicleSeatFree(vehicle,2) then
            seatIndex = 2
        elseif IsVehicleSeatFree(vehicle,3) then
            seatIndex = 3
        elseif IsVehicleSeatFree(vehicle,4) then
            seatIndex = 4
        end

    end

    TaskWarpPedIntoVehicle(cache.ped,vehicle,seatIndex)
end)
RegisterNetEvent('miska_interactions:leave_carcl',function ()
    TaskLeaveAnyVehicle(
	cache.ped --[[ Ped ]], 
	1 --[[ integer ]], 
	0 --[[ integer ]]
)
end)
RegisterNetEvent('miska_interactions:put_bag_oncl',function ()
    local bagModel ='p_cs_sack_01_s'
    lib.requestModel(bagModel)
     bagEntity =CreateObject(joaat(bagModel),0,0,0,true,true,true)
    AttachEntityToEntity(bagEntity,cache.ped,98, 0.010123577358968, 0.01631026373313, 0, 1.8958819353146e-13, -88.077237140812, -95.833136409703, true, true, false, true, 1, true)
    SendNUIMessage({
        type ='bag',
        bagStatus = true
        })
    SetModelAsNoLongerNeeded(bagModel)
   
   
end)
RegisterNetEvent('miska_interactions:put_bag_offcl',function ()
    SendNUIMessage({
        type = 'bag',
        bagStatus = false

    })
    
    ESX.Game.DeleteObject(bagEntity)
end)
