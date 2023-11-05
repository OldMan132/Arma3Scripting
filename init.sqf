[] spawn {
	waitUntil { !isNull findDisplay 46 };
};
TreasureHunt = 0;
_treasureHunter = createAgent ["C_man_hunter_1_F", [3751.33,12988.2,0.15415], [], 0, "NONE"]; //Location Kav Hospital 
_treasureHunter allowDammage false;
_treasureHunter disableAI  "ALL";
_treasureHunter addAction ["Hunt Treasure", {["StartHunt"] spawn TES_fnc_treasureHunt;}, nil, 1.5, true, true, "", "", 8];

waitUntil {TreasureHunt isEqualto 1};
_treasureHunter addAction ["Turn Treasure In", {
	if (treasurePickedUp isEqualto 1) then {
		treasurePickedUp = 0;
		TreasureHunt = 0;
		cutRsc ["TurnInTreasure","PLAIN", 0, true];
	} else {hint "you have no currently picked up any treasure."};
}, nil, 1.5, true, true, "", "", 8];
