--- STEAMODDED HEADER
--- MOD_NAME: Grim
--- MOD_ID: GRM
--- PREFIX: grm
--- MOD_AUTHOR: [mathguy]
--- MOD_DESCRIPTION: Skill trees in Balatro! Thank you to Mr.Clover for Taiwanese Mandarin translation
--- VERSION: 1.1.0
----------------------------------------------
------------MOD CODE -------------------------

if not IncantationAddons then
	IncantationAddons = {
		Stacking = {},
		Dividing = {},
		BulkUse = {},
		StackingIndividual = {},
		DividingIndividual = {},
		BulkUseIndividual = {}
	} 
end

table.insert(IncantationAddons.Stacking, "Lunar")
table.insert(IncantationAddons.Stacking, "Stellar")
table.insert(IncantationAddons.Dividing, "Lunar")
table.insert(IncantationAddons.Dividing, "Stellar")
table.insert(IncantationAddons.BulkUse, "Lunar")
table.insert(IncantationAddons.BulkUse, "Stellar")

local areaType = SMODS.ConsumableType {
    key = 'Area',
    loc_txt = {},
    primary_colour = G.C.GREEN,
    secondary_colour = G.C.GREEN,
    collection_rows = { 4, 4 },
    shop_rate = 0,
    default = "c_grm_classic"
}

local lunarType = SMODS.ConsumableType {
    key = 'Lunar',
    loc_txt = {},
    primary_colour = HEX('505A8D'),
    secondary_colour = HEX('7F82C4'),
    collection_rows = { 4, 4 },
    shop_rate = 0,
    default = "c_grm_moon"
}

local stellarType = SMODS.ConsumableType {
    key = 'Stellar',
    loc_txt = {},
    primary_colour = HEX('AAA65B'),
    secondary_colour = HEX('D2CE84'),
    collection_rows = { 3, 2 },
    shop_rate = 0,
    default = "c_grm_sun"
}

local elementType = SMODS.ConsumableType {
    key = 'Elemental',
    loc_txt = {},
    primary_colour = HEX('e9e4d3'),
    secondary_colour = HEX('e9e4d3'),
    collection_rows = { 4, 4 },
    shop_rate = 0,
    default = "c_grm_m_lead"
}

local attackType = SMODS.ConsumableType {
    key = 'Attack',
    loc_txt = {},
    primary_colour = HEX('E9D3D3'),
    secondary_colour = HEX('E9D3D3'),
    collection_rows = { 4, 4 },
    shop_rate = 0,
    default = "c_grm_debuff"
}

local lootType = SMODS.ConsumableType {
    key = 'Loot',
    loc_txt = {},
    primary_colour = HEX('7190A6'),
    secondary_colour = HEX('7190A6'),
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
    bulk_use = function(self, card, area, copier, number)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + number
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
            ((self.config.suit == "Fleurons") or (self.config.suit == "Halberds")) and (self.config.suit) or localize(self.config.suit, 'suits_plural'),
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
    end,
    set_badges = function(self, card, badges)
        local colours = {
            Classic = HEX('115f15'),
            Sewer =  HEX('9ae4b5'),
            Spooky = HEX("6317a8"),
            Metro = HEX("d8aeff"),
            Aether = HEX("ffffd0"),
        }
        local len = string.len(card.config.center.region)
        local size = 1.3 - (len > 5 and 0.02 * (len - 5) or 0)
        if card.config.center.discovered then
            badges[#badges + 1] = create_badge(localize("region_" .. card.config.center.region:lower()), colours[card.config.center.region], nil, size)
        end
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
        count = G.ACTIVE_MOD_UI and modsCollectionTally(G.P_CENTER_POOLS['Skill']),
        button = 'your_collection_skills', label = {"Skills"}, count = G.ACTIVE_MOD_UI and modsCollectionTally(G.P_CENTER_POOLS['Skill']), minw = 5, id = 'your_collection_skills'
    }}
end

SMODS.current_mod.set_debuff = function(card)
    if skill_active("sk_grm_motley_1") and ((card.ability.name == 'Wild Card') or (skill_active("sk_grm_motley_3") and (card.config.center ~= G.P_CENTERS.c_base))) then
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

