--- STEAMODDED HEADER
--- MOD_NAME: Grim
--- MOD_ID: GRM
--- PREFIX: grm
--- MOD_AUTHOR: [mathguy]
--- MOD_DESCRIPTION: Skill trees in Balatro!
--- VERSION: 0.9.8
----------------------------------------------
------------MOD CODE -------------------------

local areaType = SMODS.ConsumableType {
    key = 'Area',
    primary_colour = G.C.GREEN,
    secondary_colour = G.C.GREEN,
    loc_txt = {
        name = 'Area',
        collection = 'Area Cards',
        undiscovered = {
            name = "Not Discovered",
            text = {
                "use this card",
                "in an unseeded",
                "run to learn",
                "what it does"
            }
        }
    },
    collection_rows = { 4, 4 },
    shop_rate = 0,
    default = "c_grm_classic"
}

local lunarType = SMODS.ConsumableType {
    key = 'Lunar',
    primary_colour = HEX('505A8D'),
    secondary_colour = HEX('7F82C4'),
    loc_txt = {
        name = 'Lunar',
        collection = 'Lunar Cards',
        undiscovered = {
            name = "Not Discovered",
            text = {
                "Purchase or use",
                "this card in an",
                "unseeded run to",
                "learn what it does"
            }
        }
    },
    collection_rows = { 3, 3 },
    shop_rate = 0,
    default = "c_grm_moon"
}

local stellarType = SMODS.ConsumableType {
    key = 'Stellar',
    primary_colour = HEX('AAA65B'),
    secondary_colour = HEX('D2CE84'),
    loc_txt = {
        name = 'Stellar',
        collection = 'Stellar Cards',
        undiscovered = {
            name = "Not Discovered",
            text = {
                "Purchase or use",
                "this card in an",
                "unseeded run to",
                "learn what it does"
            }
        }
    },
    collection_rows = { 2, 2 },
    shop_rate = 0,
    default = "c_grm_sun"
}

local elementType = SMODS.ConsumableType {
    key = 'Elemental',
    primary_colour = HEX('e9e4d3'),
    secondary_colour = HEX('e9e4d3'),
    loc_txt = {
        name = 'Elemental',
        collection = 'Elemental Cards',
        undiscovered = {
            name = "Not Discovered",
            text = {
                "Purchase or use",
                "this card in an",
                "unseeded run to",
                "learn what it does"
            }
        }
    },
    collection_rows = { 4, 4 },
    shop_rate = 0,
    default = "c_grm_m_lead"
}

local attackType = SMODS.ConsumableType {
    key = 'Attack',
    primary_colour = HEX('E9D3D3'),
    secondary_colour = HEX('E9D3D3'),
    loc_txt = {
        name = 'Attack',
        collection = 'Attack Cards',
        undiscovered = {
            name = "Not Discovered",
            text = {
                "Recieve this",
                "attack in an",
                "unseeded run to",
                "learn what it does"
            }
        }
    },
    collection_rows = { 4, 4 },
    shop_rate = 0,
    default = "c_grm_debuff"
}

local lootType = SMODS.ConsumableType {
    key = 'Loot',
    primary_colour = HEX('7190A6'),
    secondary_colour = HEX('7190A6'),
    loc_txt = {
        name = 'Loot',
        collection = 'Loot Cards',
        undiscovered = {
            name = "Not Discovered",
            text = {
                "Purchase or use",
                "this card in an",
                "unseeded run to",
                "learn what it does"
            }
        }
    },
    collection_rows = { 4, 4 },
    shop_rate = 0,
    default = "c_grm_hand_refresh"
}

SMODS.Lunar = SMODS.Consumable:extend {
    set = 'Lunar',
    use = function(self, card, area, copier)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + 1
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize('k_upgrade_ex')})
    end,
    can_use = function(self, card)
        return true
    end,
    cost = 3
}

SMODS.Stellar = SMODS.Consumable:extend {
    set = 'Stellar',
    use = function(self, card, area, copier)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + 1
        G.GAME.stellar_levels[self.special_level .. "s"].chips = (G.GAME.special_levels and (G.GAME.special_levels[self.special_level]) or 0) * card.ability.chips
        G.GAME.stellar_levels[self.special_level .. "s"].mult = (G.GAME.special_levels and (G.GAME.special_levels[self.special_level]) or 0) * card.ability.mult
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.MONEY, message = localize('k_upgrade_ex')})
    end,
    can_use = function(self, card)
        return true
    end,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return {vars = {
            localize(self.config.suit, 'suits_plural'),
            G.GAME.special_levels[self.special_level] + 1,
            string.format("%.2f", self.config.mult),
            string.format("%.1f", self.config.chips),
            string.format("%.2f",(G.GAME.special_levels and (G.GAME.special_levels[self.special_level]) or 0) * self.config.mult),
            string.format("%.1f",(G.GAME.special_levels and (G.GAME.special_levels[self.special_level]) or 0) * self.config.chips),
        }}
    end
}

SMODS.Area = SMODS.Consumable:extend {
    set = 'Area',
    use = function(self, card, area, copier)
        leave_area(G.GAME.area)
        G.GAME.area = self.area
        G.GAME.region = self.region or 'Classic'
        G.GAME.area_data.norm_color = self.norm_color
        G.GAME.area_data.endless_color = self.endless_color
        G.GAME.area_data.adjacent = {}
        if self.adjacent then
            for i, j in pairs(self.adjacent) do
                G.GAME.area_data.adjacent[i] = true
            end
        end
        G.GAME.area_data.adjacent[G.GAME.region] = true
        enter_area(self.area, card)
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.GREEN, message = localize('k_new_area')})
        for i = 1, #G.jokers.cards do
            eval = G.jokers.cards[i]:calculate_joker({visited_area = self.area})
        end
    end,
    region = "Classic",
    can_use = function(self, card)
        return true
    end,
    cost = 10,
    in_pool = function(self, card)
        return (self.area ~= G.GAME.area) and (G.GAME.area_data and G.GAME.area_data.adjacent and G.GAME.area_data.adjacent[self.region or 'Classic'])
    end
}

SMODS.Element = SMODS.Consumable:extend {
    set = 'Elemental',
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = skip_animation or 0.4, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        if self.status then
            for i=1, #G.hand.highlighted do
                G.hand.highlighted[i].ability.grm_status = G.hand.highlighted[i].ability.grm_status or {}
                if (self.status == "gust") and not G.hand.highlighted[i].ability.grm_status.gust and not card.debuff then
                    G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + 1
                end
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    G.hand.highlighted[i].ability.grm_status[self.status] = true
                    return true 
                end }))
            end
        else
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() G.hand.highlighted[i]:set_ability(G.P_CENTERS[card.ability.consumeable.mod_conv]);return true end }))
            end
        end
        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
        delay(0.5)
    end,
    cost = 4,
    m_type = 'Common',
    set_badges = function(self, card, badges)
        local colours = {
            Common = HEX('939393'),
            Precious =  HEX('e2d583'),
            Modern = HEX("339d41"),
        }
        local len = string.len(card.config.center.m_type)
        local size = 1.3 - (len > 5 and 0.02 * (len - 5) or 0)
        if card.config.center.discovered then
            badges[#badges + 1] = create_badge(card.config.center.m_type, colours[card.config.center.m_type], nil, size)
        end
    end
}

SMODS.Attack = SMODS.Consumable:extend {
    set = 'Attack',
    use = function(self, card, area, copier)
       local a = 1
    end,
    cost = 4,
    discovered = true,
}

SMODS.Loot = SMODS.Consumable:extend {
    set = 'Loot',
    cost = 4,
    can_use = function(self, card)
        return true
    end,
    discovered = true,
}

SMODS.UndiscoveredSprite {
    key = 'Lunar',
    atlas = 'lunar',
    pos = {x = 2, y = 1}
}

SMODS.UndiscoveredSprite {
    key = 'Stellar',
    atlas = 'stellar',
    pos = {x = 0, y = 1}
}

SMODS.UndiscoveredSprite {
    key = 'Skill',
    atlas = 'skills',
    pos = {x = 0, y = 0}
}

SMODS.UndiscoveredSprite {
    key = 'Area',
    atlas = 'areas',
    pos = {x = 0, y = 1}
}

SMODS.UndiscoveredSprite {
    key = 'Elemental',
    atlas = 'metal',
    pos = {x = 0, y = 0}
}

SMODS.UndiscoveredSprite {
    key = 'Attack',
    atlas = 'attack',
    pos = {x = 0, y = 2}
}

SMODS.UndiscoveredSprite {
    key = 'Loot',
    atlas = 'loot',
    pos = {x = 0, y = 0}
}

function SMODS.current_mod.reset_game_globals()
    G.GAME.grim_hand_size_bonus = 0
end

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
    if card.ability.temp_debuff then
        return true
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
                card.sticker = get_skill_win_banner(center)
                if card.sticker then
                    card.no_shader = true
                end
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
            card.sticker = get_skill_win_banner(center)
            if card.sticker then
                card.no_shader = true
            end
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
            if not v.unlocked and meta.unlocked[k] then
                v.unlocked = true
            end
            if not v.unlocked then
                G.P_LOCKED[#G.P_LOCKED + 1] = v
            end
            if not v.discovered and meta.discovered[k] then
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

	for k, v in pairs(G.P_SKILLS or {}) do
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

    for k, v in pairs(G.P_CRAFTS or {}) do
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
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        G.P_SEALS,
        G.P_SKILLS or {},
        G.P_CRAFTS or {},
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
            if j.class and G.GAME.grim_class.class then
                valid = false
            end
            if G.GAME.skills[j.key] then
                valid = true
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

function fix_ante_scaling(do_blind)
    local result = 1
    for i, j in pairs(G.GAME.scaling_multipliers) do
        result = result * j
    end
    result = 0.01 * math.max(1,math.floor(result * 100))
    local orig = G.GAME.starting_params.ante_scaling
    G.GAME.starting_params.ante_scaling = result * G.GAME.base_ante_scaling
    local mult = 0.01 * math.max(1,math.floor(G.GAME.starting_params.ante_scaling / orig * 100))
    if not do_blind and G.GAME.blind and G.GAME.blind.chips and G.GAME.blind.chip_text then
        G.GAME.blind.chips = math.floor(G.GAME.blind.chips * mult)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
end

function learn_skill(card, direct_)
    local obj, key = "", ""
    if direct_ then
        obj = G.P_SKILLS[direct_]
        key = direct_
    else
        obj = card.config.center
        key = obj.key
    end
    G.GAME.skills[key] = true
    if G.GAME.ante_banners and not G.GAME.ante_banners[key] then
        G.GAME.ante_banners[key] = G.GAME.round_resets.ante
    end
    if not obj.class and (G.GAME.free_skills and (G.GAME.free_skills > 0)) then
        G.GAME.free_skills = G.GAME.free_skills - 1
    else
        G.GAME.skill_xp = G.GAME.skill_xp - obj.xp_req
        G.GAME.xp_spent = (G.GAME.xp_spent or 0) + obj.xp_req
    end
    if obj.token_req then
        G.GAME.legendary_tokens = G.GAME.legendary_tokens - obj.token_req
    end
    check_for_unlock({type = 'skill_check', learned_skill = key, learned_tier = obj.tier})
    if card then
        discover_card(obj)
        card:set_sprites(obj)
    end
    if key == "sk_grm_ease_1" then
        G.GAME.scaling_multipliers.ease = 0.9
        fix_ante_scaling()
    elseif key == "sk_grm_ease_2" then
        G.GAME.scaling_multipliers.ease = 0.8
        fix_ante_scaling()
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
        G.GAME.scaling_multipliers.stake = 1.3 ^ G.GAME.round_resets.ante
        fix_ante_scaling()
        G.E_MANAGER:add_event(Event({func = function()
            if G.jokers then 
                G.jokers.config.card_limit = G.jokers.config.card_limit + 3
            end
        return true end }))
    elseif key == "sk_grm_scarce_1" then
        for i, j in ipairs({'p_buffoon_normal_1', 'p_buffoon_normal_2', 'p_buffoon_jumbo_1', 'p_buffoon_mega_1'}) do
            if not G.GAME.banned_keys[j] then
                G.GAME.banned_keys[j] = 'grim'
            end
        end
    elseif key == "sk_grm_ghost_1" then
        G.hand:change_size(-1)
    elseif key == "sk_grm_ghost_2" then
        G.hand:change_size(-2)
    elseif key == "sk_grm_chime_3" then
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
        ease_hands_played(-1)
    elseif key == "sk_grm_strike_3" then
        G.GAME.scaling_multipliers.strike = 1.2
        fix_ante_scaling()
    elseif key == "sk_grm_receipt_3" then
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - 25
    elseif key == "sk_grm_mystical_2" then
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true end }))
    elseif key == "sk_grm_receipt_2" then
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true end }))
    elseif key == "sk_grm_chime_1" and ((G.GAME.round_resets.ante) % 8 == 0) and not G.GAME.reset_antes[G.GAME.round_resets.ante] then
        G.GAME.reset_antes[G.GAME.round_resets.ante] = true
        ease_ante(-1, true)
        if G.GAME.skills["sk_grm_stake_3"] then
            G.GAME.scaling_multipliers.stake = 1.3 ^ G.GAME.round_resets.ante
            fix_ante_scaling()
        end
    elseif key == "sk_grm_chime_2" and ((G.GAME.round_resets.ante) % 4 == 0) and not G.GAME.reset_antes2[G.GAME.round_resets.ante] then
        G.GAME.reset_antes2[G.GAME.round_resets.ante] = true
        ease_ante(-1, true)
        if G.GAME.skills["sk_grm_stake_3"] then
            G.GAME.scaling_multipliers.stake = 1.3 ^ G.GAME.round_resets.ante
            fix_ante_scaling()
        end
    elseif key == "sk_grm_chime_3" and ((G.GAME.round_resets.ante) % 3 == 0) and not G.GAME.reset_antes3[G.GAME.round_resets.ante] then
        G.GAME.reset_antes3[G.GAME.round_resets.ante] = true
        ease_ante(-1, true)
        if G.GAME.skills["sk_grm_stake_3"] then
            G.GAME.scaling_multipliers.stake = 1.3 ^ G.GAME.round_resets.ante
            fix_ante_scaling()
        end
    elseif key == "sk_grm_cl_hoarder" then
        G.hand:change_size(-1)
        G.GAME.grim_class.hoarder = true
        G.GAME.grim_class.class = true
    elseif key == "sk_grm_cl_astronaut" then
        G.GAME.grim_class.astronaut = true
        G.GAME.grim_class.class = true
    elseif key == "sk_grm_cl_alchemist" then
        G.GAME.banned_keys['c_devil'] = true
        G.GAME.elemental_rate = 4
        G.GAME.grim_class.alchemist = true
        G.GAME.grim_class.class = true
    elseif key == "sk_grm_cl_explorer" then
        G.GAME.grim_class.explorer = true
        G.GAME.grim_class.class = true
    elseif key == "sk_grm_orbit_1" then
        G.GAME.lunar_rate = 4
        G.GAME.stellar_rate = 4
    elseif key == "sk_grm_sticky_2" then
        G.GAME.perishable_rounds = (G.GAME.perishable_rounds or 5) + 3
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.perishable then
                G.jokers.cards[i].ability.perish_tally = (G.jokers.cards[i].ability.perish_tally or 5) + 3
                G.jokers.cards[i]:set_debuff()
            end
        end
    elseif key == "sk_grm_sticky_3" then
        G.GAME.rental_rate = -G.GAME.rental_rate
    elseif key == "sk_grm_shelf_1" then
        change_shop_size(-1)
        G.GAME.grm_modify_booster_slots = (G.GAME.grm_modify_booster_slots or 0) + 2
        if G.shop then
            for i = 3, 4 do
                local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[get_pack('shop_pack').key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                create_shop_card_ui(card, 'Booster', G.shop_booster)
                card.ability.booster_pos = i
                card:start_materialize()
                G.shop_booster:emplace(card)
            end
        end
    elseif key == "sk_grm_shelf_2" then
        if not G.GAME.grm_did_purchase then
            change_shop_size(1)
        end
    elseif key == "sk_grm_prestige_1" then
        local pool = {}
        for i, j in pairs(G.GAME.skills) do
            if not G.P_SKILLS[i].class and (i ~= "sk_grm_prestige_1") then
                table.insert(pool, i)
            end
        end
        for i, j in ipairs(pool) do
            unlearn_skill(j)
        end
        skills_page = nil
        if G.GAME.xp_spent >= 2500 then
            G.GAME.legendary_tokens = (G.GAME.legendary_tokens or 0) + 1
        end
    end
end

function unlearn_skill(direct_)
    local obj, key = G.P_SKILLS[direct_], direct_
    G.GAME.skills[key] = nil
    if key == "sk_grm_ease_1" then
        G.GAME.scaling_multipliers.ease = nil
        fix_ante_scaling()
    elseif key == "sk_grm_ease_2" then
        G.GAME.scaling_multipliers.ease = 0.9
        fix_ante_scaling()
    elseif key == "sk_grm_hexahedron_1" then
        G.E_MANAGER:add_event(Event({func = function()
            G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + 1
            G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost + 1)
        return true end }))
    elseif key == "sk_grm_ocean_1" then
        G.hand:change_size(-1)
    elseif key == "sk_grm_stake_1" then
        G.GAME.win_ante = G.GAME.win_ante - 1
        G.hand:change_size(-1)
    elseif key == "sk_grm_stake_2" then
        G.GAME.win_ante = G.GAME.win_ante - 2
        G.E_MANAGER:add_event(Event({func = function()
            if G.jokers then 
                G.jokers.config.card_limit = G.jokers.config.card_limit - 1
            end
        return true end }))
    elseif key == "sk_grm_stake_3" then
        G.GAME.scaling_multipliers.stake = nil
        fix_ante_scaling()
        G.E_MANAGER:add_event(Event({func = function()
            if G.jokers then 
                G.jokers.config.card_limit = G.jokers.config.card_limit - 3
            end
        return true end }))
    elseif key == "sk_grm_scarce_1" then
        for i, j in ipairs({'p_buffoon_normal_1', 'p_buffoon_normal_2', 'p_buffoon_jumbo_1', 'p_buffoon_mega_1'}) do
            if G.GAME.banned_keys[j] == 'grim' then
                G.GAME.banned_keys[j] = nil
            end
        end
    elseif key == "sk_grm_ghost_1" then
        G.hand:change_size(1)
    elseif key == "sk_grm_ghost_2" then
        G.hand:change_size(2)
    elseif key == "sk_grm_chime_3" then
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
        ease_hands_played(1)
    elseif key == "sk_grm_strike_3" then
        G.GAME.scaling_multipliers.strike = nil
        fix_ante_scaling()
    elseif key == "sk_grm_receipt_3" then
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + 25
    elseif key == "sk_grm_mystical_2" then
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true end }))
    elseif key == "sk_grm_receipt_2" then
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true end }))
    -- elseif key == "sk_grm_cl_hoarder" then
    --     G.hand:change_size(1)
    --     G.GAME.grim_class.hoarder = true
    --     G.GAME.grim_class.class = true
    -- elseif key == "sk_grm_cl_astronaut" then
    --     G.GAME.grim_class.astronaut = true
    --     G.GAME.grim_class.class = true
    -- elseif key == "sk_grm_cl_alchemist" then
    --     G.GAME.banned_keys['c_devil'] = true
    --     G.GAME.elemental_rate = 4
    --     G.GAME.grim_class.alchemist = true
    --     G.GAME.grim_class.class = true
    -- elseif key == "sk_grm_cl_explorer" then
    --     G.GAME.grim_class.explorer = true
    --     G.GAME.grim_class.class = true
    elseif key == "sk_grm_orbit_1" then
        G.GAME.lunar_rate = nil
        G.GAME.stellar_rate = nil
    elseif key == "sk_grm_sticky_2" then
        G.GAME.perishable_rounds = (G.GAME.perishable_rounds or 5) - 3
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.perishable then
                G.jokers.cards[i].ability.perish_tally = math.max(0,(G.jokers.cards[i].ability.perish_tally or 5) - 3)
                G.jokers.cards[i]:set_debuff()
            end
        end
    elseif key == "sk_grm_sticky_3" then
        G.GAME.rental_rate = -G.GAME.rental_rate
    elseif key == "sk_grm_shelf_1" then
        change_shop_size(1)
        G.GAME.grm_modify_booster_slots = (G.GAME.grm_modify_booster_slots or 0) - 2
        if G.shop then
        end
    elseif key == "sk_grm_shelf_2" then
        if not G.GAME.grm_did_purchase then
            change_shop_size(-1)
        end
    end
