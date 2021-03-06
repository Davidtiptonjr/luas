-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Mode
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Composure
--              [ CTRL+- ]          Light Arts/Addendum: White
--              [ CTRL+= ]          Dark Arts/Addendum: Black
--              [ CTRL+; ]          Celerity/Alacrity
--              [ ALT+[ ]           Accesion/Manifestation
--              [ ALT+; ]           Penury/Parsimony
--
--  Spells:     [ CTRL+` ]          Stun
--              [ ALT+Q ]           Temper
--              [ ALT+W ]           Flurry II
--              [ ALT+E ]           Haste II
--              [ ALT+R ]           Refresh II
--              [ ALT+Y ]           Phalanx
--              [ ALT+O ]           Regen II
--              [ ALT+P ]           Shock Spikes
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad9 ]    Chant Du Cygne
--              [ CTRL+Numpad4 ]    Requiescat
--              [ CTRL+Numpad1 ]    Sanguine Blade
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--              Addendum Commands:
--              Shorthand versions for each strategem type that uses the version appropriate for
--              the current Arts.
--                                          Light Arts                  Dark Arts
--                                          ----------                  ---------
--              gs c scholar light          Light Arts/Addendum
--              gs c scholar dark                                       Dark Arts/Addendum
--              gs c scholar cost           Penury                      Parsimony
--              gs c scholar speed          Celerity                    Alacrity
--              gs c scholar aoe            Accession                   Manifestation
--              gs c scholar addendum       Addendum: White             Addendum: Black


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

    state.CP = M(false, "Capacity Points Mode")
    state.Buff.Saboteur = buffactive.Saboteur or false

    enfeebling_magic_acc = S{'Bind', 'Break', 'Dispel', 'Distract', 'Distract II', 'Frazzle',
        'Frazzle II',  'Gravity', 'Gravity II', 'Silence', 'Sleep', 'Sleep II', 'Sleepga'}
    enfeebling_magic_skill = S{'Distract III', 'Frazzle III', 'Poison II'}
    enfeebling_magic_effect = S{'Dia', 'Dia II', 'Dia III', 'Diaga'}

    skill_spells = S{
        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',
        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}

    lockstyleset = 14

    update_offense_mode()
    determine_haste_group()
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Seidr', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
    include('Global-GEO-Binds.lua') -- OK to remove this line

    send_command('bind ^` input /ja Composure <me>')
    send_command('bind !` gs c toggle MagicBurst')

    if player.sub_job == 'SCH' then
        send_command('bind ^- gs c scholar light')
        send_command('bind ^= gs c scholar dark')
        send_command('bind !- gs c scholar addendum')
        send_command('bind != gs c scholar addendum')
        send_command('bind ^; gs c scholar speed')
        send_command('bind ![ gs c scholar aoe')
        send_command('bind !; gs c scholar cost')
    end

    send_command('bind !q input /ma "Temper II" <me>')
    send_command('bind !w input /ma "Flurry II" <stpc>')
    send_command('bind !e input /ma "Haste II" <stpc>')
    send_command('bind !r input /ma "Refresh III" <stpc>')
    send_command('bind !y input /ma "Phalanx II" <stpc>')
    send_command('bind !o input /ma "Regen II" <stpc>')
    send_command('bind !p input /ma "Shock Spikes" <me>')

    send_command('bind @c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')

    send_command('bind ^numpad7 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad9 input /ws "Chant du Cygne" <t>')
    send_command('bind ^numpad4 input /ws "Requiescat" <t>')
    send_command('bind ^numpad1 input /ws "Sanguine Blade" <t>')
    send_command('bind ^numpad2 input /ws "Red Lotus Blade" <t>')
    send_command('bind ^numpad3 input /ws "Flat Blade" <t>')

    select_default_macro_book()
    set_lockstyle()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ^;')
    send_command('unbind ![')
    send_command('unbind !;')
    send_command('unbind !q')
    send_command('unbind !w')
    send_command('bind !e input /ma "Haste" <stpc>')
    send_command('bind !r input /ma "Refresh" <stpc>')
    send_command('bind !y input /ma "Phalanx" <me>')
    send_command('unbind !o')
    send_command('unbind !p')
    send_command('unbind @c')
    send_command('unbind @w')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Viti. Tabard +1"}

    -- Fast cast sets for spells

    -- Fast cast sets for spells
    sets.precast.FC = {
    --    Traits --30
        ammo="Sapience Orb", --2
        head="Atrophy Chapeau +3", --16
        legs="Aya. Cosciales +2", --6
        feet="Carmine Greaves +1", --8
        neck="Orunmila's Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Kishar Ring", --4
        ring2="Weather. Ring +1", --5
        }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        ear1="Mendi. Earring", --5
        ring1="Lebeche Ring", --(2)
        back="Perimede Cape", --(4)
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC['Healing Magic'] = sets.precast.FC.Cure
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {waist="Channeler's Stone"})
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
    sets.precast.Storm = set_combine(sets.precast.FC, {ring2="Levia. Ring +1", waist="Channeler's Stone"}) -- stop quick cast

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        neck="Magoraga Beads",
        ring1="Lebeche Ring",
        back="Perimede Cape",
        waist="Rumination Sash",
        })


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo="Floestone",
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Atrophy Gloves +3",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Ishvara Earring",
        ring1="Rufescent Ring",
        ring2="Shukuyu Ring",
        back=gear.RDM_WS1_Cape,
        waist="Fotia Belt",
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        neck="Combatant's Torque",
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head=gear.Taeon_Crit_head,
        body=gear.Taeon_Crit_body,
        hands=gear.Taeon_Crit_hands,
        legs=gear.Taeon_Crit_legs,
        feet="Thereoid Greaves",
        ear2="Sherida Earring",
        ring1="Begrudging Ring",
        ring2="Ilabrat Ring",
        back=gear.RDM_WS2_Cape,
        })

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
        head=gear.Taeon_TA_head,
        body=gear.Taeon_TA_body,
        hands=gear.Taeon_TA_hands,
        legs=gear.Taeon_TA_legs,
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck="Caro Necklace",
        ear2="Sherida Earring",
        waist="Prosilio Belt +1",
        })

    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        neck="Combatant's Torque",
        ear2="Telos Earring",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Death Blossom'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Death Blossom'].Acc = sets.precast.WS['Savage Blade'].Acc

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        ammo="Regal Gem",
        ear2="Sherida Earring",
        })

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
        neck="Combatant's Torque",
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Sanguine Blade'] = {
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Amalric Doublet +1",
        hands="Amalric Gages +1",
        legs="Merlinic Shalwar",
        feet="Merlinic Crackows",
        neck="Baetyl Pendant",
        ear1="Moonshade Earring",
        ear2="Regal Earring",
        ring1="Shiva Ring +1",
        ring2="Archon Ring",
        back=gear.RDM_INT_Cape,
        waist="Refoccilation Stone",
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        legs="Carmine Cuisses +1", --20
        ring1="Evanescence Ring", --5
        waist="Rumination Sash", --10
        }

    sets.midcast.Cure = {
        main="Tamaxchi", --22/(-10)
        sub="Sors Shield", --3/(-5)
        ammo="Esper Stone +1", --0/(-5)
        head="Gende. Caubeen +1", --15/(-8)
        body="Kaykaus Bliaut", --(+3)
        hands="Kaykaus Cuffs +1", --11/(-6)
        legs="Kaykaus Tights", --10/(-5)
        feet="Kaykaus Boots", --10/(-10)
        neck="Incanter's Torque",
        ear1="Mendi. Earring", --5
        ear2="Roundel Earring", --5
        ring1="Lebeche Ring", --3/(-5)
        ring2="Haoma's Ring",
        back=gear.RDM_MND_Cape, --10
        waist="Bishop's Sash",
        }

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        main="Chatoyant Staff",
        sub="Achaq Grip", --0/(-4)
        hands="Kaykaus Cuffs +1", --11/(-6)
        back="Twilight Cape",
        waist="Hachirin-no-Obi",
        })

    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {
        hands="Buremte Gloves", -- (13)
        neck="Phalaina Locket", -- 4(4)
        ring2="Asklepian Ring", -- (3)
        waist="Gishdubar Sash", -- (10)
        })

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        ammo="Regal Gem",
        ring1="Levia. Ring +1",
        ring2="Levia. Ring +1",
        waist="Luminary Sash",
        })

    sets.midcast.StatusRemoval = {
        head="Vanya Hood",
        body="Vanya Robe",
        legs="Atrophy Tights +2",
        feet="Vanya Clogs",
        neck="Incanter's Torque",
        ear2="Healing Earring",
        ring1="Haoma's Ring",
        ring2="Haoma's Ring",
        back=gear.RDM_MND_Cape,
        waist="Bishop's Sash",
        }

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        hands="Hieros Mittens",
        neck="Debilis Medallion",
        ear1="Beatific Earring",
        back="Oretan. Cape +1",
        })

    sets.midcast['Enhancing Magic'] = {
        main=gear.Colada_ENH,
        sub="Ammurapi Shield",
        ammo="Regal Gem",
        head="Befouled Crown",
        body="Viti. Tabard +1",
        hands="Atrophy Gloves +3",
        legs="Atrophy Tights +2",
        feet="Leth. Houseaux +1",
        neck="Incanter's Torque",
        ear1="Augment. Earring",
        ear2="Andoaa Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back="Ghostfyre Cape",
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = {
        main=gear.Colada_ENH,
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Atrophy Gloves +3",
        legs="Telchine Braconi",
        feet="Leth. Houseaux +1",
        back="Ghostfyre Cape",
        }

    sets.midcast.EnhancingSkill = {
        main="Pukulatmuj +1",
        sub="Pukulatmuj",
        hands="Viti. Gloves +1",
        }

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        body="Telchine Chas.",
        })

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif", -- +1
        body="Atrophy Tabard +3", -- +3
        legs="Leth. Fuseau +1", -- +2
        })

    sets.midcast.RefreshSelf = {
        waist="Gishdubar Sash",
        back="Grapevine Cape"
        }

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        neck="Nodens Gorget",
        waist="Siegel Sash",
        })

    sets.midcast['Phalanx'] = set_combine(sets.midcast.EnhancingDuration, {
        body=gear.Taeon_Phalanx_body, --3
        hands=gear.Taeon_Phalanx_hands, --3
        legs=gear.Taeon_Phalanx_legs, --3
        feet=gear.Taeon_Phalanx_feet, --3
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif",
        waist="Emphatikos Rope",
        })

    sets.midcast.Storm = sets.midcast.EnhancingDuration

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
        ring2="Sheltered Ring",
        })

    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

     -- Custom spell classes
    sets.midcast.MndEnfeebles = {
        main=gear.Grioavolr_MND,
        sub="Enki Strap",
        ammo="Regal Gem",
        head="Atrophy Chapeau +3",
        body="Lethargy Sayon +1",
        hands="Kaykaus Cuffs +1",
        legs="Chironic Hose",
        feet="Skaoi Boots",
        neck="Imbodla Necklace",
        ear1="Hermetic Earring",
        ear2="Regal Earring",
        ring1="Kishar Ring",
        ring2="Globidonta Ring",
        back=gear.RDM_MND_Cape,
        waist="Luminary Sash",
        }

    sets.midcast.MndEnfeeblesAcc = set_combine(sets.midcast.MndEnfeebles, {
        head="Atrophy Chapeau +3",
        body="Atrophy Tabard +3",
        neck="Sanctity Necklace",
        ring2="Weather. Ring +1",
        })

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        main=gear.Grioavolr_MB,
        back=gear.RDM_INT_Cape,
        })

    sets.midcast.IntEnfeeblesAcc = set_combine(sets.midcast.IntEnfeebles, {
        body="Atrophy Tabard +3",
        neck="Erra Pendant",
        ring2="Weather. Ring +1",
        })

    sets.midcast.SkillEnfeebles = {
        sub="Mephitis Grip",
        head="Viti. Chapeau +1",
        body="Atrophy Tabard +3",
        hands="Leth. Gantherots +1",
        neck="Incanter's Torque",
        ring1="Stikini Ring",
        ear1="Enfeebling Earring",
        waist="Rumination Sash",
        }

    sets.midcast.EffectEnfeebles = {
        ammo="Regal Gem",
        body="Lethargy Sayon +1",
        feet="Uk'uxkaj Boots",
        back=gear.RDM_MND_Cape,
        }

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

    sets.midcast['Dia III'] = set_combine(sets.midcast.MndEnfeebles, sets.midcast.EffectEnfeebles, {head="Viti. Chapeau +1"})
    sets.midcast['Paralyze II'] = set_combine(sets.midcast.MndEnfeebles, {head="Vitiation Boots +1"})
    sets.midcast['Slow II'] = set_combine(sets.midcast.MndEnfeebles, {head="Viti. Chapeau +1"})

    sets.midcast['Dark Magic'] = {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head="Atrophy Chapeau +3",
        body="Atrophy Tabard +3",
        hands="Kaykaus Cuffs +1",
        legs="Jhakri Slops +2",
        feet="Merlinic Crackows",
        neck="Erra Pendant",
        ear1="Hermetic Earring",
        ear2="Regal Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back=gear.RDM_INT_Cape,
        waist="Luminary Sash",
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1",
        feet="Merlinic Crackows",
        ear1="Hirudinea Earring",
        ring2="Archon Ring",
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain
    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {waist="Luminary Sash"})

    sets.midcast['Elemental Magic'] = {
        main=gear.Grioavolr_MB,
        sub="Niobid Strap",
        ammo="Pemphredo Tathlum",
        head="Merlinic Hood",
        body="Amalric Doublet +1",
        hands="Amalric Gages +1",
        legs="Merlinic Shalwar",
        feet="Merlinic Crackows",
        neck="Baetyl Pendant",
        ear1="Friomisi Earring",
        ear2="Regal Earring",
        ring1="Shiva Ring +1",
        ring2="Shiva Ring +1",
        back=gear.RDM_INT_Cape,
        waist="Refoccilation Stone",
        }

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        body="Seidr Cotehardie",
        feet="Jhakri Pigaches +2",
        neck="Erra Pendant",
        })

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        head="Atrophy Chapeau +3",
        feet="Jhakri Pigaches +2",
        neck="Erra Pendant",
        ear1="Hermetic Earring",
        waist="Yamabuki-no-Obi",
        })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        main=gear.Grioavolr_MB,
        sub="Niobid Strap",
        head=empty,
        body="Twilight Cloak",
        ring1="Archon Ring",
        })

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    -- Job-specific buff sets
    sets.buff.ComposureOther = {
        head="Leth. Chappel +1",
        body="Lethargy Sayon +1",
        --hands="Leth. Gantherots +1",
        legs="Leth. Fuseau +1",
        feet="Leth. Houseaux +1",
        }

    sets.buff.Saboteur = {hands="Leth. Gantherots +1"}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        main="Bolelabunga",
        sub="Beatific Shield +1",
        ammo="Homiliary",
        head="Viti. Chapeau +1",
        body="Jhakri Robe +2",
        hands="Atrophy Gloves +3",
        legs="Carmine Cuisses +1",
        feet="Carmine Greaves +1",
        neck="Bathy Choker +1",
        ear1="Genmei Earring",
        ear2="Infused Earring",
        ring1="Paguroidea Ring",
        ring2="Sheltered Ring",
        back="Moonlight Cape",
        waist="Flume Belt +1",
        }

    sets.idle.DT = set_combine(sets.idle, {
        main="Bolelabunga",
        sub="Beatific Shield +1", --4/29
        ammo="Staunch Tathlum", --2/2
        head="Gende. Caubeen +1", --4/4
        body="Ayanmo Corazza +2", --6/6
        hands="Gende. Gages +1", --4/3
        neck="Loricate Torque +1", --6/6
        ear1="Genmei Earring", --2/0
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
        waist="Slipor Sash", --0/3
        })

    sets.idle.Town = set_combine(sets.idle, {
        ammo="Regal Gem",
        head="Atrophy Chapeau +3",
        body="Amalric Doublet +1",
        hands="Amalric Gages +1",
        neck="Incanter's Torque",
        ear1="Sherida Earring",
        ear2="Regal Earring",
        ring1="Levia. Ring +1",
        ring2="Weather. Ring +1",
        back=gear.RDM_INT_Cape,
        waist="Luminary Sash",
        })

    sets.idle.Weak = sets.idle.DT

    sets.resting = set_combine(sets.idle, {
        main="Chatoyant Staff",
        waist="Shinjutsu-no-Obi +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.magic_burst = {
        main=gear.Grioavolr_MB, --5
        body="Merlinic Jubbah", --10
        hands="Ea Cuffs", --5(5)
        feet="Merlinic Crackows", --11
        neck="Mizu. Kubikazari", --10
        ring1="Mujin Band", --(5)
        }

    sets.Kiting = {legs="Carmine Cuisses +1"}
    sets.latent_refresh = {waist="Fucho-no-obi"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        main="Sequence",
        sub="Genmei Shield",
        ammo="Ginsen",
        head=gear.Taeon_TA_head,
        body="Ayanmo Corazza +2",
        hands=gear.Taeon_TA_hands,
        legs=gear.Taeon_TA_legs,
        feet="Carmine Greaves +1",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring",
        ring2="Hetairoi Ring",
        back=gear.RDM_DW_Cape,
        waist="Windbuffet Belt +1",
        }

    sets.engaged.MidAcc = set_combine(sets.engaged, {
        neck="Combatant's Torque",
        waist="Kentarch Belt +1",
        ring2="Ilabrat Ring",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        ear1="Cessance Earring",
        ring1="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
        main="Sequence",
        sub=gear.Colada_ATT,
        ammo="Ginsen",
        head=gear.Taeon_TA_head,
        body="Ayanmo Corazza +2",
        hands=gear.Taeon_TA_hands,
        legs="Carmine Cuisses +1", --6
        feet=gear.Taeon_DW_feet, --9
        neck="Anu Torque",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Chirich Ring",
        ring2="Hetairoi Ring",
        back=gear.RDM_DW_Cape, --10
        waist="Reiki Yotai", --7
        } --41

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW, {
        neck="Combatant's Torque",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        head="Carmine Mask +1",
        ring1="Ramuh Ring +1",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
        ammo="Ginsen",
        head=gear.Taeon_TA_head,
        body="Ayanmo Corazza +2",
        hands=gear.Taeon_TA_hands,
        legs="Carmine Cuisses +1", --6
        feet=gear.Taeon_DW_feet, --9
        neck="Anu Torque",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Chirich Ring",
        ring2="Hetairoi Ring",
        back=gear.RDM_DW_Cape, --10
        waist="Reiki Yotai", --7
        }) --41

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        neck="Combatant's Torque",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        head="Carmine Mask +1",
        ring1="Ramuh Ring +1",
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW, {
        ammo="Ginsen",
        head=gear.Taeon_TA_head,
        body="Ayanmo Corazza +2",
        hands=gear.Taeon_TA_hands,
        legs=gear.Taeon_TA_legs,
        feet=gear.Taeon_DW_feet, --9
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Suppanomimi", --5
        ring1="Chirich Ring",
        ring2="Hetairoi Ring",
        back=gear.RDM_DW_Cape, --10
        waist="Reiki Yotai", --7
        }) --41

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        legs="Carmine Cuisses +1", --6
        neck="Combatant's Torque",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        head="Carmine Mask +1",
        ear1="Cessance Earring",
        ring1="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW, {
        ammo="Ginsen",
        head=gear.Taeon_TA_head,
        body="Ayanmo Corazza +2",
        hands=gear.Taeon_TA_hands,
        legs=gear.Taeon_TA_legs,
        feet=gear.Taeon_DW_feet, --9
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring",
        ring2="Hetairoi Ring",
        back=gear.RDM_DW_Cape, --10
        waist="Reiki Yotai", --7
        }) --26

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        legs="Carmine Cuisses +1", --6
        neck="Combatant's Torque",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        head="Carmine Mask +1",
        ear1="Cessance Earring",
        ring1="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW, {
        ammo="Ginsen",
        head=gear.Taeon_TA_head,
        body="Ayanmo Corazza +2",
        hands=gear.Taeon_TA_hands,
        legs=gear.Taeon_TA_legs,
        feet="Carmine Greaves +1",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring",
        ring2="Hetairoi Ring",
        back=gear.RDM_DW_Cape, --10
        waist="Windbuffet Belt +1",
        }) --10

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        neck="Combatant's Torque",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1", --6
        ear1="Cessance Earring",
        ring1="Ramuh Ring +1",
        waist="Olseni Belt",
        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        neck="Loricate Torque +1", --6/6
        ring2="Defending Ring", --10/10
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {ring1="Eshmun's Ring", ring2="Eshmun's Ring", waist="Gishdubar Sash"}

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
    if spell.english == "Phalanx II" and spell.target.type == 'SELF' then
        cancel_spell()
        send_command('@input /ma "Phalanx" <me>')
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' then
        if enfeebling_magic_skill:contains(spell.english) or enfeebling_magic_effect:contains(spell.english) then
            if spell.type == "WhiteMagic" then
                equip(sets.midcast.MndEnfeeblesAcc)
            else
                equip(sets.midcast.IntEnfeeblesAcc)
            end
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' then
        if enfeebling_magic_skill:contains(spell.english) then
            equip(sets.midcast.SkillEnfeebles)
        elseif enfeebling_magic_effect:contains(spell.english) then
            equip(sets.midcast.EffectEnfeebles)
        end
        if state.Buff.Saboteur then
            equip(sets.buff.Saboteur)
        end
    end
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
                if spell.target.type == 'SELF' then
                    equip (sets.midcast.RefreshSelf)
                end
            end
        elseif skill_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingSkill)
        end
        if (spell.target.type == 'PLAYER' or spell.target.type == 'NPC') and buffactive.Composure then
            equip(sets.buff.ComposureOther)
        end
    end
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value and spell.english ~= 'Death' then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Break" then
            send_command('@timers c "Break ['..spell.target.name..']" 30 down spells/00255.png')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste', 'erratic flutter'}:contains(buff:lower()) then
        determine_haste_group()
        if not gain then
            haste = nil
            --add_to_chat(122, "Haste Status: Cleared")
            determine_haste_group()
        end
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == "WhiteMagic" then
                if  enfeebling_magic_effect:contains(spell.english) then
                    return "EffectEnfeebles"
                elseif not enfeebling_magic_skill:contains(spell.english) then
                    if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                        return "MndEnfeeblesAcc"
                    else
                        return "MndEnfeebles"
                    end
                end
            elseif spell.type == "BlackMagic" then
                if  enfeebling_magic_effect:contains(spell.english) then
                    return "EffectEnfeebles"
                elseif not enfeebling_magic_skill:contains(spell.english) then
                    if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                        return "IntEnfeeblesAcc"
                    else
                        return "IntEnfeebles"
                    end
                end
            else
                return "MndEnfeebles"
            end
        end
    end
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_offense_mode()
    determine_haste_group()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
     elseif state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end

    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = '[ Melee'

    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end

    msg = msg .. ': '

    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ' ][ WS: ' .. state.WeaponskillMode.value .. ' ]'

    if state.DefenseMode.value ~= 'None' then
        msg = msg .. '[ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ' ]'
    end

    if state.IdleMode.value ~= 'None' then
        msg = msg .. '[ Idle: ' .. state.IdleMode.value .. ' ]'
    end

    if state.Kiting.value then
        msg = msg .. '[ Kiting Mode: ON ]'
    end

    add_to_chat(060, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

--Read incoming packet to differentiate between Haste I and II
windower.register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 57 and haste ~= 2 then
                    --add_to_chat(122, 'Haste Status: Haste I (Haste)')
                    haste = 1
                elseif param == 511 then
                    --add_to_chat(122, 'Haste Status: Haste II (Haste II)')
                    haste = 2
                end
                elseif param == 710 then
                    --add_to_chat(122, 'Haste Status: Haste II (Erratic Flutter)')
                    haste = 2
                end
            elseif act.category == 5 then
                if act.param == 5389 then
                    --add_to_chat(122, 'Haste Status: Haste II (Spy Drink)')
                    haste = 2
                end
            elseif act.category == 13 then
                local param = act.param
                if param == 595 and haste ~= 2 then
                    --add_to_chat(122, 'Haste Status: Haste I (Hastega)')
                    haste = 1
                elseif param == 602 then
                    --add_to_chat(122, 'Haste Status: Haste II (Hastega2)')
                    haste = 2
                end
            end
        end
    end)

