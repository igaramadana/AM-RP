gg.inventory = gg.inventory or {}

gg.inventory.getImageUrl = function(item)
    return string.format('https://cfx-nui-origen_inventory/html/images/%s.png', item)
end

gg.inventory.getImageDirectory = function()
    return 'https://cfx-nui-origen_inventory/html/images/'
end

gg.inventory.getItemTable = function(item)
    if not item then return nil end
    return gg.framework.getItemTable(item) or nil
end