local AllInOne = {}
local myHero, myPlayer, myTeam, myMana, myFaction, attackRange, myPos, myBase, enemyBase, enemyPosition
local enemy
local comboHero
local q,w,e,r,f
local razeShortPos, razeMidPos, razeLongPos
local remnant_casted = false
local snowball_speed
local nextTick = 0
local nextTick2 = 0
local needTime = 0
local needTime2 = 0
local needAttack
local added = false
local pushing = false
local ebladeCasted = {}
local RearmChannelTime = {}
RearmChannelTime[1] = 3.00
RearmChannelTime[2] = 1.5
RearmChannelTime[3] = 0.75
local clone, clone_q, clone_w, clone_e, clone_mana, clone_state, clone_target, thinker
local clone_hex, clone_orchid, clone_blood, clone_nullifier, clone_silver, clone_mjolnir, clone_manta, clone_midas, clone_bkb, clone_diffusal, clone_satanic, clone_boots, clone_necro
local x,y
local arcPanelW = 120
local arcPanelH = 277
local arcFont = Renderer.LoadFont("Arial", 18, Enum.FontWeight.EXTRABOLD)
local arcPushMode = Config.ReadString("KAIO", "arcPushMode", "Auto")
local arcPushModeLine = Config.ReadString("KAIO", "arcPushModeLine", "min")
local necroTable = {}
local mantaTable = {}
--items
local urn, soulring, vessel, hex, halberd, mjolnir, bkb, nullifier, solar, courage, force, pike, eul, orchid, bloodthorn, diffusal, armlet, lotus, satanic, blademail, blink, abyssal, eblade, phase, discord, shiva, refresher, manta, silver, midas, necro, silver
local time = 0
local cachedHeroIcons = {}
local cachedItemIcons = {}
AllInOne.optionArcEnable = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden"}, "Enable", false)
Menu.AddOptionIcon(AllInOne.optionArcEnable, "panorama/images/items/branches_png.vtex_c")
Menu.AddMenuIcon({"KAIO", "Hero Specific", "Arc Warden"}, "panorama/images/heroes/icons/npc_dota_hero_arc_warden_png.vtex_c")
AllInOne.optionArcMainComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Arc Warden"}, "Main Hero Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionArcCloneComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Arc Warden"}, "Clone Combo Key", Enum.ButtonCode.KEY_V)
AllInOne.optionArcStackClone = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden"}, "Use Clone in Main Hero Combo", true)	
AllInOne.optionArcTargetStyle = Menu.AddOptionCombo({"KAIO", "Hero Specific", "Arc Warden"}, "Target Style", {"Lock Target", "Free Target"}, 0)
AllInOne.optionArcDebuffUnstack = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden"}, "Debuff Unstack", true)
AllInOne.optionArcClonePushKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Arc Warden"}, "Clone Push Key", Enum.ButtonCode.KEY_N)
AllInOne.optionArcMinimumRangeToTP = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Arc Warden"}, "Minimum Range to use travel boots in push mode", 1000,3000,1000)
AllInOne.optionArcDrawPanel = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden"}, "Draw Info Panel", true)
AllInOne.optionArcPanelMoveable = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden"}, "Movable Panel", true)
AllInOne.optionArcEnableFlux = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Skills"}, "Flux", true)
Menu.AddOptionIcon(AllInOne.optionArcEnableFlux, "panorama/images/spellicons/arc_warden_flux_png.vtex_c")
AllInOne.optionArcEnableField = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Skills"}, "Magnetic Field", true)
Menu.AddOptionIcon(AllInOne.optionArcEnableField, "panorama/images/spellicons/arc_warden_magnetic_field_png.vtex_c")
AllInOne.optionArcEnableSpark = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Skills"}, "Spark Wraith", true)
Menu.AddOptionIcon(AllInOne.optionArcEnableSpark, "panorama/images/spellicons/arc_warden_spark_wraith_png.vtex_c", true)
AllInOne.optionArcEnableBkb = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionArcEnableBlood = Menu.AddOptionBool({"KAIO", "Hero Specific","Arc Warden", "Items"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionArcEnableDiffusal = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Diffusal Blade", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableDiffusal, "panorama/images/items/diffusal_blade_png.vtex_c")
AllInOne.optionArcEnableMidas = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Hand of Midas", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableMidas, "panorama/images/items/hand_of_midas_png.vtex_c")
AllInOne.optionArcEnableManta = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Manta Style", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableManta, "panorama/images/items/manta_png.vtex_c")
AllInOne.optionArcEnableMjolnir = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Mjolnir", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableMjolnir, "panorama/images/items/mjollnir_png.vtex_c")
AllInOne.optionArcEnableNecro = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Necronomicon", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableNecro, "panorama/images/items/necronomicon_3_png.vtex_c")
AllInOne.optionArcEnableNulifier = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Nullifier", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableNulifier, "panorama/images/items/nullifier_png.vtex_c")
AllInOne.optionArcEnableOrchid = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionArcEnableSatanic = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Satanic", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableSatanic, "panorama/images/items/satanic_png.vtex_c")
AllInOne.optionArcSatanicThreshold = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "HP Percent for satanic use", 1, 50, 15)
AllInOne.optionArcEnableHex = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Scythe of Vyse", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionArcEnableSilver = Menu.AddOptionBool({"KAIO", "Hero Specific", "Arc Warden", "Items"}, "Silver Edge", false)
Menu.AddOptionIcon(AllInOne.optionArcEnableSilver, "panorama/images/items/silver_edge_png.vtex_c")
AllInOne.optionClinkzEnable = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz"}, "Enable", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnable, "panorama/images/items/branches_png.vtex_c")
Menu.AddMenuIcon({"KAIO","Hero Specific", "Clinkz"}, "panorama/images/heroes/icons/npc_dota_hero_clinkz_png.vtex_c")
AllInOne.optionClinkzComboKey = Menu.AddKeyOption({"KAIO","Hero Specific", "Clinkz"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionClinkzTargetStyle = Menu.AddOptionCombo({"KAIO", "Hero Specific", "Clinkz"}, "Target Style", {"Free Target", "Lock Target"}, 1)
AllInOne.optionClinkzEnableBkb = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionClinkzEnableBlood = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionClinkzEnableCourage = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Medallion of Courage", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableCourage, "panorama/images/items/medallion_of_courage_png.vtex_c")
AllInOne.optionClinkzEnableDiffusal = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Diffusal Blade", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableDiffusal, "panorama/images/items/diffusal_blade_png.vtex_c")
AllInOne.optionClinkzEnableHex = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionClinkzEnableNullifier = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Nullifier", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableNullifier, "panorama/images/items/nullifier_png.vtex_c")
AllInOne.optionClinkzEnableOrchid = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionClinkzEnableSolar = Menu.AddOptionBool({"KAIO","Hero Specific", "Clinkz", "Combo"}, "Solar Crest", false)
Menu.AddOptionIcon(AllInOne.optionClinkzEnableSolar, "panorama/images/items/solar_crest_png.vtex_c")
AllInOne.optionClinkzEnableStack = Menu.AddOptionBool({"KAIO", "Hero Specific", "Clinkz"}, "Stack Hex/orchid+nullifier", false)
AllInOne.optionEmberEnable = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit"}, "Enable", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnable, "panorama/images/items/branches_png.vtex_c")
Menu.AddMenuIcon({"KAIO", "Hero Specific", "Ember Spirit"}, "panorama/images/heroes/icons/npc_dota_hero_ember_spirit_png.vtex_c")
AllInOne.optionEmberAutoChain = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit"}, "Auto Cast Chains After Fist")
AllInOne.optionEmberComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Ember Spirit"}, "Combo Key", Enum.ButtonCode.KEY_F)
AllInOne.optionEmberComboRadius = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Ember Spirit"}, "Combo Radius", 250, 1500, 1500)
AllInOne.optionEmberEnableChains = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Searing Chains", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableChains, "panorama/images/spellicons/ember_spirit_searing_chains_png.vtex_c")
AllInOne.optionEmberEnableFist = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Sleight of Fist", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableFist, "panorama/images/spellicons/ember_spirit_sleight_of_fist_png.vtex_c")
AllInOne.optionEmberEnableFlame = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Flame Guard", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableFlame, "panorama/images/spellicons/ember_spirit_flame_guard_png.vtex_c")
AllInOne.optionEmberEnableRemnant = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Fire Remnant", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableRemnant, "panorama/images/spellicons/ember_spirit_fire_remnant_png.vtex_c")
AllInOne.optionEmberSaveRemnantCount = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Ember Spirit", "Skills"}, "Fire Remnant Save Count", 0, 2, 0)
AllInOne.optionEmberEnableBkb = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionEmberEnableBlademail = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Blademail", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableBlademail, "panorama/images/items/blade_mail_png.vtex_c")
AllInOne.optionEmberEnableBloodthorn = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableBloodthorn, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionEmberEnableDiscord = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Veil of Discord", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableDiscord, "panorama/images/items/veil_of_discord_png.vtex_c")
AllInOne.optionEmberEnableOrchid = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionEmberEnableShiva = Menu.AddOptionBool({"KAIO", "Hero Specific", "Ember Spirit", "Items"}, "Shiva's Guard", false)
Menu.AddOptionIcon(AllInOne.optionEmberEnableShiva, "panorama/images/items/shivas_guard_png.vtex_c")
AllInOne.optionEnigmaEnable = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma"}, "Enable", false)
Menu.AddMenuIcon({"KAIO", "Hero Specific", "Enigma"}, "panorama/images/heroes/icons/npc_dota_hero_enigma_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionEnigmaEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionEnigmaComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Enigma"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionEnigmaComboRadius = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Enigma"}, "Combo Radius", 420, 1200, 1200)
AllInOne.optionEnigmaComboPos = Menu.AddOptionCombo({"KAIO", "Hero Specific", "Enigma"}, "Combo Position", {"Auto Find Better Position [BETA]", "Cursor Position"}, 0)
AllInOne.optionEnigmaEnablePulse = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma", "Skills"}, "Midnight Pulse", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnablePulse, "panorama/images/spellicons/enigma_midnight_pulse_png.vtex_c")
AllInOne.optionEnigmaEnableBkb = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionEnigmaEnableBlink = Menu.AddOptionBool({"KAIO", "Hero Specific","Enigma", "Items"}, "Blink Dagger", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionEnigmaEnableRefresher = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma", "Items"}, "Refresher Orb", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnableRefresher, "panorama/images/items/refresher_png.vtex_c")
AllInOne.optionEnigmaEnableShiva = Menu.AddOptionBool({"KAIO", "Hero Specific", "Enigma", "Items"}, "Shiva's Guard", false)
Menu.AddOptionIcon(AllInOne.optionEnigmaEnableShiva, "panorama/images/items/shivas_guard_png.vtex_c")
AllInOne.optionLionEnable = Menu.AddOptionBool({"KAIO", "Hero Specific", "Lion"}, "Enable", false)
Menu.AddMenuIcon({"KAIO", "Hero Specific", "Lion"}, "panorama/images/heroes/icons/npc_dota_hero_lion_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionLionEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionLionComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Lion"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionLionComboRadius = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Lion"}, "Safe Radius for Blink", 0, 600, 250)
AllInOne.optionLionEnableSpike = Menu.AddOptionBool({"KAIO", "Hero Specific", "Lion", "Skills"}, "Earth Spike", false)
Menu.AddOptionIcon(AllInOne.optionLionEnableSpike, "panorama/images/spellicons/lion_impale_png.vtex_c")
AllInOne.optionLionEnableHex = Menu.AddOptionBool({"KAIO", "Hero Specific", "Lion", "Skills"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionLionEnableHex, "panorama/images/spellicons/lion_voodoo_png.vtex_c")
AllInOne.optionLionEnableFinger = Menu.AddOptionBool({"KAIO", "Hero Specific", "Lion", "Skills"}, "Finger of Death", false)
Menu.AddOptionIcon(AllInOne.optionLionEnableFinger, "panorama/images/spellicons/lion_finger_of_death_png.vtex_c")
AllInOne.optionLionEnableBlink = Menu.AddOptionBool({"KAIO", "Hero Specific", "Lion", "Items"}, "Blink Dagger", false)
Menu.AddOptionIcon(AllInOne.optionLionEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionLionMinimumBlinkRange = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Lion", "Items"}, "Minimum Blink Range", 250, 1150, 800)
AllInOne.optionLionEnableEblade = Menu.AddOptionBool({"KAIO", "Hero Specific", "Lion", "Items"}, "Ethereal Blade", false)
Menu.AddOptionIcon(AllInOne.optionLionEnableEblade, "panorama/images/items/ethereal_blade_png.vtex_c")
AllInOne.optionLionEnableDagon = Menu.AddOptionBool({"KAIO", "Hero Specific", "Lion", "Items"}, "Dagon", false)
Menu.AddOptionIcon(AllInOne.optionLionEnableDagon, "panorama/images/items/dagon_5_png.vtex_c")
AllInOne.optionLegionEnable = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander"}, "Enable", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionLegionOnlyWithDuel = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander"}, "Combo only when duel ready", false)
Menu.AddOptionIcon(AllInOne.optionLegionOnlyWithDuel, "panorama/images/spellicons/legion_commander_duel_png.vtex_c")
Menu.AddMenuIcon({"KAIO","Hero Specific", "Legion Commander"}, "panorama/images/heroes/icons/npc_dota_hero_legion_commander_png.vtex_c")
AllInOne.optionLegionComboKey = Menu.AddKeyOption({"KAIO","Hero Specific", "Legion Commander"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionLegionEnablePressTheAttack = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Skills"}, "Press The Attack", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnablePressTheAttack, "panorama/images/spellicons/legion_commander_press_the_attack_png.vtex_c")
AllInOne.optionLegionEnableDuel = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Skills"}, "Duel", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableDuel, "panorama/images/spellicons/legion_commander_duel_png.vtex_c")
AllInOne.optionLegionEnableAbyssalWithDuel = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Abbysal Blade In Duel", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableAbyssalWithDuel, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionLegionEnableAbyssalWthDuel = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Abbysal Without Duel", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableAbyssalWthDuel, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionLegionEnableArmlet = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Armlet of Mordiggian", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableArmlet, "panorama/images/items/armlet_png.vtex_c")
AllInOne.optionLegionEnableBkb = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionLegionEnableBlademail = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Blade Mail", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBlademail, "panorama/images/items/blade_mail_png.vtex_c")
AllInOne.optionLegionEnableBlink = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Blink Dagger", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionLegionEnableBlood = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionLegionEnableCourage = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Medallion of Courage", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableCourage, "panorama/images/items/medallion_of_courage_png.vtex_c")
AllInOne.optionLegionEnableHalberd = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Heavens Halberd", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableHalberd, "panorama/images/items/heavens_halberd_png.vtex_c")
AllInOne.optionLegionEnableLotus = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Lotus Orb", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableLotus, "panorama/images/items/lotus_orb_png.vtex_c")
AllInOne.optionLegionEnableMjolnir = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Mjolnir", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableMjolnir, "panorama/images/items/mjollnir_png.vtex_c")
AllInOne.optionLegionEnableOrchid = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionLegionEnableSatanic = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Satanic", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableSatanic, "panorama/images/items/satanic_png.vtex_c")
AllInOne.optionLegionSatanicThreshold = Menu.AddOptionSlider({"KAIO","Hero Specific", "Legion Commander", "Items"}, "HP Percent for satanic use", 1, 100, 15)
AllInOne.optionLegionEnableSolar = Menu.AddOptionBool({"KAIO","Hero Specific", "Legion Commander", "Items"}, "Solar Crest", false)
Menu.AddOptionIcon(AllInOne.optionLegionEnableSolar, "panorama/images/items/solar_crest_png.vtex_c")
AllInOne.optionLegionBlinkRange = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Legion Commander"}, "Minimum Blink Range", 200, 1150, 300)
AllInOne.optionSfEnable = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend"}, "Enable", false)
Menu.AddMenuIcon({"KAIO","Hero Specific", "Shadow Fiend"}, "panorama/images/heroes/icons/npc_dota_hero_nevermore_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionSfEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionSfRazeKey = Menu.AddKeyOption({"KAIO","Hero Specific", "Shadow Fiend"}, "Auto Raze Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionSfDrawRazePos = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend"}, "Draw Raze Position", false)
AllInOne.optionSfComboKey = Menu.AddKeyOption({"KAIO","Hero Specific", "Shadow Fiend"}, "Eul combo key", Enum.ButtonCode.KEY_F)
AllInOne.optionSfEnableBkb = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionSfEnableBlink = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Blink", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionSfEnableBlood = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionSfEnableDagon = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Dagon", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableDagon, "panorama/images/items/dagon_5_png.vtex_c")
AllInOne.optionSfEnableEthereal = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Ethereal blade", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableEthereal, "panorama/images/items/ethereal_blade_png.vtex_c")
AllInOne.optionSfEnableHex = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionSfEnableOrchid = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionSfEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionSfEnablePhase = Menu.AddOptionBool({"KAIO","Hero Specific", "Shadow Fiend", "Eul Combo"}, "Phase Boots", false)
Menu.AddOptionIcon(AllInOne.optionSfEnablePhase, "panorama/images/items/phase_boots_png.vtex_c")
AllInOne.optionTinkerEnable = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker"}, "Enable", false)
Menu.AddMenuIcon({"KAIO","Hero Specific","Tinker"}, "panorama/images/heroes/icons/npc_dota_hero_tinker_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionTinkerEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionTinkerComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Tinker"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionTinkerSpamKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Tinker"}, "Spam Rockets Key", Enum.ButtonCode.KEY_F)
AllInOne.optionTinkerFailSwitch = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker"}, "Rocket and Rearm failswitch", true)
AllInOne.optionTinkerPoopLaser = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker"}, "Poop Linken with Laser", false)
AllInOne.optionTinkerTargetStyle = Menu.AddOptionCombo({"KAIO", "Hero Specific", "Tinker"}, "Target Style", {"Free Target", "Lock Target"}, 1)
AllInOne.optionTinkerCheckBM = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker"}, "Check BM/Lotus", true)
AllInOne.optionTinkerEnableRockets = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Skills"}, "Heat-Seeking Missle", true)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableRockets, "panorama/images/spellicons/tinker_heat_seeking_missile_png.vtex_c")
AllInOne.optionTinkerEnableRearm = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Skills"}, "Rearm", true)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableRearm, "panorama/images/spellicons/tinker_rearm_png.vtex_c")
AllInOne.optionTinkerEnableBkb = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionTinkerEnableBlink = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Blink Dagger", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableBlink, "panorama/images/items/blink_png.vtex_c")
AllInOne.optionTinkerBlinkSafeRange = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Tinker", "Items"}, "Safe Radius for Blink", 0, 800, 400)
AllInOne.optionTinkerBlinkStyle = Menu.AddOptionCombo({"KAIO", "Hero Specific", "Tinker"}, "Blink Style", {"Auto Blink Safe Pozition", "Cursor Position"}, 0)
AllInOne.optionTinkerEnableBlood = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionTinkerEnableDagon = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Dagon", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableDagon, "panorama/images/items/dagon_5_png.vtex_c")
AllInOne.optionTinkerEnableEblade = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Ethereal Blade", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableEblade, "panorama/images/items/ethereal_blade_png.vtex_c")
AllInOne.optionTinkerEnableLotus = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Lotus Orb", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableLotus, "panorama/images/items/lotus_orb_png.vtex_c")
AllInOne.optionTinkerEnableOrchid = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionTinkerEnableHex = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Scythe of Vyse", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionTinkerEnableShiva = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Shiva's Guard", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableShiva, "panorama/images/items/shivas_guard_png.vtex_c")
AllInOne.optionTinkerEnableSoul = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Soul Ring", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableSoul, "panorama/images/items/soul_ring_png.vtex_c")
AllInOne.optionTinkerThreshold = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Tinker", "Items"}, "HP Percent Threshold for use soulring", 0, 99, 10)
AllInOne.optionTinkerEnableDiscord = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tinker", "Items"}, "Veil of Discord", false)
Menu.AddOptionIcon(AllInOne.optionTinkerEnableDiscord, "panorama/images/items/veil_of_discord_png.vtex_c")
AllInOne.optionTuskEnable = Menu.AddOptionBool({"KAIO","Hero Specific" ,"Tusk"}, "Enable", false)
Menu.AddMenuIcon({"KAIO", "Hero Specific", "Tusk"}, "panorama/images/heroes/icons/npc_dota_hero_tusk_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionTuskEnable, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionTuskEnablePickTeam = Menu.AddOptionBool({"KAIO","Hero Specific", "Tusk"}, "Pick teammates to the snowball", false)
AllInOne.optionTuskComboKey = Menu.AddKeyOption({"KAIO", "Hero Specific", "Tusk"}, "Combo Key", Enum.ButtonCode.KEY_Z)
AllInOne.optionTuskEnableShard = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Skills"}, "Ice Shards", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableShard, "panorama/images/spellicons/tusk_ice_shards_png.vtex_c")
AllInOne.optionTuskEnableSnowball = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Skills"}, "Snowball", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableSnowball, "panorama/images/spellicons/tusk_snowball_png.vtex_c")
AllInOne.optionTuskEnableSigil = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Skills"}, "Frozen Sigil", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableSigil, "panorama/images/spellicons/tusk_frozen_sigil_png.vtex_c")
AllInOne.optionTuskEnablePunch = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Skills"}, "Walrus Punch", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnablePunch, "panorama/images/spellicons/tusk_walrus_punch_png.vtex_c")
AllInOne.optionTuskEnableAbyssal = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Abyssal Blade", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableAbyssal, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionTuskEnableArmlet = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Armlet of Mordiggian", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableArmlet, "panorama/images/items/armlet_png.vtex_c")
AllInOne.optionTuskEnableBkb = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Black King Bar", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableBkb, "panorama/images/items/black_king_bar_png.vtex_c")
AllInOne.optionTuskEnableBlood = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionTuskEnableCourage = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Medallion of Courage", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableCourage, "panorama/images/items/medallion_of_courage_png.vtex_c")
AllInOne.optionTuskEnableHalberd = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Heavens Halberd", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableHalberd, "panorama/images/items/heavens_halberd_png.vtex_c")
AllInOne.optionTuskEnableMjolnir = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Mjolnir", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableMjolnir, "panorama/images/items/mjollnir_png.vtex_c")
AllInOne.optionTuskEnableOrchid = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableOrchid, "panorama/images/items/orchid_png.vtex_c")
AllInOne.optionTuskEnableSolar = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Solar Crest", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableSolar, "panorama/images/items/solar_crest_png.vtex_c")
AllInOne.optionTuskEnableUrn = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Urn of Shadows", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableUrn, "panorama/images/items/urn_of_shadows_png.vtex_c")
AllInOne.optionTuskEnableVessel = Menu.AddOptionBool({"KAIO", "Hero Specific", "Tusk", "Items"}, "Spirit Vessel", false)
Menu.AddOptionIcon(AllInOne.optionTuskEnableVessel, "panorama/images/items/spirit_vessel_png.vtex_c")
AllInOne.optionTuskComboRadius = Menu.AddOptionSlider({"KAIO", "Hero Specific", "Tusk"}, "Combo Radius", 200, 2500, 1500)
AllInOne.optionEnablePoopLinken = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Enable", false)
Menu.AddMenuIcon({"KAIO", "Poop Linken"}, "panorama/images/items/sphere_png.vtex_c")
Menu.AddOptionIcon(AllInOne.optionEnablePoopLinken, "panorama/images/items/branches_png.vtex_c")
AllInOne.optionEnablePoopAbyssal = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Abyssal Blade", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopAbyssal, "panorama/images/items/abyssal_blade_png.vtex_c")
AllInOne.optionEnablePoopBlood = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Bloodthorn", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopBlood, "panorama/images/items/bloodthorn_png.vtex_c")
AllInOne.optionEnablePoopDagon = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Dagon", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopDagon, "panorama/images/items/dagon_5_png.vtex_c")
AllInOne.optionEnablePoopDiffusal = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Diffusal Blade", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopDiffusal, "panorama/images/items/diffusal_blade_png.vtex_c")
AllInOne.optionEnablePoopEul = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Eul", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopEul, "panorama/images/items/cyclone_png.vtex_c")
AllInOne.optionEnablePoopForce = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Force Staff", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopForce, "panorama/images/items/force_staff_png.vtex_c")
AllInOne.optionEnablePoopHalberd = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Heavens Halberd", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopHalberd, "panorama/images/items/heavens_halberd_png.vtex_c")
AllInOne.optionEnablePoopHex = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Hex", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopHex, "panorama/images/items/sheepstick_png.vtex_c")
AllInOne.optionEnablePoopPike = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Hurricane Pike", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopPike, "panorama/images/items/hurricane_pike_png.vtex_c")
AllInOne.optionEnablePoopOrchid = Menu.AddOptionBool({"KAIO", "Poop Linken"}, "Orchid", false)
Menu.AddOptionIcon(AllInOne.optionEnablePoopOrchid, "panorama/images/items/orchid_png.vtex_c")
function AllInOne.Init( ... )
	myHero = Heroes.GetLocal()
	nextTick = 0
	nextTick2 = 0
	needTime = 0
	needTime2 = 0
	time = 0
	added = false
	if not myHero then return end
	if NPC.GetUnitName(myHero) == "npc_dota_hero_clinkz" then
		comboHero = "Clinkz"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_legion_commander" then
		comboHero = "Legion"
		w = NPC.GetAbilityByIndex(myHero, 1)
		r = NPC.GetAbility(myHero, "legion_commander_duel")
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_nevermore" then
		comboHero = "SF"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
		e = NPC.GetAbilityByIndex(myHero, 2)
		r = NPC.GetAbility(myHero, "nevermore_requiem")
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_tusk" then
		comboHero = "Tusk"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
		e = NPC.GetAbilityByIndex(myHero, 2)
		f = NPC.GetAbility(myHero, "tusk_launch_snowball")
		r = NPC.GetAbility(myHero, "tusk_walrus_punch")
		snowball_speed = 600
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_ember_spirit" then
		comboHero = "Ember"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
		e = NPC.GetAbilityByIndex(myHero, 2)
		r = NPC.GetAbility(myHero, "ember_spirit_fire_remnant")
		f = NPC.GetAbility(myHero, "ember_spirit_activate_fire_remnant")
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_enigma" then
		comboHero = "Enigma"
		e = NPC.GetAbilityByIndex(myHero, 2)
		r = NPC.GetAbility(myHero, "enigma_black_hole")
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_lion" then
		comboHero = "Lion"
		q = NPC.GetAbilityByIndex(myHero,0)
		w = NPC.GetAbilityByIndex(myHero, 1)
		r = NPC.GetAbility(myHero, "lion_finger_of_death")
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_tinker" then
		comboHero = "Tinker"
		q = NPC.GetAbilityByIndex(myHero, 0)
		w = NPC.GetAbilityByIndex(myHero, 1)
		r = NPC.GetAbility(myHero, "tinker_rearm")
	elseif NPC.GetUnitName(myHero) == "npc_dota_hero_arc_warden" then
		comboHero = "Arc"
		q = NPC.GetAbility(myHero, "arc_warden_flux")
		w = NPC.GetAbility(myHero, "arc_warden_magnetic_field")
		e = NPC.GetAbility(myHero, "arc_warden_spark_wraith")
		r = NPC.GetAbility(myHero, "arc_warden_tempest_double")
		local w,h = Renderer.GetScreenSize()
		x = Config.ReadInt("KAIO", "arcPanelX", w/2)
		y = Config.ReadInt("KAIO", "arcPanelY", h/2)
	else	
		myHero = nil
		return	
	end
	myTeam = Entity.GetTeamNum(myHero)
	if myTeam == 2 then -- radiant
		myBase = Vector(-7328.000000, -6816.000000, 512.000000)
		enemyBase = Vector(7141.750000, 6666.125000, 512.000000)
		myFaction = "radiant"
	else
		myBase = Vector(7141.750000, 6666.125000, 512.000000)
		enemyBase = Vector(-7328.000000, -6816.000000, 512.000000)
		myFaction = "dire"
	end
	myPlayer = Players.GetLocal()
end
function AllInOne.OnGameStart( ... )
	AllInOne.Init()
end
function AllInOne.ClearVar( ... )
	urn = nil
	vessel = nil 
	hex = nil
	halberd = nil 
	mjolnir = nil
	bkb = nil
	nullifier = nil 
	solar = nil 
	courage = nil 
	force = nil
	pike = nil
	eul = nil
	orchid = nil
	bloodthorn = nil
	diffusal = nil
	armlet = nil 
	lotus = nil 
	satanic = nil 
	blademail = nil
	blink = nil
	abyssal = nil
	discrd = nil
	phase = nil
	dagon = nil
	eblade = nil
	shiva = nil
	refresher = nil
	soulring = nil
	necro = nil
	manta = nil
	silver = nil
end
function AllInOne.cloneClearVar( ... )
	clone_hex = nil
	clone_orchid = nil
	clone_blood = nil
	clone_nullifier = nil
	clone_silver = nil
	clone_mjolnir = nil
	clone_manta = nil
	clone_midas = nil
	clone_bkb = nil
	clone_diffusal = nil
	clone_satanic = nil
	clone_necro = nil
	clone_boots = nil
	clone_silver = nil
end
function AllInOne.OnUpdate( ... )
	if not myHero then return end
	myMana = NPC.GetMana(myHero)
	time = GameRules.GetGameTime()
	myPos = Entity.GetAbsOrigin(myHero)
	if comboHero == "Clinkz" and Menu.IsEnabled(AllInOne.optionClinkzEnable) then
		if Menu.IsKeyDown(AllInOne.optionClinkzComboKey) then
			if Menu.GetValue(AllInOne.optionClinkzTargetStyle) == 1 and not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			elseif Menu.GetValue(AllInOne.optionClinkzTargetStyle) == 0 then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				AllInOne.ClinkzCombo()
			end
		else
			enemy = nil
		end
	elseif comboHero == "Arc" and Menu.IsEnabled(AllInOne.optionArcEnable) then
		if Ability.GetLevel(r) > 0 then
			AllInOne.DrawArcPanel()
		end
		AllInOne.ArcPush()
		if clone and Entity.IsAlive(clone) then
			clone_mana = NPC.GetMana(clone)
			AllInOne.cloneClearVar()
			for i = 0, 5 do
			item = NPC.GetItemByIndex(clone, i)
				if item and item ~= 0 then
					local name = Ability.GetName(item)
					if name == "item_sheepstick" then
						clone_hex = item
					elseif name == "item_nullifier" then
						clone_nullifier = item
					elseif name == "item_diffusal_blade" then
						clone_diffusal = item
					elseif name == "item_mjollnir" then
						clone_mjolnir = item
					elseif name == "item_bloodthorn" then
						clone_blood = item
					elseif name == "item_black_king_bar" then
						clone_bkb = item
					elseif name == "item_orchid" then
						clone_orchid = item
					elseif name == "item_satanic" then
						clone_satanic = item
					elseif name == "item_manta" then
						clone_manta = item
					elseif name == "item_travel_boots" or name == "item_travel_boots_2" then
						clone_boots = item	
					elseif name == "item_hand_of_midas" then
						clone_midas = item
					elseif name == "item_necronomicon"	 or name == "item_necronomicon_2" or name == "item_necronomicon_3" then
						clone_necro = item
					elseif name == "item_silver_edge" then
						clone_silver = item	
					end	 
				end
			end
		end
		if Menu.IsKeyDown(AllInOne.optionArcMainComboKey) then
			if Menu.GetValue(AllInOne.optionArcTargetStyle) == 0 and not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			elseif Menu.GetValue(AllInOne.optionArcTargetStyle) == 1 then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				AllInOne.ArcCombo()
			end
		elseif Menu.IsKeyDown(AllInOne.optionArcCloneComboKey) then
			if Menu.GetValue(AllInOne.optionArcTargetStyle) == 0 and not clone_target then
				clone_target = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			elseif Menu.GetValue(AllInOne.optionArcTargetStyle) == 1 then
				clone_target = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if clone_target and Entity.IsAlive(clone_target) then
				AllInOne.ArcCloneCombo(clone_target)
			end
		else
			added = false
			enemy = nil	
		end
		if Menu.IsKeyDownOnce(AllInOne.optionArcClonePushKey) and ((clone and Entity.IsEntity(clone) and Entity.IsAlive(clone)) or Ability.IsCastable(r, myMana))  then
			pushing = true
		end
		if clone_target and not Menu.IsKeyDown(AllInOne.optionArcMainComboKey) and not Menu.IsKeyDown(AllInOne.optionArcCloneComboKey) and not pushing then
			clone_target = nil
		end
	elseif comboHero == "Legion" and Menu.IsEnabled(AllInOne.optionLegionEnable) then
		if Menu.IsKeyDown(AllInOne.optionLegionComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				AllInOne.LegionCombo()
			end
		else
			enemy = nil
		end
	elseif comboHero == "SF" and Menu.IsEnabled(AllInOne.optionSfEnable) then
		if Menu.IsKeyDown(AllInOne.optionSfComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				AllInOne.SfCombo(eul)
			end
		else
			enemy = nil
		end
		AllInOne.SfAutoRaze()
	elseif comboHero == "Tusk" and Menu.IsEnabled(AllInOne.optionTuskEnable) then
		if Menu.IsKeyDown(AllInOne.optionTuskComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				AllInOne.TuskCombo()
			end
		else
			enemy = nil	
		end
	elseif comboHero == "Ember" and Menu.IsEnabled(AllInOne.optionEmberEnable) then
		if Menu.IsKeyDown(AllInOne.optionEmberComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				AllInOne.EmberCombo()
			end
		elseif Menu.IsEnabled(AllInOne.optionEmberAutoChain) then
			if NPC.HasModifier(myHero, "modifier_ember_spirit_sleight_of_fist_marker") or NPC.HasModifier(myHero, "modifier_ember_spirit_sleight_of_fist_caster") or NPC.HasModifier(myHero, "modifier_ember_spirit_sleight_of_fist_caster_invulnerability") then
				if not enemy then
					if Heroes.InRadius(myPos,150, myTeam, Enum.TeamType.TEAM_ENEMY) then
						for i, k in pairs(Heroes.InRadius(myPos,150, myTeam, Enum.TeamType.TEAM_ENEMY)) do
							enemy = k
							break
						end
					end
				end
				if enemy and Entity.IsAlive(enemy) then
					enemyPosition = Entity.GetAbsOrigin(enemy)
					if NPC.IsEntityInRange(myHero, enemy, 125) then
						if Ability.IsCastable(q,myMana) then
							Ability.CastNoTarget(q)
						end
					end
				end
			else
				if not Menu.IsKeyDown(AllInOne.optionEmberComboKey) then
					enemy = nil
				end	
			end
		else	
			enemy = nil	
		end
	elseif comboHero == "Enigma" and Menu.IsEnabled(AllInOne.optionEnigmaEnable) then
		if Menu.IsKeyDown(AllInOne.optionEnigmaComboKey) then
			if not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				AllInOne.EnigmaCombo()
			end
		end
	elseif comboHero == "Lion" and Menu.IsEnabled(AllInOne.optionLionEnable) then
		if Menu.IsKeyDown(AllInOne.optionLionComboKey) then
			enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				AllInOne.LionCombo()
			end
		end
	elseif comboHero == "Tinker" and Menu.IsEnabled(AllInOne.optionTinkerEnable) then
		if Menu.IsKeyDown(AllInOne.optionTinkerComboKey) then
			if Menu.GetValue(AllInOne.optionTinkerTargetStyle) == 1 and not enemy then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			elseif Menu.GetValue(AllInOne.optionTinkerTargetStyle) == 0 then
				enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
			end
			if enemy and Entity.IsAlive(enemy) then
				enemyPosition = Entity.GetAbsOrigin(enemy)
				AllInOne.TinkerCombo()
			end
		else
			enemy = nil		
		end
		if Menu.IsKeyDown(AllInOne.optionTinkerSpamKey) then
			AllInOne.TinkerSpamRockets()
		end
	end
	AllInOne.ClearVar()
	for i = 0, 5 do
		item = NPC.GetItemByIndex(myHero, i)
		if item and item ~= 0 then
			local name = Ability.GetName(item)
			if name == "item_urn_of_shadows" then
				urn = item
			elseif name == "item_spirit_vessel" then
				vessel = item
			elseif name == "item_sheepstick" then
				hex = item
			elseif name == "item_nullifier" then
				nullifier = item
			elseif name == "item_diffusal_blade" then
				diffusal = item
			elseif name == "item_mjollnir" then
				mjolnir = item
			elseif name == "item_heavens_halberd" then
				halberd = item
			elseif name == "item_abyssal_blade" then
				abyssal = item
			elseif name == "item_armlet" then
				armlet = item
			elseif name == "item_bloodthorn" then
				bloodthorn = item
			elseif name == "item_black_king_bar" then
				bkb = item
			elseif name == "item_medallion_of_courage" then
				courage = item
			elseif name == "item_solar_crest" then
				solar = item
			elseif name == "item_blink" then
				blink = item
			elseif name == "item_blade_mail" then
				blademail = item
			elseif name == "item_orchid" then
				orchid = item
			elseif name == "item_lotus_orb" then
				lotus = item
			elseif name == "item_cyclone" then
				eul = item
			elseif name == "item_satanic" then
				satanic = item
			elseif name == "item_force_staff" then
				force = item
			elseif name == "item_hurricane_pike" then
				pike = item 
			elseif name == "item_ethereal_blade" then
				eblade = item
			elseif name == "item_phase_boots" then
				phase = item
			elseif name == "item_dagon" or name == "item_dagon_2" or name == "item_dagon_3" or name == "item_dagon_4" or name == "item_dagon_5" then
				dagon = item
			elseif name == "item_veil_of_discord" then
				discord = item
			elseif name == "item_shivas_guard" then
				shiva = item
			elseif name == "item_refresher" then
				refresher = item
			elseif name == "item_soul_ring"	then
				soulring = item
			elseif name == "item_manta" then
				manta = item
			elseif name == "item_necronomicon" or name == "item_necronomicon_2" or name == "item_necronomicon_3" then
				necro = item
			elseif name == "item_silver_edge" then
				silver = item
			end
		end
	end
end
function AllInOne.OnModifierCreate(ent, mod) 
	if not myHero or not Menu.IsEnabled(AllInOne.optionArcEnable) or comboHero ~= "Arc" then
		return
	end
	if Modifier.GetName(mod) == "modifier_arc_warden_magnetic_field_thinker_attack_speed" then
		thinker = mod
	end
	if Modifier.GetName(mod) == "modifier_kill" and Entity.GetOwner(ent) == clone then
		if NPC.GetUnitName(ent) == "npc_dota_necronomicon_warrior_1" or NPC.GetUnitName(ent) == "npc_dota_necronomicon_warrior_2" or NPC.GetUnitName(ent) == "npc_dota_necronomicon_warrior_3" or NPC.GetUnitName(ent) == "npc_dota_necronomicon_archer_1" or NPC.GetUnitName(ent) == "npc_dota_necronomicon_archer_2" or NPC.GetUnitName(ent) == "npc_dota_necronomicon_archer_3" then
			table.insert(necroTable, ent)
		end
	end
	if Modifier.GetName(mod) == "modifier_illusion" and Entity.GetOwner(ent) == myPlayer and ((manta and not Ability.IsReady(clone_manta)) or clone_manta and not Ability.IsReady(clone_manta)) then
		table.insert(mantaTable, ent)
	end
	if Entity.GetClassName(ent) == "CDOTA_Unit_Hero_ArcWarden" and ent ~= myHero and NPC.HasModifier(ent, "modifier_arc_warden_tempest_double") and (not clone or not Entity.IsEntity(clone) or not Entity.IsAlive(clone)) then
		clone = ent
		clone_state = 0
		clone_q = NPC.GetAbility(clone, "arc_warden_flux")
		clone_w = NPC.GetAbility(clone, "arc_warden_magnetic_field")
		clone_e = NPC.GetAbility(clone, "arc_warden_spark_wraith")
	end
end
function AllInOne.OnModifierDestroy(ent, mod)
	if not myHero or comboHero ~= "Arc" then
		return
	end
	if Modifier.GetName(mod) == "modifier_kill" then
		if NPC.GetUnitName(ent) == "npc_dota_hero_arc_warden" then
			pushing = false
		end
		for i, k in pairs(necroTable) do
			if k == ent then
				table.remove(necroTable, ent)
			end
		end
	end
	if Modifier.GetName(mod) == "modifier_illusion" then
		for i, k in pairs(mantaTable) do
			if k == ent then
				table.remove(mantaTable, ent)
			end
		end
	end
end
function AllInOne.DrawArcPanel( ... )
	if not Menu.IsEnabled(AllInOne.optionArcDrawPanel) then
		return
	end
	if Menu.IsEnabled(AllInOne.optionArcPanelMoveable) then
		if Input.IsKeyDown(Enum.ButtonCode.KEY_UP) then
			y = y - 10
			Config.WriteInt("KAIO", "arcPanelY", y)
		end
		if Input.IsKeyDown(Enum.ButtonCode.KEY_DOWN) then
			y = y + 10
			Config.WriteInt("KAIO", "arcPanelY", y)
		end
		if Input.IsKeyDown(Enum.ButtonCode.KEY_LEFT) then
			x = x - 10
			Config.WriteInt("KAIO", "arcPanelX", x)
		end
		if Input.IsKeyDown(Enum.ButtonCode.KEY_RIGHT) then
			x = x + 10
			Config.WriteInt("KAIO", "arcPanelX", x)
		end
	end
	Renderer.SetDrawColor(0,0,0,125)
	Renderer.DrawFilledRect(x,y,arcPanelW, arcPanelH)
	Renderer.SetDrawColor(0,0,0)
	Renderer.DrawOutlineRect(x,y,arcPanelW, arcPanelH)
	Renderer.SetDrawColor(255,0,0)
	AllInOne.DrawTextCentered(arcFont, x + arcPanelW/2, y + 10, "OPTIONS", 1)
	Renderer.SetDrawColor(0,0,0,45)
	Renderer.DrawFilledRect(x+1,y+1,arcPanelW-2, 18)
	Renderer.SetDrawColor(0, 191, 255)
	AllInOne.DrawTextCentered(arcFont, x + arcPanelW/2, y + 30, "TP PUSH", 1)
	Renderer.SetDrawColor(255, 255, 255, 45)
	Renderer.DrawFilledRect(x+1, y+21, arcPanelW-2, 18)
	Renderer.SetDrawColor(0, 0, 0)
	Renderer.DrawOutlineRect(x, y+40, arcPanelW/2, 20)
	Renderer.DrawOutlineRect(x + arcPanelW/2, y+40, arcPanelW/2, 20)
	local hoveringOverAuto = Input.IsCursorInRect(x, y+40, arcPanelW/2, 20)
	local hoveringOverCursor = Input.IsCursorInRect(x + arcPanelW/2, y+40, arcPanelW/2, 20)
	if hoveringOverAuto and Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_LEFT) then
		if arcPushMode == "Cursor" then
			arcPushMode = "Auto"
			Config.WriteString("KAIO", "arcPushMode", "Auto")
		end
	end

	if hoveringOverCursor and Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_LEFT) then
		if arcPushMode == "Auto" then
			arcPushMode = "Cursor"
			Config.WriteString("KAIO", "arcPushMode", "Cursor")
		end
	end
	if arcPushMode == "Auto" then
		Renderer.SetDrawColor(0, 255, 0, 255)
		AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4, y + 40, "auto", 0)
		Renderer.SetDrawColor(255, 255, 255, 75)
		AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4*3, y + 40, "cursor", 0)
	else
		Renderer.SetDrawColor(255, 255, 255, 75)
		AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4, y + 40, "auto", 0)
		Renderer.SetDrawColor(0, 255, 0, 255)
		AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4*3, y + 40, "cursor", 0)
	end

	Renderer.SetDrawColor(0, 191, 255, 255)
	AllInOne.DrawTextCentered(arcFont, x + arcPanelW/2, y + 70, "line select", 1)
	Renderer.SetDrawColor(255, 255, 255, 45)
	Renderer.DrawFilledRect(x+1, y+61, arcPanelW-2, 18)
	Renderer.SetDrawColor(0, 0, 0, 255)
	Renderer.DrawOutlineRect(x, y+80, arcPanelW/2, 20)
	Renderer.DrawOutlineRect(x + arcPanelW/2, y+80, arcPanelW/2, 20)

	local hoveringOverFurthest = Input.IsCursorInRect(x, y+80, arcPanelW/2, 20)
	local hoveringOverLeast = Input.IsCursorInRect(x + arcPanelW/2, y+80, arcPanelW/2, 20)

	if hoveringOverFurthest and Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_LEFT) then
		if arcPushModeLine == "max" then
			arcPushModeLine = "min"
			Config.WriteString("KAIO", "arcPushModeLine", "min")
		end
	end

	if hoveringOverLeast and Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_LEFT) then
		if arcPushModeLine == "min" then
			arcPushModeLine = "max"
			Config.WriteString("KAIO", "arcPushModeLine", "max")
		end
	end

	if arcPushMode == "Cursor" then
		Renderer.SetDrawColor(255, 255, 255, 75)
		AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4, y + 80, "min", 0)
		AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4*3, y + 80, "max", 0)
	else
		if arcPushModeLine == "min" then
			Renderer.SetDrawColor(0, 255, 0, 255)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4, y + 80, "min", 0)
			Renderer.SetDrawColor(255, 255, 255, 75)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4*3, y + 80, "max", 0)
		else
			Renderer.SetDrawColor(255, 255, 255, 75)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4, y + 80, "min", 0)
			Renderer.SetDrawColor(0, 255, 0, 255)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/4*3, y + 80, "max", 0)
		end
	end
	local yInfo = y + 110
	Renderer.SetDrawColor(255, 0, 0, 255)
	AllInOne.DrawTextCentered(arcFont, x + arcPanelW/2, yInfo + 10, "INFORMATION", 1)
	Renderer.SetDrawColor(0, 0, 0, 45)
	Renderer.DrawFilledRect(x+1, yInfo+1, arcPanelW-2, 20-2)

	Renderer.SetDrawColor(0, 191, 255, 255)
	AllInOne.DrawTextCentered(arcFont, x + arcPanelW/2, yInfo + 30, "Clone action", 1)
	Renderer.SetDrawColor(255, 255, 255, 45)
	Renderer.DrawFilledRect(x+1, yInfo+21, arcPanelW-2, 20-2)
	if not clone then
		Renderer.SetDrawColor(255, 100, 0, 255)
		AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/2, yInfo + 40, "not spawned", 0)
	else
		if not Entity.IsEntity(clone) or not Entity.IsAlive(clone) then
			Renderer.SetDrawColor(255, 100, 0, 255)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/2, yInfo + 40, "dead", 0)
		end
		if clone_state == 0 and Entity.IsEntity(clone) and Entity.IsAlive(clone) then
			Renderer.SetDrawColor(255, 100, 0, 255)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/2, yInfo + 40, "idle", 0)
		elseif clone_state == 1 and enemy and clone_target == enemy and Entity.IsAlive(clone)  then
			Renderer.SetDrawColor(0, 255, 0, 255)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/2, yInfo + 40, "main comboing", 0)
			local heroName = NPC.GetUnitName(clone_target)
			local imageHandle
			if cachedHeroIcons[heroName] then
				imageHandle = cachedHeroIcons[heroName]
			else
				imageHandle = Renderer.LoadImage("panorama/images/heroes/icons/" .. heroName .. "_png.vtex_c")
				cachedHeroIcons[heroName] = imageHandle
			end
			Renderer.SetDrawColor(255, 255, 255, 255)
			if imageHandle then
				Renderer.DrawImage(imageHandle, x + arcPanelW/2 - 35, yInfo + 58, 67, 48)
			end
		elseif clone_state == 1 and clone_target ~= enemy and Entity.IsAlive(clone) and clone_target then
			Renderer.SetDrawColor(0, 255, 0, 255)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/2, yInfo + 40, "comboing", 0)
			local heroName = NPC.GetUnitName(clone_target)
			local imageHandle
			if cachedHeroIcons[heroName] then
				imageHandle = cachedHeroIcons[heroName]
			else
				imageHandle = Renderer.LoadImage("panorama/images/heroes/icons/"..heroName.."_png.vtex_c")
				cachedHeroIcons[heroName] = imageHandle
			end	
			Renderer.SetDrawColor(255,255,255)
			if imageHandle then
				Renderer.DrawImage(imageHandle, x + arcPanelW/2 - 35, yInfo + 58, 67, 48)
			end
		elseif clone_state == 2 and Entity.IsAlive(clone) then
			Renderer.SetDrawColor(0,255,0)			
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/2, yInfo + 40, "TPing", 0)
		elseif clone_state == 3 and Entity.IsAlive(clone) then
			Renderer.SetDrawColor(0,255,0)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/2, yInfo + 40, "Pushing", 0)
		elseif Entity.IsAlive(clone) then
			Renderer.SetDrawColor(255, 100, 0, 255)
			AllInOne.DrawTextCenteredX(arcFont, x + arcPanelW/2, yInfo + 40, "idle", 0)
		end
	end
	Renderer.SetDrawColor(0, 191, 255, 255)
	AllInOne.DrawTextCentered(arcFont, x + arcPanelW/2, yInfo + 120, "Clone CDs", 1)
	Renderer.SetDrawColor(255, 255, 255, 45)
	Renderer.DrawFilledRect(x+1, yInfo+111, arcPanelW-2, 20-2)
	if clone then
		local tempTable = {}
		if clone_midas and Entity.IsAbility(clone_midas) then
			table.insert(tempTable, clone_midas)
		end
		if clone_boots and Entity.IsAbility(clone_boots) then
			table.insert(tempTable, clone_boots)
		end
		if clone_necro and Entity.IsAbility(clone_necro) then
			table.insert(tempTable, clone_necro)
		end
		for i, k in ipairs(tempTable) do
			local itemName = Ability.GetName(k)
			local itemNameShort = string.gsub(itemName, "item_", "")
			local imageHandle
			if cachedItemIcons[itemNameShort] then
				imageHandle = cachedItemIcons[itemNameShort]
			else
				imageHandle = Renderer.LoadImage("resource/flash3/images/items/"..itemNameShort.."_png.vtex_c")
				cachedItemIcons[itemNameShort] = imageHandle
			end	
			Renderer.SetDrawColor(255,255,255)
			Renderer.DrawImage(imageHandle, x + 3 + (39*(i-1)), yInfo + 135, 37, 26)
			if Ability.GetCooldownTimeLeft(k) > 0 then
				Renderer.SetDrawColor(255, 255, 255, 45)
				Renderer.DrawFilledRect(x + 3 + (39*(i-1)), yInfo + 135, 37, 26)
				Renderer.SetDrawColor(255, 0, 0)
				AllInOne.DrawTextCenteredX(arcFont, x + 21 + (39*(i-1)), yInfo + 139, math.ceil(Ability.GetCooldownTimeLeft(k)), 0)
			end
		end
	end