function determine_haste_group()

    -- Assuming the following values:

    -- Haste - 15%
    -- Haste II - 30%
    -- Haste Samba - 5%
    -- Honor March - 15%
    -- Victory March - 25%
    -- Advancing March - 15%
    -- Embrava - 25%
    -- Mighty Guard (buffactive[604]) - 15%
    -- Geo-Haste (buffactive[580]) - 30%

    classes.CustomMeleeGroups:clear()

    if state.CombatForm.value == 'DW' then

        if (haste == 2 and (buffactive[580] or buffactive.march or buffactive.embrava or buffactive[604])) or
            (haste == 1 and (buffactive[580] or buffactive.march == 2 or (buffactive.embrava and buffactive['haste samba']) or (buffactive.march and buffactive[604]))) or
            (buffactive[580] and (buffactive.march or buffactive.embrava or buffactive[604])) or
            (buffactive.march == 2 and (buffactive.embrava or buffactive[604])) or
            (buffactive.march and (buffactive.embrava and buffactive['haste samba'])) then
            --add_to_chat(122, 'Magic Haste Level: 43%')
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif ((haste == 2 or buffactive[580] or buffactive.march == 2) and buffactive['haste samba']) or
            (haste == 1 and buffactive['haste samba'] and (buffactive.march or buffactive[604])) or
            (buffactive.march and buffactive['haste samba'] and buffactive[604]) then
            --add_to_chat(122, 'Magic Haste Level: 35%')
            classes.CustomMeleeGroups:append('HighHaste')
        elseif (haste == 2 or buffactive[580] or buffactive.march == 2 or (buffactive.embrava and buffactive['haste samba']) or
            (haste == 1 and (buffactive.march or buffactive[604])) or (buffactive.march and buffactive[604])) then
            --add_to_chat(122, 'Magic Haste Level: 30%')
            classes.CustomMeleeGroups:append('MidHaste')
        elseif (haste == 1 or buffactive.march or buffactive[604] or buffactive.embrava) then
            --add_to_chat(122, 'Magic Haste Level: 15%')
            classes.CustomMeleeGroups:append('LowHaste')
        end
    end
end

-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>

function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end

function update_offense_mode()
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 13)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