function get_skills(during_game)
    local shown_skills = {}
    for i, j in ipairs(G.P_CENTER_POOLS['Skill']) do
        local layer = get_skill_layer(j.key)
        j.layer = layer
        if not shown_skills[layer] then
            shown_skills[layer] = {offset = 0, tier = layer}
        end
        if during_game and not G.GAME.hide_unlearnable then
            shown_skills[layer][#shown_skills[layer] + 1] = j.key
        else
            local valid = true
            if j.prereq then
                for i2, j2 in ipairs(j.prereq) do
                    if not during_game or not G.GAME.skills[j2] then
                        valid = false
                    end
                end
            end
            if valid then
                shown_skills[layer][#shown_skills[layer] + 1] = j.key
            end
        end
    end
    return shown_skills
end

function refresh_skill_menu_skills()
    local offsets = {}
    offsets[1] = G.GAME.skill_tree_data[1].offset
    offsets[2] = G.GAME.skill_tree_data[2].offset
    offsets[3] = G.GAME.skill_tree_data[3].offset
    G.GAME.skill_tree_data = get_skills(true)
    for i = 1, 3 do
        if offsets[i] + 5 > #G.GAME.skill_tree_data[i] then
            offsets[i] = math.max(0, #G.GAME.skill_tree_data[i] - 5)
        end
    end
    G.GAME.skill_tree_data[1].offset = offsets[1]
    G.GAME.skill_tree_data[2].offset = offsets[2]
    G.GAME.skill_tree_data[3].offset = offsets[3]
    for i = 1, 3 do
        local offset = G.GAME.skill_tree_data[i].offset
        skills = {offset = offset, tier = i}
        for j = offset + 1, offset + 5 do
            if G.GAME.skill_tree_data[i][j] then
                table.insert(skills, G.GAME.skill_tree_data[i][j])
            end
        end
        for j = 5, 1, -1 do
            if G.areas[i].cards[j] then
                G.areas[i].cards[j]:remove()
            end
        end
        for k, j in ipairs(skills) do
            local center = G.P_SKILLS[j]
            local card = Card(G.areas[i].T.x + G.areas[i].T.w/2, G.areas[i].T.y, G.CARD_W, G.CARD_H, nil, center)
            card:start_materialize()
            if G.GAME.skill_debuffs[center.key] then
                card.debuff = true
            end
            G.areas[i]:emplace(card)
        end
    end
end

function get_skill_layer(direct_)
    local tier = 1
    local skill = G.P_SKILLS[direct_]
    if skill.layer then
        return skill.layer
    end
    if skill then
        for i, j in ipairs(skill.prereq) do
            local skill2 = G.P_SKILLS[j]
            if skill2.branch ~= skill.branch then
                tier = math.max(get_skill_layer(j) + 1, tier)
            else
                tier = math.max(get_skill_layer(j), tier)
            end
        end
    end
    return math.min(3, tier)
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

function learn_skill(card, direct_, debuffing)
    local obj, key = "", ""
    if direct_ then
        obj = G.P_SKILLS[direct_]
        key = direct_
    else
        obj = card.config.center
        key = obj.key
    end
    if not debuffing then
        G.GAME.skills[key] = true
    end
    if G.GAME.ante_banners and not G.GAME.ante_banners[key] then
        G.GAME.ante_banners[key] = G.GAME.round_resets.ante
    end
    if not obj.class and (G.GAME.free_skills and (G.GAME.free_skills > 0)) then
        G.GAME.free_skills = G.GAME.free_skills - 1
    elseif not debuffing then
        G.GAME.skill_xp = G.GAME.skill_xp - obj.xp_req
        G.GAME.xp_spent = (G.GAME.xp_spent or 0) + obj.xp_req
    end
    if obj.token_req and not debuffing then
        G.GAME.legendary_tokens = G.GAME.legendary_tokens - obj.token_req
    end
    check_for_unlock({type = 'skill_check', learned_skill = key, learned_tier = obj.tier})
    if card then
        discover_card(obj)
        card:set_sprites(obj)
    end
    if key == "sk_grm_ease_1" then
        G.GAME.scaling_multipliers.ease1 = 0.9
        fix_ante_scaling()
    elseif key == "sk_grm_ease_2" then
        G.GAME.scaling_multipliers.ease2 = 0.8
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
        G.GAME.orig_joker_rate = G.GAME.joker_rate
    elseif key == "sk_grm_ghost_1" then
        G.hand:change_size(-1)
    elseif key == "sk_grm_ghost_2" then
        G.hand:change_size(-2)
    elseif key == "sk_grm_chime_3" then
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
        ease_hands_played(-1)
        if ((G.GAME.round_resets.ante) % 3 == 0) and not G.GAME.reset_antes3[G.GAME.round_resets.ante] then
            G.GAME.reset_antes3[G.GAME.round_resets.ante] = true
            ease_ante(-1, true)
            if skill_active("sk_grm_stake_3") then
                G.GAME.scaling_multipliers.stake = 1.3 ^ G.GAME.round_resets.ante
                fix_ante_scaling()
            end
        end
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
        if skill_active("sk_grm_stake_3") then
            G.GAME.scaling_multipliers.stake = 1.3 ^ G.GAME.round_resets.ante
            fix_ante_scaling()
        end
    elseif key == "sk_grm_chime_2" and ((G.GAME.round_resets.ante) % 4 == 0) and not G.GAME.reset_antes2[G.GAME.round_resets.ante] then
        G.GAME.reset_antes2[G.GAME.round_resets.ante] = true
        ease_ante(-1, true)
        if skill_active("sk_grm_stake_3") then
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
        if not debuffing then
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
        else
            G.GAME.legendary_tokens = (G.GAME.legendary_tokens or 0) + 1
        end
    elseif key == "sk_grm_dash_1" then
        if G.GAME.force_grm_packs then
            table.insert(G.GAME.force_grm_packs, "Standard")
        end
    elseif key == "sk_grm_midas_touch" then
        for i, j in ipairs(G.playing_cards) do
            j:set_ability(G.P_CENTERS.m_gold)
        end
        if G.pack_cards and G.pack_cards.cards then
            for i, j in ipairs(G.pack_cards.cards) do
                j:set_ability(G.P_CENTERS.m_gold)
            end
        end
    elseif key == "sk_cry_ace_1" then
        pseudoseed("cry_crash")
    elseif key == "sk_cry_m_3" then
        if #G.jokers.cards < G.jokers.config.card_limit then
            local card = SMODS.create_card { key = "j_grm_jolly_jimball" }
            card:add_to_deck()
            G.jokers:emplace(card)
        end
    elseif key == "sk_poke_energetic_1" then
        G.GAME.energy_plus = (G.GAME.energy_plus or 0) + 1
    elseif key == "sk_ortalab_decay_1" then
        for i, j in ipairs({'p_arcana_normal_1', 'p_arcana_normal_2', 'p_arcana_normal_3', 'p_arcana_normal_4', 'p_arcana_jumbo_1', 'p_arcana_jumbo_2', 'p_arcana_mega_1', 'p_arcana_mega_2', 'p_celestial_normal_1', 'p_celestial_normal_2', 'p_celestial_normal_3', 'p_celestial_normal_4', 'p_celestial_jumbo_1', 'p_celestial_jumbo_2', 'p_celestial_mega_1', 'p_celestial_mega_2'}) do
            if not G.GAME.banned_keys[j] then
                G.GAME.banned_keys[j] = 'grim'
            end
        end
        G.GAME.orig_tarot_rate = G.GAME.tarot_rate
        G.GAME.orig_planet_rate = G.GAME.planet_rate
    elseif key == "sk_ortalab_starry_3" then
        G.GAME.orig_Zodiac_Reduction = G.GAME.Ortalab_Zodiac_Reduction
        G.GAME.Ortalab_Zodiac_Reduction = 0
    end
end

function unlearn_skill(direct_, debuffing)
    local obj, key = G.P_SKILLS[direct_], direct_
    if not debuffing then
        G.GAME.skills[key] = nil
    end
    if G.GAME.skill_debuffs[direct_] and not debuffing then
        G.GAME.skill_debuffs[direct_] = nil
        return
    end
    if key == "sk_grm_ease_1" then
        G.GAME.scaling_multipliers.ease1 = nil
        fix_ante_scaling()
    elseif key == "sk_grm_ease_2" then
        G.GAME.scaling_multipliers.ease2 = nil
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
        G.GAME.joker_rate = G.GAME.orig_joker_rate
        G.GAME.orig_joker_rate = nil
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
        G.GAME.lunar_rate = 0
        G.GAME.stellar_rate = 0
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
    elseif key == "sk_cry_m_3" then
        for i = 1, #G.jokers.cards do
            local card = G.jokers.cards[i]
            if (card.ability.name == "JollyJimball") and not card.ability.eternal then
                card:start_dissolve()
                return
            end
        end
    elseif key == "sk_poke_energetic_1" then
        G.GAME.energy_plus = (G.GAME.energy_plus or 0) - 1
    elseif key == "sk_grm_prestige_1" then
        G.GAME.legendary_tokens = (G.GAME.legendary_tokens or 0) - 1
    elseif key == "sk_ortalab_decay_1" then
        for i, j in ipairs({'p_arcana_normal_1', 'p_arcana_normal_2', 'p_arcana_normal_3', 'p_arcana_normal_4', 'p_arcana_jumbo_1', 'p_arcana_jumbo_2', 'p_arcana_mega_1', 'p_arcana_mega_2', 'p_celestial_normal_1', 'p_celestial_normal_2', 'p_celestial_normal_3', 'p_celestial_normal_4', 'p_celestial_jumbo_1', 'p_celestial_jumbo_2', 'p_celestial_mega_1', 'p_celestial_mega_2'}) do
            if G.GAME.banned_keys[j] == 'grim' then
                G.GAME.banned_keys[j] = nil
            end
        end
        G.GAME.tarot_rate = G.GAME.orig_tarot_rate
        G.GAME.orig_tarot_rate = nil
        G.GAME.planet_rate = G.GAME.orig_planet_rate
        G.GAME.orig_planet_rate = nil
    elseif key == "sk_ortalab_starry_3" then
        G.GAME.Ortalab_Zodiac_Reduction = G.GAME.orig_Zodiac_Reduction
        G.GAME.orig_Zodiac_Reduction = nil
    end
end

function debuff_skill(debuff_, direct_)
    if debuff_ == nil then
        debuff_ = true
    end
    if debuff_ == false then
        debuff_ = nil
    end
    G.GAME.skill_debuffs = G.GAME.skill_debuffs or {}
    if debuff_ and not G.GAME.skill_debuffs[direct_] then
        unlearn_skill(direct_, true)
    elseif not debuff_ and G.GAME.skill_debuffs[direct_] then
        learn_skill(nil, direct_, true)
    end
    G.GAME.skill_debuffs[direct_] = debuff_
end

function skill_active(direct_)
    if G.GAME.skill_debuffs and G.GAME.skill_debuffs[direct_] then
        return false
    end
    if G.GAME.skills[direct_] then
        return true
    end
    return false
end

G.FUNCS.can_learn = function(e)
    if e.config.ref_table and e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.prereq then
        for i2, j2 in ipairs(e.config.ref_table.config.center.prereq) do
            if not G.GAME.skills[j2] then
                e.config.colour = G.C.UI.BACKGROUND_INACTIVE
                e.config.button = 'do_nothing'
                return 
            end
        end
    end
    if e.config.ref_table and e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.class and G.GAME.grim_class.class then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
        return
    end
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
    local skill_ui = G.OVERLAY_MENU:get_UIE_by_ID("skill_tree_ui")
    local text = localize{type = 'variable', key = 'skill_xp', vars = {number_format(G.GAME.skill_xp)}, nodes = text}
    skill_ui.children[1].children[1].config.object.config.string[1] = text
    skill_ui.children[1].children[1].config.object:update_text(true)
    if skill_ui.children[2].config.id == 'legenary_tokens' then
        local text2 = localize{type = 'variable', key = 'legendary_tokens', vars = {number_format(G.GAME.legendary_tokens)}, nodes = text2}
        skill_ui.children[2].children[1].config.object.config.string[1] = text2
        skill_ui.children[2].children[1].config.object:update_text(true)
    end
    G.OVERLAY_MENU:recalculate()
    if G.GAME.hide_unlearnable then
        refresh_skill_menu_skills()
    end
end

G.FUNCS.do_nothing = function(e)
end

function skill_tree_row_UI(tier)
    local row = G.GAME.skill_tree_data[tier]
    if not row then
        G.GAME.skill_tree_data[tier] = {offset = 0, tier = tier}
        row = G.GAME.skill_tree_data[tier]
    end
    local offset = row.offset
    local skills = {offset = offset, tier = tier}
    for i = offset + 1, offset + 5 do
        if row[i] then
            table.insert(skills, row[i])
        end
    end
    G.areas[tier] = CardArea(
        G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
        (5.25)*G.CARD_W,
        1*G.CARD_W, 
    {card_limit = 5, type = 'joker', highlight_limit = 1, skill_table = true})
    local t = {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true, id = 'skill_tree_tier_' .. tostring(tier)}, nodes={
        UIBox_button{col = true, label = {"<"}, button = "grm_skill_tree_l", func = 'grm_can_skill_tree_l', minw = 0.5, minh = 1*G.CARD_W, ref_table = skills},
        {n=G.UIT.C, config={align = "cm", padding = 0, minh = 0.8, minw = 0.4 + (5.25)*G.CARD_W}, nodes = {{n=G.UIT.O, config={object = G.areas[tier]}}}},
        UIBox_button{col = true, label = {">"}, button = "grm_skill_tree_r", func = 'grm_can_skill_tree_r', minw = 0.5, minh = 1*G.CARD_W, ref_table = skills},
    }}
    for i, j in ipairs(skills) do
        local center = G.P_SKILLS[j]
        local card = Card(G.areas[tier].T.x + G.areas[tier].T.w/2, G.areas[tier].T.y, G.CARD_W, G.CARD_H, nil, center)
        card:start_materialize()
        if G.GAME.skill_debuffs[center.key] then
            card.debuff = true
        end
        G.areas[tier]:emplace(card)
    end
    return t
end

function create_UI_learned_skills()
    if not use_page then
        skills_page = nil
    end
    G.areas = {}
    area_table = {}
    for j = 3, 1, -1 do
        table.insert(area_table, skill_tree_row_UI(j))
    end

    local text = localize{type = 'variable', key = 'skill_xp', vars = {number_format(G.GAME.skill_xp)}, nodes = text}

    local text2 = localize{type = 'variable', key = 'legendary_tokens', vars = {number_format(G.GAME.legendary_tokens)}, nodes = text2}

    local t = {n=G.UIT.R, config={align = "cm", id = 'skill_tree_ui', colour = G.C.CLEAR, paddng = 0.1}, nodes = {
        {n=G.UIT.R, config={align = "cm", paddng = 0.3}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = text, colours = {G.C.UI.TEXT_LIGHT}, bump = true, scale = 0.6})}}
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=area_table},
        create_toggle({label = localize('b_hide_unavailiable_skills'), ref_table = G.GAME, ref_value = 'hide_unlearnable', callback = G.FUNCS.flip_hidden}),
      }}
    if skill_active("sk_grm_cl_astronaut") then
        table.insert(t.nodes, 4, UIBox_button{id = 'lunar_button', label = {localize("lunar_stats")}, button = "your_lunar_stats", minw = 5})
    end
    if skill_active("sk_grm_cl_explorer") then
        table.insert(t.nodes, 2, {n=G.UIT.R, config={align = "cm", padding = 0.2}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = localize{type='variable',key='area_indicator',vars={G.GAME.area or "Classic"}}, colours = {G.C.UI.TEXT_LIGHT}, bump = true, scale = 0.6})}}
        }})
    end
    if G.GAME.legendary_tokens and (G.GAME.legendary_tokens > 0) then
        table.insert(t.nodes, 2, {n=G.UIT.R, config={align = "cm", padding = 0.2, id = 'legenary_tokens'}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = text2, colours = {G.C.UI.TEXT_LIGHT}, bump = true, scale = 0.6})}}
        }})
    end
    local skill_ui = create_UIBox_generic_options({ contents = {t}})
    return skill_ui
