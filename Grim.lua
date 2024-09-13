--- STEAMODDED HEADER
--- MOD_NAME: Grim
--- MOD_ID: GRM
--- PREFIX: grm
--- MOD_AUTHOR: [mathguy]
--- MOD_DESCRIPTION: Skill trees in Balatro!
--- VERSION: 0.9.4
----------------------------------------------
------------MOD CODE -------------------------

SMODS.current_mod.custom_collection_tabs = function()
	return { UIBox_button {
        count = G.ACTIVE_MOD_UI and modsCollectionTally(G.P_CENTER_POOLS['Skill']), --Returns nil outside of G.ACTIVE_MOD_UI but we don't use it anyways
        button = 'your_collection_skills', label = {"Skills"}, count = G.ACTIVE_MOD_UI and modsCollectionTally(G.P_CENTER_POOLS['Skill']), minw = 5, id = 'your_collection_skills'
    }}
end

SMODS.current_mod.set_debuff = function(card)
    if G.GAME.skills["sk_grm_motley_1"] and ((card.ability.name == 'Wild Card') or (G.GAME.skills["sk_grm_motley_3"] and (card.config.center ~= G.P_CENTERS.c_base))) then
        return 'prevent_debuff'
    end
end

function create_UIBox_Skills()
    local deck_tables = {}

    G.your_collection = {}
    for j = 1, 4 do
      G.your_collection[j] = CardArea(
        G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
        (5.25)*G.CARD_W,
        1*G.CARD_W, 
        {card_limit = 5, type = 'title', highlight_limit = 0, collection = true})
      table.insert(deck_tables, 
      {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
        {n=G.UIT.O, config={object = G.your_collection[j]}}
      }}
      )
    end

    local tarot_options = {}
    for i = 1, math.ceil(#G.P_CENTER_POOLS['Skill']/20) do
      table.insert(tarot_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#G.P_CENTER_POOLS['Skill']/20)))
    end
  
    for j = 1, #G.your_collection do
        for i = 1, 5 do
            local center = G.P_CENTER_POOLS['Skill'][i+(j-1)*(5)]
            if (i+(j-1)*(5)) <= #G.P_CENTER_POOLS['Skill'] then
                local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
                card:start_materialize(nil, i>1 or j>1)
                G.your_collection[j]:emplace(card)
            end
        end
    end
  
    INIT_COLLECTION_CARD_ALERTS()
    
    local t = create_UIBox_generic_options({ back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection', contents = {
              {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables},
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                      create_option_cycle({options = tarot_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collection_skill_page', focus_args = {snap_to = true, nav = 'wide'},current_option = 1, colour = G.C.RED, no_pips = true})
                    }}
            }})
    return t
end

G.FUNCS.your_collection_skills = function(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu{
	  definition = create_UIBox_Skills(),
	}
end

G.FUNCS.your_collection_skill_page = function(args)
    if not args or not args.cycle_config then return end
    for j = 1, #G.your_collection do
        for i = #G.your_collection[j].cards,1, -1 do
            local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
            c:remove()
            c = nil
        end
    end
    for i = 1, 5 do
        for j = 1, #G.your_collection do
            local center = G.P_CENTER_POOLS['Skill'][i+(j-1)*5 + (5*#G.your_collection*(args.cycle_config.current_option - 1))]
            if not center then break end
            local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
            G.your_collection[j]:emplace(card)
        end
    end
    INIT_COLLECTION_CARD_ALERTS()
end

function SMODS.SAVE_UNLOCKS()
    boot_print_stage("Saving Unlocks")
	G:save_progress()
    -------------------------------------
    local TESTHELPER_unlocks = false and not _RELEASE_MODE
    -------------------------------------
    if not love.filesystem.getInfo(G.SETTINGS.profile .. '') then
        love.filesystem.createDirectory(G.SETTINGS.profile ..
            '')
    end
    if not love.filesystem.getInfo(G.SETTINGS.profile .. '/' .. 'meta.jkr') then
        love.filesystem.append(
            G.SETTINGS.profile .. '/' .. 'meta.jkr', 'return {}')
    end

    convert_save_to_meta()

    local meta = STR_UNPACK(get_compressed(G.SETTINGS.profile .. '/' .. 'meta.jkr') or 'return {}')
    meta.unlocked = meta.unlocked or {}
    meta.discovered = meta.discovered or {}
    meta.alerted = meta.alerted or {}

    G.P_LOCKED = {}
    for k, v in pairs(G.P_CENTERS) do
        if not v.wip and not v.demo then
            if TESTHELPER_unlocks then
                v.unlocked = true; v.discovered = true; v.alerted = true
            end --REMOVE THIS
            if not v.unlocked and (string.find(k, '^j_') or string.find(k, '^b_') or string.find(k, '^v_')) and meta.unlocked[k] then
                v.unlocked = true
            end
            if not v.unlocked and (string.find(k, '^j_') or string.find(k, '^b_') or string.find(k, '^v_')) then
                G.P_LOCKED[#G.P_LOCKED + 1] = v
            end
            if not v.discovered and (string.find(k, '^j_') or string.find(k, '^b_') or string.find(k, '^e_') or string.find(k, '^c_') or string.find(k, '^p_') or string.find(k, '^v_')) and meta.discovered[k] then
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] or v.set == 'Back' or v.start_alerted then
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end

	table.sort(G.P_LOCKED, function (a, b) return a.order and b.order and a.order < b.order end)

	for k, v in pairs(G.P_BLINDS) do
        v.key = k
        if not v.wip and not v.demo then 
            if TESTHELPER_unlocks then v.discovered = true; v.alerted = true  end --REMOVE THIS
            if not v.discovered and meta.discovered[k] then 
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then 
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
	for k, v in pairs(G.P_TAGS) do
        v.key = k
        if not v.wip and not v.demo then 
            if TESTHELPER_unlocks then v.discovered = true; v.alerted = true  end --REMOVE THIS
            if not v.discovered and meta.discovered[k] then 
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then 
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
	for k, v in pairs(G.P_SKILLS) do
        v.key = k
        if not v.wip and not v.demo then 
            if TESTHELPER_unlocks then
                v.unlocked = true; v.discovered = true; v.alerted = true
            end --REMOVE THIS
            if not v.unlocked and meta.unlocked[k] then
                v.unlocked = true
            end
            if not v.discovered and meta.discovered[k] then
                v.discovered = true
            end
            if v.discovered then
                v.alerted = false
            end
        end
    end
    for k, v in pairs(G.P_SEALS) do
        v.key = k
        if not v.wip and not v.demo then
            if TESTHELPER_unlocks then
                v.discovered = true; v.alerted = true
            end                                                                   --REMOVE THIS
            if not v.discovered and meta.discovered[k] then
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        G.P_SEALS,
        G.P_SKILLS,
    } do
        for k, v in pairs(t) do
            v._discovered_unlocked_overwritten = true
        end
    end
end

local function get_skils()
    local shown_skills = {}
    for i, j in pairs(G.P_CENTER_POOLS['Skill']) do
        if j.prereq and j.unlocked then
            local valid = true
            for i2, j2 in pairs(j.prereq) do
                if not G.GAME.skills[j2] then
                    valid = false
                    break
                end
            end
            if valid then
                if G.GAME.skills[j] then
                    shown_skills[#shown_skills + 1] = {j, true}
                else
                    shown_skills[#shown_skills + 1] = {j, false}
                end
            end
        end
    end
    return shown_skills
end

function learn_skill(card)
    local obj = card.config.center
    local key = obj.key
    G.GAME.skills[key] = true
    G.GAME.skill_xp = G.GAME.skill_xp - obj.xp_req
    discover_card(obj)
    card:set_sprites(obj)
    if key == "sk_grm_ease_1" then
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 0.9
        if G.GAME.blind and G.GAME.blind.chips and G.GAME.blind.chip_text then
            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 0.9)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
    elseif key == "sk_grm_ease_2" then
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 8 / 9
        if G.GAME.blind and G.GAME.blind.chips and G.GAME.blind.chip_text then
            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 8 / 9)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
    elseif key == "sk_grm_hexahedron_1" then
        G.E_MANAGER:add_event(Event({func = function()
            G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - 1
            G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - 1)
        return true end }))
    elseif key == "sk_grm_ocean_1" then
        G.hand:change_size(1)
    elseif key == "sk_grm_stake_1" then
        G.GAME.win_ante = G.GAME.win_ante + 1
        G.hand:change_size(1)
    elseif key == "sk_grm_stake_2" then
        G.GAME.win_ante = G.GAME.win_ante + 2
        G.E_MANAGER:add_event(Event({func = function()
            if G.jokers then 
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        return true end }))
    elseif key == "sk_grm_stake_3" then
        local mult = 1.3 ^ G.GAME.round_resets.ante
        local new_scaling = 0.01 * math.max(1,math.floor(mult * 100))
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * new_scaling
        if G.GAME.blind and G.GAME.blind.chips and G.GAME.blind.chip_text then
            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * new_scaling)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
        G.E_MANAGER:add_event(Event({func = function()
            if G.jokers then 
                G.jokers.config.card_limit = G.jokers.config.card_limit + 3
            end
        return true end }))
    elseif key == "sk_grm_scarce_1" then
        G.GAME.banned_keys['p_buffoon_normal_1'] = true
        G.GAME.banned_keys['p_buffoon_normal_2'] = true
        G.GAME.banned_keys['p_buffoon_jumbo_1'] = true
        G.GAME.banned_keys['p_buffoon_mega_1'] = true
    elseif key == "sk_grm_ghost_1" then
        G.hand:change_size(-1)
    elseif key == "sk_grm_ghost_2" then
        G.hand:change_size(-2)
    elseif key == "sk_grm_chime_3" then
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
        ease_hands_played(-1)
    elseif key == "sk_grm_strike_3" then
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 1.2
        if G.GAME.blind and G.GAME.blind.chips and G.GAME.blind.chip_text then
            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.2)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
    end
