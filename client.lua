lib.locale()

function hasASharpWeapon()
    for i =1,#Config.SharpWeapons  do
        local hashOfASharpWeapon = joaat(Config.SharpWeapons[i])
      
       
        if hashOfASharpWeapon == cache.weapon then

            return true 
        end
    end
end
function IsVehicleEmpty(vehicle)
    local numberOfSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    for i = 0, numberOfSeats -1 do
        if IsVehicleSeatFree(vehicle,i) == false then
            return false
        end

    end
    return true
end

local peopleOptions = {
    {
        icon = 'fa-solid fa-magnifying-glass',
        label = locale('search'),
        canInteract = function (entity)
           
            local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
            if Player(targetPlayerId).state.isHandCuffed == true or Player(targetPlayerId).state.isZiptied == true or IsPedDeadOrDying(entity,true) == true or IsEntityPlayingAnim(entity,Config.HandsUp.Dict,Config.HandsUp.Anim,3) then            
                return true
            else 
                return false
            end
            end,
        distance = 1,
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
        distance = 1,
        onSelect = function (data)
         if IsPedDeadOrDying(cache.ped,true) == false then
                exports.ox_target:disableTargeting(true)
            local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            lib.requestAnimDict('mp_arrest_paired',200)
         
            TriggerServerEvent('miska_interactions:ziptie_detainee:detain',targetPlayerId)
            local offset = GetOffsetFromEntityInWorldCoords(data.entity,0,-0.9,0)
            local heading = GetEntityHeading(data.entity)
            SetEntityHeading(cache.ped,heading)
            
            SetEntityCoords(cache.ped,offset.x,offset.y,offset.z-1.0,true,false,false,false)
            Wait(450)
            TaskPlayAnim(cache.ped,'mp_arrest_paired','cop_p2_back_right',8.0, -8, 4000, 0, 0, false, false, false )
          
            Wait(3000)
            RemoveAnimDict('mp_arrest_paired')
            exports.ox_target:disableTargeting(false)
            end
        end
    },
    {
        icon = 'fa-solid fa-scissors',
        label = locale('cut_zipties'),
        distance = 1,
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
           
            if hasASharpWeapon() == true then
                exports.ox_target:disableTargeting(true)
                if LocalPlayer.state.Dragging == targetPlayerId then
                    TriggerServerEvent('miska_interactions:stop_dragging',targetPlayerId)
                    LocalPlayer.state.Dragging = nil
                end

                if Player(targetPlayerId).state.hasBagOnHead  == true then
                    TriggerServerEvent('miska_interactions:put_bag_off',targetPlayerId)
                end
                local offset = GetOffsetFromEntityInWorldCoords(data.entity,0,-1.0,0)
                local heading = GetEntityHeading(data.entity)
                SetEntityHeading(cache.ped,heading)
                
                SetEntityCoords(cache.ped,offset.x,offset.y,offset.z-1.0,true,false,false,false)
                Wait(200)
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
        distance = 1,
        onSelect = function (data)
            if IsPedDeadOrDying(cache.ped,true) == false then
                exports.ox_target:disableTargeting(true)
            local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            lib.requestAnimDict('mp_arrest_paired',200)
           
            TriggerServerEvent('miska_interactions:handcuff_detainee:detain',targetPlayerId)
            local offset = GetOffsetFromEntityInWorldCoords(data.entity,0,-0.9,0)
            local heading = GetEntityHeading(data.entity)
            SetEntityHeading(cache.ped,heading)
            SetEntityCoords(cache.ped,offset.x,offset.y,offset.z-1.0,true,false,false,false)
            Wait(500)
            TaskPlayAnim(cache.ped,'mp_arrest_paired','cop_p2_back_right',8.0, -8, 4000, 0, 0, false, false, false )
            RemoveAnimDict('mp_arrest_paired')
         
            Wait(3000)
            exports.ox_target:disableTargeting(false)
            end
        end
    },
    {
        icon = 'fa-solid fa-key',
        label = locale('unlock_handcuffs'),
        distance = 1,
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
                    TriggerServerEvent('miska_interactions:stop_dragging',targetPlayerId)
                    LocalPlayer.state.Dragging = nil
                end
                if Player(targetPlayerId).state.hasBagOnHead  == true then
                   
                    TriggerServerEvent('miska_interactions:put_bag_off',targetPlayerId)
                end
                lib.requestAnimDict('mp_arresting')
               
                TriggerServerEvent('miska_interactions:handcuff_free',targetPlayerId)
                local offset = GetOffsetFromEntityInWorldCoords(data.entity,0,-1.0,0)
                local heading = GetEntityHeading(data.entity)
                SetEntityHeading(cache.ped,heading)
                SetEntityCoords(cache.ped,offset.x,offset.y,offset.z-1.0,true,false,false,false)
                Wait(200)
                TaskPlayAnim(cache.ped,'mp_arresting','a_uncuff',8.0,-8,3000,0,0.0,false,false,false)
              
                
                Wait(3000)
                RemoveAnimDict('mp_arresting')
                exports.ox_target:disableTargeting(false)
            end
        end
    
    },
    {
        icon = 'fa-solid fa-people-pulling',
        label = locale('take_person'),
        distance = 1,
        canInteract = function (entity)
            local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
            if ( LocalPlayer.state.Dragging ==  nil and Player(targetPlayerId).state.isBeingDragged == nil ) and( Player(targetPlayerId).state.isHandCuffed == true or Player(targetPlayerId).state.isZiptied == true or IsPedDeadOrDying(cache.ped)==1)  and(Player(targetPlayerId).state.isBeingCarried == nil and LocalPlayer.state.isCarrying == nil)then
                return true
          
               
            elseif LocalPlayer.state.Dragging ~= nil then
                return false
            end
        end,
        onSelect = function (data)
      
            if IsPedDeadOrDying(cache.ped,true) == false then
          
            local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)) 
           
            TriggerServerEvent('miska_interactions:dragging',targetPlayerId,PedToNet(PlayerPedId()))
            end
        end
    
    },
    {
        icon = 'fa-solid fa-people-pulling',
        label = locale('stop_dragging'),
        distance = 1,
        canInteract = function (entity)
            local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
            if LocalPlayer.state.Dragging == targetPlayerId and Player(targetPlayerId).state.isBeingDragged == true   then
                return true
            else
                return false
            end
        end,
        onSelect = function (data)
            if IsPedDeadOrDying(cache.ped, true) == false then
                local targetPlayerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)) 
                TriggerServerEvent('miska_interactions:dragging', targetPlayerId, PedToNet(PlayerPedId()))
                
                lib.showTextUI('[E] - '..locale('stop_drag'))

                while true do
                    Wait(0)
                    
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent('miska_interactions:stop_dragging', targetPlayerId)
                        lib.hideTextUI()
                        break
                    end
                end
            end
        end
    
    },
    {
        icon = 'fa-solid fa-people-pulling',
        label =locale('put_into_car'),
        distance = 1,
        canInteract = function (entity)
            local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) 
            if Player(targetPlayerId).state.isZiptied == true or Player(targetPlayerId).state.isHandCuffed == true and lib.getClosestVehicle(GetEntityCoords(cache.ped),3.0) ~= nil  then
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
                TriggerServerEvent('miska_interactions:stop_dragging',targetPlayerId)
                LocalPlayer.state.Dragging = nil
            end
            local vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped), 3.0, true)
          
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
        distance =1,
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
        distance = 1,
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
    },
    {
        icon='fa-solid fa-person-praying',
        label = locale('put_into_trunk'),
        distance = 1,
        canInteract = function (entity)
            local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
            if (Player(targetPlayerId).state.isHandCuffed == true or Player(targetPlayerId).state.isZiptied == true ) and lib.getClosestVehicle(GetEntityCoords(cache.ped),4.0) ~= nil then
                return true
          
            else 
                return false
            end
        end,
        onSelect =  function (data)
            local vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped),4)
            if vehicle and Entity(vehicle).state.PlayerInTrunk == nil then
                
                local boneIndex =GetEntityBoneIndexByName(vehicle,'boot')
                if boneIndex == -1 then
                    lib.notify( {id = 'cant_put_into_trunk',
                    title =locale('cant_put_into_trunk'),
                    description = locale('no_vehicle_with_trunk'),
                    postion = 'top-right',
                    type = 'error'})
                    return
                end
                local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                if LocalPlayer.state.Dragging == targetPlayerId then
                    TriggerServerEvent('miska_interactions:stop_dragging',targetPlayerId)
                    LocalPlayer.state.Dragging = nil
                end
                TriggerServerEvent('miska_interactions:put_into_trunk',targetPlayerId,NetworkGetNetworkIdFromEntity(vehicle))
    
            end
        end,
    },

    }
    if Config.CarryEnabled == true then
        table.insert(peopleOptions,{
            icon = 'fa-solid fa-hands-holding',
            label = locale('carry_person'),
            distance = 1,
            canInteract = function (entity)
                local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                if Player(targetPlayerId).state.isBeingCarried ~= true and LocalPlayer.state.isCarrying == nil and LocalPlayer.state.Dragging == nil and Player(targetPlayerId).state.isBeingDragged == nil then
                     return true
              
                else
                    return false
                end
                
            end,
            onSelect = function (data)
                local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                
                TriggerServerEvent('miska_interactions:carry',targetPlayerId,NetworkGetNetworkIdFromEntity(cache.ped))
            end
        })
    end
