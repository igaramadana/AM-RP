if true then return end
-- admin commands
/spawn_fish [name] [jumlah?] [tipe?]
untuk spawn fish/fishitem

name = nama ikan / item (wajib)
jumlah? = jumlah ikan / item (opsional)
tipe? = ikan / fishitem (opsional)

/createtournament [starting] [duration]
untuk membuat turnamen sekarang juga

starting? = akan dimulai sampai kapan? (opsional, default akan mengikuti config)
duration? = berapa lama turnamen akan berlangsung? (opsional, default akan mengikuti config)

/degradeproperty
untuk mengurangi semua stock condition

/generate_dive
Tambahkan kontrak diving

/generate_delivery
Tambahkan kontrak deliveries

-- database masukkan file sql yg ada di dalam folder stevid_ikanv2

-- pastikan untuk cek Config.FW pada stevid_ikanv2 dan Config file pada script stevid_utils