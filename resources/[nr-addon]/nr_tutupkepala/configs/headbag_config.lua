wx = {}

wx.useTarget = true 
wx.removeHeadbagOnRespawn = true

wx.Locale = { 
    HeadbagTarget = "Gunakan Karung Penutup Kepala",
    ContextTitle = "Headbag Menu",
    ContextPutOn = "Pakai Karung Penutup Kepala",
    ContextDescPutOn = "Gunakan Karung Penutup Kepala Dan Pakaikan Ke orang Lain",
    ContextTakeOff = "Melepas Karung Penutup Kepala",
    ContextDescTakeOff = "Mencopot Karung Penutup Kepala Pada Orang Terdekat",
    NotifyTitle = "Karung Penutup Kepala",
    NotifyPutOn = "Kamu Memakaikan Karung Penutup Kepala Ke Orang Lain",
    NotifyTookOff = "Seseorang Mencopot Karung Penutup Kepala Pada Dirimu",
    NotifyAlreadyOn = "Orang Ini Sudah Tertutup Karung",
    NotifyNoOneNearby = "Tidak Ada Orang Disekitar",
    NotifyNoHeadbag = "Kamu Tidak Memiliki Karung Penutup Kepala",
    Unpacking = "Unpacking headbag...",
}

function Notification(title,desc)
    lib.notify({
        title = title,
        description = desc,
        position = 'top',
        style = {
            backgroundColor = '#1E1E2E',
        },
        icon = 'masks-theater',
    })
end