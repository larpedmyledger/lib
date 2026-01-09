local Library = {}

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local function GetParent()
    if gethui then return gethui() end
    
    local success, _ = pcall(function() return CoreGui.Name end)
    if success then return CoreGui end
    
    return Player:WaitForChild("PlayerGui")
end

Library.Flags = {}
Library.Connections = {}
Library.MainFrames = {}
Library.ConfigFlags = {}
Library.CurrentElementOpen = nil
Library.Notifications = {}
Library.Sin = 0
Library.GuiOffset = 36
Library.ConfigDirectory = "uilib_configs"
Library.CurrentConfigName = nil
Library.AutoloadConfigName = nil
Library.AutoloadSettingsFile = "uilib_configs/autoload.txt"

Library.Theme = {
    Accent = Color3.fromRGB(100, 100, 255),
    Background = Color3.fromRGB(22, 22, 22),
    Outline = Color3.fromRGB(32, 32, 38),
    Border = Color3.fromRGB(8, 8, 8),
    Text = Color3.fromRGB(170, 170, 170),
    DarkText = Color3.fromRGB(90, 90, 90),
    UnselectedText = Color3.fromRGB(90, 90, 90)
}

-- Preset Themes
Library.PresetThemes = {
    ["Default"] = {
        Accent = Color3.fromRGB(100, 100, 255),
        Background = Color3.fromRGB(22, 22, 22),
        Outline = Color3.fromRGB(32, 32, 38),
        Border = Color3.fromRGB(8, 8, 8),
        Text = Color3.fromRGB(170, 170, 170),
        DarkText = Color3.fromRGB(90, 90, 90),
        UnselectedText = Color3.fromRGB(90, 90, 90)
    },
    ["Dark"] = {
        Accent = Color3.fromRGB(80, 80, 120),
        Background = Color3.fromRGB(15, 15, 15),
        Outline = Color3.fromRGB(25, 25, 25),
        Border = Color3.fromRGB(5, 5, 5),
        Text = Color3.fromRGB(180, 180, 180),
        DarkText = Color3.fromRGB(80, 80, 80),
        UnselectedText = Color3.fromRGB(80, 80, 80)
    },
    ["Light"] = {
        Accent = Color3.fromRGB(0, 120, 215),
        Background = Color3.fromRGB(240, 240, 240),
        Outline = Color3.fromRGB(200, 200, 200),
        Border = Color3.fromRGB(180, 180, 180),
        Text = Color3.fromRGB(40, 40, 40),
        DarkText = Color3.fromRGB(120, 120, 120),
        UnselectedText = Color3.fromRGB(120, 120, 120)
    },
    ["Midnight"] = {
        Accent = Color3.fromRGB(50, 150, 255),
        Background = Color3.fromRGB(10, 10, 15),
        Outline = Color3.fromRGB(20, 20, 25),
        Border = Color3.fromRGB(2, 2, 5),
        Text = Color3.fromRGB(180, 190, 200),
        DarkText = Color3.fromRGB(75, 80, 90),
        UnselectedText = Color3.fromRGB(75, 80, 90)
    },
    ["Moonlight"] = {
        Accent = Color3.fromRGB(180, 150, 255),
        Background = Color3.fromRGB(18, 18, 25),
        Outline = Color3.fromRGB(28, 28, 35),
        Border = Color3.fromRGB(6, 6, 10),
        Text = Color3.fromRGB(200, 200, 210),
        DarkText = Color3.fromRGB(95, 95, 100),
        UnselectedText = Color3.fromRGB(95, 95, 100)
    },
    ["Carbon"] = {
        Accent = Color3.fromRGB(100, 100, 100),
        Background = Color3.fromRGB(18, 18, 18),
        Outline = Color3.fromRGB(28, 28, 28),
        Border = Color3.fromRGB(8, 8, 8),
        Text = Color3.fromRGB(190, 190, 190),
        DarkText = Color3.fromRGB(90, 90, 90),
        UnselectedText = Color3.fromRGB(90, 90, 90)
    },
    ["Black"] = {
        Accent = Color3.fromRGB(60, 60, 60),
        Background = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(15, 15, 15),
        Border = Color3.fromRGB(0, 0, 0),
        Text = Color3.fromRGB(200, 200, 200),
        DarkText = Color3.fromRGB(100, 100, 100),
        UnselectedText = Color3.fromRGB(100, 100, 100)
    },
    ["Osiris"] = {
        Accent = Color3.fromRGB(255, 180, 0),
        Background = Color3.fromRGB(19, 19, 22),
        Outline = Color3.fromRGB(29, 29, 32),
        Border = Color3.fromRGB(7, 7, 9),
        Text = Color3.fromRGB(195, 195, 195),
        DarkText = Color3.fromRGB(95, 95, 95),
        UnselectedText = Color3.fromRGB(95, 95, 95)
    },
    ["Ev0lve"] = {
        Accent = Color3.fromRGB(255, 50, 100),
        Background = Color3.fromRGB(16, 16, 19),
        Outline = Color3.fromRGB(26, 26, 29),
        Border = Color3.fromRGB(4, 4, 6),
        Text = Color3.fromRGB(200, 180, 190),
        DarkText = Color3.fromRGB(90, 80, 85),
        UnselectedText = Color3.fromRGB(90, 80, 85)
    },
    ["Legendware"] = {
        Accent = Color3.fromRGB(120, 255, 200),
        Background = Color3.fromRGB(13, 13, 17),
        Outline = Color3.fromRGB(23, 23, 27),
        Border = Color3.fromRGB(3, 3, 5),
        Text = Color3.fromRGB(180, 200, 195),
        DarkText = Color3.fromRGB(80, 90, 88),
        UnselectedText = Color3.fromRGB(80, 90, 88)
    },
    ["Rifk7"] = {
        Accent = Color3.fromRGB(255, 120, 200),
        Background = Color3.fromRGB(20, 18, 24),
        Outline = Color3.fromRGB(30, 28, 34),
        Border = Color3.fromRGB(8, 6, 10),
        Text = Color3.fromRGB(200, 190, 205),
        DarkText = Color3.fromRGB(95, 90, 98),
        UnselectedText = Color3.fromRGB(95, 90, 98)
    },
    ["Crimson"] = {
        Accent = Color3.fromRGB(220, 20, 60),
        Background = Color3.fromRGB(20, 12, 15),
        Outline = Color3.fromRGB(30, 20, 25),
        Border = Color3.fromRGB(10, 5, 8),
        Text = Color3.fromRGB(200, 180, 185),
        DarkText = Color3.fromRGB(100, 80, 85),
        UnselectedText = Color3.fromRGB(100, 80, 85)
    },
    ["Scarlet"] = {
        Accent = Color3.fromRGB(255, 36, 0),
        Background = Color3.fromRGB(22, 15, 12),
        Outline = Color3.fromRGB(32, 25, 20),
        Border = Color3.fromRGB(12, 8, 5),
        Text = Color3.fromRGB(200, 185, 180),
        DarkText = Color3.fromRGB(100, 90, 85),
        UnselectedText = Color3.fromRGB(100, 90, 85)
    },
    ["Emerald"] = {
        Accent = Color3.fromRGB(80, 200, 120),
        Background = Color3.fromRGB(15, 22, 18),
        Outline = Color3.fromRGB(25, 32, 28),
        Border = Color3.fromRGB(8, 12, 10),
        Text = Color3.fromRGB(180, 200, 185),
        DarkText = Color3.fromRGB(85, 100, 90),
        UnselectedText = Color3.fromRGB(85, 100, 90)
    },
    ["Jade"] = {
        Accent = Color3.fromRGB(0, 168, 107),
        Background = Color3.fromRGB(12, 20, 16),
        Outline = Color3.fromRGB(20, 30, 26),
        Border = Color3.fromRGB(5, 10, 8),
        Text = Color3.fromRGB(180, 195, 185),
        DarkText = Color3.fromRGB(80, 95, 85),
        UnselectedText = Color3.fromRGB(80, 95, 85)
    },
    ["Mint"] = {
        Accent = Color3.fromRGB(152, 255, 152),
        Background = Color3.fromRGB(18, 25, 20),
        Outline = Color3.fromRGB(28, 35, 30),
        Border = Color3.fromRGB(10, 15, 12),
        Text = Color3.fromRGB(200, 220, 205),
        DarkText = Color3.fromRGB(95, 110, 100),
        UnselectedText = Color3.fromRGB(95, 110, 100)
    },
    ["Forest"] = {
        Accent = Color3.fromRGB(34, 139, 34),
        Background = Color3.fromRGB(10, 18, 10),
        Outline = Color3.fromRGB(18, 28, 18),
        Border = Color3.fromRGB(5, 10, 5),
        Text = Color3.fromRGB(180, 200, 180),
        DarkText = Color3.fromRGB(75, 95, 75),
        UnselectedText = Color3.fromRGB(75, 95, 75)
    },
    ["Sapphire"] = {
        Accent = Color3.fromRGB(15, 82, 186),
        Background = Color3.fromRGB(12, 15, 25),
        Outline = Color3.fromRGB(20, 25, 35),
        Border = Color3.fromRGB(5, 8, 15),
        Text = Color3.fromRGB(180, 190, 220),
        DarkText = Color3.fromRGB(80, 90, 110),
        UnselectedText = Color3.fromRGB(80, 90, 110)
    },
    ["Ocean"] = {
        Accent = Color3.fromRGB(0, 119, 182),
        Background = Color3.fromRGB(10, 18, 25),
        Outline = Color3.fromRGB(18, 28, 35),
        Border = Color3.fromRGB(5, 10, 15),
        Text = Color3.fromRGB(180, 200, 220),
        DarkText = Color3.fromRGB(75, 95, 110),
        UnselectedText = Color3.fromRGB(75, 95, 110)
    },
    ["Aqua"] = {
        Accent = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(12, 22, 25),
        Outline = Color3.fromRGB(20, 32, 35),
        Border = Color3.fromRGB(5, 12, 15),
        Text = Color3.fromRGB(200, 220, 230),
        DarkText = Color3.fromRGB(90, 110, 115),
        UnselectedText = Color3.fromRGB(90, 110, 115)
    },
    ["Cyan"] = {
        Accent = Color3.fromRGB(0, 200, 200),
        Background = Color3.fromRGB(15, 23, 25),
        Outline = Color3.fromRGB(25, 33, 35),
        Border = Color3.fromRGB(8, 13, 15),
        Text = Color3.fromRGB(190, 215, 220),
        DarkText = Color3.fromRGB(85, 105, 110),
        UnselectedText = Color3.fromRGB(85, 105, 110)
    },
    ["Amethyst"] = {
        Accent = Color3.fromRGB(153, 102, 204),
        Background = Color3.fromRGB(18, 15, 25),
        Outline = Color3.fromRGB(28, 25, 35),
        Border = Color3.fromRGB(10, 8, 15),
        Text = Color3.fromRGB(200, 190, 220),
        DarkText = Color3.fromRGB(95, 85, 110),
        UnselectedText = Color3.fromRGB(95, 85, 110)
    },
    ["Purple"] = {
        Accent = Color3.fromRGB(128, 0, 128),
        Background = Color3.fromRGB(18, 12, 22),
        Outline = Color3.fromRGB(28, 20, 32),
        Border = Color3.fromRGB(10, 5, 12),
        Text = Color3.fromRGB(200, 180, 210),
        DarkText = Color3.fromRGB(95, 80, 105),
        UnselectedText = Color3.fromRGB(95, 80, 105)
    },
    ["Violet"] = {
        Accent = Color3.fromRGB(148, 0, 211),
        Background = Color3.fromRGB(20, 12, 25),
        Outline = Color3.fromRGB(30, 20, 35),
        Border = Color3.fromRGB(12, 5, 15),
        Text = Color3.fromRGB(205, 180, 220),
        DarkText = Color3.fromRGB(100, 80, 110),
        UnselectedText = Color3.fromRGB(100, 80, 110)
    },
    ["Lavender"] = {
        Accent = Color3.fromRGB(181, 126, 220),
        Background = Color3.fromRGB(22, 20, 28),
        Outline = Color3.fromRGB(32, 30, 38),
        Border = Color3.fromRGB(12, 10, 18),
        Text = Color3.fromRGB(210, 200, 225),
        DarkText = Color3.fromRGB(105, 95, 115),
        UnselectedText = Color3.fromRGB(105, 95, 115)
    },
    ["Gold"] = {
        Accent = Color3.fromRGB(255, 215, 0),
        Background = Color3.fromRGB(25, 22, 12),
        Outline = Color3.fromRGB(35, 32, 20),
        Border = Color3.fromRGB(15, 12, 5),
        Text = Color3.fromRGB(220, 210, 180),
        DarkText = Color3.fromRGB(110, 100, 80),
        UnselectedText = Color3.fromRGB(110, 100, 80)
    },
    ["Amber"] = {
        Accent = Color3.fromRGB(255, 191, 0),
        Background = Color3.fromRGB(22, 20, 10),
        Outline = Color3.fromRGB(32, 30, 18),
        Border = Color3.fromRGB(12, 10, 5),
        Text = Color3.fromRGB(215, 205, 180),
        DarkText = Color3.fromRGB(105, 95, 80),
        UnselectedText = Color3.fromRGB(105, 95, 80)
    },
    ["Orange"] = {
        Accent = Color3.fromRGB(255, 140, 0),
        Background = Color3.fromRGB(22, 18, 12),
        Outline = Color3.fromRGB(32, 28, 20),
        Border = Color3.fromRGB(12, 10, 5),
        Text = Color3.fromRGB(210, 195, 180),
        DarkText = Color3.fromRGB(100, 90, 80),
        UnselectedText = Color3.fromRGB(100, 90, 80)
    },
    ["Sunset"] = {
        Accent = Color3.fromRGB(255, 120, 50),
        Background = Color3.fromRGB(25, 18, 15),
        Outline = Color3.fromRGB(35, 28, 25),
        Border = Color3.fromRGB(15, 10, 8),
        Text = Color3.fromRGB(220, 200, 190),
        DarkText = Color3.fromRGB(110, 95, 90),
        UnselectedText = Color3.fromRGB(110, 95, 90)
    },
    ["Dracula"] = {
        Accent = Color3.fromRGB(255, 121, 198),
        Background = Color3.fromRGB(40, 42, 54),
        Outline = Color3.fromRGB(68, 71, 90),
        Border = Color3.fromRGB(30, 32, 44),
        Text = Color3.fromRGB(248, 248, 242),
        DarkText = Color3.fromRGB(98, 114, 164),
        UnselectedText = Color3.fromRGB(98, 114, 164)
    },
    ["Nord"] = {
        Accent = Color3.fromRGB(136, 192, 208),
        Background = Color3.fromRGB(46, 52, 64),
        Outline = Color3.fromRGB(59, 66, 82),
        Border = Color3.fromRGB(36, 42, 54),
        Text = Color3.fromRGB(236, 239, 244),
        DarkText = Color3.fromRGB(129, 161, 193),
        UnselectedText = Color3.fromRGB(129, 161, 193)
    },
    ["Gruvbox"] = {
        Accent = Color3.fromRGB(251, 184, 108),
        Background = Color3.fromRGB(40, 40, 40),
        Outline = Color3.fromRGB(60, 56, 54),
        Border = Color3.fromRGB(29, 32, 33),
        Text = Color3.fromRGB(235, 219, 178),
        DarkText = Color3.fromRGB(168, 153, 132),
        UnselectedText = Color3.fromRGB(168, 153, 132)
    },
    ["Solarized Dark"] = {
        Accent = Color3.fromRGB(38, 139, 210),
        Background = Color3.fromRGB(0, 43, 54),
        Outline = Color3.fromRGB(7, 54, 66),
        Border = Color3.fromRGB(0, 30, 38),
        Text = Color3.fromRGB(131, 148, 150),
        DarkText = Color3.fromRGB(88, 110, 117),
        UnselectedText = Color3.fromRGB(88, 110, 117)
    },
    ["Solarized Light"] = {
        Accent = Color3.fromRGB(38, 139, 210),
        Background = Color3.fromRGB(253, 246, 227),
        Outline = Color3.fromRGB(238, 232, 213),
        Border = Color3.fromRGB(220, 215, 200),
        Text = Color3.fromRGB(101, 123, 131),
        DarkText = Color3.fromRGB(147, 161, 161),
        UnselectedText = Color3.fromRGB(147, 161, 161)
    },
    ["Discord"] = {
        Accent = Color3.fromRGB(88, 101, 242),
        Background = Color3.fromRGB(54, 57, 63),
        Outline = Color3.fromRGB(47, 49, 54),
        Border = Color3.fromRGB(35, 39, 42),
        Text = Color3.fromRGB(220, 221, 222),
        DarkText = Color3.fromRGB(142, 146, 151),
        UnselectedText = Color3.fromRGB(142, 146, 151)
    },
    ["Spotify"] = {
        Accent = Color3.fromRGB(30, 215, 96),
        Background = Color3.fromRGB(18, 18, 18),
        Outline = Color3.fromRGB(40, 40, 40),
        Border = Color3.fromRGB(10, 10, 10),
        Text = Color3.fromRGB(255, 255, 255),
        DarkText = Color3.fromRGB(179, 179, 179),
        UnselectedText = Color3.fromRGB(179, 179, 179)
    },
    ["Steam"] = {
        Accent = Color3.fromRGB(102, 192, 244),
        Background = Color3.fromRGB(27, 40, 56),
        Outline = Color3.fromRGB(35, 51, 72),
        Border = Color3.fromRGB(20, 30, 42),
        Text = Color3.fromRGB(198, 212, 223),
        DarkText = Color3.fromRGB(140, 158, 173),
        UnselectedText = Color3.fromRGB(140, 158, 173)
    },
    ["YouTube"] = {
        Accent = Color3.fromRGB(255, 0, 0),
        Background = Color3.fromRGB(15, 15, 15),
        Outline = Color3.fromRGB(33, 33, 33),
        Border = Color3.fromRGB(8, 8, 8),
        Text = Color3.fromRGB(241, 241, 241),
        DarkText = Color3.fromRGB(170, 170, 170),
        UnselectedText = Color3.fromRGB(170, 170, 170)
    },
    ["Fatality"] = {
        Accent = Color3.fromRGB(140, 120, 255),
        Background = Color3.fromRGB(18, 18, 22),
        Outline = Color3.fromRGB(28, 28, 32),
        Border = Color3.fromRGB(6, 6, 8),
        Text = Color3.fromRGB(180, 180, 180),
        DarkText = Color3.fromRGB(85, 85, 90),
        UnselectedText = Color3.fromRGB(85, 85, 90)
    },
    ["Gamesense"] = {
        Accent = Color3.fromRGB(165, 215, 95),
        Background = Color3.fromRGB(25, 25, 25),
        Outline = Color3.fromRGB(35, 35, 35),
        Border = Color3.fromRGB(10, 10, 10),
        Text = Color3.fromRGB(165, 165, 165),
        DarkText = Color3.fromRGB(90, 90, 90),
        UnselectedText = Color3.fromRGB(90, 90, 90)
    },
    ["Neverlose"] = {
        Accent = Color3.fromRGB(125, 255, 180),
        Background = Color3.fromRGB(16, 16, 20),
        Outline = Color3.fromRGB(26, 26, 30),
        Border = Color3.fromRGB(4, 4, 6),
        Text = Color3.fromRGB(180, 180, 185),
        DarkText = Color3.fromRGB(80, 80, 85),
        UnselectedText = Color3.fromRGB(80, 80, 85)
    },
    ["Onetap"] = {
        Accent = Color3.fromRGB(255, 75, 125),
        Background = Color3.fromRGB(20, 20, 24),
        Outline = Color3.fromRGB(32, 32, 36),
        Border = Color3.fromRGB(8, 8, 10),
        Text = Color3.fromRGB(170, 170, 175),
        DarkText = Color3.fromRGB(90, 90, 92),
        UnselectedText = Color3.fromRGB(90, 90, 92)
    },
    ["Skeet"] = {
        Accent = Color3.fromRGB(100, 150, 255),
        Background = Color3.fromRGB(12, 12, 12),
        Outline = Color3.fromRGB(40, 40, 50),
        Border = Color3.fromRGB(0, 0, 0),
        Text = Color3.fromRGB(200, 200, 200),
        DarkText = Color3.fromRGB(100, 100, 100),
        UnselectedText = Color3.fromRGB(100, 100, 100)
    },
    ["Aimware"] = {
        Accent = Color3.fromRGB(255, 100, 100),
        Background = Color3.fromRGB(20, 20, 25),
        Outline = Color3.fromRGB(30, 30, 35),
        Border = Color3.fromRGB(5, 5, 8),
        Text = Color3.fromRGB(175, 175, 175),
        DarkText = Color3.fromRGB(90, 90, 95),
        UnselectedText = Color3.fromRGB(90, 90, 95)
    },
    ["Novoline"] = {
        Accent = Color3.fromRGB(102, 204, 255),
        Background = Color3.fromRGB(16, 18, 22),
        Outline = Color3.fromRGB(26, 28, 32),
        Border = Color3.fromRGB(6, 8, 12),
        Text = Color3.fromRGB(180, 190, 200),
        DarkText = Color3.fromRGB(85, 90, 95),
        UnselectedText = Color3.fromRGB(85, 90, 95)
    },
    ["Primordial"] = {
        Accent = Color3.fromRGB(255, 140, 0),
        Background = Color3.fromRGB(15, 15, 18),
        Outline = Color3.fromRGB(25, 25, 28),
        Border = Color3.fromRGB(5, 5, 6),
        Text = Color3.fromRGB(190, 190, 190),
        DarkText = Color3.fromRGB(85, 85, 85),
        UnselectedText = Color3.fromRGB(85, 85, 85)
    },
    ["Pandora"] = {
        Accent = Color3.fromRGB(255, 100, 255),
        Background = Color3.fromRGB(18, 15, 22),
        Outline = Color3.fromRGB(28, 25, 32),
        Border = Color3.fromRGB(8, 5, 12),
        Text = Color3.fromRGB(200, 180, 210),
        DarkText = Color3.fromRGB(95, 80, 105),
        UnselectedText = Color3.fromRGB(95, 80, 105)
    },
    ["Osiris"] = {
        Accent = Color3.fromRGB(0, 255, 150),
        Background = Color3.fromRGB(14, 20, 18),
        Outline = Color3.fromRGB(24, 30, 28),
        Border = Color3.fromRGB(4, 10, 8),
        Text = Color3.fromRGB(180, 200, 190),
        DarkText = Color3.fromRGB(80, 95, 85),
        UnselectedText = Color3.fromRGB(80, 95, 85)
    },
    ["Ev0lve"] = {
        Accent = Color3.fromRGB(255, 200, 0),
        Background = Color3.fromRGB(20, 18, 12),
        Outline = Color3.fromRGB(30, 28, 20),
        Border = Color3.fromRGB(10, 8, 5),
        Text = Color3.fromRGB(200, 195, 180),
        DarkText = Color3.fromRGB(95, 90, 80),
        UnselectedText = Color3.fromRGB(95, 90, 80)
    },
    ["Legendware"] = {
        Accent = Color3.fromRGB(255, 50, 100),
        Background = Color3.fromRGB(18, 14, 16),
        Outline = Color3.fromRGB(28, 24, 26),
        Border = Color3.fromRGB(8, 4, 6),
        Text = Color3.fromRGB(200, 180, 190),
        DarkText = Color3.fromRGB(95, 80, 85),
        UnselectedText = Color3.fromRGB(95, 80, 85)
    },
    ["Rifk7"] = {
        Accent = Color3.fromRGB(150, 255, 100),
        Background = Color3.fromRGB(16, 20, 14),
        Outline = Color3.fromRGB(26, 30, 24),
        Border = Color3.fromRGB(6, 10, 4),
        Text = Color3.fromRGB(190, 210, 180),
        DarkText = Color3.fromRGB(85, 100, 80),
        UnselectedText = Color3.fromRGB(85, 100, 80)
    },
    ["Monolith"] = {
        Accent = Color3.fromRGB(100, 100, 100),
        Background = Color3.fromRGB(12, 12, 12),
        Outline = Color3.fromRGB(22, 22, 22),
        Border = Color3.fromRGB(2, 2, 2),
        Text = Color3.fromRGB(180, 180, 180),
        DarkText = Color3.fromRGB(80, 80, 80),
        UnselectedText = Color3.fromRGB(80, 80, 80)
    },
    ["Supremacy"] = {
        Accent = Color3.fromRGB(200, 100, 255),
        Background = Color3.fromRGB(18, 14, 22),
        Outline = Color3.fromRGB(28, 24, 32),
        Border = Color3.fromRGB(8, 4, 12),
        Text = Color3.fromRGB(200, 180, 210),
        DarkText = Color3.fromRGB(95, 80, 105),
        UnselectedText = Color3.fromRGB(95, 80, 105)
    },
    ["Exodus"] = {
        Accent = Color3.fromRGB(0, 200, 255),
        Background = Color3.fromRGB(12, 18, 22),
        Outline = Color3.fromRGB(20, 28, 32),
        Border = Color3.fromRGB(5, 10, 12),
        Text = Color3.fromRGB(180, 200, 210),
        DarkText = Color3.fromRGB(80, 95, 100),
        UnselectedText = Color3.fromRGB(80, 95, 100)
    },
    ["Spirthack"] = {
        Accent = Color3.fromRGB(255, 150, 0),
        Background = Color3.fromRGB(20, 16, 12),
        Outline = Color3.fromRGB(30, 26, 20),
        Border = Color3.fromRGB(10, 6, 5),
        Text = Color3.fromRGB(200, 190, 180),
        DarkText = Color3.fromRGB(95, 85, 80),
        UnselectedText = Color3.fromRGB(95, 85, 80)
    },
    ["Ubuntu"] = {
        Accent = Color3.fromRGB(233, 84, 32),
        Background = Color3.fromRGB(45, 45, 45),
        Outline = Color3.fromRGB(60, 60, 60),
        Border = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(220, 220, 220),
        DarkText = Color3.fromRGB(150, 150, 150),
        UnselectedText = Color3.fromRGB(150, 150, 150)
    },
    ["Windows"] = {
        Accent = Color3.fromRGB(0, 120, 215),
        Background = Color3.fromRGB(240, 240, 240),
        Outline = Color3.fromRGB(200, 200, 200),
        Border = Color3.fromRGB(180, 180, 180),
        Text = Color3.fromRGB(30, 30, 30),
        DarkText = Color3.fromRGB(120, 120, 120),
        UnselectedText = Color3.fromRGB(120, 120, 120)
    },
    ["Windows Dark"] = {
        Accent = Color3.fromRGB(0, 120, 215),
        Background = Color3.fromRGB(30, 30, 30),
        Outline = Color3.fromRGB(45, 45, 45),
        Border = Color3.fromRGB(20, 20, 20),
        Text = Color3.fromRGB(230, 230, 230),
        DarkText = Color3.fromRGB(150, 150, 150),
        UnselectedText = Color3.fromRGB(150, 150, 150)
    },
    ["macOS"] = {
        Accent = Color3.fromRGB(0, 122, 255),
        Background = Color3.fromRGB(245, 245, 245),
        Outline = Color3.fromRGB(220, 220, 220),
        Border = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(40, 40, 40),
        DarkText = Color3.fromRGB(130, 130, 130),
        UnselectedText = Color3.fromRGB(130, 130, 130)
    },
    ["macOS Dark"] = {
        Accent = Color3.fromRGB(10, 132, 255),
        Background = Color3.fromRGB(30, 30, 30),
        Outline = Color3.fromRGB(50, 50, 50),
        Border = Color3.fromRGB(20, 20, 20),
        Text = Color3.fromRGB(235, 235, 235),
        DarkText = Color3.fromRGB(155, 155, 155),
        UnselectedText = Color3.fromRGB(155, 155, 155)
    },
    ["KDE"] = {
        Accent = Color3.fromRGB(61, 174, 233),
        Background = Color3.fromRGB(49, 54, 59),
        Outline = Color3.fromRGB(61, 66, 71),
        Border = Color3.fromRGB(35, 38, 41),
        Text = Color3.fromRGB(239, 240, 241),
        DarkText = Color3.fromRGB(189, 195, 199),
        UnselectedText = Color3.fromRGB(189, 195, 199)
    },
    ["GNOME"] = {
        Accent = Color3.fromRGB(53, 132, 228),
        Background = Color3.fromRGB(36, 36, 36),
        Outline = Color3.fromRGB(51, 51, 51),
        Border = Color3.fromRGB(26, 26, 26),
        Text = Color3.fromRGB(235, 235, 235),
        DarkText = Color3.fromRGB(150, 150, 150),
        UnselectedText = Color3.fromRGB(150, 150, 150)
    },
    ["Material"] = {
        Accent = Color3.fromRGB(33, 150, 243),
        Background = Color3.fromRGB(250, 250, 250),
        Outline = Color3.fromRGB(224, 224, 224),
        Border = Color3.fromRGB(189, 189, 189),
        Text = Color3.fromRGB(33, 33, 33),
        DarkText = Color3.fromRGB(117, 117, 117),
        UnselectedText = Color3.fromRGB(117, 117, 117)
    },
    ["Material Dark"] = {
        Accent = Color3.fromRGB(33, 150, 243),
        Background = Color3.fromRGB(48, 48, 48),
        Outline = Color3.fromRGB(66, 66, 66),
        Border = Color3.fromRGB(33, 33, 33),
        Text = Color3.fromRGB(255, 255, 255),
        DarkText = Color3.fromRGB(158, 158, 158),
        UnselectedText = Color3.fromRGB(158, 158, 158)
    }
}