end

G.FUNCS.your_skill_tree = function(e)
    G.FUNCS.overlay_menu{
        definition = create_UI_learned_skills(),
    }
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
            if skill_active("sk_grm_stake_3") then
                G.GAME.scaling_multipliers.stake = 1.3 ^ context.current_ante
                fix_ante_scaling(true)
            end
        elseif skill == "sk_grm_chime_2" and ((context.current_ante) % 4 == 0) and not G.GAME.reset_antes2[context.current_ante] then
            G.GAME.reset_antes2[context.current_ante] = true
            ease_ante(-1, true)
            if skill_active("sk_grm_stake_3") then
                G.GAME.scaling_multipliers.stake = 1.3 ^ context.current_ante
                fix_ante_scaling(true)
            end
        elseif skill == "sk_grm_chime_3" and ((context.current_ante) % 3 == 0) and not G.GAME.reset_antes3[context.current_ante] then
            G.GAME.reset_antes3[context.current_ante] = true
            ease_ante(-1, true)
            if skill_active("sk_grm_stake_3") then
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
        elseif skill == "sk_ortalab_magica_3" and (context.card.ability.set == 'Loteria') and (context.card.config.center.key == 'c_ortalab_lot_rooster') and (pseudorandom("magical") < 0.8) then
            if (context.card.area == G.consumeables) or (#G.consumeables.cards < G.consumeables.config.card_limit) then
                local rooster = SMODS.create_card {key = "c_ortalab_lot_rooster", no_edition = true}
                rooster:add_to_deck()
                G.consumeables:emplace(rooster)
            end
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
        elseif skill == "sk_cry_m_1" then
            local bonus = 3 * G.GAME.hands["Pair"].played
            return context.chips + bonus, context.mult, (bonus > 0)
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
            if (to_big and to_big(level) or level) > (to_big and to_big(0) or 0) then
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
    if skill_active("sk_grm_ghost_1") then
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
    if skill_active("sk_grm_skillful_3") and (new_amount > 0) then
        new_amount = new_amount * 2
    end
    if skill_active("sk_grm_ghost_3") and (new_amount > 0) then
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
        if (args.type == 'upgrade_hand') and ((to_big and to_big(args.level) or args.level) >= (to_big and to_big(40) or 40)) then
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
                if (v.ability.name == "Wild Card") or (G.GAME.skills and skill_active("sk_grm_motley_3") and (v.config.center ~= G.P_CENTERS.c_base)) then count = count + 1 end
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
            if ((to_big and to_big(j.level) or j.level) > (to_big and to_big(1) or 1)) and j.visible then
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

G.FUNCS.grm_skill_tree_r = function(e)
    local tier = e.config.ref_table.tier
    G.GAME.skill_tree_data[tier].offset = G.GAME.skill_tree_data[tier].offset + 1
    local center = G.P_SKILLS[G.GAME.skill_tree_data[tier][5 + G.GAME.skill_tree_data[tier].offset]]
    G.areas[tier].cards[1]:remove()
    local card = Card(G.areas[tier].T.x + G.areas[tier].T.w/2, G.areas[tier].T.y, G.CARD_W, G.CARD_H, nil, center)
    card:start_materialize()
    if G.GAME.skill_debuffs[center.key] then
        card.debuff = true
    end
    G.areas[tier]:emplace(card)
end

G.FUNCS.grm_can_skill_tree_r = function(e)
    local tier = e.config.ref_table.tier
    local offset = G.GAME.skill_tree_data[tier].offset
    local length = #G.GAME.skill_tree_data[tier]
    if (5 + offset >= length) then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.PURPLE
        e.config.button = 'grm_skill_tree_r'
    end
end

G.FUNCS.grm_skill_tree_l = function(e)
    local tier = e.config.ref_table.tier
    G.GAME.skill_tree_data[tier].offset = G.GAME.skill_tree_data[tier].offset - 1
    local center = G.P_SKILLS[G.GAME.skill_tree_data[tier][1 + G.GAME.skill_tree_data[tier].offset]]
    local a = G.areas[tier]
    G.areas[tier].cards[#G.areas[tier].cards]:remove()
    local card = Card(G.areas[tier].T.x + G.areas[tier].T.w/2, G.areas[tier].T.y, G.CARD_W, G.CARD_H, nil, center)
    card:start_materialize(nil)
    if G.GAME.skill_debuffs[center.key] then
        card.debuff = true
    end
    G.areas[tier]:emplace(card, 'front')
end

G.FUNCS.grm_can_skill_tree_l = function(e)
    local tier = e.config.ref_table.tier
    local offset = G.GAME.skill_tree_data[tier].offset
    local length = #e.config.ref_table
    if (offset <= 0) then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.PURPLE
        e.config.button = 'grm_skill_tree_l'
    end
end

G.FUNCS.flip_hidden = function(flipped)
    refresh_skill_menu_skills()
end

SMODS.Atlas({ key = "skills", atlas_table = "ASSET_ATLAS", path = "skills.png", px = 71, py = 95})

SMODS.Atlas({ key = "skills2", atlas_table = "ASSET_ATLAS", path = "skills2.png", px = 71, py = 95})

SMODS.Atlas({ key = "skills3", atlas_table = "ASSET_ATLAS", path = "skills3.png", px = 71, py = 95,
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
        G.skill_soul = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 2,y = 0})
        G.gold_bar = Sprite(0, 0, G.CARD_W, G.CARD_H, G[self.atlas_table][self.key_noloc or self.key], {x = 1,y = 5})
    end
})

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

