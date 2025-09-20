CreateThread(function()
    exports['qb-target']:AddGlobalPlayer({
        options = {
            {
                type = "client",
                icon = 'fas fa-money-bill',
                label = 'Billing Player',
                action = function(entity)
                    ExecuteCommand('invoices')
                end,
                distance = 1.5
            },
        }
    })
end)
