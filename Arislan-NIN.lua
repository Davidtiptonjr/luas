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
	state.Buff.Migawari = buffactive.migawari or false
	state.Buff.Doom = buffactive.doom or false
	state.Buff.Yonin = buffactive.Yonin or false
	state.Buff.Innin = buffactive.Innin or false
	state.Buff.Futae = buffactive.Futae or false

	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'Fodder')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'PDT', 'MDT')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')

	-- Additional local binds
	send_command('bind ^- input /ja "Yonin" <me>')
	send_command('bind ^= input /ja "Innin" <me>')
	send_command('bind ^, input /nin "Monomi: Ichi" <me>')
	send_command('bind ^. input /ma "Tonko: Ni" <me>')

--	select_movement_feet()
	select_default_macro_book()
end

function user_unload()
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind ^,')
	send_command('unbind !.')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
--	sets.precast.JA['Mijin Gakure'] = {legs="Mochizuki Hakama"}
--	sets.precast.JA['Futae'] = {legs="Iga Tekko +2"}
--	sets.precast.JA['Sange'] = {legs="Mochizuki Chainmail"}

	sets.precast.Waltz = {
		hands="Slither Gloves +1",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		} -- CHR and VIT
		
	sets.precast.Waltz['Healing Waltz'] = {}

	-- Fast cast sets for spells
	
	sets.precast.FC = {
		ammo="Sapience Orb", --2
		head=gear.Herc_FC_head, --12
		body="Samnuha Coat", --5
		hands="Leyline Gloves", --7
		feet=gear.Herc_MAB_feet, --2
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Etiolation Earring", --1
		ring1="Prolix Ring", --2
		ring2="Weather. Ring", --5(3)
		waist="Ninurta's Sash",
		}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		waist="Ninurta's Sash",
		})

	sets.precast.RA = {
		head="Aurore Beret +1", --5
		legs="Adhemar Kecks", --9
		}
	   
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {
		ammo="Seething Bomblet",
		head="Lilitu Headpiece",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Hiza. Hizayoroi +1",
		feet=gear.Herc_TA_feet,
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ifrit Ring +1",
		ring2="Shukuyu Ring",
		back="Ground. Mantle +1",
		waist=gear.ElementalBelt,
		} -- default set

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		head="Adhemar Bonnet",
		legs="Adhemar Kecks",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		})

	sets.precast.WS['Blade: Shun'] = set_combine (sets.precast.WS, {
		legs="Samnuha Tights",
		ear1="Lugra Earring",
		ear2="Lugra Earring +1",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		})

	sets.precast.WS['Blade: Kamu'] = set_combine (sets.precast.WS, {
		ear1="Lugra Earring",
		ear2="Lugra Earring +1",
		ring1="Ifrit Ring +1",
		ring2="Shukuyu Ring",
		})

	--------------------------------------
	-- Midcast sets
	--------------------------------------

	sets.midcast.FastRecast = {
		ear1="Loquacious Earring",
		ear2="Etiolation Earring",
		}

	-- Specific spells
	sets.midcast.Utsusemi = {
		ear2="Loquacious Earring",
		waist="Ninurta's Sash",
		}

	sets.midcast.ElementalNinjutsu = {
		ammo="Grenade Core",
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Leyline Gloves",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,
		neck="Sanctity Necklace",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back=gear.COR_WS_Cape,
		waist="Eschan Stone",
		}

--	sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.Ninjutsu, {})

--	sets.midcast.NinjutsuDebuff = {}

--	sets.midcast.NinjutsuBuff = {}

--	sets.midcast.RA = {}

	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------
	
	-- Resting sets
--	sets.resting = {}
	
	-- Idle sets
	sets.idle = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Hiza. Haramaki +1",
		hands=gear.Herc_TA_hands,
		legs="Samnuha Tights",
		feet="Danzo Sune-ate",
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Flume Belt",
		}

	sets.idle.PDT = set_combine (sets.idle, {
		hands=gear.Herc_TA_hands,
		neck="Loricate Torque +1", 
		ear1="Genmei Earring",
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1", --7
		back="Solemnity Cape",
		waist="Flume Belt",
		})

	sets.idle.MDT = set_combine (sets.idle, {
		head="Dampening Tam",
		neck="Loricate Torque +1",
		ear2="Etiolation Earring",
		ring1="Defending Ring", 
		back="Solemnity Cape",
		})

	sets.idle.Town = set_combine(sets.idle, {
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		waist="Windbuffet Belt +1",
		})
	
	sets.idle.Weak = sets.idle.PDT
	
	-- Defense sets
	sets.defense.PDT = {
		hands=gear.Herc_TA_hands, --2
		neck="Loricate Torque +1", --6
		ear1="Genmei Earring", --2
		ring1="Defending Ring", --10
		ring2="Gelatinous Ring +1", --7
		back="Solemnity Cape", --4
		waist="Flume Belt", --4
		}

	sets.defense.MDT = {
		head="Dampening Tam", --4
		neck="Loricate Torque +1", --6
		ear2="Etiolation Earring", --3
		ring1="Defending Ring", --10
		back="Solemnity Cape", --4
		}

	sets.Kiting = {feet="Danzo sune-ate"}
	