end
function AllInOne.ArcTP( ... )
	if arcPushMode == "Cursor" then
		local targetCreep
		local targetDistance = 999999
		if clone_boots then
			for i = 1, NPCs.Count() do
				local npc = NPCs.Get(i)
				if npc and Entity.IsEntity(npc) and Entity.IsAlive(npc) and not NPC.IsWaitingToSpawn(npc) and NPC.IsLaneCreep(npc) and Entity.IsSameTeam(myHero, npc) and NPC.IsRanged(npc) and NPC.GetUnitName(npc) ~= "npc_dota_neutral_caster" then
					local creepOrigin = Entity.GetAbsOrigin(npc)
					local distanceToMouse = (creepOrigin - Input.GetWorldCursorPos()):Length2D()
					if distanceToMouse < targetDistance then
						targetCreep = npc
						targetDistance = distanceToMouse
					end
				end
			end
		end
		if not targetCreep then
			targetDistance = 999999
		else
			return Entity.GetAbsOrigin(targetCreep)	
		end
	else
		local targetCreep
		local targetDistance = 999999
		if clone_boots then
			for i = 1, NPCs.Count() do
				local npc = NPCs.Get(i)
				if npc and Entity.IsEntity(npc) and Entity.IsAlive(npc) and not NPC.IsWaitingToSpawn(npc) and NPC.IsLaneCreep(npc) and Entity.IsSameTeam(myHero, npc) and NPC.IsRanged(npc) and NPC.GetUnitName(npc) ~= "npc_dota_neutral_caster" then
					local tempTable = Entity.GetUnitsInRadius(npc, 1200, Enum.TeamType.TEAM_ENEMY)
					local tempTable2 = Entity.GetHeroesInRadius(npc, 900, Enum.TeamType.TEAM_ENEMY)
					local tempTable3 = Entity.GetHeroesInRadius(npc, 1000, Enum.TeamType.TEAM_FRIEND)
					if tempTable and #tempTable >= 3 and (not tempTable2 or #tempTable2 == 1) and (not tempTable3 or #tempTable3 == 1) then
						tempTable = Entity.GetUnitsInRadius(npc, 500, Enum.TeamType.TEAM_FRIEND)
						if Entity.GetHealth(npc)/Entity.GetMaxHealth(npc) >= 0.8 and tempTable and #tempTable >= 2 then
							if (Entity.GetAbsOrigin(npc) - myPos):Length2D() >= 3000 then
								if arcPushModeLine == "min" then
									if (Entity.GetAbsOrigin(npc) - enemyBase):Length2D() < targetDistance then
										targetCreep = npc
										targetDistance = (Entity.GetAbsOrigin(npc) - enemyBase):Length2D()
										break
									end
								else
									if (Entity.GetAbsOrigin(npc) - myBase):Length2D() < targetDistance then
										targetCreep = npc
										targetDistance = (Entity.GetAbsOrigin(npc) - myBase):Length2D()
										break
									end
								end	
							end
						end
					end
				end
			end
		end
		if not targetCreep then
			targetDistance = 999999
		else
			return Entity.GetAbsOrigin(targetCreep)	
		end
	end