end

G.FUNCS.can_learn = function(e)
    if e.config.ref_table and e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.key and (G.GAME.skills[e.config.ref_table.config.center.key] or (not e.config.ref_table.config.center.xp_req or (G.GAME.skill_xp < e.config.ref_table.config.center.xp_req))) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
    else
        e.config.colour = G.C.ORANGE
        e.config.button = 'learn_skill'
    end
end

G.FUNCS.learn_skill = function(e)
    learn_skill(e.config.ref_table)
    if G.OVERLAY_MENU then
        local tab_but = G.OVERLAY_MENU:get_UIE_by_ID("tab_but_" .. localize('b_skills'))
        use_page = true
        G.FUNCS.change_tab(tab_but)
        use_page = nil
    end
end

G.FUNCS.do_nothing = function(e)
end

function G.UIDEF.learned_skills()
    local shown_skills = get_skils()
    if not use_page then
        skills_page = nil
    end
    local adding = 15  * ((skills_page or 1) - 1)
    local rows = {}
    for i = 1, 3 do
        table.insert(rows, {})
        for j = 0, 4 do
            if shown_skills[j*5+i+adding] then
                table.insert(rows[i], shown_skills[j*5+i+adding][1])
            end
        end
    end
    G.areas = {}
    area_table = {}
    for j = 1, math.max(1,math.min(3, math.ceil(#shown_skills/5))) do
        G.areas[j] = CardArea(
            G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
            (5.25)*G.CARD_W,
            1*G.CARD_W, 
            {card_limit = 5, type = 'joker', highlight_limit = 1, skill_table = true})
        table.insert(area_table, 
        {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
            {n=G.UIT.O, config={object = G.areas[j]}}
        }}
        )
    end

    local skill_options = {}
    for i = 1, math.ceil(math.max(1, math.ceil(#shown_skills/15))) do
        table.insert(skill_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(math.max(1, math.ceil(#shown_skills/15)))))
    end

    for j = 1, #G.areas do
        for i = 1, 5 do
            if (i+(j-1)*(5)+adding) <= #shown_skills then
                local center = shown_skills[i+(j-1)*(5)+adding][1]
                local card = Card(G.areas[j].T.x + G.areas[j].T.w/2, G.areas[j].T.y, G.CARD_W, G.CARD_H, nil, center)
                card:start_materialize(nil, i>1 or j>1)
                G.areas[j]:emplace(card)
            end
        end
    end

    local text = localize{type = 'variable', key = 'skill_xp', vars = {number_format(G.GAME.skill_xp)}, nodes = text}

    local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes = {
        {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = text, colours = {G.C.UI.TEXT_LIGHT}, bump = true, scale = 0.6})}}
        }},
        {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=area_table},
            {n=G.UIT.R, config={align = "cm"}, nodes={
                create_option_cycle({options = skill_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_game_skill_page', focus_args = {snap_to = true, nav = 'wide'},current_option = (skills_page or 1), colour = G.C.ORANGE, no_pips = true})
        }}
      }}
    return t
end

function calculate_skill(skill, context)
    if context.end_of_round then
        if skill == "sk_grm_ease_3" and context.game_over then
            if G.GAME.chips >= (G.GAME.blind.chips * 0.85) then
                return true
            end
        end
    elseif context.ante_mod then
        if skill == "sk_grm_chime_1" and ((context.current_ante) % 8 == 0) and not G.GAME.reset_antes[context.current_ante] then
            G.GAME.reset_antes[context.current_ante] = true
            ease_ante(-1, true)
            if G.GAME.skills["sk_grm_stake_3"] then
                G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 0.78
            end
        elseif skill == "sk_grm_chime_2" and ((context.current_ante) % 4 == 0) and not G.GAME.reset_antes2[context.current_ante] then
            G.GAME.reset_antes2[context.current_ante] = true
            ease_ante(-1, true)
            if G.GAME.skills["sk_grm_stake_3"] then
                G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 0.78
            end
        elseif skill == "sk_grm_chime_3" and ((context.current_ante) % 3 == 0) and not G.GAME.reset_antes3[context.current_ante] then
            G.GAME.reset_antes3[context.current_ante] = true
            ease_ante(-1, true)
            if G.GAME.skills["sk_grm_stake_3"] then
                G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 0.78
            end
        elseif skill == "sk_grm_stake_3" then
            local mult = 1.3 ^ (context.current_ante - context.old_ante)
            local new_scaling = 0.01 * math.max(1,math.floor(mult * 100))
            G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * new_scaling
        end
    elseif context.using_consumeable then
        if skill == "sk_grm_mystical_3" and (context.card.ability.set == 'Tarot') and not (context.card.ability.name == 'The Fool') and (pseudorandom("mystical") < 0.3) then
            local fool = SMODS.create_card {key = "c_fool", no_edition = true}
            fool:set_edition('e_negative')
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end
    elseif context.modify_base then
        if skill == "sk_grm_strike_1" then
            return context.chips, (context.mult + 2), true
        elseif skill == "sk_grm_strike_2" then
            return (context.chips + 50), context.mult, true
        elseif skill == "sk_grm_gravity_2" then
            local _handname, _played, _order = 'High Card', -1, 100
            for k, v in pairs(G.GAME.hands) do
                if v.played > _played or (v.played == _played and _order > v.order) then 
                    _played = v.played
                    _handname = k
                end
            end
            if context.scoring_name == _handname then
                return context.chips, (context.mult * 2), true
            else
                return context.chips, context.mult, false
            end
        elseif skill == "sk_grm_strike_3" then
            local balance = math.floor((context.chips + context.mult) / 2)
            return balance, balance, true
        else
            return context.chips, context.mult, false
        end
    elseif context.reroll_shop then
        if skill == "sk_grm_hexahedron_2" then
            ease_dollars(1)
        end
    elseif context.pre_discard then
        if skill == "sk_grm_ocean_2" and (G.GAME.current_round.discards_left == 1) then
            ease_hands_played(1)
        end
    elseif context.before then
        if skill == "sk_grm_skillful_2" then
            local level = G.GAME.hands[context.scoring_name].level
            if level > 0 then
                add_skill_xp(math.min(40, level), G.deck)
            end
        elseif skill == "sk_grm_ocean_3" and (G.GAME.current_round.hands_played == 0) then
            ease_discard(2)
        end
    elseif context.ending_shop then
        if skill == "sk_grm_ghost_2" then
            add_tag(Tag("tag_ethereal"))
        end
    end
end

function add_skill_xp(amount, card, message_, no_mod)
    local message = true
    if message_ ~= nil then
        message = message_
    end
    if not no_mod then
        amount = get_modded_xp(amount)
    end
    G.GAME.skill_xp = G.GAME.skill_xp + amount
    if G.GAME.skills["sk_grm_ghost_1"] then
        G.GAME.ghost_skill_xp = G.GAME.ghost_skill_xp + amount
        if G.GAME.ghost_skill_xp > 200 then
            local spectrals = math.floor(G.GAME.ghost_skill_xp / 200)
            G.GAME.ghost_skill_xp = G.GAME.ghost_skill_xp - (200 * spectrals)
            spectrals = math.min(spectrals, G.consumeables.config.card_limit - #G.consumeables.cards)
            if spectrals > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            spectrals = math.min(spectrals, G.consumeables.config.card_limit - #G.consumeables.cards)
                            if spectrals > 0 then
                                for i = 1, spectrals do
                                    local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'ghost')
                                    card:add_to_deck()
                                    G.consumeables:emplace(card)
                                end
                            end
                            return true
                    end)}))
            end
        end
    end
    if card and message and (amount ~= 0) then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='gain_xp',vars={amount}},colour = G.C.PURPLE, delay = 0.45})
    end
