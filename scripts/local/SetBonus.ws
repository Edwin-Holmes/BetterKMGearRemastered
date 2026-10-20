enum EItemSetBonus {
    EISB_KM,
    EISB_Viper_1,
    EISB_Viper_2
}

enum EItemSetType {
    EIST_KM
}

// Set Bonus
@wrapMethod(W3PlayerWitcher) function GetToxicityDamageThreshold(): float {
    var ret: float;

    ret = wrappedMethod();

    if (this.IsSetBonusActive(EISB_KM)) {
        ret += 0.25;
    }

    return ret;
}

@wrapMethod(W3PlayerWitcher) function ItemSetTypeToItemSetBonus(setType: EItemSetType, nr: int): EItemSetBonus {
    if (setType == EIST_KM) {
        return EISB_KM;
    }

    return wrappedMethod(setType, nr);
}

//Pieces needed
@wrapMethod(W3PlayerWitcher) function IsSetBonusActive(bonus: EItemSetBonus): bool {
    if (bonus == EISB_KM) {
        return amountOfSetPiecesEquipped[EIST_KM] >= 4;
    }

    return wrappedMethod(bonus);
}

//Pieces equipped
@wrapMethod(W3PlayerWitcher) function UpdateItemSetBonuses(item: SItemUniqueId, increment: bool) {
    var setType: EItemSetType;

    if (inv.IsIdValid(item) && inv.ItemHasTag(item, 'KMset')) {
        setType = EIST_KM;

        if (increment) {
            amountOfSetPiecesEquipped[setType] += 1;
        }
        else if (amountOfSetPiecesEquipped[setType] > 0) {
            amountOfSetPiecesEquipped[setType] -= 1;
        }

        ManageActiveSetBonuses(setType);
        return;
    }

    wrappedMethod(item, increment);
}

@wrapMethod(W3PlayerWitcher) function CheckSetType(item: SItemUniqueId): EItemSetType {
    var tags: array<name>;
    var i: int;

    inv.GetItemTags(item, tags);

    for (i = 0; i < tags.Size(); i += 1) {
        if (tags[i] == 'KMset') {
            return EIST_KM;
        }
    }

    return wrappedMethod(item);
}

@wrapMethod(W3PlayerWitcher) function GetSetBonusStatus(item: SItemUniqueId, out desc1, desc2: string, out isActive1, isActive2: bool): EItemSetType {
    var setType: EItemSetType;

    setType = wrappedMethod(item, desc1, desc2, isActive1, isActive2);

    if (setType == EIST_KM) {
        desc1 = GetLocStringByKeyExt("tooltip_set_bonus_kmset");
        isActive1 = this.IsSetBonusActive(EISB_KM);

        desc2 = "";
        isActive2 = false;
    }

    return setType;
}

@wrapMethod(W3PlayerWitcher) function GetSetBonusTooltipDescription(bonus: EItemSetBonus): string {
    if (bonus == EISB_KM) {
        return GetLocStringByKeyExt("tooltip_set_bonus_kmset");
    }

    return wrappedMethod(bonus);
}

@wrapMethod(CInventoryComponent) function IsItemSetItem(item: SItemUniqueId): bool {
    if (ItemHasTag(item, 'KMset')) {
        return true;
    }

    return wrappedMethod(item);
}

//Build tooltip
@wrapMethod(W3TooltipComponent) function AddSetAttributes(itemId: SItemUniqueId, itemInvComponent: CInventoryComponent, out flashDataObj: CScriptedFlashObject): bool {
    var tags: array<name>;
    var i: int;
    var isKMSet: bool;
    var setAttributesList: CScriptedFlashArray;
    var setAttribute: CScriptedFlashObject;
    var currentCount: int;
    var counterText: string;
    var isActive: bool;

    if (itemInvComponent.IsIdValid(itemId)) {
        itemInvComponent.GetItemTags(itemId, tags);
        for (i = 0; i < tags.Size(); i += 1) {
            if (tags[i] == 'KMset') {
                isKMSet = true;
                break;
            }
        }
    }

    if (isKMSet) {
        currentCount = GetWitcherPlayer().GetSetPartsEquipped(EIST_KM);

        counterText = currentCount + " / 6";
        flashDataObj.SetMemberFlashString("SetCounter", counterText);

        setAttributesList = flashDataObj.CreateFlashArray();

        setAttribute = flashDataObj.CreateFlashObject(); //Tooltip highlights if active
        setAttribute.SetMemberFlashString("value", "4");
        setAttribute.SetMemberFlashString("name", GetLocStringByKeyExt("tooltip_set_bonus_kmset"));

        isActive = GetWitcherPlayer().IsSetBonusActive(EISB_KM);
        setAttribute.SetMemberFlashBool("active", isActive);

        setAttributesList.PushBackFlashObject(setAttribute);
        flashDataObj.SetMemberFlashArray("SetStatsList", setAttributesList);

        return true;
    }

    return wrappedMethod(itemId, itemInvComponent, flashDataObj);
}