Library.ThemeObjects = {}

function Library:ApplyTheme(theme_name)
    local theme = self.PresetThemes[theme_name]
    if not theme then return end
    
    -- Update Library.Theme
    for key, value in pairs(theme) do
        self.Theme[key] = value
    end
    
    -- Update all registered theme objects
    for obj, property in pairs(self.ThemeObjects) do
        if obj and obj.Parent then
            pcall(function()
                if property == "Accent" then
                    obj.BackgroundColor3 = theme.Accent
                elseif property == "AccentImage" then
                    obj.ImageColor3 = theme.Accent
                elseif property == "Background" then
                    obj.BackgroundColor3 = theme.Background
                elseif property == "Outline" then
                    obj.BackgroundColor3 = theme.Outline
                elseif property == "Border" then
                    obj.BackgroundColor3 = theme.Border
                elseif property == "Text" then
                    obj.TextColor3 = theme.Text
                elseif property == "DarkText" then
                    obj.TextColor3 = theme.DarkText
                end
            end)
        end
    end
end

-- Key mapping table
local Keys = {
    [Enum.KeyCode.LeftShift] = "LSHIFT",
    [Enum.KeyCode.RightShift] = "RSHIFT",
    [Enum.KeyCode.LeftControl] = "LCTRL",
    [Enum.KeyCode.RightControl] = "RCTRL",
    [Enum.KeyCode.LeftAlt] = "LALT",
    [Enum.KeyCode.RightAlt] = "RALT",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "NUM1",
    [Enum.KeyCode.KeypadTwo] = "NUM2",
    [Enum.KeyCode.KeypadThree] = "NUM3",
    [Enum.KeyCode.KeypadFour] = "NUM4",
    [Enum.KeyCode.KeypadFive] = "NUM5",
    [Enum.KeyCode.KeypadSix] = "NUM6",
    [Enum.KeyCode.KeypadSeven] = "NUM7",
    [Enum.KeyCode.KeypadEight] = "NUM8",
    [Enum.KeyCode.KeypadNine] = "NUM9",
    [Enum.KeyCode.KeypadZero] = "NUM0",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3"
}