end

function get_modded_xp(amount)
    local new_amount = amount
    if G.GAME.skills["sk_grm_skillful_3"] and (new_amount > 0) then
        new_amount = new_amount * 2
    end
    if G.GAME.skills["sk_grm_ghost_3"] and (new_amount > 0) then
        new_amount = math.max(1 , math.floor(new_amount * 0.5))
    end
    return new_amount
end

function skill_unlock_check(card, args)
    if card.key == "sk_grm_hexahedron_3" then
        if G.GAME and G.GAME.grm_unlocks and G.GAME.grm_unlocks.shop_rerolls and (G.GAME.grm_unlocks.shop_rerolls >= 15) then
            return true
        end
    elseif card.key == "sk_grm_ocean_3" then
        if G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left and (G.GAME.current_round.discards_left >= 10) then
            return true
        end
    elseif card.key == "sk_grm_strike_3" then
        if (args.type == 'upgrade_hand') and (args.level >= 40) then
            return true
        end
    elseif card.key == "sk_grm_chime_3" then
        if (args.type == 'ante_up') and (args.ante >= 17) then
            return true
        end
    elseif card.key == "sk_grm_fortunate_2" then
        if args.fortune_check then
            return true
        end
    end
end

G.FUNCS.your_game_skill_page = function(args)
    local shown_skills = get_skils()
    if not args or not args.cycle_config then return end
    skills_page = args.cycle_config.current_option
    for j = 1, #G.areas do
        for i = #G.areas[j].cards,1, -1 do
            local c = G.areas[j]:remove_card(G.areas[j].cards[i])
            c:remove()
            c = nil
        end
    end
    for i = 1, 5 do
        for j = 1, 3 do
            local adding = 3  * (args.cycle_config.current_option - 1)
            local center = shown_skills[i+(j-1)*5 + 5 * adding]
            if not center then break end
            local card = Card(G.areas[j].T.x + G.areas[j].T.w/2, G.areas[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center[1])
            G.areas[j]:emplace(card)
        end
    end
end

SMODS.Atlas({ key = "skills", atlas_table = "ASSET_ATLAS", path = "skills.png", px = 71, py = 95})

SMODS.Atlas({ key = "skills2", atlas_table = "ASSET_ATLAS", path = "skills2.png", px = 71, py = 95})

SMODS.Atlas({ key = "enhance", atlas_table = "ASSET_ATLAS", path = "enhance.png", px = 71, py = 95})

SMODS.Atlas({ key = "tarots", atlas_table = "ASSET_ATLAS", path = "tarots.png", px = 71, py = 95})

SMODS.Atlas({ key = "jokers", atlas_table = "ASSET_ATLAS", path = "joker.png", px = 71, py = 95})

SMODS.Atlas({ key = "vouchers", atlas_table = "ASSET_ATLAS", path = "vouchers.png", px = 71, py = 95})

SMODS.Atlas({ key = "stakes", atlas_table = "ASSET_ATLAS", path = "stakes.png", px = 29, py = 29})

SMODS.Atlas({ key = "stickers", atlas_table = "ASSET_ATLAS", path = "stickers.png", px = 71, py = 95})

SMODS.Atlas({key = "modicon", path = "grm_icon.png", px = 34, py = 34}):register()

SMODS.Shader {
    key = 'dimmed',
    path = 'dimmed.fs'
}

SMODS.Tarot {
    key = 'craft',
    loc_txt = {
        name = "The Craft",
        text = {
            "Enhances {C:attention}#1#",
            "selected cards to",
            "{C:attention}#2#s"
        }
    },
    atlas = "tarots",
    pos = {x = 0, y = 0},
    config = {mod_conv = 'm_grm_rpg', max_highlighted = 3},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_rpg']
        return {vars = {(card and card.ability.max_highlighted or 3), localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_rpg')}}}
    end,
}

SMODS.Joker {
    key = 'energy_bar',
    name = "Energy Bar",
    loc_txt = {
        name = "Energy Bar",
        text = {
            "{C:purple}+#1#{} XP at end of",
            "{C:attention}round{}, loses {C:purple}#2#{} XP",
            "per hand played"
        }
    },
    rarity = 2,
    atlas = 'jokers',
    pos = {x = 0, y = 0},
    cost = 6,
    blueprint_compat = true,
    config = {extra = {xp = 30, xp_mod = 1}},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xp ,card.ability.extra.xp_mod}}
    end,
    calculate = function(self, card, context)
        if (context.cardarea == G.jokers) and context.after and not context.blueprint then
            if card.ability.extra.xp - card.ability.extra.xp_mod <= 0 then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.GREEN
                }
            else
                card.ability.extra.xp = card.ability.extra.xp - card.ability.extra.xp_mod
                return {
                    message = localize{type='variable',key='minus_xp',vars={card.ability.extra.xp_mod}},
                    colour = G.C.PURPLE
                }
            end
        end
    end,
    calc_xp_bonus = function(self, card)
        return card.ability.extra.xp
    end
}