end
function AllInOne.ArcPush( ... )
	if not pushing then
		return
	end
	if not clone or not Entity.IsEntity(clone) or not Entity.IsAlive(clone) then
		if r and Ability.IsCastable(r, myMana) then
			Ability.CastNoTarget(r)
			nextTick2 = 0.1 + time + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
	end
	if clone and Entity.IsEntity(clone) and Entity.IsAlive(clone) and clone_target and Entity.IsEntity(clone_target) and Entity.IsAlive(clone_target) and NPC.IsEntityInRange(clone, clone_target, 1100) then
		AllInOne.ArcCloneCombo(clone_target)
	end
	if clone and Entity.IsEntity(clone) and Entity.IsAlive(clone) and clone_boots and Ability.IsCastable(clone_boots, clone_mana) then
		if AllInOne.ArcTP() and not NPC.IsPositionInRange(clone, AllInOne.ArcTP(), Menu.GetValue(AllInOne.optionArcMinimumRangeToTP)) then
			Ability.CastPosition(clone_boots, AllInOne.ArcTP())
		end
	end
	if clone and time >= nextTick2 and Entity.IsEntity(clone) and Entity.IsAlive(clone) and clone_mana then
		if clone_boots and Ability.IsChannelling(clone_boots) then
			clone_state = 2
			return
		end
		if not clone_target or not NPC.IsEntityInRange(clone, clone_target, 1300) then
			clone_state = 3
		end
		local tempTable1 = Entity.GetUnitsInRadius(clone, 1300, Enum.TeamType.TEAM_ENEMY)
		if clone_midas and Ability.IsCastable(clone_midas, 0) and tempTable1 then
			local target
			for i, k in pairs(tempTable1) do
				if Entity.IsEntity(k) and Entity.IsAlive(k) and not NPC.IsWaitingToSpawn(k) and NPC.IsCreep(k) and not Entity.IsDormant(k) then
					target = k
					break
				end
			end
			if target then
				Ability.CastTarget(clone_midas, target)
				nextTick2 = 0.1 + time + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			end
		end
		if clone_necro and Ability.IsCastable(clone_necro, clone_mana) then
			Ability.CastNoTarget(clone_necro)
			nextTick2 = 0.1 + time + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if clone_manta and Ability.IsCastable(clone_manta, clone_mana) then
			Ability.CastNoTarget(clone_manta)
			nextTick2 = 0.1 + time + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if NPC.HasModifier(clone, "modifier_kill") then
			local tempestDieTime = Modifier.GetDieTime(NPC.GetModifier(clone, "modifier_kill"))
			if tempestDieTime - time < 2.5 then
				if clone_mjolnir and Ability.IsCastable(clone_mjolnir, clone_mana) then
					local tempTable = Entity.GetUnitsInRadius(clone, 825, Enum.TeamType.TEAM_FRIEND)
					if tempTable then
						for i, k in pairs(tempTable) do
							Ability.CastTarget(clone_mjolnir, k)
							nextTick2 = 0.1 + time + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
							return
						end
					end
				end
			end
		end
		if attackRange ~= NPC.GetAttackRange(myHero) then
			attackRange = NPC.GetAttackRange(myHero)
		end
		local target
		local targetHP = 999999
		local targetCreep
		local targetCreepHP = 999999
		local tempTable = Entity.GetHeroesInRadius(clone, attackRange+21, Enum.TeamType.TEAM_ENEMY)
		if tempTable then
			for i, k in pairs(tempTable) do
				if Entity.IsAlive(k) and Entity.GetHealth(k) < targetHP then
					target = k
					targetHP = Entity.GetHealth(k)
				end
			end
		else
			tempTable = Entity.GetUnitsInRadius(clone, attackRange+21, Enum.TeamType.TEAM_ENEMY)
			if tempTable then
				for i, k in pairs(tempTable) do
					if Entity.IsAlive(k) and (NPC.IsCreep(k) or NPC.IsStructure(k)) and NPC.IsKillable(k) and not NPC.IsWaitingToSpawn(k) and NPC.GetUnitName(k) ~= "npc_dota_neutral_caster" then
						if Entity.GetHealth(k) < targetCreepHP then
							targetCreep = k
							targetCreepHP = Entity.GetHealth(k)
						end
					end
				end
			else
				target = nil
				targetHP = 999999
				targetCreep = nil
				targetCreepHP = 999999
			end
		end
		if target then
			AllInOne.ArcCloneCombo(target)
			nextTick2 = 0.1 + time + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		elseif targetCreep then
			if not NPC.IsAttacking(clone) then
				Player.AttackTarget(myPlayer, clone, targetCreep)
				nextTick2 = NPC.GetAttackTime(clone)/2 + time + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			end
			tempTable = Entity.GetUnitsInRadius(clone, 625, Enum.TeamType.TEAM_ENEMY)
			if tempTable and #tempTable >= 3 then
				if clone_w and Ability.IsCastable(clone_w, clone_mana) then
					tempTable = Heroes.InRadius(Entity.GetAbsOrigin(clone),570, myTeam, Enum.TeamType.TEAM_FRIEND)
					if tempTable then
						table.insert(tempTable, clone)
						Ability.CastPosition(clone_w, AllInOne.FindBestOrderPosition(tempTable,570))
					else
						Ability.CastPosition(clone_w, Entity.GetAbsOrigin(clone))	
					end
				end
			end
			if NPC.IsEntityInRange(clone, targetCreep, 1999) then
				if clone_e and Ability.IsCastable(clone_e, clone_mana) then
					Ability.CastPosition(clone_e, Entity.GetAbsOrigin(targetCreep))
					nextTick2 = 0.1 + time + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
					return
				end
			end
		end
		if not targetCreep and not target then
			if not NPC.IsAttacking(clone) then
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_MOVE, nil, AllInOne.GenericLanePusher(clone), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, clone)
				nextTick2 = 0.1 + time + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			end
			if #necroTable > 1 then
				AllInOne.NecroController("push")
			end
			if #mantaTable > 1 then
				AllInOne.MantaController("push")
			end
		end
	end