end

G.FUNCS.can_learn = function(e)
    if e.config.ref_table and e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.key and (G.GAME.skills[e.config.ref_table.config.center.key] or (not e.config.ref_table.config.center.xp_req or (G.GAME.skill_xp < e.config.ref_table.config.center.xp_req)) or (e.config.ref_table.config.center.token_req and (G.GAME.legendary_tokens < e.config.ref_table.config.center.token_req))) and (not G.GAME.free_skills or (G.GAME.free_skills <= 0)) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
    else
        if e.config.ref_table and e.config.ref_table.config.center.key and (e.config.ref_table.config.center.key == "sk_grm_prestige_1") and (not G.GAME.xp_spent or (G.GAME.xp_spent < 2500)) then
            e.config.colour = G.C.RED
            e.config.button = 'do_nothing'
            return 
        end
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

    local text2 = localize{type = 'variable', key = 'legendary_tokens', vars = {number_format(G.GAME.legendary_tokens)}, nodes = text}

    local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes = {
        {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = text, colours = {G.C.UI.TEXT_LIGHT}, bump = true, scale = 0.6})}}
        }},
        {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=area_table},
        {n=G.UIT.R, config={align = "cm"}, nodes={
            create_option_cycle({options = skill_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_game_skill_page', focus_args = {snap_to = true, nav = 'wide'},current_option = (skills_page or 1), colour = G.C.ORANGE, no_pips = true})
        }},
      }}
    if G.GAME.skills["sk_grm_cl_astronaut"] then
        t.nodes[4] = UIBox_button{id = 'lunar_button', label = {"Lunar Stats"}, button = "your_lunar_stats", minw = 5}
    end
    if G.GAME.legendary_tokens and (G.GAME.legendary_tokens > 0) then
        table.insert(t.nodes, 2, {n=G.UIT.R, config={align = "cm", padding = 0.2}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = text2, colours = {G.C.UI.TEXT_LIGHT}, bump = true, scale = 0.6})}}
        }})
    end
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
                G.GAME.scaling_multipliers.stake = 1.3 ^ context.current_ante
                fix_ante_scaling(true)
            end
        elseif skill == "sk_grm_chime_2" and ((context.current_ante) % 4 == 0) and not G.GAME.reset_antes2[context.current_ante] then
            G.GAME.reset_antes2[context.current_ante] = true
            ease_ante(-1, true)
            if G.GAME.skills["sk_grm_stake_3"] then
                G.GAME.scaling_multipliers.stake = 1.3 ^ context.current_ante
                fix_ante_scaling(true)
            end
        elseif skill == "sk_grm_chime_3" and ((context.current_ante) % 3 == 0) and not G.GAME.reset_antes3[context.current_ante] then
            G.GAME.reset_antes3[context.current_ante] = true
            ease_ante(-1, true)
            if G.GAME.skills["sk_grm_stake_3"] then
                G.GAME.scaling_multipliers.stake = 1.3 ^ context.current_ante
                fix_ante_scaling(true)
            end
        elseif skill == "sk_grm_stake_3" then
            G.GAME.scaling_multipliers.stake = 1.3 ^ context.current_ante
            fix_ante_scaling(true)
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
    check_for_unlock({type = 'skill_check', total_xp = G.GAME.skill_xp})
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
    if G.GAME.area == "Ghost Town" then
        return 0
    end
    local new_amount = amount
    if G.GAME.skills["sk_grm_skillful_3"] and (new_amount > 0) then
        new_amount = new_amount * 2
    end
    if G.GAME.skills["sk_grm_ghost_3"] and (new_amount > 0) then
        new_amount = math.max(1 , math.floor(new_amount * 0.5))
    end
    if (G.GAME.area == "Metro") or (G.GAME.area == "Aether") then
        new_amount = math.max(1 , math.floor(new_amount * (G.GAME.area_data.xp_buff or 1)))
    end
    new_amount = math.floor(new_amount)
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
    elseif card.key == "sk_grm_cl_explorer" then
        if args.grm_run_won then
            local count = 0
            for i, j in pairs(G.GAME.skills) do
                count = count + 1
                if count >= 10 then
                    return true
                end
            end
        end
    elseif (card.key == "sk_grm_cl_astronaut") and args.learned_skill then
        if args.learned_skill == "sk_grm_gravity_3" then
            return true
        end
    elseif card.key == "sk_grm_cl_alchemist" then
        if args.type == 'modify_deck' then
            local count = 0
            for _, v in pairs(G.playing_cards) do
                if (v.ability.name == "Wild Card") or (G.GAME.skills and G.GAME.skills["sk_grm_motley_3"] and (v.config.center ~= G.P_CENTERS.c_base)) then count = count + 1 end
            end
            if count >= 52 then
                return true
            end
        end
    elseif card.key == "sk_grm_cl_hoarder" then
        if args.total_xp and (args.total_xp >= 2000) then
            return true
        end
    elseif card.key == "sk_grm_prestige_1" and args.learned_tier then
        if args.learned_tier == 3 then
            return true
        end
    end
end

function leave_area(area)
    if area == 'Graveyard' then
        G.GAME.spectral_rate = (G.GAME.area_data.orig_spectral_rate or 0)
    elseif area == 'Plains' then
        if G.GAME.modifiers.no_extra_hand_money then
            G.GAME.modifiers.money_per_hand = 0
            G.GAME.modifiers.no_extra_hand_money = false
        end
        G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 2) + (G.GAME.area_data.hand_dollars_mod or 1)
        G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) - (G.GAME.area_data.discard_dollars_mod or 1)
        if G.GAME.modifiers.money_per_discard == 0 then
            G.GAME.modifiers.money_per_discard = nil
        end
        if G.GAME.modifiers.money_per_hand == 0 then
            G.GAME.modifiers.no_extra_hand_money = true
        end
    elseif area == 'Market' then
        G.E_MANAGER:add_event(Event({func = function()
            change_shop_size((G.GAME.area_data.slots_mod and (-1 * G.GAME.area_data.slots_mod)) or -2)
        return true end }))
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
        return true end }))
    elseif area == 'Landfill' then
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + (G.GAME.area_data.hands_mod or 1)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - (G.GAME.area_data.discards_mod or 2)
        ease_hands_played(G.GAME.area_data.hands_mod)
        ease_discard(-1 * G.GAME.area_data.discards_mod)
    elseif area == 'Toxic Waste' then
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - (G.GAME.area_data.discards_mod or 2)
        ease_discard(-1 * G.GAME.area_data.discards_mod)
    end
end

function enter_area(area, card)
    if area == 'Graveyard' then
        G.GAME.area_data.orig_spectral_rate = G.GAME.spectral_rate
        G.GAME.spectral_rate = 2
    elseif area == 'Plains' then
        if G.GAME.modifiers.no_extra_hand_money then
            G.GAME.modifiers.money_per_hand = 0
            G.GAME.modifiers.no_extra_hand_money = false
        end
        G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 1) - (card and card.ability and card.ability.hand_dollars or 1)
        G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + (card and card.ability and card.ability.discard_dollars or 1)
        G.GAME.area_data.hand_dollars_mod = card.ability.hand_dollars
        G.GAME.area_data.discard_dollars_mod = card.ability.discard_dollars
        if G.GAME.modifiers.money_per_discard == 0 then
            G.GAME.modifiers.money_per_discard = nil
        end
        if G.GAME.modifiers.money_per_hand == 0 then
            G.GAME.modifiers.no_extra_hand_money = true
        end
    elseif area == 'Market' then
        G.GAME.area_data.market_upcount = 1 + (card.ability.upcount * 0.01)
        G.GAME.area_data.slots_mod = card.ability.slots
        G.E_MANAGER:add_event(Event({func = function()
            change_shop_size(card and card.ability and card.ability.slots or 2)
        return true end }))
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
        return true end }))
    elseif area == 'Landfill' then
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - (card and card.ability and card.ability.hands or 1)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + (card and card.ability and card.ability.discards or 2)
        G.GAME.area_data.hands_mod = card and card.ability and card.ability.hands or 1
        G.GAME.area_data.discards_mod = card and card.ability and card.ability.discards or 2
        ease_hands_played(-1 * (card and card.ability and card.ability.hands or 1))
        ease_discard(card and card.ability and card.ability.discards or 2)
    elseif area == 'Metro' then
        G.GAME.area_data.xp_buff = 1 + (0.01 * (card and card.ability and card.ability.xp_buff or 0))
    elseif area == 'Ghost Town' then
        G.GAME.area_data.ghost_odds = (card and card.ability and card.ability.odds or 3)
        G.GAME.area_data.ghost_dollars = (card and card.ability and card.ability.money or 15)
    elseif area == 'Midnight' then
        G.GAME.area_data.midnight_mult = (card and card.ability and card.ability.grm_x_mult or 1.7)
    elseif area == 'Dungeon' then
        if not G.P_BLINDS[G.GAME.round_resets.blind_choices.Boss].boss or not G.P_BLINDS[G.GAME.round_resets.blind_choices.Boss].boss.showdown then
            G.GAME.round_resets.blind_choices.Boss = get_new_boss()
        end
    elseif area == 'Toxic Waste' then
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + (card and card.ability and card.ability.discards or 2)
        G.GAME.area_data.discards_mod = card and card.ability and card.ability.discards or 2
        ease_discard(card and card.ability and card.ability.discards or 2)
        G.GAME.area_data.discard_decay = card and card.ability and card.ability.degrade or 1
    elseif area == 'Aether' then
        G.GAME.area_data.xp_buff = 1 + (0.01 * (card and card.ability and card.ability.xp_buff or 0))
        G.GAME.area_data.aether_discount = 1 - (0.01 * (card and card.ability and card.ability.money_buff or 0))
        G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
        return true end }))
    end