exports.ox_target:addGlobalPlayer(peopleOptions)
local vehicleOptions = {
    {
        icon = 'fa-solid fa-car',
        label = locale('take_out_of_car'),
        distance = 1,
        canInteract = function (entity)
            return  not IsVehicleEmpty(entity)
        end,
        onSelect = function (data)
            if IsPedDeadOrDying(cache.ped,true) == false then
                local numberOfSeats =GetVehicleMaxNumberOfPassengers( data.entity )
            for i = 0, numberOfSeats - 1  do
               
                if IsVehicleSeatFree(data.entity,i) == false then
                local ped = GetPedInVehicleSeat(data.entity,i) 
                if IsPedAPlayer(ped) == 1 then
                local targetPlayerId =GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
                if Player(targetPlayerId).state.isHandCuffed == true or Player(targetPlayerId).state.isZiptied == true  then 
                        TriggerServerEvent('miska_interactions:leave_car',targetPlayerId)
                end
            end
            end
            end
        end
        end
    },
    
    {
        icon ='fa-solid fa-truck-ramp-box',
        label = locale('take_out_of_trunk'),
        distance = 1,
        offset = vec3(0.5, 0, 0.5),
        canInteract = function(entity)
         if Entity(entity).state.PlayerInTrunk ~= nil then
             return true
         else 
             return false
         end
        end,
        onSelect = function(data) 
            if IsPedDeadOrDying(cache.ped,true) == false then
        
                TriggerServerEvent('miska_interactions:take_out_of_trunk',Entity(data.entity).state.PlayerInTrunk,NetworkGetNetworkIdFromEntity(data.entity))
            end
        end,

    },
  
}
if Config.TowingEnabled == true then
 
  
    table.insert(vehicleOptions,{   
        icon ='fa-solid fa-car',
        label = locale('tow_car_away'),
        distance =1,
        groups =Config.TowingGroups,
        onSelect = function (data)
            
        if lib.progressBar({
            duration = 5000,
            label=locale('towing_car_away'),
            useWhileDead = false,
            canCancel= true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim ={scenario = 'WORLD_HUMAN_MOBILE_FILM_SHOCKING'}
        })then
          
            if IsPedDeadOrDying(cache.ped,true) == false then
            TriggerServerEvent('miska_interactions:delete_entity',NetworkGetNetworkIdFromEntity(data.entity))
            end
        end
      
        end
    })