end
function AllInOne.NecroController(keyValue, var)
	for i, k in pairs(necroTable) do
		if k and Entity.IsEntity(k) and Entity.IsAlive(k) then
			if keyValue == "attack" then
				if not NPC.IsAttacking(k) and NPC.IsEntityInRange(k, var, 1000) then
					Player.AttackTarget(myPlayer, k, var)
				end
				if NPC.GetUnitName(k) == "npc_dota_necronomicon_archer" or NPC.GetUnitName(k) == "npc_dota_necronomicon_archer_2" or NPC.GetUnitName(k) == "npc_dota_necronomicon_archer_3" then
					local ability = NPC.GetAbilityByIndex(k, 0)
					if ability and Ability.IsCastable(ability, 0) then
						Ability.CastTarget(ability, var)
					end
				end
			elseif keyValue == "push" then
				if not NPC.IsAttacking(k) then
					Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_MOVE, nil, AllInOne.GenericLanePusher(k), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, k)
				end
			end
		end
	end
end
function AllInOne.MantaController(keyValue, var)
	for i, k in pairs(mantaTable) do
		if k and Entity.IsEntity(k) and Entity.IsAlive(k) then
			if keyValue == "attack" then
				if not NPC.IsAttacking(k) and NPC.IsEntityInRange(k, var, 1000) then
					Player.AttackTarget(myPlayer, k, var)
				end
			elseif keyValue == "push" then
				if not NPC.IsAttacking(k) then
					Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_MOVE, nil, AllInOne.GenericLanePusher(k), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, k)
				end
			end
		end
	end
end
function AllInOne.GenericLanePusher(npc)
	if not npc then return end


	local leftCornerPos = Vector(-5750, 6050, 384)
	local rightCornerPos = Vector(6000, -5800, 384)
	local midPos = Vector(-600, -300, 128)

	local radiantTop2 = Vector(-6150, -800, 384)
	local radiantBot2 = Vector(-800, -6250, 384)
	local radiantMid2 = Vector(-2800, -2250, 256)
	
	local direTop2 = Vector(800, 6000, 384)
	local direBot2 = Vector(6200, 400, 384)
	local direMid2 = Vector(2800, 2100, 256)


	local myBotTower2
		if myFaction == "radiant"
			then myBotTower2 = radiantBot2
		else myBotTower2 = direBot2
		end

	local myTopTower2
		if myFaction == "radiant"
			then myTopTower2 = radiantTop2
		else myTopTower2 = direTop2
		end

	local myMidTower2
		if myFaction == "radiant"
			then myMidTower2 = radiantMid2
		else myMidTower2 = direMid2
		end


	local npcPos = Entity.GetAbsOrigin(npc)

	local homeSide
	if npcPos:__sub(myBase):Length2D() < npcPos:__sub(enemyBase):Length2D() then
		homeSide = true
	else homeSide = false
	end
	
	if not homeSide then
		return enemyBase
	end

	if homeSide then
		if npcPos:__sub(leftCornerPos):Length2D() <= 800 then
			return enemyBase
		elseif npcPos:__sub(rightCornerPos):Length2D() <= 800 then
			return enemyBase
		elseif npcPos:__sub(midPos):Length2D() <= 800 then
			return enemyBase
		end
	end

	if homeSide then
		if npcPos:__sub(leftCornerPos):Length2D() > 800 and npcPos:__sub(rightCornerPos):Length2D() > 800 and npcPos:__sub(midPos):Length2D() > 800 then
			
			if npcPos:__sub(leftCornerPos):Length2D() < npcPos:__sub(rightCornerPos):Length2D() and npcPos:__sub(leftCornerPos):Length2D() < npcPos:__sub(midPos):Length2D() then
				return leftCornerPos
			elseif npcPos:__sub(leftCornerPos):Length2D() < npcPos:__sub(rightCornerPos):Length2D() and npcPos:__sub(myTopTower2):Length2D() < npcPos:__sub(midPos):Length2D() and npcPos:__sub(myMidTower2):Length2D() > npcPos:__sub(myTopTower2):Length2D() then
				return leftCornerPos
			elseif npcPos:__sub(rightCornerPos):Length2D() < npcPos:__sub(leftCornerPos):Length2D() and npcPos:__sub(rightCornerPos):Length2D() < npcPos:__sub(midPos):Length2D() then
				return rightCornerPos
			elseif npcPos:__sub(rightCornerPos):Length2D() < npcPos:__sub(leftCornerPos):Length2D() and npcPos:__sub(myBotTower2):Length2D() < npcPos:__sub(midPos):Length2D() and npcPos:__sub(myMidTower2):Length2D() > npcPos:__sub(myBotTower2):Length2D() then
				return rightCornerPos
			elseif npcPos:__sub(midPos):Length2D() < npcPos:__sub(leftCornerPos):Length2D() and npcPos:__sub(midPos):Length2D() < npcPos:__sub(rightCornerPos):Length2D() and npcPos:__sub(myMidTower2):Length2D() < npcPos:__sub(myTopTower2):Length2D() then
				return enemyBase
			elseif npcPos:__sub(midPos):Length2D() < npcPos:__sub(leftCornerPos):Length2D() and npcPos:__sub(midPos):Length2D() < npcPos:__sub(rightCornerPos):Length2D() and npcPos:__sub(myMidTower2):Length2D() < npcPos:__sub(myBotTower2):Length2D() then
				return enemyBase
			else return enemyBase
			end
		end
	end