SMODS.Atlas({ key = "jolly_jimball", path = "JollyJimball.png", px = 71, py = 95 })

SMODS.Atlas({key = "modicon", path = "grm_icon.png", px = 34, py = 34}):register()

SMODS.Shader {
    key = 'dimmed',
    path = 'dimmed.fs'
}

SMODS.Shader {
    key = 'skill_debuff',
    path = 'skill_debuff.fs'
}

SMODS.Shader {
    key = 'purple_shade',
    path = 'purple_shade.fs'
}

SMODS.Tarot {
    key = 'craft',
    atlas = "tarots",
    pos = {x = 0, y = 0},
    config = {mod_conv = 'm_grm_rpg', max_highlighted = 3},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_rpg']
        return {vars = {(card and card.ability.max_highlighted or 3), localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_rpg')}}}
    end
}

SMODS.Joker {
    key = 'jack_of_all_trades',
    name = "Jack of All Trades",
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
    pos = {x = 0, y = 0},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'hide',
    pos = {x = 1, y = 1},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'up',
    pos = {x = 2, y = 0},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'ring',
    pos = {x = 0, y = 1},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'snatch',
    pos = {x = 1, y = 0},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Attack {
    key = 'collapse',
    pos = {x = 2, y = 1},
    config = {},
    atlas = "attack",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
}

SMODS.Loot {
    key = 'hand_refresh',
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
    key = 'loot_normal_1',
    group_key = 'k_loot_pack',
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
    key = 'forgotten',
    config = {},
    boss = {min = 3, max = 10}, 
    boss_colour = HEX("79458f"),
    atlas = "blinds",
    name = "The Forgotten",
    pos = { x = 0, y = 5},
    vars = {},
    dollars = 5,
    mult = 2,
    discovered = true,
    press_play = function(self)
        if not G.GAME.blind.disabled then
            G.GAME.blind.triggered = true
            G.GAME.blind.prepped = true
        end
    end,
    defeat = function(self)
        if G.GAME.blind.debuffed_skills and G.GAME.blind.debuffed_skills[1] then
            debuff_skill(false, G.GAME.blind.debuffed_skills[1], true)
        end
    end,
    disable = function(self)
        if G.GAME.blind.debuffed_skills and G.GAME.blind.debuffed_skills[1] then
            debuff_skill(false, G.GAME.blind.debuffed_skills[1], true)
        end
    end,
    set_blind = function(self, reset, silent)
        if not reset then
            G.GAME.blind.debuffed_skills = {}
            local pool = {}
            for i, j in pairs(G.GAME.skills) do
                if not G.P_SKILLS[i].class then
                    table.insert(pool, i)
                end
            end
            if #pool > 0 then
                local skill = pseudorandom_element(pool, pseudoseed('forgot'))
                debuff_skill(true, skill)
                G.GAME.blind.debuffed_skills = {skill}
            end
            G.GAME.blind.prepped = false
        end
    end,
    drawn_to_hand = function(self)
        if G.GAME.blind.prepped then
            local old_skill = nil
            if G.GAME.blind.debuffed_skills and G.GAME.blind.debuffed_skills[1] then
                old_skill = G.GAME.blind.debuffed_skills[1]
                debuff_skill(false, G.GAME.blind.debuffed_skills[1], true)
            end
            G.GAME.blind.debuffed_skills = {}
            local pool = {}
            for i, j in pairs(G.GAME.skills) do
                if not G.P_SKILLS[i].class and (i ~= old_skill) then
                    table.insert(pool, i)
                end
            end
            if #pool > 0 then
                local skill = pseudorandom_element(pool, pseudoseed('forgot'))
                debuff_skill(true, skill)
                G.GAME.blind.debuffed_skills = {skill}
            elseif old_skill then
                debuff_skill(true, old_skill)
                G.GAME.blind.debuffed_skills = {old_skill}
            end
            G.GAME.blind.prepped = false
        end
    end,
    discovered = true,
}

SMODS.Blind	{
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

SMODS.Joker {
	name = "JollyJimball",
	key = "jolly_jimball",
	pos = { x = 0, y = 0 },
	config = { x_mult = 1, extra = 1.3, override_x_mult_check = true, type = "Pair"},
    pools = {["Meme"] = true},
    dependencies = {"Cryptid"},
	loc_vars = function(self, info_queue, center)
		return { vars = { center and center.ability.extra or 1.3, center and localize(center.ability.type, 'poker_hands') or "Pair", center and center.ability.x_mult or 1} }
	end,
	rarity = 3,
	cost = 9,
	blueprint_compat = true,
	perishable_compat = false,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			if next(context.poker_hands[card.ability.type]) then
				card.ability.x_mult = card.ability.x_mult + card.ability.extra
				return {
                    card = self,
                    message = localize("k_upgrade_ex"),
                }
			else
				if to_big(card.ability.x_mult) > to_big(1) then
					card.ability.x_mult = 1
					return {
						card = self,
						message = localize("k_reset"),
					}
				end
			end
		end
	end,
	atlas = "jolly_jimball",
    in_pool = function(self)
        return false, {allow_duplicates = false}
    end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			create_cryptid_notif_overlay("jimball")
		end
	end,
}

-----Alchemist Stuff---------

SMODS.Element {
    key = 'm_lead',
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
    atlas = "metal",
    pos = {x =4, y = 1},
    config = {mod_conv = 'm_grm_iron', max_highlighted = 2},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_grm_iron']
        return {vars = {(card and card.ability.max_highlighted or 2), localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_grm_iron')}}}
    end,
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
}

SMODS.Spectral {
    key = 'philosophy',
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
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_alchemist, {allow_duplicates = false}
    end,
}

SMODS.Enhancement {
    key = 'radium',
    name = "Radium Card",
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
    atlas = 'enhance',
    config = {grm_h_chips = 50, m_type = "Precious"},
    pos = {x = 2, y = 0},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.grm_h_chips or 50}}
    end,
}

SMODS.Enhancement {
    key = 'iron',
    name = "Iron Card",
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
    pos = {x = 2, y = 0},
    min_ante = 2,
    apply = function(self, tag, context)
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
    atlas = "lunar",
    special_level = "debuff",
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1, 
            string.format("%.1f",(G.GAME.special_levels and (G.GAME.special_levels[self.special_level] + 1) or 1) * 0.5)
        }}
    end,
    bulk_use = function(self, card, area, copier, number)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + number
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize('k_upgrade_ex')})
    end,
}

