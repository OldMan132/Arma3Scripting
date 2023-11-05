params [
	["_mode", "", [""]]
];

switch _mode do {
	case "StartHunt": {
		if (TreasureHunt isEqualto 0) then {
			cutRsc ["LocateTreasure","PLAIN", 0, true];
			TreasureHunt = 1;
			treasurePickedUp = 0;
			lootCheck = 0;
			["BoxTimer"] spawn TES_fnc_treasureHunt;

			_treasureLocation = selectRandom [[3098.72,14171.3,0.000991821],[2076.89,22180.6,0.00120926],[8888.27,23470.6,0.00177765],[23421.7,24168.5,0.00140905],[26096,19667.9,0.00151217],[22296.5,5098.68,0.00142145],[8389.06,9658.52,0.00148898]]; 
			_randomMarker = selectRandom ["Contact_pencilTask1", "Contact_pencilTask2", "Contact_pencilTask3"];

			_marker = createMarkerLocal ["treasureMarker", _treasureLocation]; 
			"treasureMarker" setMarkerShapeLocal "ICON";
			"treasureMarker" setMarkerTypeLocal _randomMarker;
			"treasureMarker" setMarkerColorLocal "ColorRed";
			"treasureMarker" setMarkerTextLocal "Treasure Location";
			"treasureMarker" setMarkerAlphaLocal 1;
			openMap [true, false];
			mapAnimAdd [3, 0.3, markerPos "treasureMarker"];
			mapAnimCommit;

			_treasure = createVehicleLocal ["Box_Syndicate_Ammo_F", _treasureLocation, [], 0, "None"];  
			clearItemCargoGlobal _treasure;
			clearMagazineCargoGlobal _treasure;
			_treasure lockInventory true;

			_treasure enableSimulation false;
			_treasure setPosATL [getPosATL _treasure select 0, getPosATL _treasure select 1, (getPosATL _treasure select 2) - 1];

			//_xmark = createVehicle ["UserTexture1m_F", getPosATL _treasure]; ***Personally I dislike the idea of the X mark because it takes away the fun of looking for the treasure. Nonetheless, its a feature which could be added if wanted.
			//_xmark setObjectTextureGlobal [0, "images\XMark256.paa"]; 

			_treasure addAction ["Dig Up Treasure", {
				_this select 0 removeAction 0;
				_floorHeight = 10; 
				while {_floorHeight > 0} do {
					_treasureA = _this select 0;
					_treasureA setPosATL [getPosATL _treasureA select 0, getPosATL _treasureA select 1, (getPosATL _treasureA select 2) + 0.1];
					sleep 1;
					_floorHeight = _floorHeight - 1;
				}; 
				cutRsc ["FoundTreasure","PLAIN", 0, true];
				_this select 0 lockInventory false;
				lootCheck = 1;
			}, _treasure, 1.5, true, true, "", "", 8];

			_lootOdds = random [1, 50, 100];

			if (_lootOdds <= 30) then { //uncommon loot 30% - Mid tier guns with level 3 vest
				_randomGun = selectRandom ["arifle_Katiba_C_F", "arifle_MX_SW_Black_F", "arifle_ARX_hex_F"];
				_treasure addItemCargo [_randomGun , 1];
				_randomVest = selectRandom ["V_PlateCarrier1_rgr", "V_PlateCarrierIA2_dgtl", "H_HelmetO_ocamo"];
				_treasure addItemCargo [_randomVest , 1];
			} else { //common loot 70% - Low Tier guns with level 1 or 2 vest 
				_randomGun = selectRandom ["hgun_ACPC2_F", "arifle_SDAR_F", "hgun_PDW2000_F"];
				_treasure addItemCargo [_randomGun , 1];
				_randomVest = selectRandom ["V_TacVestIR_blk", "V_Press_F", "H_Helmet_Kerry"];
				_treasure addItemCargo [_randomVest , 1];
			}; 
			_originalLoot = getItemCargo _treasure;

			waitUntil {lootCheck isEqualto 1};
			_treasure addAction ["Pickup Treasure", {
				_t1 = _this select 3 select 0;
				_t2 = _this select 3 select 1;
				if (_t2 isEqualto getItemCargo _t1) then {
					deleteVehicle _t1;
					treasurePickedUp = 1;
				}; 
			}, [_treasure, _originalLoot], 1.5, true, true, "", "", 8];
		} else {hint "Treasure hunt already started"}; 
	};

	case "BoxTimer":
	{
		_timer = 1200;
		while {_timer >= 0} do {
			_timer = _timer - 1;
			sleep 1;
			if (_timer isEqualto 0) then {
				TreasureHunt = 0;
				treasurePickedUp = 0;
				lootCheck = 0;
				deleteVehicle _treasure;
				hint "The hunt has ended. You did not find the treasure in time."
			};
		};

	};

	default {};
};