end
function AllInOne.DrawTextCentered(p1,p2,p3,p4,p5) -- Wrap Utility
	local wide, tall = Renderer.GetTextSize(p1, p4)
	return Renderer.DrawText(p1, p2 - wide/2 , p3 - tall/2, p4)
end
function AllInOne.DrawTextCenteredX(p1,p2,p3,p4,p5) -- Wrap Utility
	local wide, tall = Renderer.GetTextSize(p1, p4)
	return Renderer.DrawText(p1, p2 - wide/2, p3, p4)
end
function AllInOne.ArcCloneCombo(target)
	if not target or NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE)then
		clone_target = nil
		pushing = true
		return
	end
	if (not clone or not Entity.IsEntity(clone) or not Entity.IsAlive(clone)) and Ability.IsCastable(r, myMana) then
		Ability.CastNoTarget(r)
		return
	end
	if not clone or not Entity.IsEntity(clone) or not Entity.IsAlive(clone) then
		return
	end
	if not NPC.IsEntityInRange(clone, target, 1100) then
		clone_target = nil
		pushing = true
		return
	end
	if clone and Entity.IsEntity(clone) and Entity.IsAlive(clone) then
		clone_state = 1
		clone_target = target
		if NPC.IsLinkensProtected(target) then
			if clone_diffusal and Menu.IsEnabled(AllInOne.optionEnablePoopDiffusal) and Ability.IsCastable(clone_diffusal, 0) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
				Ability.CastTarget(clone_diffusal, target)
				return
			end
			if clone_orchid and Menu.IsEnabled(AllInOne.optionEnablePoopOrchid) and Ability.IsCastable(clone_orchid, clone_mana) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
				Ability.CastTarget(clone_orchid, target)
				return
			end
			if clone_blood and Menu.IsEnabled(AllInOne.optionEnablePoopBlood) and Ability.IsCastable(clone_blood, clone_mana) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
				Ability.CastTarget(clone_blood, target)
				return
			end
			if clone_hex and Menu.IsEnabled(AllInOne.optionEnablePoopHex) and Ability.IsCastable(clone_hex, clone_mana) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
				Ability.CastTarget(clone_hex, target)
				return
			end
			if clone_q and Ability.IsCastable(clone_q, clone_mana) and Menu.IsEnabled(AllInOne.optionArcEnableFlux) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
				Ability.CastTarget(clone_q, target)
				return
			end
		end
		if NPC.HasModifier(clone, "modifier_item_silver_edge_windwalk") and time >= needTime then
			Player.AttackTarget(myPlayer, clone, target)
			needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if clone_hex and time >= needTime2 and Ability.IsCastable(clone_hex, clone_mana) and Menu.IsEnabled(AllInOne.optionArcEnableHex) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			if Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
				if NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_HEXED) then
					local modHex = NPC.GetModifier(target, "modifier_sheepstick_debuff")
					if not modHex then
						modHex = NPC.GetModifier(target, "modifier_shadow_shaman_voodoo")
					end
					if not modHex then
						modHex = NPC.GetModifier(target, "modifier_lion_voodoo")
					end
					if modHex then
						local dieTime = Modifier.GetDieTime(modHex)
						if dieTime - time <= 0.85 then
							Ability.CastTarget(clone_hex,target)
							needTime2 = time + 0.05 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
							return
						end
					end
				else	
					Ability.CastTarget(clone_hex, target)
					needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
					return
				end
			elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
				Ability.CastTarget(clone_hex, target)
				needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return
			end	
		end
		if clone_silver and Menu.IsEnabled(AllInOne.optionArcEnableSilver) and Ability.IsCastable(clone_silver, clone_mana) then
			Ability.CastNoTarget(clone_silver)
			needTime2 = time + 0.3 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*3
			needAttack = true
			return
		end
		if clone_bkb and time >= needTime2 and Ability.IsCastable(clone_bkb, 0) and Menu.IsEnabled(AllInOne.optionArcEnableBkb) and not NPC.HasState(clone, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastNoTarget(clone_bkb)
			needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if clone_orchid and time >= needTime2 and Menu.IsEnabled(AllInOne.optionArcEnableOrchid) and Ability.IsCastable(clone_orchid, myMana) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			if Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_SILENCED) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_HEXED) then
				Ability.CastTarget(clone_orchid,target)
				needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return
			elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
				Ability.CastTarget(clone_orchid, target)
				needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return	
			end
		end
		if clone_blood and time >= needTime2 and Menu.IsEnabled(AllInOne.optionArcEnableBlood) and Ability.IsCastable(clone_blood, myMana) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			if Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_SILENCED) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_HEXED) then
				Ability.CastTarget(clone_blood,target)
				needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return
			elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
				Ability.CastTarget(clone_blood, target)
				needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return	
			end
		end
		if clone_nullifier and time >= needTime2 and Ability.IsCastable(clone_nullifier, myMana) and Menu.IsEnabled(AllInOne.optionArcEnableNulifier) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			if NPC.GetItem(target, "item_aeon_disk", true) then
				if NPC.HasModifier(target, "modifier_item_aeon_disk_buff") or not Ability.IsReady(NPC.GetItem(target, "item_aeon_disk", true)) then
					Ability.CastTarget(clone_nullifier,target)
					needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
					return
				end
			else
				if NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_HEXED) and Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
					local modHex = NPC.GetModifier(target, "modifier_sheepstick_debuff")
					if not modHex then
						modHex = NPC.GetModifier(target, "modifier_shadow_shaman_voodoo")
					end
					if not modHex then
						modHex = NPC.GetModifier(target, "modifier_lion_voodoo")
					end
					if modHex and not added then
						local dieTime = Modifier.GetDieTime(modHex)
						if dieTime - time <= (Entity.GetAbsOrigin(target)-Entity.GetAbsOrigin(clone)):Length()/750 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
							Ability.CastTarget(clone_nullifier,target)
							needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
							return
						end
					end
				elseif NPC.HasModifier(target, "modifier_item_nullifier_mute") and Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
					added = false
					local mod = NPC.GetModifier(target, "modifier_item_nullifier_mute")
					if mod then
						local dieTime = Modifier.GetDieTime(mod)
						if dieTime - time <= (Entity.GetAbsOrigin(target)-Entity.GetAbsOrigin(clone)):Length()/750 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
							Ability.CastTarget(clone_nullifier, target)
							needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
							return
						end
					end
				elseif Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_HEXED) and not NPC.HasModifier(target, "modifier_item_nullifier_mute") then
					Ability.CastTarget(clone_nullifier, target)
					needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
					return	
				elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
					Ability.CastTarget(clone_nullifier, target)
					needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
					return
				end
			end
		end
		if clone_diffusal and time >= needTime2 and Menu.IsEnabled(AllInOne.optionArcEnableDiffusal) and Ability.IsCastable(clone_diffusal, 0) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			if Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) and not NPC.HasModifier(target, "modifier_item_diffusal_blade_slow") and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_HEXED) then
				Ability.CastTarget(clone_diffusal, target)
				needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return
			elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
				Ability.CastTarget(clone_diffusal, target)
				needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return
			end	
		end
		if clone_satanic and time >= needTime2 and Menu.IsEnabled(AllInOne.optionArcEnableSatanic) and Ability.IsCastable(satanic, 0) and Entity.GetHealth(clone)/Entity.GetMaxHealth(clone) <= Menu.GetValue(AllInOne.optionArcSatanicThreshold) then
			Ability.CastNoTarget(clone_satanic)
			needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if clone_mjolnir and time >= needTime2 and Menu.IsEnabled(AllInOne.optionArcEnableMjolnir) and Ability.IsCastable(clone_mjolnir, myMana) then
			Ability.CastTarget(clone_mjolnir, clone)
			needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if clone_manta and time >= needTime2 and Ability.IsCastable(clone_manta, clone_mana) and Menu.IsEnabled(AllInOne.optionArcEnableManta) then
			Ability.CastNoTarget(clone_manta)
			needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if clone_necro and time >= needTime2 and Ability.IsCastable(clone_necro, clone_mana) and Menu.IsEnabled(AllInOne.optionArcEnableNecro) then
			Ability.CastNoTarget(clone_necro)
			needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if clone_q and time >= needTime2 and Ability.IsCastable(clone_q, clone_mana) and Menu.IsEnabled(AllInOne.optionArcEnableFlux) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastTarget(clone_q, target)
			needTime2 = time + 0.35 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if clone_w and time >= needTime2 and Ability.IsCastable(clone_w, clone_mana) and Menu.IsEnabled(AllInOne.optionArcEnableField) and time >= nextTick and (not NPC.HasModifier(myHero, "modifier_arc_warden_magnetic_field_attack_speed") or NPC.HasModifier(myHero, "modifier_arc_warden_magnetic_field_attack_speed") and Modifier.GetDieTime(thinker) - time <= Ability.GetCastPoint(clone_w) + 0.25 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)) then
			local tempTable = Heroes.InRadius(Entity.GetAbsOrigin(clone), 570, myTeam, Enum.TeamType.TEAM_FRIEND)
			if tempTable then
				table.insert(tempTable, clone)
				Ability.CastPosition(clone_w, AllInOne.FindBestOrderPosition(tempTable, 570))
			else
				Ability.CastPosition(clone_w, Entity.GetAbsOrigin(clone))	
			end
			needTime2 = time + 0.35 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if clone_e and time >= needTime2 and Ability.IsCastable(clone_e, clone_mana) and Menu.IsEnabled(AllInOne.optionArcEnableSpark) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastPosition(clone_e, AllInOne.castPrediction(target,1.5))
			needTime2 = time + 0.35 + Ability.GetCastPoint(clone_e)*3 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		end
	end
	if #mantaTable > 1 then
		AllInOne.MantaController("attack", target)
	end
	if #necroTable > 1 then
		AllInOne.NecroController("attack", target)
	end
	if time >= needTime2 or needAttack then
		Player.AttackTarget(myPlayer,clone,target)
		needTime2 = time + 0.35 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		needAttack = false
	end
end
function AllInOne.ArcCombo( ... )
	if not enemy or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or not NPC.IsEntityInRange(myHero, enemy, 2500) then
		enemy = nil
		return
	end
	if NPC.IsLinkensProtected(enemy) then
		AllInOne.PoopLinken()
	end
	if NPC.HasModifier(myHero, "modifier_item_silver_edge_windwalk") and time >= needTime then
		Player.AttackTarget(myPlayer, myHero, enemy)
		needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if hex and time >= needTime and Ability.IsCastable(hex, myMana) and Menu.IsEnabled(AllInOne.optionArcEnableHex) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		if Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
			Ability.CastTarget(hex, enemy)
			needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
			Ability.CastTarget(hex, enemy)
			needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end	
	end	
	if Menu.IsEnabled(AllInOne.optionArcStackClone) and time >= needTime and Ability.IsCastable(r, myMana) then
		Ability.CastNoTarget(r)
		needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if silver and Menu.IsEnabled(AllInOne.optionArcEnableSilver) and Ability.IsCastable(silver, myMana) then
		Ability.CastNoTarget(silver)
		needTime = time + 0.3 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*3
		return
	end
	if clone and Entity.IsEntity(clone) and Entity.IsAlive(clone) and NPC.IsEntityInRange(myHero, clone, 1500) and Menu.IsEnabled(AllInOne.optionArcStackClone) then
		AllInOne.ArcCloneCombo(enemy)
	end 
	if nullifier and time >= needTime and Ability.IsCastable(nullifier, myMana) and Menu.IsEnabled(AllInOne.optionArcEnableNulifier) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		if NPC.GetItem(enemy, "item_aeon_disk", true) then
			if NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") or not Ability.IsReady(NPC.GetItem(enemy, "item_aeon_disk", true)) then
				Ability.CastTarget(nullifier,enemy)
				needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return
			end
		else
			if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) and Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
				local modHex = NPC.GetModifier(enemy, "modifier_sheepstick_debuff")
				if not modHex then
					modHex = NPC.GetModifier(enemy, "modifier_shadow_shaman_voodoo")
				end
				if not modHex then
					modHex = NPC.GetModifier(enemy, "modifier_lion_voodoo")
				end
				if modHex then
					local dieTime = Modifier.GetDieTime(modHex)
					if dieTime - time <= (enemyPosition-myPos):Length()/750 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
						Ability.CastTarget(nullifier,enemy)
						needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
						needTime2 = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
						added = true
						return
					end
				end
			elseif Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
				Ability.CastTarget(nullifier, enemy)
				needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return	
			elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
				Ability.CastTarget(nullifier, enemy)
				needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return
			end
		end
	end
	if orchid and time >= needTime and Menu.IsEnabled(AllInOne.optionArcEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		if Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_SILENCED) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
			Ability.CastTarget(orchid,enemy)
			needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
			Ability.CastTarget(orchid, enemy)
			needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return	
		end
	end
	if bloodthorn and time >= needTime and Menu.IsEnabled(AllInOne.optionArcEnableBlood) and Ability.IsCastable(bloodthorn, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		if Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_SILENCED) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
			Ability.CastTarget(bloodthorn,enemy)
			needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
			Ability.CastTarget(bloodthorn, enemy)
			needTime = time + 0.05 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return	
		end
	end
	if bkb and time >= needTime and Ability.IsCastable(bkb, myMana) and Menu.IsEnabled(AllInOne.optionArcEnableBkb) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastNoTarget(bkb)
		needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if mjolnir and time >= needTime and Menu.IsEnabled(AllInOne.optionArcEnableMjolnir) and Ability.IsCastable(mjolnir, myMana) then
		Ability.CastTarget(mjolnir, myHero)
		needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if satanic and time >= needTime and Menu.IsEnabled(AllInOne.optionArcEnableSatanic) and Ability.IsCastable(satanic, 0) and Entity.GetHealth(myHero)/Entity.GetMaxHealth(myHero) <= Menu.GetValue(AllInOne.optionArcSatanicThreshold)/100 then
		Ability.CastNoTarget(satanic)
		needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if diffusal and time >= needTime and Menu.IsEnabled(AllInOne.optionArcEnableDiffusal) and Ability.IsCastable(diffusal, 0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		if Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) and not NPC.HasModifier(enemy, "modifier_item_diffusal_blade_slow") and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
			Ability.CastTarget(diffusal, enemy)
			needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		elseif not Menu.IsEnabled(AllInOne.optionArcDebuffUnstack) then
			Ability.CastTarget(diffusal, enemy)
			needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end	
	end
	if manta and time >= needTime and Ability.IsCastable(manta, myMana) and Menu.IsEnabled(AllInOne.optionArcEnableManta) then
		Ability.CastNoTarget(manta)
		needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if necro and time >= needTime and Ability.IsCastable(necro, myMana) and Menu.IsEnabled(AllInOne.optionArcEnableNecro) then
		Ability.CastNoTarget(necro)
		needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if Ability.IsCastable(q, myMana) and time >= needTime and Menu.IsEnabled(AllInOne.optionArcEnableFlux) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		Ability.CastTarget(q, enemy)
		needTime = time + 0.1 + Ability.GetCastPoint(q) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if Ability.IsCastable(w, myMana) and time >= needTime and Menu.IsEnabled(AllInOne.optionArcEnableField) and (not NPC.HasModifier(myHero, "modifier_arc_warden_magnetic_field_attack_speed") or NPC.HasModifier(myHero, "modifier_arc_warden_magnetic_field_attack_speed") and Modifier.GetDieTime(thinker) - time <= Ability.GetCastPoint(w) + 0.25 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)) then
		local tempTable = Heroes.InRadius(myPos, 570, myTeam, Enum.TeamType.TEAM_FRIEND)
		if clone and Entity.IsAlive(clone) then
			table.insert(tempTable, clone)
		end
		Ability.CastPosition(w, AllInOne.FindBestOrderPosition(tempTable, 570))
		needTime = time + 0.1 + Ability.GetCastPoint(w) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		nextTick = time + 0.75 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 3
		return
	end
	if Ability.IsCastable(e, myMana) and time >= needTime and Menu.IsEnabled(AllInOne.optionArcEnableSpark) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		Ability.CastPosition(e, AllInOne.castPrediction(enemy,1.5))
		needTime = time + 0.1 + Ability.GetCastPoint(e) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
	end
	if #mantaTable > 1 then
		AllInOne.MantaController("attack", enemy)
	end
	if #necroTable > 1 then
		AllInOne.NecroController("attack", enemy)
	end
	if not NPC.IsAttacking(myHero) then
		Player.AttackTarget(myPlayer, myHero, enemy)
	end