SMODS.Lunar {
    key = 'deimos',
    atlas = "lunar",
    special_level = "boss",
    pos = {x = 2, y = 2},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['m_glass']
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1, 
            G.GAME.special_levels[self.special_level] + 1, 
            localize{type = 'name_text', set = 'Enhanced', key = 'm_glass'},
        }}
    end,
    bulk_use = function(self, card, area, copier, number)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + number
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize('k_upgrade_ex')})
    end,
}

SMODS.Lunar {
    key = 'callisto',
    atlas = "lunar",
    special_level = "face_down",
    pos = {x = 1, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1,
            string.format("%.2f",1 + 0.15 * (G.GAME.special_levels[self.special_level] + 1)),
        }}
    end,
    bulk_use = function(self, card, area, copier, number)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + number
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize('k_upgrade_ex')})
    end,
}

SMODS.Lunar {
    key = 'rhea',
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
    end,
    bulk_use = function(self, card, area, copier, number)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + number
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize('k_upgrade_ex')})
    end,
}

SMODS.Lunar {
    key = 'oberon',
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
    end,
    bulk_use = function(self, card, area, copier, number)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + number
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize('k_upgrade_ex')})
    end,
}

SMODS.Lunar {
    key = 'proteus',
    atlas = "lunar",
    special_level = "money",
    pos = {x = 0, y = 1},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.special_levels[self.special_level] + 1,
            10 * (G.GAME.special_levels[self.special_level] + 1),
        }}
    end,
    bulk_use = function(self, card, area, copier, number)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + number
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize('k_upgrade_ex')})
    end,
}

