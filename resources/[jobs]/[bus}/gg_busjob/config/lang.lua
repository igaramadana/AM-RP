lang = {}
--  lang:get("noti_stop_working")
lang.translations = {
    gg = "[WARN] Placeholder Text Form: %s", -- Placeholder Text Ignore

    noti_bus_despawn = 'Job Abandoned, return to bus depot to work again.',
    noti_tip_add = 'You received a tip of $%s',
    noti_route_complete = 'Route complete. You’ve been paid. A new route is ready — drive to the next stop or return to the depot anytime to clock out.',
    noti_seats_req = 'Your bus does not have enough seats for this route.',

    popup_next_stop = 'Proceed to the next bus stop.',
    popup_bus_remove = 'Bus will be removed in %s seconds. Enter the bus.',
    popup_bus_remove_02 = 'Enter the bus.',
    popup_stop_bus = 'Stop at the bus stop.',
    popup_board_bus = 'Wait for passengers to board and offboard.',

    target_gc_su = "Swap Uniform",

    nav_overview = 'Overview',
    nav_progress = 'Progress',
    nav_vehicles = 'Vehicles',    
    nav_jobs = 'Jobs',
    nav_riders = 'Riders Log',
    nav_leaderboard = 'Leaderboards',

    leaderboard_mostexperience = 'Most Experience',
    leaderboard_mostjobs = 'Routes Completed',

    unlocks_vehicle = 'Unlock Bus',
    unlocks_route = 'Unlock Route',

    waypoint_destination = "Destination",

    -- Defaults
    default_inventory_additem = "Could not add item",
    default_inventory_removeitem = "Could not remove item",
    default_money_addmoney = "Could not Add Money",
    default_money_removemoney = "Could Not Afford Purchase",
    default_error = "Failed to do this",
}


lang.ui_translations = {
    util_close_btn = "Close",
    util_esc_btn = "ESC",
    util_xp = "XP",
    util_money = "Money",
    util_experience = "Experience",
    util_level = "Level",
    util_lvl = "Lvl",

    overview_level_progress = "Progress ot Next Level",
    overview_daily_experience = "Experience Gained Today",
    overview_daily_money = "Money Earned Today",
    overview_daily_jobs = "Routes Completed Today",
    overview_claim_reward_packages_title = "Jobs Completed to Reward",
    overview_claim_reward_title = "Claim Reward",
    overview_claim_reward_desc = "Click The Present at Top Left",
    overview_claim_reward_title2 = "Reward Claimed",
    overview_claim_reward_desc2 = "Enjoy your reward!",
    overview_reward_item = "Item",

    progress_current_level = "Current Level Progress",
    progress_level = "Level:",
    progress_money_bonus = "Experience Bonus",
    progress_money_bonus2 = "Bonus Experience",
    progress_exp_bonus = "Money Bonus",
    progress_exp_bonus2 = "Bonus Money",
    progress_new_unlocks = "New Unlocks",
    progress_bonus_multi = "Bonus Multipliers",

    leaderboards_header_pname = "Player Names",
    leaderboards_right_yourplacement = "Your Placement",
    leaderboards_rank = "Rank",

    jobs_route_info_title = "View Route Information",
    jobs_route_info_desc = "Select a route to view details and get started!",
    jobs_route_reward_title = "Route Rewards",
    jobs_route_req_title = "Route Requirements",
    jobs_route_req_01 = "Required Seats",
    jobs_route_req_02 = "Required Level",
    jobs_route_start = "Start Route",
    jobs_route_cancel = "End Route",
    jobs_route_error_01 = "Your bus does not have sufficient capacity for this route please select a larger bus.",
    jobs_route_error_02 = "Too Low of Level",
    jobs_locked = "Locked",
    jobs_active = "Active",

    riders_rides = "Rides",
    riders_unknown = "Unknown",

    vehicles_seats = "Seats",
    vehicles_owned = "Owned",
    vehicles_purchase = "Purchase",
    vehicles_select = "Select",
    vehicles_selected = "Selected"
}


-- IGNORE CODE BELOW
function lang:get(key, ...)
    local translation = self.translations[key]
    if not translation then
        return "Translation not found for key: " .. key
    end
    return string.format(translation, ...)
end