end

function random_attack()
    if G.GAME.modifiers["blind_attack"] then
        local rng = pseudorandom('attack')
        if G.GAME.blind_on_deck == "Small" then
            if rng < 0.3 then
                return {attack = "debuff", amt = 1, context = "pre_draw_hand"}
            else
                return {attack = "hide", amt = 1, context = "press_play"}
            end
        elseif G.GAME.blind_on_deck == "Big" then
            if rng < 0.25 then
                return {attack = "debuff", amt = 2, context = "pre_draw_hand"}
            elseif rng < 0.5 then
                return {attack = "up", amt = 1.1, context = "pre_draw_hand"}
            elseif rng < 0.75 then
                return {attack = "hide", amt = 2, context = "press_play"}
            else
                return {attack = "ring", amt = 1, context = "pre_draw_hand"}
            end
        elseif G.GAME.blind_on_deck == "Boss" then
            if G.GAME.blind.name == "Coral Well" then
                if rng < 0.2 then
                    return {attack = "collapse", amt = 3, context = "press_play"}
                elseif rng < 0.4 then
                    return {attack = "up", amt = 1.25, context = "pre_draw_hand"}
                elseif rng < 0.6 then
                    return {attack = "snatch", amt = 4, context = "press_play"}
                elseif rng < 0.8 then
                    return {attack = "debuff", amt = 4, context = "pre_draw_hand"}
                else
                    return {attack = "ring", amt = 2, context = "pre_draw_hand"}
                end
            else
                if rng < 0.2 then
                    return {attack = "collapse", amt = 2, context = "press_play"}
                elseif rng < 0.4 then
                    return {attack = "up", amt = 1.1, context = "pre_draw_hand"}
                elseif rng < 0.6 then
                    return {attack = "hide", amt = 2, context = "press_play"}
                elseif rng < 0.8 then
                    return {attack = "debuff", amt = 2, context = "pre_draw_hand"}
                else
                    return {attack = "ring", amt = 1, context = "pre_draw_hand"}
                end
            end
        end
    end
end

function do_attack(context, extra)
    local attack_type, amt = 0,0
    if G.GAME.blind_attack and G.GAME.blind_attack.context == context then
        attack_type = G.GAME.blind_attack.attack
        amt = G.GAME.blind_attack.amt
    else
        return
    end
    atk_card = "c_grm_" .. attack_type
    discover_card(G.P_CENTERS[atk_card])
    local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W/2,
    G.play.T.y + G.play.T.h/2-G.CARD_H/2, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[atk_card], {bypass_discovery_center = true, bypass_discovery_ui = true})
    card.cost = 0
    card.attack_card = true
    G.FUNCS.use_card({config = {ref_table = card}})
    card:start_materialize()
    G.CONTROLLER.locks.blind_attack = true
    if attack_type == "debuff" then
        G.E_MANAGER:add_event(Event({func = function()
            local amount = math.min(#G.hand.cards, amt)
            local pool = {}
            local result = {}
            for i, j in ipairs(G.hand.cards) do
                if not j.debuff then
                    table.insert(pool, j)
                end
            end
            for i = 1, amount do
                local card2, key = pseudorandom_element(pool, pseudoseed('attack'))
                table.remove(pool, key)
                table.insert(result, card2)
            end
            for i, j in ipairs(result) do
                j.ability.temp_debuff = true
                j:set_debuff()
            end
        return true end }))
    elseif attack_type == "snatch" then
        G.E_MANAGER:add_event(Event({
            func = function()
                local amount = math.min(#G.hand.cards, amt)
                local pool = {}
                local result = {}
                for i, j in ipairs(G.hand.cards) do
                    table.insert(pool, j)
                end
                for i = 1, amount do
                    local card2, key = pseudorandom_element(pool, pseudoseed('attack'))
                    table.remove(pool, key)
                    table.insert(result, card2)
                end
                for i, j in ipairs(result) do
                    draw_card(G.hand, G.discard, nil, nil, nil, j, nil, nil, true)
                end
        return true end }))
    elseif attack_type == "hide" then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
            local amount = math.min(G.hand.config.card_limit - #G.hand.cards, amt)
            for i = 1, amount do
                draw_card(G.deck, G.hand, nil, nil, nil, nil, nil, nil, true)
            end
        return true end }))
    elseif attack_type == "ring" then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local amount = math.min(5, math.min(#G.hand.cards, amt))
                local pool = {}
                local result = {}
                for i, j in ipairs(G.hand.cards) do
                    if not j.forced_selection then
                        table.insert(pool, j)
                    end
                end
                for i = 1, amount do
                    local card2, key = pseudorandom_element(pool, pseudoseed('attack'))
                    table.remove(pool, key)
                    table.insert(result, card2)
                end
                for i, j in ipairs(result) do
                    G.hand:unhighlight_all()
                    j.ability.forced_selection = true
                    G.hand:add_to_highlighted(j)
                end
        return true end }))
    elseif attack_type == "up" then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * amt)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.GAME.blind:set_text()
                G.GAME.blind:wiggle()
        return true end }))
    elseif attack_type == "collapse" then
        local pool = {}
        local total = 0
        local result = nil
        local valid = false
        for i, j in pairs(G.GAME.hands) do
            if (j.level > 1) and j.visible then
                pool[i] = j.played
                valid = true
                total = total + j.played
            end
        end
        if valid then
            local index = math.min(total - 1, math.floor((total) * pseudorandom('collapse')))
            local subtotal = 0
            for i, j in pairs(pool) do
                subtotal = subtotal + j
                if index <= subtotal then
                    result = i
                    break
                end
            end
            if result then
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(result, 'poker_hands'),chips = G.GAME.hands[result].chips, mult = G.GAME.hands[result].mult, level=G.GAME.hands[result].level})
                delay(0.35)
                level_up_hand(nil, result, nil, -math.min(G.GAME.hands[result].level - 1, amt))
            end
        end
    end
    G.GAME.blind_attack = nil
    G.CONTROLLER.locks.blind_attack = nil
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

G.FUNCS.grm_discard_card = function(e)
    local card = e.config.ref_table
    if G.STATE == G.STATES.SELECTING_HAND then
        draw_card(G.consumeables, G.discard, nil, nil, nil, card)
    else
        draw_card(G.consumeables, G.deck, nil, nil, nil, card)
    end
end

G.FUNCS.grm_can_discard_card = function(e)
    if (G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0) then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = 'grm_discard_card'
    end
end

G.FUNCS.grm_draw_card = function(e)
    local card = e.config.ref_table
    draw_card(G.consumeables, G.hand, nil, nil, nil, card, nil, nil, (card.facing == "back"))
end

G.FUNCS.grm_can_draw_card = function(e)
    if not G.hand or not (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) or ((G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.BLUE
        e.config.button = 'grm_draw_card'
    end
end

G.FUNCS.grm_pack_card = function(e)
    local card = e.config.ref_table
    draw_card(card.area, G.consumeables, nil, nil, nil, card, nil, nil, (card.facing == "back"))
end

G.FUNCS.grm_can_pack_card = function(e)
    local card = e.config.ref_table
    if not G.consumeables or (#G.consumeables.cards >= G.consumeables.config.card_limit) or (card.area ~= G.hand) or ((G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.GREEN
        e.config.button = 'grm_pack_card'
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

SMODS.Atlas({ key = "banners", atlas_table = "ASSET_ATLAS", path = "banners.png", px = 71, py = 95,
    inject = function(self)
        local file_path = type(self.path) == 'table' and
            (self.path[G.SETTINGS.language] or self.path['default'] or self.path['en-us']) or self.path
        if file_path == 'DEFAULT' then return end
        -- language specific sprites override fully defined sprites only if that language is set
        if self.language and not (G.SETTINGS.language == self.language) then return end
        if not self.language and self.obj_table[('%s_%s'):format(self.key, G.SETTINGS.language)] then return end
        self.full_path = (self.mod and self.mod.path or SMODS.path) ..
            'assets/' .. G.SETTINGS.GRAPHICS.texture_scaling .. 'x/' .. file_path
        local file_data = assert(NFS.newFileData(self.full_path),
            ('Failed to collect file data for Atlas %s'):format(self.key))
        self.image_data = assert(love.image.newImageData(file_data),
            ('Failed to initialize image data for Atlas %s'):format(self.key))
        self.image = love.graphics.newImage(self.image_data,
            { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
        G[self.atlas_table][self.key_noloc or self.key] = self
        G.shared_stickers['ante_0'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 0,y = 0})
        G.shared_stickers['ante_1'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 1,y = 0})
        G.shared_stickers['ante_2'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 2,y = 0})
        G.shared_stickers['ante_3'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 3,y = 0})
        G.shared_stickers['ante_4'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 0,y = 1})
        G.shared_stickers['ante_5'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 1,y = 1})
        G.shared_stickers['ante_6'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 2,y = 1})
        G.shared_stickers['ante_7'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 3,y = 1})
        G.shared_stickers['ante_8'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 0,y = 2})
        G.shared_stickers['ante_9'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 1,y = 2})
        G.shared_stickers['ante_-1'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 2,y = 2})
    end
})

SMODS.Atlas({ key = "stellar", atlas_table = "ASSET_ATLAS", path = "Stellar.png", px = 71, py = 95,
    inject = function(self)
        local file_path = type(self.path) == 'table' and
            (self.path[G.SETTINGS.language] or self.path['default'] or self.path['en-us']) or self.path
        if file_path == 'DEFAULT' then return end
        -- language specific sprites override fully defined sprites only if that language is set
        if self.language and not (G.SETTINGS.language == self.language) then return end
        if not self.language and self.obj_table[('%s_%s'):format(self.key, G.SETTINGS.language)] then return end
        self.full_path = (self.mod and self.mod.path or SMODS.path) ..
            'assets/' .. G.SETTINGS.GRAPHICS.texture_scaling .. 'x/' .. file_path
        local file_data = assert(NFS.newFileData(self.full_path),
            ('Failed to collect file data for Atlas %s'):format(self.key))
        self.image_data = assert(love.image.newImageData(file_data),
            ('Failed to initialize image data for Atlas %s'):format(self.key))
        self.image = love.graphics.newImage(self.image_data,
            { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
        G[self.atlas_table][self.key_noloc or self.key] = self
        G.iron_core = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 3,y = 1})
    end
})

SMODS.Atlas({ key = "lunar", atlas_table = "ASSET_ATLAS", path = "Lunar.png", px = 71, py = 95})

SMODS.Atlas({ key = "areas", atlas_table = "ASSET_ATLAS", path = "Areas.png", px = 71, py = 95})

SMODS.Atlas({ key = "tags", atlas_table = "ASSET_ATLAS", path = "tags.png", px = 34, py = 34})

SMODS.Atlas({ key = "boosters", atlas_table = "ASSET_ATLAS", path = "Boosters.png", px = 71, py = 95})

SMODS.Atlas({ key = "status", atlas_table = "ASSET_ATLAS", path = "Status.png", px = 71, py = 95,
    inject = function(self)
        local file_path = type(self.path) == 'table' and
            (self.path[G.SETTINGS.language] or self.path['default'] or self.path['en-us']) or self.path
        if file_path == 'DEFAULT' then return end
        -- language specific sprites override fully defined sprites only if that language is set
        if self.language and not (G.SETTINGS.language == self.language) then return end
        if not self.language and self.obj_table[('%s_%s'):format(self.key, G.SETTINGS.language)] then return end
        self.full_path = (self.mod and self.mod.path or SMODS.path) ..
            'assets/' .. G.SETTINGS.GRAPHICS.texture_scaling .. 'x/' .. file_path
        local file_data = assert(NFS.newFileData(self.full_path),
            ('Failed to collect file data for Atlas %s'):format(self.key))
        self.image_data = assert(love.image.newImageData(file_data),
            ('Failed to initialize image data for Atlas %s'):format(self.key))
        self.image = love.graphics.newImage(self.image_data,
            { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
        G[self.atlas_table][self.key_noloc or self.key] = self
        G.shared_stickers['sa_flint'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 0,y = 0})
        G.shared_stickers['sa_subzero'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 1,y = 0})
        G.shared_stickers['sa_rocky'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 0,y = 1})
        G.shared_stickers['sa_aether'] = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 1,y = 1})
    end
})

SMODS.Atlas({ key = "decks", atlas_table = "ASSET_ATLAS", path = "Backs.png", px = 71, py = 95})

SMODS.Atlas({ key = "metal", atlas_table = "ASSET_ATLAS", path = "Metallic.png", px = 71, py = 95,
    inject = function(self)
        local file_path = type(self.path) == 'table' and
            (self.path[G.SETTINGS.language] or self.path['default'] or self.path['en-us']) or self.path
        if file_path == 'DEFAULT' then return end
        -- language specific sprites override fully defined sprites only if that language is set
        if self.language and not (G.SETTINGS.language == self.language) then return end
        if not self.language and self.obj_table[('%s_%s'):format(self.key, G.SETTINGS.language)] then return end
        self.full_path = (self.mod and self.mod.path or SMODS.path) ..
            'assets/' .. G.SETTINGS.GRAPHICS.texture_scaling .. 'x/' .. file_path
        local file_data = assert(NFS.newFileData(self.full_path),
            ('Failed to collect file data for Atlas %s'):format(self.key))
        self.image_data = assert(love.image.newImageData(file_data),
            ('Failed to initialize image data for Atlas %s'):format(self.key))
        self.image = love.graphics.newImage(self.image_data,
            { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
        G[self.atlas_table][self.key_noloc or self.key] = self
        G.ultra_status = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 2,y = 2})
    end
})

SMODS.Atlas({ key = "attack", atlas_table = "ASSET_ATLAS", path = "Attack.png", px = 71, py = 95})

SMODS.Atlas({ key = "loot", atlas_table = "ASSET_ATLAS", path = "Loot.png", px = 71, py = 95})

SMODS.Atlas({ key = "sleeves", atlas_table = "ASSET_ATLAS", path = "Sleeves.png", px = 71, py = 95})

SMODS.Atlas({ key = "blinds", atlas_table = "ANIMATION_ATLAS", path = "Blinds.png", px = 34, py = 34, frames = 21 })

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
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_hoarder, {allow_duplicates = false}
    end,
}