SMODS.Lunar {
    key = 'nix',
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
    end,
    bulk_use = function(self, card, area, copier, number)
        G.GAME.special_levels[self.special_level] = G.GAME.special_levels[self.special_level] + number
        card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.BLUE, message = localize('k_upgrade_ex')})
    end,
}

SMODS.Spectral {
    key = 'moon_x',
    atlas = "lunar",
    soul_set = 'Lunar',
    hidden = true,
    soul_rate = 0.01,
    pos = {x = 0, y = 2},
    soul_pos = {x = 1, y = 2},
    use = function(self, card, area, copier)
        for i, j in ipairs({'debuff', 'face_down', 'not_allowed', 'overshoot', 'money', 'boss'}) do
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
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_astronaut, {allow_duplicates = false}
    end,
}

SMODS.Stellar {
    key = 'sun',
    atlas = "stellar",
    special_level = "heart",
    pos = {x = 0, y = 0},
    config = {suit = "Hearts", mult = 0.35, chips = 1.8},
}

SMODS.Stellar {
    key = 'sirius',
    atlas = "stellar",
    special_level = "diamond",
    pos = {x = 1, y = 0},
    config = {suit = "Diamonds", mult = 0.3, chips = 2.5},
}

SMODS.Stellar {
    key = 'canopus',
    atlas = "stellar",
    special_level = "spade",
    pos = {x = 2, y = 0},
    config = {suit = "Spades", mult = 0.22, chips = 4},
}