end
function AllInOne.TinkerSpamRockets( ... )
	local tempTable = Entity.GetHeroesInRadius(myHero, Ability.GetCastRange(w), Enum.TeamType.TEAM_ENEMY)
	local bool = false
	if tempTable then
		for i, k in pairs(tempTable) do
			if not NPC.HasState(k, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.HasState(k, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
				bool = true
				break
			end
		end
	end
	if bool and not Ability.IsChannelling(r) then
		if soulring and Ability.IsCastable(soulring, 0) and Entity.GetHealth(myHero)/Entity.GetMaxHealth(myHero)*100 > Menu.GetValue(AllInOne.optionTinkerThreshold) then
			Ability.CastNoTarget(soulring)
			return
		end
		if Ability.IsCastable(w,myMana) then
			Ability.CastNoTarget(w)
			return
		end
		if Ability.IsCastable(r, myMana) and time >= nextTick then
			Ability.CastNoTarget(r)
			nextTick = time + (RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING))/2
			return
		end
	end
end
function AllInOne.TinkerCombo( ... )
	if not enemy or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		enemy = nil
		return
	end
	if Menu.IsEnabled(AllInOne.optionTinkerCheckBM) and (NPC.HasModifier(enemy, "modifier_item_blade_mail_reflect") or NPC.HasModifier(enemy, "modifier_item_lotus_orb_active")) then
		return
	end
	if not Ability.IsChannelling(r) then
		if soulring and Menu.IsEnabled(AllInOne.optionTinkerEnableSoul) and Ability.IsCastable(soulring, 0) and NPC.IsEntityInRange(myHero, enemy, 1050) and Entity.GetHealth(myHero)/Entity.GetMaxHealth(myHero)*100 > Menu.GetValue(AllInOne.optionTinkerThreshold) then
			Ability.CastNoTarget(soulring)
			return
		end
		if time < needTime then
			return
		end
		if blink and Menu.IsEnabled(AllInOne.optionTinkerEnableBlink) and Ability.IsCastable(blink, 0) and not NPC.IsEntityInRange(myHero, enemy, 801) and NPC.IsPositionInRange(myHero, enemyPosition + (myPos - enemyPosition):Normalized():Scaled(Menu.GetValue(AllInOne.optionTinkerBlinkSafeRange)), 1199) then
			if Menu.GetValue(AllInOne.optionTinkerBlinkStyle) == 0 then
				Ability.CastPosition(blink, enemyPosition + (myPos - enemyPosition):Normalized():Scaled(Menu.GetValue(AllInOne.optionTinkerBlinkSafeRange)))
			else
				Ability.CastPosition(blink, Input.GetWorldCursorPos())
			end
			return
		end
		if NPC.IsLinkensProtected(enemy) then
			if Menu.IsEnabled(AllInOne.optionTinkerPoopLaser) and Ability.IsCastable(q, myMana) then
				Ability.CastTarget(q,enemy)
				return
			elseif Menu.IsEnabled(AllInOne.optionEnablePoopLinken) then
				AllInOne.PoopLinken()
				needTime = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			end
		end
		if hex and Menu.IsEnabled(AllInOne.optionTinkerEnableHex) and Ability.IsCastable(hex, myMana) and not NPC.HasModifier(enemy, "modifier_sheepstick_debuff") or NPC.HasModifier(enemy, "modifier_sheepstick_debuff") and Modifier.GetDieTime(NPC.GetModifier(enemy, "modifier_sheepstick_debuff")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastTarget(hex, enemy)
			return
		end
		if discord and Menu.IsEnabled(AllInOne.optionTinkerEnableDiscord) and Ability.IsCastable(discord, myMana) and not NPC.HasModifier(enemy, "modifier_item_veil_of_discord_debuff") or NPC.HasModifier(enemy, "modifier_item_veil_of_discord_debuff") and Modifier.GetDieTime(NPC.GetModifier(enemy, "modifier_item_veil_of_discord_debuff")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastPosition(discord, enemyPosition)
			return
		end
		if eblade and Menu.IsEnabled(AllInOne.optionTinkerEnableEblade) and Ability.IsCastable(eblade, myMana) and not NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") or NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") and Modifier.GetDieTime(NPC.GetModifier(enemy, "modifier_item_ethereal_blade_ethereal")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastTarget(eblade, enemy)
			ebladeCasted[enemy] = true
			return
		end
		if bkb and Menu.IsEnabled(AllInOne.optionTinkerEnableBkb) and Ability.IsCastable(bkb, 0) and NPC.IsEntityInRange(myHero, enemy, 1050) and not NPC.HasModifier(myHero, "modifier_black_king_bar_immune") or NPC.HasModifier(myHero, "modifier_black_king_bar_immune") and Modifier.GetDieTime(NPC.GetModifier(myHero, "modifier_black_king_bar_immune")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastNoTarget(bkb)
			return
		end
		if lotus and Menu.IsEnabled(AllInOne.optionTinkerEnableLotus) and Ability.IsCastable(lotus, myMana) and NPC.IsEntityInRange(myHero, enemy, 1050) and not NPC.HasModifier(myHero, "modifier_item_lotus_orb_active") or NPC.HasModifier(myHero, "modifier_item_lotus_orb_active") and Modifier.GetDieTime(NPC.GetModifier(myHero, "modifier_item_lotus_orb_active")) - time <= RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)*2 then
			Ability.CastTarget(lotus, myHero)
			return
		end
		if orchid and Menu.IsEnabled(AllInOne.optionTinkerEnableOrchid) and Ability.IsCastable(orchid, myMana) then
			Ability.CastTarget(orchid, enemy)
			return
		end
		if bloodthorn and Menu.IsEnabled(AllInOne.optionTinkerEnableBlood) and Ability.IsCastable(bloodthorn, myMana) then
			Ability.CastTarget(bloodthorn, enemy)
			return
		end
		if shiva and Menu.IsEnabled(AllInOne.optionTinkerEnableShiva) and Ability.IsCastable(shiva, myMana) and NPC.IsEntityInRange(myHero, enemy, 800) then
			Ability.CastNoTarget(shiva)
			return
		end
		if Ability.IsCastable(w, myMana) and NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(w)) and Menu.IsEnabled(AllInOne.optionTinkerEnableRockets) then
			Ability.CastNoTarget(w)
			return
		end
		if Ability.IsCastable(q, myMana) then
			Ability.CastTarget(q, enemy)
			return
		end
		if dagon and Menu.IsEnabled(AllInOne.optionTinkerEnableDagon) and Ability.IsCastable(dagon, myMana) then
			if ebladeCasted[enemy] and Ability.SecondsSinceLastUse(eblade) < 3 then
				if NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") then
					Ability.CastTarget(dagon, enemy)
					ebladeCasted[enemy] = nil
					return
				end	
			else
				Ability.CastTarget(dagon, enemy)
				ebladeCasted[enemy] = nil
				return
			end
		end
		if Ability.IsCastable(r, myMana) and time >= nextTick and Menu.IsEnabled(AllInOne.optionTinkerEnableRearm) then
			if not Ability.IsCastable(q,myMana) then
				Ability.CastNoTarget(r)
				nextTick = time + (RearmChannelTime[Ability.GetLevel(r)] + Ability.GetCastPoint(r) + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING))/2
				return
			end
		end
	end
end
function AllInOne.LionCombo( ... )
	if not enemy or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		enemy = nil
		return
	end
	if not added and Ability.GetLevel(NPC.GetAbility(myHero, "special_bonus_unique_lion_4")) > 0 then
		added = true
	end
	if blink and Ability.IsCastable(blink, 0) and Menu.IsEnabled(AllInOne.optionLionEnableBlink) and not NPC.IsEntityInRange(myHero, enemy, Menu.GetValue(AllInOne.optionLionMinimumBlinkRange)) and NPC.IsPositionInRange(myHero, enemyPosition + (myPos - enemyPosition):Normalized():Scaled(Menu.GetValue(AllInOne.optionLionComboRadius)), 1199) then
		Ability.CastPosition(blink, enemyPosition + (myPos - enemyPosition):Normalized():Scaled(Menu.GetValue(AllInOne.optionLionComboRadius)))
		return
	end
	if NPC.IsLinkensProtected(enemy) and Menu.IsEnabled(AllInOne.optionEnablePoopLinken) then
		AllInOne.PoopLinken()
	end
	if w and not added and Menu.IsEnabled(AllInOne.optionLionEnableHex) and Ability.IsCastable(w, myMana) and NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(w)*1.5) then
		if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
			local modHex = NPC.GetModifier(enemy, "modifier_sheepstick_debuff")
			if not modHex then
				modHex = NPC.GetModifier(enemy, "modifier_shadow_shaman_voodoo")
			end
			if not modHex then
				modHex = NPC.GetModifier(enemy, "modifier_lion_voodoo")
			end
			if modHex then
				local dieTime = Modifier.GetDieTime(modHex)
				if dieTime - time <= Ability.GetCastPoint(w) + 0.35 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
					Ability.CastTarget(w,enemy)
					nextTick = time + 0.25 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
					return
				end
			end
		elseif NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_STUNNED) then
			if not NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(w)) then
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION,	(myPos - enemyPosition):Normalized():Scaled(Ability.GetCastRange(w)+21), Vector(),nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
			end
			local mod = NPC.GetModifier(enemy, "modifier_lion_impale")
			if mod then
				local dieTime = Modifier.GetDieTime(mod)
				if dieTime - time <= Ability.GetCastPoint(w) + 0.35 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
					Ability.CastTarget(w, enemy)
					nextTick = time + 0.25 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
					return
				end
			end
		else
			Ability.CastTarget(w, enemy)
			nextTick = time + 0.25 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
	end
	if eblade and Menu.IsEnabled(AllInOne.optionLionEnableEblade) and Ability.IsCastable(eblade, myMana) then
		Ability.CastTarget(eblade, enemy)
		ebladeCasted[enemy] = true
		return
	end
	if w and added and Menu.IsEnabled(AllInOne.optionLionEnableHex) and Ability.IsCastable(w, myMana) and NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(w)*1.5) then
		if not NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(w)) and (not Menu.IsEnabled(AllInOne.optionLionEnableSpike) or not Ability.IsCastable(q, myMana)) then
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_TARGET, enemy, Vector(),nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
		end
		local tempTable = Heroes.InRadius(enemyPosition, 600, myTeam, Enum.TeamType.TEAM_ENEMY)
		if not tempTable then return end
		if #tempTable == 1 then
			if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
				local modHex = NPC.GetModifier(enemy, "modifier_sheepstick_debuff")
				if not modHex then
					modHex = NPC.GetModifier(enemy, "modifier_shadow_shaman_voodoo")
				end
				if not modHex then
					modHex = NPC.GetModifier(enemy, "modifier_lion_voodoo")
				end
				if modHex then
					local dieTime = Modifier.GetDieTime(modHex)
					if dieTime - time <= Ability.GetCastPoint(q) + 0.35 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
						Ability.CastPosition(w,enemyPosition)
						nextTick = time + 0.25 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
						return
					end
				end
			elseif NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_STUNNED) then
				local mod = NPC.GetModifier(enemy, "modifier_lion_impale")
				if mod then
					local dieTime = Modifier.GetDieTime(mod)
					if dieTime - time <= Ability.GetCastPoint(w) + 0.35 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
						Ability.CastPosition(w, enemyPosition)
						nextTick = time + 0.25 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
						return
					end
				end	
			else
				Ability.CastPosition(w, enemyPosition)
				nextTick = time + 0.25 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
				return
			end
		else
			local orderPos = AllInOne.FindBestOrderPosition(tempTable, 600)
			Ability.CastPosition(w, orderPos)
		end
	end
	if q and NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(q)+400) and Menu.IsEnabled(AllInOne.optionLionEnableSpike) and Ability.IsCastable(q, myMana) and time >= nextTick then
		if NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(w)) and Menu.IsEnabled(AllInOne.optionLionEnableHex) and Ability.GetLevel(w) > 0 and Ability.SecondsSinceLastUse(w) <= 0.3 and Ability.SecondsSinceLastUse(w) >= -1 then
			return
		end
		if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
			local modHex = NPC.GetModifier(enemy, "modifier_sheepstick_debuff")
			if not modHex then
				modHex = NPC.GetModifier(enemy, "modifier_shadow_shaman_voodoo")
			end
			if not modHex then
				modHex = NPC.GetModifier(enemy, "modifier_lion_voodoo")
			end
			if modHex then
				local dieTime = Modifier.GetDieTime(modHex)
				if dieTime - time <= Ability.GetCastPoint(q) + 0.35 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
					if (myPos-enemyPosition):Length() >= 600 then
						Ability.CastPosition(q, AllInOne.castPrediction(enemy,1, 1) + (myPos - AllInOne.castPrediction(enemy,1, 1)):Normalized():Scaled(600))
					else	
						Ability.CastPosition(q, AllInOne.castPrediction(enemy,1, 1))
					end
					return
				end
			end
		else
			if (myPos-enemyPosition):Length() >= 600 then
				Ability.CastPosition(q, AllInOne.castPrediction(enemy,1, 1) + (myPos - AllInOne.castPrediction(enemy,1, 1)):Normalized():Scaled(600))
			else	
				Ability.CastPosition(q, AllInOne.castPrediction(enemy,1, 1))
			end
			return
		end
	end
	if dagon and Menu.IsEnabled(AllInOne.optionLionEnableDagon) and Ability.IsCastable(dagon, myMana) then
		if eblade and ebladeCasted[enemy] and Ability.SecondsSinceLastUse(eblade) < 3 then
			if NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") then
				Ability.CastTarget(dagon, enemy)
				ebladeCasted[enemy] = nil
			end
		else	
			Ability.CastTarget(dagon, enemy)
			ebladeCasted[enemy] = nil
		end
		return
	end
	if r and Menu.IsEnabled(AllInOne.optionLionEnableFinger) and Ability.IsCastable(r, myMana) and NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(r)) then
		if eblade and ebladeCasted[enemy] and Ability.SecondsSinceLastUse(eblade) < 3 then
			if NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") then
				Ability.CastTarget(r, enemy)
				ebladeCasted[enemy] = nil
			end
		else
			Ability.CastTarget(r, enemy)
			ebladeCasted[enemy] = nil
		end	
		return
	end
	if not NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(w)+21) then
		Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_TARGET, enemy, Vector(), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
	else
		if not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_ATTACK_IMMUNE) then
			Player.AttackTarget(myPlayer,myHero,enemy)
		else
			Player.HoldPosition(myPlayer, myHero)	
		end
	end
