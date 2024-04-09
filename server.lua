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
RegisterNetEvent('miska_interactions:carrying',function (targetPlayerId,ped)
    Player(targetPlayerId).state.isBeingCarried = true 

    TriggerClientEvent('miska_interactions:carry',targetPlayerId,ped)
end)
RegisterNetEvent('miska_interactions:stop_carry',function (targetPlayerId)
    Player(targetPlayerId).state.isBeingCarried = nil 

    TriggerClientEvent('miska_interactions:stop_carrying',targetPlayerId)
end)
RegisterNetEvent('miska_interactions:put_into_car',function (targetPlayerId,vehicle)
    TriggerClientEvent('miska_interactions:put_into_carcl',targetPlayerId,vehicle)
end)
RegisterNetEvent('miska_interactions:leave_car',function (targetPlayerId)
    TriggerClientEvent('miska_interactions:leave_carcl',targetPlayerId)
end)
RegisterNetEvent('miska_interactions:put_bag_on',function (targetPlayerId)
    bagCount = exports.ox_inventory:GetItemCount(source,Config.Items.bagItem)
    print(bagCount)
    if bagCount == 0 or targetPlayerId == -1 then
        DropPlayer(source,'Cheating')
    else
    exports.ox_inventory:RemoveItem(source,1,Config.Items.bagItem)
   
    TriggerClientEvent('miska_interactions:put_bag_oncl',targetPlayerId)
    end
end)
RegisterNetEvent('miska_interactions:put_bag_off',function (targetPlayerId)
if targetPlayerId == -1 then
    DropPlayer(source,'Cheating')
end
exports.ox_inventory:AddItem(source,1,Config.Items.bagItem)
  
    TriggerClientEvent('miska_interactions:put_bag_offcl',targetPlayerId)
end)