-- Helper Functions
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

local function Connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Library.Connections, connection)
    return connection
end

local function MakeDraggable(frame)
    local dragging, dragStart, startPos
    
    Connect(frame.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    Connect(UIS.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    Connect(UIS.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function CreateAnimatedText(text)
    local animated = {}
    for i = 1, #text do
        table.insert(animated, text:sub(1, i))
    end
    return animated
end

function Library:Round(value, decimal)
    return math.floor(value / decimal + 0.5) * decimal
end

function Library:ConvertStringRGB(text)
    local parts = {}
    for part in string.gmatch(text, "[^,]+") do
        table.insert(parts, tonumber(part))
    end
    
    if #parts >= 3 then
        local r = math.clamp(parts[1] or 0, 0, 255) / 255
        local g = math.clamp(parts[2] or 0, 0, 255) / 255
        local b = math.clamp(parts[3] or 0, 0, 255) / 255
        local a = parts[4] and math.clamp(parts[4], 0, 1) or 1
        return r, g, b, a
    end
    return nil
end

function Library:ConvertEnum(str)
    local success, result = pcall(function()
        return Enum.KeyCode[str]
    end)
    return success and result or Enum.KeyCode.Unknown
end

-- Rainbow effect
task.spawn(function()
    while true do
        Library.Sin = (math.sin(tick()) + 1) / 2
        task.wait()
    end
end)

function Library:notification(properties)
    if not Library.Gui then
        warn("Library.Gui not initialized. Create a window first.")
        return
    end
    
    local cfg = {
        time = properties.time or 5,
        text = properties.text or properties.name or "uilib notification"
    }

    function cfg:refresh_notifications()  
        for idx, notif in next, Library.Notifications do 
            TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0, 20, 0, 72 + ((idx - 1) * 28))
            }):Play()
        end     
    end 

    -- Instances
    local holder = Create("Frame", {
        Parent = Library.Gui,
        Name = "",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 72 + (#Library.Notifications * 28)),
        BorderColor3 = Color3.fromRGB(19, 19, 19),
        ZIndex = 2,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        AnchorPoint = Vector2.new(1, 0)
    })

    local inline1 = Create("Frame", {
        Parent = holder,
        Name = "",
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 0, 0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    })
    
    local inline2 = Create("Frame", {
        Parent = inline1,
        Name = "",
        Position = UDim2.new(0, 0, 0, 2),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, -4, 1, -4),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    })
    
    local main = Create("Frame", {
        Parent = inline2,
        Name = "",
        Position = UDim2.new(0, 2, 0, 2),
        BorderColor3 = Color3.fromRGB(57, 57, 57),
        Size = UDim2.new(1, -4, 1, -4),
        BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    })
    
    local tab_inline = Create("Frame", {
        Parent = main,
        Name = "",
        Position = UDim2.new(0, 2, 0, 2),
        BorderColor3 = Color3.fromRGB(19, 19, 19),
        Size = UDim2.new(1, -4, 1, -4),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(19, 19, 19)
    })
    
    local name = Create("TextLabel", {
        Parent = tab_inline,
        Name = "",
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(170, 170, 170),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = cfg.text,
        TextStrokeTransparency = 0.5,
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    })
    
    Create("UIPadding", {
        Parent = tab_inline,
        Name = "",
        PaddingRight = UDim.new(0, 14)
    })
    
    local depth = Create("Frame", {
        Parent = inline1,
        Name = "",
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Position = UDim2.new(0, 1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    })
    
    local accent_line = Create("Frame", {
        Parent = inline1,
        Name = "",
        BorderColor3 = Color3.fromRGB(34, 34, 34),
        Size = UDim2.new(0, 2, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Library.Theme.Accent
    })
    Library.ThemeObjects[accent_line] = "Accent"
    
    local glow = Create("ImageLabel", {
        Parent = holder,
        Name = "",
        ImageColor3 = Library.Theme.Accent,
        ScaleType = Enum.ScaleType.Slice,
        ImageTransparency = 0.9,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Image = "http://www.roblox.com/asset/?id=18245826428",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -20, 0, 0),
        Size = UDim2.new(0, 42, 1, 40),
        ZIndex = 2,
        BorderSizePixel = 0,
        SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
    })
    Library.ThemeObjects[glow] = "AccentImage"

    task.spawn(function()
        TweenService:Create(holder, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            AnchorPoint = Vector2.new(0, 0)
        }):Play()

        task.wait(cfg.time)

        TweenService:Create(holder, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            AnchorPoint = Vector2.new(1, 0)
        }):Play()
        for _, v in next, holder:GetDescendants() do 
            if v:IsA("TextLabel") then 
                TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    TextTransparency = 1
                }):Play()
            elseif v:IsA("Frame") then 
                TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    BackgroundTransparency = 1
                }):Play()
            elseif v:IsA("ImageLabel") then 
                TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    ImageTransparency = 1
                }):Play()
            end 
        end   
    end)

    task.delay(cfg.time + 0.1, function()
        local index = table.find(Library.Notifications, holder)
        if index then
            table.remove(Library.Notifications, index)
        end
        cfg:refresh_notifications()   
        task.wait(0.5)
        holder:Destroy()
    end)

    table.insert(Library.Notifications, holder)
end