SMODS.Enhancement {
    key = 'rpg',
    loc_txt = {
        name = 'RPG Card',
        text = {
            "{C:purple}+#1#{} XP",
        }
    },
    atlas = 'enhance',
    config = {xp = 5},
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.xp or 5}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.xp = self.config.xp
    end
}

SMODS.Voucher {
    key = 'progress',
    loc_txt = {
        name = "Progression",
        text = {
            "{C:purple}+#1#{} XP for every {C:purple}#2#{} XP you",
            "have at end of round",
            "{C:inactive}(Max of {C:purple}#3#{C:inactive} XP)"
        }
    },
    config = {extra = {xp = 1, interest = 12}, max = 30},
    atlas = 'vouchers',
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, card)
        if not card or not card.ability then
            return {1, 12, 30}
        end
        return {vars = {card.ability.extra.xp, card.ability.extra.interest, card.ability.max}}
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({func = function()
            G.GAME.xp_interest = card.ability.extra.xp
            G.GAME.xp_interest_rate = card.ability.extra.interest
            G.GAME.xp_interest_max = card.ability.max
        return true end }))
    end
}

SMODS.Voucher {
    key = 'complete',
    loc_txt = {
        name = "Completion",
        text = {
            "Raise the cap on",
            "{C:purple}XP{} interest earned in",
            "each round to {C:purple}#1#{}"
        }
    },
    config = {max = 75},
    atlas = 'vouchers',
    pos = {x = 1, y = 0},
    loc_vars = function(self, info_queue, card)
        if not card or not card.ability then
            return {75}
        end
        return {vars = {card.ability.max}}
    end,
    requires = {'v_grm_progress'},
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({func = function()
            G.GAME.xp_interest_max = card.ability.max
        return true end }))
    end
}