SMODS.Tarot {
    key = 'tape',
    loc_txt = {
        name = "The Tape",
        text = {
            "Enhances {C:attention}#1#",
            "selected cards to",
            "{C:attention}#2#s"
        }
    },
    atlas = "tarots",
    pos = {x = 1, y = 0},
    config = {mod_conv = 'm_grm_package', max_highlighted = 2},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_package']
        return {vars = {(card and card.ability.max_highlighted or 2), localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_package')}}}
    end,
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Joker {
    key = 'jack_of_all_trades',
    name = "Jack of All Trades",
    loc_txt = {
        name = "Jack of All Trades",
        text = {
            "{C:attention}Sell{} this card to",
            "{C:attention}learn{} an unlearned",
            "{C:attention}Class{}"
        }
    },
    rarity = 3,
    atlas = 'jokers',
    pos = {x = 0, y = 1},
    cost = 10,
    blueprint_compat = false,
    eternal_compat = false,
    config = {},
    in_pool = function(self)
        local valid = false
        for i, j in pairs(G.P_CENTER_POOLS['Skill']) do
            if j.unlocked and j.class and not G.GAME.skills[j.key] then
                valid = true
            end
        end
        return valid, {allow_duplicates = false}
    end,
    calculate = function(self, card, context)
        if context.selling_self then
            local classes = {}
            for i, j in pairs(G.P_CENTER_POOLS['Skill']) do
                if j.unlocked and j.class and not G.GAME.skills[j.key] then
                    classes[#classes + 1] = j.key
                end
            end
            if #classes > 0 then
                local class = pseudorandom_element(classes, pseudoseed('jack'))
                learn_skill(nil, class)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='name_text',key=class,set = "Skill"},colour = G.C.FILTER, delay = 0.45})
            end
        end
    end
}

SMODS.Attack {
    key = 'debuff',
    loc_txt = {
        name = "Debuffer",
        text = {
            "{C:red}Debuff{} cards",
            "in hand."
        }
    },
    pos = {x = 0, y = 0},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'hide',
    loc_txt = {
        name = "Hide",
        text = {
            "Draw cards",
            "{C:attention}face down{}"
        }
    },
    pos = {x = 1, y = 1},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'up',
    loc_txt = {
        name = "Up",
        text = {
            "Raise",
            "{C:attention}blind size{}"
        }
    },
    pos = {x = 2, y = 0},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'ring',
    loc_txt = {
        name = "Ring",
        text = {
            "Force {C:attention}cards{}",
            "to be selected"
        }
    },
    pos = {x = 0, y = 1},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'snatch',
    loc_txt = {
        name = "Snatch",
        text = {
            "{C:red}Discard{} cards",
            "in hand"
        }
    },
    pos = {x = 1, y = 0},
    config = {},
    atlas = "attack",
    -- loc_vars = function(self, info_queue, card)
    --     info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_package']
    --     return {vars = {(card and card.ability.max_highlighted or 2), localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_package')}}}
    -- end,
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'collapse',
    loc_txt = {
        name = "Collapse",
        text = {
            "{C:red}Downgrade{} a",
            "{C:attention}poker hand{}"
        }
    },
    pos = {x = 2, y = 1},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Loot {
    key = 'hand_refresh',
    loc_txt = {
        name = "Hand Refresh",
        text = {
            "Refresh {C:blue}Hands{}",
        }
    },
    pos = {x = 1, y = 0},
    config = {},
    atlas = "loot",
    loc_vars = function(self, info_queue, card)
        return {vars = {(card and card.ability.hands or 2)}}
    end,
    use = function(self, card, area, copier)
       ease_hands_played(G.GAME.round_resets.hands - G.GAME.current_round.hands_left)
    end,
}

SMODS.Loot {
    key = 'discard_refresh',
    loc_txt = {
        name = "Discard Refresh",
        text = {
            "Refresh {C:red}Discards{}",
        }
    },
    pos = {x = 2, y = 0},
    config = {discards = 2},
    atlas = "loot",
    loc_vars = function(self, info_queue, card)
        return {vars = {(card and card.ability.discards or 2)}}
    end,
    use = function(self, card, area, copier)
       ease_discard(G.GAME.round_resets.discards - G.GAME.current_round.discards_left)
    end,
}

SMODS.Loot {
    key = 'dollar_gain',
    loc_txt = {
        name = "Dollar Gain",
        text = {
            "{C:money}+$#1#{}",
        }
    },
    pos = {x = 0, y = 1},
    config = {money = 6},
    atlas = "loot",
    loc_vars = function(self, info_queue, card)
        return {vars = {(card and card.ability.money or 6)}}
    end,
    use = function(self, card, area, copier)
       ease_dollars(card and card.ability.money or 6)
    end,
}

SMODS.Loot {
    key = 'joker_create',
    loc_txt = {
        name = "Joker Maker",
        text = {
            "Create an",
            "{C:green}Uncommon{} {C:attention}Joker",
            "{C:inactive}(Must have room)"
        }
    },
    pos = {x = 1, y = 1},
    config = {},
    atlas = "loot",
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local card2 = SMODS.create_card{set = 'Joker', area = G.jokers, rarity = 0.83}
            card2:add_to_deck()
            G.jokers:emplace(card2)
            card:juice_up(0.3, 0.5)
            return true end }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit
    end,
}

SMODS.Booster {
    key = 'area_loot_1',
    group_key = 'k_loot_pack',
    loc_txt = {
        name = "Loot Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2# Loot{} cards to",
            "be used immediately"
        }
    },
    weight = 0,
    cost = 0,
    name = "Loot Pack",
    atlas = "boosters",
    pos = {x = 2, y = 1},
    config = {extra = 2, choose = 1, name = "Loot Pack"},
    create_card = function(self, card)
        return {set = "Loot"}
    end,
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
    discovered = true,
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Monday',
        text = { 'Cards drawn debuffed', 'after each hand' }
    },
    key = 'monday',
    config = {},
    boss = {min = 1, max = 10, astronaut = true}, 
    boss_colour = HEX("b4c6cd"),
    atlas = "blinds",
    name = "The Monday",
    pos = { x = 0, y = 1},
    vars = {},
    dollars = 5,
    mult = 2,
    stay_flipped = function(self, area, card)
        if (area == G.hand) and G.GAME.blind.prepped and not card.debuff then
            card.ability.temp_debuff = true
            card.ability.drawn_this_blind = true
            card:set_debuff()
        end
    end,
    press_play = function(self)
        if not G.GAME.blind.disabled then
            G.GAME.blind.triggered = true
            G.GAME.blind.prepped = true
        end
    end,
    defeat = function(self)
        for k, v in ipairs(G.playing_cards) do
            if v.ability.drawn_this_blind then
                v.ability.drawn_this_blind = nil
            end
        end
    end,
    disable = function(self)
        for k, v in ipairs(G.playing_cards) do
            if v.ability.drawn_this_blind then
                v.ability.drawn_this_blind = nil
            end
        end
    end,
    in_pool = function(self)
        return G.GAME.modifiers["astro_blinds"]
    end,
    recalc_debuff = function(self, card, from_blind)
        if card.ability.drawn_this_blind and not G.GAME.blind.disabled then
            return true
        end
        return false
    end,
    set_blind = function(self, reset, silent)
        if not reset then
            G.GAME.blind.prepped = false
        end
    end,
    discovered = true,
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Ganymede',
        text = { 'Cards only drawn face', 'up after each discard' }
    },
    key = 'ganymede',
    config = {},
    boss = {min = 1, max = 10, astronaut = true}, 
    boss_colour = HEX("c4b594"),
    atlas = "blinds",
    name = "The Ganymede",
    pos = { x = 0, y = 2},
    vars = {},
    dollars = 5,
    mult = 2,
    stay_flipped = function(self, area, card)
        if (area == G.hand) and G.GAME.blind.prepped then
            return true
        end
    end,
    press_play = function(self)
        if not G.GAME.blind.disabled then
            G.GAME.blind.prepped = true
        end
    end,
    set_blind = function(self, reset, silent)
        if not reset then
            G.GAME.blind.prepped = true
        end
    end,
    in_pool = function(self)
        return G.GAME.modifiers["astro_blinds"]
    end,
    discovered = true,
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Titan',
        text = { 'Only final hand', 'allowed' }
    },
    key = 'titan',
    config = {},
    boss = {min = 2, max = 10, astronaut = true}, 
    boss_colour = HEX("d3d28a"),
    atlas = "blinds",
    pos = { x = 0, y = 3},
    name = "The Titan",
    vars = {},
    dollars = 5,
    mult = 1.5,
    debuff_hand = function(self, cards, hand, handname, check)
        G.GAME.blind.triggered = true
        if G.GAME.current_round.hands_left > (check and 1 or 0) then
            return true
        end
    end,
    in_pool = function(self)
        return G.GAME.modifiers["astro_blinds"]
    end,
    discovered = true,
}

SMODS.Blind	{
    loc_txt = {
        name = 'The Triton',
        text = { 'Discarding sets', "money to $-100" }
    },
    key = 'triton',
    config = {},
    boss = {min = 1, max = 10, astronaut = true}, 
    boss_colour = HEX("737373"),
    atlas = "blinds",
    name = "The Triton",
    pos = { x = 0, y = 4},
    vars = {},
    dollars = 5,
    mult = 2,
    in_pool = function(self)
        return G.GAME.modifiers["astro_blinds"]
    end,
    discovered = true,
}

SMODS.Blind	{
    loc_txt = {
        name = 'Coral Well',
        text = { 'Convert all discards', 'to hands' }
    },
    key = 'coral_well',
    config = {},
    boss = {showdown = true, min = 2, max = 10, astronaut = true},
    showdown = true, 
    boss_colour = HEX("ff7f50"),
    atlas = "blinds",
    pos = { x = 0, y = 0},
    name = 'Coral Well',
    vars = {},
    dollars = 5,
    mult = 3,
    in_pool = function(self)
        return G.GAME.modifiers["astro_blinds"]
    end,
    set_blind = function(self, reset, silent)
        if not reset then
            self.discards_sub = G.GAME.current_round.discards_left
            self.hands_sub = -G.GAME.current_round.discards_left
            ease_hands_played(-self.hands_sub)
            ease_discard(-self.discards_sub)
        end
    end,
    defeat = function(self)
        ease_hands_played(self.hands_sub)
        ease_discard(self.discards_sub)
    end,
    disable = function(self)
        if not G.GAME.blind.disabled then
            ease_hands_played(self.hands_sub)
            ease_discard(self.discards_sub)
        end
    end,
    discovered = true,
}

-----Alchemist Stuff---------

