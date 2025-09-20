if not Lang then Lang = {} end
Lang['en'] = {
	['open'] = "Press ~y~E~w~ to open",
	['open_main_target'] = "Open fishing dashboard",
	['open_property_target'] = "Open fishing property",
	['open_store_target'] = "Open fishing store",
	['you_died'] = "You died and lost your vehicle",
	['insufficient_money'] = "Insufficient money",
	['invalid_value'] = "Invalid value",
	['no_permission'] = "You dont have the required job to open this menu",
	['not_enough_level'] = "You dont have enough level to use this item",
	['fish_store_sold'] = "You sold %sx %s",
	['fish_store_all_sold'] = "You sold all your fishes for $%s",
	['fish_store_nothing_sold'] = "You dont have any fish to sell in this store",
	['fish_store_not_enough'] = "You dont have %sx %s to sell",
	['exp'] = "EXP",

	['anchor_boat_command'] = "Anchor boat",
	['anchor_too_fast'] = "Slow down to use the anchor",
	['anchor_not_allowed'] = "You cannot anchor here",
	['anchor_lowered'] = "Anchor lowered",
	['anchor_raised'] = "Anchor raised",

	['contract_invalid'] = "This contract does not exist anymore",
	['contract_started'] = "You've started a contract, delivery the required products to the destination",
	['contract_already_started'] = "You already have a contract, please finish it first",
	['contract_someone_already_started'] = "Someone else already started this contract, please choose another",
	['contract_waypoint_set'] = "The waypoint to the contract has been marked on your GPS",
	['contract_finish_delivery'] = "Press ~y~E~w~ to finish delivery",
	['contract_received_money'] = "Received $%s for finish the contract",
	['contract_received_item'] = "Received %sx %s for finish the contract",
	['contract_received_item_error'] = "You dont have enough space to receive the item %sx %s",
	['contract_destination_blip'] = "Destination",
	['contract_cancel'] = "You have cancelled your contract",
	['contract_not_enough_items'] = "You dont have the required items: %s",

	['dive_invalid'] = "This dive does not exist anymore",
	['dive_started'] = "You've started a dive, go find the treasure",
	['dive_already_started'] = "You already have a dive, please finish it first",
	['dive_someone_already_started'] = "Someone else already started this dive, please choose another",
	['dive_waypoint_set'] = "The waypoint to the dive area has been marked on your GPS",
	['dive_received_money'] = "Received $%s for finish the dive",
	['dive_received_item'] = "Received %sx %s for finish the dive",
	['dive_received_item_error'] = "You dont have enough space to receive the item %sx %s",
	['dive_cancel'] = "You have cancelled your dive",
	['dive_finish'] = "Press ~y~E~w~ to finish dive",

	['money_withdrawn'] = "Money withdrawn",
	['money_deposited'] = "Money deposited",
	['pay_loans'] = "You must pay your loans before withdrawing your money",
	['loan'] = "Loan made",
	['no_loan'] = "You cannot take this loan",
	['loan_paid'] = "Loan paid",
	['no_loan_money'] = "You don't have any money to pay off your loan from the fishing job. You've lost everything",

	['upgrade_purchased'] = "Upgrade purchased",
	['equipment_purchased'] = "Equipment purchased",
	['insufficient_skill_points'] = "Insufficient skill points",

	['occupied_places'] = "Your garage is occupied, consider removing any obstructions that are blocking the vehicle parking space",
	['vehicle_blip'] = "Vehicle",
	['garage_blip'] = 'Garage',
	['press_e_to_store_vehicle'] = '~w~Press ~g~[E]~w~ to store the ~b~vehicle~w~.',
	['vehicle_already_spawned'] = 'You already have a vehicle',
	['vehicle_lost'] = 'You have lost your vehicle somewhere in the world',

	['garage_full'] = 'Your garage is full',
	['vehicle_purchased'] = "You have purchased the vehicle",
	['vehicle_repaired'] = "Vehicle repaired",
	['vehicle_refueled'] = "Vehicle refueled",
	['vehicle_already_repaired'] = "This vehicle is already repaired",
	['vehicle_already_refueled'] = "This vehicle is already refueled",
	['vehicle_not_found'] = "Vehicle not found",
	['vehicle_damaged'] = "Vehicle is too much damaged",
	['vehicle_sold'] = "Vehicle sold for $%s",
	['vehicle_spawned'] = "Your vehicle is in your garage",
	['vehicle_capacity_full'] = "Your vehicles capacity is full",
	['vehicle_owned_name'] = "Owned vehicle",
	['vehicle_destroyed'] = "Your vehicle has been destroyed",

	['stock_item_deposited'] = "Item deposited",
	['dont_have_item'] = "You dont have %sx %s items in your inventory",
	['stock_property_full'] = "The property stock cant carry that item",
	['stock_item_withdrawn'] = "Item withdrawn",
	['stock_cannot_withdraw'] = "This item cannot be withdrawn",
	['cant_carry_item'] = "You cant carry that item",

	['property_waypoint_set'] = "The waypoint to the property has been marked on your GPS",
	['property_needs_repair'] = "You will lose the property '%s' really soon if you dont repair it",
	['property_not_owned'] = "You dont own this property",
	['property_sold'] = "You sold the property",
	['property_purchased'] = "You have purchased the property",
	['property_max_amount'] = 'You cant have more properties',
	['property_not_found'] = "Property not found",
	['property_already_repaired'] = "This property is already repaired",
	['property_repaired'] = "Property repaired",

	['tournament_joined'] = "You've successfully joined the tournament! The tournament location has been marked on your map. Don't forget to be there on time and good luck!",
	['tournament_waypoint'] = "The tournament location has been marked on your map",
	['tournament_not_in'] = "You're not in this tournament",
	['tournament_not_found'] = "There are no tournaments currently happening here",
	['tournament_already_in'] = "You're already in this tournament",
	['tournament_not_available'] = "The tournament you're joining isn't available anymore",
	['tournament_started'] = "The fishing tournament has started! Grab your fishing rod and catch as many fish as possible to win",
	['tournament_fish_caught'] = "You have scored %s points with this catch!",
	['tournament_ended'] = "The tournament has ended",
	['tournament_cancelled'] = "The tournament was cancelled due to not reaching the minimum number of participants. The entry fee has been refunded",
	['tournament_prize_received'] = "Congratulations! Your place in the tournament is: %s. Your prize is: %s",
	['tournament_prize_not_received'] = "You didn't win a prize this time, but best of luck in your next attempt",

	-- Logs
	['logs_date'] = "Date",
	['logs_hour'] = "Time",
	['logs_withdraw'] = "```prolog\n[MONEY WITHDRAW]: %s \n[ID] %s \r```",
	['logs_deposit'] = "```prolog\n[MONEY DEPOSITED]: %s \n[ID] %s \r```",
	['logs_buy_vehicle'] = "```prolog\n[USER]: %s\n[VEHICLE PURCHASED]: %s \n[PRICE]: %s \n[ID]: %s \r```",
	['logs_buy_property'] = "```prolog\n[USER]: %s\n[PROPERTY PURCHASED]: %s \n[PRICE]: %s \n[ID]: %s \r```",
	['logs_fish_sold'] = "```prolog\n[FISH SOLD]: %s\n[AMOUNT]: %s \n[PRICE]: %s \n[ID]: %s \r```",
	['logs_exploit'] = "```prolog\n[POTENTIAL EXPLOIT]: %s\n[PLAYER LOCATION]: %s\n[DATA]: %s\n[USER]: %s \r```",

	-- Fishing Area
	["cannot_fish_in_vehicle"] = "You cannot fish while in a vehicle",
	["water_not_found"] = "No water found at the targeted location! Make sure there's sufficient water to fish",
	["area_not_found"] = "You're not in a valid area to fish",
	['new_level'] = "You just went to level: %s !",
	["fishing_lost"] = "You lost the fish",

	["missing_equipments"] = {
		["rod"] = "You must equip a fishing rod",
		["hook"] = "You must equip a fishing hook",
		["reel"] = "You must equip a fishing reel",
		["bait"] = "You must equip a fishing bait",
		["line"] = "You must equip a fishing line",
	},
	["equipment_equipped"] = "You've equipped this equipment",

	-- Config contracts
	['contracts'] = {
		['chefs_special'] = {
			['name'] = "Chef's Special",
			['description'] = "A local chef needs these fishes for a gourmet meal tonight. Can you deliver?"
		},
		['exotic_collection'] = {
			['name'] = "Exotic Collection",
			['description'] = "Deliver these rare fishes to earn special gear!"
		},
		['aquarium_exhibit'] = {
			['name'] = "Aquarium Exhibit",
			['description'] = "An aquarium is looking to expand its exhibit. Provide these fishes for a reward."
		},
		['rare_fish_trader'] = {
			['name'] = "Rare Fish Trader",
			['description'] = "A collector is in town looking for rare species. Deliver these and earn big!"
		},
		['swamp_special'] = {
			['name'] = "Swamp Specialties",
			['description'] = "Help a researcher gather samples from the swamp."
		},
		['maritime_donation'] = {
			['name'] = "Maritime Museum Donation",
			['description'] = "The local maritime museum needs specimens for their new ocean exhibit. Help them out!"
		},
		['gourmet_market'] = {
			['name'] = "Gourmet Fish Market",
			['description'] = "A high-end market is looking for premium fish. Fulfill their order for a generous payout."
		},
		['biological_research'] = {
			['name'] = "Biological Research",
			['description'] = "Assist researchers by providing them with specimens for their study of aquatic life."
		},
		['sport_fishing'] = {
			['name'] = "Sport Fishing Challenge",
			['description'] = "Catch these challenging species to win a prize in the local sport fishing competition."
		},
		['fish_fry'] = {
			['name'] = "Local Fish Fry Event",
			['description'] = "Contribute to the community fish fry event by delivering these popular fish."
		},
		['seafood_festival'] = {
			['name'] = "Local Seafood Festival",
			['description'] = "The annual seafood festival needs a variety of fish to showcase. Help supply their needs!"
		},
		['exotic_aquarium'] = {
			['name'] = "Exotic Aquarium Stock",
			['description'] = "An exotic aquarium is looking to add rare species to its collection. Can you provide them?"
		},
		['sushi_order'] = {
			['name'] = "Sushi Restaurant Order",
			['description'] = "A high-end sushi restaurant needs fresh, top-quality fish. Deliver their order on time!"
		},
		['pet_food'] = {
			['name'] = "Gourmet Pet Food Maker",
			['description'] = "A gourmet pet food maker needs high-quality fish for a new premium line. Help them out!"
		},
		['research_specimens'] = {
			['name'] = "Research Specimens",
			['description'] = "Marine researchers need specific fish species for important environmental studies."
		},
		['fish_market_supply'] = {
			['name'] = "Fish Market Supply",
			['description'] = "A local fish market needs a steady supply of common fish to keep their shelves stocked."
		},
		['bait_supply_order'] = {
			['name'] = "Bait Supply Order",
			['description'] = "A fishing shop needs various common fish for bait. Help them restock their inventory."
		},
		['cooking_class'] = {
			['name'] = "Community Cooking Class",
			['description'] = "A community center is holding a cooking class and needs common local fish to teach proper cleaning and cooking techniques."
		},
		['restaurant_daily_special'] = {
			['name'] = "Local Restaurant Special",
			['description'] = "A local restaurant features a daily fish special and needs fresh common fish delivered daily."
		},
		['science_project'] = {
			['name'] = "School Science Project",
			['description'] = "A local school needs various common fish for a science project on local ecosystems."
		},
	},
	['dives'] = {
		['reef_explorer'] = {
			['name'] = "Reef Explorer",
			['description'] = "Explore the vibrant coral reefs to find rare marine life samples for marine biologists."
		},
		['sunken_armada'] = {
			['name'] = "Sunken Armada",
			['description'] = "Dive into the remains of a legendary fleet lost during a massive storm. Recover the artifacts!"
		},
		['merchant_lost'] = {
			['name'] = "The Merchant's Lost Goods",
			['description'] = "A merchant ship sunk here in the 18th century, rumored to carry valuable silks and spices."
		},
		['underwater_city'] = {
			['name'] = "Ancient Underwater City",
			['description'] = "Ancient ruins recently discovered beneath the sea could hold clues to past civilizations."
		},
		['kraken_lair'] = {
			['name'] = "Kraken's Lair",
			['description'] = "Dare to retrieve treasures from the lair of the mythical Kraken. Beware its wrath!"
		},
		['meteorite_crash'] = {
			['name'] = "Meteorite Crash Site",
			['description'] = "A meteorite has crashed into the ocean recently, creating a rich bed of rare minerals."
		},
		['ghost_ship'] = {
			['name'] = "Ghost Ship Expedition",
			['description'] = "Dive down to investigate a ship that vanished centuries ago and has now reappeared mysteriously."
		},
		['volcanic_vents'] = {
			['name'] = "Volcanic Vents Discovery",
			['description'] = "Explore deep sea volcanic vents teeming with unique life forms and collect samples for study."
		},
		['wreck_titan'] = {
			['name'] = "Wreck of the Titan",
			['description'] = "The Titan, a luxury yacht sunk under mysterious circumstances, is believed to be filled with riches."
		},
		['bermuda_triangle'] = {
			['name'] = "Bermuda Triangle Anomaly",
			['description'] = "Investigate an anomaly in the depths of the Bermuda Triangle. Expect the unexpected."
		},
		['pearl_diver'] = {
			['name'] = "Pearl Diver's Quest",
			['description'] = "A lucrative dive to collect pearls from a dense oyster bed, known only to the oldest divers."
		},
		['cold_war_relic'] = {
			['name'] = "Cold War Relic",
			['description'] = "Recover lost espionage equipment from a sunken Cold War-era submarine."
		},
		['deep_sea_salvage'] = {
			['name'] = "Deep Sea Salvage Operation",
			['description'] = "Recover valuable cargo from a sunken freighter deep in the ocean."
		},
		['lost_jewel_atlantis'] = {
			['name'] = "Lost Jewel of Atlantis",
			['description'] = "Search for the legendary lost jewel rumored to be off the coast, guarded by the mysteries of the sea."
		},
		['sunken_plane'] = {
			['name'] = "Sunken Plane Recovery",
			['description'] = "Dive to a recently discovered WWII plane wreck to recover lost historical artifacts."
		},
		['sunken_yacht'] = {
			['name'] = "Oil Tycoon's Sunken Yacht",
			['description'] = "A billionaire's yacht has sunk under mysterious circumstances. Retrieve any valuables you find."
		},
		['coral_reef_photography'] = {
			['name'] = "Coral Reef Photography",
			['description'] = "Take stunning photographs of the coral reef for a major magazine. They pay well for quality!"
		},
		['arctic_shipwreck'] = {
			['name'] = "Arctic Shipwreck Expedition",
			['description'] = "Brave the cold waters to uncover a ship that sank while attempting to traverse the Arctic circle."
		},
	},
}