SMODS.Stake {
    key = 'turbo',
    name = "Turbo Stake",
    atlas = "stakes",
    pos = {x = 0, y = 0},
    applied_stakes = {},
	loc_txt = {
        name = "Turbo Stake",
        text = {
            "After defeating each",
            "{C:attention}Boss Blind{}, {C:purple}+150{} XP"
        },
        sticker = {
            name = "Turbo Sticker",
            text = {
                "Used this Joker",
                "to win on {C:attention}Turbo",
                "{C:attention}Stake{} difficulty"
            }
        }
    },
    modifiers = function()
        G.GAME.modifiers.force_stake_xp = 150
    end,
    colour = HEX("9260B9"),
    sticker_pos = {x = 0, y = 0},
    sticker_atlas = "stickers"
}

function Card:get_chip_xp(context)
    if self.debuff then return 0 end
    if self.ability.set == 'Joker' then return 0 end
    return self.ability.xp or 0
end

function Card:calculate_xp_bonus()
    if self.debuff then return end
    if self.ability.set == "Joker" then
        local obj = self.config.center
        if obj.calc_xp_bonus and type(obj.calc_xp_bonus) == 'function' then
            return obj:calc_xp_bonus(self)
        end
    end
end

local unknown = SMODS.UndiscoveredSprite {
    key = 'Skill',
    atlas = 'skills',
    pos = {x = 0, y = 0}
}