SMODS.Element {
    key = 'm_lead',
    loc_txt = {
        name = "Lead",
        text = {
            "Enhances {C:attention}#1#",
            "selected cards to",
            "{C:attention}#2#s"
        }
    },
    atlas = "metal",
    pos = {x = 1, y = 0},
    config = {mod_conv = 'm_grm_lead', max_highlighted = 2},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_lead']
        return {vars = {(card and card.ability.max_highlighted or 2), localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_lead')}}}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
}

SMODS.Element {
    key = 'm_radium',
    loc_txt = {
        name = "Radium",
        text = {
            "Enhances a",
            "selected {C:attention}Common Card",
            "to a {C:attention}#1#"
        }
    },
    atlas = "metal",
    m_type = "Modern",
    pos = {x = 3, y = 0},
    config = {mod_conv = 'm_grm_radium', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = 'common_metal'}
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_radium']
        return {vars = {
            localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_radium')},
        }}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        (1 >= #G.hand.highlighted) and
        (G.hand.highlighted[1] and (G.hand.highlighted[1].ability.m_type == "Common"))
    end,
}

SMODS.Element {
    key = 'm_gold',
    loc_txt = {
        name = "Gold",
        text = {
            "Enhances a",
            "selected {C:attention}Common Card",
            "to a {C:attention}#1#"
        }
    },
    atlas = "metal",
    m_type = "Precious",
    pos = {x = 2, y = 0},
    config = {mod_conv = 'm_gold', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = 'common_metal'}
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_gold']
        return {vars = {
            localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_gold')},
        }}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        (1 >= #G.hand.highlighted) and
        (G.hand.highlighted[1] and (G.hand.highlighted[1].ability.m_type == "Common"))
    end,
}

SMODS.Element {
    key = 'm_platinum',
    loc_txt = {
        name = "Platinum",
        text = {
            "Enhances a",
            "selected {C:attention}Common Card",
            "to a {C:attention}#1#"
        }
    },
    atlas = "metal",
    m_type = "Precious",
    pos = {x = 4, y = 0},
    config = {mod_conv = 'm_grm_platinum', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = 'common_metal'}
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_platinum']
        return {vars = {
            localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_platinum')},
        }}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        (1 >= #G.hand.highlighted) and
        (G.hand.highlighted[1] and (G.hand.highlighted[1].ability.m_type == "Common"))
    end,
}

SMODS.Element {
    key = 'm_fire',
    loc_txt = {
        name = "Fire",
        text = {
            "Adds a {C:attention}Flint",
            "{C:green}Status{} to a",
            "{C:attention}selected card"
        }
    },
    atlas = "metal",
    status = "flint",
    pos = {x = 0, y = 1},
    config = {max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = 'flint'}
        return {vars = {}}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        (1 == #G.hand.highlighted)
    end,
}

SMODS.Element {
    key = 'm_water',
    loc_txt = {
        name = "Water",
        text = {
            "Adds a {C:attention}Subzero",
            "{C:green}Status{} to a",
            "{C:attention}selected card"
        }
    },
    atlas = "metal",
    status = "subzero",
    pos = {x = 1, y = 1},
    config = {max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = 'subzero'}
        return {vars = {}}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        (1 == #G.hand.highlighted)
    end,
}

SMODS.Element {
    key = 'm_rock',
    loc_txt = {
        name = "Rock",
        text = {
            "Adds a {C:attention}Rocky",
            "{C:green}Status{} to a",
            "{C:attention}selected card"
        }
    },
    atlas = "metal",
    status = "rocky",
    pos = {x = 2, y = 1},
    config = {max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = 'rocky'}
        return {vars = {}}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        (1 == #G.hand.highlighted)
    end,
}

SMODS.Element {
    key = 'm_air',
    loc_txt = {
        name = "Air",
        text = {
            "Adds a {C:attention}Gust",
            "{C:green}Status{} to a",
            "{C:attention}selected card"
        }
    },
    atlas = "metal",
    status = "gust",
    pos = {x = 3, y = 1},
    config = {max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = 'gust'}
        return {vars = {}}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        (1 == #G.hand.highlighted)
    end,
}

SMODS.Element {
    key = 'm_silver',
    loc_txt = {
        name = "Silver",
        text = {
            "Enhances a",
            "selected {C:attention}Common Card",
            "to a {C:attention}#1#"
        }
    },
    atlas = "metal",
    m_type = "Precious",
    pos = {x = 0, y = 2},
    config = {mod_conv = 'm_grm_silver', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = 'common_metal'}
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_silver']
        return {vars = {
            localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_silver')},
        }}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        (1 >= #G.hand.highlighted) and
        (G.hand.highlighted[1] and (G.hand.highlighted[1].ability.m_type == "Common"))
    end,
}

SMODS.Element {
    key = 'm_iron',
    loc_txt = {
        name = "Iron",
        text = {
            "Enhances {C:attention}#1#",
            "selected cards to",
            "{C:attention}#2#s"
        }
    },
    atlas = "metal",
    pos = {x =4, y = 1},
    config = {mod_conv = 'm_grm_iron', max_highlighted = 2},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_iron']
        return {vars = {(card and card.ability.max_highlighted or 2), localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_lead')}}}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
}

SMODS.Spectral {
    key = 'philosophy',
    loc_txt = {
        name = "Philosphy",
        text = {
            "{C:attention}Adds{} a {C:green}status{} to",
            "all {C:attention}cards in hand{}",
        }
    },
    name = "Philosphy",
    atlas = "metal",
    soul_set = 'Elemental',
    hidden = true,
    soul_rate = 0.01,
    pos = {x = 1, y = 2},
    use = function(self, card, area, copier)
        local used_tarot = card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.hand.cards do
            local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        for i=1, #G.hand.cards do
            local statuses = {flint = true, subzero = true, rocky = true, gust = true}
            G.hand.cards[i].ability.grm_status = G.hand.cards[i].ability.grm_status or {}
            if G.hand.cards[i].ability.grm_status then
                for j, k in pairs(G.hand.cards[i].ability.grm_status) do
                    statuses[j] = nil
                end
            end
            local valid = false
            for j, k in pairs(statuses) do
                valid = true
                break
            end
            if valid then
                local _, status = pseudorandom_element(statuses, pseudoseed('phil'))
                G.E_MANAGER:add_event(Event({func = function()
                    G.hand.cards[i].ability.grm_status[status] = true
                    if status == "gust" and G.hand.cards[i].highlighted then
                        G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + 1
                    end
                return true end }))
            end
        end 
        for i=1, #G.hand.cards do
            local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.5)
    end,
    can_use = function(self, card)
        return true
    end,
}

SMODS.Enhancement {
    key = 'radium',
    name = "Radium Card",
    loc_txt = {
        name = 'Radium Card',
        text = {
            "{C:green}#2# in #3#{} chance to",
            "destroy this card if held",
            "in hand at end of round",
            "Otherwise {C:purple}+#1#{} XP"
        }
    },
    atlas = 'enhance',
    config = {h_xp = 12, base_odds = 226, odds = 1600, m_type = "Modern"},
    pos = {x = 0, y = 1},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.h_xp or 12, (card and card.ability.base_odds or 226) * G.GAME.probabilities.normal, card and card.ability.odds or 1600}}
    end
}

SMODS.Enhancement {
    key = 'lead',
    name = "Lead Card",
    loc_txt = {
        name = 'Lead Card',
        text = {
            "Tends to be shuffled",
            "lower in the deck",
        }
    },
    atlas = 'enhance',
    config = {m_type = "Common"},
    pos = {x = 1, y = 1},
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist
    end
}

SMODS.Enhancement {
    key = 'platinum',
    name = "Platinum Card",
    loc_txt = {
        name = 'Platinum Card',
        text = {
            "{C:blue}+#1#{} Chips",
            "while this card",
            "stays in hand"
        }
    },
    atlas = 'enhance',
    config = {h_chips = 50, m_type = "Precious"},
    pos = {x = 2, y = 0},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.h_chips or 50}}
    end,
}

SMODS.Enhancement {
    key = 'iron',
    name = "Iron Card",
    loc_txt = {
        name = 'Iron Card',
        text = {
            "{X:red,C:white} X#1# {} Mult",
        }
    },
    atlas = 'enhance',
    config = {x_mult = 1.2, m_type = "Common"},
    pos = {x = 0, y = 2},
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.x_mult or 1.2}}
    end,
}

SMODS.Enhancement {
    key = 'silver',
    name = "Silver Card",
    loc_txt = {
        name = 'Silver Card',
        text = {
            "{C:money}+$#1#{}",
        }
    },
    atlas = 'enhance',
    config = {p_dollars = 2, m_type = "Precious"},
    pos = {x = 2, y = 1},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.p_dollars or 2}}
    end,
}

SMODS.Booster {
    key = 'ancient_normal_1',
    atlas = 'boosters',
    group_key = 'k_ancient_pack',
    loc_txt = {
        name = "Ancient Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Element{} cards to",
            "be used immediately"
        }
    },
    weight = 3,
    cost = 4,
    name = "Ancient Pack",
    pos = {x = 1, y = 0},
    config = {extra = 3, choose = 1, name = "Ancient Pack"},
    create_card = function(self, card)
        return {set = "Elemental", area = G.pack_cards, skip_materialize = true, soulable = true}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    draw_hand = true
}

SMODS.Booster {
    key = 'ancient_normal_2',
    atlas = 'boosters',
    group_key = 'k_ancient_pack',
    loc_txt = {
        name = "Ancient Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Element{} cards to",
            "be used immediately"
        }
    },
    weight = 3,
    cost = 4,
    name = "Ancient Pack",
    pos = {x = 2, y = 0},
    config = {extra = 3, choose = 1, name = "Ancient Pack"},
    create_card = function(self, card)
        return {set = "Elemental", area = G.pack_cards, skip_materialize = true, soulable = true}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    draw_hand = true
}

SMODS.Booster {
    key = 'ancient_jumbo_1',
    atlas = 'boosters',
    group_key = 'k_ancient_pack',
    loc_txt = {
        name = "Jumbo Ancient Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Element{} cards to",
            "be used immediately"
        }
    },
    weight = 3,
    cost = 6,
    name = "Ancient Pack",
    pos = {x = 0, y = 1},
    config = {extra = 5, choose = 1, name = "Ancient Pack"},
    create_card = function(self, card)
        return {set = "Elemental", area = G.pack_cards, skip_materialize = true, soulable = true}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    draw_hand = true
}

SMODS.Booster {
    key = 'ancient_mega_1',
    atlas = 'boosters',
    group_key = 'k_ancient_pack',
    loc_txt = {
        name = "Mega Ancient Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Element{} cards to",
            "be used immediately"
        }
    },
    weight = 1,
    cost = 8,
    name = "Ancient Pack",
    pos = {x = 1, y = 1},
    config = {extra = 5, choose = 2, name = "Ancient Pack"},
    create_card = function(self, card)
        return {set = "Elemental", area = G.pack_cards, skip_materialize = true, soulable = true}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    draw_hand = true
}

SMODS.Tag {
    key = 'philosopher',
    atlas = 'tags',
    loc_txt = {
        name = "Philosopher's Tag",
        text = {
            "Gives a free",
            "{C:attention}Mega Ancient Pack"
        }
    },
    pos = {x = 2, y = 0},
    min_ante = 2,
    apply = function(tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.FILTER,function() 
                local key = 'p_grm_ancient_mega_1'
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue+1] = {key = 'p_grm_ancient_mega_1', set = 'Other', vars = {2, 5}}
        return {}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist
    end,
    config = {type = 'new_blind_choice'}
}

SMODS.Joker {
    key = 'cohesion',
    name = "Cohesion",
    loc_txt = {
        name = "Cohesion",
        text = {
            "{C:red}+#1#{} Mult if hand contains",
            "{C:attention}#2#{} scoring cards of",
            "the same {C:green}status{}"
        }
    },
    rarity = 1,
    atlas = 'jokers',
    pos = {x = 0, y = 2},
    cost = 4,
    config = {extra = {mult = 12, value = 2}},
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability and card.ability.extra.mult or 12, card and card.ability and card.ability.extra.value or 2}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local valid = false
            local stauses = {}
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].ability.grm_status then
                    for i, j in pairs(context.scoring_hand[i].ability.grm_status) do
                        if stauses[i] then
                            valid = true
                            break
                        end
                        stauses[i] = true
                    end
                end
            end
            if valid then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'absolute_zero',
    name = "Absolute Zero",
    loc_txt = {
        name = "Absolute Zero",
        text = {
            "{C:attention}Subzero{} cards draw",
            "an additional card",
        }
    },
    rarity = 1,
    atlas = 'jokers',
    pos = {x = 1, y = 2},
    cost = 6,
    config = {},
    blueprint_compat = false,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'subzero', set = 'Other'}
        return {vars = {}}
    end,
}

SMODS.Joker {
    key = 'precious_joker',
    name = "Precious Joker",
    loc_txt = {
        name = "Precious Joker",
        text = {
            "Earn {C:money}$#1#{} at {C:attention}end of",
            "{C:attention}round{} for each {C:attention}Precious",
            "{C:attention}Card{} in your {C:attention}full deck",
            "{C:inactive}(Currently {C:money}$#2#{C:inactive})",
        }
    },
    rarity = 2,
    atlas = 'jokers',
    pos = {x = 2, y = 2},
    cost = 8,
    config = {dollar = 1},
    blueprint_compat = false,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'precious_metal', set = 'Other'}
        return {vars = {card.ability and card.ability.dollar or 1, card.ability and card.ability.precious_tally or 0}}
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability and (card.ability.precious_tally > 0) then
            return card.ability.precious_tally
        end
    end,
}

---- Astronaut Stuff ------

SMODS.Lunar {
    key = 'moon',
    loc_txt = {
        name = "Moon",
        text = {
            "Level {C:attention}#1#{}",
            "{C:attention}Debuffed{} cards gain",
            "{C:red}+#2#{} Mult when {C:attention}held{}",
            "{C:attention}in hand{}"
        }
    },
    atlas = "lunar",
    special_level = "debuff",
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1, 
            string.format("%.1f",(G.GAME.special_levels and (G.GAME.special_levels[self.special_level] + 1) or 1) * 0.5)
        }}
    end
}

SMODS.Lunar {
    key = 'callisto',
    loc_txt = {
        name = "Callisto",
        text = {
            "Level {C:attention}#1#{}",
            "{C:attention}Face down{} cards",
            "give {X:red,C:white} X#2# {} Mult when",
            "{C:attention}scored{}"
        }
    },
    atlas = "lunar",
    special_level = "face_down",
    pos = {x = 1, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1,
            string.format("%.2f",1 + 0.15 * (G.GAME.special_levels[self.special_level] + 1)),
        }}
    end
}

SMODS.Lunar {
    key = 'rhea',
    loc_txt = {
        name = "Rhea",
        text = {
            "Level {C:attention}#1#{}",
            "{C:attention}Disallowed{} hands have a",
            "{C:green}#2# in #3#{} chance to",
            "upgrade {C:attention}#4#{} levels,",
            "otherwise upgrades {C:attention}#5#{} levels"
        }
    },
    atlas = "lunar",
    special_level = "not_allowed",
    pos = {x = 2, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1, 
            G.GAME.probabilities.normal * ((G.GAME.special_levels[self.special_level] + 1) % 2),
            2,
            math.ceil((G.GAME.special_levels[self.special_level] + 1) / 2),
            math.floor((G.GAME.special_levels[self.special_level] + 1) / 2),
        }}
    end
}

SMODS.Lunar {
    key = 'oberon',
    loc_txt = {
        name = "Oberon",
        text = {
            "Level {C:attention}#1#{}",
            "Create a {C:attention}#2#{}",
            "when defeating a {C:attention}Boss{}",
            "{C:attention}Blind{}, scoring chips within",
            "{C:attention}#3#%{} of the {C:attention}requirement{}"
        }
    },
    atlas = "lunar",
    special_level = "overshoot",
    pos = {x = 3, y = 0},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'tag_negative', set = 'Tag'}
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1, 
            localize{type ='name_text', key = 'tag_negative', set = 'Tag'},
            1.5 * (G.GAME.special_levels[self.special_level] + 1),
        }}
    end
}

SMODS.Lunar {
    key = 'proteus',
    loc_txt = {
        name = "Proteus",
        text = {
            "Level {C:attention}#1#{}",
            "Refund {C:money}#2#%{} of lost",
            "{C:money}dollars{} during {C:attention}Boss Blinds{}",
            "{C:inactive}(rounds up){}",
        }
    },
    atlas = "lunar",
    special_level = "money",
    pos = {x = 0, y = 1},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1,
            10 * (G.GAME.special_levels[self.special_level] + 1),
        }}
    end
}

SMODS.Lunar {
    key = 'nix',
    loc_txt = {
        name = "Nix",
        text = {
            "{C:red}Nullify{} a random",
            "{C:attention}Boss Blind{}",
        }
    },
    atlas = "lunar",
    pos = {x = 1, y = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'nullified', set = 'Other'}
        return {vars = {}}
    end,
    use = function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not G.GAME.nullified_blinds[i] and not G.GAME.banned_keys[i] then
                table.insert(rngpick, i)
            end
        end
        local blind = "bl_small"
        if #rngpick > 0 then
            blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        end
        G.GAME.nullified_blinds[blind] = true
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize{type ='name_text', key = blind, set = 'Blind'},})
    end,
}

SMODS.Lunar {
    key = 'dysnomia',
    loc_txt = {
        name = "Dysnomia",
        text = {
            "Level {C:attention}#1#{}",
            "After defeating each",
            "{C:attention}Boss Blind{}, create {C:attention}#2#{}",
            "{C:dark_edition}Negative{} {C:blue}Lunar{}, {C:money}Stellar{},",
            "or {C:planet}Planet{} cards with",
            "{C:money}$1{} {C:attention}sell value{}"
        }
    },
    atlas = "lunar",
    special_level = "grind",
    pos = {x = 3, y = 1},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1,
            G.GAME.special_levels[self.special_level] + 1,
        }}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_orbit_2, {allow_duplicates = false}
    end
}

SMODS.Spectral {
    key = 'moon_x',
    loc_txt = {
        name = "Moon X",
        text = {
            "Increase every",
            "{C:legendary,E:1}lunar level",
            "by {C:attention}1{} level"
        }
    },
    atlas = "lunar",
    soul_set = 'Lunar',
    hidden = true,
    soul_rate = 0.01,
    pos = {x = 0, y = 2},
    soul_pos = {x = 1, y = 2},
    use = function(self, card, area, copier)
        for i, j in ipairs({'debuff', 'face_down', 'not_allowed', 'overshoot', 'money'}) do
            G.GAME.special_levels[j] = G.GAME.special_levels[j] + 1
        end
        if G.GAME.skills.sk_grm_orbit_2 then
            G.GAME.special_levels['grind'] = G.GAME.special_levels['grind'] + 1
        end
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize('k_upgrade_ex')})
    end,
    can_use = function(self, card)
        return true
    end,
}

SMODS.Stellar {
    key = 'sun',
    loc_txt = {
        name = "Sun",
        text = {
            "{C:attention}Upgrade{} {C:hearts}#1#{}",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
            "{C:inactive}({C:red}+#5#{}, {C:blue}+#6#{C:inactive})",
            "{C:inactive}(LVL {C:attention}#2#{C:inactive})",
        }
    },
    atlas = "stellar",
    special_level = "heart",
    pos = {x = 0, y = 0},
    config = {suit = "Hearts", mult = 0.35, chips = 1.8},
}

SMODS.Stellar {
    key = 'sirius',
    loc_txt = {
        name = "Sirius",
        text = {
            "{C:attention}Upgrade{} {C:diamonds}#1#{}",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
            "{C:inactive}({C:red}+#5#{}, {C:blue}+#6#{C:inactive})",
            "{C:inactive}(LVL {C:attention}#2#{C:inactive})",
        }
    },
    atlas = "stellar",
    special_level = "diamond",
    pos = {x = 1, y = 0},
    config = {suit = "Diamonds", mult = 0.3, chips = 2.5},
}