////////////////////////////////////// Viper Set ///////////////////////////////////////////

@wrapMethod(W3PlayerWitcher) function ItemSetTypeToItemSetBonus(setType: EItemSetType, nr: int): EItemSetBonus {
    if (setType == EIST_Viper) {
        if (nr == 1) {
            return EISB_Viper_1;
        }
        return EISB_Viper_2;
    }

    return wrappedMethod(setType, nr);
}

@wrapMethod(W3PlayerWitcher) function IsSetBonusActive(bonus: EItemSetBonus): bool {
    if (bonus == EISB_Viper_1) {
        return amountOfSetPiecesEquipped[EIST_Viper] >= 3;
    }

    if (bonus == EISB_Viper_2) {
        return amountOfSetPiecesEquipped[EIST_Viper] >= 6;
    }   

    return wrappedMethod(bonus);
}

@wrapMethod(W3PlayerWitcher) function GetSetBonusTooltipDescription(bonus: EItemSetBonus): string {
    if (bonus == EISB_Viper_1) {
        return GetLocStringByKeyExt("tooltip_set_bonus_viper1");
    }

    if (bonus == EISB_Viper_2) {
        return GetLocStringByKeyExt("tooltip_set_bonus_viper2");
    }

    return wrappedMethod(bonus);
}

@wrapMethod(W3TooltipComponent) function AddSetAttributes(itemId: SItemUniqueId, itemInvComponent: CInventoryComponent, out flashDataObj: CScriptedFlashObject): bool {
    var desc1, desc2, counterText: string;
    var isActive1, isActive2: bool;
    var setType: EItemSetType;
    var currentCount: int;
    var setAttributesList: CScriptedFlashArray;
    var setAttribute: CScriptedFlashObject;

    setType = GetWitcherPlayer().GetSetBonusStatus(itemId, desc1, desc2, isActive1, isActive2);

    if (setType == EIST_Viper) {
        currentCount = GetWitcherPlayer().GetSetPartsEquipped(EIST_Viper);

        counterText = currentCount + " / 6";
        flashDataObj.SetMemberFlashString("SetCounter", counterText);

        setAttributesList = flashDataObj.CreateFlashArray();

        // Viper Bonus 1 (3 pieces)
        setAttribute = flashDataObj.CreateFlashObject();
        setAttribute.SetMemberFlashString("value", "3");
        setAttribute.SetMemberFlashString("name", GetLocStringByKeyExt("tooltip_set_bonus_viper1"));
        setAttribute.SetMemberFlashBool("active", GetWitcherPlayer().IsSetBonusActive(EISB_Viper_1));
        setAttributesList.PushBackFlashObject(setAttribute);

        // Viper Bonus 2 (6 pieces)
        setAttribute = flashDataObj.CreateFlashObject();
        setAttribute.SetMemberFlashString("value", "6");
        setAttribute.SetMemberFlashString("name", GetLocStringByKeyExt("tooltip_set_bonus_viper2"));
        setAttribute.SetMemberFlashBool("active", GetWitcherPlayer().IsSetBonusActive(EISB_Viper_2));
        setAttributesList.PushBackFlashObject(setAttribute);

        flashDataObj.SetMemberFlashArray("SetStatsList", setAttributesList);

        return true;
    }

    return wrappedMethod(itemId, itemInvComponent, flashDataObj);
}