function SMODS.current_mod.process_loc_text()
    G.localization.misc.dictionary["b_learn"] = "LEARN"
    G.localization.descriptions.Skill = {
        sk_grm_chime_1 = {
            name = "Chime I",
            text = {
                "{C:attention}-1{} Ante every {C:attention}8th{}",
                "Ante",
                "{C:inactive}(once per ante){}"
            }
        },
        sk_grm_chime_2 = {
            name = "Chime II",
            text = {
                "{C:attention}-1{} Ante every {C:attention}4th{}",
                "Ante",
                "{C:inactive}(once per ante){}"
            }
        },
        sk_grm_chime_3 = {
            name = "Chime III",
            text = {
                "{C:attention}-1{} Ante every {C:attention}3rd{}",
                "Ante",
                "{C:blue}-1{} hand",
                "{C:inactive}(once per ante){}"
            },
            unlock = {
                "Reach Ante",
                "level {E:1,C:attention}17"
            }
        },
        sk_grm_ease_1 = {
            name = "Ease I",
            text = {
                "{C:blue}x0.9{} Blind Size",
            }
        },
        sk_grm_ease_2 = {
            name = "Ease II",
            text = {
                "{C:blue}x0.8{} Blind Size",
            }
        },
        sk_grm_mystical_1 = {
            name = "Mystical I",
            text = {
                "All {C:tarot}Arcana Packs{} have {C:attention}+1{}",
                "option and choice"
            }
        },
        sk_grm_mystical_2 = {
            name = "Mystical II",
            text = {
                "All {C:tarot}Arcana Packs{} and {C:tarot}Tarot{}",
                "cards are free."
            }
        },
        sk_grm_mystical_3 = {
            name = "Mystical III",
            text = {
                "{C:green}30%{} chance to create a",
                "{C:dark_edition}Negative{} {C:tarot}The Fool{} when",
                "a {C:tarot}Tarot{} is used",
                "{C:inactive}({C:tarot}The Fool{C:inactive} excluded)"
            }
        },
        sk_grm_hexahedron_1 = {
            name = "Hexahedron I",
            text = {
                "Rerolls cost",
                "{C:money}$1{} less"
            }
        },
        sk_grm_ocean_1 = {
            name = "Ocean I",
            text = {
                "{C:attention}+1{} hand size",
            }
        },
        sk_grm_strike_1 = {
            name = "Strike I",
            text = {
                "{C:red}+2{} base mult",
            }
        },
        sk_grm_strike_2 = {
            name = "Strike II",
            text = {
                "{C:blue}+50{} base chips",
            }
        },
        sk_grm_strike_3 = {
            name = "Strike III",
            text = {
                "Balance base {C:blue}Chips{} and",
                "base {C:red}Mult{}",
                "{C:red}X1.2{} Blind Size",
            },
            unlock = {
                "Level a {C:attention}poker hand{} to",
                "level {C:attention}40{} or more"
            }
        },
        sk_grm_hexahedron_2 = {
            name = "Hexahedron II",
            text = {
                "Earn {C:money}$1{} per {C:attention}reroll{}",
                "in the shop",
            }
        },
        sk_grm_hexahedron_3 = {
            name = "Hexahedron III",
            text = {
                "+{C:attention}1{} free {C:green}reroll",
                "in the shop per {C:money}$11{} spent",
                "on {C:green}reroll"
            },
            unlock = {
                "{C:green}Reroll{} {C:attention}15{} or more",
                "times in the {C:attention}shop{}"
            }
        },
        sk_grm_ocean_2 = {
            name = "Ocean II",
            text = {
                "{C:blue}+1{} hand on",
                "{C:attention}final discard{}"
            }
        },
        sk_grm_ocean_3 = {
            name = "Ocean III",
            text = {
                "{C:red}+2{} discards on",
                "{C:attention}first hand{}"
            },
            unlock = {
                "Have {C:red}10{} or more",
                "discards"
            }
        },
        sk_grm_stake_1 = {
            name = "Stake I",
            text = {
                "{C:attention}+1{} win ante",
                "{C:attention}+1{} hand size"
            }
        },
        sk_grm_stake_2 = {
            name = "Stake II",
            text = {
                "{C:attention}+2{} win ante",
                "{C:attention}+1{} joker slot"
            }
        },
        sk_grm_skillful_1 = {
            name = "Skillful I",
            text = {
                "{C:purple}+30{} XP at",
                "end of {C:attention}round{}"
            }
        },
        sk_grm_skillful_2 = {
            name = "Skillful II",
            text = {
                "Adds the number of levels",
                "on played {C:attention}poker hand{} ",
                "to XP, on {C:attention}play{}",
                "{C:inactive}(max of {C:purple}40{C:inactive}){}",
            }
        },
        sk_grm_skillful_3 = {
            name = "Skillful III",
            text = {
                "{X:purple,C:white} X2 {} to all",
                "XP sources",
            }
        },
        sk_grm_stake_3 = {
            name = "Stake III",
            text = {
                "{C:blue}x1.3{} Blind Size for ",
                "each {C:attention}Ante{}.",
                "{C:attention}+3{} joker slots",
                "{C:inactive}(Currently {C:blue}#1#{C:inactive}){}",
            }
        },
        sk_grm_ease_3 = {
            name = "Ease III",
            text = {
                "Prevents Death",
                "if chips scored",
                "are at least {C:attention}85%",
                "of required chips",
            }
        },
        sk_grm_motley_1 = {
            name = "Motley I",
            text = {
                "{C:attention}Wild Cards{} cannot",
                "be {C:attention}debuffed{}"
            }
        },
        sk_grm_fortunate_1 = {
            name = "Fortunate I",
            text = {
                "{C:attention}The Wheel of Fortune{}",
                "can create the {C:dark_edition}Negative{}",
                "edition"
            }
        },
        sk_grm_fortunate_2 = {
            name = "Fortunate II",
            text = {
                "{C:attention}The Wheel of Fortune{}",
                "can't create the {C:dark_edition}Foil{}",
                "edition"
            },
            unlock = {
                "Add the {C:dark_edition}Negative{} edition",
                "to a {C:attention}joker{} using",
                "{C:attention}The Wheel of Fortune{}",
            }
        },
        sk_grm_motley_2 = {
            name = "Motley II",
            text = {
                "{C:tarot}Arcana Packs{} have",
                "2 {C:tarot}The Lovers{}"
            }
        },
        sk_grm_motley_3 = {
            name = "Motley III",
            text = {
                "{C:attention}Enhanced Cards{} are",
                "considered {C:attention}Wild Cards{}",
                "All {C:tarot}Arcana Packs{} have",
                "{C:attention}-1{} option",
            }
        },
        sk_grm_scarce_1 = {
            name = "Scarce I",
            text = {
                "{C:attention}Jokers{} and {C:attention}Buffoon Packs{}",
                "do not appear in {C:attention}shop{}"
            }
        },
        sk_grm_gravity_1 = {
            name = "Gravity I",
            text = {
                "All {C:planet}Celestial Packs{} have",
                "{C:attention}+2{} options",
            }
        },
        sk_grm_gravity_2 = {
            name = "Gravity II",
            text = {
                "{X:red,C:white} X2 {} base mult when",
                "playing your {C:attention}most played{}",
                "{C:attention}poker hand{}"
            }
        },
        sk_grm_gravity_3 = {
            name = "Gravity III",
            text = {
                "{C:attention}Retrigger{} used",
                "{C:planet}Planet{} cards"
            }
        },
        sk_grm_ghost_1 = {
            name = "Ghost I",
            text = {
                "Create a {C:spectral}Spectral{} card",
                "every {C:purple}200{} gained XP",
                "{C:red}-1{} hand size",
                "{C:inactive}(Must have room)"
            }
        },
        sk_grm_ghost_2 = {
            name = "Ghost II",
            text = {
                "Gain an {C:attention}Ethereal Tag",
                "at the end of each {C:attention}shop",
                "{C:red}-2{} hand size"
            }
        },
        sk_grm_ghost_3 = {
            name = "Ghost III",
            text = {
                "All {C:spectral}Spectral Packs{} have",
                "{C:attention}+4{} options and {C:attention}+2{} choices",
                "{X:purple,C:white} X0.5 {} to all XP sources",
            }
        },
    }
    G.localization.descriptions.Other["undiscovered_skill"] = {
        name = "Not Discovered",
        text = {
            "Learn this skill",
            "in an unseeded",
            "run to learn",
            "what it does"
        }
    }
    G.localization.descriptions.Other["unlearned_skill"] = {
        text = {
            "XP Needed:",
            "{C:purple}#1#{} XP",
        }
    }
    G.localization.misc.v_dictionary["skill_xp"] = "XP: #1#"
    G.localization.misc.v_dictionary["gain_xp"] = "+#1# XP"
    G.localization.misc.v_dictionary["minus_xp"] = "-#1# XP"
    G.localization.misc.dictionary['k_skill'] = "Skill"
    G.localization.misc.labels['skill'] = "Skill"
    G.localization.misc.dictionary['b_skills'] = "Skills"
    G.localization.misc.v_dictionary["xp_interest"] = "#1# interest per #2# XP (#3# max)"