SMODS.Stellar {
    key = 'canopus',
    loc_txt = {
        name = "Canopus",
        text = {
            "{C:attention}Upgrade{} {C:spades}#1#{}",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
            "{C:inactive}({C:red}+#5#{}, {C:blue}+#6#{C:inactive})",
            "{C:inactive}(LVL {C:attention}#2#{C:inactive})",
        }
    },
    atlas = "stellar",
    special_level = "spade",
    pos = {x = 2, y = 0},
    config = {suit = "Spades", mult = 0.22, chips = 4},
}

SMODS.Stellar {
    key = 'alpha',
    loc_txt = {
        name = "Alpha Centauri",
        text = {
            "{C:attention}Upgrade{} {C:spades}#1#{}",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
            "{C:inactive}({C:red}+#5#{}, {C:blue}+#6#{C:inactive})",
            "{C:inactive}(LVL {C:attention}#2#{C:inactive})",
        }
    },
    atlas = "stellar",
    special_level = "club",
    pos = {x = 3, y = 0},
    config = {suit = "Clubs", mult = 0.45, chips = 1},
}

SMODS.Stellar {
    key = 'lp_944_20',
    loc_txt = {
        name = "LP 944-20",
        text = {
            "{C:attention}Upgrade{} {C:inactive}Nothing?{}",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
            "{C:inactive}({C:red}+#5#{}, {C:blue}+#6#{C:inactive})",
            "{C:inactive}(LVL {C:attention}#2#{C:inactive})",
        }
    },
    atlas = "stellar",
    special_level = "nothing",
    pos = {x = 1, y = 1},
    config = {suit = "Nothings", mult = 0.15, chips = 6},
    in_pool = function(self)
        return G.GAME.skills.sk_grm_orbit_2, {allow_duplicates = false}
    end
}

SMODS.Spectral {
    key = 'iron_core',
    loc_txt = {
        name = "Iron Core",
        text = {
            "{C:legendary,E:1}Upgrade{} a",
            "{C:attention}random suit{}",
            "by {C:attention}3{} levels"
        }
    },
    name = "Iron Core",
    atlas = "stellar",
    soul_set = 'Stellar',
    hidden = true,
    soul_rate = 0.01,
    pos = {x = 2, y = 1},
    use = function(self, card, area, copier)
        local suits = {"Hearts", "Diamonds", "Spades", "Clubs"}
        local suit2 = pseudorandom_element(suits, pseudoseed('iron'))
        local suit = string.sub(suit2:lower(),1,-2)
        stellar_mults = {
            club = {mult = 0.45, chips = 1},
            heart = {mult = 0.35, chips = 1.8},
            spade = {mult = 0.22, chips = 4},
            diamond = {mult = 0.3, chips = 2.5},
        }
        G.GAME.special_levels[suit] = G.GAME.special_levels[suit] + 3
        G.GAME.stellar_levels[suit .. "s"].chips = (G.GAME.special_levels and (G.GAME.special_levels[suit]) or 0) * stellar_mults[suit].chips
        G.GAME.stellar_levels[suit .. "s"].mult = (G.GAME.special_levels and (G.GAME.special_levels[suit]) or 0) * stellar_mults[suit].mult
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.MONEY, message = localize(suit2, 'suits_singular') .. "s"})
    end,
    can_use = function(self, card)
        return true
    end,
}

-------Explorer Stuff--------

SMODS.Area {
    key = 'classic',
    loc_txt = {
        name = "Classic",
        text = {
            "Return to",
            "normal gameplay",
        }
    },
    area = "Classic",
    atlas = "areas",
    pos = {x = 0, y = 0},
    norm_color = HEX("50846e"),
    endless_color = HEX("4f6367"),
    adjacent = {
        Metro = true,
    }
}

SMODS.Area {
    key = 'graveyard',
    loc_txt = {
        name = "Graveyard",
        text = {
            "{C:spectral}Spectral{} cards may",
            "appear in the shop,",
        }
    },
    area = "Graveyard",
    region = "Spooky",
    atlas = "areas",
    pos = {x = 1, y = 0},
    norm_color = HEX("6c8279"),
    endless_color = HEX("5e6769"),
    adjacent = {
        Metro = true
    }
}

SMODS.Area {
    key = 'plains',
    loc_txt = {
        name = "Plains",
        text = {
            "{C:money}-$#1#{} per remaining {C:blue}Hand{},",
            "{C:money}+$#2#{} per remaining {C:red}Discard",
            "at end of {C:attention}round{}"
        }
    },
    area = "Plains",
    atlas = "areas",
    pos = {x = 2, y = 0},
    norm_color = HEX("7e8450"),
    endless_color = HEX("566353"),
    config = {hand_dollars = 1, discard_dollars = 1},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.hand_dollars,
            card.ability.discard_dollars,
        }}
    end,
    adjacent = {
        Metro = true
    }
}

SMODS.Area {
    key = 'market',
    loc_txt = {
        name = "Market",
        text = {
            "{C:attention}+#1#{} shop slots",
            "All cards and packs in",
            "shop cost {C:attention}#2#%{} more"
        }
    },
    area = "Market",
    atlas = "areas",
    pos = {x = 3, y = 0},
    norm_color = HEX("41853d"),
    endless_color = HEX("373c66"),
    config = {slots = 2, upcount = 50},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.slots,
            card.ability.upcount,
        }}
    end,
    adjacent = {
        Metro = true
    }
}

SMODS.Area {
    key = 'landfill',
    loc_txt = {
        name = "Landfill",
        text = {
            "{C:red}+#1#{} discards per {C:attention}round{}",
            "{C:blue}-#2#{} hands per {C:attention}round{}",
        }
    },
    area = "Landfill",
    atlas = "areas",
    pos = {x = 4, y = 0},
    norm_color = HEX("846d50"),
    endless_color = HEX("696259"),
    config = {hands = 1, discards = 2},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.discards,
            card.ability.hands,
        }}
    end,
    adjacent = {
        Metro = true
    }
}

SMODS.Area {
    key = 'metro',
    loc_txt = {
        name = "Metro",
        text = {
            "Earn {C:purple}#1#%{} more XP",
            "No {C:attention}Shops{}"
        }
    },
    area = "Metro",
    region = "Metro",
    atlas = "areas",
    pos = {x = 1, y = 1},
    norm_color = HEX("725084"),
    endless_color = HEX("5f4f67"),
    config = {xp_buff = 100},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.xp_buff,
        }}
    end,
    adjacent = {
        Classic = true,
        Spooky = true,
        Sewer = true,
    }
}

SMODS.Area {
    key = 'ghost_town',
    loc_txt = {
        name = "Ghost Town",
        text = {
            "{C:green}#1# in #2#{} chance to",
            "earn {C:money}$#3#{} at cashout",
            "Earn no XP",
        }
    },
    area = "Ghost Town",
    region = "Spooky",
    atlas = "areas",
    pos = {x = 2, y = 1},
    config = {odds = 3, money = 15},
    norm_color = HEX("405b6c"),
    endless_color = HEX("434b68"),
    adjacent = {
        Metro = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.probabilities.normal,
            card.ability.odds,
            card.ability.money,
        }}
    end,
}

SMODS.Area {
    key = 'midnight',
    loc_txt = {
        name = "Midnight",
        text = {
            "Cards {C:attention}may{} be drawn",
            "{C:attention}face down{}, {C:attention}face down{}",
            "cards give {X:red,C:white} X#1# {} Mult on",
            "{C:attention}final hand{}",
        }
    },
    area = "Midnight",
    region = "Spooky",
    atlas = "areas",
    pos = {x = 3, y = 1},
    config = {grm_x_mult = 2.5},
    norm_color = HEX("5d5084"),
    endless_color = HEX("3a3266"),
    adjacent = {
        Metro = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.grm_x_mult,
        }}
    end,
}

SMODS.Area {
    key = 'dungeon',
    loc_txt = {
        name = "Dungeon",
        text = {
            "Every {C:attention}Boss Blind{}",
            "is a {C:attention}Showdown Blind{}",
        }
    },
    area = "Dungeon",
    region = "Sewer",
    atlas = "areas",
    pos = {x = 0, y = 2},
    config = {},
    norm_color = HEX("c2c1c1"),
    endless_color = HEX("737272"),
    adjacent = {
        Metro = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
        }}
    end,
}

SMODS.Area {
    key = 'tunnel',
    loc_txt = {
        name = "Tunnel",
        text = {
            "On {C:attention}first hand{} of round, {C:attention}upgrade{}",
            "your {C:attention}most played hand{} if it is",
            "played, otherwise {C:attention}half{} its level"
        }
    },
    area = "Tunnel",
    region = "Sewer",
    atlas = "areas",
    pos = {x = 1, y = 2},
    config = {},
    norm_color = HEX("c3c3ff"),
    endless_color = HEX("504f67"),
    adjacent = {
        Metro = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
        }}
    end,
}

SMODS.Area {
    key = 'toxic_waste',
    loc_txt = {
        name = "Toxic Waste",
        text = {
            "{C:red}+#1#{} discards per round",
            "On {C:attention}Play{}, {C:red}-#2#{} discard",
        }
    },
    area = "Toxic Waste",
    region = "Sewer",
    atlas = "areas",
    pos = {x = 4, y = 1},
    config = {discards = 2, degrade = 1},
    norm_color = HEX("d5f1b5"),
    endless_color = HEX("5f674f"),
    adjacent = {
        Metro = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.discards,
            card.ability.degrade,
        }}
    end,
}

SMODS.Area {
    key = 'aether',
    loc_txt = {
        name = "Aether",
        text = {
            "All cards and packs in",
            "shop are {C:attention}#1#%{} off,",
            "Earn {C:purple}#2#%{} more XP"
        }
    },
    area = "Aether",
    region = "Aether",
    atlas = "areas",
    pos = {x = 2, y = 2},
    config = {money_buff = 50, xp_buff = 50},
    norm_color = HEX("fff769"),
    endless_color = HEX("65674f"),
    adjacent = {
        Metro = true,
        Classic = true,
        Sewer = true,
        Spooky = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.money_buff,
            card.ability.xp_buff,
        }}
    end,
}

SMODS.Booster {
    key = 'area_normal_1',
    atlas = 'boosters',
    group_key = 'k_area_pack',
    loc_txt = {
        name = "Area Pack",
        text = {
            "Enter {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:green} Areas{}"
        }
    },
    weight = 0,
    cost = 1,
    name = "Area Pack",
    pos = {x = 0, y = 0},
    config = {extra = 2, choose = 1, name = "Area Pack"},
    create_card = function(self, card)
        if next(SMODS.find_card("j_grm_hyperspace")) and pseudorandom('odds') < 0.07 then
            return {key = "c_grm_aether"}
        end
        return {set = "Area"}
    end,
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Tag {
    key = 'grid',
    atlas = 'tags',
    loc_txt = {
        name = "Grid Tag",
        text = {
            "Gives a free",
            "{C:red}Area Pack"
        }
    },
    pos = {x = 1, y = 0},
    apply = function(tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.RED,function() 
                local key = 'p_grm_area_normal_1'
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue+1] = {key = 'p_grm_area_normal_1', set = 'Other', vars = {1, 2}}
        return {}
    end,
    in_pool = function(self)
        return false
    end,
    config = {type = 'new_blind_choice'}
}

SMODS.Joker {
    key = 'hyperspace',
    name = "Hyperspace",
    loc_txt = {
        name = "Hyperspace",
        text = {
            "{X:red,C:white} X#1# {} Mult"
        }
    },
    rarity = 2,
    atlas = 'jokers',
    pos = {x = 2, y = 0},
    cost = 4,
    config = {extra = {Xmult = 4}},
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_explorer, {allow_duplicates = false}
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME and (G.GAME.area == "Aether") then
            return {vars = {4}}
        else
            return {vars = {1}}
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and (G.GAME and (G.GAME.area == "Aether")) then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult,
            }
        end
    end
}

SMODS.Joker {
    key = 'tourist',
    name = "Tourist",
    loc_txt = {
        name = "Tourist",
        text = {
            "This Joker gains {X:mult,C:white} X#1# {} Mult",
            "for every {C:attention}unique",
            "{C:attention}Area{} visited",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
        }
    },
    rarity = 2,
    atlas = 'jokers',
    pos = {x = 1, y = 1},
    cost = 6,
    perishable_compat = false,
    config = {extra = {x_mult = 1, x_mult_mod = 0.75}},
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_explorer, {allow_duplicates = false}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability and card.ability.extra.x_mult_mod or 0.75, card and card.ability and card.ability.extra.x_mult or 1}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.visited = {}
    end,
    calculate = function(self, card, context)
        if context.joker_main and (card.ability.extra.x_mult > 1) then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
                Xmult_mod = card.ability.extra.x_mult,
            }
        end
        if context.visited_area and not card.ability.visited[context.visited_area] and not context.blueprint then
            card.ability.visited[context.visited_area] = true
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}}})
            return true
        end
    end
}

SMODS.Joker {
    key = 'brochure',
    name = "Brochure",
    loc_txt = {
        name = "Brochure",
        text = {
            "{C:attention}+#1#{} option in",
            "{C:attention}Area Packs{}",
        }
    },
    rarity = 1,
    atlas = 'jokers',
    blueprint_compat = false,
    pos = {x = 2, y = 1},
    cost = 5,
    config = {extra = 1},
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_explorer, {allow_duplicates = false}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability and card.ability.extra or 1}}
    end,
}

---------------------------------------

