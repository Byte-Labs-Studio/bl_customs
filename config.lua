return {
    moneyType = 'cash',
    locations = {
        {
            pos = vector4(727.74, -1088.95, 22.17, 90.0),
            blip = { sprite = 72, color = 1, shortRange = true, label = 'Customs' },
            mods = {
                decals = true,
                paint = true,
            },
            free = true,
            group = {
                mechanic = 0 -- [job] = [grade]
            },
            classes = {18}
        },

        { pos = vector4(-206.109, -1328.886, 30.67899, 90.0), blip = { sprite = 72, color = 1, shortRange = true, label = 'Customs' } },
        { pos = vector4(868.22, -1350.14, 25.97, 90.0),       blip = { sprite = 72, color = 1, shortRange = true, label = 'Customs' } },
        { pos = vector4(450.25, -975.71, 25.7, 90.0),         blip = { sprite = 72, color = 1, shortRange = true, label = 'Customs' } },
        { pos = vector4(110.8, 6626.46, 31.89, 90.0),         blip = { sprite = 72, color = 1, shortRange = true, label = 'Customs' } },
        { pos = vector4(1695.14, 3588.98, 35.29, 90.0),       blip = { sprite = 72, color = 1, shortRange = true, label = 'Customs' } },
        { pos = vector4(-1269.103, -3376.59, 13.94014, 90.0), blip = { sprite = 72, color = 1, shortRange = true, label = 'Customs' } },
    },
    colors = {
        cam = {
            dashboard = { angle = vec2(0.375, 25.875), off = vec3(0.199988, 0.000024, 0.800000) },
            wheels = { angle = vec2(87.125, 2.375), off = vec3(-1.000012, 2.100049, 0.100000) },
        },
        types = {
            'Primary',
            'Secondary',
            'Dashboard',
            'Interior',
            'Wheels',
            'Pearlescent',
            'Neon',
            'Tyre Smoke',
            'Xenon Lights',
            'Window Tint'
        },
        paints = {
            'Metallic',
            'Matte',
            'Metal',
            'Chrome',
            'Chameleon'
        },
        color = {
            Neons = {
                { label = 'Left',   id = 0,            selected = true, price = 200,  toggle = true },
                { label = 'Right ', id = 1,            price = 200,     toggle = true },
                { label = 'Front ', id = 2,            price = 200,     toggle = true },
                { label = 'Back',   id = 3,            price = 200,     toggle = true },
                { label = 'Colors', id = 'Neon Colors' },
            },
            WindowsTint = {
                { price = 200, label = "Default",    id = 0 },
                { price = 200, label = "Lightsmoke", id = 3 },
                { price = 200, label = "Darksmoke",  id = 2 },
                { price = 200, label = "Pure Black", id = 1 },
            },
            TyreSmoke = {
                { price = 200, label = "White",         rgb = { 222, 222, 255 } },
                { price = 200, label = "Blue ",         rgb = { 2, 21, 255 } },
                { price = 200, label = "Electric Blue", rgb = { 3, 83, 255 } },
                { price = 200, label = "Mint Green",    rgb = { 0, 255, 140 } },
                { price = 200, label = "Lime Green",    rgb = { 94, 255, 1 } },
                { price = 200, label = "Yellow",        rgb = { 255, 255, 0 } },
                { price = 200, label = "Golden Shower", rgb = { 255, 150, 0 } },
                { price = 200, label = "Orange",        rgb = { 255, 62, 0 } },
                { price = 200, label = "Red",           rgb = { 255, 1, 1 } },
                { price = 200, label = "Pony Pink",     rgb = { 255, 50, 100 } },
                { price = 200, label = "Hot Pink",      rgb = { 255, 5, 190 } },
                { price = 200, label = "Purple",        rgb = { 35, 1, 255 } },
                { price = 200, label = "Blacklight",    rgb = { 15, 3, 255 } },
            },
            Xenon = {
                { price = 200, label = "Default",       id = -1 },
                { price = 200, label = "White",         id = 0 },
                { price = 200, label = "Blue ",         id = 1 },
                { price = 200, label = "Electric Blue", id = 2 },
                { price = 200, label = "Mint Green",    id = 3 },
                { price = 200, label = "Lime Green",    id = 4 },
                { price = 200, label = "Yellow",        id = 5 },
                { price = 200, label = "Golden Shower", id = 6 },
                { price = 200, label = "Orange",        id = 7 },
                { price = 200, label = "Red",           id = 8 },
                { price = 200, label = "Pony Pink",     id = 9 },
                { price = 200, label = "Hot Pink",      id = 10 },
                { price = 200, label = "Purple",        id = 11 },
                { price = 200, label = "Blacklight",    id = 12 },
            },
            Chrome = {
                { price = 200, label = "Chrome", id = 120 },
            },
            Matte = {
                { price = 200, label = "Black",           id = 12 },
                { price = 200, label = "Gray",            id = 13 },
                { price = 200, label = "Light Gray",      id = 14 },
                { price = 200, label = "Ice White",       id = 131 },
                { price = 200, label = "Blue",            id = 83 },
                { price = 200, label = "Dark Blue",       id = 82 },
                { price = 200, label = "Midnight Blue",   id = 84 },
                { price = 200, label = "Midnight Purple", id = 149 },
                { price = 200, label = "Schafter Purple", id = 148 },
                { price = 200, label = "Red",             id = 39 },
                { price = 200, label = "Dark Red",        id = 40 },
                { price = 200, label = "Orange",          id = 41 },
                { price = 200, label = "Yellow",          id = 42 },
                { price = 200, label = "Lime Green",      id = 55 },
                { price = 200, label = "Green",           id = 128 },
                { price = 200, label = "Forest Green",    id = 151 },
                { price = 200, label = "Foliage Green",   id = 155 },
                { price = 200, label = "Olive Darb",      id = 152 },
                { price = 200, label = "Dark Earth",      id = 153 },
                { price = 200, label = "Desert Tan",      id = 154 }
            },
            Metal = {
                { price = 200, label = "Brushed Steel",       id = 117 },
                { price = 200, label = "Brushed Black Steel", id = 118 },
                { price = 200, label = "Brushed Aluminium",   id = 119 },
                { price = 200, label = "Pure Gold",           id = 158 },
                { price = 200, label = "Brushed Gold",        id = 159 }
            },
            Metallic = {
                { price = 200, label = "Black",            id = 0 },
                { price = 200, label = "Carbon Black",     id = 147 },
                { price = 200, label = "Graphite",         id = 1 },
                { price = 200, label = "Anhracite Black",  id = 11 },
                { price = 200, label = "Black Steel",      id = 11 },
                { price = 200, label = "Dark Steel",       id = 3 },
                { price = 200, label = "Silver",           id = 4 },
                { price = 200, label = "Bluish Silver",    id = 5 },
                { price = 200, label = "Rolled Steel",     id = 6 },
                { price = 200, label = "Shadow Silver",    id = 7 },
                { price = 200, label = "Stone Silver",     id = 8 },
                { price = 200, label = "Midnight Silver",  id = 9 },
                { price = 200, label = "Cast Iron Silver", id = 10 },
                { price = 200, label = "Red",              id = 27 },
                { price = 200, label = "Torino Red",       id = 28 },
                { price = 200, label = "Formula Red",      id = 29 },
                { price = 200, label = "Lava Red",         id = 150 },
                { price = 200, label = "Blaze Red",        id = 30 },
                { price = 200, label = "Grace Red",        id = 31 },
                { price = 200, label = "Garnet Red",       id = 32 },
                { price = 200, label = "Sunset Red",       id = 33 },
                { price = 200, label = "Cabernet Red",     id = 34 },
                { price = 200, label = "Wine Red",         id = 143 },
                { price = 200, label = "Candy Red",        id = 35 },
                { price = 200, label = "Hot Pink",         id = 135 },
                { price = 200, label = "Pfsiter Pink",     id = 137 },
                { price = 200, label = "Salmon Pink",      id = 136 },
                { price = 200, label = "Sunrise Orange",   id = 36 },
                { price = 200, label = "Orange",           id = 38 },
                { price = 200, label = "Bright Orange",    id = 138 },
                { price = 200, label = "Gold",             id = 99 },
                { price = 200, label = "Bronze",           id = 90 },
                { price = 200, label = "Yellow",           id = 88 },
                { price = 200, label = "Race Yellow",      id = 89 },
                { price = 200, label = "Dew Yellow",       id = 91 },
                { price = 200, label = "Dark Green",       id = 49 },
                { price = 200, label = "Racing Green",     id = 50 },
                { price = 200, label = "Sea Green",        id = 51 },
                { price = 200, label = "Olive Green",      id = 52 },
                { price = 200, label = "Bright Green",     id = 53 },
                { price = 200, label = "Gasoline Green",   id = 54 },
                { price = 200, label = "Lime Green",       id = 92 },
                { price = 200, label = "Midnight Blue",    id = 141 },
                { price = 200, label = "Galaxy Blue",      id = 61 },
                { price = 200, label = "Dark Blue",        id = 62 },
                { price = 200, label = "Saxon Blue",       id = 63 },
                { price = 200, label = "Blue",             id = 64 },
                { price = 200, label = "Mariner Blue",     id = 65 },
                { price = 200, label = "Harbor Blue",      id = 66 },
                { price = 200, label = "Diamond Blue",     id = 67 },
                { price = 200, label = "Surf Blue",        id = 68 },
                { price = 200, label = "Nautical Blue",    id = 69 },
                { price = 200, label = "Racing Blue",      id = 73 },
                { price = 200, label = "Ultra Blue",       id = 70 },
                { price = 200, label = "Light Blue",       id = 74 },
                { price = 200, label = "Chocolate Brown",  id = 96 },
                { price = 200, label = "Bison Brown",      id = 101 },
                { price = 200, label = "Creeen Brown",     id = 95 },
                { price = 200, label = "Feltzer Brown",    id = 94 },
                { price = 200, label = "Maple Brown",      id = 97 },
                { price = 200, label = "Beechwood Brown",  id = 103 },
                { price = 200, label = "Sienna Brown",     id = 104 },
                { price = 200, label = "Saddle Brown",     id = 98 },
                { price = 200, label = "Moss Brown",       id = 100 },
                { price = 200, label = "Woodbeech Brown",  id = 102 },
                { price = 200, label = "Straw Brown",      id = 99 },
                { price = 200, label = "Sandy Brown",      id = 105 },
                { price = 200, label = "Bleached Brown",   id = 106 },
                { price = 200, label = "Schafter Purple",  id = 71 },
                { price = 200, label = "Spinnaker Purple", id = 72 },
                { price = 200, label = "Midnight Purple",  id = 142 },
                { price = 200, label = "Bright Purple",    id = 145 },
                { price = 200, label = "Cream",            id = 107 },
                { price = 200, label = "Ice White",        id = 111 },
                { price = 200, label = "Frost White",      id = 112 }
            },
            Chameleon = {
                { price = 200, label = "Anodized Red Pearl",         id = 161 },
                { price = 200, label = "Anodized Wine Pearl",        id = 162 },
                { price = 200, label = "Anodized Purple Pearl",      id = 163 },
                { price = 200, label = "Anodized Blue Pearl",        id = 164 },
                { price = 200, label = "Anodized Green Pearl",       id = 165 },
                { price = 200, label = "Anodized Lime Pearl",        id = 166 },
                { price = 200, label = "Anodized Copper Pearl",      id = 167 },
                { price = 200, label = "Anodized Bronze Pearl",      id = 168 },
                { price = 200, label = "Anodized Champagne Pearl",   id = 169 },
                { price = 200, label = "Anodized Gold Pearl",        id = 170 },
                { price = 200, label = "Green/Blue Flip",            id = 171 },
                { price = 200, label = "Green/Red Flip",             id = 172 },
                { price = 200, label = "Green/Brown Flip",           id = 173 },
                { price = 200, label = "Green/Turquoise Flip",       id = 174 },
                { price = 200, label = "Green/Purple Flip",          id = 175 },
                { price = 200, label = "Teal/Purple Flip",           id = 176 },
                { price = 200, label = "Turquoise/Red Flip",         id = 177 },
                { price = 200, label = "Turquoise/Purple Flip",      id = 178 },
                { price = 200, label = "Cyan/Purple Flip",           id = 179 },
                { price = 200, label = "Blue/Pink Flip",             id = 180 },
                { price = 200, label = "Blue/Green Flip",            id = 181 },
                { price = 200, label = "Purple/Red Flip",            id = 182 },
                { price = 200, label = "Purple/Green Flip",          id = 183 },
                { price = 200, label = "Magenta/Green Flip",         id = 184 },
                { price = 200, label = "Magenta/Yellow Flip",        id = 185 },
                { price = 200, label = "Burgundy/Green Flip",        id = 186 },
                { price = 200, label = "Magenta/Cyan Flip",          id = 187 },
                { price = 200, label = "Copper/Purple Flip",         id = 188 },
                { price = 200, label = "Magenta/Orange Flip",        id = 189 },
                { price = 200, label = "Red/Orange Flip",            id = 190 },
                { price = 200, label = "Orange/Purple Flip",         id = 191 },
                { price = 200, label = "Orange/Blue Flip",           id = 192 },
                { price = 200, label = "White/Purple Flip",          id = 193 },
                { price = 200, label = "Red/Rainbow Flip",           id = 194 },
                { price = 200, label = "Blue/Rainbow Flip",          id = 195 },
                { price = 200, label = "Dark Green Pearl",           id = 196 },
                { price = 200, label = "Dark Teal Pearl",            id = 197 },
                { price = 200, label = "Dark Blue Pearl",            id = 198 },
                { price = 200, label = "Dark Purple Pearl",          id = 199 },
                { price = 200, label = "Oil Slick Pearl",            id = 200 },
                { price = 200, label = "Light Green Pearl",          id = 201 },
                { price = 200, label = "Light Blue Pearl",           id = 202 },
                { price = 200, label = "Light Purple Pearl",         id = 203 },
                { price = 200, label = "Light Pink Pearl",           id = 204 },
                { price = 200, label = "Off White Pearl",            id = 205 },
                { price = 200, label = "Cute Pink Pearl",            id = 206 },
                { price = 200, label = "Baby Yellow Pearl",          id = 207 },
                { price = 200, label = "Baby Green Pearl",           id = 208 },
                { price = 200, label = "Baby Blue Pearl",            id = 209 },
                { price = 200, label = "Cream Pearl",                id = 210 },
                { price = 200, label = "White Prismatic Pearl",       id = 211 },
                { price = 200, label = "Graphite Prismatic Pearl",    id = 212 },
                { price = 200, label = "Blue Prismatic Pearl",        id = 213 },
                { price = 200, label = "Purple Prismatic Pearl",      id = 214 },
                { price = 200, label = "Hot Pink Prismatic Pearl",    id = 215 },
                { price = 200, label = "Red Prismatic Pearl",         id = 216 },
                { price = 200, label = "Green Prismatic Pearl",       id = 217 },
                { price = 200, label = "Black Prismatic Pearl",       id = 218 },
                { price = 200, label = "Oil Spill Prismatic Pearl",   id = 219 },
                { price = 200, label = "Rainbow Prismatic Pearl",     id = 220 },
                { price = 200, label = "Black Holographic Pearl",     id = 221 },
                { price = 200, label = "White Holographic Pearl",     id = 222 },
                { price = 200, label = "YKTA Monochrome",             id = 223 },
                { price = 200, label = "YKTA Night & Day",            id = 224 },
                { price = 200, label = "YKTA The Verlierer",          id = 225 },
                { price = 200, label = "YKTA Sprunk Extreme",         id = 226 },
                { price = 200, label = "YKTA Vice City",              id = 227 },
                { price = 200, label = "YKTA Synthwave Night",        id = 228 },
                { price = 200, label = "YKTA Four Seasons",           id = 229 },
                { price = 200, label = "YKTA M9 Throwback",           id = 230 },
                { price = 200, label = "YKTA Bubblegum",              id = 231 },
                { price = 200, label = "YKTA Full Rainbow",           id = 232 },
                { price = 200, label = "YKTA Sunset",                 id = 233 },
                { price = 200, label = "YKTA The Seven",              id = 234 },
                { price = 200, label = "YKTA Kamen Rider",            id = 235 },
                { price = 200, label = "YKTA Chromatic",              id = 236 },
                { price = 200, label = "YKTA Christmas",              id = 237 },
                { price = 200, label = "YKTA Temperature",            id = 238 },
                { price = 200, label = "YKTA HSW Badge",              id = 239 },
                { price = 200, label = "YKTA Electro",                id = 240 },
                { price = 200, label = "YKTA Monika",                 id = 241 },
                { price = 200, label = "YKTA Fubuki",                 id = 242 },
            }
        }
    },
    wheels = {
        Sport = { id = 0, price = 2000 },
        Muscle = { id = 1, price = 2000 },
        Lowrider = { id = 2, price = 2000 },
        Suv = { id = 3, price = 2000 },
        Offroad = { id = 4, price = 2000 },
        Tuner = { id = 5, price = 2000 },
        Bike = { id = 6, price = 2000 },
        Hiend = { id = 7, price = 2000 },
        ['Benny\'s Original'] = { id = 8, price = 2000 }, -- Benny's Original
        ['Benny\'s Bespoke'] = { id = 9, price = 2000 },  -- Benny's Bespoke
        ['Open Wheel'] = { id = 10, price = 2000 },       -- Open Wheel
        ['Street'] = { id = 11, price = 2000 },           -- Street
        ['Track'] = { id = 12, price = 2000 },            -- Track
    },
    -- highest price | means the last mod of spoiler (for ex) gonna cost $2000 / if you want to make the price higher or lower just increase price then all spoiler mods gonna price increase
    decals = {
        Spoiler = {
            id = 0,
            price = 2000,
            cam = { angle = vec2(-38.25, 12.62), off = vec3(2.800061, -1.699902, 1.000000) },
            --blacklist = {'sultan'}
        },
        Skirt = {
            id = 3,
            price = 2000,
            cam = { angle = vec2(96.375, 12.125), off = vec3(-0.200012, 2.700024, 0.100000) }
        },
        Exhaust = {
            id = 4,
            price = 2000,
            cam = { angle = vec2(-0.875, 7.87), off = vec3(3.099988, 0.000073, 0.000000) }
        },
        Chassis = {
            id = 5,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Grill = {
            id = 6,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-2.900037, 0.000049, 0.300000) }
        },
        Bonnet = {
            id = 7,
            price = 2000,
            cam = { angle = vec2(163.5, 19.635), off = vec3(-2.900012, 0.700024, 1.300000) }
        },
        Wing = {
            id = 8,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(2.599976, 1.800000, 1.600000) }
        },
        Roof = {
            id = 10,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-0.700049, 0.899951, 1.900000) }
        },
        Horn = {
            id = 14,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Nitrous = {
            id = 17,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Subwoofer = {
            id = 19,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Seats = {
            id = 32,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Turbo = {
            id = 18,
            price = 0,
            toggle = true,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Steering = {
            id = 33,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(0.100012, -0.300000, 0.600001) }
        },
        Knob = {
            id = 34,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Plaque = {
            id = 35,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Ice = {
            id = 36,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Trunk = {
            id = 37,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Hydro = {
            id = 38,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        Lightbar = {
            id = 49,
            price = 2000,
            cam = { angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000) }
        },
        ['Enginebay 1'] = {
            id = 39,
            price = 2000,
            cam = {
                door = 4,
                angle = vec2(127.125, 33.0),
                off = vec3(-2.400012, 0.000024, 1.000000)
            }
        },

        ['Engine Upgrades'] = {
            id = 11,
            labels = {
                [0] = {label = 'Engine lvl 1', price = 200},
                [1] = {label = 'Engine lvl 2', price = 200},
                [2] = {label = 'Engine lvl 3', price = 200},
                [3] = {label = 'Engine lvl 4', price = 200},
                [4] = {label = 'Engine lvl 5', price = 200},
            }
        },
        ['Brakes Upgrades'] = {
            id = 12,
            labels = {
                [0] = {label = 'Brakes lvl 1', price = 200},
                [1] = {label = 'Brakes lvl 2', price = 200},
                [2] = {label = 'Brakes lvl 3', price = 200},
                [3] = {label = 'Brakes lvl 4', price = 200},
                [4] = {label = 'Brakes lvl 5', price = 200},
            },
        },
        ['Armour Upgrades'] = {
            id = 16,
            labels = {
                [0] = {label = 'Armour lvl 1', price = 200},
                [1] = {label = 'Armour lvl 2', price = 200},
                [2] = {label = 'Armour lvl 3', price = 200},
                [3] = {label = 'Armour lvl 4', price = 200},
                [4] = {label = 'Armour lvl 5', price = 200},
            },
        },

        ['Enginebay 2'] = {
            id = 40,
            price = 2000,
            cam = {
                door = 4,
                angle = vec2(127.125, 33.0),
                off = vec3(-2.400012, 0.000024, 1.000000)
            }
        },
        ['Enginebay 3'] = {
            id = 41,
            price = 2000,
            cam = {
                door = 4,
                angle = vec2(127.125, 33.0),
                off = vec3(-2.400012, 0.000024, 1.000000)
            }
        },
        ['Chassis 2'] = {
            id = 42,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-2.400012, 1.200024, 0.600000)
            }
        },
        ['Chassis 3'] = {
            id = 43,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-2.900012, -0.099976, 0.600000)
            }
        },
        ['Chassis 4'] = {
            id = 44,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-0.800012, 1.000024, 1.400000)
            }
        },
        ['Chassis 5'] = {
            id = 45,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-3.100024, 0.800024, 0.000000)
            }
        },
        ['L Door'] = {
            id = 46,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-3.200000, 3.400000, 2.100000)
            }
        },
        ['R Door'] = {
            id = 47,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-3.200000, 3.400000, 2.100000)
            }
        },
        ['Livery Mod'] = {
            id = 48,
            price = 2000,
            cam = {
                angle = vec2(130.5, 19.125),
                off = vec3(-3.200000, 3.400000, 2.100000)
            }
        },
        ['Front Bumper'] = {
            id = 1,
            price = 2000,
            cam = {
                angle = vec2(157.75, 1.125),
                off = vec3(-3.100024, 0.800024, 0.000000)
            }
        },
        ['Rear Bumper'] = {
            id = 2,
            price = 2000,
            cam = {
                angle = vec2(-3.25, 0.0),
                off = vec3(3.900037, 0.000073, 0.100000)
            }
        },
        ['Wing 2'] = {
            id = 9,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(2.199975, 0.200000, 1.600000)
            }
        },
        ['Old Livery'] = {
            id = 24,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-3.200000, 3.400000, 2.100000)
            }
        },
        ['Plate holder'] = {
            id = 25,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-3.100024, 0.800024, 0.000000)
            }
        },
        ['Plate vanity'] = {
            id = 26,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-2.900037, 0.000049, 0.300000)
            }
        },
        ['Interior 1'] = {
            id = 27,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-3.200000, 3.400000, 2.100000)
            }
        },
        ['Interior 2'] = {
            id = 28,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-3.200000, 3.400000, 2.100000)
            }
        },
        ['Interior 3'] = {
            id = 29,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(-1.000012, 2.800025, 1.400000)
            }
        },
        ['Interior 4'] = {
            id = 30,
            price = 2000,
            cam = {
                angle = vec2(127.125, 33.0),
                off = vec3(0.199988, 0.000024, 0.700000)
            }
        },
        ['Interior 5'] = {
            id = 31,
            price = 2000,
            cam = {
                door = 0,
                angle = vec2(127.125, 33.0),
                off = vec3(0.399988, -1.199976, 0.400000)
            }
        },
        ['Plate Index'] = {
            id = 51,
            price = 2000,
            cam = {
                angle = vec2(178.62, 17.25),
                off = vec3(-2.900037, 0.000049, 0.300000)
            },
            data = {
                getter = GetVehicleNumberPlateTextIndex,
                mods = {
                    { label = 'Blue/White',   id = 0, price = 200 },
                    { label = 'Yellow/black', id = 1, price = 200 },
                    { label = 'Yellow/Blue',  id = 2, price = 200 },
                    { label = 'Blue/White2',  id = 3, price = 200 },
                    { label = 'Blue/White3',  id = 4, price = 200 },
                    { label = 'Yankton',      id = 5, price = 200 },
                }
            }
        },
        ['Gearbox'] = {
            id = 13,
            labels = {
                [0] = {label = 'Gearbox lvl 1', price = 0},
                [1] = {label = 'Gearbox lvl 2', price = 0},
                [2] = {label = 'Gearbox lvl 3', price = 0},
                [3] = {label = 'Gearbox lvl 4', price = 0},
            },
        },
        ['Suspension'] = {
            id = 15,
            cam = { angle = vec2(96.375, 12.125), off = vec3(-0.200012, 2.700024, 0.100000) },
            labels = {
                [0] = {label = 'Suspension lvl 1', price = 0},
                [1] = {label = 'Suspension lvl 2', price = 0},
                [2] = {label = 'Suspension lvl 3', price = 0},
                [3] = {label = 'Suspension lvl 4', price = 0},
            },
        },
        --Tyre_smoke =              {id = 20, price = 2000, cam = {angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000)}},
        --Hydraulics =              {id = 21, price = 2000, cam = {angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000)}},
        --Xenon_lights =            {id = 22, price = 2000, cam = {angle = vec2(127.125, 33.0), off = vec3(-3.200000, 3.400000, 2.100000)}},

    }
}