SMODS.Stellar {
    key = 'alpha',
    atlas = "stellar",
    special_level = "club",
    pos = {x = 3, y = 0},
    config = {suit = "Clubs", mult = 0.45, chips = 1},
}

SMODS.Stellar {
    key = 'lp_944_20',
    atlas = "stellar",
    special_level = "nothing",
    pos = {x = 1, y = 1},
    config = {suit = "Nothings", mult = 0.15, chips = 6},
    in_pool = function(self)
        return G.GAME.skills.sk_grm_orbit_2, {allow_duplicates = false}
    end
}
SMODS.Stellar {
    key = 'arcturus',
    atlas = "stellar",
    special_level = "fleuron",
    pos = {x = 0, y = 2},
    config = {suit = "Fleurons", mult = 0.25, chips = 3},
    dependencies = {"Bunco"}
}

SMODS.Stellar {
    key = 'vega',
    atlas = "stellar",
    special_level = "halberd",
    pos = {x = 1, y = 2},
    config = {suit = "Halberds", mult = 0.4, chips = 1.4},
    dependencies = {"Bunco"}
}

SMODS.Spectral {
    key = 'iron_core',
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
    in_pool = function(self)
        return G.GAME.skills.sk_grm_cl_astronaut, {allow_duplicates = false}
    end,
}

