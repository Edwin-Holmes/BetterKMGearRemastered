//=======================================================================//
//              Socket Debugging                                         //
//=======================================================================//

@wrapMethod(CR4InventoryMenu)
function OnPutInSocket(item: SItemUniqueId) {
    var result: bool;

    result = wrappedMethod(item);

    if (_inv.ItemHasTag(item, 'KMset')) {
        LogChannel('KMMod', "CanBeUpgradedBy called for KM item. Result: " + result);
    }

    return result;
}

@wrapMethod(W3GuiBaseInventoryComponent)
function CanBeUpgradedBy(targetItem: SItemUniqueId, upgradeItem: SItemUniqueId): bool {
    var result: bool;
    var socketsCount, usedSocketsCount, emptySocketsCount: int;
    var hasArmorTag, hasSwordTag: bool;

    result = wrappedMethod(targetItem, upgradeItem);

    if (_inv.ItemHasTag(targetItem, 'KMset')) {
        socketsCount = _inv.GetItemEnhancementSlotsCount(targetItem);
        usedSocketsCount = _inv.GetItemEnhancementCount(targetItem);
        emptySocketsCount = socketsCount - usedSocketsCount;

        hasArmorTag = _inv.ItemHasTag(targetItem, 'Armor');
        hasSwordTag = _inv.ItemHasTag(targetItem, 'sword1h');

        LogChannel('KMMod', "=== CanBeUpgradedBy Debug ===");
        LogChannel('KMMod', "Final Result: " + result);
        LogChannel('KMMod', "Sockets Total: " + socketsCount + " | Used: " + usedSocketsCount + " | Empty: " + emptySocketsCount);
        LogChannel('KMMod', "Has 'Armor' tag: " + hasArmorTag + " | Has 'sword1h' tag: " + hasSwordTag);
        LogChannel('KMMod', "Enchantment present: " + (_inv.GetEnchantment(targetItem) != ''));
    }

    return result;
}

exec function addbkmitems() {
    thePlayer.inv.AddAnItem('Starting Armor', 1);
    thePlayer.inv.AddAnItem('Starting Armor 1', 1);
    thePlayer.inv.AddAnItem('Starting Pants', 1);
    thePlayer.inv.AddAnItem('Starting Gloves', 1);
    thePlayer.inv.AddAnItem('Starting Boots', 1);
    thePlayer.inv.AddAnItem('Witcher Silver Sword', 1);
    thePlayer.inv.AddAnItem('Long Steel Sword', 1);
    thePlayer.inv.AddAnItem('Rune veles', 5);
    thePlayer.inv.AddAnItem('Glyph igni', 5);
}
