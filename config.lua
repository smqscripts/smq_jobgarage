Config = {}

Config.Locale = 'en'
Config.KeyItem = 'vehicle_key'

Config.Garages = {
    -- POLICE
    ['police_car'] = {
        label = "Mission Row PD",
        job = "police",
        type = "car", 
        ped = { model = `s_m_y_cop_01`, coords = vector4(441.8702, -981.9225, 25.7097, 182.84) },
        spawnPoint = vector4(435.8932, -984.9636, 25.7097, 182.8422),
        shopVehicles = {
            { label = "Benefactor GLX (Police)", model = "police" },
            { label = "Vapid Stanier (Police)", model = "police" },
            { label = "Vapid Stanier Custom", model = "police" },
        }
    },
    ['police_air'] = {
        label = "Mission Row PD",
        job = "police",
        type = "air", 
        ped = { model = `s_m_y_cop_01`, coords = vector4(440.6642, -973.3429, 43.6916, 93.34) },
        spawnPoint = vector4(449.3820, -981.1480, 43.6913, 93.3438),
        shopVehicles = {
            { label = "Maverick", model = "jcon" },
        }
    },

    -- AMBULANCE
    ['ems_car'] = {
        label = "Pillbox Hospital",
        job = "ambulance",
        type = "car",
        ped = { model = `s_m_m_doctor_01`, coords = vector4(359.6530, -570.0103, 28.8474, 71.89) },
        spawnPoint = vector4(353.3153, -564.6006, 28.8474, 71.8915),
        shopVehicles = {
            { label = "Vapid Ambulance", model = "ambulance" },
            { label = "Vapid Caracara (EMS)", model = "ambulance" },
            { label = "Bravado Buffalo STX (EMS)", model = "ambulance" },
        }
    },
    ['ems_air'] = {
        label = "Pillbox Hospital",
        job = "ambulance",
        type = "air",
        ped = { model = `s_m_m_doctor_01`, coords = vector4(340.1375, -581.3199, 74.1617, 356.08) },
        spawnPoint = vector4(351.8884, -589.0001, 74.1617, 356.0814),
        shopVehicles = {
            { label = "Maverick", model = "jcon" },
        }
    },
}