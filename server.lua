RegisterNetEvent('miska_interactions:ziptie_detainee:detain',function (targetPlayerId)
    local ziptiesCount =exports.ox_inventory:GetItemCount(source,Config.Items.ziptiesItem)

    if ziptiesCount == 0 or targetPlayerId == -1  then
        DropPlayer(source,'Cheating')
    else
    exports.ox_inventory:RemoveItem(source,Config.Items.ziptiesItem,1)
  
    TriggerClientEvent('miska_interactions:ziptie_detainee:detaincli',targetPlayerId)
    Wait(2800)
    Player(targetPlayerId).state.isZiptied = true
    end

end)
RegisterNetEvent('miska_interactions:ziptie_free',function (targetPlayerId)
    Player(targetPlayerId).state.isZiptied = nil

end)
RegisterNetEvent('miska_interactions:handcuff_detainee:detain',function (targetPlayerId)
    local handcuffsCount =exports.ox_inventory:GetItemCount(source,Config.Items.handcuffsItem)

    if handcuffsCount == 0 or targetPlayerId == -1  then
        DropPlayer(source,'Cheating')
    else
    exports.ox_inventory:RemoveItem(source,Config.Items.handcuffsItem,1)
    

   
    TriggerClientEvent('miska_interactions:handcuff_detainee:detaincli',targetPlayerId)
    Wait(2800)
    Player(targetPlayerId).state.isHandCuffed = true
    end

end)
RegisterNetEvent('miska_interactions:handcuff_free',function (targetPlayerId)
    Player(targetPlayerId).state.isHandCuffed = nil
    exports.ox_inventory:AddItem(source,Config.Items.handcuffsItem,1)
    
end)
RegisterNetEvent('miska_interactions:dragging',function (targetPlayerId,ped)
    Player(targetPlayerId).state.isBeingDragged = true 

    TriggerClientEvent('miska_interactions:drag',targetPlayerId,ped)
end)
RegisterNetEvent('miska_interactions:stop_dragging',function (targetPlayerId)
    Player(targetPlayerId).state.isBeingDragged = nil 

    TriggerClientEvent('miska_interactions:stop_dragging',targetPlayerId)
end)
RegisterNetEvent('miska_interactions:put_into_car',function (targetPlayerId,vehicle)
    TriggerClientEvent('miska_interactions:put_into_carcl',targetPlayerId,vehicle)
end)
RegisterNetEvent('miska_interactions:leave_car',function (targetPlayerId)
    TriggerClientEvent('miska_interactions:leave_carcl',targetPlayerId)
end)
RegisterNetEvent('miska_interactions:put_bag_on',function (targetPlayerId)
    bagCount = exports.ox_inventory:GetItemCount(source,Config.Items.bagItem)
    
    if bagCount == 0 or targetPlayerId == -1 then
        DropPlayer(source,'Cheating')
    else
        Player(targetPlayerId).state.hasBagOnHead = true
    exports.ox_inventory:RemoveItem(source,Config.Items.bagItem,1)
        
    TriggerClientEvent('miska_interactions:put_bag_oncl',targetPlayerId)
    end
end)
RegisterNetEvent('miska_interactions:put_bag_off',function (targetPlayerId)
if targetPlayerId == -1 then
    DropPlayer(source,'Cheating')
end

    exports.ox_inventory:AddItem(source,Config.Items.bagItem,1)

Player(targetPlayerId).state.hasBagOnHead = nil
    TriggerClientEvent('miska_interactions:put_bag_offcl',targetPlayerId)
end)
