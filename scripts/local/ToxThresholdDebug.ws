@wrapMethod(W3Effect_Toxicity)
function OnEffectAdded(optional customParams: W3BuffCustomParams) {
    var wp: W3PlayerWitcher = GetWitcherPlayer();
    var threshold: float;

    threshold = wp.GetToxicityDamageThreshold();
    thePlayer.DisplayHudMessage("Tox Threshold: " + threshold);
    LogChannel('KMMod', "Tox Threshold: " + threshold);

    return wrappedMethod();
}