function Library:Window(config)
    local Window = {}
    setmetatable(Window, {__index = Library})
    local name = config.Name or config.name or config.Title or config.title or "UI Library"
    local size = config.Size or config.size or UDim2.new(0, 500, 0, 650)
    local showPreview = config.Preview or false
    if config.preview ~= nil then showPreview = config.preview end
    
    for _, gui in pairs(GetParent():GetChildren()) do
        if gui.Name:sub(1, 6) == "UILib_" then gui:Destroy() end
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "UILib_" .. tostring(math.random(1000, 9999)),
        Parent = GetParent(),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    Library.Gui = ScreenGui
    
    -- Initialize stats service and shared data
    local Stats = game:GetService("Stats")
    Library.Shared = Library.Shared or {}
    Library.Shared.fps = 0
    Library.Shared.ping = 0
    Library.Shared.uid = Players.LocalPlayer.UserId
    
    -- Watermark configuration
    Window.WatermarkConfig = {
        enabled = false,
        format = function() return "" end
    }
    
    local WatermarkHolder = Create("Frame", {
        Parent = ScreenGui,
        Name = "",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 60,
        Size = UDim2.new(0, 200, 0, 21),
        Visible = false
    })
    
    local WatermarkOutline = Create("Frame", {
        Parent = WatermarkHolder,
        Name = "",
        Active = true,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        ZIndex = 60
    })
    Library.ThemeObjects[WatermarkOutline] = "Outline"
    
    MakeDraggable(WatermarkOutline)
    
    local WatermarkInline = Create("Frame", {
        Parent = WatermarkOutline,
        Name = "",
        Position = UDim2.new(0, 1, 0, 1),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(56, 56, 56),
        ZIndex = 60
    })
    Library.ThemeObjects[WatermarkInline] = "Border"
    
    local WatermarkMain = Create("Frame", {
        Parent = WatermarkInline,
        Name = "",
        Position = UDim2.new(0, 1, 0, 1),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(38, 38, 38),
        ZIndex = 60
    })
    Library.ThemeObjects[WatermarkMain] = "Background"
    
    local WatermarkAccent = Create("Frame", {
        Parent = WatermarkMain,
        Name = "",
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = Library.Theme.Accent,
        ZIndex = 60
    })
    Library.ThemeObjects[WatermarkAccent] = "Accent"
    
    local WatermarkText = Create("TextLabel", {
        Parent = WatermarkMain,
        Name = "",
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "",
        TextStrokeTransparency = 0.5,
        Size = UDim2.new(1, 0, 1, -2),
        Position = UDim2.new(0, 0, 0, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 60
    })
    Library.ThemeObjects[WatermarkText] = "Text"
    
    -- Update FPS and Ping
    Connect(RunService.RenderStepped, function(delta)
        Library.Shared.fps = math.round(1 / delta)
        
        local success, ping = pcall(function()
            return tonumber(string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1])
        end)
        
        if success and ping then
            Library.Shared.ping = math.floor(ping)
        end
    end)
    
    -- Watermark update function
    function Window:Watermark(properties)
        Window.WatermarkConfig.enabled = properties.enabled ~= nil and properties.enabled or true
        Window.WatermarkConfig.format = properties.format or function()
            return string.format("%s || uid : %u || ping : %u || fps : %u", 
                name, Library.Shared.uid, Library.Shared.ping, Library.Shared.fps)
        end
        
        WatermarkHolder.Visible = Window.WatermarkConfig.enabled
        
        return Window
    end
    
    -- Keybind list function
    function Window:KeybindList(properties)
        local cfg = properties or {}
        cfg.enabled = cfg.enabled ~= nil and cfg.enabled or true
        cfg.title = cfg.title or cfg.Title or "Keybinds"
        
        local KeybindListHolder = Create("Frame", {
            Parent = ScreenGui,
            Name = "",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -50),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 60,
            Size = UDim2.new(0, 180, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = cfg.enabled
        })
        
        local KeybindOutline = Create("Frame", {
            Parent = KeybindListHolder,
            Name = "",
            Active = true,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            ZIndex = 60,
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        MakeDraggable(KeybindOutline)
        
        local KeybindInline = Create("Frame", {
            Parent = KeybindOutline,
            Name = "",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(56, 56, 56),
            ZIndex = 60,
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        local KeybindMain = Create("Frame", {
            Parent = KeybindInline,
            Name = "",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(38, 38, 38),
            ZIndex = 60,
            AutomaticSize = Enum.AutomaticSize.Y
        })
        Library.ThemeObjects[KeybindMain] = "Background"
        
        local KeybindAccent = Create("Frame", {
            Parent = KeybindMain,
            Name = "",
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Accent,
            ZIndex = 60
        })
        Library.ThemeObjects[KeybindAccent] = "Accent"
        
        local KeybindTitle = Create("TextLabel", {
            Parent = KeybindMain,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = cfg.title,
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 21),
            Position = UDim2.new(0, 0, 0, 1),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ZIndex = 60
        })
        Library.ThemeObjects[KeybindTitle] = "Text"
        
        local KeybindSeparator = Create("Frame", {
            Parent = KeybindMain,
            Name = "",
            Position = UDim2.new(0, 0, 0, 22),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            ZIndex = 60,
            Visible = true
        })
        
        local KeybindContainer = Create("Frame", {
            Parent = KeybindMain,
            Name = "",
            Position = UDim2.new(0, 6, 0, 27),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -12, 0, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 60
        })
        
        Create("UIListLayout", {
            Parent = KeybindContainer,
            Name = "",
            Padding = UDim.new(0, 3),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        Create("UIPadding", {
            Parent = KeybindContainer,
            Name = "",
            PaddingBottom = UDim.new(0, 4)
        })
        
        Library.KeybindContainer = KeybindContainer
        Library.KeybindListVisible = cfg.enabled
    
    -- Store ESP Preview reference for external module
    Library.ESPPreview = nil
    Library.ESPPreviewVisible = false
    
    -- Function to set ESP preview from external module
    function Library:SetESPPreview(preview_frame)
        self.ESPPreview = preview_frame
        if self.cfg and self.cfg.show_esp_preview ~= nil then
            preview_frame.Visible = self.cfg.show_esp_preview
        end
    end
    
    -- Function to toggle ESP preview visibility
    function Library:ToggleESPPreview(visible)
        self.ESPPreviewVisible = visible
        if self.ESPPreview then
            self.ESPPreview.Visible = visible
        end
        if self.cfg then
            self.cfg.show_esp_preview = visible
        end
    end
        task.spawn(function()
            while task.wait(0.1) do
                if not Library.KeybindListVisible then continue end
                
                -- Clear existing keybind displays
                for _, child in pairs(KeybindContainer:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end
                
                -- Count active keybinds and add them
                local keybindCount = 0
                for flagName, flagValue in pairs(Library.Flags) do
                    if type(flagValue) == "table" and flagValue._type == "keybind" and flagValue.active and flagValue.key ~= Enum.KeyCode.Unknown then
                        keybindCount = keybindCount + 1
                        local keyText = tostring(flagValue.key):gsub("Enum.KeyCode.", "")
                        local keybindName = flagName:gsub("_bind", ""):gsub("_", " ")
                        
                        local keybindLabel = Create("TextLabel", {
                            Parent = KeybindContainer,
                            Name = "",
                            Font = Enum.Font.Code,
                            TextColor3 = Color3.fromRGB(170, 170, 170),
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Text = keybindName .. " [" .. keyText .. "]",
                            TextStrokeTransparency = 0.5,
                            Size = UDim2.new(1, 0, 0, 14),
                            BackgroundTransparency = 1,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            BorderSizePixel = 0,
                            TextSize = 11,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            ZIndex = 60
                        })
                        Library.ThemeObjects[keybindLabel] = "Text"
                    end
                end
            end
        end)
        
        Window.KeybindListConfig = {
            enabled = cfg.enabled,
            holder = KeybindListHolder,
            set_visible = function(visible)
                Library.KeybindListVisible = visible
                KeybindListHolder.Visible = visible
            end
        }
        
        return Window.KeybindListConfig
    end
    
    -- Update watermark text
    task.spawn(function()
        while WatermarkHolder and WatermarkHolder.Parent do
            if Window.WatermarkConfig.enabled and WatermarkText then
                local text = Window.WatermarkConfig.format()
                WatermarkText.Text = text
                
                -- Update size based on text bounds
                local textBounds = game:GetService("TextService"):GetTextSize(
                    text,
                    WatermarkText.TextSize,
                    WatermarkText.Font,
                    Vector2.new(math.huge, math.huge)
                )
                
                WatermarkHolder.Size = UDim2.new(0, textBounds.X + 12, 0, 21)
            end
            task.wait(0.1)
        end
    end)
    
    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        Active = true,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        BorderColor3 = Color3.fromRGB(8, 8, 8),
        ZIndex = 2,
        Size = size,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    })
    
    -- Store reference for external modules
    Library.Holder = Main
    Library.Create = Create
    Library.MakeDraggable = MakeDraggable
    
    table.insert(Library.MainFrames, Main)
    MakeDraggable(Main)
    
    local Inner = Create("Frame", {
        Parent = Main,
        Name = "",
        Position = UDim2.new(0, 2, 0, 2),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, -4, 1, -4),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    })
    
    local Content = Create("Frame", {
        Parent = Inner,
        Name = "",
        Position = UDim2.new(0, 2, 0, 2),
        BorderColor3 = Color3.fromRGB(57, 57, 57),
        Size = UDim2.new(1, -4, 1, -4),
        BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    })
    
    local TabButtons = Create("Frame", {
        Parent = Content,
        Name = "",
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 4),
        Size = UDim2.new(1, -32, 0, 0),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    })
    
    Create("UIListLayout", {
        Parent = TabButtons,
        Name = "",
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local TabInline = Create("Frame", {
        Parent = Content,
        Name = "",
        Position = UDim2.new(0, 15, 0, 33),
        BorderColor3 = Color3.fromRGB(19, 19, 19),
        Size = UDim2.new(1, -30, 1, -48),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(19, 19, 19)
    })
    
    local Tabs = Create("Frame", {
        Parent = TabInline,
        Name = "",
        Position = UDim2.new(0, 2, 0, 2),
        BorderColor3 = Color3.fromRGB(56, 56, 56),
        Size = UDim2.new(1, -4, 1, -4),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    })
    Library.ThemeObjects[Tabs] = "Background"
    
    local Accent = Create("Frame", {
        Parent = Main,
        Name = "",
        BorderColor3 = Color3.fromRGB(34, 34, 34),
        Size = UDim2.new(1, 0, 0, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = Library.Theme.Accent
    })
    Library.ThemeObjects[Accent] = "Accent"
    
    local TitleLabel = Create("TextLabel", {
        Parent = Main,
        Name = "",
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(170, 170, 170),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = name,
        TextStrokeTransparency = 0.5,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, -1),
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 2,
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    })
    Library.ThemeObjects[TitleLabel] = "Text"
    
    local MainGlow = Create("ImageLabel", {
        Parent = Main,
        Name = "",
        ImageColor3 = Library.Theme.Accent,
        ScaleType = Enum.ScaleType.Slice,
        ImageTransparency = 0.9,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Image = "http://www.roblox.com/asset/?id=18245826428",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -20, 0, -20),
        Size = UDim2.new(1, 40, 0, 42),
        ZIndex = 2,
        BorderSizePixel = 0,
        SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
    })
    Library.ThemeObjects[MainGlow] = "AccentImage"
    
    local Depth = Create("Frame", {
        Parent = Main,
        Name = "",
        BackgroundTransparency = 0.5,
        Position = UDim2.new(0, 0, 0, 1),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    })
    
    local MobileBtn = Create("TextButton", {
        Parent = ScreenGui,
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(0, 45, 0, 45),
        Text = "☰",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Visible = false
    })
    
    if UIS.TouchEnabled then
        MobileBtn.Visible = true
    end
    
    Create("UICorner", {Parent = MobileBtn, CornerRadius = UDim.new(0, 8)})
    
    MobileBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)
    
    -- Menu toggle keybind
    Window.MenuKeybind = {
        Key = Enum.KeyCode.Insert,
        Active = false
    }
    Window.MenuVisible = true
    
    Connect(UIS.InputBegan, function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Window.MenuKeybind.Key then
            Window.MenuVisible = not Window.MenuVisible
            Main.Visible = Window.MenuVisible
        end
    end)
    
    Window.CurrentTab = nil
    Window.CurrentElementOpen = nil
    
    task.spawn(function()
        while WatermarkGradient and WatermarkGradient.Parent do
            WatermarkGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(math.abs(math.sin(tick())), Library.Theme.Accent),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            }
            task.wait()
        end
    end)
    
    function Window:Tab(properties)
        local cfg = {
            name = properties.Name or properties.name or "Tab",
            enabled = false
        }
        
        local TAB_BUTTON = Create("TextButton", {
            Parent = TabButtons,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Library.Theme.UnselectedText,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = cfg.name,
            TextStrokeTransparency = 0.5,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.333, -4, 0, 22),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        local line = Create("Frame", {
            Parent = TAB_BUTTON,
            Name = "",
            Position = UDim2.new(0, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(57, 57, 57)
        })
        
        cfg.tab_button = TAB_BUTTON
        cfg.tab_line = line
        
        local glow = Create("ImageLabel", {
            Parent = line,
            Name = "",
            ImageColor3 = Library.Theme.Accent,
            ScaleType = Enum.ScaleType.Slice,
            ImageTransparency = 0.9,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Image = "http://www.roblox.com/asset/?id=18245826428",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -20, 0, -20),
            Size = UDim2.new(1, 40, 1, 40),
            ZIndex = 2,
            Visible = false,
            BorderSizePixel = 0,
            SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
        })
        Library.ThemeObjects[glow] = "AccentImage"
        
        local depth = Create("Frame", {
            Parent = line,
            Name = "",
            BackgroundTransparency = 0.5,
            Position = UDim2.new(0, 0, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        })
        
        local TAB = Create("Frame", {
            Parent = Tabs,
            Name = "",
            Visible = false,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        local scrolling_columns = Create("Frame", {
            Parent = TAB,
            Name = "",
            ClipsDescendants = true,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 6, 0, 6),
            Size = UDim2.new(1, -12, 1, -12),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        cfg.column_holder = scrolling_columns
        
        Create("UIListLayout", {
            Parent = scrolling_columns,
            Name = "",
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local left = Create("ScrollingFrame", {
            Parent = scrolling_columns,
            Name = "",
            ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            Size = UDim2.new(0.5, -64, 1, 0),
            ClipsDescendants = false,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        
        Connect(left:GetPropertyChangedSignal("CanvasPosition"), function()
            if Window.CurrentElementOpen then
                Window.CurrentElementOpen.set_visible(false)
                Window.CurrentElementOpen.open = false
                Window.CurrentElementOpen = nil
            end
        end)
        
        cfg.left = left
        cfg.holder = left
        
        Create("UIListLayout", {
            Parent = left,
            Name = "",
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        Create("UIPadding", {
            Parent = left,
            Name = "",
            PaddingBottom = UDim.new(0, 15)
        })
        
        local right = Create("ScrollingFrame", {
            Parent = scrolling_columns,
            Name = "",
            ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            Size = UDim2.new(0.5, -64, 1, 0),
            ClipsDescendants = false,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -50, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        
        Connect(right:GetPropertyChangedSignal("CanvasPosition"), function()
            if Window.CurrentElementOpen then
                Window.CurrentElementOpen.set_visible(false)
                Window.CurrentElementOpen.open = false
                Window.CurrentElementOpen = nil
            end
        end)
        
        cfg.right = right
        
        Create("UIListLayout", {
            Parent = right,
            Name = "",
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        Create("UIPadding", {
            Parent = right,
            Name = "",
            PaddingBottom = UDim.new(0, 15)
        })
        
        function cfg.open_tab()
            if Window.CurrentTab and Window.CurrentTab[1] ~= TAB_BUTTON then
                local button = Window.CurrentTab[1]
                button.TextColor3 = Library.Theme.UnselectedText
                
                local parent = button:FindFirstChildOfClass("Frame")
                parent.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
                parent:FindFirstChildOfClass("ImageLabel").Visible = false
                
                -- Unregister previous active tab from theme
                if Library.ThemeObjects[button] then
                    Library.ThemeObjects[button] = nil
                end
                if Library.ThemeObjects[parent] then
                    Library.ThemeObjects[parent] = nil
                end
                
                Window.CurrentTab[2].Visible = false
            end
            
            Window.CurrentTab = {TAB_BUTTON, TAB}
            
            line.BackgroundColor3 = Library.Theme.Accent
            glow.Visible = true
            TAB_BUTTON.TextColor3 = Library.Theme.Text
            TAB.Visible = true
            
            -- Register active tab with theme system
            Library.ThemeObjects[TAB_BUTTON] = "Text"
            Library.ThemeObjects[line] = "Accent"
            
            if Window.CurrentElementOpen and Window.CurrentElementOpen ~= cfg then
                Window.CurrentElementOpen.set_visible(false)
                Window.CurrentElementOpen.open = false
                Window.CurrentElementOpen = nil
            end
        end
        
        TAB_BUTTON.MouseButton1Click:Connect(cfg.open_tab)
        
        return setmetatable(cfg, {__index = Window})
    end
    
    function Window:Toggle(properties) 
        local cfg = {
            enabled = properties.enabled or nil,
            name = properties.Name or properties.name or "Toggle",
            flag = properties.Flag or properties.flag or tostring(math.random(1,9999999)),
            callback = properties.Callback or properties.callback or function() end,
            default = properties.Default or properties.default or false,
            previous_holder = self
        }

        Library.Flags[cfg.flag] = cfg.default

        local object = Create("TextButton", {
            Parent = self.holder,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = cfg.name,
            TextStrokeTransparency = 0.5,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, -26, 0, 12),
            ZIndex = 1,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        local right_components = Create("Frame", {
            Parent = object,
            Name = "",
            Position = UDim2.new(1, 15, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(0, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })

        Create("UIListLayout", {
            Parent = right_components,
            Name = "",
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 3),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local icon_inline = Create("TextButton", {
            Parent = object,
            Name = "",
            Position = UDim2.new(0, -15, 0, 1),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(0, 10, 0, 10),
            BorderSizePixel = 0,
            Text = "", 
            AutoButtonColor = false, 
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local icon = Create("Frame", {
            Parent = icon_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        })

        local icon_2 = Create("Frame", {
            Parent = icon,
            Name = "",
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Library.Theme.Accent
        })
        Library.ThemeObjects[icon_2] = "Accent"

        local glow = Create("ImageLabel", {
            Parent = icon_inline,
            Name = "",
            Visible = false, 
            ImageColor3 = Library.Theme.Accent,
            ScaleType = Enum.ScaleType.Slice,
            ImageTransparency = 0.75,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Image = "http://www.roblox.com/asset/?id=18245826428",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -12, 0, -12),
            Size = UDim2.new(1, 24, 1, 24),
            ZIndex = 2,
            BorderSizePixel = 0,
            SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
        })
        Library.ThemeObjects[glow] = "AccentImage"
    
        local bottom_components = Create("Frame", {
            Parent = object,
            Name = "",
            Visible = true,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.new(0, 0, 0, 13),
            Size = UDim2.new(1, 26, 0, 0),
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        Create("UIListLayout", {
            Parent = bottom_components,
            Name = "",
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
                
        function cfg.set(bool)
            icon_2.Visible = bool
            glow.Visible = bool
            
            Library.Flags[cfg.flag] = bool
            
            cfg.callback(bool)
        end 
    
        Connect(object.MouseButton1Click, function()
            cfg.enabled = not cfg.enabled
    
            cfg.set(cfg.enabled)
        end)

        Connect(icon_inline.MouseButton1Click, function()
            cfg.enabled = not cfg.enabled
    
            cfg.set(cfg.enabled)
        end)

        cfg.set(cfg.default)
    
        cfg.previous_holder = self
        cfg.bottom_holder = bottom_components
        cfg.right_holder = right_components
        
        Library.ConfigFlags[cfg.flag] = cfg.set

        return setmetatable(cfg, {__index = Window})  
    end
    
    function Window:Dropdown(properties) 
        local cfg = {
            name = properties.name or properties.Name or nil,
            flag = properties.flag or properties.Flag or tostring(math.random(1,9999999)),
            items = properties.items or properties.Items or {"1", "2", "3"},
            callback = properties.callback or properties.Callback or function() end,
            multi = properties.multi or properties.Multi or false, 
            open = false, 
            option_instances = {}, 
            multi_items = {}, 
            previous_holder = self
        }
        cfg.default = properties.default or properties.Default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or nil

        local bottom_components
        local object
        
        if cfg.name then 
            object = Create("TextLabel", {
                Parent = self.holder,
                Name = "",
                Font = Enum.Font.Code,
                TextColor3 = Color3.fromRGB(170, 170, 170),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Text = cfg.name,
                TextStrokeTransparency = 0.5,
                Size = UDim2.new(1, -26, 0, 12),
                BorderSizePixel = 0,
                ZIndex = 2,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.Y,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextSize = 12,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            Library.ThemeObjects[object] = "Text"
            
            bottom_components = Create("Frame", {
                Parent = object,
                Name = "",
                Visible = true,
                Position = UDim2.new(0, 0, 0, 13),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, 26, 0, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            
            Create("UIListLayout", {
                Parent = bottom_components,
                Name = "",
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })    
        else 
            self.bottom_holder.Parent.AutomaticSize = Enum.AutomaticSize.Y 
            self.bottom_holder.Parent.TextYAlignment = Enum.TextYAlignment.Top
        end      

        local dropdown_outline = Create("Frame", {
            Parent = cfg.name and bottom_components or self.bottom_holder, 
            Name = "",
            Position = UDim2.new(0, -15, 0, 2),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -26, 0, 16),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        })
        Library.ThemeObjects[dropdown_outline] = "Outline"
        
        local dropdown_inline = Create("Frame", {
            Parent = dropdown_outline,
            Name = "",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        })
        Library.ThemeObjects[dropdown_inline] = "Border"
        
        local dropdown = Create("TextButton", {
            Parent = dropdown_inline,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "...",
            TextStrokeTransparency = 0.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, -2, 1, -2),
            Position = UDim2.new(0, 1, 0, 1),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        Library.ThemeObjects[dropdown] = "Background"
        
        Create("UIPadding", {
            Parent = dropdown,
            Name = "",
            PaddingLeft = UDim.new(0, 5)
        })
        
        local icon = Create("TextLabel", {
            Parent = dropdown,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "+",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(0, 1, 1, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Right,
            Position = UDim2.new(1, -6, 0, -1),
            BorderSizePixel = 0,
            TextSize = 8,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        local content_outline = Create("Frame", {
            Parent = Library.Gui,
            Name = "",
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(0, dropdown_outline.AbsoluteSize.X, 0, 0),
            Position = UDim2.new(0, dropdown_outline.AbsolutePosition.X, 0, dropdown_outline.AbsolutePosition.Y + dropdown_outline.AbsoluteSize.Y + 2),
            BorderSizePixel = 0,
            ZIndex = 9999,
            Visible = false, 
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        })
        Library.ThemeObjects[content_outline] = "Outline"
        
        local content_inline = Create("Frame", {
            Parent = content_outline,
            Name = "",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            ZIndex = 9999,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        })
        Library.ThemeObjects[content_inline] = "Border"

        Connect(dropdown_outline:GetPropertyChangedSignal("AbsolutePosition"), function()
            content_outline.Position = UDim2.new(0, dropdown_outline.AbsolutePosition.X, 0, dropdown_outline.AbsolutePosition.Y + dropdown_outline.AbsoluteSize.Y + 2)
        end)    

        Connect(dropdown_outline:GetPropertyChangedSignal("AbsoluteSize"), function()
            content_outline.Size = UDim2.new(0, dropdown_outline.AbsoluteSize.X, 0, 0)
        end)
        
        local content = Create("Frame", {
            Parent = content_inline,
            Name = "",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        Library.ThemeObjects[content] = "Background"
        
        -- Lerp outline on hover
        local isHovering = false
        local targetColor = dropdown_outline.BackgroundColor3
        local currentColor = dropdown_outline.BackgroundColor3
        
        Connect(RunService.Heartbeat, function()
            targetColor = isHovering and Library.Theme.Accent or (Library.ThemeObjects[dropdown_outline] and Library.Theme[Library.ThemeObjects[dropdown_outline]] or Color3.fromRGB(60, 60, 60))
            currentColor = currentColor:Lerp(targetColor, 0.1)
            dropdown_outline.BackgroundColor3 = currentColor
        end)
        
        Connect(dropdown.MouseEnter, function()
            isHovering = true
        end)
        
        Connect(dropdown.MouseLeave, function()
            isHovering = false
        end)
        
        local options = Create("Frame", {
            Parent = content,
            Name = "",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -4, 1, -4),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        })
        
        Create("UIListLayout", {
            Parent = options,
            Name = "",
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
         
        Create("UIPadding", {
            Parent = options,
            Name = "",
            PaddingBottom = UDim.new(0, 4)
        })

        function cfg.set_visible(bool) 
            content_outline.Visible = bool

            icon.Text = bool and "-" or "+"
            icon.TextSize = bool and 12 or 8

            if cfg.name then 
                object.ZIndex = bool and 9999 or 3
            end 

            if bool then 
                if Library.CurrentElementOpen and Library.CurrentElementOpen ~= cfg then 
                    Library.CurrentElementOpen.set_visible(false)
                    Library.CurrentElementOpen.open = false 
                end

                Library.CurrentElementOpen = cfg 
            end
        end

        function cfg.set(value) 
            local selected = {}

            local is_table = type(value) == "table"

            for _,v in next, cfg.option_instances do 
                if v.Text == value or (is_table and table.find(value, v.Text)) then 
                    table.insert(selected, v.Text)
                    cfg.multi_items = selected
                    v.BackgroundTransparency = 0
                else 
                    v.BackgroundTransparency = 1
                end
            end

            dropdown.Text = is_table and table.concat(selected, ",  ") or selected[1] or "nun"
            Library.Flags[cfg.flag] = is_table and selected or selected[1]
            cfg.callback(Library.Flags[cfg.flag]) 
        end

        function cfg:refresh_options(refreshed_list) 
            -- Clear all existing options (destroy parent outlines)
            for _, v in next, cfg.option_instances do 
                if v and v.Parent and v.Parent.Parent then
                    -- Destroy the outline (grandparent) to remove the entire option
                    v.Parent.Parent:Destroy()
                elseif v then
                    v:Destroy()
                end
            end

            cfg.option_instances = {} 
            
            -- Validate refreshed_list
            if not refreshed_list or type(refreshed_list) ~= "table" or #refreshed_list == 0 then
                warn("[UI] Invalid or empty list provided to refresh_options")
                return
            end

            for i,v in next, refreshed_list do
                -- Skip empty or invalid values
                if not v or v == "" or type(v) ~= "string" then
                    continue
                end
                
                local op_outline = Create("Frame", {
                    Parent = options,
                    Name = "",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                })
                Library.ThemeObjects[op_outline] = "Outline"
                
                local op_inline = Create("Frame", {
                    Parent = op_outline,
                    Name = "",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                })
                Library.ThemeObjects[op_inline] = "Border"
                
                local op = Create("TextButton", {
                    Parent = op_inline,
                    Name = "",
                    Font = Enum.Font.Code,
                    TextColor3 = Color3.fromRGB(170, 170, 170),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = v,
                    BackgroundTransparency = 1,
                    TextStrokeTransparency = 0.5,
                    Size = UDim2.new(1, -2, 1, -2),
                    Position = UDim2.new(0, 1, 0, 1),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                })
                Library.ThemeObjects[op] = "Background"
                
                Create("UIPadding", {
                    Parent = op,
                    Name = "",
                    PaddingLeft = UDim.new(0, 5)
                })
                
                -- Individual hover effect for each option
                local optionHovering = false
                local optionTargetColor = op_outline.BackgroundColor3
                local optionCurrentColor = op_outline.BackgroundColor3
                
                Connect(RunService.Heartbeat, function()
                    optionTargetColor = optionHovering and Library.Theme.Accent or (Library.ThemeObjects[op_outline] and Library.Theme[Library.ThemeObjects[op_outline]] or Color3.fromRGB(60, 60, 60))
                    optionCurrentColor = optionCurrentColor:Lerp(optionTargetColor, 0.1)
                    op_outline.BackgroundColor3 = optionCurrentColor
                end)
                
                Connect(op.MouseEnter, function()
                    optionHovering = true
                end)
                
                Connect(op.MouseLeave, function()
                    optionHovering = false
                end)

                table.insert(cfg.option_instances, op)

                op.MouseButton1Down:Connect(function()
                    if cfg.multi then 
                        local selected_index = table.find(cfg.multi_items, op.Text)

                        if selected_index then 
                            table.remove(cfg.multi_items, selected_index)
                        else
                            table.insert(cfg.multi_items, op.Text)
                        end

                        cfg.set(cfg.multi_items) 				
                    else 
                        cfg.set_visible(false)
                        cfg.open = false 

                        cfg.set(op.Text)
                    end
                end)
            end

            dropdown.Text = ""
        end

        dropdown.MouseButton1Click:Connect(function()
            cfg.open = not cfg.open 

            cfg.set_visible(cfg.open)
        end)

        cfg:refresh_options(cfg.items) 
        cfg.set(cfg.default)

        Library.ConfigFlags[cfg.flag] = cfg.set

        return setmetatable(cfg, {__index = Window})
    end
    
    function Window:Textbox(properties)
        local cfg = {
            placeholder = properties.placeholder or properties.Placeholder or properties.placeholdertext or "type here...",
            default = properties.default or properties.Default,
            clear_on_focus = properties.clearonfocus or properties.ClearOnFocus or false,
            flag = properties.flag or properties.Flag or tostring(math.random(1,9999999)),
            callback = properties.callback or properties.Callback or function() end 
        }

        local textbox_inline = Create("Frame", {
            Parent = self.holder,
            Name = "",
            Position = UDim2.new(0, -15, 0, 2),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(1, -26, 0, 16),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local textbox = Create("TextBox", {
            Parent = textbox_inline,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "",
            TextStrokeTransparency = 0.5,
            Position = UDim2.new(0, 2, 0, 2),
            Size = UDim2.new(1, -4, 1, -4),
            ClearTextOnFocus = cfg.clear_on_focus, 
            PlaceholderColor3 = Color3.fromRGB(90, 90, 90),
            CursorPosition = -1,
            PlaceholderText = cfg.placeholder,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        Library.ThemeObjects[textbox] = "Text"
        
        Connect(textbox:GetPropertyChangedSignal("Text"), function()
            Library.Flags[cfg.flag] = textbox.Text
            cfg.callback(textbox.Text)
        end)

        function cfg.set(text) 
            Library.Flags[cfg.flag] = text
            textbox.Text = text
            cfg.callback(text)
        end 

        if cfg.default then 
            cfg.set(cfg.default) 
        end 

        Library.ConfigFlags[cfg.flag] = cfg.set

        return setmetatable(cfg, {__index = Window})  
    end
    
    function Window:Button(config)
        local cfg = {
            callback = config.Callback or config.callback or function() end,
            name = config.text or config.Text or config.Name or config.name or "Button"
        }
        
        local button_inline = Create("Frame", {
            Parent = self.holder,
            Name = "",
            Position = UDim2.new(0, -15, 0, 2),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(1, -26, 0, 16),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local button = Create("TextButton", {
            Parent = button_inline,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = cfg.name,
            TextStrokeTransparency = 0.5,
            Position = UDim2.new(0, 2, 0, 2),
            Size = UDim2.new(1, -4, 1, -4),
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        Library.ThemeObjects[button] = "Text"
        
        button.MouseButton1Click:Connect(function()
            cfg.callback()
        end)
        
        return setmetatable(cfg, {__index = Window})
    end
    
    function Window:Section(properties)
        local cfg = {
            name = properties.name or properties.Name or "Section", 
            side = properties.side or properties.Side or "left" 
        }
        
        -- Instances
        local section_container = Create("Frame", {
            Parent = self[cfg.side],
            Name = "",
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            ZIndex = 2,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        local section_inline = Create("Frame", {
            Parent = section_container,
            Name = "",
            Position = UDim2.new(0, 0, 0, 4),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(1, 0, 1, -4),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local section_accent = Create("Frame", {
            Parent = section_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -4, 0, 1),
            BorderSizePixel = 0,
            ZIndex = 2,
            BackgroundColor3 = Library.Theme.Accent
        })
        Library.ThemeObjects[section_accent] = "Accent"
        
        local name = Create("TextLabel", {
            Parent = section_inline,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = cfg.name,
            TextStrokeTransparency = 0.5,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 8, 0, 2),
            ZIndex = 3,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        Library.ThemeObjects[name] = "Text"
        
        local section = Create("Frame", {
            Parent = section_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        })
        Library.ThemeObjects[section] = "Background"
        
        local elements = Create("Frame", {
            Parent = section,
            Name = "",
            Position = UDim2.new(0, 12, 0, 12),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -24, 0, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        Create("UIListLayout", {
            Parent = elements,
            Name = "",
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 3)
        })
        
        Create("UIPadding", {
            Parent = section,
            Name = "",
            PaddingBottom = UDim.new(0, 13)
        })    
        
        cfg.holder = elements
        return setmetatable(cfg, {__index = Window})
    end
    
    function Window:Keybind(properties)
        local cfg = {
            flag = properties.flag or properties.Flag or tostring(2^math.random(1,30)*3),
            keybind_name = properties.keybind_name or properties.KeybindName or nil, 
            callback = properties.callback or properties.Callback or function() end,
            open = false,
            binding = nil, 
            name = properties.name or properties.Name or nil, 
            key = properties.key or properties.Key or Enum.KeyCode.Unknown, 
            mode = properties.mode or properties.Mode or "toggle",
            active = properties.default or properties.Default or false,
        }

        Library.Flags[cfg.flag] = {
            _type = "keybind",
            key = cfg.key,
            mode = cfg.mode,
            active = cfg.active
        }

        -- Instances
        local right_components
        if cfg.name then 
            local object = Create("TextLabel", {
                Parent = self.holder,
                Name = "",
                Font = Enum.Font.Code,
                TextColor3 = Color3.fromRGB(170, 170, 170),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Text = cfg.name,
                TextStrokeTransparency = 0.5,
                Size = UDim2.new(1, -26, 0, 12),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextSize = 12,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            
            right_components = Create("Frame", {
                Parent = object,
                Name = "",
                Position = UDim2.new(1, 15, 0, 1),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            
            Create("UIListLayout", {
                Parent = right_components,
                Name = "",
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            })                               
        end

        local keybind = Create("TextButton", {
            Parent = cfg.name and right_components or self.right_holder,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "[...]",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(0, 25, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })

        local content_inline = Create("Frame", {
            Parent = Library.Gui,
            Name = "",
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(0, 57, 0, 0),
            Position = UDim2.new(0, keybind.AbsolutePosition.X, 0, keybind.AbsolutePosition.Y + 15),
            BorderSizePixel = 0,
            ZIndex = 9999,
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false, 
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })

        Connect(keybind:GetPropertyChangedSignal("AbsolutePosition"), function()
            content_inline.Position = UDim2.new(0, keybind.AbsolutePosition.X, 0, keybind.AbsolutePosition.Y + 15)
        end)
        
        local content = Create("Frame", {
            Parent = content_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        
        local options = Create("Frame", {
            Parent = content,
            Name = "",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -4, 1, -4),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        })
        
        Create("UIListLayout", {
            Parent = options,
            Name = "",
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local toggle_btn = Create("TextButton", {
            Parent = options,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "toggle",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 12),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 2, 0, 2),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        })
        
        Create("UIPadding", {
            Parent = toggle_btn,
            Name = "",
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 5)
        })
        
        local hold_btn = Create("TextButton", {
            Parent = options,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "hold",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 12),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 2, 0, 2),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        })
        
        Create("UIPadding", {
            Parent = hold_btn,
            Name = "",
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 5)
        })
        
        local always_btn = Create("TextButton", {
            Parent = options,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "always",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 12),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 2, 0, 2),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        })
        
        Create("UIPadding", {
            Parent = always_btn,
            Name = "",
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 5)
        })
        
        Create("UIPadding", {
            Parent = options,
            Name = "",
            PaddingBottom = UDim.new(0, 4)
        })

        function cfg.set_visible(bool)
            content_inline.Visible = bool

            if bool then 
                if Library.CurrentElementOpen and Library.CurrentElementOpen ~= cfg then 
                    Library.CurrentElementOpen.set_visible(false)
                    Library.CurrentElementOpen.open = false 
                end

                Library.CurrentElementOpen = cfg 
            end
        end 

        function cfg.set_mode(mode) 
            cfg.mode = mode 

            if mode == "always" then
                cfg.set(true)
            elseif mode == "hold" then
                cfg.set(false)
            end

            Library.Flags[cfg.flag] = {
                _type = "keybind",
                mode = cfg.mode, 
                key = cfg.key,
                active = cfg.active 
            }
        end 

        function cfg.set(input)
            if type(input) == "boolean" then 
                local __cached = input 

                if cfg.mode == "always" then 
                    __cached = true 
                end 

                cfg.active = __cached 
                Library.Flags[cfg.flag].active = __cached 
                cfg.callback(__cached)
                
            elseif tostring(input):find("Enum") then 
                input = input.Name == "Escape" and "..." or input
                cfg.key = input or "..."	

                local _text = Keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")
                local _text2 = (tostring(_text):gsub("KeyCode.", ""):gsub("UserInputType.", "")) or "..."
                cfg.key_name = _text2

                Library.Flags[cfg.flag].mode = cfg.mode 
                Library.Flags[cfg.flag].key = cfg.key 

                keybind.Text = "[" .. string.lower(_text2) .. "]"
                cfg.callback(cfg.active or false)
                
            elseif table.find({"toggle", "hold", "always"}, input) then 
                cfg.set_mode(input)

                if input == "always" then 
                    cfg.active = true 
                end 

                cfg.callback(cfg.active or false)
                
            elseif type(input) == "table" then 
                if type(input.key) == "string" and input.key ~= "..." then
                    input.key = Library:ConvertEnum(input.key)
                end

                input.key = input.key == Enum.KeyCode.Escape and "..." or input.key
                cfg.key = input.key or "..."
                
                cfg.mode = input.mode or "toggle"

                if input.active then
                    cfg.active = input.active
                end

                Library.Flags[cfg.flag] = {
                    _type = "keybind",
                    mode = cfg.mode,
                    key = cfg.key, 
                    active = cfg.active
                }

                local text = tostring(cfg.key) ~= "Enums" and (Keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

                keybind.Text = "[" .. string.lower(__text or "...") .. "]"
                cfg.key_name = __text
            end 
        end

        local selected = toggle_btn
        selected.BackgroundTransparency = 0

        hold_btn.MouseButton1Click:Connect(function()
            if selected then 
                selected.BackgroundTransparency = 1
            end 
            selected = hold_btn
            hold_btn.BackgroundTransparency = 0 

            cfg.set_mode("hold") 
            cfg.set_visible(false)
            cfg.open = false 
        end) 

        toggle_btn.MouseButton1Click:Connect(function()
            if selected then 
                selected.BackgroundTransparency = 1
            end 
            selected = toggle_btn
            toggle_btn.BackgroundTransparency = 0 

            cfg.set_mode("toggle") 
            cfg.set_visible(false)
            cfg.open = false 
        end) 

        always_btn.MouseButton1Click:Connect(function()
            if selected then 
                selected.BackgroundTransparency = 1
            end 
            selected = always_btn
            
            always_btn.BackgroundTransparency = 0 
            cfg.set_mode("always") 
            cfg.set_visible(false)
            cfg.open = false 
        end) 

        keybind.MouseButton2Click:Connect(function()
            cfg.open = not cfg.open 
            cfg.set_visible(cfg.open)
        end)
        
        keybind.MouseButton1Down:Connect(function()
            task.wait()
            keybind.Text = "..."	

            cfg.binding = Connect(UIS.InputBegan, function(keycode, game_event)  
                cfg.set(keycode.KeyCode)
                
                if cfg.binding then
                    cfg.binding:Disconnect() 
                    cfg.binding = nil
                end
            end)
        end)

        local toggled = cfg.active
        local inputConnection
        
        local function updateInputConnection()
            if inputConnection then
                inputConnection:Disconnect()
                inputConnection = nil
            end
            
            inputConnection = Connect(UIS.InputBegan, function(input, game_event) 
                if not game_event then 
                    if input.KeyCode == Library.Flags[cfg.flag].key then 
                        if Library.Flags[cfg.flag].mode == "toggle" then 
                            toggled = not toggled
                            cfg.set(toggled)
                        elseif Library.Flags[cfg.flag].mode == "hold" then 
                            cfg.set(true)
                        end
                    end 
                end
            end)
        end
        
        updateInputConnection()
        
        local originalSet = cfg.set
        cfg.set = function(input)
            originalSet(input)
            if tostring(input):find("Enum") then
                updateInputConnection()
            end
        end

        Connect(UIS.InputEnded, function(input, game_event) 
            if game_event then 
                return 
            end 

            if input.KeyCode == Library.Flags[cfg.flag].key then
                if Library.Flags[cfg.flag].mode == "hold" then 
                    cfg.set(false)
                end
            end
        end)

        cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})

        Library.ConfigFlags[cfg.flag] = cfg.set

        return setmetatable(cfg, {__index = Window}) 
    end
    
    function Window:Slider(properties)
        local cfg = {
            name = properties.Name or properties.name or nil,
            suffix = properties.suffix or properties.Suffix or "",
            flag = properties.Flag or properties.flag or tostring(2^789),
            callback = properties.Callback or properties.callback or function() end,
            min = properties.Min or properties.min or properties.minimum or 0,
            max = properties.Max or properties.max or properties.maximum or 100,
            intervals = properties.interval or properties.Interval or properties.decimal or 1,
            default = properties.Default or properties.default or 10,
            dragging = false,
            value = properties.Default or properties.default or 10
        }
        
        Library.Flags[cfg.flag] = cfg.default
        
        local object = Create("TextLabel", {
            Parent = self.holder or self.left,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = cfg.name or "Slider",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, -26, 0, 12),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        Library.ThemeObjects[object] = "Text"
        
        local bottom_components = Create("Frame", {
            Parent = object,
            Name = "",
            Visible = true,
            Position = UDim2.new(0, 0, 0, 13),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 26, 0, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        Create("UIListLayout", {
            Parent = bottom_components,
            Name = "",
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local slider_holder = Create("Frame", {
            Parent = bottom_components,
            Name = "",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        local slider_inline = Create("TextButton", {
            Parent = slider_holder,
            Name = "",
            Position = UDim2.new(0, 0, 0, 1),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(1, -26, 0, 8),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local fill_inline = Create("Frame", {
            Parent = slider_inline,
            Name = "",
            Size = UDim2.new(0.5, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(19, 19, 19)
        })
        
        local fill = Create("Frame", {
            Parent = fill_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, -4),
            BackgroundColor3 = Library.Theme.Accent
        })
        Library.ThemeObjects[fill] = "Accent"
        
        local VALUE_TEXT = Create("TextLabel", {
            Parent = fill_inline,
            Name = "",
            RichText = true,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(0, 1, 0, 11),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0,
            Font = Enum.Font.Code,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        local glow = Create("ImageLabel", {
            Parent = fill_inline,
            Name = "",
            ImageColor3 = Library.Theme.Accent,
            ScaleType = Enum.ScaleType.Slice,
            ImageTransparency = 0.9,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Image = "http://www.roblox.com/asset/?id=18245826428",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -18, 0, -18),
            Size = UDim2.new(1, 36, 1, 36),
            ZIndex = 2,
            BorderSizePixel = 0,
            SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
        })
        
        local add = Create("TextButton", {
            Parent = slider_inline,
            Name = "",
            TextWrapped = true,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "+",
            TextStrokeTransparency = 0.5,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 5, 0, -1),
            Size = UDim2.new(0, 8, 0, 8),
            Font = Enum.Font.Code,
            TextSize = 8,
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        
        local sub = Create("TextButton", {
            Parent = slider_inline,
            Name = "",
            TextWrapped = true,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "-",
            TextStrokeTransparency = 0.5,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -15, 0, -1),
            Size = UDim2.new(0, 8, 0, 8),
            Font = Enum.Font.Code,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        
        local slider = Create("Frame", {
            Parent = slider_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        })
        
        Create("UIPadding", {
            Parent = slider_holder,
            Name = "",
            PaddingBottom = UDim.new(0, -17)
        })
        
        local function Round(value, decimal)
            return math.floor(value / decimal + 0.5) * decimal
        end
        
        function cfg.set(value)
            if type(value) ~= "number" then
                return
            end
            
            cfg.value = math.clamp(Round(value, cfg.intervals), cfg.min, cfg.max)
            fill_inline.Size = UDim2.new((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
            VALUE_TEXT.Text = tostring(cfg.value) .. cfg.suffix
            Library.Flags[cfg.flag] = cfg.value
            cfg.callback(Library.Flags[cfg.flag])
        end
        
        Connect(UIS.InputChanged, function(input)
            if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local size_x = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
                local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                cfg.set(value)
            end
        end)
        
        Connect(UIS.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                cfg.dragging = false
            end
        end)
        
        slider_inline.MouseButton1Down:Connect(function()
            cfg.dragging = true
        end)
        
        add.MouseButton1Down:Connect(function()
            cfg.value = cfg.value + cfg.intervals
            cfg.set(cfg.value)
        end)
        
        sub.MouseButton1Down:Connect(function()
            cfg.value = cfg.value - cfg.intervals
            cfg.set(cfg.value)
        end)
        
        cfg.set(cfg.default)
        
        Library.ConfigFlags[cfg.flag] = cfg.set
        
        return setmetatable(cfg, {__index = Window})
    end
    
    function Window:ColorPicker(properties)            
        local cfg = {
            name = properties.name or nil, 
            flag = properties.flag or tostring(math.random(1, 100000)),
            color = properties.color or Color3.new(1, 1, 1),
            alpha = properties.alpha or 1,
            callback = properties.callback or function() end,
            animation = "normal",
            saved_color = nil,
            right_holder = self.right_holder or nil,
            holder = self.holder or nil
        }

        Library.Flags[cfg.flag] = {}
        
        local dragging_sat = false 
        local dragging_hue = false 
        local dragging_alpha = false 

        local h, s, v = cfg.color:ToHSV() 
        local a = cfg.alpha 

        -- Button Instances
        local right_components 
        if cfg.name then 
            local object = Create("TextLabel", {
                Parent = self.holder,
                Name = "",
                Font = Enum.Font.Code,
                TextColor3 = Color3.fromRGB(170, 170, 170),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Text = cfg.name,
                TextStrokeTransparency = 0.5,
                Size = UDim2.new(1, -26, 0, 12),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextSize = 12,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            
            right_components = Create("Frame", {
                Parent = object,
                Name = "",
                Position = UDim2.new(1, 15, 0, 1),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            
            Create("UIListLayout", {
                Parent = right_components,
                Name = "",
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            })                               
        end 

        local icon_inline = Create("TextButton", {
            Parent = cfg.name and right_components or self.right_holder,
            Name = "",
            Text = "",
            Size = UDim2.new(0, 16, 0, 10),
            Position = UDim2.new(0, -15, 0, 1),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(9, 9, 44)
        })
        
        local icon = Create("Frame", {
            Parent = icon_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(22, 22, 108),
            ZIndex = 2,
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(41, 41, 204)
        })
        
        local glow = Create("ImageLabel", {
            Parent = icon_inline,
            Name = "",
            ImageColor3 = Color3.fromRGB(41, 41, 204),
            ScaleType = Enum.ScaleType.Slice,
            ImageTransparency = 0.9,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Image = "http://www.roblox.com/asset/?id=18245826428",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -20, 0, -20),
            Size = UDim2.new(1, 40, 1, 40),
            ZIndex = 2,
            BorderSizePixel = 0,
            SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
        })

        -- Colorpicker Instances
        local picker_inline = Create("Frame", {
            Parent = Library.Gui,
            Name = "",
            Size = UDim2.new(0, 142, 0, 146),
            Position = UDim2.new(0, icon_inline.AbsolutePosition.X + 1, 0, icon_inline.AbsolutePosition.Y + 17),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            ZIndex = 9999,
            BorderSizePixel = 0,
            Visible = false,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local picker = Create("Frame", {
            Parent = picker_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        
        local sat_inline = Create("TextButton", {
            Parent = picker,
            Name = "",
            Text = "",
            Position = UDim2.new(0, 4, 0, 4),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(1, -8, 1, -50),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local sat = Create("Frame", {
            Parent = sat_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        })
        
        local sat_white = Create("Frame", {
            Parent = sat,
            Name = "",
            Size = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        Create("UIGradient", {
            Parent = sat_white,
            Name = "",
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            }
        })
        
        local sat_black = Create("Frame", {
            Parent = sat_white,
            Name = "",
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        Create("UIGradient", {
            Parent = sat_black,
            Name = "",
            Rotation = 90,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0)
            },
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            }
        })
        
        local sat_black_cursor = Create("Frame", {
            Parent = sat_black,
            Name = "",
            Position = UDim2.new(0.8, 0, 0.2, 0),
            BorderColor3 = Color3.fromRGB(108, 22, 22),
            Size = UDim2.new(0, 1, 0, 1),
            BackgroundColor3 = Color3.fromRGB(204, 41, 41)
        })
        
        local preview_inline = Create("Frame", {
            Parent = picker,
            Name = "",
            Position = UDim2.new(1, -20, 1, -20),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(0, 16, 0, 16),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local preview_border = Create("Frame", {
            Parent = preview_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(38, 38, 38),
            BorderSizePixel = 0
        })
        
        local preview_bg = Create("ImageLabel", {
            Parent = preview_border,
            Name = "",
            ScaleType = Enum.ScaleType.Tile,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Image = "http://www.roblox.com/asset/?id=18274452449",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            TileSize = UDim2.new(0, 6, 0, 6),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        local preview = Create("Frame", {
            Parent = preview_bg,
            Name = "",
            Size = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(204, 41, 41),
            BackgroundTransparency = 0
        })
        
        local hue_inline = Create("TextButton", {
            Parent = picker,
            Text = "",
            Name = "",
            Position = UDim2.new(0, 4, 1, -44),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(1, -8, 0, 10),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local hue_border = Create("Frame", {
            Parent = hue_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        local hue = Create("Frame", {
            Parent = hue_border,
            Name = "",
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        Create("UIGradient", {
            Parent = hue,
            Name = "",
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            }
        })
        
        local hue_cursor = Create("Frame", {
            Parent = hue,
            Name = "",
            BorderColor3 = Color3.fromRGB(108, 22, 22),
            Size = UDim2.new(0, 1, 1, 0),
            BackgroundColor3 = Color3.fromRGB(204, 41, 41)
        })
        
        local input_inline = Create("Frame", {
            Parent = picker,
            Name = "",
            Position = UDim2.new(0, 4, 1, -20),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(1, -26, 0, 16),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local __input = Create("TextBox", {
            Parent = input_inline,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "204, 41, 41, 0.5",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, -4, 1, -4),
            PlaceholderColor3 = Color3.fromRGB(90, 90, 90),
            Position = UDim2.new(0, 2, 0, 2),
            PlaceholderText = "r, g, b, a",
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        
        local alpha_inline = Create("TextButton", {
            Parent = picker,
            Name = "",
            Text = "",
            Position = UDim2.new(0, 4, 1, -32),
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(1, -8, 0, 10),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })
        
        local alpha = Create("Frame", {
            Parent = alpha_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(204, 41, 41)
        })
        
        local alpha_image = Create("ImageLabel", {
            Parent = alpha,
            Name = "",
            ScaleType = Enum.ScaleType.Tile,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Image = "http://www.roblox.com/asset/?id=18343135386",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            TileSize = UDim2.new(0, 6, 0, 6),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        Create("UIGradient", {
            Parent = alpha_image,
            Name = "",
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0)
            }
        })
        
        local alpha_cursor = Create("Frame", {
            Parent = alpha_image,
            Name = "",
            Position = UDim2.new(0.5, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(108, 22, 22),
            Size = UDim2.new(0, 1, 1, 0),
            BackgroundColor3 = Color3.fromRGB(204, 41, 41)
        })

        -- Animation Handling 
        local content_inline = Create("Frame", {
            Parent = Library.Gui,
            Name = "",
            BorderColor3 = Color3.fromRGB(19, 19, 19),
            Size = UDim2.new(0, 73, 0, 0),
            Position = UDim2.new(0, icon_inline.AbsolutePosition.X + 20, 0, icon_inline.AbsolutePosition.Y),
            BorderSizePixel = 0,
            ZIndex = 2,
            Visible = false, 
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(8, 8, 8)
        })

        local content = Create("Frame", {
            Parent = content_inline,
            Name = "",
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Size = UDim2.new(1, -4, 1, -4),
            BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        })
        
        local options = Create("Frame", {
            Parent = content,
            Name = "",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 2, 0, 2),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -4, 1, -4),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        })
        
        Create("UIListLayout", {
            Parent = options,
            Name = "",
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local normal = Create("TextButton", {
            Parent = options,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "normal",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 12),
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 2, 0, 2),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        })
        
        Create("UIPadding", {
            Parent = normal,
            Name = "",
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 5)
        })
        
        local rainbow = Create("TextButton", {
            Parent = options,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "rainbow",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 12),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 2, 0, 2),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        })
        
        Create("UIPadding", {
            Parent = rainbow,
            Name = "",
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 5)
        })
        
        local fade = Create("TextButton", {
            Parent = options,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "fade",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 12),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 2, 0, 2),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        })
        
        Create("UIPadding", {
            Parent = fade,
            Name = "",
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 5)
        })
        
        Create("UIPadding", {
            Parent = options,
            Name = "",
            PaddingBottom = UDim.new(0, 4)
        })
        
        local fade_alpha = Create("TextButton", {
            Parent = options,
            Name = "",
            Font = Enum.Font.Code,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            BorderColor3 = Color3.fromRGB(56, 56, 56),
            Text = "fade alpha",
            TextStrokeTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 12),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 2, 0, 2),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        })
        
        Create("UIPadding", {
            Parent = fade_alpha,
            Name = "",
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 5)
        })            

        function cfg.set_visible(bool)
            picker_inline.Visible = bool
            content_inline.Visible = false
            
            if bool then    
                if Library.CurrentElementOpen and Library.CurrentElementOpen ~= cfg then 
                    Library.CurrentElementOpen.set_visible(false)
                    Library.CurrentElementOpen.open = false 
                end

                Library.CurrentElementOpen = cfg  
            end

            picker_inline.Position = UDim2.new(0, icon_inline.AbsolutePosition.X + 1, 0, icon_inline.AbsolutePosition.Y + 17)
            content_inline.Position = UDim2.new(0, icon_inline.AbsolutePosition.X + 20, 0, icon_inline.AbsolutePosition.Y)
        end 

        icon_inline.MouseButton1Click:Connect(function()		
            cfg.open = not cfg.open

            cfg.set_visible(cfg.open) 
        end)

        icon_inline.MouseButton2Click:Connect(function()
            if cfg.open then 
                cfg.open = false 
                cfg.set_visible(false)
            end 

            content_inline.Visible = not content_inline.Visible

            picker_inline.Position = UDim2.new(0, icon_inline.AbsolutePosition.X + 1, 0, icon_inline.AbsolutePosition.Y + 17)
            content_inline.Position = UDim2.new(0, icon_inline.AbsolutePosition.X + 20, 0, icon_inline.AbsolutePosition.Y)
        end)

        function cfg.set(color, alpha)
            if color then 
                h, s, v = color:ToHSV()
            else 
                cfg.saved_color = Color3.fromHSV(h, s, v)
            end 
        
            if alpha then 
                a = alpha
            end 

            local visual = alpha_inline:FindFirstChildOfClass("Frame")

            if not visual then 
                return 
            end

            local Color = Color3.fromHSV(h, s, v)
            
            local value = h
            local offset = (value < 1) and 0 or -4
            hue_cursor.Position = UDim2.new(value, offset, 0, 0)

            local offset = (a < 1) and 0 or -4
            alpha_cursor.Position = UDim2.new(a, offset, 0, 0)

            visual.BackgroundColor3 = Color
            glow.ImageColor3 = Color
            
            local RGB_Format = visual.BackgroundColor3

            icon_inline.BackgroundColor3 = Color3.fromRGB(RGB_Format.R / 4, RGB_Format.G / 4, RGB_Format.B / 4)
            icon.BorderColor3 = Color3.fromRGB(math.floor((Color.R * 255) + 0.5) / 2, math.floor((Color.G * 255)+0.5) / 2, math.floor((Color.B * 255) + 0.5) / 2)
            icon.BackgroundColor3 = Color
                
            __input.Text = math.floor(RGB_Format.R * 255) .. ", " .. math.floor(RGB_Format.G * 255)  .. ", " .. math.floor(RGB_Format.B * 255) .. ", " .. Library:Round(a, 0.01) 
            preview.BackgroundColor3 = Color
            preview.BackgroundTransparency = a

            sat.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            
            local s_offset = (s < 1) and 0 or -3
            local v_offset = (1 - v < 1) and 0 or -3
            sat_black_cursor.Position = UDim2.new(s, s_offset, 1 - v, v_offset)

            cfg.color = Color
            cfg.alpha = a
 
            Library.Flags[cfg.flag] = {
                Color = Color,
                Transparency = a
            }
            cfg.saved_color = Color3.fromHSV(h, s, v)

            cfg.callback(Color, a)
        end
        
        __input.FocusLost:Connect(function()
            local text = __input.Text
            local r, g, b, alpha_val = text:match("(%d+),%s*(%d+),%s*(%d+),%s*([%d%.]+)")

            if r and g and b and alpha_val then 
                r = math.clamp(tonumber(r) or 255, 0, 255) / 255
                g = math.clamp(tonumber(g) or 255, 0, 255) / 255
                b = math.clamp(tonumber(b) or 255, 0, 255) / 255
                alpha_val = math.clamp(tonumber(alpha_val) or 1, 0, 1)
                cfg.set(Color3.fromRGB(r * 255, g * 255, b * 255), alpha_val)
            end 
        end)
        
        function cfg.update_color() 
            local mouse = UIS:GetMouseLocation() 

            if dragging_sat then	
                s = math.clamp((Vector2.new(mouse.X, mouse.Y - Library.GuiOffset) - sat_white.AbsolutePosition).X / sat_white.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp((Vector2.new(mouse.X, mouse.Y - Library.GuiOffset) - sat_black.AbsolutePosition).Y / sat_black.AbsoluteSize.Y, 0, 1)
            elseif dragging_hue then 
                h = 1 - math.clamp(1 - (Vector2.new(mouse.X, mouse.Y - Library.GuiOffset) - hue_inline.AbsolutePosition).X / hue_inline.AbsoluteSize.X, 0, 1)
            elseif dragging_alpha then 
                a = math.clamp((Vector2.new(mouse.X, mouse.Y - Library.GuiOffset) - alpha_inline.AbsolutePosition).X / alpha_inline.AbsoluteSize.X, 0, 1)
            end

            cfg.set(nil, nil)
        end

        alpha_inline.MouseButton1Down:Connect(function()
            dragging_alpha = true 
        end)

        hue_inline.MouseButton1Down:Connect(function()
            dragging_hue = true 
        end)

        sat_inline.MouseButton1Down:Connect(function()
            dragging_sat = true  
        end)

        cfg.saved_color = Color3.fromHSV(h, s, v)
        local selected = normal
        Library.Flags[cfg.flag]["animation"] = "normal"

        rainbow.MouseButton1Down:Connect(function()
            selected.BackgroundTransparency = 1 
            selected = "rainbow" 
            rainbow.BackgroundTransparency = 0 

            Library.Flags[cfg.flag]["animation"] = "rainbow"
            cfg.saved_color = Color3.fromHSV(h, s, v)
        end)

        fade_alpha.MouseButton1Down:Connect(function()
            selected.BackgroundTransparency = 1 
            selected = "fade_alpha" 
            fade_alpha.BackgroundTransparency = 0 

            Library.Flags[cfg.flag]["animation"] = "fade_alpha"
            cfg.saved_color = Color3.fromHSV(h, s, v)
        end)

        fade.MouseButton1Down:Connect(function()
            selected.BackgroundTransparency = 1 
            selected = "fade" 
            fade.BackgroundTransparency = 0 

            Library.Flags[cfg.flag]["animation"] = "fade"
            cfg.saved_color = Color3.fromHSV(h, s, v)
        end)

        normal.MouseButton1Down:Connect(function()
            selected.BackgroundTransparency = 1 
            selected = "normal" 
            normal.BackgroundTransparency = 0 

            Library.Flags[cfg.flag]["animation"] = "normal"
            cfg.set(cfg.saved_color)
        end)

        Connect(UIS.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging_sat = false
                dragging_hue = false
                dragging_alpha = false 
            end
        end)

        Connect(UIS.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if picker_inline.Visible or content_inline.Visible then
                    task.wait()
                    local mouse = UIS:GetMouseLocation()
                    local mouse_pos = Vector2.new(mouse.X, mouse.Y - Library.GuiOffset)
                    
                    -- Function to check if point is inside frame
                    local function isInside(frame)
                        local pos = frame.AbsolutePosition
                        local size = frame.AbsoluteSize
                        return mouse_pos.X >= pos.X and mouse_pos.X <= pos.X + size.X and
                               mouse_pos.Y >= pos.Y and mouse_pos.Y <= pos.Y + size.Y
                    end
                    
                    -- If click is not inside any of the UI elements, close them
                    if not isInside(picker_inline) and not isInside(content_inline) and not isInside(icon_inline) then
                        cfg.open = false
                        cfg.set_visible(false)
                        content_inline.Visible = false
                    end
                end
            end
        end)

        Connect(UIS.InputChanged, function(input)
            if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                cfg.update_color() 
            end
        end)	

        cfg.set(cfg.color, cfg.alpha)

        self.previous_holder = parent

        Library.ConfigFlags[cfg.flag] = cfg.set

        -- Update colorpicker position when window moves
        Connect(RunService.Heartbeat, function()
            if picker_inline.Visible or content_inline.Visible then
                picker_inline.Position = UDim2.new(0, icon_inline.AbsolutePosition.X + 1, 0, icon_inline.AbsolutePosition.Y + 17)
                content_inline.Position = UDim2.new(0, icon_inline.AbsolutePosition.X + 20, 0, icon_inline.AbsolutePosition.Y)
            end
        end)

        task.spawn(function()
            while true do 
                if selected ~= "normal" then 
                    cfg.set(
                        Color3.fromHSV(
                            selected == "rainbow" and Library.Sin or h, 
                            selected == "rainbow" and 1 or s, 
                            selected == "fade" and Library.Sin or v
                        )
                        , selected == "fade_alpha" and Library.Sin
                    )
                end 
                task.wait() 
            end     
        end)    
        
        return setmetatable(cfg, {__index = Window})  
    end
    
    function Window:Destroy()
        for _, connection in pairs(Library.Connections) do
            if connection then connection:Disconnect() end
        end
        Library.Connections = {}
        if Library.Gui then
            Library.Gui:Destroy()
        end
    end
    
    if showPreview then
        local Tab1 = Window:Tab({Name = "Main"})
        Tab1:Toggle({Name = "Active Preview", Default = true, Callback = function(v) print("Preview:", v) end})
        Tab1:Slider({Name = "Value Test", Min = 0, Max = 100, Default = 50, Callback = function(v) print("Slider:", v) end})
        Tab1:Button({Name = "Print Hello", Callback = function() 
            Library:notification({
                text = "Hello World!",
                time = 3
            })
            print("Hello World") 
        end})
        Tab1:Dropdown({Name = "Select Option", Items = {"Option 1", "Option 2", "Option 3"}, Default = "Option 1", Callback = function(v) print("Selected:", v) end})
        Tab1:Textbox({placeholder = "Type something...", Default = "", Callback = function(v) print("Text:", v) end})
        
        Tab1.open_tab()
    end
    
    return Window
end

return Library
