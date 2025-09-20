if (Lang == undefined) {
	var Lang = [];
}
Lang["en"] = {
	common: {
		confirm: "Confirm",
		weight_unit: "kg",
		level_abbreviate: "Lvl.",
		skill_point: "Skill point",
		areas: {
			sea: "Sea",
			lake: "Lake",
			river: "River",
			swamp: "Swamp",
			all: "All",
		},
	},
	sidebar: {
		profile: "Your Profile",
		bank: "Bank",
		deliveries: "Special deliveries",
		dives: "Dives",
		upgrades: "Upgrades",
		equipments: "Equipments",
		store: "Store",
		owned_vehicles: "Owned vehicles",
		owned_property: "Owned properties",
		guide: "Guide",
		close: "Close",
		property: "Property",
		fish_store: "Fish store",
	},
	modals: {
		confirmation: {
			sell_vehicle: "Are you sure you want to sell this vehicle?",
			sell_propertty: "Are you sure you want to sell this property? All the items in storage will be lost",
			loan_payoff: "Are you sure you want to pay the entire balance of {0}?",
			sell_all_fishes: "This action will sell all the fish in your inventory. Are you sure you want to proceed?",
		},
	},
	statistics_page: {
		title: "Statistics",
		desc: "Statistics to track your fishing life progression",
		money_earned: "Total money earned",
		money_spent: "Total money spent",
		total_mythic_fish: "Total mythic fish caught",
		total_legendary_fish: "Total legendary fish caught",
		total_all_fish: "Total fishes caught",
		total_dives: "Total dives finished",
		total_deliveries: "Total deliveries finished",
		total_exp: "Total EXP earned",
		total_upgrades: "Total upgrades purchased",
		top_users: {
			title: "Top fishermans",
			desc: "Top 10 fishermans in the city",
			fishes_caught: "Fishes caught: {0}",
			exp: "EXP: {0}",
		},
	},
	deliveries_page: {
		title: "Deliveries",
		desc: "Complete orders to receive special pricing for fish. Select a contract to start and deliver the requested fishes to the client",
		contracts_time: "New contracts each {0} min",
		reward: "Reward",
		required_items: "Required items",
		start_button: "Start contract",
		cancel_button: "Cancel contract",
		see_location: "See location",
		missing_item: "You don't have this",
	},
	dives_page: {
		start_button: "Start dive",
		cancel_button: "Cancel dive",
		title: "Dives",
		desc: "Complete underwater expeditions to find treasures and rare items. Select a dive mission to start and earn unique rewards, but note that the locations of treasure chests aren't accurate on your GPS, making it challenging even for the most experienced",
		time: "New dives each {0} min",
	},
	bank_page: {
		title: "Bank",
		desc: "View your company's bank account information here",
		withdraw: "Withdraw money",
		deposit: "Deposit Money",
		balance: "Your balance is:",
		active_loans: "Active loans",

		loan_title: "Loans",
		loan_desc: "Take out loans to invest in your business!<BR>(Maximum loan: {0})",
		loan_button: "Take loan",
		loan_value_title: "Loan amount",
		loan_daily_title: "Daily cost",
		loan_remaining_title: "Remaining amount",
		loan_date_title: "Next payment (Auto-Debit)",
		loan_pay: "Payoff Loan",

		loan_modal_desc: "Select one of the loan types:",
		loan_modal_item: "({0}% interest rate, repayable in {1} days)",
		loan_modal_submit: "Take loan",

		deposit_modal_title: "Deposit money",
		deposit_modal_desc: "How much do you want to deposit?",
		deposit_modal_submit: "Deposit money",

		withdraw_modal_title: "Withdraw money",
		withdraw_modal_desc: "How much do you want to withdraw?",
		withdraw_modal_submit: "Withdraw money",

		modal_placeholder: "Amount",
		modal_money_available: "Available money: {0}",
		modal_cancel: "Cancel",
	},
	upgrades_page: {
		title: "Skills",
		desc: "Use your accumulated skill points to unlock new abilities that will improve your fishing experience. There is a diverse range of skills that can make you a better fisherman",
		vehicles: {
			title: "Vehicles",
			desc: "Upgrade your garage capacity to accommodate more vehicles for transporting your fish.",
			level: "+{0} vehicle slots in your garage<BR>+ Unlocks new vehicles to purchase",
		},
		boats: {
			title: "Boats",
			desc: "Upgrade your dock capacity to accommodate more boats for transporting your fish.",
			level: "+{0} vehicle slots in your garage<BR>+ Unlocks new boats to purchase",
		},
		properties: {
			title: "Properties",
			desc: "Unlock new properties to make them purchasable.",
			level: "Unlocks new properties to purchase",
		},
		lake: {
			title: "Lake",
			desc: "Upgrade your lake skills to catch more types of fish.",
			level: "Unlocks new fish species in the lake",
		},
		river: {
			title: "River",
			desc: "Upgrade your river skills to catch more types of fish.",
			level: "Unlocks new fish species in the river",
		},
		swamp: {
			title: "Swamp",
			desc: "Upgrade your swamp skills to catch more types of fish.",
			level: "Unlocks new fish species in the swamp",
		},
		sea: {
			title: "Sea",
			desc: "Upgrade your sea skills to catch more types of fish.",
			level: "Unlocks new fish species in the sea",
		},
	},
	equipments_page: {
		title: "Equipments",
		desc: "Purchase new fishing equipments to improve your fishing techniques. Improve your reaction time, increase the chances of catching rare fish, and reduce the wait time for bites. Invest on your equipment to increase your fishing effectiveness and success",
		name: "Name",
		price: "Price",
		bonus: "Bonus",
		amount: "Amount",
		buy_button: "Buy",
		unlock_text: "Reach <b>level {0}</b> to unlock this equipment",
		rod: {
			title: "Rod",
			desc: "Upgrade your fishing rod to increase the chances of catching rarer fishes",
		},
		reel: {
			title: "Reel",
			desc: "Upgrade your reel to increase the reeling performance, making the reeling progress be faster",
		},
		hook: {
			title: "Hook",
			desc: "Upgrade your hook to increase the time you have to react when hooking a fish, making it easier to catch",
		},
		line: {
			title: "Line",
			desc: "This upgrade will make your line stronger, this means that will be easier to control the tension and faster to catch the fish",
		},
		bait: {
			title: "Bait",
			desc: "Upgrade your bait to reduce the wait time for a fish to bite, starting your fishing sooner",
		},
		other : {
			title: "Other",
			desc: "Other equiments to improve your fishing experience",
		},
	},
	store_page: {
		title: "Fleet & Property Store",
		desc: "Purchase vehicles, boats, and properties to improve your delivery capabilities. Select from a variety of options to improve your efficiency and expand your operations",
		buy_button: "Buy",
		tabs: {
			vehicle: "Vehicles",
			boat: "Boats",
			property: "Properties",
		},
		vehicle: {
			name: "Vehicle",
			price: "Price",
			trunk: "Weight",
		},
		property: {
			name: "Property",
			capacity: "Capacity",
			owned: "You already own this property",
		},
	},
	owned_vehicles_page: {
		title: "Owned vehicles",
		desc: "View and manage your garage, where you can monitor the condition and fuel levels of your boats and vehicles",
		vehicle_plate: "Plate:",
		unregistered: "Empty",
		distance: "Odometer: {0} km",
		vehicle_condition: "Vehicle condition",
		vehicle_fuel: "Fuel",
		repair: "Repair {0}",
		refuel: "Refuel {0}",
		spawn: "Spawn Vehicle",
		sell: "Sell",
		unlock_text: {
			vehicle: "Upgrade the vehicle garage to <b>level {0}</b> to unlock this vehicle",
			boat: "Upgrade the boat garage to <b>level {0}</b> to unlock this boat",
			property: "Upgrade the property skill to <b>level {0}</b> to unlock this property",
		},
		tabs: {
			vehicle: "Vehicles",
			boat: "Boats",
		},
	},
	owned_properties_page: {
		title: "Owned properties",
		desc: "Manage your properties here. View stock capacity, condition, set waypoints, sell properties and repair them once they degrade to keep functioning properly",
		see: "See property stock",
		repair: "Repair {0}",
		sell: "Sell property",
		stock_percentage: "Stock capacity",
		stock_condition: "Stock condition",
		address: "Address: {0}",
		set_waypoint: "Set waypoint",
	},
	guide_page: {
		title: "Guide",
		desc: "A guide designed to assist fishermen to learn about the fish species found in each location",
		fish_weight: "Weight",
		fish_value: "Value",
		filter_label: "Filter by name",
		filter_placeholder: "Fish name",
	},
	stock_page: {
		title: "Property stock ({0})",
		desc: "Here you can see and interact with all the items your property has stored",
		property_stock_title: "Property stock",
		player_inventory_title: "Your inventory",
		table_empty:"Stock empty",
		bar_title: "Stock capacity",
		inventory_table: {
			header_name: "Item name",
			header_amount: "Amount",
			header_weight: "Weight",
			header_value: "Value",
		},
		deposit_modal_title: "Deposit item",
		deposit_modal_item_available: "In inventory: {0}",
		withdraw_modal_title: "Withdraw item",
		withdraw_modal_item_available: "In stock: {0}",
		withdraw_modal_amount: "Amount",
		withdraw_modal_cancel: "Cancel",
	},
	tournaments: {
		join_tournament_alert: {
			title: "Fishing Tournament",
			body: "Join our fishing tournaments for a chance to win big prizes! The next tournament begins <b>{0}</b> at <b>{1}</b>. To participate, click the \"Join Tournament\" button before the event starts.",
			footer: "Prepare your gear and aim for the top prize by catching the biggest and rarest fish. Don't miss out on your chance to win up to <b>{0}</b>!",
			button: "Join Tournament",
		},
		joined_tournament_alert: {
			title: "Tournament Entry Confirmed",
			body: "You've successfully joined the upcoming fishing tournament! It begins <b>{0}</b> at <b>{1}</b>. Don't forget to be there in time.",
			footer: "You're all set! Gear up to compete for the top prize and the chance to catch the biggest and rarest fish. Up to <b>{0}</b> in prizes awaits!",
			button: "Mark Location on GPS",
		},
		scoreboard_dialog: {
			title: "Tournament Scoreboard",
			table_name: "Name",
			table_points: "Points",
		},
		join_tournament_dialog: {
			title: "Join Fishing Tournament",
			body: `
				<p>You are about to enter the fishing tournament. Below are the details of the tournament:</p>

				<ul>
					<li><strong>Tournament Start Time:</strong> {0} at {1}</li>
					<li><strong>Entry Fee:</strong> {2}</li>
					<li><strong>Duration:</strong> {3} minutes</li>
				</ul>

				<p><strong>Prizes:</strong></p>
				<ul>
					<li><strong>1st Place:</strong> {4}</li>
					<li><strong>2nd Place:</strong> {5}</li>
					<li><strong>3rd Place:</strong> {6}</li>
				</ul>

				<p><strong>Objective:</strong> Catch as many fish as you can to increase your total score, with rarer fish boosting your score more than common ones! 🏆</p>

				<p>Are you ready?</p>`, // Caution when translating, this code must keep its formatting
		},
		today_text: "Today",
		week_days: new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"),
	},
	fish_store_page: {
		desc: "Here you can sell your catch for designated prices. Use the filter options to quickly find specific fish by name or adjust price ranges. Get the best value for your efforts and keep your inventory fresh",
		amount: "Amount",
		sell_button: "Sell fish",
		sell_all_button: "Sell all fishes",
		filters: {
			title: "Filters",
			name_placeholder: "Filter by name",
			name: "Name:",
			price: "Price:",
			min: "Min:",
			max: "Max:",
			only_owned: "Owned Only:",
			filter_btn: "Filter",
		},
		others_tab: "Others",
	},
	fishing_game: {
		get_ready: "Get ready to hook the fish!",
		hook_fish: "Press <strong>LMB</strong> to hook the fish!",
		instructions: {
			title: "INSTRUCTIONS",
			hook_command: "Action (hook/reel)",
			exit_fishing: "Exit fishing game",
		},
		progress_bar_labels: {
			tension: {
				low: "Low Tension",
				avg: "Optimal Tension",
				max: "High Tension",
			},
			progress: {
				low: "Just Started",
				avg: "Making Progress",
				max: "Almost Caught",
			},
		},
		fish_details: {
			rarity: {
				common: "Common",
				uncommon: "Uncommon",
				rare: "Rare",
				legendary: "Legendary",
				mythic: "Mythic",
			},
			weight: "Weight",
			exp: "EXP",
			price: "Price",
			keep: "Keep",
			release: "Release",
			illegal: "Illegal",
		},
	},
};