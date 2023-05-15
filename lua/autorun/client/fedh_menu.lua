local function PopulateSBXToolMenu(pnl)
    pnl:CheckBox("Enabled", "fedhoria_enabled")
    pnl:ControlHelp("Enable or disable Fanhoria.")

    pnl:CheckBox("Lethal Headshots", "fedhoria_lethalheadshots")
    pnl:ControlHelp("Enable or disable lethal headshots. This will make NPCs immediately die if shot in the head.      This only works with models that use the valve biped skeleton, if using custom models keep this off.      It's recommended to keep this on otherwise.")

    pnl:NumSlider("Stumble time", "fedhoria_stumble_time", 0, 10, 3)
    pnl:ControlHelp("This effects how long the ragdoll will stumble around for in seconds.      Stumbling looks very bad and janky so it's recommended to keep this at 0 until updated to look better.")

    pnl:NumSlider("Die time", "fedhoria_dietime", 0, 10, 3)
    pnl:ControlHelp("This controls how long before the ragdoll dies after drowning/being still for too long in seconds.     It's recommended to keep this at 10.")

    pnl:NumSlider("Right wound grab chance", "fedhoria_grabright_chance", 0, 1, 3)
    pnl:ControlHelp("This is the chance the ragdoll will grab it's wound with it's right hand when shot. 0.25 Correlates to 25% and vice versa.      It's recommended to keep this at 0.5.")

    pnl:NumSlider("Left wound grab chance", "fedhoria_grableft_chance", 0, 1, 3)
    pnl:ControlHelp("This is the chance the ragdoll will grab it's wound with it's left hand when shot. 0.25 Correlates to 25% and vice versa.      It's recommended to keep this at 0.5.")

    pnl:NumSlider("Wound grab time", "fedhoria_woundgrab_time", 0, 10, 3)
    pnl:ControlHelp("This controls how long the ragdoll should hold its wound in seconds.       It's recommended to keep this at 6.5.")
end

if engine.ActiveGamemode() == "sandbox" then
    hook.Add("AddToolMenuCategories", "FedhoriaCategory", function() 
        spawnmenu.AddToolCategory("Options", "Fanhoria", "Fanhoria")
    end)

    hook.Add("PopulateToolMenu", "FedhoriaMenuSettings", function() 
        spawnmenu.AddToolMenuOption("Options", "Fanhoria", "FedhoriaSettings", "Settings", "", "", function(pnl)
            pnl:ClearControls()
            PopulateSBXToolMenu(pnl)
        end)
    end)
end