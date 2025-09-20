CreateThread(function()
    exports['qb-target']:AddGlobalPlayer({
        options = {
            -- {
            --     type = "client",
            --     icon = 'fas fa-hands',
            --     label = 'Carry',
            --     action = function(entity)
            --         ExecuteCommand('carry')
            --     end,
            --     distance = 1.5
            -- },
            {
                type = "client",
                icon = 'fas fa-hands',
                label = 'Gendong',
                action = function(entity)
                    ExecuteCommand('carry3')
                end,
                distance = 2
            },
            -- {
            --     type = "client",
            --     icon = 'fas fa-hands',
            --     label = 'Carry 3',
            --     action = function(entity)
            --         ExecuteCommand('carry3')
            --     end,
            --     distance = 1.5
            -- }
        }
    })
end)