--	sets.DayMovement = {feet="Danzo sune-ate"}
--	sets.NightMovement = {feet="Ninja Kyahan"}


	--------------------------------------
	-- Engaged sets
	--------------------------------------

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	sets.engaged = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet,
		neck="Erudit. Necklace",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Bleating Mantle",
		waist="Patentia Sash",
		}

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		ammo="Falcon Eye",
		hands=gear.Herc_TA_hands,
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		legs=gear.Herc_TA_legs,
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		legs="Hiza. Hizayoroi +1",
		neck="Combatant's Torque",
		ear1="Digni. Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.Fodder = set_combine(sets.engaged, {
		body="Thaumas Coat",
		})

	sets.engaged.HighHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Erudit. Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Bleating Mantle",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste, {
		ammo="Falcon Eye",
		hands=gear.Herc_TA_hands,
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc, {
		legs=gear.Herc_TA_legs,
		ear2="Zennaroi Earring",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

		sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc, {
		legs="Hiza. Hizayoroi +1",
		neck="Combatant's Torque",
		ear1="Digni. Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.HighHaste.Fodder = set_combine(sets.engaged.HighHaste, {
		body="Thaumas Coat",
		})

	sets.engaged.MaxHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Erudit. Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Bleating Mantle",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.MaxHaste, {
		ammo="Falcon Eye",
		hands=gear.Herc_TA_hands,
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc, {
		legs=gear.Herc_TA_legs,
		ear2="Zennaroi Earring",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc, {
		legs="Hiza. Hizayoroi +1",
		neck="Combatant's Torque",
		ear1="Digni. Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.MaxHaste.Fodder = set_combine(sets.engaged.MaxHaste, {
		body="Thaumas Coat",
		})

	--------------------------------------
	-- Custom buff sets
	--------------------------------------

--	sets.buff.Migawari = {body="Iga Ningi +2"}
--	sets.buff.Doom = {ring2="Saida Ring"}
--	sets.buff.Yonin = {}
--	sets.buff.Innin = {}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if state.Buff.Doom then
		equip(sets.buff.Doom)
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if not spell.interrupted and spell.english == "Migawari: Ichi" then
		state.Buff.Migawari = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
		determine_haste_group()
		handle_equipping_gear(player.status)
	elseif state.Buff[buff] ~= nil then
		handle_equipping_gear(player.status)
	end
end

--function job_status_change(new_status, old_status)
--	if new_status == 'Idle' then
--		select_movement_feet()
--	end
--end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Get custom spell maps
function job_get_spell_map(spell, default_spell_map)
	if spell.skill == "Ninjutsu" then
		if not default_spell_map then
			if spell.target.type == 'SELF' then
				return 'NinjutsuBuff'
			else
				return 'NinjutsuDebuff'
			end
		end
	end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Buff.Migawari then
        idleSet = set_combine(idleSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
--    idleSet = set_combine(idleSet, select_movement_feet())
    return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if state.Buff.Migawari then
		meleeSet = set_combine(meleeSet, sets.buff.Migawari)
	end
	if state.Buff.Doom then
		meleeSet = set_combine(meleeSet, sets.buff.Doom)
	end
	return meleeSet
end

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
--	select_movement_feet()
	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
	-- We have three groups of DW in gear: Hachiya body/legs, Iga head + Patentia Sash, and DW earrings
	
	-- Standard gear set reaches near capped delay with just Haste (77%-78%, depending on HQs)

	-- For high haste, we want to be able to drop one of the 10% groups.
	-- Basic gear hits capped delay (roughly) with:
	-- 1 March + Haste
	-- 2 March
	-- Haste + Haste Samba
	-- 1 March + Haste Samba
	-- Embrava
	
	-- High haste buffs:
	-- 2x Marches + Haste Samba == 19% DW in gear
	-- 1x March + Haste + Haste Samba == 22% DW in gear
	-- Embrava + Haste or 1x March == 7% DW in gear
	
	-- For max haste (capped magic haste + 25% gear haste), we can drop all DW gear.
	-- Max haste buffs:
	-- Embrava + Haste+March or 2x March
	-- 2x Marches + Haste
	
	-- So we want four tiers:
	-- Normal DW
	-- 20% DW -- High Haste
	-- 7% DW (earrings) - Embrava Haste (specialized situation with embrava and haste, but no marches)
	-- 0 DW - Max Haste
	
	classes.CustomMeleeGroups:clear()
	
	if buffactive.embrava and (buffactive.march == 2 or (buffactive.march and buffactive.haste)) then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.embrava and (buffactive.haste or buffactive.march) then
		classes.CustomMeleeGroups:append('EmbravaHaste')
	elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 2 then
		classes.CustomMeleeGroups:append('HighHaste')
	end
end


--function select_movement_feet()
--    if world.time >= (17*60) or world.time <= (7*60) then
--        return sets.NightMovement
--    else
--        return sets.DayMovement
 --   end
--end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(2, 11)
	elseif player.sub_job == 'THF' then
		set_macro_page(3, 11)
	else
		set_macro_page(1, 11)
	end
end