end

exports.ox_target:addGlobalVehicle(vehicleOptions)

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
      
       
        if LocalPlayer.state.invBusy == false then
            LocalPlayer.state.invBusy = true 
        end
        
        if IsEntityPlayingAnim(cache.ped, 'mp_arresting', 'idle', 3) ~= 1  and LocalPlayer.state.isBeingCarried ==nil and LocalPlayer.state.InTrunk == nil  then
         
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


RegisterNetEvent('miska_interactions:handcuff_detainee:detaincli',function (cuffEntityNetId)

    Wait(200)
    local cuffEntity = NetworkGetEntityFromNetworkId(cuffEntityNetId)  
    NetworkRequestControlOfEntity(cuffEntity)
    LocalPlayer.state.canUseWeapons = false
    LocalPlayer.state.invBusy = true
    local cuffEntityNetId = cuffEntityNetId
    exports.ox_target:disableTargeting(true)
    lib.requestAnimDict('mp_arrest_paired',100)
    
    TaskPlayAnim(cache.ped,'mp_arrest_paired','crook_p2_back_right',8.0,-8,4000,0,0.0,false,false,false)
    Wait(4000)
    
   
    AttachEntityToEntity(cuffEntity, cache.ped,42, 0.024147452582042, 0.060595231810598, 0.036692805193156, 10.09303755519, -65.134356240468, -116.79441831032, true, true, false, true, 1, true)
   
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
       if IsPedSwimming(cache.ped) then
                SetPedToRagdoll(cache.ped, 1000, 1000, 0, false, false, false)
        end
       
        if LocalPlayer.state.invBusy == false then
            LocalPlayer.state.invBusy = true 
        end
        if  IsEntityPlayingAnim(cache.ped, 'mp_arresting', 'idle', 3) ~= 1 and  LocalPlayer.state.isBeingCarried ==nil  and LocalPlayer.state.InTrunk == nil   then
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
    
  
   TriggerServerEvent('miska_interactions:delete_entity',cuffEntityNetId)
    ClearPedTasks(cache.ped)
    exports.ox_target:disableTargeting(false)
end)
RegisterNetEvent('miska_interactions:drag',function (dragger)
    local dragger = NetToPed(dragger)
      AttachEntityToEntity(cache.ped,dragger,11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, true, 2, true)
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
RegisterNetEvent('miska_interactions:put_bag_oncl',function (bagNetworkId)
    Wait(400)
    local bagEntity = NetworkGetEntityFromNetworkId(bagNetworkId)
    NetworkRequestControlOfEntity(bagEntity)
  
    bagNetworkID = bagNetworkId
   
  

    Wait(200)  
    AttachEntityToEntity(bagEntity,cache.ped,98, 0.010123577358968, 0.01631026373313, 0, 1.8958819353146e-13, -88.077237140812, -95.833136409703, true, true, false, true, 1, true)
    SendNUIMessage({
        type ='bag',
        bagStatus = true
        })
 
   
   
end)
RegisterNetEvent('miska_interactions:put_bag_offcl',function ()
    SendNUIMessage({
        type = 'bag',
        bagStatus = false

    })
    
    TriggerServerEvent('miska_interactions:delete_entity',bagNetworkID)
end)
RegisterNetEvent('miska_interactions:put_into_trunkcl',function (vehicle)
    local vehicle =  NetworkGetEntityFromNetworkId(vehicle)
   
    local boneIndex =GetEntityBoneIndexByName(vehicle,'boot')
   
    
    local zcoord = GetWorldPositionOfEntityBone(vehicle,boneIndex) - GetEntityCoords(vehicle)
    local zcoord = (math.abs(zcoord.z) * -1 )-0.13
    AttachEntityToEntity(cache.ped,vehicle,boneIndex,0,0,zcoord,0,0,0,true,true,true,true,1,false)
  
    SetVehicleDoorOpen(vehicle,5,true,true )
    SetEntityCollision(cache.ped,false,true)
    
    lib.requestAnimDict('fin_ext_p1-5')
    ClearPedTasks(cache.ped)
    TaskPlayAnim(cache.ped,'fin_ext_p1-5','cs_devin_dual-5',8.0,8.0,-1,1,0,false,false,false)    
    Wait(3000)
    SetVehicleDoorShut(vehicle,5,true)

    while LocalPlayer.state.InTrunk ~= nil do
        Wait(1000)
     
        if DoesEntityExist(vehicle) ~= 1  then

            TriggerServerEvent('miska_interactions:take_out_of_trunk',PlayerId(),nil)

        end
      
        if IsPedDeadOrDying(cache.ped,true) == 1 then
            TriggerServerEvent('miska_interactions:take_out_of_trunk',PlayerId(),LocalPlayer.state.InTrunk)
        end
    end
end)
RegisterNetEvent('miska_interactions:take_out_of_trunkcl',function (vehicle)
    
    if vehicle  and IsPedDeadOrDying ~= 1 then
    local vehicle = NetworkGetEntityFromNetworkId(vehicle)
    
    SetVehicleDoorOpen(vehicle,5,true,true )
   
   
    DetachEntity(cache.ped,false,true)
    Wait(500)
    local offset = GetOffsetFromEntityInWorldCoords(vehicle,0,-3.2,0)
   
    RemoveAnimDict('fin_ext_p1-5')
    SetEntityCollision(cache.ped,true,true)
    SetEntityCoords(cache.ped,offset.x,offset.y,offset.z,true,false,false,false)
    ClearPedTasks(cache.ped)
    Wait(500)
  
    Wait(2000)
    SetVehicleDoorShut(vehicle,5,true)
    else
        
        RemoveAnimDict('fin_ext_p1-5')
        ClearPedTasks(cache.ped)
        SetEntityCollision(cache.ped,true,true)
        DetachEntity(cache.ped,true,true)
            
    end 
    
end)

RegisterNetEvent('miska_interactions:carrycl',function (playerId,ped)
   
    local ped = NetworkGetEntityFromNetworkId(ped)
    local alert = lib.alertDialog({
        header = locale('carry_person_request'),
        content = locale('carry_player')..playerId..locale('wants_to_carry'),
        centered = true,
        cancel = true
    })

    if alert =='confirm'  then
        local carrierCoords = GetEntityCoords(ped)
        local playerCoords = GetEntityCoords(cache.ped)
        local result = carrierCoords - playerCoords
        if #result <= 3.0  then 
        lib.requestAnimDict('nm',300)
        TaskPlayAnim(cache.ped,'nm','firemans_carry',8.0,8.0,-1,33,0,false,false,false)
        AttachEntityToEntity(cache.ped,ped,-1,0.27,0.15,0.63,0.5,0.5,180,false,false,false,false,2,false)
        LocalPlayer.state.isBeingCarried = playerId
        LocalPlayer.state.invBusy = true
        if LocalPlayer.state.isZiptied == nil or LocalPlayer.state.isHandCuffed == nil or IsPedDeadOrDying == false then
        TriggerServerEvent('miska_interactions:carry_accepted',playerId)   
        while LocalPlayer.state.isBeingCarried == true do
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
        end
    end
    end
    end
     
    
end)
RegisterNetEvent('miska_interactions:carry_acceptedcl',function (playerId)
    LocalPlayer.state.isCarrying = playerId
    LocalPlayer.state.canUseWeapons = false
    lib.requestAnimDict('missfinale_c2mcs_1',300)
    TaskPlayAnim(cache.ped,'missfinale_c2mcs_1','fin_c2_mcs_1_camman',8.0,8.0,-1,49,0,false,false,false)
   
    lib.showTextUI('[E] - '..locale('stop_carry'))
    while LocalPlayer.state.isCarrying ~= nil do
        Wait(0)
       
        if IsEntityPlayingAnim(cache.ped,'missfinale_c2mcs_1','fin_c2_mcs_1_camman',3) ~= 1 then
            lib.requestAnimDict('missfinale_c2mcs_1')
            TaskPlayAnim(cache.ped, 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 8.0, -8, -1, 49, 0.0, false, false, false)
            RemoveAnimDict('missfinale_c2mcs_1')
        end
          if IsControlJustPressed(0,38) then
            TriggerServerEvent('miska_interactions:carry_stop',playerId)
            ClearPedTasks(cache.ped)
            LocalPlayer.state.canUseWeapons = true
            LocalPlayer.state.isCarrying = nil
            RemoveAnimDict('missfinale_c2mcs_1')
            lib.hideTextUI()
        end   
    end
end)
RegisterNetEvent('miska_interactions:carry_stopcl',function ()
    RemoveAnimDict('NM')
    LocalPlayer.state.isBeingCarried = nil
    DetachEntity(cache.ped,true,true)
    ClearPedTasks(cache.ped)
    
    LocalPlayer.state.invBusy = false
end)