SMODS.Tag {
    key = 'xp',
    atlas = 'tags',
    loc_txt = {
        name = "XP Tag",
        text = {
            "{C:purple}+#1#{} XP"
        }
    },
    pos = {x = 0, y = 0},
    config = {type = 'immediate', amount = 100},
    apply = function(tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.PURPLE,function()
                add_skill_xp(100)
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    loc_vars = function(self, info_queue, tag)
        return {vars = {self.config.amount}}
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
    blueprint_compat = false,
    eternal_compat = false,
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

SMODS.Joker {
    key = 'showdown',
    name = "Showdown",
    loc_txt = {
        name = "Showdown",
        text = {
            "{C:green}Packed cards{} count towards",
            "played {C:attention}poker hand{}"
        }
    },
    rarity = 3,
    atlas = 'jokers',
    pos = {x = 1, y = 0},
    cost = 8,
    blueprint_compat = false,
    config = {},
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_hoarder, {allow_duplicates = false}
    end,
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

SMODS.Enhancement {
    key = 'package',
    loc_txt = {
        name = 'Package Card',
        text = {
            "When selected,",
            "You may {C:green}pack{}",
            "this {C:attention}card"
        }
    },
    atlas = 'enhance',
    config = {},
    pos = {x = 1, y = 0},
    in_pool = function(self)
        return false
    end,
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

SMODS.Stake {
    key = 'bismuth',
    name = "Bismuth Stake",
    atlas = "stakes",
    pos = {x = 1, y = 0},
    applied_stakes = {"gold"},
	loc_txt = {
        name = "Bismuth Stake",
        text = {
            "No shop after",
            "each {C:attention}Big Blind{}"
        },
        sticker = {
            name = "Bismuth Sticker",
            text = {
                "Used this Joker",
                "to win on {C:attention}Bismuth",
                "{C:attention}Stake{} difficulty"
            }
        }
    },
    modifiers = function()
        G.GAME.modifiers.no_big_shop = true
    end,
    colour = HEX("D184BC"),
    sticker_pos = {x = 1, y = 0},
    sticker_atlas = "stickers"
}

SMODS.Back {
    key = 'talent',
    loc_txt = {
        name = "Talented Deck",
        text = {
            "The {C:attention}first{} learned",
            "skill requires {C:attention}0{} XP",
        }
    },
    name = "Talented Deck",
    pos = { x = 0, y = 0 },
    atlas = 'decks',
    apply = function(self)
        G.GAME.free_skills = (G.GAME.free_skills or 0) + 1
    end
}

if CardSleeves and CardSleeves.Sleeve then
    CardSleeves.Sleeve {
        key = "taleneted_sl",
        name = "Talented Sleeve",
        atlas = "sleeves",
        loc_txt = {
            name = "Talented Sleeve",
            text = {
                "{C:attention}+1 free{} skill",
            }
        },
        pos = { x = 0, y = 0 },
        config = {},
        apply = function(self)
            G.GAME.free_skills = (G.GAME.free_skills or 0) + 1
        end,
    }
end

table.insert(G.CHALLENGES,#G.CHALLENGES+1,
    {name = 'Astro Dungeon',
        id = 'c_astro_dungeon',
        rules = {
            custom = {
                {id = 'no_hand_discard_reset'},
                {id = 'no_extra_hand_money'},
                {id = 'blind_attack'},
                {id = 'loot_pack'},
                {id = 'astro_blinds'},
                {id = 'force_astronaut'}
            },
            modifiers = {
                {id = 'hands', value = 8},
                {id = 'discards', value = 6},
                {id = 'force_stake_xp', value = 150},
            }
        },
        jokers = {       
        },
        consumeables = {
        },
        vouchers = {
        },
        deck = {
            type = 'Challenge Deck',
        },
        restrictions = {
            banned_cards = {
                {id = 'j_burglar'},
            },
            banned_tags = {
            },
            banned_other = {
                {id = 'bl_water', type = 'blind'},
                {id = 'bl_needle', type = 'blind'},
            }
        },
    }
)

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

function SMODS.current_mod.process_loc_text()
    G.localization.misc.dictionary["b_learn"] = "LEARN"
    G.localization.misc.challenge_names["c_astro_dungeon"] = "Astro Dungeon"
    G.localization.misc.v_text.ch_c_no_hand_discard_reset = {"{C:blue}Hands{} and {C:red}Discards{} are not reset automatically."}
    G.localization.misc.v_text.ch_c_blind_attack = {"Blinds may use {C:attention}Attack{} cards"}
    G.localization.misc.v_text.ch_c_astro_blinds = {"Only {C:attention}Astronaut{} blinds may show up."}
    G.localization.misc.v_text.ch_c_force_astronaut = {"You must play on the {C:attention}Astronaut{} class."}
    G.localization.misc.v_text.ch_c_loot_pack = {"Each shop has a free {C:attention}Loot Pack{}."}
    G.localization.misc.v_text.ch_m_force_stake_xp = {"{C:purple}#1#{} XP per Ante"}
    G.localization.descriptions.Other.ch_m_force_stake_xp2 = {name = "", text = {"{s:0.8,C:purple}#1#{s:0.8} XP per Ante"}}
    
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
                "to a {C:attention}Joker{} using",
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
        sk_grm_receipt_1 = {
            name = "Receipt I",
            text = {
                "Earn {C:money}$1{} for every",
                "{C:money}$7{} earned at {C:attention}cash out{}",
            }
        },
        sk_grm_receipt_2 = {
            name = "Receipt II",
            text = {
                "{C:attention}Vouchers{} and {C:attention}Booster Packs{}",
                "in shop are {C:attention}30%{} off"
            }
        },
        sk_grm_receipt_3 = {
            name = "Receipt III",
            text = {
                "Go up to",
                "{C:red}-$25{} in debt"
            }
        },
        sk_grm_dash_1 = {
            name = "Dash I",
            text = {
                "Each shop has",
                "a {C:attention}Standard Pack{}"
            }
        },
        sk_grm_dash_2 = {
            name = "Dash II",
            text = {
                "All {C:attention}Standard Packs{} have",
                "{X:attention,C:white} X2 {} options",
            }
        },
        sk_grm_cl_hoarder = {
            name = "Hoarder",
            text = {
                "{C:red}-1{} Hand Size",
                "You may {C:green}Pack{}",
                "cards."
            },
            unlock = {
                "Have {C:purple}2,000{} or",
                "more {C:attention}XP{}",
            }
        },
        sk_grm_cl_astronaut = {
            name = "Astronaut",
            text = {
                "{C:money}Stellar{} cards and {C:blue}Lunar{}",
                "cards can appear in",
                "{C:planet}Celestial{} packs",
            },
            unlock = {
                "Learn",
                "{C:planet}Gravity III{}",
            }
        },
        sk_grm_orbit_1 = {
            name = "Orbit I",
            text = {
                "{C:money}Stellar{} cards and {C:blue}Lunar{}",
                "cards can appear in",
                "the {C:attention}shop{}",
            }
        },
        sk_grm_orbit_2 = {
            name = "Orbit II",
            text = {
                "{C:attention}Dysnomia{} and {C:attention}LP 944-20{}",
                "can appear"
            }
        },
        sk_grm_cl_alchemist = {
            name = "Alchemist",
            text = {
                "{C:attention}Elements{} and",
                "{C:green}Statuses{} enabled",
            },
            unlock = {
                "Have at least {E:1,C:attention}52",
                "{E:1,C:attention}Wild Cards{} in",
                "your deck"
            }
        },
        sk_grm_cl_explorer = {
            name = "Explorer",
            text = {
                "After defeating each",
                "{C:attention}Boss Blind{}, gain a",
                "{C:attention}Grid Tag{}"
            },
            unlock = {
                "Win a run with",
                "{C:attention}10 skills{} learned",
            }
        },
        sk_grm_sticky_1 = {
            name = "Sticky I",
            text = {
                "{C:attention}Eternal Jokers{} cost",
                "{C:purple}100 XP{} to sell"
            }
        },
        sk_grm_sticky_2 = {
            name = "Sticky II",
            text = {
                "{C:attention}Perishable Jokers{} last",
                "{C:attention}3{} extra rounds"
            }
        },
        sk_grm_sticky_3 = {
            name = "Sticky III",
            text = {
                "{C:attention}Rental Jokers{} give",
                "{C:money}$3{} instead of {C:red}-$3{}"
            }
        },
        sk_grm_shelf_1 = {
            name = "Shelf I",
            text = {
                "{C:red}-1{} shop slot",
                "{C:attention}+2{} booster slots"
            }
        },
        sk_grm_shelf_2 = {
            name = "Shelf II",
            text = {
                "{C:attention}+1{} shop slot each",
                "shop until an item is",
                "{C:attention}purchased"
            }
        },
        sk_grm_prestige_1 = {
            name = "Prestige I",
            text = {
                "{C:attention}Unlearn{} all other skills",
                "{C:dark_edition}+1{} Legendary Token",
                "Must have {C:purple}2,500{} XP spent this run",
                "{C:inactive}({C:purple}#1#{C:inactive} XP spent this run)"
            },
            unlock = {
                "Learn a {C:red}Tier{}",
                "{C:red}III{} skill",
            }
        },
        sk_grm_blind_breaker = {
            name = "Blind Breaker",
            text = {
                "After {C:attention}main scoring{}, Gives",
                "{X:red,C:white} XMult {} equal to {C:blue}scored chips^0.15{}",
                "{C:inactive}(Minimum of {X:red,C:white} X1 {C:inactive})"
            }
        }
    }
    G.localization.descriptions.Other["flint"] = {
        name = "Flint",
        text = {
            "gains {C:red}+1{} Mult, when {C:attention}played{}",
            "{C:red}Expires when discarded!{}"
        }
    }
    G.localization.descriptions.Other["subzero"] = {
        name = "Subzero",
        text = {
            "{C:attention}+1{} drawn card this ",
            "{C:attention}hand{} when {C:attention}played{}",
            "{C:red}Expires when scored!{}"
        }
    }
    G.localization.descriptions.Other["rocky"] = {
        name = "Rocky",
        text = {
            "{C:attention}Scored{} cards permanently",
            "gain {C:blue}+3{} Chips",
            "{C:red}Expires when held in hand!{}"
        }
    }
    G.localization.descriptions.Other["gust"] = {
        name = "Gust",
        text = {
            "{C:dark_edition}+1{} play size",
            "{C:red}Expires when debuffed!{}"
        }
    }
    G.localization.descriptions.Other["aether"] = {
        name = "Ultimate",
        text = {
            "Statuses cannot expire",
        }
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
    G.localization.descriptions.Other["nullified"] = {
        name = "Nullified",
        text = {
            "Instantly disables",
        }
    }
    G.localization.descriptions.Other["unlearned_skill"] = {
        text = {
            "XP Needed:",
            "{C:purple}#1#{} XP",
        }
    }
    G.localization.descriptions.Other["unlearned_skill_free"] = {
        text = {
            "XP Needed:",
            "{C:purple}0{} XP {C:inactive}(#1#){}",
        }
    }
    G.localization.descriptions.Other["leg_unlearned_skill"] = {
        text = {
            "Tokens Needed:",
            "{C:dark_edition}#1#{} Legendary Token",
        }
    }
    G.localization.descriptions.Other["star_tooltip"] = {
        name = "Stellar Bonus",
        text = {
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#1#{} Chips",
        }
    }
    G.localization.descriptions.Other["card_extra_mult"] = 
        {
        text = {
            "{C:red}+#1#{} extra mult"
        }
    }
    for i = 0, 8 do
        G.localization.descriptions.Other["ante_" .. tostring(i) .. "_sticker"] = {
            name = "Ante " .. tostring(i) .. " Banner",
            text = {
                "Learned this Skill",
                "on {C:attention}Ante " .. tostring(i) .. "{}",
                "then won"
            }
        }
    end
    G.localization.descriptions.Other["ante_9_sticker"] = {
        name = "Banner",
        text = {
            "Learned this Skill",
            "then won"
        }
    }
    G.localization.descriptions.Other["ante_-1_sticker"] = {
        name = "Negative Banner",
        text = {
            "Learned this Skill",
            "on a {C:attention}negative{}",
            "{C:attention}Ante{} then won"
        }
    }
    G.localization.descriptions.Other["moon_level_desc"] = {
        text = {
            "Debuffed cards gain",
            "+#1# Mult when held",
            "in hand",
        }
    }
    G.localization.descriptions.Other["callisto_level_desc"] = {
        text = {
            "Face down cards",
            "give X#1# Mult when",
            "scored"
        }
    }
    G.localization.descriptions.Other["rhea_level_desc"] = {
        text = {
            "Disallowed hands upgrade",
            "#1# times on average",
        }
    }
    G.localization.descriptions.Other["oberon_level_desc"] = {
        text = {
            "Create a #1#",
            "when defeating a Boss",
            "Blind, scoring chips within",
            "#2#% of the requirement"
        }
    }
    G.localization.descriptions.Other["proteus_level_desc"] = {
        text = {
            "Refund #1#% of lost",
            "dollars during Boss Blinds",
        }
    }
    G.localization.descriptions.Other["dysnomia_level_desc"] = {
        text = {
            "After defeating each",
            "Boss Blind, create {C:attention}#1#{}",
            "Negative Lunar, Stellar,",
            "or Planet cards with",
            "{C:money}$1{} {C:attention}sell value{}"
        }
    }
    G.localization.descriptions.Other["common_metal"] = 
        {
        name = "Common",
        text = {
            "Card with a",
            "Common Enhancement"
        }
    }
    G.localization.descriptions.Other["precious_metal"] = 
        {
        name = "Precious",
        text = {
            "Card with",
            "a Precious",
            "Enhancement"
        }
    }
    G.localization.descriptions.Other["modern_metal"] = 
        {
        name = "Modern",
        text = {
            "Card with a",
            "Modern Enhancement",
        }
    }
    G.localization.misc.v_dictionary["skill_xp"] = "XP: #1#"
    G.localization.misc.v_dictionary["legendary_tokens"] = "Legendary Tokens: #1#"
    G.localization.misc.v_dictionary["gain_xp"] = "+#1# XP"
    G.localization.misc.v_dictionary["minus_xp"] = "-#1# XP"
    G.localization.misc.dictionary['k_skill'] = "Skill"
    G.localization.misc.dictionary['k_class'] = "Class"
    G.localization.misc.dictionary['k_inactive'] = "inactive"
    G.localization.misc.dictionary['nullified'] = "Nullified!"
    G.localization.misc.dictionary['k_ex_expired'] = "Expired!"
    G.localization.misc.dictionary['k_ex_decay'] = "Decayed!"
    G.localization.misc.labels['skill'] = "Skill"
    G.localization.misc.dictionary['b_skills'] = "Skills"
    G.localization.misc.dictionary['b_draw'] = "Draw"
    G.localization.misc.dictionary['b_pack'] = "Pack"
    G.localization.misc.dictionary['k_new_area'] = "New Area!"
    G.localization.misc.dictionary['k_area_pack'] = "Area Pack"
    G.localization.misc.dictionary['k_loot_pack'] = "Loot Pack"
    G.localization.misc.dictionary['k_ancient_pack'] = "Ancient Pack"
    G.localization.misc.v_dictionary["xp_interest"] = "#1# interest per #2# XP (#3# max)"
end

function set_skill_win()
    if not G.PROFILES[G.SETTINGS.profile].skill_banners then
        G.PROFILES[G.SETTINGS.profile].skill_banners = {}
    end
    if not grm_valid_mods() then
        check_for_unlock({type = 'skill_check', grm_run_won = true})
        return
    end
    for k, v in pairs(G.GAME.skills) do
        if G.GAME.ante_banners[k] then
            if G.PROFILES[G.SETTINGS.profile].skill_banners[k] and (G.PROFILES[G.SETTINGS.profile].skill_banners[k].ante > G.GAME.ante_banners[k]) then
                G.PROFILES[G.SETTINGS.profile].skill_banners[k] = G.PROFILES[G.SETTINGS.profile].skill_banners[k] or {ante = G.GAME.ante_banners[k]}
            elseif not G.PROFILES[G.SETTINGS.profile].skill_banners[k] then
                G.PROFILES[G.SETTINGS.profile].skill_banners[k] = {ante = G.GAME.ante_banners[k]}
            end
        end
    end
    check_for_unlock({type = 'skill_check'})
    G:save_settings()
end

function get_skill_win_banner(_center, ante)
    if G.PROFILES[G.SETTINGS.profile].skill_banners[_center.key] and
    G.PROFILES[G.SETTINGS.profile].skill_banners[_center.key].ante then 
        local _w = G.PROFILES[G.SETTINGS.profile].skill_banners[_center.key].ante
        if type(_w) ~= "number" then
            return
        end
        if (_w <= -1) then
            _w = -1
        end
        if (_w > 8) then
            _w = 9
        end
        _w = math.floor(_w)
        if ante then return _w end
        return "ante_" .. tostring(_w)
    end
    if ante then return -2 end
end

function grm_valid_mods()
    for i, j in pairs(SMODS.Mods) do
        if j.can_load and not j.disabled and (i ~= "GRM") and (i ~= "Talisman") and (i ~= "Steamodded") and (i ~= "nopeus") and (i ~= "Handy") then
            return false
        end
    end
    return true
end

function add_custom_round_eval_row(name, foot, intrest, the_colour)
    the_colour = the_colour or G.C.PURPLE
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
                table.insert(left_text, {n=G.UIT.T, config={text = intrest, scale = 0.8*scale, colour = the_colour, shadow = true, juice = true}})
            end
            if intrest then
                table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = name, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})
            else
                table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = name, colours = {the_colour}, shadow = true, pop_in = 0, scale = 0.6*scale, silent = true})}})
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
                            {n=G.UIT.O, config={object = DynaText({string = {foot}, colours = {the_colour}, shadow = true, pop_in = 0, scale = 0.65, float = true})}}
                        }},
                        G.round_eval:get_UIE_by_ID('dollar_grm_'..name .. tostring(total_cashout_rows)))
            play_sound('coin3', 0.9+0.2*math.random(), 0.7)
            play_sound('coin6', 1.3, 0.8)
            return true
        end
    }))
