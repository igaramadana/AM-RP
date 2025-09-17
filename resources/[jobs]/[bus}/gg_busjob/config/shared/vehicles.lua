cfg = cfg or {}


cfg.vehicles = {
    {                   -- Default Bus
        id    = "coach",   -- id/vehicle spawncode
        label = "Coach",
        image = "vehicles/coach.png", -- We store images locally if you prefer online images put direct path here.
        level = 1,
        price = 0,
        seats = 8,
    },
    {
        id    = "bus",
        label = "Bus",
        image = "vehicles/bus.png",
        level = 6,
        price = 1000,
        seats = 14,
    },
    {
        id    = "airbus",
        label = "Air Bus",
        image = "vehicles/airbus.png",
        level = 6,
        price = 1000,
        seats = 14,
    },
}