end 
function AllInOne.SfCombo( ... )
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		enemy = nil
		return
	end
	if r and Ability.IsCastable(r, myMana) then
		if AllInOne.IsLinkensProtected() and Menu.IsEnabled(AllInOne.optionEnablePoopLinken) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			AllInOne.PoopLinken(eul)
		end
		local possibleRange = NPC.GetMoveSpeed(myHero) * 0.8
		if not NPC.IsEntityInRange(myHero, enemy, possibleRange) then
			if blink and Menu.IsEnabled(AllInOne.optionSfEnableBlink) and Ability.IsCastable(blink,0) and NPC.IsEntityInRange(myHero, enemy, 1175 + 0.75 * possibleRange) then
				Ability.CastPosition(blink, (enemyPosition + (myPos - enemyPosition):Normalized():Scaled(0.75 * possibleRange)))
				return
			else
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_TARGET, enemy, Vector(0,0,0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)	
			end
		end
		if eblade and Menu.IsEnabled(AllInOne.optionSfEnableEthereal) and Ability.IsCastable(eblade, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastTarget(eblade, enemy)
			ebladeCasted[enemy] = true
			return
		end
		if dagon and Menu.IsEnabled(AllInOne.optionSfEnableDagon) and Ability.IsCastable(dagon, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(dagon, enemy)
			return
		end
		if hex and Menu.IsEnabled(AllInOne.optionSfEnableHex) and Ability.IsCastable(hex, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastTarget(hex, enemy)
			return
		end
		if bkb and Menu.IsEnabled(AllInOne.optionSfEnableBkb) and Ability.IsCastable(bkb, 0) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastNoTarget(bkb)
			return
		end
		if orchid and Menu.IsEnabled(AllInOne.optionSfEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastTarget(orchid, enemy)
			return
		end
		if bloodthorn and Menu.IsEnabled(AllInOne.optionSfEnableBlood) and Ability.IsCastable(bloodthorn, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
			Ability.CastTarget(bloodthorn, enemy)
			return
		end
		if phase and Menu.IsEnabled(AllInOne.optionSfEnablePhase) and Ability.IsCastable(phase, 0) then
			Ability.CastNoTarget(phase)
		end
		if eul and Ability.IsCastable(eul, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not AllInOne.IsLinkensProtected() then
			if Menu.IsEnabled(AllInOne.optionSfEnableEthereal) and ebladeCasted[enemy] and eblade and Ability.SecondsSinceLastUse(eblade) < 3 then
				if NPC.HasModifier(enemy, "modifier_item_ethereal_blade_ethereal") then
					Ability.CastTarget(eul, enemy)
					ebladeCasted[enemy] = nil
				end
			else
				Ability.CastTarget(eul, enemy)
				ebladeCasted[enemy] = nil
			end
			return
		end	
		if NPC.HasModifier(enemy, "modifier_eul_cyclone") then
			local cycloneDieTime = Modifier.GetDieTime(NPC.GetModifier(enemy, "modifier_eul_cyclone"))
			if not NPC.IsEntityInRange(myHero, enemy, 65) then
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, enemyPosition, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
			else
				if cycloneDieTime - time <= 1.67 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
					Ability.CastNoTarget(r)
					return
				end
			end

		end
	end
end
function AllInOne.SfAutoRaze( ... )
	razeShortPos = myPos + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(200)
	razeMidPos = myPos + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(450)
	razeLongPos = myPos + Entity.GetRotation(myHero):GetForward():Normalized():Scaled(700)
	if Menu.IsKeyDown(AllInOne.optionSfRazeKey) then
		if not enemy then
			enemy = Input.GetNearestHeroToCursor(myTeam, Enum.TeamType.TEAM_ENEMY)
		end
	else
		if not Menu.IsKeyDown(AllInOne.optionSfComboKey) then
			enemy = nil
		end
		return
	end
	local razePrediction = 0.55 + 0.1 + (NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) * 2)
	if not enemy or not Entity.IsAlive(enemy) then return end
	local predictPos = AllInOne.castPrediction(enemy,razePrediction)
	if q and Ability.IsCastable(q, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		local disRazePOSpredictedPOS = (razeShortPos - predictPos):Length2D()
		if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
			Ability.CastNoTarget(q)
			return
		end
	end
	if w and Ability.IsCastable(w, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		local disRazePOSpredictedPOS = (razeMidPos - predictPos):Length2D()
		if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
			Ability.CastNoTarget(w)
			return
		end
	end
	if e and Ability.IsCastable(e, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		local disRazePOSpredictedPOS = (razeLongPos - predictPos):Length2D()
		if disRazePOSpredictedPOS <= 200 and not NPC.IsTurning(myHero) then
			Ability.CastNoTarget(e)
			return
		end
	end
end
function AllInOne.EmberCombo( ... )
	if not enemy or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or not NPC.IsEntityInRange(myHero, enemy, Menu.GetValue(AllInOne.optionEmberComboRadius)) then
		enemy = nil
		return
	end
	local enemyPos = enemyPosition
	local remnant_count = Modifier.GetStackCount(NPC.GetModifier(myHero, "modifier_ember_spirit_fire_remnant_charge_counter")) - Menu.GetValue(AllInOne.optionEmberSaveRemnantCount)
	if discord and Menu.IsEnabled(AllInOne.optionEmberEnableDiscord) and Ability.IsCastable(discord, myMana) then
		Ability.CastPosition(discord, AllInOne.castPrediction(enemy,1))
	end
	if bkb and Menu.IsEnabled(AllInOne.optionEmberEnableBkb) and Ability.IsCastable(bkb,0) then
		Ability.CastNoTarget(bkb)
		return
	end
	if r and Ability.IsCastable(f,myMana) and Menu.IsEnabled(AllInOne.optionEmberEnableRemnant) and remnant_count > 0 and time >= nextTick then
		for i = 1, remnant_count do
			Ability.CastPosition(r, AllInOne.castPrediction(enemy,1))
			remnant_casted = true
		end
		needTime = time + ((myPos:__sub(enemyPos)):Length() - 350)/(AllInOne.GetMoveSpeed(myHero)*2.5)
		nextTick = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if AllInOne.IsLinkensProtected() and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		AllInOne.PoopLinken()
	end
	if f and Ability.IsCastable(f,myMana) and remnant_casted and time >= needTime then
		Ability.CastPosition(f, enemyPos)
		remnant_casted = false
		return
	end
	if shiva and Menu.IsEnabled(AllInOne.optionEmberEnableShiva) and Ability.IsCastable(shiva, myMana) then
		Ability.CastNoTarget(shiva)
		return
	end
	if blademail and Menu.IsEnabled(AllInOne.optionEmberEnableBlademail) and Ability.IsCastable(blademail, myMana) then
		Ability.CastNoTarget(blademail)
		return
	end
	if orchid and Menu.IsEnabled(AllInOne.optionEmberEnableOrchid) and Ability.IsCastable(orchid, myMana) then
		Ability.CastTarget(orchid, enemy)
		return
	end
	if bloodthorn and Menu.IsEnabled(AllInOne.optionEmberEnableBloodthorn) and Ability.IsCastable(bloodthorn, myMana) then
		Ability.CastTarget(bloodthorn, enemy)
		return
	end
	if q and Menu.IsEnabled(AllInOne.optionEmberEnableChains) and Ability.IsCastable(q, myMana) and NPC.IsEntityInRange(myHero, enemy, 200) then
		Ability.CastNoTarget(q)
		return
	end
	if w and Menu.IsEnabled(AllInOne.optionEmberEnableFist) and Ability.IsCastable(w, myMana) and time > needTime+0.25 then
		Ability.CastPosition(w, enemyPos)
		return
	end
	if e and Menu.IsEnabled(AllInOne.optionEmberEnableFlame) and Ability.IsCastable(e, myMana) then
		Ability.CastNoTarget(e)
		return
	end
	Player.AttackTarget(myPlayer, myHero, enemy)
end
function AllInOne.EnigmaCombo( ... )
	if not enemy then
		return 
	end
	local orderPos
	if Menu.GetValue(AllInOne.optionEnigmaComboPos) == 0 then
		local tempTable = Entity.GetHeroesInRadius(myHero, 1600, Enum.TeamType.TEAM_ENEMY)
		orderPos = AllInOne.FindBestOrderPosition(tempTable, 800)
	else
		orderPos = Input.GetWorldCursorPos()
	end	
	if NPC.IsPositionInRange(myHero, orderPos, Menu.GetValue(AllInOne.optionEnigmaComboRadius)) and not Ability.IsChannelling(r) then
		if bkb and Ability.IsCastable(bkb, 0) and Menu.IsEnabled(AllInOne.optionEnigmaEnableBkb) then
			Ability.CastNoTarget(bkb)
			return
		end
		if blink and Ability.IsCastable(blink, 0) and Menu.IsEnabled(AllInOne.optionEnigmaEnableBlink) then
			if NPC.IsPositionInRange(myHero, orderPos, 1200) then
				Ability.CastPosition(blink, orderPos)
				return
			end
		end
		if Ability.IsCastable(e, myMana - Ability.GetManaCost(r)) and Menu.IsEnabled(AllInOne.optionEnigmaEnablePulse) then
			Ability.CastPosition(e, orderPos)
			return
		end
		if shiva and Menu.IsEnabled(AllInOne.optionEnigmaEnableShiva) and Ability.IsCastable(shiva, myMana - Ability.GetManaCost(r)) then
			Ability.CastNoTarget(shiva)
			return
		end
		if Ability.IsCastable(r, myMana) then
			Ability.CastPosition(r, orderPos)
			return
		end
		if refresher and Ability.IsCastable(refresher, myMana - Ability.GetManaCost(r)) and not Ability.IsChannelling(r) then
			Ability.CastNoTarget(refresher)
			return
		end
	end
end
function AllInOne.FindBestOrderPosition(tempTable, radius)
	if not tempTable then
		return
	end
	local enemyCount = #tempTable
	if enemyCount == 1 then
		return Entity.GetAbsOrigin(tempTable[1])
	end
	local count = 0
	local coord = {}
	for i, k in pairs(tempTable) do
		if NPC.IsEntityInRange(k, tempTable[1], radius) then
			local origin = Entity.GetAbsOrigin(k)
			local originX = origin:GetX()
			local originY = origin:GetY()
			table.insert(coord, {x = originX, y = originY})
			count = count + 1
		end
	end 
	local x = 0
	local y = 0
	for i = 1, count do
		x = x + coord[i].x
		y = y + coord[i].y
	end
	x = x/count
	y = y/count
	return Vector(x,y,0)
end
function AllInOne.OnDraw( ... )
	if not myHero then return end
	if comboHero == "SF" and Menu.IsEnabled(AllInOne.optionSfDrawRazePos) and Ability.GetLevel(q) >= 1 then
		if not razeShortPos or not razeMidPos or not razeLongPos then
			return
		end
		local x,y,vis = Renderer.WorldToScreen(razeShortPos)
		if vis and Ability.IsReady(q) then
			if Heroes.InRadius(razeShortPos,250,myTeam,Enum.TeamType.TEAM_ENEMY) then
				Renderer.SetDrawColor(255,0,0)
			else
				Renderer.SetDrawColor(0,255,100)	
			end
			Renderer.DrawOutlineRect(x,y,15,15)
		end
		local x1,y1,vis1 = Renderer.WorldToScreen(razeMidPos)
		if vis1 and Ability.IsReady(w) then
			if Heroes.InRadius(razeMidPos,250,myTeam,Enum.TeamType.TEAM_ENEMY)then
				Renderer.SetDrawColor(255,0,0)
			else
				Renderer.SetDrawColor(0,255,100)
			end
			Renderer.DrawOutlineRect(x1,y1,15,15)
		end
		local x2,y2,vis2 = Renderer.WorldToScreen(razeLongPos)
		if vis2 and Ability.IsReady(e) then
			if Heroes.InRadius(razeLongPos,250,myTeam,Enum.TeamType.TEAM_ENEMY) then
				Renderer.SetDrawColor(255,0,0)
			else
				Renderer.SetDrawColor(0,255,100)
			end
			Renderer.DrawOutlineRect(x2,y2,15,15)
		end
	end
end
function AllInOne.GetMoveSpeed(ent)
	local baseSpeed = NPC.GetBaseSpeed(ent)
	local bonusSpeed = NPC.GetMoveSpeed(ent) - baseSpeed
	local modHex
	if NPC.HasModifier(ent, "modifier_sheepstick_debuff") or NPC.HasModifier(ent, "modifier_lion_voodoo") or NPC.HasModifier(ent, "modifier_shadow_shaman_voodoo") then
		return 140 + bonusSpeed
	end
	if NPC.HasModifier(ent, "modifier_invoker_cold_snap_freeze") or NPC.HasModifier(ent, "modifier_invoker_cold_snap") then
		return NPC.GetMoveSpeed(ent) * 0.5
	end
	return baseSpeed + bonusSpeed
end
function AllInOne.castPrediction(enemy,adjVar, keyValue)
	local enemyRotation = Entity.GetRotation(enemy):GetVectors()
	enemyRotation:SetZ(0)
	local enemyOrigin = Entity.GetAbsOrigin(enemy)
	enemyOrigin:SetZ(0)
	if enemyRotation and enemyOrigin then
		if not NPC.IsRunning(enemy) then
			return enemyOrigin
		else
			if keyValue == 1 then --lion
				enemyRotation = Entity.GetRotation(enemy)
				local enemyPos = enemyOrigin+enemyRotation:GetForward():Normalized():Scaled(AllInOne.GetMoveSpeed(enemy)*adjVar)
				if NPC.IsPositionInRange(myHero, enemyPos, 600) then
					return enemyOrigin
				else
					return enemyOrigin+enemyRotation:GetVectors():Scaled(AllInOne.GetMoveSpeed(enemy))	
				end
			else
				return enemyOrigin:__add(enemyRotation:Normalized():Scaled(AllInOne.GetMoveSpeed(enemy) * adjVar))
			end
		end
	end
end
function AllInOne.LegionCombo( ... )
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
		enemy = nil
		return
	end
	if Menu.IsEnabled(AllInOne.optionLegionOnlyWithDuel) and not Ability.IsCastable(r, myMana) then
		enemy = nil
		return
	end
	if blink and Ability.IsCastable(blink, 0) and not NPC.IsEntityInRange(myHero, enemy, Menu.GetValue(AllInOne.optionLegionBlinkRange)) and NPC.IsEntityInRange(myHero, enemy, 1199) then
		if w and Menu.IsEnabled(AllInOne.optionLegionEnablePressTheAttack) and Ability.IsCastable(w, myMana) then
			Ability.CastTarget(w, myHero)
			return
		end
		if blademail and Menu.IsEnabled(AllInOne.optionLegionEnableBlademail) and Ability.IsCastable(blademail, myMana) then
			Ability.CastNoTarget(blademail)
			return
		end
		if bkb and Menu.IsEnabled(AllInOne.optionLegionEnableBkb) and Ability.IsCastable(bkb, 0) then
			Ability.CastNoTarget(bkb)
			return
		end
		if mjolnir and Menu.IsEnabled(AllInOne.optionLegionEnableMjolnir) and Ability.IsCastable(mjolnir, myMana) then
			Ability.CastTarget(mjolnir, myHero)
			return
		end
		if lotus and Menu.IsEnabled(AllInOne.optionLegionEnableLotus) and Ability.IsCastable(lotus, myMana) then
			Ability.CastTarget(lotus, myHero)
			return
		end
		if blink and Menu.IsEnabled(AllInOne.optionLegionEnableBlink) and Ability.IsCastable(blink, 0) then
			Ability.CastPosition(blink, enemyPosition)
			return
		end
	end
	if NPC.IsEntityInRange(myHero, enemy, NPC.GetAttackRange(myHero)*1.5) then
		if AllInOne.IsLinkensProtected() and Menu.IsEnabled(AllInOne.optionEnablePoopLinken) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE)then
			AllInOne.PoopLinken()
		end
		if w and Menu.IsEnabled(AllInOne.optionLegionEnablePressTheAttack) and Ability.IsCastable(w, myMana) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE)  then
			Ability.CastTarget(w, myHero)
			return
		end		
		if bkb and Menu.IsEnabled(AllInOne.optionLegionEnableBkb) and Ability.IsCastable(bkb, 0) then
			Ability.CastNoTarget(bkb)
			return
		end
		if abyssal and Ability.IsCastable(abyssal, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_STUNNED) and (Menu.IsEnabled(AllInOne.optionLegionEnableAbyssalWithDuel) or Menu.IsEnabled(AllInOne.optionLegionEnableAbyssalWthDuel)) then
			if Menu.IsEnabled(AllInOne.optionLegionEnableAbyssalWithDuel) and Menu.IsEnabled(AllInOne.optionLegionEnableDuel) and Ability.IsCastable(r, myMana) then
				Ability.CastTarget(abyssal, enemy)
				return
			elseif Menu.IsEnabled(AllInOne.optionLegionEnableAbyssalWthDuel) and (not Ability.IsCastable(r, myMana) or not Menu.IsEnabled(AllInOne.optionLegionEnableDuel)) then
				Ability.CastTarget(abyssal, enemy)
				return
			end
		end
		if mjolnir and Menu.IsEnabled(AllInOne.optionLegionEnableMjolnir) and Ability.IsCastable(mjolnir, myMana) then
			Ability.CastTarget(mjolnir, myHero)
			return
		end
		if lotus  and Menu.IsEnabled(AllInOne.optionLegionEnableLotus) and Ability.IsCastable(lotus, myMana) then
			Ability.CastTarget(lotus, myHero)
			return
		end
		if armlet and Menu.IsEnabled(AllInOne.optionLegionEnableArmlet) and not Ability.GetToggleState(armlet) and Ability.IsCastable(armlet, 0) and time >= nextTick then
			Ability.Toggle(armlet)
			nextTick = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if blademail and Menu.IsEnabled(AllInOne.optionLegionEnableBlademail) and Ability.IsCastable(blademail, myMana) then
			Ability.CastNoTarget(blademail)
			return
		end
		if solar and Menu.IsEnabled(AllInOne.optionLegionEnableSolar) and Ability.IsCastable(solar, 0) then
			Ability.CastTarget(solar, enemy)
			return
		end
		if courage and Menu.IsEnabled(AllInOne.optionLegionEnableCourage) and Ability.IsCastable(courage, 0) then
			Ability.CastTarget(courage, enemy)
			return
		end
		if halberd and Menu.IsEnabled(AllInOne.optionLegionEnableHalberd) and Ability.IsCastable(halberd, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(halberd, enemy)
			return
		end
		if orchid and Menu.IsEnabled(AllInOne.optionLegionEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(orchid, enemy)
			return
		end
		if bloodthorn and Menu.IsEnabled(AllInOne.optionLegionEnableBlood) and Ability.IsCastable(bloodthorn, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(bloodthorn, enemy)
			return
		end
		if satanic and Menu.IsEnabled(AllInOne.optionLegionEnableSatanic) and Ability.IsCastable(satanic, myMana) and Entity.GetHealth(myHero)/Entity.GetMaxHealth(myHero) < Menu.GetValue(AllInOne.optionLegionSatanicThreshold)/100 then
			Ability.CastNoTarget(satanic)
			return
		end
		if r and Menu.IsEnabled(AllInOne.optionLegionEnableDuel) and Ability.IsCastable(r, myMana) and not NPC.IsLinkensProtected(enemy) then
			if not NPC.IsEntityInRange(myHero, enemy, 150) then
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, enemyPosition, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
			else	
				Ability.CastTarget(r, enemy)
				return
			end
		end
	else
		if AllInOne.IsLinkensProtected() and Menu.IsEnabled(AllInOne.optionEnablePoopLinken) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			AllInOne.PoopLinken()
		end
		if r and Menu.IsEnabled(AllInOne.optionLegionEnableDuel) and Ability.IsCastable(r, myMana) and not NPC.IsLinkensProtected(enemy) then
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, enemyPosition, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
		else
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, enemy, Vector(0,0,0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
		end
		return
	end
end
function AllInOne.TuskCombo( ... )
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or not NPC.IsEntityInRange(myHero, enemy, Menu.GetValue(AllInOne.optionTuskComboRadius)) then
		enemy = nil
		return
	end
	if not added and Ability.GetLevel(NPC.GetAbility(myHero, "special_bonus_unique_tusk_3")) > 0 then
		snowball_speed = snowball_speed + 300
	end
	if w and Menu.IsEnabled(AllInOne.optionTuskEnableSnowball) and Ability.IsCastable(w, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(w, enemy)
		local tempTable = Entity.GetHeroesInRadius(myHero, 350, Enum.TeamType.TEAM_FRIEND)
		if not Menu.IsEnabled(AllInOne.optionTuskEnablePickTeam) then
			tempTable = nil
		else
			if tempTable then
				for i, k in pairs(tempTable) do
					if not NPC.HasModifier(k, "modifier_tusk_snowball_movement_friendly") then
						Player.AttackTarget(myPlayer, myHero, k, false)
					end
				end
				tempTable = nil
			end	
		end
		if Ability.IsCastable(f, 0) and not tempTable then
			Ability.CastNoTarget(f)
		end
		return
	end
	if q and Menu.IsEnabled(AllInOne.optionTuskEnableShard) and Ability.IsCastable(q, myMana) and not NPC.IsTurning(myHero) then
		if NPC.HasModifier(enemy, "modifier_stunned") and Modifier.GetDieTime(NPC.GetModifier(enemy,"modifier_stunned")) > (myPos:__sub(enemyPosition)):Length()/snowball_speed then
			Ability.CastPosition(q, AllInOne.ShardPrediction(0))
		elseif not NPC.IsRunning(enemy) then
			Ability.CastPosition(q, AllInOne.ShardPrediction(0))
		else
			Ability.CastPosition(q, AllInOne.ShardPrediction())
		end
		return
	end
	if Menu.IsEnabled(AllInOne.optionTuskEnableSigil) and Ability.IsCastable(e, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		if NPC.IsEntityInRange(myHero, enemy, 450) then
			Ability.CastNoTarget(e)
		end
		return
	end
	if urn and Menu.IsEnabled(AllInOne.optionTuskEnableUrn) and Item.GetCurrentCharges(urn) > 0 and Ability.IsCastable(urn,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(urn, enemy)
		return
	end
	if vessel and Menu.IsEnabled(AllInOne.optionTuskEnableVessel) and Item.GetCurrentCharges(vessel) > 0 and Ability.IsCastable(vessel,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(vessel, enemy)
		return
	end
	if solar and Menu.IsEnabled(AllInOne.optionTuskEnableSolar) and Ability.IsCastable(solar,0) then
		Ability.CastTarget(solar, enemy)
		return
	end
	if courage and Menu.IsEnabled(AllInOne.optionTuskEnableCourage) and Ability.IsCastable(courage,0) then
		Ability.CastTarget(courage, enemy)
		return
	end
	if orchid and Menu.IsEnabled(AllInOne.optionTuskEnableOrchid) and Ability.IsCastable(orchid,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(orchid, enemy)
		return
	end
	if bloodthorn and Menu.IsEnabled(AllInOne.optionTuskEnableBlood) and Ability.IsCastable(bloodthorn,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(bloodthorn, enemy)
		return
	end
	if mjolnir and Menu.IsEnabled(AllInOne.optionTuskEnableMjolnir) and Ability.IsCastable(mjolnir,0) then
		Ability.CastTarget(mjolnir, myHero)
		return
	end
	if abyssal and Menu.IsEnabled(AllInOne.optionTuskEnableAbyssal) and Ability.IsCastable(abyssal,0) then
		Ability.CastTarget(abyssal, enemy)
		return
	end
	if halberd and Menu.IsEnabled(AllInOne.optionTuskEnableHalberd) and Ability.IsCastable(halberd,0) and NPC.IsAttacking(enemy) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
		Ability.CastTarget(halberd, enemy)
		return
	end
	if bkb and Menu.IsEnabled(AllInOne.optionTuskEnableBkb) and Ability.IsCastable(bkb,0) then
		Ability.CastNoTarget(bkb)
		return
	end
	if armlet and Menu.IsEnabled(AllInOne.optionTuskEnableArmlet) and not Ability.GetToggleState(armlet) and Ability.IsCastable(armlet,0) and time >= nextTick then
		Ability.Toggle(armlet)
		nextTick = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
		return
	end
	if Menu.IsEnabled(AllInOne.optionTuskEnablePunch) and Ability.GetLevel(r) > 0 and Ability.IsCastable(r, myMana) and NPC.IsEntityInRange(myHero, enemy, 350) and not NPC.HasModifier(myHero, "modifier_tusk_snowball_movement") then
		Ability.CastTarget(r, enemy)
		return
	end	
	if not NPC.IsAttacking(myHero) and Menu.IsEnabled(AllInOne.optionTuskEnablePunch) and not Ability.IsCastable(r, myMana) then
		Player.AttackTarget(myPlayer, myHero, enemy, false)
	elseif not NPC.IsAttacking(myHero) and not Menu.IsEnabled(AllInOne.optionTuskEnablePunch) then
		Player.AttackTarget(myPlayer, myHero, enemy, false)	
	end
end
function AllInOne.ShardPrediction(speed)
	if not enemy then return end
	local pos = enemyPosition
	local dir = Entity.GetRotation(myHero):GetForward():Normalized()
	if not speed then
		speed = AllInOne.GetMoveSpeed(enemy)
	end
	if speed == 0 then
		pos = pos + dir:Scaled(100)
	end	
	if speed <= 350 then
		pos = pos + dir:Scaled(speed*1.2)
	else
		pos = pos + dir:Scaled(speed*1.3)
	end	
	return pos
end
function AllInOne.ClinkzCombo( ... )
	if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or NPC.HasModifier(enemy, "modifier_dark_willow_shadow_realm_buff") then
		enemy = nil
		return
	end
	if attackRange ~= NPC.GetAttackRange(myHero) then
		attackRange = NPC.GetAttackRange(myHero)
	end
	if NPC.IsEntityInRange(myHero, enemy, attackRange) then
		if q and Ability.IsCastable(q, myMana) then
			Ability.CastNoTarget(q)
			return
		end
		if not Ability.GetAutoCastState(w) and time >= nextTick then
			Ability.ToggleMod(w)
			nextTick = time + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
			return
		end
		if AllInOne.IsLinkensProtected() and Menu.IsEnabled(AllInOne.optionEnablePoopLinken) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			AllInOne.PoopLinken()
		end
		if hex and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) and Menu.IsEnabled(AllInOne.optionClinkzEnableHex) and Ability.IsCastable(hex, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(hex, enemy)
			return
		end		
		if nullifier and not NPC.HasModifier(enemy, "modifier_item_nullifier_mute") and Menu.IsEnabled(AllInOne.optionClinkzEnableNullifier) and Ability.IsCastable(nullifier, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			if NPC.GetItem(enemy, "item_aeon_disk", true) then
				if NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") and not Ability.IsReady(NPC.GetItem(enemy, "item_aeon_disk", true)) then
					Ability.CastTarget(nullifier,enemy)
				end
			else
				if NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) and not Menu.IsEnabled(AllInOne.optionClinkzEnableStack) then
					local modHex = NPC.GetModifier(enemy, "modifier_sheepstick_debuff")
					if not modHex then
						modHex = NPC.GetModifier(enemy, "modifier_shadow_shaman_voodoo")
					end
					if not modHex then
						modHex = NPC.GetModifier(enemy, "modifier_lion_voodoo")
					end
					if modHex then
						local dieTime = Modifier.GetDieTime(modHex)
						if dieTime - time <= (enemyPosition-myPos):Length()/750 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
							Ability.CastTarget(nullifier,enemy)
						end
					end
				else
					Ability.CastTarget(nullifier, enemy)
				end
			end
			return
		end		
		if diffusal and not NPC.HasModifier(enemy, "modifier_item_diffusal_blade_slow") and Menu.IsEnabled(AllInOne.optionClinkzEnableDiffusal) and Ability.IsCastable(diffusal,0) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			Ability.CastTarget(diffusal, enemy)
			return
		end
		if orchid and not NPC.HasModifier(enemy, "modifier_orchid_malevolence_debuff") and Menu.IsEnabled(AllInOne.optionClinkzEnableOrchid) and Ability.IsCastable(orchid, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			if Menu.IsEnabled(AllInOne.optionClinkzEnableStack) and NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED)then
				Ability.CastTarget(orchid, enemy)
			elseif not Menu.IsEnabled(AllInOne.optionClinkzEnableStack) and NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
			
			else
				Ability.CastTarget(orchid, enemy)	
			end
			return
		end
		if bloodthorn and not NPC.HasModifier(enemy, "modifier_bloodthorn_debuff") and Menu.IsEnabled(AllInOne.optionClinkzEnableBlood) and Ability.IsCastable(bloodthorn, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
			if Menu.IsEnabled(AllInOne.optionClinkzEnableStack) and NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
				Ability.CastTarget(bloodthorn, enemy)
			elseif not Menu.IsEnabled(AllInOne.optionClinkzEnableStack) and NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_HEXED) then
			
			else
				Ability.CastTarget(bloodthorn, enemy)	
			end
			return
		end
		if courage and not NPC.HasModifier(enemy, "modifier_item_medallion_of_courage_armor_reduction") and Menu.IsEnabled(AllInOne.optionClinkzEnableCourage) and Ability.IsCastable(courage, 0) then
			Ability.CastTarget(courage, enemy)
			return
		end
		if solar and not NPC.HasModifier(enemy, "modifier_item_solar_crest_armor_reduction") and Menu.IsEnabled(AllInOne.optionClinkzEnableSolar) and Ability.IsCastable(solar, 0) then
			Ability.CastTarget(solar, enemy)
			return
		end
		if bkb and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and Menu.IsEnabled(AllInOne.optionClinkzEnableBkb) and Ability.IsCastable(bkb, 0) then
			Ability.CastNoTarget(bkb)
			return
		end
	end
	Player.AttackTarget(myPlayer, myHero, enemy)
end
function AllInOne.IsLinkensProtected()
	if NPC.IsLinkensProtected(enemy) then
		return true
	end
	return false
end
function AllInOne.PoopLinken(exception)
	if abyssal and Menu.IsEnabled(AllInOne.optionEnablePoopAbyssal) and Ability.IsCastable(abyssal, myMana) then
		Ability.CastTarget(abyssal, enemy)
		return
	end
	if bloodthorn and Menu.IsEnabled(AllInOne.optionEnablePoopBlood) and Ability.IsCastable(bloodthorn, myMana) then
		Ability.CastTarget(bloodthorn, enemy)
		return
	end
	if dagon and Menu.IsEnabled(AllInOne.optionEnablePoopDagon) and Ability.IsCastable(dagon, myMana) then
		Ability.CastTarget(dagon, enemy)
		return
	end
	if diffusal and Menu.IsEnabled(AllInOne.optionEnablePoopDiffusal) and Ability.IsCastable(diffusal, 0) then
		Ability.CastTarget(diffusal, enemy)
		return
	end
	if eul and Menu.IsEnabled(AllInOne.optionEnablePoopEul) and Ability.IsCastable(eul, myMana) and eul ~= exception then
		Ability.CastTarget(eul, enemy)
		return
	end
	if force and Menu.IsEnabled(AllInOne.optionEnablePoopForce) and Ability.IsCastable(force, myMana) then
		Ability.CastTarget(force, enemy)
		return
	end
	if halberd and Menu.IsEnabled(AllInOne.optionEnablePoopHalberd) and Ability.IsCastable(halberd, myMana) then
		Ability.CastTarget(halberd, enemy)
		return
	end
	if hex and Menu.IsEnabled(AllInOne.optionEnablePoopHex) and Ability.IsCastable(hex, myMana) then
		Ability.CastTarget(hex, enemy)
		return
	end
	if pike and Menu.IsEnabled(AllInOne.optionEnablePoopPike) and Ability.IsCastable(pike, myMana) then
		Ability.CastTarget(pike, enemy)
		return
	end
	if orchid and Menu.IsEnabled(AllInOne.optionEnablePoopOrchid) and Ability.IsCastable(orchid, myMana) then
		Ability.CastTarget(orchid, enemy)
		return
	end
end
function AllInOne.OnPrepareUnitOrders(order)
	if not myHero or not Menu.IsEnabled(AllInOne.optionTinkerFailSwitch) or comboHero ~= "Tinker" then
		return
	end
	if not order or not order.ability or order.order ~= 8 then
		return
	end
	if Ability.GetName(order.ability) == "tinker_heat_seeking_missile" then
		if not Entity.GetHeroesInRadius(myHero, Ability.GetCastRange(w), Enum.TeamType.TEAM_ENEMY) then
			return false
		end
	end
	if Ability.GetName(order.ability) == "tinker_rearm" then
		local bool = false
		for i = 0, 8 do
			local item = NPC.GetItemByIndex(myHero, i)
			if item and item ~= 0 and not Ability.IsReady(item) then
				bool = true
				break
			end
		end
		if not bool then
			for i = 0, 5 do
				local ability = NPC.GetAbilityByIndex(myHero, i)
				if ability and not Ability.IsHidden(ability) and not Ability.IsReady(ability) then
					bool = true
					break
				end
			end
		end
		return bool
	end
end
AllInOne.Init()
return AllInOne