end

function upgrade_poker_hand_showdown(text, scoring_hand, j_card)
    local new_hand = {}
    for i, j in ipairs(G.play.cards) do
        new_hand[#new_hand+1] = j
    end
    for i, j in ipairs(G.consumeables.cards) do
        if j.playing_card then
            new_hand[#new_hand+1] = j
        end
    end
    local new_text,new_disp_text,new_poker_hands,new_scoring_hand,new_non_loc_disp_text = G.FUNCS.get_poker_hand_info(new_hand)
    for i=#new_scoring_hand, 1,-1 do
        if new_scoring_hand[i].area == G.consumeables then
            table.remove(new_scoring_hand, i)
        end
    end
    local splash = next(find_joker('Splash'))
    if not splash then
        local pures = {}
        for i=1, #G.play.cards do
            if G.play.cards[i].ability.effect == 'Stone Card' or G.play.cards[i].config.center.always_scores then
                local inside = false
                for j=1, #scoring_hand do
                    if new_scoring_hand[j] == G.play.cards[i] then
                        inside = true
                    end
                end
                if not inside then table.insert(pures, G.play.cards[i]) end
            end
        end
        for i=1, #pures do
            table.insert(new_scoring_hand, pures[i])
        end
        table.sort(new_scoring_hand, function (a, b) return a.T.x < b.T.x end )
    end
    for i=1, #scoring_hand do
        local card = scoring_hand[i]
        card.prev_scored = true
    end
    for i=1, #new_scoring_hand do
        local card = new_scoring_hand[i]
        card.grm_scored = true
        if not card.prev_scored then
            highlight_card(card,(i-0.999)/5,'up')
        end
    end
    for i=1, #G.play.cards do
        local card = G.play.cards[i]
        if not card.grm_scored and card.prev_scored then
            highlight_card(card,(i-0.999)/5,'down')
        end
    end
    if text ~= new_text then
        card_eval_status_text(j_card, 'jokers', nil, nil, nil, {colour = G.C.RED, message = localize('k_upgrade_ex')})
        delay(0.4)
        G.GAME.hands[text].played = G.GAME.hands[text].played - 1
        G.GAME.hands[text].played_this_round = G.GAME.hands[text].played_this_round - 1
        G.GAME.hands[new_text].played = G.GAME.hands[new_text].played + 1
        G.GAME.hands[new_text].played_this_round = G.GAME.hands[new_text].played_this_round + 1
        G.GAME.last_hand_played = new_text
        G.GAME.hands[new_text].visible = true
        update_hand_text({sound = 'button', volume = 0.4, nopulse = nil, delay = 0.4}, {handname=new_disp_text, level=G.GAME.hands[new_text].level, mult = G.GAME.hands[new_text].mult, chips = G.GAME.hands[new_text].chips})
    end
    return new_text,new_disp_text,new_poker_hands,new_scoring_hand,new_non_loc_disp_text
end

function moon_row(moon)
    local desc_nodes = {}
    local loc_vars = {}
    local moon_name = ""
    local stat_text = ""
    local stat_color = G.C.FILTER
    local level = 0
    if moon == 'c_grm_moon' then
        loc_vars = {
            string.format("%.1f",(G.GAME.special_levels and (G.GAME.special_levels["debuff"]) or 0) * 0.5)
        }
        desc_nodes = localize{type = 'raw_descriptions', key = 'moon_level_desc', set = "Other", vars = loc_vars}
        moon_name = localize{type = 'name_text', key = moon, set = "Lunar"}
        stat_text = "+" .. loc_vars[1]
        stat_color = G.C.RED
        level = G.GAME.special_levels["debuff"] + 1
    elseif moon == 'c_grm_callisto' then
        loc_vars = {
            string.format("%.2f",1 + 0.15 * (G.GAME.special_levels and G.GAME.special_levels["face_down"] or 0))
        }
        desc_nodes = localize{type = 'raw_descriptions', key = 'callisto_level_desc', set = "Other", vars = loc_vars}
        moon_name = localize{type = 'name_text', key = moon, set = "Lunar"}
        stat_text = "X" .. loc_vars[1]
        stat_color = G.C.RED
        level = G.GAME.special_levels["face_down"] + 1
    elseif moon == 'c_grm_rhea' then
        loc_vars = {
            string.format("%.1f",0.5 * (G.GAME.special_levels and G.GAME.special_levels["not_allowed"] or 0))
        }
        desc_nodes = localize{type = 'raw_descriptions', key = 'rhea_level_desc', set = "Other", vars = loc_vars}
        moon_name = localize{type = 'name_text', key = moon, set = "Lunar"}
        stat_text = loc_vars[1]
        stat_color = G.C.GREEN
        level = G.GAME.special_levels["not_allowed"] + 1
    elseif moon == 'c_grm_oberon' then
        loc_vars = {
            localize{type ='name_text', key = 'tag_negative', set = 'Tag'},
            1.5 * (G.GAME.special_levels and G.GAME.special_levels["overshoot"] or 0),
        }
        desc_nodes = localize{type = 'raw_descriptions', key = 'oberon_level_desc', set = "Other", vars = loc_vars}
        moon_name = localize{type = 'name_text', key = moon, set = "Lunar"}
        stat_text = loc_vars[2] .. "%"
        stat_color = G.C.IMPORTANT
        level = G.GAME.special_levels["overshoot"] + 1
    elseif moon == 'c_grm_proteus' then
        loc_vars = {
            10 * (G.GAME.special_levels and G.GAME.special_levels["money"] or 0),
        }
        desc_nodes = localize{type = 'raw_descriptions', key = 'proteus_level_desc', set = "Other", vars = loc_vars}
        moon_name = localize{type = 'name_text', key = moon, set = "Lunar"}
        stat_text = loc_vars[1] .. "%"
        stat_color = G.C.MONEY
        level = G.GAME.special_levels["money"] + 1
    elseif moon == 'c_grm_dysnomia' then
        loc_vars = {
            (G.GAME.special_levels and G.GAME.special_levels["grind"] or 0),
        }
        desc_nodes = localize{type = 'raw_descriptions', key = 'dysnomia_level_desc', set = "Other", vars = loc_vars}
        moon_name = localize{type = 'name_text', key = moon, set = "Lunar"}
        stat_text = loc_vars[1]
        stat_color = G.C.PURPLE
        level = G.GAME.special_levels["grind"] + 1
    end
    return {n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.1, colour = darken(G.C.JOKER_GREY, 0.1), emboss = 0.05, hover = true, force_focus = true, on_demand_tooltip = {text = desc_nodes}}, nodes={
        {n=G.UIT.C, config={align = "cl", padding = 0, minw = 5}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.IMPORTANT, minw = 1.5, outline = 0.8, outline_colour = G.C.WHITE}, nodes={
                {n=G.UIT.T, config={text = localize('k_level_prefix')..(level), scale = 0.5, colour = G.C.UI.TEXT_DARK}}
            }},
            {n=G.UIT.C, config={align = "cm", minw = 4.5, maxw = 4.5}, nodes={
                {n=G.UIT.T, config={text = ' '..moon_name, scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }}
        }},
        {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.BLACK,r = 0.1}, nodes={
            {n=G.UIT.C, config={align = "cr", padding = 0.01, r = 0.1, colour = stat_color, minw = 1.1}, nodes={
                {n=G.UIT.T, config={text = stat_text, scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
                {n=G.UIT.B, config={w = 0.08, h = 0.01}}
            }},
        }}
    }}
end

function create_UIBox_current_lunar_stats()
    local moons = {
        moon_row("c_grm_moon"),
        moon_row("c_grm_callisto"),
        moon_row("c_grm_rhea"),
        moon_row("c_grm_oberon"),
        moon_row("c_grm_proteus"),
    }
    if G.GAME.special_levels and G.GAME.special_levels["grind"] > 0 then
        table.insert(moons, moon_row("c_grm_dysnomia"))
    end
  
    local t = {n=G.UIT.ROOT, config={align = "cm", minw = 17, minh = 7, padding = 0.1, r = 0.1, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.04}, nodes=
            moons
        },
        nullified_blinds_sect()
    }}
  
    return create_UIBox_generic_options({ back_func = 'skills_page_direct', contents = {t}})
end

function nullified_blinds_sect()
    if not use_page then
        skills_page = nil
    end
    local blind_matrix = {
        {},{},{}
    }
    local blind_tab = {}
    for k, v in pairs(G.GAME.nullified_blinds) do
        blind_tab[#blind_tab+1] = G.P_BLINDS[k]
    end


    table.sort(blind_tab, function (a, b) return a.order < b.order end)
    local blind_tab2 = {}
    for i = ((skills_page or 1) - 1) * 12 + 1, (skills_page or 1) * 12 do
        blind_tab2[#blind_tab2+1] = blind_tab[i]
    end

    local blinds_to_be_alerted = {}
    for k, v in ipairs(blind_tab2) do
        local discovered = true
        local temp_blind = AnimatedSprite(0,0,1.3,1.3, G.ANIMATION_ATLAS[v.atlas or 'blind_chips'], discovered and v.pos or G.b_undiscovered.pos)
        temp_blind:define_draw_steps({
            {shader = 'dissolve', shadow_height = 0.05},
            {shader = 'dissolve'}
        })
        if k == 1 then 
            G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                G.CONTROLLER:snap_to{node = temp_blind}
                return true
            end)
            }))
        end
        temp_blind.float = true
        temp_blind.states.hover.can = true
        temp_blind.states.drag.can = false
        temp_blind.states.collide.can = true
        temp_blind.config = {blind = v, force_focus = true}
        if discovered and not v.alerted then 
            blinds_to_be_alerted[#blinds_to_be_alerted+1] = temp_blind
        end
        temp_blind.hover = function()
            if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
                if not temp_blind.hovering and temp_blind.states.visible then
                    temp_blind.hovering = true
                    temp_blind.hover_tilt = 3
                    temp_blind:juice_up(0.05, 0.02)
                    play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
                    temp_blind.config.h_popup = create_UIBox_blind_popup(v, discovered)
                    temp_blind.config.h_popup_config ={align = 'cl', offset = {x=-0.1,y=0},parent = temp_blind}
                    Node.hover(temp_blind)
                    if temp_blind.children.alert then 
                        temp_blind.children.alert:remove()
                        temp_blind.children.alert = nil
                        temp_blind.config.blind.alerted = true
                        G:save_progress()
                    end
                end
            end
            temp_blind.stop_hover = function() temp_blind.hovering = false; Node.stop_hover(temp_blind); temp_blind.hover_tilt = 0 end
        end
        blind_matrix[math.ceil((k-1)/4+0.001)][1+((k-1)%4)] = {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
            (k==5) and {n=G.UIT.B, config={h=0.2,w=0.5}} or nil,
            {n=G.UIT.O, config={object = temp_blind, focus_with_object = true}},
            (k==4 or k == 12) and {n=G.UIT.B, config={h=0.2,w=0.5}} or nil,
        }} 
    end

    local blind_options = {}
    for i = 1, math.ceil(#blind_tab/12) do
      table.insert(blind_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#blind_tab/20)))
    end
    if #blind_options == 0 then
        blind_options = {localize('k_page')..' 1/1'}
    end

    local t = 
    {n=G.UIT.C, config={align = "cm"}, nodes={
        {n=G.UIT.R, config={align = "cm", minh = 0.4}, nodes={
            {n=G.UIT.T, config={scale = 0.8,text = "Nullified Blinds", colour = G.C.UI.TEXT_LIGHT, padding = 0.1}}
        }},
        {n=G.UIT.R, config={align = "cm", minw = 3, minh = 4.5, padding = 0.1, colour = G.C.BLACK, emboss = 0.05,r = 0.1}, nodes={
          {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[1]},
          {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[2]},
          {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[3]},
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
            create_option_cycle({options = blind_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_nullified_blinds_page', focus_args = {snap_to = true, nav = 'wide'},current_option = skills_page or 1, colour = G.C.RED, no_pips = true})
        }}
    }}
    return t
end

function CardArea:dragLead()
    if self.cards and (self.config.type == 'deck') then
        local lead = {}
        for i, j in ipairs(self.cards) do
            if j.ability and j.ability.name == 'Lead Card' then
                table.insert(lead, i)
            end
        end
        local k = #self.cards
        for i, j in ipairs(lead) do
            local landing = j
            local count = 0
            local l = k / 2
            l = math.floor(pseudorandom('lead') * k / 2)
            while ((landing > 1)) and (count < l) do
                if not (self.cards[landing].ability and (self.cards[landing].ability.name == 'Lead Card')) then
                    count = count + 1
                end
                k = k + 1
                landing = landing - 1
            end
            self.cards[landing], self.cards[j] = self.cards[j], self.cards[landing]
        end
    end
end

function Card:get_chip_h_chips()
    if self.debuff then return 0 end
    return self.ability.h_chips or 0
end

G.FUNCS.your_lunar_stats = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_current_lunar_stats(),
    }
end

G.FUNCS.skills_page_direct = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = G.UIDEF.run_info(),
    }
end

G.FUNCS.your_nullified_blinds_page = function(args)
    if not args or not args.cycle_config then return end
    skills_page = args.cycle_config.current_option
    G.SETTINGS.paused = true
    use_page = true
    G.FUNCS.overlay_menu{
      definition = create_UIBox_current_lunar_stats(),
    }
    use_page = nil
end

----------------------------------------------
------------MOD CODE END----------------------