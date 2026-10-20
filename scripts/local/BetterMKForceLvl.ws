@wrapMethod(W3GameParams) function GetItemLevel(itemCategory : name, itemAttributes : array<SAbilityAttributeValue>, optional itemName : name, optional out baseItemLevel : int) : int {
    if (itemName == 'Starting Gloves' || itemName == 'Witcher Silver Sword') {
        baseItemLevel = 1;
        return 1;
    }

    return wrappedMethod(itemCategory, itemAttributes, itemName, baseItemLevel);
}