-------Explorer Stuff--------

SMODS.Area {
    key = 'classic',
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
    pos = {x = 1, y = 0},
    apply = function(self, tag, context)
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
    pos = {x = 0, y = 0},
    config = {type = 'immediate', amount = 100},
    apply = function(self, tag, context)
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
    prefix_config = { applied_stakes = { mod = false } },
    applied_stakes = {"gold"},
    modifiers = function()
        G.GAME.modifiers.no_big_shop = true
    end,
    colour = HEX("D184BC"),
    sticker_pos = {x = 1, y = 0},
    sticker_atlas = "stickers"
}

SMODS.Back {
    key = 'talent',
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

local upd = Game.update
grm_jimball_dt = 0
function Game:update(dt)
    upd(self, dt)
    grm_jimball_dt = grm_jimball_dt + dt
    if G.P_CENTERS and G.P_CENTERS.j_grm_jolly_jimball and grm_jimball_dt > 0.1 then
        grm_jimball_dt = 0
        local obj = G.P_CENTERS.j_grm_jolly_jimball
        if obj.pos.x == 5 and obj.pos.y == 6 then
            obj.pos.x = 0
            obj.pos.y = 0
        elseif obj.pos.x < 8 then
            obj.pos.x = obj.pos.x + 1
        elseif obj.pos.y < 6 then
            obj.pos.x = 0
            obj.pos.y = obj.pos.y + 1
        end
    end
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
    elseif moon == 'c_grm_deimos' then
        loc_vars = {
            (G.GAME.special_levels and G.GAME.special_levels["boss"] or 0),
            localize{type = 'name_text', set = 'Enhanced', key = 'm_glass'},
        }
        desc_nodes = localize{type = 'raw_descriptions', key = 'deimos_level_desc', set = "Other", vars = loc_vars}
        moon_name = localize{type = 'name_text', key = moon, set = "Lunar"}
        stat_text = loc_vars[1]
        stat_color = G.C.SET.Tarot
        level = G.GAME.special_levels["boss"] + 1
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
        moon_row("c_grm_deimos"),
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
  
    return create_UIBox_generic_options({ back_func = 'your_skill_tree', contents = {t}})
end

function nullified_blinds_sect()
    if not use_page then
        blinds_page = nil
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
    for i = ((blinds_page or 1) - 1) * 12 + 1, (blinds_page or 1) * 12 do
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
            create_option_cycle({options = blind_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_nullified_blinds_page', focus_args = {snap_to = true, nav = 'wide'},current_option = blinds_page or 1, colour = G.C.RED, no_pips = true})
        }}
    }}
    return t
end

-----Pokermon thing-------

function pokermon_selected_joker(self)
    if G.jokers.highlighted and (#G.jokers.highlighted ~= 0) then
        return G.jokers.highlighted[1]
    end
    for k, v in pairs(G.jokers.cards) do
        if self.etype and (energy_matches(v, self.etype, true) or self.etype == "Trans") then
            if type(v.ability.extra) == "table" then
                if can_increase_energy(v) then
                    for l, data in pairs(v.ability.extra) do
                        if type(data) == "number" then
                            for m, name in ipairs(energy_whitelist) do
                                if l == name then
                                    return v
                                end
                            end
                        end
                    end
                end
            end
        elseif (type(v.ability.extra) == "number" or (v.ability.mult and v.ability.mult > 0) or (v.ability.t_mult and v.ability.t_mult > 0) or
                (v.ability.t_chips and v.ability.t_chips > 0)) then
            if can_increase_energy and can_increase_energy(v) then
                return v
            end
        end
    end
end

--------------------------

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
    return self.ability.grm_h_chips or 0
end

G.FUNCS.your_lunar_stats = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_current_lunar_stats(),
    }
end

G.FUNCS.your_nullified_blinds_page = function(args)
    if not args or not args.cycle_config then return end
    blinds_page = args.cycle_config.current_option
    G.SETTINGS.paused = true
    use_page = true
    G.FUNCS.overlay_menu{
      definition = create_UIBox_current_lunar_stats(),
    }
    use_page = nil
end

----------------------------------------------
------------MOD CODE END----------------------