end

function add_custom_round_eval_row(name, foot, intrest)
    local width = G.round_eval.T.w - 0.51
    local scale = 0.9
    total_cashout_rows = (total_cashout_rows or 0) + 1
    delay(0.4)

    G.E_MANAGER:add_event(Event({
        trigger = 'before',delay = 0.5,
        func = function()
            --Add the far left text and context first:
            local left_text = {}
            if intrest then
                table.insert(left_text, {n=G.UIT.T, config={text = intrest, scale = 0.8*scale, colour = G.C.PURPLE, shadow = true, juice = true}})
            end
            if intrest then
                table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = name, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})
            else
                table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = name, colours = {G.C.PURPLE}, shadow = true, pop_in = 0, scale = 0.6*scale, silent = true})}})
            end
            local full_row = {n=G.UIT.R, config={align = "cm", minw = 5}, nodes={
                {n=G.UIT.C, config={padding = 0.05, minw = width*0.55, minh = 0.61, align = "cl"}, nodes=left_text},
                {n=G.UIT.C, config={padding = 0.05,minw = width*0.45, align = "cr"}, nodes={{n=G.UIT.C, config={align = "cm", id = 'dollar_grm_'..name .. tostring(total_cashout_rows)},nodes={}}}}
            }}
            G.round_eval:add_child(full_row,G.round_eval:get_UIE_by_ID('bonus_round_eval'))
            play_sound('cancel', 1)
            play_sound('highlight1', 1, 0.2)
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'before',delay = 0.38,
        func = function()
                G.round_eval:add_child(
                        {n=G.UIT.R, config={align = "cm", id = 'dollar_row_grm_'..name .. tostring(total_cashout_rows)}, nodes={
                            {n=G.UIT.O, config={object = DynaText({string = {foot}, colours = {G.C.PURPLE}, shadow = true, pop_in = 0, scale = 0.65, float = true})}}
                        }},
                        G.round_eval:get_UIE_by_ID('dollar_grm_'..name .. tostring(total_cashout_rows)))
            play_sound('coin3', 0.9+0.2*math.random(), 0.7)
            play_sound('coin6', 1.3, 0.8)
            return true
        end
    }))
end

----------------------------------------------
------------MOD CODE END----------------------