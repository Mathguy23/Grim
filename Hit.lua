--- STEAMODDED HEADER
--- MOD_NAME: Hit
--- MOD_ID: HIT
--- PREFIX: hit
--- MOD_AUTHOR: [mathguy]
--- MOD_DESCRIPTION: Blackjack instead of Poker
--- VERSION: 1.0.3
----------------------------------------------
------------MOD CODE -------------------------
-------------Credits--------------------------

--- Aced Sleeve - Code: SMG9000, Art: GenEric1110

----------------------------------------------

SMODS.current_mod.set_debuff = function(card)
    if card.ability.temp_debuff then
        return true
    end
    if card.ability.enemy and G.GAME.hit_3C_countdown_e and (card.config.center ~= G.P_CENTERS.c_base) then
        return true
    end
end

SMODS.Atlas({ key = "tags", atlas_table = "ASSET_ATLAS", path = "tags.png", px = 34, py = 34})

SMODS.Atlas({ key = "decks", atlas_table = "ASSET_ATLAS", path = "backs.png", px = 71, py = 95})

SMODS.Atlas({ key = "sleeves", atlas_table = "ASSET_ATLAS", path = "Sleeves.png", px = 71, py = 95})

SMODS.Atlas({ key = "reversed_tarots", atlas_table = "ASSET_ATLAS", path = "Untarot.png", px = 71, py = 95})

SMODS.Atlas({ key = "enhance", atlas_table = "ASSET_ATLAS", path = "Enhance.png", px = 71, py = 95})

SMODS.Atlas({ key = "boosters", atlas_table = "ASSET_ATLAS", path = "boosters.png", px = 71, py = 95})

SMODS.Atlas({ key = "ranks", atlas_table = "ASSET_ATLAS", path = "ranks.png", px = 71, py = 95})

SMODS.Atlas({ key = "hc_ranks", atlas_table = "ASSET_ATLAS", path = "hc_ranks.png", px = 71, py = 95})

SMODS.Atlas({ key = "pc_cards", atlas_table = "ASSET_ATLAS", path = "pc_cards.png", px = 71, py = 95})

SMODS.Atlas({ key = "planets", atlas_table = "ASSET_ATLAS", path = "Planets.png", px = 71, py = 95})

SMODS.Atlas({ key = "jokers", atlas_table = "ASSET_ATLAS", path = "Jokers.png", px = 71, py = 95})

SMODS.Atlas({ key = "blinds", atlas_table = "ANIMATION_ATLAS", path = "blinds.png", px = 34, py = 34, frames = 21 })

SMODS.Atlas({ key = "minor", atlas_table = "ASSET_ATLAS", path = "Minor.png", px = 71, py = 95})

SMODS.Atlas({ key = "mini_suits", atlas_table = "ASSET_ATLAS", path = "mini_suits.png", px = 18, py = 18})

function get_smods_rank_from_id(card)
    local id = card:get_id()
    if id > 0 then
        for i, j in pairs(SMODS.Ranks) do
            if j.id == id then
                return j
            end
        end
    else
        return SMODS.Ranks[card.base.value] or {}
    end
end

function shuffle_card_in_deck(card)
    if card.facing == 'front' then
        card:flip()
    end
    local index = -1
    for i = 1, #G.deck.cards do
        if G.deck.cards[i] == card then
            index = i
            break
        end
    end
    if index ~= -1 then
        local rand_index = 1 + math.floor(#G.deck.cards * pseudorandom('shuffle_index'))
        if rand_index == #G.deck.cards + 1 then
            rand_index = #G.deck.cards
        end
        G.deck.cards[rand_index], G.deck.cards[index] = G.deck.cards[index], G.deck.cards[rand_index]
        G.deck:set_ranks()
    end
end

----Poker Hands--------

    SMODS.PokerHand {
        key = 'High Card0',
        chips = 30,
        l_chips = 10,
        mult = 3,
        l_mult = 1,
        example = {
            { 'C_5', false },
            { 'H_K', false },
            { 'D_4', false },
            { 'H_7', false },
            { 'C_A', true } 
        },
        evaluate = function(parts, hand)
            if not G.GAME.modifiers.dungeon then
                return {}
            end
            if #hand == 0 then
                return {}
            end
            return parts._highest
        end,
        visible = false,
        order_offset = 3000,
        bj_mode = true
    }

    SMODS.PokerHand {
        key = 'Court',
        chips = 40,
        l_chips = 10,
        mult = 4,
        l_mult = 1,
        example = {
            { 'D_K', true },
            { 'H_J', true },
            { 'C_6', false },
            { 'H_9', false },
            { 'S_2', false } 
        },
        evaluate = function(parts, hand)
            if not G.GAME.modifiers.dungeon then
                return {}
            end
            local faces = {}
            for i, j in ipairs(hand) do
                if j:is_face() then
                    table.insert(faces, j)
                end
            end
            if #faces >= 2 then
                local highest = nil
                local highest2 = nil
                for i = 1, #faces do
                    if not highest then
                        highest = i
                    elseif not highest2 then
                        if (faces[i]:get_nominal() > faces[highest]:get_nominal()) then
                            highest2 = highest
                            highest = i
                        else
                            highest2 = i
                        end
                    elseif (faces[i]:get_nominal() > faces[highest]:get_nominal()) then
                        highest2 = highest
                        highest = i
                    elseif (faces[i]:get_nominal() > faces[highest2]:get_nominal()) then
                        highest2 = i
                    end
                end
                return { {faces[highest], faces[highest2]} }
            end
            return {}
        end,
        visible = false,
        order_offset = 3000,
        bj_mode = true
    }

    SMODS.PokerHand {
        key = 'Duo',
        chips = 50,
        l_chips = 15,
        mult = 4,
        l_mult = 2,
        example = {
            { 'D_A', true },
            { 'S_Q', false },
            { 'C_8', true },
            { 'D_8', true },
            { 'C_4', false } 
        },
        evaluate = function(parts, hand)
            if not G.GAME.modifiers.dungeon then
                return {}
            end
            local pair = get_X_same(2, hand, true)
            if next(pair) then
                best_pair = pair[1]
                best_card = nil
                for i, j in ipairs(hand) do
                    if (j ~= best_pair[1]) and (j ~= best_pair[2]) then
                        if not best_card and (j:get_id() > 0) then
                            best_card = j
                        elseif best_card and (j:get_nominal() > best_card:get_nominal()) then
                            best_card = j
                        end
                    end
                end
                if best_card then
                    return { {best_pair[1], best_pair[2], best_card} }
                end
            end
            return {}
        end,
        visible = false,
        order_offset = 3000,
        bj_mode = true
    }

    SMODS.PokerHand {
        key = 'Batch',
        chips = 60,
        l_chips = 20,
        mult = 6,
        l_mult = 2,
        example = {
            { 'C_9', true },
            { 'H_6', false },
            { 'C_A', true },
            { 'D_7', false },
            { 'C_5', true } 
        },
        evaluate = function(parts, hand)
            if not G.GAME.modifiers.dungeon then
                return {}
            end
            local suits = SMODS.Suit.obj_buffer
            local map = {}
            for i=1, #hand do
                for j = 1, #suits do
                    if hand[i]:is_suit(suits[j], nil, true) then
                        map[suits[j]] = map[suits[j]] or {}
                        map[suits[j]][#map[suits[j]]+1] = hand[i] 
                        if #map[suits[j]] >= 3 then
                            return { map[suits[j]] }
                        end
                    end
                end
            end
            return {}
        end,
        visible = false,
        order_offset = 3000,
        bj_mode = true
    }

    SMODS.PokerHand {
        key = 'Blackjack',
        chips = 70,
        l_chips = 20,
        mult = 6,
        l_mult = 1,
        example = {
            { 'C_4', true },
            { 'H_7', true },
            { 'H_J', true },
        },
        evaluate = function(parts, hand)
            if not G.GAME.modifiers.dungeon then
                return {}
            end
            local data = get_card_total(hand)
            if data.total == data.bust_limit then
                return { hand }
            end
            return {}
        end,
        visible = false,
        order_offset = 3000,
        bj_mode = true
    }

    SMODS.PokerHand {
        key = 'Duo+',
        chips = 80,
        l_chips = 20,
        mult = 7,
        l_mult = 2,
        example = {
            { 'S_A', true },
            { 'D_3', true },
            { 'H_3', true },
            { 'C_3', true },
            { 'C_K', false } 
        },
        evaluate = function(parts, hand)
            if not G.GAME.modifiers.dungeon then
                return {}
            end
            local oaK = get_X_same(3, hand, true)
            if next(oaK) then
                best_oaK = oaK[1]
                best_card = nil
                for i, j in ipairs(hand) do
                    local valid = true
                    for i2, j2 in ipairs(best_oaK) do
                        if j2 == j then
                            valid = false
                            break
                        end
                    end
                    if valid then
                        if not best_card and (j:get_id() > 0) then
                            best_card = j
                        elseif best_card and (j:get_nominal() > best_card:get_nominal()) then
                            best_card = j
                        end
                    end
                end
                if best_card then
                    local result = {}
                    for i, j in ipairs(best_oaK) do
                        table.insert(result, j)
                    end
                    table.insert(result, best_card)
                    return { result }
                end
            end
            return {}
        end,
        visible = false,
        order_offset = 3000,
        bj_mode = true
    }

    SMODS.PokerHand {
        key = 'Batch+',
        chips = 80,
        l_chips = 25,
        mult = 8,
        l_mult = 3,
        example = {
            { 'D_Q', true },
            { 'H_6', false },
            { 'D_J', true },
            { 'D_2', true },
            { 'D_4', true } 
        },
        evaluate = function(parts, hand)
            if not G.GAME.modifiers.dungeon then
                return {}
            end
            local suits = SMODS.Suit.obj_buffer
            local map = {}
            for i=1, #hand do
                for j = 1, #suits do
                    if hand[i]:is_suit(suits[j], nil, true) then
                        map[suits[j]] = map[suits[j]] or {}
                        map[suits[j]][#map[suits[j]]+1] = hand[i] 
                        if #map[suits[j]] >= 4 then
                            return { map[suits[j]] }
                        end
                    end
                end
            end
            return {}
        end,
        visible = false,
        order_offset = 3000,
        bj_mode = true
    }

    SMODS.PokerHand {
        key = 'Blackjack Batch',
        chips = 90,
        l_chips = 25,
        mult = 9,
        l_mult = 2,
        example = {
            { 'S_A', true },
            { 'S_2', true },
            { 'S_3', true },
            { 'S_5', true },
            { 'C_J', false } 
        },
        evaluate = function(parts, hand)
            if not G.GAME.modifiers.dungeon then
                return {}
            end
            local data = get_card_total(hand)
            if (data.total == data.bust_limit) then
                if data.card_count < 3 then
                    return {}
                end
                for i, j in pairs(data.suit_map) do
                    if #j >= data.card_count then
                        return { j }
                    end
                end
            end
            return {}
        end,
        visible = false,
        order_offset = 3000,
        bj_mode = true
    }

    SMODS.PokerHand {
        key = 'Supreme',
        chips = 100,
        l_chips = 15,
        mult = 10,
        l_mult = 2,
        example = {
            { 'S_7', true },
            { 'H_A', true },
            { 'D_2', true },
            { 'C_K', true },
            { 'S_2', true },
            { 'D_8', true } 
        },
        evaluate = function(parts, hand)
            if not G.GAME.modifiers.dungeon then
                return {}
            end
            cards = {}
            for i=1, #hand do
                local id = hand[i]:get_id()
                if (id >= 0) then
                    table.insert(cards, hand[i])
                end
            end
            if #cards >= 6 then
                return { cards }
            end
            return {}
        end,
        visible = false,
        order_offset = 3000,
        bj_mode = true
    }

    local bj_hands = {
        {hand = 'hit_High Card0', x = 0, y = 0, key = 'pluto'},
        {hand = 'hit_Court', x = 1, y = 0, key = 'mercury'},
        {hand = 'hit_Duo', x = 2, y = 0, key = 'uranus'},
        {hand = 'hit_Batch', x = 3, y = 0, key = 'venus'},
        {hand = 'hit_Blackjack', x = 0, y = 1, key = 'saturn'},
        {hand = 'hit_Duo+', x = 1, y = 1, key = 'jupiter'},
        {hand = 'hit_Batch+', x = 2, y = 1, key = 'earth'},
        {hand = 'hit_Blackjack Batch', x = 3, y = 1, key = 'mars'},
        {hand = 'hit_Supreme', x = 0, y = 2, key = 'neptune'},
    }

    for i, j in ipairs(bj_hands) do
        SMODS.Planet {
            key = j.key,
            name = string.upper(string.sub(j.key, 1, 1)) .. string.sub(j.key, 2, -1),
            loc_txt = {
                name = string.upper(string.sub(j.key, 1, 1)) .. string.sub(j.key, 2, -1),
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#",
                    "{C:mult}+#3#{} Mult and",
                    "{C:chips}+#4#{} chips"
                }
            },
            config = {hand_type = j.hand},
            atlas = "planets",
            pos = {x = j.x, y = j.y},
            loc_vars = function(self, info_queue, card)
                local hand = self.config.hand_type
                return { vars = {G.GAME.hands[hand].level,localize(hand, 'poker_hands'), G.GAME.hands[hand].l_mult, G.GAME.hands[hand].l_chips, colours = {(G.GAME.hands[hand].level==1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[hand].level)])}} }
            end,
            in_pool = function(self)
                return G.GAME.modifiers.dungeon
            end
        }
    end

------------------------

----Untarots------------

    SMODS.ConsumableType {
        key = 'Untarot',
        collection_rows = { 5, 6 },
        primary_colour = HEX('424e54'),
        secondary_colour = HEX('a58547'),
        default = 'c_hit_unstrength'
    }

    SMODS.UndiscoveredSprite {
        key = 'Untarot',
        atlas = 'reversed_tarots',
        pos = {x = 2, y = 4}
    }

    SMODS.Untarot = SMODS.Consumable:extend {
        set = 'Untarot',
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
    }

    SMODS.Enhancement {
        key = 'blackjack',
        name = "Mega Blackjack Card",
        atlas = 'enhance',
        config = {},
        pos = {x = 0, y = 0},
        in_pool = function(self)
            return false
        end,
    }

    SMODS.Untarot {
        key = 'unfool',
        atlas = 'reversed_tarots',
        pos = {x = 0, y = 0},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    local suits = {'H', 'S', 'D', 'C'}
                    local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
                    local rank = pseudorandom_element(ranks, pseudoseed('untarot'))
                    local suit = pseudorandom_element(suits, pseudoseed('untarot'))
                    local card_ = create_playing_card({front = G.P_CARDS[suit..'_'..rank], center = G.P_CENTERS['m_hit_blackjack']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
                    shuffle_card_in_deck(card_)
                    return true
                end
            })) 
        end,
        config = {},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS['m_hit_blackjack']
            return {vars = {localize{type = 'name_text', set = 'Enhanced', key = 'm_hit_blackjack'}}}
        end,
        can_use = function(self, card)
            if G.deck then
                return true
            end
        end
    }

    SMODS.Untarot {
        key = 'unmagician',
        atlas = 'reversed_tarots',
        pos = {x = 1, y = 0},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local suit = SMODS.Suits[G.hand.highlighted[i].base.suit].card_key
                    local og_base = G.hand.highlighted[i].config.card
                    G.hand.highlighted[i].ability.revert_base = {og_base, 4}
                
                    G.hand.highlighted[i]:set_base(G.P_CARDS[suit..'_A'])
                    G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 3, rounds = 4},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 3, localize('Ace', 'ranks'), card and card.ability.rounds or 4}}
        end
    }

    SMODS.Untarot {
        key = 'unhigh_priestess',
        atlas = 'reversed_tarots',
        pos = {x = 2, y = 0},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    local suits = {'H', 'S', 'D', 'C'}
                    local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
                    local rank = pseudorandom_element(ranks, pseudoseed('untarot'))
                    local suit = pseudorandom_element(suits, pseudoseed('untarot'))
                    local common_rank = 'Ace'
                    local rank_c = 0
                    local common_suit = 'Hearts'
                    local suit_c = 0
                    G.GAME.hit_stood_ranks = G.GAME.hit_stood_ranks or {}
                    G.GAME.hit_stood_suits = G.GAME.hit_stood_suits or {}
                    for i, j in pairs(G.GAME.hit_stood_ranks) do
                        if j > rank_c then
                            rank_c = j
                            common_rank = i
                        end
                    end
                    for i, j in pairs(G.GAME.hit_stood_suits) do
                        if j > suit_c then
                            suit_c = j
                            common_suit = i
                        end
                    end
                    common_rank = SMODS.Ranks[common_rank].card_key
                    common_suit = SMODS.Suits[common_suit].card_key
                    local card_1 = create_playing_card({front = G.P_CARDS[suit..'_'..common_rank], center = G.P_CENTERS['c_base']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
                    local card_2 = create_playing_card({front = G.P_CARDS[common_suit..'_'..rank], center = G.P_CENTERS['c_base']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
                    shuffle_card_in_deck(card_1)
                    shuffle_card_in_deck(card_2)
                    return true
                end
            })) 
        end,
        config = {},
        loc_vars = function(self, info_queue, card)
            local common_rank = 'Ace'
            local rank_c = 0
            local common_suit = 'Hearts'
            local suit_c = 0
            G.GAME.hit_stood_ranks = G.GAME.hit_stood_ranks or {}
            G.GAME.hit_stood_suits = G.GAME.hit_stood_suits or {}
            for i, j in pairs(G.GAME.hit_stood_ranks) do
                if j > rank_c then
                    rank_c = j
                    common_rank = i
                end
            end
            for i, j in pairs(G.GAME.hit_stood_suits) do
                if j > suit_c then
                    suit_c = j
                    common_suit = i
                end
            end
            return {vars = {localize(common_rank, 'ranks'), localize(common_suit, 'suits_plural')}}
        end,
        can_use = function(self, card)
            if G.deck then
                return true
            end
        end
    }

    SMODS.Untarot {
        key = 'unempress',
        atlas = 'reversed_tarots',
        pos = {x = 3, y = 0},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            for i = 1, card.ability.cards do
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        local new_card = SMODS.create_card {set = 'Untarot'}
                        new_card:add_to_deck()
                        G.consumeables:emplace(new_card)
                        used_tarot:juice_up(0.3, 0.5)
                    end
                    return true end }))
            end
            delay(0.6)
        end,
        config = {cards = 2},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.cards or 2}}
        end,
        can_use = function(self, card)
            if #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables then
                return true
            end
        end
    }

    SMODS.Untarot {
        key = 'unemperor',
        atlas = 'reversed_tarots',
        pos = {x = 4, y = 0},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local suit = SMODS.Suits[G.hand.highlighted[i].base.suit].card_key
                
                    G.hand.highlighted[i]:set_base(G.P_CARDS[suit..'_K'])
                    G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 2},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 2, localize('King', 'ranks')}}
        end
    }

    SMODS.Untarot {
        key = 'unheirophant',
        atlas = 'reversed_tarots',
        pos = {x = 0, y = 1},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            local common_suit = "H"
            local suit_count = 0
            for i, j in pairs(SMODS.Suits) do
                local count = 0
                for i=1, #G.hand.highlighted do
                    if G.hand.highlighted[i]:is_suit(j.key) then
                        count = count + 1
                    end
                end
                if count > suit_count then
                    common_suit = j.card_key
                    suit_count = count
                end
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local rank = SMODS.Ranks[G.hand.highlighted[i].base.value].card_key
                
                    G.hand.highlighted[i]:set_base(G.P_CARDS[common_suit..'_'..rank])
                    G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 200},
        can_use = function(self, card)
            if (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and (#G.hand.highlighted >= 1) then
                return true
            end
        end
    }

    SMODS.Rank {
        key = '0',
        card_key = 'Z',
        pos = { x = 0 },
        lc_atlas = 'ranks',
        hc_atlas = 'hc_ranks',
        nominal = 0,
        next = { 'Ace' },
        in_pool = function(self, args)
            return false
        end
    }

    SMODS.Untarot {
        key = 'unlovers',
        atlas = 'reversed_tarots',
        pos = {x = 1, y = 1},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local suit = SMODS.Suits[G.hand.highlighted[i].base.suit].card_key
                
                    G.hand.highlighted[i]:set_base(G.P_CARDS[suit..'_hit_Z'])
                    G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 2},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 1, '0'}}
        end
    }

    SMODS.Untarot {
        key = 'unchariot',
        atlas = 'reversed_tarots',
        pos = {x = 2, y = 1},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local suit = SMODS.Suits[G.hand.highlighted[i].base.suit].card_key
                    local ranks = {}
                    local norm_nominal = G.hand.highlighted[i].base.nominal
                    for i2, j2 in pairs(SMODS.Ranks) do
                        if (j2.nominal > norm_nominal) and (not j2.in_pool or (type(j2.in_pool) ~= 'function') or j2:in_pool()) then
                            table.insert(ranks, j2.card_key)
                        end
                    end
                    if #ranks ~= 0 then
                        local rank = pseudorandom_element(ranks, pseudoseed('untarot2'))
                        G.hand.highlighted[i]:set_base(G.P_CARDS[suit..'_'..rank])
                        G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    end
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 4},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 4}}
        end
    }

    SMODS.Untarot {
        key = 'unjustice',
        atlas = 'reversed_tarots',
        pos = {x = 3, y = 1},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            ease_dollars(-card.ability.dollars)
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local suit = SMODS.Suits[G.hand.highlighted[i].base.suit].card_key
                    local rank_data = SMODS.Ranks[G.hand.highlighted[i].base.value]
                    local up_rank = pseudorandom_element(rank_data.next, pseudoseed('untarot'))
                    up_rank = SMODS.Ranks[up_rank]
                    if up_rank then
                        rank_data = up_rank
                        up_rank = pseudorandom_element(rank_data.next, pseudoseed('untarot'))
                        up_rank = SMODS.Ranks[up_rank].card_key
                
                        G.hand.highlighted[i]:set_base(G.P_CARDS[suit..'_'..up_rank])
                        G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    end
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {dollars = 2, max_highlighted = 3},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.dollars or 2, card and card.ability.max_highlighted or 3}}
        end
    }

    SMODS.Untarot {
        key = 'unhermit',
        atlas = 'reversed_tarots',
        pos = {x = 4, y = 1},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    G.hand.highlighted[i].ability.shuffle_bottom = card.ability.rounds
                    return true 
                end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 6, rounds = 4},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 6, card and card.ability.rounds or 4}}
        end,
        can_use = function(self, card)
            if (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and (#G.hand.highlighted >= 1) and (#G.hand.highlighted <= (card and card.ability.max_highlighted or 6)) then
                return true
            end
        end
    }

    SMODS.Enhancement {
        key = 'nope',
        name = "Nope Card",
        atlas = 'enhance',
        config = {},
        pos = {x = 1, y = 0},
        in_pool = function(self)
            return false
        end,
    }

    SMODS.Untarot {
        key = 'unwheel_of_fortune',
        atlas = 'reversed_tarots',
        pos = {x = 0, y = 2},
        use = function(self, card, area, copier)
            ease_dollars(card.ability.dollars)
            if (pseudorandom('untarot_debuff') < G.GAME.probabilities.normal/card.ability.odds) then
                local used_tarot = copier or card
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    play_sound('tarot1')
                    used_tarot:juice_up(0.3, 0.5)
                    return true end }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local suits = {'H', 'S', 'D', 'C'}
                        local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
                        local rank = pseudorandom_element(ranks, pseudoseed('untarot'))
                        local suit = pseudorandom_element(suits, pseudoseed('untarot'))
                        local card_ = create_playing_card({front = G.P_CARDS[suit..'_'..rank], center = G.P_CENTERS['m_hit_nope']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
                        shuffle_card_in_deck(card_)
                        return true
                    end
                })) 
            end
        end,
        config = {dollars = 10, odds = 2},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS['m_hit_nope']
            return {vars = {card and card.ability.dollars or 5, G.GAME.probabilities.normal, card and card.ability.odds or 2, localize{type = 'name_text', set = 'Enhanced', key = 'm_hit_nope'}}}
        end,
        can_use = function(self, card)
            if G.deck then
                return true
            end
        end
    }

    SMODS.Untarot {
        key = 'unstrength',
        atlas = 'reversed_tarots',
        pos = {x = 1, y = 2},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            local did_debuff = (pseudorandom('untarot_debuff') < G.GAME.probabilities.normal/card.ability.odds)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local pool = {}
                    for j, k in pairs(G.P_CENTER_POOLS['Enhanced']) do
                        if not k.in_pool or (type(k.in_pool) ~= 'function') or k:in_pool() and not G.GAME.banned_keys[k.key] then
                            table.insert(pool, k)
                        end
                    end
                    local enhancement = pseudorandom_element(pool, pseudoseed('untarot'))
                    G.hand.highlighted[i]:set_ability(enhancement)
                    if did_debuff then
                        G.hand.highlighted[i].ability.perma_debuff = true
                    end
                    G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {odds = 5, max_highlighted = 4},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 4, G.GAME.probabilities and G.GAME.probabilities.normal or 1, card and card.ability.odds or 5}}
        end
    }

    SMODS.Untarot {
        key = 'unhanged_man',
        atlas = 'reversed_tarots',
        pos = {x = 2, y = 2},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = 1, card.ability.cards do
                        local suits = {'H', 'S', 'D', 'C'}
                        local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
                        local rank = pseudorandom_element(ranks, pseudoseed('untarot'))
                        local suit = pseudorandom_element(suits, pseudoseed('untarot'))
                        local pool = {}
                        for j, k in pairs(G.P_CENTER_POOLS['Enhanced']) do
                            if not k.in_pool or (type(k.in_pool) ~= 'function') or k:in_pool() then
                                table.insert(pool, k)
                            end
                        end
                        local enhancement = pseudorandom_element(pool, pseudoseed('untarot'))
                        local card_ = create_playing_card({front = G.P_CARDS[suit..'_'..rank], center = enhancement}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
                        shuffle_card_in_deck(card_)
                    end
                    return true
                end
            })) 
        end,
        config = {cards = 2},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.cards or 2}}
        end,
        can_use = function(self, card)
            if G.deck then
                return true
            end
        end
    }

    SMODS.Enhancement {
        key = 'garnet',
        name = "Garnet Card",
        atlas = 'enhance',
        config = {},
        pos = {x = 2, y = 0},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon
        end,
    }

    SMODS.Untarot {
        key = 'undeath',
        atlas = 'reversed_tarots',
        pos = {x = 3, y = 2},
        config = {max_highlighted = 2, mod_conv = 'm_hit_garnet'},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS['m_hit_garnet']
            return {vars = {card and card.ability.max_highlighted or 2, localize{type = 'name_text', set = 'Enhanced', key = 'm_hit_garnet'}}}
        end
    }

    SMODS.Untarot {
        key = 'untemperance',
        atlas = 'reversed_tarots',
        pos = {x = 4, y = 2},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local suit = SMODS.Suits[G.hand.highlighted[i].base.suit].card_key
                    local ranks = {'7', '7', '7', 'J', 'Q', 'K'}
                    local rank = pseudorandom_element(ranks, pseudoseed('untarot'))
                
                    G.hand.highlighted[i]:set_base(G.P_CARDS[suit..'_'..rank])
                    G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 4},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 4, localize('7', 'ranks')}}
        end
    }

    SMODS.Untarot {
        key = 'undevil',
        atlas = 'reversed_tarots',
        pos = {x = 0, y = 3},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local suit = SMODS.Suits[G.hand.highlighted[i].base.suit].card_key
                
                    G.hand.highlighted[i]:set_base(G.P_CARDS[suit..'_A'])
                    G.hand.highlighted[i].ability.perma_debuff = true
                    G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 2},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 2, localize('Ace', 'ranks')}}
        end
    }

    SMODS.Enhancement {
        key = 'crazy',
        name = "Crazy Card",
        atlas = 'enhance',
        no_rank = true,
        no_suit = true,
        replace_base_card = true,
        config = {chips = 7},
        pos = {x = 0, y = 1},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.chips or 7}}
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                return {chips = card and card.ability.chips or 7}
            end
        end
    }

    SMODS.Untarot {
        key = 'untower',
        atlas = 'reversed_tarots',
        pos = {x = 1, y = 3},
        config = {max_highlighted = 1, mod_conv = 'm_hit_crazy'},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS['m_hit_crazy']
            return {vars = {card and card.ability.max_highlighted or 1, localize{type = 'name_text', set = 'Enhanced', key = 'm_hit_crazy'}}}
        end
    }

    SMODS.Untarot {
        key = 'unstar',
        atlas = 'reversed_tarots',
        pos = {x = 2, y = 3},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            delay(0.2)
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                local pool = {}
                for i = 1, #G.hand.cards do
                    table.insert(pool, G.hand.cards[i])
                end
                local destroy = {}
                for i = 1, (card and card.ability.cards or 3) do
                    local card2, index = pseudorandom_element(pool, pseudoseed('untarot'))
                    table.remove(pool, index)
                    table.insert(destroy, card2)
                end
                for i = 1, #destroy do
                    destroy[i]:start_dissolve()
                end
                return true 
            end }))
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {cards = 3},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.cards or 3}}
        end,
        can_use = function(self, card)
            if (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and (#G.hand.cards >= (card and card.ability.cards or 3)) then
                return true
            end
        end
    }

    SMODS.Untarot {
        key = 'unmoon',
        atlas = 'reversed_tarots',
        pos = {x = 3, y = 3},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    G.hand.highlighted[i].ability.shuffle_top = card.ability.rounds
                    return true 
                end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 3, rounds = 4},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 3, card and card.ability.rounds or 4}}
        end,
    }

    SMODS.Untarot {
        key = 'unsun',
        atlas = 'reversed_tarots',
        pos = {x = 4, y = 3},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local suit = SMODS.Suits[G.hand.highlighted[i].base.suit].card_key
                    local ranks = {}
                    local norm_nominal = G.hand.highlighted[i].base.nominal
                    for i2, j2 in pairs(SMODS.Ranks) do
                        if (j2.nominal < norm_nominal) and (not j2.in_pool or (type(j2.in_pool) ~= 'function') or j2:in_pool()) then
                            table.insert(ranks, j2.card_key)
                        end
                    end
                    if #ranks ~= 0 then
                        local rank = pseudorandom_element(ranks, pseudoseed('untarot2'))
                        G.hand.highlighted[i]:set_base(G.P_CARDS[suit..'_'..rank])
                        G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    end
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 4},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 4}}
        end
    }

    SMODS.Untarot {
        key = 'unjudgement',
        atlas = 'reversed_tarots',
        pos = {x = 0, y = 4},
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true end }))
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            delay(0.2)

            local rank = get_smods_rank_from_id(G.hand.cards[1]).card_key
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    local suit = SMODS.Suits[G.hand.highlighted[i].base.suit].card_key
                
                    G.hand.highlighted[i]:set_base(G.P_CARDS[suit..'_'..rank])
                    G.GAME.blind:debuff_card(G.hand.highlighted[i])
                    return true 
                end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
            delay(0.5)
        end,
        config = {max_highlighted = 2},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability.max_highlighted or 2}}
        end
    }

    SMODS.Enhancement {
        key = 'osmium',
        name = "Osmium Card",
        atlas = 'enhance',
        config = {},
        pos = {x = 1, y = 1},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon
        end,
    }

    SMODS.Untarot {
        key = 'unworld',
        atlas = 'reversed_tarots',
        pos = {x = 1, y = 4},
        config = {max_highlighted = 2, mod_conv = 'm_hit_osmium'},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS['m_hit_osmium']
            return {vars = {card and card.ability.max_highlighted or 2, localize{type = 'name_text', set = 'Enhanced', key = 'm_hit_osmium'}}}
        end
    }

    for i = 1, 4 do
        SMODS.Booster {
            key = 'unarcana_normal_' .. tostring(i),
            group_key = 'k_unarcana_pack',
            weight = 1,
            cost = 4,
            name = "Unarcana Pack",
            atlas = "boosters",
            pos = {x = i - 1, y = 0},
            config = {extra = 3, choose = 1, name = "Unarcana Pack"},
            create_card = function(self, card)
                return {set = "Untarot", skip_materialize = true}
            end,
            loc_txt = {
                name = "Unarcana Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:attention} Untarot{} cards to",
                    "be used immediately"
                }
            },
            draw_hand = true,
            in_pool = function(self)
                return G.GAME.modifiers.dungeon
            end,
            ease_background_colour = function(self)
                ease_colour(G.C.DYN_UI.MAIN, HEX('a58547'))
                ease_background_colour{new_colour = HEX('a58547'), special_colour = G.C.BLACK, contrast = 2}
            end,
        }
    end

    for i = 1, 2 do
        SMODS.Booster {
            key = 'unarcana_jumbo_' .. tostring(i),
            group_key = 'k_unarcana_pack',
            weight = 1,
            cost = 6,
            name = "Unarcana Pack",
            atlas = "boosters",
            pos = {x = i - 1, y = 1},
            config = {extra = 5, choose = 1, name = "Unarcana Pack"},
            create_card = function(self, card)
                return {set = "Untarot", skip_materialize = true}
            end,
            loc_txt = {
                name = "Jumbo Unarcana Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:attention} Untarot{} cards to",
                    "be used immediately"
                }
            },
            draw_hand = true,
            in_pool = function(self)
                return G.GAME.modifiers.dungeon
            end,
            ease_background_colour = function(self)
                ease_colour(G.C.DYN_UI.MAIN, HEX('a58547'))
                ease_background_colour{new_colour = HEX('a58547'), special_colour = G.C.BLACK, contrast = 2}
            end,
        }
        SMODS.Booster {
            key = 'unarcana_mega_' .. tostring(i),
            group_key = 'k_unarcana_pack',
            weight = 1,
            cost = 8,
            name = "Unarcana Pack",
            atlas = "boosters",
            pos = {x = i + 1, y = 1},
            config = {extra = 5, choose = 2, name = "Unarcana Pack"},
            create_card = function(self, card)
                return {set = "Untarot", skip_materialize = true}
            end,
            loc_txt = {
                name = "Mega Unarcana Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:attention} Untarot{} cards to",
                    "be used immediately"
                }
            },
            draw_hand = true,
            in_pool = function(self)
                return G.GAME.modifiers.dungeon
            end,
        }
    end

------------------------

SMODS.Booster {
    key = 'minorarcana_normal_1',
    atlas = 'boosters',
    group_key = 'k_minorarcana_pack',
    loc_txt = {
        name = "Minor Arcana Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Minor Arcana{} cards",
            "to add to your deck"
        }
    },
    weight = 1,
    name = "Minor Arcana Pack",
    pos = {x = 0, y = 2},
    config = {extra = 3, choose = 1, name = "Minor Arcana Pack"},
    create_card = function(self, card)
        local bases = {'hit_P_A', 'hit_CP_A', 'hit_SW_A', 'hit_W_A', 'hit_P_2', 'hit_CP_2', 'hit_SW_2', 'hit_W_2', 'hit_P_3', 'hit_CP_3', 'hit_SW_3', 'hit_W_3', 'hit_P_4', 'hit_CP_4', 'hit_SW_4', 'hit_W_4'}
        local base = pseudorandom_element(bases, pseudoseed('pack'))
        local _card = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, G.P_CARDS[base], G.P_CENTERS['c_base'], {playing_card = G.playing_card})
        return _card
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX('a58547'))
        ease_background_colour{new_colour = HEX('a58547'), special_colour = G.C.BLACK, contrast = 2}
    end,
}

-----Jokers-------------

    SMODS.Joker {
        key = 'social',
        name = "Social Joker",
        rarity = 1,
        atlas = 'jokers',
        pos = {x = 0, y = 0},
        cost = 4,
        config = {t_mult = 8, type = 'hit_Court'},
        effect = "Type Mult",
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.t_mult or 8, localize(card and card.ability and card.ability.type or 'hit_Court', 'poker_hands')}}
        end,
    }

    SMODS.Joker {
        key = 'manipulative',
        name = "Maniplulative Joker",
        rarity = 1,
        atlas = 'jokers',
        pos = {x = 1, y = 0},
        cost = 4,
        config = {t_mult = 12, type = 'hit_Duo'},
        effect = "Type Mult",
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.t_mult or 12, localize(card and card.ability and card.ability.type or 'hit_Duo', 'poker_hands')}}
        end,
    }

    SMODS.Joker {
        key = 'creative',
        name = "Creative Joker",
        rarity = 1,
        atlas = 'jokers',
        pos = {x = 2, y = 0},
        cost = 4,
        config = {t_mult = 12, type = 'hit_Batch'},
        effect = "Type Mult",
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.t_mult or 12, localize(card and card.ability and card.ability.type or 'hit_Batch', 'poker_hands')}}
        end,
    }

    SMODS.Joker {
        key = 'merry',
        name = "Merry Joker",
        rarity = 1,
        atlas = 'jokers',
        pos = {x = 3, y = 0},
        cost = 4,
        config = {t_chips = 50, type = 'hit_Court'},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.t_chips or 50, localize(card and card.ability and card.ability.type or 'hit_Court', 'poker_hands')}}
        end,
    }

    SMODS.Joker {
        key = 'secretive',
        name = "Secretive Joker",
        rarity = 1,
        atlas = 'jokers',
        pos = {x = 4, y = 0},
        cost = 4,
        config = {t_chips = 80, type = 'hit_Duo'},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.t_chips or 80, localize(card and card.ability and card.ability.type or 'hit_Duo', 'poker_hands')}}
        end,
    }

    SMODS.Joker {
        key = 'hoarding',
        name = "Hoarding Joker",
        rarity = 1,
        atlas = 'jokers',
        pos = {x = 0, y = 1},
        cost = 4,
        config = {t_chips = 100, type = 'hit_Batch'},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.t_chips or 100, localize(card and card.ability and card.ability.type or 'hit_Batch', 'poker_hands')}}
        end,
    }

    SMODS.Joker {
        key = 'friends',
        name = "The Friends",
        rarity = 3,
        atlas = 'jokers',
        pos = {x = 1, y = 1},
        cost = 8,
        config = {Xmult = 2, type = 'hit_Court'},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.Xmult or 2, localize(card and card.ability and card.ability.type or 'hit_Court', 'poker_hands')}}
        end,
    }

    SMODS.Joker {
        key = 'pair',
        name = "The Pair",
        rarity = 3,
        atlas = 'jokers',
        pos = {x = 2, y = 1},
        cost = 8,
        config = {Xmult = 3, type = 'hit_Duo'},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.Xmult or 3, localize(card and card.ability and card.ability.type or 'hit_Duo', 'poker_hands')}}
        end,
    }

    SMODS.Joker {
        key = 'bundle',
        name = "The Bundle",
        rarity = 3,
        atlas = 'jokers',
        pos = {x = 3, y = 1},
        cost = 8,
        config = {Xmult = 3, type = 'hit_Batch'},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.Xmult or 3, localize(card and card.ability and card.ability.type or 'hit_Batch', 'poker_hands')}}
        end,
    }

    SMODS.Joker {
        key = 'constructing_primes',
        name = "Constructing Primes",
        rarity = 2,
        atlas = 'jokers',
        pos = {x = 4, y = 1},
        cost = 6,
        config = {hit_x_mult = 1.3},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.hit_x_mult or 1.3}}
        end,
        calculate = function(self, card, context)
            if (context.cardarea == G.play) and context.individual and not context.repetition and not context.end_of_round then
                if (context.other_card:get_id() == 2) or (context.other_card:get_id() == 3) or (context.other_card:get_id() == 5) or (context.other_card:get_id() == 7) or (context.other_card:get_id() == 14) then
                    return {
                        x_mult = card.ability.hit_x_mult,
                        card = card
                    }
                end
            end
        end,
    }

    SMODS.Joker {
        key = 'tiebreaker',
        name = "Tiebreaker",
        rarity = 2,
        atlas = 'jokers',
        pos = {x = 0, y = 2},
        cost = 5,
        config = {},
        blueprint_compat = false,
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
    }

    SMODS.Joker {
        key = 'jackpot',
        name = "Jackpot",
        rarity = 2,
        atlas = 'jokers',
        pos = {x = 1, y = 2},
        cost = 7,
        config = {},
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS['m_lucky']
            return {vars = {}}
        end,
        calculate = function(self, card, context)
            if context.before and not context.blueprint and context.full_hand and (context.cardarea == G.jokers) then
                sevens = {}
                for i, j in ipairs(context.full_hand) do
                    if j:get_id() == 7 then
                        table.insert(sevens, j)
                    end
                end
                if #sevens >= 3 then
                    card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.MONEY, message = localize('k_lucky_ex')})
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            play_sound('multhit1')
                            local suits = {'H', 'S', 'D', 'C'}
                            local suit = pseudorandom_element(suits, pseudoseed('untarot'))
                            local card_ = create_playing_card({front = G.P_CARDS[suit..'_7'], center = G.P_CENTERS['m_lucky']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
                            shuffle_card_in_deck(card_)
                            return true
                        end
                    }))
                end
            end
        end,
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
    }

    SMODS.Joker {
        key = 'supernatural_stars',
        name = "Supernatural Stars",
        rarity = 2,
        atlas = 'jokers',
        pos = {x = 2, y = 2},
        cost = 6,
        config = {},
        calculate = function(self, card, context)
            if context.post_stand and (context.cardarea == G.jokers) and (#G.hand.cards == 7) and context.won then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'spec')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                    card = card
                }
            end
        end,
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
    }

    SMODS.Joker {
        key = 'perfect_crystal',
        name = "Perfect Crystal",
        rarity = 2,
        atlas = 'jokers',
        pos = {x = 3, y = 2},
        cost = 6,
        config = {hit_x_mult = 3},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = {set = 'Other', key = 'perfect'}
            return {vars = {card and card.ability and card.ability.hit_x_mult or 3}}
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                for i = 1, #G.play.cards do
                    if G.play.cards[i]:get_id() == 14 then
                        return
                    end
                end
                local y_data = get_card_total(G.play.cards, nil, context.add_total)
                if y_data.total == y_data.bust_limit then
                    return {

                        message = localize{type='variable',key='a_xmult',vars={card.ability.hit_x_mult}},
                        Xmult_mod = card.ability.hit_x_mult
                    }
                end
            end
        end,
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
    }

    SMODS.Joker {
        key = 'big_chip',
        name = "Big Chip",
        rarity = 1,
        atlas = 'jokers',
        pos = {x = 4, y = 2},
        cost = 5,
        config = {bust_limit = 1},
        loc_vars = function(self, info_queue, card)
            return {vars = {card and card.ability and card.ability.bust_limit or 1}}
        end,
        add_to_deck = function(self, card, from_debuff)
            G.GAME.hit_bust_limit = (G.GAME.hit_bust_limit or 21) + 1
            check_total_over_21()
            if G.GAME.facing_blind then
                G.GAME.blind:set_text()
            end
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.GAME.hit_bust_limit = (G.GAME.hit_bust_limit or 21) - 1
            check_total_over_21()
            if G.GAME.facing_blind then
                G.GAME.blind:set_text()
            end
        end,
        in_pool = function(self)
            return G.GAME.modifiers.dungeon, {allow_duplicates = false}
        end,
    }

------------------------

--------Blinds----------

    SMODS.Blind	{
        loc_txt = {
            name = 'The Steel',
            text = { 'Every 3rd hit stands', '#1# / 3' }
        },
        key = 'steel',
        name = "The Steel",
        config = {},
        boss = {min = 1, max = 10}, 
        showdown = true,
        boss_colour = HEX("682feb"),
        vars = {"0"},
        dollars = 5,
        mult = 2,
        atlas = "blinds",
        pos = {x = 0, y = 0},
        loc_vars = function(self)
            return {vars = {G.GAME.blind and G.GAME.blind.hits and tostring(G.GAME.blind.hits) or '0'}}
        end,
        set_blind = function(self, reset, silent)
            if not reset then
                G.GAME.blind.hits = 0
            end
        end,
        defeat = function(self, reset, silent)
            G.GAME.blind.hits = nil
        end,
        disable = function(self, reset, silent)
            G.GAME.blind.hits = nil
        end,
        in_pool = function(self)
            return G.GAME.modifiers.dungeon
        end,
    }

    SMODS.Blind	{
        loc_txt = {
            name = 'The Bind',
            text = { '-2 Bust Limit' }
        },
        key = 'bind',
        name = "The Bind",
        config = {},
        boss = {min = 1, max = 10}, 
        showdown = true,
        boss_colour = HEX("8ac8bb"),
        vars = {},
        dollars = 5,
        mult = 2,
        atlas = "blinds",
        pos = {x = 0, y = 1},
        set_blind = function(self, reset, silent)
            if not reset then
                G.GAME.hit_bust_limit = (G.GAME.hit_bust_limit or 21) - 2
                G.GAME.blind:set_text()
            end
        end,
        disable = function(self)
            G.GAME.hit_bust_limit = (G.GAME.hit_bust_limit or 21) + 2
            G.GAME.blind:set_text()
        end,
        defeat = function(self)
            if not G.GAME.blind.disabled then
                G.GAME.hit_bust_limit = (G.GAME.hit_bust_limit or 21) + 2
            end
        end,
        get_stand_val = function(self)
            if G.GAME.blind and (G.GAME.blind.name == "The Bind") then
                return (G.GAME.hit_bust_limit or 21) - 4
            else
                return (G.GAME.hit_bust_limit or 21) - 6
            end
        end,
        in_pool = function(self)
            return G.GAME.modifiers.dungeon
        end
    }

    SMODS.Blind	{
        loc_txt = {
            name = 'The House',
            text = { 'All cards drawn face', 'down until stand' }
        },
        key = 'house',
        name = "hit_The House",
        config = {},
        boss = {min = 2, max = 10}, 
        boss_colour = HEX("5186a8"),
        vars = {},
        dollars = 5,
        mult = 2,
        pos = {x = 0, y = 3},
        stay_flipped = function(self, area, card)
            if area == G.hand then
                return true
            end
        end,
        disable = function(self)
            if not G.GAME.blind.do_not_flip then
                for i = 1, #G.hand.cards do
                    if G.hand.cards[i].facing == 'back' then
                        G.hand.cards[i]:flip()
                    end
                end
                for k, v in pairs(G.playing_cards) do
                    v.ability.wheel_flipped = nil
                end
            end
        end,
        in_pool = function(self)
            return G.GAME.modifiers.dungeon
        end
    }

    SMODS.Blind	{
        loc_txt = {
            name = 'The Needle',
            text = { 'Causes death if first', 'hand is \'Loss\'' }
        },
        key = 'needle',
        name = "hit_The Needle",
        config = {},
        boss = {min = 2, max = 10}, 
        boss_colour = HEX("5c6e31"),
        vars = {},
        dollars = 5,
        mult = 2,
        pos = {x = 0, y = 20},
        in_pool = function(self)
            return G.GAME.modifiers.dungeon
        end
    }

------------------------

SMODS.Seal {
    key = 'blue',
    pos = { x = 6, y = 4 },
    badge_colour = G.C.BLUE,
    sound = { sound = 'gold_seal', per = 1.2, vol = 0.4 },
    atlas = 'centers',
    prefix_config = {
        atlas = false, 
    },
    in_pool = function(self)
        return G.GAME.modifiers.dungeon
    end,
}

SMODS.Spectral {
    key = 'trance',
    pos = {x = 3 , y = 5},
    config = {extra = 'hit_blue', max_highlighted = 1},
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true end }))
        
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            conv_card:set_seal('hit_blue', nil, true)
            return true end }))
        
        delay(0.5)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS['hit_blue']
        return {vars = {}}
    end,
    in_pool = function(self)
        return G.GAME.modifiers.dungeon, {allow_duplicates = false}
    end,
}

local old_buttons = create_UIBox_buttons
function create_UIBox_buttons()
    local t = old_buttons()
    if G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.dungeon then
        local index = 3
        if G.SETTINGS.play_button_pos ~= 1 then
            index = 1
        end
        local button = t.nodes[index]
        button.nodes[1].nodes[1].config.text = nil
        button.nodes[1].nodes[1].config.ref_value = 'hit_discard_button'
        button.nodes[1].nodes[1].config.ref_table = G.GAME
        button.config.button = 'hit'
        button.config.func = 'can_hit'
        -- button.config.color = G.C[checking[G.GAME.active].colour]
    end
    if G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.dungeon then
        local index = 1
        if G.SETTINGS.play_button_pos ~= 1 then
            index = 3
        end
        G.GAME.hit_hand_sum_total = G.GAME.hit_hand_sum_total or '???'
        local button = t.nodes[index]
        button.nodes[1].nodes[1].config.text = nil
        button.nodes[1].nodes[1].config.ref_value = 'hit_hand_sum_total'
        button.nodes[1].nodes[1].config.ref_table = G.GAME
        button.config.button = 'stand'
        button.config.func = 'can_stand'
        -- button.config.color = G.C[checking[G.GAME.passive].colour]
    end
    return t
end

function check_total_over_21()
    if G.GAME.modifiers.dungeon and not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
        G.GAME.hit_hand_sum_total = get_hand_sum()
        local data = get_card_total(G.hand.cards, false)
        if (data.total > data.bust_limit) and not G.GAME.hit_busted then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    if hide_sum() then
                        play_area_status_text("Bust (??)")
                    else
                        play_area_status_text("Bust (" .. tostring(data.total) .. ")")
                    end
                    return true
                end
            }))
            G.GAME.hit_busted = true
        elseif (data.total <= data.bust_limit) then
            G.GAME.hit_busted = nil
        end
    end
end

function get_hand_sum()
    local data = get_card_total(G.hand.cards)
    if hide_sum() then
        return localize("b_stand") .. ' ??'
    elseif data.soft then
        return localize("b_stand") .. ' S' .. tostring(data.total)
    elseif data.total > data.bust_limit then
        return localize("b_stand") .. ' ' .. tostring(data.total) .. 'B'
    else
        return localize("b_stand") .. ' ' .. tostring(data.total)
    end
end

function get_card_total(cards, do_soft, bonus_total)
    if do_soft == nil then
        do_soft = true
    end
    local suits = SMODS.Suit.obj_buffer
    local map = {}
    local total = bonus_total or 0
    local aces = 0
    local variance = 0
    local bust_limit = G.GAME.hit_bust_limit or 21
    local req_count = 0
    local soft = false
    for i = 1, #cards do
        local id = cards[i]:get_id()
        local valid = true
        if id > 0 then
            local rank = get_smods_rank_from_id(cards[i])
            local nominal = rank.nominal
            if not cards[i].debuff and cards[i].ability.trading and cards[i].ability.trading.config.hit_hand_value then
                total = total + cards[i].ability.trading.config.hit_hand_value
            elseif rank.key == 'Ace' then
                total = total + 1
                aces = aces + 1
            else
                total = total + nominal
            end
            if not cards[i].debuff and cards[i].ability.trading and cards[i].ability.trading.config.hit_hand_aces then
                aces = aces + cards[i].ability.trading.config.hit_hand_aces
            end
        elseif cards[i].ability.name == 'Crazy Card' then
            total = total - 3
            aces = aces + 1
        else
            valid = false
        end
        if not cards[i].debuff and (cards[i].ability.name == 'Mega Blackjack Card') then
            total = total + 1
            variance = variance + 3
            valid = true
        elseif not cards[i].debuff and (cards[i].ability.name == 'Nope Card') then
            total = total + 13
            valid = true
        end
        if valid then
            req_count = req_count + 1
            for j = 1, #suits do
                if cards[i]:is_suit(suits[j], nil, true) then
                    map[suits[j]] = map[suits[j]] or {}
                    map[suits[j]][#map[suits[j]]+1] = cards[i] 
                end
            end
        end
    end
    if do_soft then
        while (total <= bust_limit - 10) and (aces >= 1) do
            aces = aces - 1
            total = total + 10
            soft = true
        end
        while (total <= bust_limit - 1) and (variance >= 1) do
            variance = variance - 1
            total = total + 1
            soft = true
        end
    end
    return {
        total = total,
        bust_limit = bust_limit,
        suit_map = map,
        card_count = req_count,
        soft = soft
    }
end

function hide_sum()
    for i = 1, #G.hand.cards do
        if G.hand.cards[i].facing == 'back' then
            return true
        end
    end
    return false
end

local old_use = Card.use_consumeable
function Card:use_consumeable(area, copier)
    old_use(self, area, copier)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            check_total_over_21()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    check_total_over_21()
                    return true
                end
            }))
            return true
        end
    }))
end

G.FUNCS.can_hit = function(e)
    if G.hand and G.hand.highlighted and (#G.hand.highlighted == 1) and (G.GAME.current_round.discards_left > 0) then
        e.config.colour = G.C.RED
        e.config.button = 'discard_cards_from_highlighted'
    elseif G.GAME.stood or G.GAME.hit_busted or (#G.deck.cards == 0) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.IMPORTANT
        e.config.button = 'hit'
    end
end

G.FUNCS.hit = function(e, no_state)
    if not no_state then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.STATE = G.STATES.DRAW_TO_HAND
                G.STATE_COMPLETE = false
                return true
            end
        }))
    end
    local valid = true
    local add_limit = 0
    for i = 1, #G.hand.cards do
        if G.hand.cards[i].calculate_exotic then
            local result = G.hand.cards[i]:calculate_exotic({hit = true, cardarea = G.hand})
            if result and result.add_limit then
                add_limit = add_limit + result.add_limit
            end
        end
    end
    if valid then
        G.GAME.hit_limit = (G.hand and G.hand.cards and #G.hand.cards or 2) + 1 + add_limit
    end
    if G.GAME.blind.hits then
        G.GAME.blind.hits = G.GAME.blind.hits + 1
        if G.GAME.blind.hits == 3 then
            G.GAME.forced_stand = true
            G.GAME.blind.hits = 0
        end
        G.GAME.blind:set_text()
    end
end

G.FUNCS.can_stand = function(e)
    if G.GAME.stood then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.GREEN
        e.config.button = 'stand'
    end
end

G.FUNCS.stand = function(e)
    -- Remove buttons 
    if G.GAME.hit_3C_countdown_p then
        G.GAME.hit_3C_countdown_p = G.GAME.hit_3C_countdown_p - 1
        if G.GAME.hit_3C_countdown_p == 0 then
            G.GAME.hit_3C_countdown_p = nil
        end
        full_reset_cards_debuff()
    end
    if G.GAME.double_mult then
        G.GAME.negate_hand = (G.GAME.negate_hand or 1) * 2
        G.GAME.double_mult = nil
    end
    if G.GAME.blind and (G.GAME.blind.name == "hit_The House") and not G.GAME.blind.disabled then
        G.GAME.blind.do_not_flip = true
        G.GAME.blind:disable()
        G.GAME.blind.do_not_flip = nil
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))
    -- Osmium Cards
    local add_total = 0
    for i = 1, #G.hand.cards do
        if G.hand.cards[i].ability.name == 'Osmium Card' then
            add_total = add_total + 2
        end
        if G.hand.cards[i].calculate_exotic then
            G.hand.cards[i]:calculate_exotic({stand = true, cardarea = G.hand})
        end
    end
    local y_data = get_card_total(G.hand.cards, nil, add_total)
    local total = y_data.total
    G.GAME.hit_busted = nil
    G.GAME.stood = true
    G.GAME.hit_stood_ranks = G.GAME.hit_stood_ranks or {}
    G.GAME.hit_stood_suits = G.GAME.hit_stood_suits or {}
    -- Blind Actions
    local obj = G.GAME.blind.config.blind
    local bl_total = 0
    local bl_cards = {}
    local bl_actions = {}
    local total_list = {}
    local stand_val = (G.GAME.hit_bust_limit or 21) - 4
    if obj.get_stand_val then
        if type(obj.get_stand_val) == 'function' then
            stand_val = obj:get_stand_val()
        elseif type(obj.get_stand_val) == 'number' then
            stand_val = obj.get_stand_val
        end
    elseif obj.name == "Small Blind" then
        stand_val = (G.GAME.hit_bust_limit or 21) - 6
    end
    while true do
        local next_action = 'hit'
        if (bl_total >= stand_val) then
            next_action = 'stand'
        end
        if next_action == 'stand' then
            table.insert(bl_actions, {'stand'})
            break
        elseif next_action == 'hit' then
            local index = #G.enemy_deck.cards - #bl_cards
            if index <= 0 then
                break
            else
                local id = G.enemy_deck.cards[index]:get_id()
                table.insert(bl_cards, G.enemy_deck.cards[index])
                local bl_data = get_card_total(bl_cards)
                bl_total = bl_data.total
                table.insert(total_list, bl_total)
                table.insert(bl_actions, {'hit', G.enemy_deck.cards[index], bl_total})
            end
        end
    end
    if total > y_data.bust_limit then
        total = -1e15
    end
    local bl_data = get_card_total(bl_cards, nil, add_total)
    bl_total = bl_data.total
    if bl_total > bl_data.bust_limit then
        bl_total = -1e15
    end
    local force_push = nil
    for i = 1, #bl_cards  do
        if not bl_cards[i].debuff and bl_cards[i].ability.trading and (bl_cards[i].ability.trading.name == 'Sun Two') then
            force_push = true
            break
        end
    end
    for i = 1, #G.hand.cards do
        if not G.hand.cards[i].debuff and G.hand.cards[i].ability.trading and (G.hand.cards[i].ability.trading.name == 'Sun Two') then
            force_push = true
            break
        end
    end
    if force_push then
        if (bl_total ~= -1e15) then
            bl_total = 0
        end
        if (total ~= -1e15) then
            total = 0
        end
    end
    SMODS.calculate_context({stand = true, cardarea = G.jokers, add_total = add_total})
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            if #bl_actions > 0 then
                for i = 1, #bl_actions do
                    if bl_actions[i][1] == 'hit' then
                        draw_card(G.enemy_deck, G.play, i*100/5, 'up', nil, bl_actions[i][2])
                        force_up_status_text = true
                        local color = G.C.FILTER
                        if bl_actions[i][3] > (bl_data.bust_limit) then
                            color = G.C.RED
                        elseif bl_actions[i][3] >= stand_val then
                            color = G.C.GREEN
                        end
                        card_eval_status_text(bl_actions[i][2], 'extra', nil, nil, nil, {message = tostring(bl_actions[i][3]), colour = color})
                        force_up_status_text = nil
                    elseif bl_actions[i][1] == 'stand' then
                        if G.GAME.hit_3C_countdown_e then
                            G.GAME.hit_3C_countdown_e = G.GAME.hit_3C_countdown_e - 1
                            if G.GAME.hit_3C_countdown_e == 0 then
                                G.GAME.hit_3C_countdown_e = nil
                            end
                            full_reset_cards_debuff()
                        end
                    end
                end
            end
            delay(0.5)
            if (bl_total > total) or (not next(SMODS.find_card('j_hit_tiebreaker')) and (bl_total == total)) then
                local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.hand.cards)
                for i = 1, #G.hand.cards do
                    if G.hand.cards[i].seal == 'hit_blue' then
                        update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= disp_text and 'button' or nil, volume = 0.4, nopulse = nil, delay = G.GAME.current_round.current_hand.handname ~= disp_text and 0.4 or 0}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})
                        level_up_hand(G.hand.cards[i], text)
                        update_hand_text({nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
                        delay(0.1)
                    end
                end
            end
            if (bl_total < total) or (next(SMODS.find_card('j_hit_tiebreaker')) and (bl_total == total)) then
                if bl_total == -1e15 then
                    if (next(SMODS.find_card('j_hit_tiebreaker')) and (bl_total == total)) then
                        play_area_status_text("Win (Bust = Bust)")
                    else
                        play_area_status_text("Win (" .. tostring(total) .. " > Bust)")
                    end
                else
                    if (next(SMODS.find_card('j_hit_tiebreaker')) and (bl_total == total)) then
                        play_area_status_text("Win (" .. tostring(total) .. " = " .. tostring(bl_total) .. ")")
                    else
                        play_area_status_text("Win (" .. tostring(total) .. " > " .. tostring(bl_total) .. ")")
                    end
                end
                SMODS.calculate_context({post_stand = true, cardarea = G.jokers, add_total = add_total , won = true})
                if G.GAME.blind and (G.GAME.blind.name == "hit_The Needle") and not G.GAME.blind.disabled then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.GAME.blind:disable()
                            return true
                        end
                    }))
                end
                G.GAME.hit_limit = 2
                ease_hands_played(1)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        for i = 1, #G.play.cards do
                            draw_card(G.play, G.enemy_discard, i*100/5, 'up')
                        end
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                for i = 1, #G.hand.cards do
                                    if not G.hand.cards[i].highlighted then
                                        G.hand:add_to_highlighted(G.hand.cards[i])
                                    end
                                    local id = G.hand.cards[i]:get_id()
                                    local suit = SMODS.Suits[G.hand.cards[i].base.suit] or {}
                                    if id > 0 then
                                        local rank = get_smods_rank_from_id(G.hand.cards[i])
                                        G.GAME.hit_stood_ranks[rank.key] = (G.GAME.hit_stood_ranks[rank.key] or 1) + 1
                                    end
                                    if G.hand.cards[i]:is_suit(suit.key) then
                                        G.GAME.hit_stood_suits[suit.key] = (G.GAME.hit_stood_suits[suit.key] or 1) + 1
                                    end
                                end
                                G.FUNCS.play_cards_from_highlighted()
                                G.GAME.hit_busted = nil
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'immediate',
                                    func = function()
                                        G.GAME.stood = nil
                                        return true
                                    end
                                }))
                                return true
                            end
                        }))
                        return true
                    end
                }))
            elseif bl_total == total then
                if bl_total == -1e15 then
                    if hide_sum() then
                        play_area_status_text("Push (?? = Bust)")
                    else
                        play_area_status_text("Push (Bust = Bust)")
                    end
                else
                    if hide_sum() then
                        play_area_status_text("Push (?? = " .. tostring(bl_total) .. ")")
                    else
                        play_area_status_text("Push (" .. tostring(total) .. " = " .. tostring(bl_total) .. ")")
                    end
                end
                SMODS.calculate_context({post_stand = true, cardarea = G.jokers, add_total = add_total , won = false})
                if G.GAME.blind and (G.GAME.blind.name == "hit_The Needle") and not G.GAME.blind.disabled then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.GAME.blind:disable()
                            return true
                        end
                    }))
                end
                G.GAME.hit_limit = 2
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        for i = 1, #G.play.cards do
                            draw_card(G.play, G.enemy_discard, i*100/5, 'up')
                        end
                        for i = #G.hand.cards, 1, -1 do
                            if (G.hand.cards[i].ability.name ~= 'Garnet Card') or G.hand.cards[i].debuff then
                                draw_card(G.hand, G.discard, i*100/5, 'up', nil, G.hand.cards[i])
                            end
                        end
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                G.STATE_COMPLETE = false
                                return true
                            end
                        }))
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                G.GAME.stood = nil
                                return true
                            end
                        }))
                        return true
                    end
                }))
            elseif bl_total > total then
                if total == -1e15 then
                    if hide_sum() then
                        play_area_status_text("Loss (?? < " .. tostring(bl_total) .. ")")
                    else
                        play_area_status_text("Loss (Bust < " .. tostring(bl_total) .. ")")
                    end
                else
                    if hide_sum() then
                        play_area_status_text("Loss (?? < " .. tostring(bl_total) .. ")")
                    else
                        play_area_status_text("Loss (" .. tostring(total) .. " < " .. tostring(bl_total) .. ")")
                    end
                end
                SMODS.calculate_context({post_stand = true, cardarea = G.jokers, add_total = add_total , won = false})
                if G.GAME.blind and (G.GAME.blind.name == "hit_The Needle") and not G.GAME.blind.disabled then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            G.STATE = G.STATES.NEW_ROUND
                            G.STATE_COMPLETE = false
                            return true
                        end
                    }))
                    return true
                end
                G.GAME.hit_limit = 2
                ease_hands_played(-1)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                for i = #G.hand.cards, 1, -1 do
                                    if (G.hand.cards[i].ability.name ~= 'Garnet Card') or G.hand.cards[i].debuff then
                                        draw_card(G.hand, G.discard, i*100/5, 'up', nil, G.hand.cards[i])
                                    end
                                end
                                G.GAME.negate_hand = (G.GAME.negate_hand or 1) * -0.5
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'immediate',
                                    func = function()
                                        G.FUNCS.evaluate_play()
                                        return true
                                    end
                                }))
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    delay = 0.1,
                                    func = function()
                                        G.GAME.hands_played = G.GAME.hands_played + 1
                                        G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
                                        return true
                                    end
                                }))
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'immediate',
                                    func = function()
                                        local play_count = #G.play.cards
                                        local it = 1
                                        for k, v in ipairs(G.play.cards) do
                                            if (not v.shattered) and (not v.destroyed) then 
                                                draw_card(G.play,G.enemy_discard, it*100/play_count,'down', false, v)
                                                it = it + 1
                                            end
                                        end
                                        return true
                                    end
                                }))
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'immediate',
                                    func = function()
                                        G.STATE_COMPLETE = false
                                        return true
                                    end
                                }))
                                G.GAME.hit_busted = nil
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'immediate',
                                    func = function()
                                        G.GAME.stood = nil
                                        return true
                                    end
                                }))
                                return true
                            end
                        }))
                        return true
                    end
                }))
            end
            if #G.enemy_deck.cards - #bl_cards <= 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        for i = 1, #G.enemy_discard.cards do
                            draw_card(G.enemy_discard, G.enemy_deck, i*100/5, 'up')
                        end
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.enemy_deck:shuffle('enemy_deck')
                        return true
                    end
                }))
            end
            return true
        end
    }))
end

local old_draw_from_deck = G.FUNCS.draw_from_deck_to_hand
G.FUNCS.draw_from_deck_to_hand = function(e)
    if G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.dungeon and not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) then
        local hand_space =  math.min(2, math.max(0, (G.GAME.hit_limit or 2) - #G.hand.cards))
        if (#G.hand.cards ~= 0) and (hand_space == 2) then
            hand_space = 1
        end
        if hand_space >= 1 then
            local i = 1
            local j = 0
            while i + j <= hand_space do
                if G.deck.cards[#G.deck.cards - i - j + 1] and G.GAME.suits_drawn then
                    for i2, j2 in pairs(SMODS.Suits) do
                        if G.deck.cards[#G.deck.cards - i - j + 1]:is_suit(j2.key) then
                            G.GAME.suits_drawn[j2.key] = true
                        end
                    end
                    local count = 0
                    for i2, j2 in pairs(G.GAME.suits_drawn) do
                        count = count + 1
                    end
                    if count >= 4 then
                        G.GAME.suits_drawn = nil
                    end
                end
                if G.deck.cards[#G.deck.cards - i - j + 1] and G.deck.cards[#G.deck.cards - i - j + 1].config.card and hit_minor_arcana_suits[G.deck.cards[#G.deck.cards - i - j + 1].config.card.suit] and (#G.consumeables.cards + j < G.consumeables.config.card_limit) then
                    draw_card(G.deck,G.consumeables, 90,'up', nil, G.deck.cards[#G.deck.cards - i - j + 1])
                    j = j + 1
                else
                    draw_card(G.deck,G.hand, i*100/hand_space,'up', true)
                    i = i + 1
                end
                if G.deck.cards[#G.deck.cards - i - j + 1] then
                    G.deck.cards[#G.deck.cards - i - j + 1]:set_sprites()
                end
            end
        end
    else
        old_draw_from_deck(e)
    end
end

function set_blackjack_mode()
    G.GAME.modifiers = G.GAME.modifiers or {}
    G.GAME.modifiers.dungeon = true
    for hand, j in pairs(G.GAME.hands) do
        G.GAME.hands[hand].visible = false
        if G.GAME.hands[hand].bj_mode then
            G.GAME.hands[hand].visible = true
        end
    end
    for _, list in pairs(bj_ban_list) do
        for k, v in ipairs(list) do
            G.GAME.banned_keys[v.id] = true
        end
    end
    G.GAME.untarot_rate = 4
    if G.GAME.action_rate then
        G.GAME.action_rate = 0
    end
end

SMODS.Back {
    key = 'aced',
    name = "Aced Deck",
    pos = { x = 0, y = 0 },
    atlas = 'decks',
    apply = function(self)
        set_blackjack_mode()
        G.E_MANAGER:add_event(Event({
            func = function()
                for i, j in ipairs({'H', 'S', 'D', 'C'}) do
                    local _card = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, G.P_CARDS[j .. '_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card})
                    G.deck:emplace(_card)
                    table.insert(G.playing_cards, _card)
                end
            return true
            end
        }))
    end,
}

SMODS.Back {
    key = 'overload',
    name = "Overload Deck",
    pos = { x = 1, y = 0 },
    atlas = 'decks',
    apply = function(self)
        set_blackjack_mode()
        G.GAME.hit_bust_limit = (G.GAME.hit_bust_limit or 21) + 10
    end,
}

SMODS.Back {
    key = 'arcane',
    name = "Arcane Deck",
    pos = { x = 2, y = 0 },
    atlas = 'decks',
    apply = function(self)
        set_blackjack_mode()
        G.GAME.untarot_rate = 8
        G.GAME.hit_bust_limit = (G.GAME.hit_bust_limit or 21) - 1
    end,
}

SMODS.Back {
    key = 'temporary',
    pos = {x = 0, y = 0},
    name = "Temporary Deck",
    apply = function(self)
        set_blackjack_mode()
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1, 16 do
                    local card = pseudorandom_element(G.playing_cards, pseudoseed('collect'))
                    card:remove()
                end
                local bases = {'hit_P_A', 'hit_CP_A', 'hit_SW_A', 'hit_W_A', 'hit_P_2', 'hit_CP_2', 'hit_SW_2', 'hit_W_2', 'hit_P_3', 'hit_CP_3', 'hit_SW_3', 'hit_W_3', 'hit_P_4', 'hit_CP_4', 'hit_SW_4', 'hit_W_4'}
                for i = 1, 16 do
                    local _card = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, G.P_CARDS[bases[i]], G.P_CENTERS['c_base'], {playing_card = G.playing_card})
                    _card:set_sprites(_card.config.center)
                    G.deck:emplace(_card)
                    table.insert(G.playing_cards, _card)
                end
            return true
            end
        }))
    end
}

SMODS.Back {
    key = 'mystic',
    name = "Mystic Deck",
    pos = { x = 0, y = 1 },
    atlas = 'decks',
    apply = function(self)
        set_blackjack_mode()
        G.GAME.hit_reshuffle_deck = true
        G.GAME.starting_params.discards = 0
    end,
}

old_inject = SMODS.inject_p_card
function SMODS.inject_p_card(suit, rank)
    if suit.rank_map and suit.rank_map[rank.key] then
        G.P_CARDS[suit.card_key .. '_' .. rank.card_key] = {
            name = rank.key .. ' of ' .. suit.key,
            value = rank.key,
            suit = suit.key,
            pos = { x = suit.rank_map[rank.key] or rank.pos.x, y = suit.pos.y },
            lc_atlas = suit.rank_map[rank.key] and suit.lc_atlas or rank.lc_atlas,
            hc_atlas = suit.rank_map[rank.key] and suit.hc_atlas or rank.hc_atlas,
        }
    else
        old_inject(suit, rank)
    end
end

hit_minor_arcana_suits = {
    hit_pentacles = true,
    hit_cups = true,
    hit_swords = true,
    hit_wands = true,
}

function full_reset_cards_debuff()
    for i = 1, #G.playing_cards do
        G.playing_cards[i]:set_debuff()
    end
    for i = 1, #G.enemy_deck.cards do
        G.enemy_deck.cards[i]:set_debuff()
    end
    for i = 1, #G.play.cards do
        G.play.cards[i]:set_debuff()
    end
    for i = 1, #G.enemy_discard.cards do
        G.enemy_discard.cards[i]:set_debuff()
    end
end

function hit_minor_arcana_use(card)
    local name = card.config.card.name
    local prev_state = G.STATE
    G.TAROT_INTERRUPT = G.STATE
    G.STATE = (G.STATE == G.STATES.TAROT_PACK and G.STATES.TAROT_PACK) or
    (G.STATE == G.STATES.PLANET_PACK and G.STATES.PLANET_PACK) or
    (G.STATE == G.STATES.SPECTRAL_PACK and G.STATES.SPECTRAL_PACK) or
    (G.STATE == G.STATES.STANDARD_PACK and G.STATES.STANDARD_PACK) or
    (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and G.STATES.SMODS_BOOSTER_OPENED) or
    (G.STATE == G.STATES.BUFFOON_PACK and G.STATES.BUFFOON_PACK) or
    G.STATES.PLAY_TAROT
    G.CONTROLLER.locks.use = true
    if card.children.use_button then card.children.use_button:remove(); card.children.use_button = nil end
    if card.children.sell_button then card.children.sell_button:remove(); card.children.sell_button = nil end
    if card.children.price then card.children.price:remove(); card.children.price = nil end
    if card.area then card.area:remove_from_highlighted(card) end
    if name == "Ace of hit_pentacles" then
        G.E_MANAGER:add_event(Event({trigger = 'after',
        func = function()
            create_playing_card({front = G.P_CARDS['D_A'], center = G.P_CENTERS['c_base']}, G.hand, nil, nil, {G.C.SECONDARY_SET.Tarot})
            draw_card(card.area, G.discard, 100/5, 'down', nil, card)
            return true
        end}))
    elseif name == "Ace of hit_cups" then
        card.area:remove_card(card)
        G.deck:emplace(card)
        local index = -1
        local pool = {}
        for i = 1, #G.deck.cards do
            if G.deck.cards[i] == card then
                index = i
            end
            table.insert(pool, G.deck.cards[i])
        end
        pseudoshuffle(pool, pseudoseed('cups'))
        if index ~= -1 then
            table.remove(G.deck.cards, index)
            table.insert(G.deck.cards, card)
        end
        local rand_index = 1 + math.floor(#G.deck.cards * pseudorandom('shuffle_index'))
        if rand_index == #G.deck.cards + 1 then
            rand_index = #G.deck.cards
        end
        local rand_suit = 'Hearts'
        for i=1,#pool do
            for i2, j2 in pairs(SMODS.Suits) do
                if pool[i]:is_suit(j2.key) then
                    rand_suit = j2.key
                    break
                end
            end
        end
        local j = #G.deck.cards + 1
        local i = 1
        while i < j do
            if G.deck.cards[i]:is_suit(rand_suit) then
                local card_ = G.deck.cards[i]
                table.remove(G.deck.cards, i)
                table.insert(G.deck.cards, card_)
                j = j - 1
            else
                i = i + 1
            end
        end
        G.deck:set_ranks()
    elseif name == "Ace of hit_swords" then
        G.E_MANAGER:add_event(Event({trigger = 'after',
        func = function()
            for i = 1, 4 do
                local suits = {'H', 'S', 'D', 'C'}
                local suit = pseudorandom_element(suits, pseudoseed('swords'))
                local card_ = create_playing_card({front = G.P_CARDS[suit..'_hit_Z'], center = G.P_CENTERS['m_hit_blackjack']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
                card_.ability.fleeting = true
                shuffle_card_in_deck(card_)
            end
            draw_card(card.area, G.discard, 100/5, 'down', nil, card)
            return true
        end}))
    elseif name == "Ace of hit_wands" then
        G.GAME.double_mult = true
        G.GAME.forced_stand = true
        G.FUNCS.hit()
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,
        func = function()
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,
            func = function()
                G.TAROT_INTERRUPT=nil
                G.CONTROLLER.locks.use = false
                if area and area.cards[1] then 
                    G.E_MANAGER:add_event(Event({func = function()
                        G.E_MANAGER:add_event(Event({func = function()
                            G.CONTROLLER.interrupt.focus = nil
                            G.CONTROLLER:recall_cardarea_focus(area)
                            return true 
                        end }))
                        return true 
                    end }))
                end
                return true
            end}))
            return true
            end
        }))
        return
    elseif name == "2 of hit_pentacles" then
        G.E_MANAGER:add_event(Event({trigger = 'after',
        func = function()
            local card_ = create_playing_card({front = G.P_CARDS['D_A'], center = G.P_CENTERS['c_base']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
            card_.ability.fleeting = true
            shuffle_card_in_deck(card_)
            card_ = create_playing_card({front = G.P_CARDS['D_2'], center = G.P_CENTERS['c_base']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
            card_.ability.fleeting = true
            shuffle_card_in_deck(card_)
            draw_card(card.area, G.discard, 100/5, 'down', nil, card)
            return true
        end}))
    elseif name == "2 of hit_cups" then
        local card_ = nil
        for i = #G.deck.cards, 1, -1 do
            if G.deck.cards[i].config.card and ((G.deck.cards[i].config.card.name == "Queen of Hearts") or (G.deck.cards[i].config.card.name == "King of Hearts")) then
                card_ = G.deck.cards[i]
                break
            end
        end
        if card_ ~= nil then
            draw_card(G.deck, G.hand, 100/5, 'down', nil, card_)
        end
    elseif name == "2 of hit_swords" then
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1, 2 do
                    local suits = {'H', 'S', 'D', 'C'}
                    local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
                    local rank = pseudorandom_element(ranks, pseudoseed('untarot'))
                    local suit = pseudorandom_element(suits, pseudoseed('untarot'))
                    local card_ = create_playing_card({front = G.P_CARDS[suit..'_'..rank], center = G.P_CENTERS['m_stone']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
                    card_.ability.fleeting = true
                    card_:set_edition({foil = true})
                    shuffle_card_in_deck(card_)
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({trigger = 'immediate',
            func = function()
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                G.TAROT_INTERRUPT = nil
                G.CONTROLLER.locks.use = false
                if area and area.cards[1] then 
                    G.E_MANAGER:add_event(Event({func = function()
                        G.E_MANAGER:add_event(Event({func = function()
                            G.CONTROLLER.interrupt.focus = nil
                            G.CONTROLLER:recall_cardarea_focus(area)
                            return true 
                        end }))
                        return true 
                    end }))
                end
                draw_card(card.area, G.discard, 100/5, 'down', nil, card)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                play_area_status_text("Push")
                G.GAME.hit_limit = 2
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        for i = #G.hand.cards, 1, -1 do
                            if (G.hand.cards[i].ability.name ~= 'Garnet Card') or G.hand.cards[i].debuff then
                                draw_card(G.hand, G.discard, i*100/5, 'up', nil, G.hand.cards[i])
                            end
                        end
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                G.STATE_COMPLETE = false
                                return true
                            end
                        }))
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                G.GAME.stood = nil
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return true
            end
        }))
        return
    elseif name == "2 of hit_wands" then
        G.E_MANAGER:add_event(Event({trigger = 'after',
        func = function()
            for i = 1, 2 do
                if G.deck.cards[#G.deck.cards + 1 - i] then
                    local rank = G.deck.cards[#G.deck.cards + 1 - i].config.card.value
                    local suit = G.deck.cards[#G.deck.cards + 1 - i].config.card.suit
                    local message = localize(rank, 'ranks') .. " of " .. localize(suit, 'suits_plural')
                    card_eval_status_text(card, 'jokers', nil, nil, nil, {message = message, colour = G.C.SO_2[suit]})
                    delay(0.5)
                end
            end
            draw_card(card.area, G.discard, 100/5, 'down', nil, card)
            return true
        end}))
    elseif name == "3 of hit_pentacles" then
        local hand_data = get_card_total(G.hand.cards)
        local rank_nominal = hand_data.bust_limit - hand_data.total
        local rank = nil
        for i, j in pairs(SMODS.Ranks) do
            if ((j.nominal == rank_nominal) or ((j.key == 'Ace') and (rank_nominal == 1))) and not j.face then
                rank = j
                break
            end
        end
        if rank ~= nil then
            G.E_MANAGER:add_event(Event({trigger = 'after',
                func = function()
                    local suits = {'H', 'S', 'D', 'C'}
                    local suit = pseudorandom_element(suits, pseudoseed('pentacles'))
                    local card_ = create_playing_card({front = G.P_CARDS[suit .. '_' .. rank.card_key], center = G.P_CENTERS['c_base']}, G.hand, nil, nil, {G.C.SECONDARY_SET.Tarot})
                    card_.ability.fleeting = true
                    draw_card(card.area, G.discard, 100/5, 'down', nil, card)
                    return true
                end
            }))
        else
            card_eval_status_text(card, 'jokers', nil, nil, nil, {message = localize('k_nope_ex'), colour = G.C.SECONDARY_SET.Tarot})
        end
    elseif name == "3 of hit_cups" then
        G.E_MANAGER:add_event(Event({
            func = function()
                local pool = {}
                for i = 1, #G.hand.cards do
                    table.insert(pool, G.hand.cards[i])
                end
                pseudoshuffle(pool, pseudoseed('cups'))
                local rand_suit = pseudorandom_element(SMODS.Suits, pseudoseed('cups'))
                for i = 1, 3 do
                    local rank = SMODS.Ranks[pool[i].base.value].card_key
                    pool[i]:set_base(G.P_CARDS[rand_suit.card_key..'_'..rank])
                    G.GAME.blind:debuff_card(pool[i])
                    pool[i]:juice_up()
                end
                return true
            end
        }))
        check_total_over_21()
        G.E_MANAGER:add_event(Event({trigger = 'immediate',
            func = function()
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                G.TAROT_INTERRUPT = nil
                G.CONTROLLER.locks.use = false
                if area and area.cards[1] then 
                    G.E_MANAGER:add_event(Event({func = function()
                        G.E_MANAGER:add_event(Event({func = function()
                            G.CONTROLLER.interrupt.focus = nil
                            G.CONTROLLER:recall_cardarea_focus(area)
                            return true 
                        end }))
                        return true 
                    end }))
                end
                return true
            end
        }))
        G.FUNCS.stand()
        return 'cancel'
    elseif name == "3 of hit_swords" then
        G.GAME.hit_3C_countdown_e = 3
        full_reset_cards_debuff()
        draw_card(card.area, G.discard, 100/5, 'down', nil, card)
    elseif name == "3 of hit_wands" then
        G.FUNCS.discard_cards_from_highlighted(nil, true)
        G.STATE = G.STATES.DRAW_TO_HAND
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
        G.GAME.hit_limit = G.GAME.hit_limit + 1
        G.GAME.forced_stand = true
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,
        func = function()
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,
            func = function()
                G.TAROT_INTERRUPT = nil
                G.CONTROLLER.locks.use = false
                if area and area.cards[1] then 
                    G.E_MANAGER:add_event(Event({func = function()
                        G.E_MANAGER:add_event(Event({func = function()
                            G.CONTROLLER.interrupt.focus = nil
                            G.CONTROLLER:recall_cardarea_focus(area)
                            return true 
                        end }))
                        return true 
                    end }))
                end
                return true
            end}))
            return true
            end
        }))
        return
    elseif name == "4 of hit_pentacles" then
        local aces = {}
        for _, j in ipairs({G.hand.cards, G.deck.cards, G.discard.cards}) do
            for i = 1, #j do
                if j[i]:get_id() == 14 then
                    table.insert(aces, j[i])
                end
            end
        end
        for i, j in ipairs(aces) do
            if j.area ~= G.deck then
                draw_card(j.area, G.deck, i*100/5, 'down', nil, j)
                shuffle_card_in_deck(j)
            end
        end
        draw_card(card.area, G.discard, 100/5, 'down', nil, card)
    elseif name == "4 of hit_cups" then
        G.GAME.suits_drawn = {}
        G.E_MANAGER:add_event(Event({
            trigger = 'ease',
            blocking = false,
            ref_table = G.GAME,
            ref_value = 'chips',
            ease_to = 0,
            delay =  0.5,
            func = (function(t) return math.floor(t) end)
        }))
    elseif name == "4 of hit_swords" then
        G.E_MANAGER:add_event(Event({trigger = 'after',
        func = function()
            for i = 1, 14 do
                local suits = {'H', 'S', 'D', 'C'}
                local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
                local rank = pseudorandom_element(ranks, pseudoseed('untarot'))
                local suit = pseudorandom_element(suits, pseudoseed('untarot'))
                local card_ = create_playing_card({front = G.P_CARDS[suit..'_'..rank], center = G.P_CENTERS['m_bonus']}, G.deck, nil, nil, {G.C.SECONDARY_SET.Tarot})
                card_.ability.fleeting = true
                shuffle_card_in_deck(card_)
            end
            draw_card(card.area, G.discard, 100/5, 'down', nil, card)
            return true
        end}))
    elseif name == "4 of hit_wands" then
        card.ability['4_W_uses'] = (card.ability['4_W_uses'] or 4) - 1
        draw_card(G.discard, G.hand, 100/5, 'down', nil, G.discard.cards[#G.discard.cards])
        if card.ability['4_W_uses'] == 0 then
            draw_card(card.area, G.discard, 100/5, 'down', nil, card)
        end
    end
    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,
        func = function()
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,
            func = function()
                G.STATE = prev_state
                G.TAROT_INTERRUPT=nil
                G.CONTROLLER.locks.use = false
                if (prev_state == G.STATES.TAROT_PACK or prev_state == G.STATES.PLANET_PACK or
                    prev_state == G.STATES.SPECTRAL_PACK or prev_state == G.STATES.STANDARD_PACK or
                    prev_state == G.STATES.SMODS_BOOSTER_OPENED or
                    prev_state == G.STATES.BUFFOON_PACK) and G.booster_pack then
                    G.CONTROLLER.interrupt.focus = true
                    G.FUNCS.end_consumeable(nil, delay_fac)
                else
                    if area and area.cards[1] then 
                        G.E_MANAGER:add_event(Event({func = function()
                            G.E_MANAGER:add_event(Event({func = function()
                                G.CONTROLLER.interrupt.focus = nil
                                G.CONTROLLER:recall_cardarea_focus(area)
                                return true 
                            end }))
                            return true 
                        end }))
                    end
                end
                return true
            end}))
            return true
        end
    }))
end

function hit_minor_arcana_can_use(card)
    local name = card.config.card.name
    if not G.GAME.facing_blind or card.debuff then
        return false
    end
    if ((G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) then  
        return false 
    end
    if (G.STATE == G.STATES.HAND_PLAYED) or (G.STATE == G.STATES.DRAW_TO_HAND) or (G.STATE == G.STATES.PLAY_TAROT) then
        return false
    end
    if name == "Ace of hit_pentacles" then
        if G.hand and (#G.hand.cards >= 1) then
            return true
        end
    elseif name == "Ace of hit_cups" then
        return true
    elseif name == "Ace of hit_swords" then
        return true
    elseif name == "Ace of hit_wands" then
        if not (G.GAME.stood or G.GAME.hit_busted or (#G.deck.cards == 0)) then
            return true
        end
    elseif name == "2 of hit_pentacles" then
        if G.deck then
            return true
        end
    elseif name == "2 of hit_cups" then
        local card_ = nil
        for i = #G.deck.cards, 1, -1 do
            if G.deck.cards[i].config.card and ((G.deck.cards[i].config.card.name == "Queen of Hearts") or (G.deck.cards[i].config.card.name == "King of Hearts")) then
                card_ = G.deck.cards[i]
                break
            end
        end
        if card_ ~= nil then
            return true
        end
    elseif name == "2 of hit_swords" then
        return true
    elseif name == "2 of hit_wands" then
        if G.deck and (#G.deck.cards >= 2) then
            return true
        end
    elseif name == "3 of hit_pentacles" then
        return true
    elseif name == "3 of hit_cups" then
        if G.hand and (#G.hand.cards >= 3) then
            return true
        end
    elseif name == "3 of hit_swords" then
        return true
    elseif name == "3 of hit_wands" then
        if G.hand.highlighted and (#G.hand.highlighted == 1) and G.GAME.hit_busted then
            return true
        end
    elseif name == "4 of hit_pentacles" then
        local aces = {}
        for _, j in ipairs({G.hand.cards, G.deck.cards, G.discard.cards}) do
            for i = 1, #j do
                if j[i]:get_id() == 14 then
                    return true
                end
            end
        end
    elseif name == "4 of hit_cups" then
        return true
    elseif name == "4 of hit_swords" then
        return true
    elseif name == "4 of hit_wands" then
        return (#G.discard.cards > 0)
    end
    return false
end

function hit_minor_arcana_loc_vars(card, info_queue)
    local name = card.config.card.name
    if name == "Ace of hit_swords" then
        info_queue[#info_queue + 1] = {key = 'fleeting', set = 'Other'}
        info_queue[#info_queue + 1] = G.P_CENTERS['m_hit_blackjack']
    elseif name == "2 of hit_pentacles" then
        info_queue[#info_queue + 1] = {key = 'fleeting', set = 'Other'}
    elseif name == "2 of hit_swords" then
        info_queue[#info_queue + 1] = {key = 'fleeting', set = 'Other'}
        info_queue[#info_queue + 1] = G.P_CENTERS['e_foil']
    elseif name == "3 of hit_pentacles" then
        info_queue[#info_queue + 1] = {key = 'perfect', set = 'Other'}
    elseif name == "4 of hit_cups" then
        if not G.GAME.suits_drawn then
            return {'None'}
        end
        local count = 0
        for i, j in pairs(G.GAME.suits_drawn) do
            count = count + 1
        end
        return {count}
    elseif name == "4 of hit_swords" then
        info_queue[#info_queue + 1] = G.P_CENTERS['m_bonus']
        info_queue[#info_queue + 1] = {key = 'fleeting', set = 'Other'}
    elseif name == "4 of hit_wands" then
        local card_ = 'None'
        if G.discard.cards[1] then
            local rank = localize(G.discard.cards[#G.discard.cards].config.card.value, 'ranks')
            local suit = localize(G.discard.cards[#G.discard.cards].config.card.suit, 'suits_plural')
            card_ = rank .. ' of ' .. suit
        end
        return {4 - (card.ability['4_W_uses'] or 4), card_}
    end
    return {}
end

SMODS.Suit {
    key = 'pentacles',
    card_key = 'P',
    pos = { y = 0 },
    lc_atlas = 'minor',
    hc_atlas = 'minor',
    lc_colour = HEX('cbb137'),
    hc_colour = HEX('cbb137'),
    lc_ui_atlas = 'mini_suits',
    hc_ui_atlas = 'mini_suits',
    ui_pos = { x = 0 , y = 0 },
    in_pool = function(self, args)
        return false
    end,
    rank_map = {
        Ace = 0,
        ['2'] = 1,
        ['3'] = 2,
        ['4'] = 3,
        ['5'] = 4,
        ['6'] = 5,
        ['7'] = 6,
        ['8'] = 7,
        hit_0 = 13,
    },
    hidden = true,
}

SMODS.Suit {
    key = 'cups',
    card_key = 'CP',
    pos = { y = 1 },
    lc_atlas = 'minor',
    hc_atlas = 'minor',
    lc_colour = HEX('ffff49'),
    hc_colour = HEX('ffff49'),
    lc_ui_atlas = 'mini_suits',
    hc_ui_atlas = 'mini_suits',
    ui_pos = { x = 1 , y = 0 },
    in_pool = function(self, args)
        return false
    end,
    rank_map = {
        Ace = 0,
        ['2'] = 1,
        ['3'] = 2,
        ['4'] = 3,
        ['5'] = 4,
        ['6'] = 5,
        ['7'] = 6,
        ['8'] = 7,
        hit_0 = 13,
    },
    hidden = true,
}

SMODS.Suit {
    key = 'swords',
    card_key = 'SW',
    pos = { y = 2 },
    lc_atlas = 'minor',
    hc_atlas = 'minor',
    lc_colour = HEX('51949d'),
    hc_colour = HEX('51949d'),
    lc_ui_atlas = 'mini_suits',
    hc_ui_atlas = 'mini_suits',
    ui_pos = { x = 0 , y = 1 },
    in_pool = function(self, args)
        return false
    end,
    rank_map = {
        Ace = 0,
        ['2'] = 1,
        ['3'] = 2,
        ['4'] = 3,
        ['5'] = 4,
        ['6'] = 5,
        ['7'] = 6,
        ['8'] = 7,
        hit_0 = 13,
    },
    hidden = true,
}

SMODS.Suit {
    key = 'wands',
    card_key = 'W',
    pos = { y = 3 },
    lc_atlas = 'minor',
    hc_atlas = 'minor',
    lc_colour = HEX('93713e'),
    hc_colour = HEX('93713e'),
    lc_ui_atlas = 'mini_suits',
    hc_ui_atlas = 'mini_suits',
    ui_pos = { x = 1 , y = 1 },
    in_pool = function(self, args)
        return false
    end,
    rank_map = {
        Ace = 0,
        ['2'] = 1,
        ['3'] = 2,
        ['4'] = 3,
        ['5'] = 4,
        ['6'] = 5,
        ['7'] = 6,
        ['8'] = 7,
        hit_0 = 13,
    },
    hidden = true,
}

G.FUNCS.hit_can_use_minor_arcana = function(e)
    if not hit_minor_arcana_can_use(e.config.ref_table) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = 'hit_use_minor_arcana'
    end
end

G.FUNCS.hit_use_minor_arcana = function(e)
    local result = hit_minor_arcana_use(e.config.ref_table)
    if result ~= 'cancel' then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                check_total_over_21()
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        check_total_over_21()
                        return true
                    end
                }))
                return true
            end
        }))
    end
end

G.FUNCS.hit_can_discard_minor_arcana = function(e)
    if ((G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) or (G.STATE == G.STATES.HAND_PLAYED) or (G.STATE == G.STATES.DRAW_TO_HAND) or (G.STATE == G.STATES.PLAY_TAROT) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.FILTER
        e.config.button = 'hit_discard_minor_arcana'
    end
end

G.FUNCS.hit_discard_minor_arcana = function(e)
    draw_card(e.config.ref_table.area, G.discard, 100/5, 'down', nil, e.config.ref_table)
end

if CardSleeves and CardSleeves.Sleeve then
    CardSleeves.Sleeve {
		key = "aced_sl",
		name = "Aced Sleeve",
		atlas = "sleeves",
		pos = { x = 0, y = 0 },

		loc_vars = function(self)
			local key
			if self.get_current_deck_key() ~= "b_hit_aced" and self.get_current_deck_key() ~= "b_hit_overload" then
				key = self.key
			else
				key = self.key .. "_alt"
			end
			return {key = key}
		end,
		apply = function(self)
			if self.get_current_deck_key() ~= "b_hit_aced" and self.get_current_deck_key() ~= "b_hit_overload" then
                set_blackjack_mode()
			end
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i, j in ipairs({'H', 'S', 'D', 'C'}) do
                        local _card = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, G.P_CARDS[j .. '_A'], G.P_CENTERS['c_base'], {playing_card = G.playing_card})
                        G.deck:emplace(_card)
                        table.insert(G.playing_cards, _card)
                    end
                return true
                end
            }))
		end
	}
end

-----------Memory Game----------

G.FUNCS.can_play_memory = function(e)
    if (G.GAME.currently_choosing ~= nil) or (G.GAME.hit_tries_left <= 0) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.BLUE
        e.config.button = 'play_memory'
    end
end

G.FUNCS.play_memory = function(e)
    G.GAME.currently_choosing = true
    G.GAME.memory_cards = {}
    G.memory_row_1.highlighted = {}
    G.memory_row_2.highlighted = {}
    G.GAME.hit_tries_left = G.GAME.hit_tries_left - 1
end

SMODS.Tag {
    key = 'memory',
    atlas = 'tags',
    loc_txt = {
        name = "Memory Tag",
        text = {
            "Play a",
            "Memory Game"
        }
    },
    discovered = true,
    in_pool = function(self)
        return G.GAME.modifiers.dungeon
    end,
    pos = {x = 1, y = 0},
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            tag:yep('+', G.C.GREEN,function()
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    config = {type = 'immediate', minigame = true}
}

function G.UIDEF.memory()
    local rows = {}
    G.GAME.currently_choosing = nil
    G.GAME.memory_cards = nil
    for i = 1, 2 do
        G["memory_row_" .. tostring(i)] = CardArea(
        G.hand.T.x+0,
        G.hand.T.y+G.ROOM.T.y + 9,
        5*1.02*G.CARD_W,
        1.05*G.CARD_H, 
        {card_limit = 5, type = 'shop', highlight_limit = 5})
        table.insert(rows, {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
                {n=G.UIT.O, config={object = G["memory_row_" .. tostring(i)]}},
            }},
        }})
    end
    if not G.load_memory_row_1 then
        G.GAME.hit_tries_left = nil
        local pools = {G.P_JOKER_RARITY_POOLS[2], G.P_JOKER_RARITY_POOLS[3], G.P_CENTER_POOLS["Spectral"], G.P_CENTER_POOLS["Spectral"], G.P_CENTER_POOLS["Voucher"]}
        local keys = {}
        for i, j in ipairs(pools) do
            local pool = {}
            for k, v in ipairs(j) do
                local valid = true
                local in_pool, pool_opts
                if v.in_pool and type(v.in_pool) == 'function' then
                    in_pool, pool_opts = v:in_pool({})
                end
                if (G.GAME.used_jokers[v.key] and (not pool_opts or not pool_opts.allow_duplicates) and not next(find_joker("Showman"))) then
                    valid = false
                end
                if not v.unlocked then
                    valid = false
                end
                if (i == 4) and (keys[3] == v.key) then
                    valid = false
                end
                if G.GAME.banned_keys[v.key] then
                    valid = false
                end
                if G.GAME.used_vouchers[v.key] then
                    valid = false
                end
                if v.requires then 
                    for i2, j2 in pairs(v.requires) do
                        if not G.GAME.used_vouchers[j2] then 
                            valid = false
                        end
                    end
                end
                for i2, j2 in ipairs(SMODS.Consumable.legendaries) do
                    if v.key == j2.key then
                        valid = false
                        break
                    end
                end
                if (v.key == 'c_black_hole') or (v.key == 'c_soul') then
                    valid = false
                end
                if valid then
                    table.insert(pool, v.key)
                end
            end
            if #pool == 0 then
                keys[#keys + 1] = 'c_pluto'
            else
                keys[#keys + 1] = pseudorandom_element(pool, pseudoseed('remember'))
            end
        end
        local row_1 = {}
        local row_2 = {}
        local pool = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
        for _, j in pairs(keys) do
            for k = 1, 2 do
                local slot, index = pseudorandom_element(pool, pseudoseed('remember2'))
                table.remove(pool, index)
                if slot > 5 then
                    row_2[slot - 5] = j
                else
                    row_1[slot] = j
                end
            end
        end
        for i, j in ipairs(row_1) do
            local card = SMODS.create_card {key = j, no_edition = true}
            G.memory_row_1:emplace(card)
            card:flip()
        end
        for i, j in ipairs(row_2) do
            local card = SMODS.create_card {key = j, no_edition = true}
            G.memory_row_2:emplace(card)
            card:flip()
        end
    else
        G.memory_row_1:load(G.load_memory_row_1)
        G.memory_row_2:load(G.load_memory_row_2)
        G.load_memory_row_1 = nil
        G.load_memory_row_2 = nil
    end
    G.GAME.hit_tries_left = G.GAME.hit_tries_left or 6


    local shop_sign = AnimatedSprite(0,0, 4.4, 2.2, G.ANIMATION_ATLAS['shop_sign'])
    shop_sign:define_draw_steps({
      {shader = 'dissolve', shadow_height = 0.05},
      {shader = 'dissolve'}
    })
    G.SHOP_SIGN = UIBox{
      definition = 
        {n=G.UIT.ROOT, config = {colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = shop_sign}}
            }},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('ph_test_memory')}, colours = {lighten(G.C.GOLD, 0.3)},shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, pop_in = 1.5, maxw = 4.3})}}
            }},
          }},
        }},
      config = {
        align="cm",
        offset = {x=0,y=-15},
        major = G.HUD:get_UIE_by_ID('row_blind'),
        bond = 'Weak'
      }
    }
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = (function()
          G.SHOP_SIGN.alignment.offset.y = 0
          return true
      end)
    }))


    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
            UIBox_dyn_container({
                {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                rows[1], rows[2],
                {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.C, config={align = "cm", minw = 2.8, minh = 0.7, r=0.04,colour = G.C.BLUE, button = 'play_memory', func = 'can_play_memory', hover = true,shadow = true}, nodes = {
                        {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = localize('b_choose_cards'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                              {n=G.UIT.T, config={text = " (", scale = 0.4, colour = G.C.WHITE, shadow = true}},
                              {n=G.UIT.T, config={ref_table = G.GAME, ref_value = 'hit_tries_left', scale = 0.4, colour = G.C.WHITE, shadow = true}},
                              {n=G.UIT.T, config={text = ")", scale = 0.4, colour = G.C.WHITE, shadow = true}},
                            }}
                        }}
                    }},
                    {n=G.UIT.C, config={id = 'next_round_button', align = "cm", minw = 2.8, minh = 0.7, r=0.04,colour = G.C.RED, one_press = true, button = 'toggle_shop', hover = true,shadow = true}, nodes = {
                        {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                                {n=G.UIT.T, config={text = localize('b_exit'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                            }},
                        }}
                    }},
                }}}
            },
              }, false)
        }}
    return t
end

-----------Cross Mod Stuff----

if pc_add_cross_mod_card then
    pc_add_cross_mod_card {
        key = 'mega_ace',
        card = {
            key = 'mega_ace', 
            unlocked = true, 
            discovered = true, 
            atlas = 'hit_pc_cards', 
            cost = 1, 
            name = "Mega Ace", 
            pos = {x=0,y=0},
            config = {chips = 11, hit_hand_value = 11, hit_hand_aces = 1}, 
            base = "H_A"
        },
        calculate = function(card, effects, context, reps)
            local config_thing = card.ability.trading.config 
            if context.playing_card_main then
                table.insert(effects, {
                    chips = config_thing.chips,
                    card = card
                })
            elseif context.get_id then
                return 14
            end
        end,
        loc_vars = function(specific_vars, info_queue, card)
            local config_thing = specific_vars.collect.config
            return {config_thing.chips}
        end,
        in_pool = function()
            return G.GAME.modifiers.dungeon
        end
    }

    pc_add_cross_mod_card {
        key = 'sun_two',
        card = {
            key = 'sun_two', 
            unlocked = true, 
            discovered = true, 
            atlas = 'hit_pc_cards', 
            cost = 1, 
            name = "Sun Two", 
            pos = {x=1,y=0},
            config = {}, 
            base = "D_2"
        },
        calculate = function(card, effects, context, reps)
            if context.get_id then
                return 2
            elseif context.is_face then
                return true
            end
        end,
        in_pool = function()
            return G.GAME.modifiers.dungeon
        end
    }

    pc_add_cross_mod_card {
        key = 'adrenalten',
        card = {
            key = 'adrenalten', 
            unlocked = true, 
            discovered = true, 
            atlas = 'hit_pc_cards', 
            cost = 1, 
            name = "Adrenaline Ace", 
            pos = {x=2,y=0},
            config = {mult = 0, gain = 1}, 
            base = "H_T"
        },
        calculate = function(card, effects, context, reps)
            local config_thing = card.ability.trading.config 
            if context.get_id then
                return 10
            elseif context.playing_card_main then
                table.insert(effects, {
                    mult = config_thing.mult,
                    card = card
                })
            elseif context.hit then
                config_thing.mult = config_thing.mult + config_thing.gain
                card_eval_status_text(card, 'jokers', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={config_thing.gain}}, colour = G.C.RED})
            end
        end,
        loc_vars = function(specific_vars, info_queue, card)
            local config_thing = specific_vars.collect.config
            return {localize("Hearts", 'suits_plural'), config_thing.gain, config_thing.mult}
        end,
        in_pool = function()
            return G.GAME.modifiers.dungeon
        end
    }

    pc_add_cross_mod_card {
        key = 'bottomless_pit',
        card = {
            key = 'bottomless_pit', 
            unlocked = true, 
            discovered = true, 
            atlas = 'hit_pc_cards', 
            cost = 1, 
            name = "Bottomless Pit", 
            pos = {x=3,y=0},
            config = {chips = 10, hit_hand_value = 10, gain = -10}, 
            base = "S_T"
        },
        calculate = function(card, effects, context, reps)
            local config_thing = card.ability.trading.config 
            if context.playing_card_main then
                table.insert(effects, {
                    chips = config_thing.chips,
                    card = card
                })
            elseif context.get_id then
                return 10
            elseif context.stand and G.GAME.hit_busted then
                config_thing.hit_hand_value = config_thing.hit_hand_value + config_thing.gain
                card_eval_status_text(card, 'jokers', nil, nil, nil, {message = tostring(config_thing.gain), colour = G.C.RED})
            end
        end,
        loc_vars = function(specific_vars, info_queue, card)
            local config_thing = specific_vars.collect.config
            return {config_thing.chips, config_thing.gain, config_thing.hit_hand_value}
        end,
        in_pool = function()
            return G.GAME.modifiers.dungeon
        end
    }

    pc_add_cross_mod_card {
        key = 'hydra',
        card = {
            key = 'hydra', 
            unlocked = true, 
            discovered = true, 
            atlas = 'hit_pc_cards', 
            cost = 1, 
            name = "Adrenaline Ace", 
            pos = {x=0,y=1},
            config = {chips = 3}, 
            base = "D_3"
        },
        calculate = function(card, effects, context, reps)
            local config_thing = card.ability.trading.config 
            if context.get_id then
                return 3
            elseif context.playing_card_main then
                table.insert(effects, {
                    chips = config_thing.chips,
                    card = card
                })
            elseif context.hit then
                card_eval_status_text(card, 'jokers', nil, nil, nil, {message = localize('ow_ex'), colour = G.C.RED})
                G.E_MANAGER:add_event(Event({ func = function()
                    local card2 = copy_card(card, nil, nil, true)
                    card2:start_materialize()
                    G.hand:emplace(card2)
                    table.insert(G.playing_cards, card2)
                    card2.ability.fleeting = true
                    return true
                end
                }))
                return {
                    add_limit = 1
                }
            elseif context.is_face then
                return true
            end
        end,
        loc_vars = function(specific_vars, info_queue, card)
            local config_thing = specific_vars.collect.config
            info_queue[#info_queue+1] = {key = 'fleeting', set = 'Other'}
            return {config_thing.chips}
        end,
        in_pool = function()
            return G.GAME.modifiers.dungeon
        end
    }
end

------------------------------

bj_ban_list = {
    banned_cards = {
        -- effective useless
        {id = 'j_jolly'},
        {id = 'j_zany'},
        {id = 'j_mad'},
        {id = 'j_sly'},
        {id = 'j_wily'},
        {id = 'j_clever'},
        {id = 'j_crazy'},
        {id = 'j_droll'},
        {id = 'j_devious'},
        {id = 'j_crafty'},
        {id = 'j_four_fingers'},
        {id = 'j_runner'},
        {id = 'j_superposition'},
        {id = 'j_seance'},
        {id = 'j_shortcut'},
        {id = 'j_obelisk'},
        {id = 'j_duo'},
        {id = 'j_trio'},
        {id = 'j_family'},
        {id = 'j_order'},
        {id = 'j_tribe'},
        {id = 'j_trousers'},
        -- really useless
        {id = 'j_mime'},
        {id = 'j_raised_fist'},
        {id = 'j_blackboard'},
        {id = 'j_baron'},
        {id = 'j_reserved_parking'},
        {id = 'j_juggler'},
        {id = 'j_troubadour'},
        {id = 'j_turtle_bean'},
        {id = 'j_shoot_the_moon'},
        {id = 'j_dusk'},
        {id = 'j_acrobat'},
        {id = 'j_steel_joker'},
        {id = 'j_ticket'},
        {id = 'j_midas_mask'},
        -- discard based
        {id = 'j_merry_andy'},
        -- stuntman
        {id = 'j_stuntman'},
        -- non jokers
        {id = 'v_paint_brush'},
        {id = 'v_palette'},
        {id = 'c_earth'},
        {id = 'c_mars'},
        {id = 'c_jupiter'},
        {id = 'c_neptune'},
        {id = 'c_saturn'},
        {id = 'c_pluto'},
        {id = 'c_mercury'},
        {id = 'c_venus'},
        {id = 'c_uranus'},
        {id = 'c_planet_x'},
        {id = 'c_ceres'},
        {id = 'c_eris'},
        {id = 'c_devil'},
        {id = 'c_chariot'},
        {id = 'm_gold'},
        {id = 'm_steel'},
        {id = 'Blue'},
        --- replaced cards
        {id = 'c_trance'},
        {id = 'sk_grm_cl_hoarder'},
    },
    banned_tags = {
        {id = 'tag_juggle'},
    },
    banned_other = {
        {id = 'bl_hook', type = 'blind'},
        {id = 'bl_psychic', type = 'blind'},
        {id = 'bl_manacle', type = 'blind'},
        {id = 'bl_eye', type = 'blind'},
        {id = 'bl_serpent', type = 'blind'},
        {id = 'bl_final_bell', type = 'blind'},
        {id = 'bl_mouth', type = 'blind'},
        {id = 'bl_fish', type = 'blind'},
        {id = 'bl_house', type = 'blind'},
        {id = 'bl_needle', type = 'blind'},
    }
}

function G.UIDEF.view_enemy_deck(unplayed_only)
	local deck_tables = {}
    local all_cards = {}
    if G.enemy_deck and G.enemy_deck.cards then
        for i = 1, #G.enemy_deck.cards do
            table.insert(all_cards, G.enemy_deck.cards[i])
        end
    end
    if G.enemy_discard and G.enemy_discard.cards then
        for i = 1, #G.enemy_discard.cards do
            table.insert(all_cards, G.enemy_discard.cards[i])
        end
    end
    if G.play and G.play.cards then
        for i = 1, #G.play.cards do
            if G.play.cards[i].ability.enemy then
                table.insert(all_cards, G.play.cards[i])
            end
        end
    end
	G.VIEWING_DECK = true
	table.sort(all_cards, function(a, b) return a:get_nominal('suit') > b:get_nominal('suit') end)
	local SUITS = {}
	local suit_map = {}
	for i = #SMODS.Suit.obj_buffer, 1, -1 do
		SUITS[SMODS.Suit.obj_buffer[i]] = {}
		suit_map[#suit_map + 1] = SMODS.Suit.obj_buffer[i]
	end
	for k, v in ipairs(all_cards) do
		if v.base.suit then table.insert(SUITS[v.base.suit], v) end
	end
	local num_suits = 0
	for j = 1, #suit_map do
		if SUITS[suit_map[j]][1] then num_suits = num_suits + 1 end
	end
	for j = 1, #suit_map do
		if SUITS[suit_map[j]][1] then
			local view_deck = CardArea(
				G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
				6.5 * G.CARD_W,
				((num_suits > 8) and 0.2 or (num_suits > 4) and (1 - 0.1 * num_suits) or 0.6) * G.CARD_H,
				{
					card_limit = #SUITS[suit_map[j]],
					type = 'title',
					view_deck = true,
					highlight_limit = 0,
					card_w = G
						.CARD_W * 0.7,
					draw_layers = { 'card' }
				})
			table.insert(deck_tables,
				{n = G.UIT.R, config = {align = "cm", padding = 0}, nodes = {
					{n = G.UIT.O, config = {object = view_deck}}}}
			)

			for i = 1, #SUITS[suit_map[j]] do
				if SUITS[suit_map[j]][i] then
					local greyed, _scale = nil, 0.7
					local copy = copy_card(SUITS[suit_map[j]][i], nil, _scale)
                    if not ((SUITS[suit_map[j]][i].area and SUITS[suit_map[j]][i].area == G.enemy_deck)) then
                        greyed = true
                    end
					copy.greyed = greyed
					copy.T.x = view_deck.T.x + view_deck.T.w / 2
					copy.T.y = view_deck.T.y

					copy:hard_set_T()
					view_deck:emplace(copy)
				end
			end
		end
	end

	local flip_col = G.C.WHITE

	local suit_tallies = {}
	local mod_suit_tallies = {}
	for _, v in ipairs(suit_map) do
		suit_tallies[v] = 0
		mod_suit_tallies[v] = 0
	end
	local rank_tallies = {}
	local mod_rank_tallies = {}
	local rank_name_mapping = SMODS.Rank.obj_buffer
	for _, v in ipairs(rank_name_mapping) do
		rank_tallies[v] = 0
		mod_rank_tallies[v] = 0
	end
	local face_tally = 0
	local mod_face_tally = 0
	local num_tally = 0
	local mod_num_tally = 0
	local ace_tally = 0
	local mod_ace_tally = 0
	local wheel_flipped = 0

	for k, v in ipairs(all_cards) do
		if (v.ability.name ~= 'Stone Card') and (v.area and v.area == G.enemy_deck) then
			--For the suits
			if v.base.suit then suit_tallies[v.base.suit] = (suit_tallies[v.base.suit] or 0) + 1 end
			for kk, vv in pairs(mod_suit_tallies) do
				mod_suit_tallies[kk] = (vv or 0) + (v:is_suit(kk) and 1 or 0)
			end

			--for face cards/numbered cards/aces
			local card_id = v:get_id()
			if v.base.value then face_tally = face_tally + ((SMODS.Ranks[v.base.value].face) and 1 or 0) end
			mod_face_tally = mod_face_tally + (v:is_face() and 1 or 0)
			if v.base.value and not SMODS.Ranks[v.base.value].face and card_id ~= 14 then
				num_tally = num_tally + 1
				if not v.debuff then mod_num_tally = mod_num_tally + 1 end
			end
			if card_id == 14 then
				ace_tally = ace_tally + 1
				if not v.debuff then mod_ace_tally = mod_ace_tally + 1 end
			end

			--ranks
			if v.base.value then rank_tallies[v.base.value] = rank_tallies[v.base.value] + 1 end
			if v.base.value and not v.debuff then mod_rank_tallies[v.base.value] = mod_rank_tallies[v.base.value] + 1 end
		end
	end
	local modded = face_tally ~= mod_face_tally
	for kk, vv in pairs(mod_suit_tallies) do
		modded = modded or (vv ~= suit_tallies[kk])
		if modded then break end
	end

	if wheel_flipped > 0 then flip_col = mix_colours(G.C.FILTER, G.C.WHITE, 0.7) end

	local rank_cols = {}
	for i = #rank_name_mapping, 1, -1 do
		if rank_tallies[rank_name_mapping[i]] ~= 0 or not SMODS.Ranks[rank_name_mapping[i]].in_pool or SMODS.Ranks[rank_name_mapping[i]]:in_pool({suit=''}) then
			local mod_delta = mod_rank_tallies[rank_name_mapping[i]] ~= rank_tallies[rank_name_mapping[i]]
			rank_cols[#rank_cols + 1] = {n = G.UIT.R, config = {align = "cm", padding = 0.07}, nodes = {
				{n = G.UIT.C, config = {align = "cm", r = 0.1, padding = 0.04, emboss = 0.04, minw = 0.5, colour = G.C.L_BLACK}, nodes = {
					{n = G.UIT.T, config = {text = SMODS.Ranks[rank_name_mapping[i]].shorthand, colour = G.C.JOKER_GREY, scale = 0.35, shadow = true}},}},
				{n = G.UIT.C, config = {align = "cr", minw = 0.4}, nodes = {
					mod_delta and {n = G.UIT.O, config = {
							object = DynaText({
								string = { { string = '' .. rank_tallies[rank_name_mapping[i]], colour = flip_col }, { string = '' .. mod_rank_tallies[rank_name_mapping[i]], colour = G.C.BLUE } },
								colours = { G.C.RED }, scale = 0.4, y_offset = -2, silent = true, shadow = true, pop_in_rate = 10, pop_delay = 4
							})}}
					or {n = G.UIT.T, config = {text = rank_tallies[rank_name_mapping[i]], colour = flip_col, scale = 0.45, shadow = true } },}}}}
		end
	end

	local tally_ui = {
		-- base cards
		{n = G.UIT.R, config = {align = "cm", minh = 0.05, padding = 0.07}, nodes = {
			{n = G.UIT.O, config = {
					object = DynaText({ 
						string = { 
							{ string = localize('k_base_cards'), colour = G.C.RED }, 
							modded and { string = localize('k_effective'), colour = G.C.BLUE } or nil
						},
						colours = { G.C.RED }, silent = true, scale = 0.4, pop_in_rate = 10, pop_delay = 4
					})
				}}}},
		-- aces, faces and numbered cards
		{n = G.UIT.R, config = {align = "cm", minh = 0.05, padding = 0.1}, nodes = {
			tally_sprite(
				{ x = 1, y = 0 },
				{ { string = '' .. ace_tally, colour = flip_col }, { string = '' .. mod_ace_tally, colour = G.C.BLUE } },
				{ localize('k_aces') }
			), --Aces
			tally_sprite(
				{ x = 2, y = 0 },
				{ { string = '' .. face_tally, colour = flip_col }, { string = '' .. mod_face_tally, colour = G.C.BLUE } },
				{ localize('k_face_cards') }
			), --Face
			tally_sprite(
				{ x = 3, y = 0 },
				{ { string = '' .. num_tally, colour = flip_col }, { string = '' .. mod_num_tally, colour = G.C.BLUE } },
				{ localize('k_numbered_cards') }
			), --Numbers
		}},
	}
	-- add suit tallies
	local hidden_suits = {}
	for _, suit in ipairs(suit_map) do
		if suit_tallies[suit] == 0 and SMODS.Suits[suit].in_pool and not SMODS.Suits[suit]:in_pool({rank=''}) then
			hidden_suits[suit] = true
		end
	end
	local i = 1
	local num_suits_shown = 0
	for i = 1, #suit_map do
		if not hidden_suits[suit_map[i]] then
			num_suits_shown = num_suits_shown+1
		end
	end
	local suits_per_row = num_suits_shown > 6 and 4 or num_suits_shown > 4 and 3 or 2
	local n_nodes = {}
	while i <= #suit_map do
		while #n_nodes < suits_per_row and i <= #suit_map do
			if not hidden_suits[suit_map[i]] then
				table.insert(n_nodes, tally_sprite(
					SMODS.Suits[suit_map[i]].ui_pos,
					{
						{ string = '' .. suit_tallies[suit_map[i]], colour = flip_col },
						{ string = '' .. mod_suit_tallies[suit_map[i]], colour = G.C.BLUE }
					},
					{ localize(suit_map[i], 'suits_plural') },
					suit_map[i]
				))
			end
			i = i + 1
		end
		if #n_nodes > 0 then
			local n = {n = G.UIT.R, config = {align = "cm", minh = 0.05, padding = 0.1}, nodes = n_nodes}
			table.insert(tally_ui, n)
			n_nodes = {}
		end
	end
	local t = {n = G.UIT.ROOT, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
		{n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}},
		{n = G.UIT.R, config = {align = "cm"}, nodes = {
			{n = G.UIT.C, config = {align = "cm", minw = 1.5, minh = 2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = {
				{n = G.UIT.C, config = {align = "cm", padding = 0.1}, nodes = {
					{n = G.UIT.R, config = {align = "cm", r = 0.1, colour = G.C.L_BLACK, emboss = 0.05, padding = 0.15}, nodes = {
						{n = G.UIT.R, config = {align = "cm"}, nodes = {
							{n = G.UIT.O, config = {
									object = DynaText({ string = G.GAME.selected_back.loc_name, colours = {G.C.WHITE}, bump = true, rotate = true, shadow = true, scale = 0.6 - string.len(G.GAME.selected_back.loc_name) * 0.01 })
								}},}},
						{n = G.UIT.R, config = {align = "cm", r = 0.1, padding = 0.1, minw = 2.5, minh = 1.3, colour = G.C.WHITE, emboss = 0.05}, nodes = {
							{n = G.UIT.O, config = {
									object = UIBox {
										definition = G.GAME.selected_back:generate_UI(nil, 0.7, 0.5, G.GAME.challenge), config = {offset = { x = 0, y = 0 } }
									}
								}}}}}},
					{n = G.UIT.R, config = {align = "cm", r = 0.1, outline_colour = G.C.L_BLACK, line_emboss = 0.05, outline = 1.5}, nodes = 
						tally_ui}}},
				{n = G.UIT.C, config = {align = "cm"}, nodes = rank_cols},
				{n = G.UIT.B, config = {w = 0.1, h = 0.1}},}},
			{n = G.UIT.B, config = {w = 0.2, h = 0.1}},
			{n = G.UIT.C, config = {align = "cm", padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes =
				deck_tables}}},
		{n = G.UIT.R, config = {align = "cm", minh = 0.8, padding = 0.05}, nodes = {
			modded and {n = G.UIT.R, config = {align = "cm"}, nodes = {
				{n = G.UIT.C, config = {padding = 0.3, r = 0.1, colour = mix_colours(G.C.BLUE, G.C.WHITE, 0.7)}, nodes = {}},
				{n = G.UIT.T, config = {text = ' ' .. localize('ph_deck_preview_effective'), colour = G.C.WHITE, scale = 0.3}},}}
			or nil,
			wheel_flipped > 0 and {n = G.UIT.R, config = {align = "cm"}, nodes = {
				{n = G.UIT.C, config = {padding = 0.3, r = 0.1, colour = flip_col}, nodes = {}},
				{n = G.UIT.T, config = {
						text = ' ' .. (wheel_flipped > 1 and
							localize { type = 'variable', key = 'deck_preview_wheel_plural', vars = { wheel_flipped } } or
							localize { type = 'variable', key = 'deck_preview_wheel_singular', vars = { wheel_flipped } }),
						colour = G.C.WHITE, scale = 0.3
					}},}}
			or nil,}}}}
	return t
end

local old_set_sprites = Card.set_sprites
function Card:set_sprites(_center, _front)
    if self.children.center and _front and (self.children.center.sprite_pos.x == 999) then
        self.children.center:set_sprite_pos({x = 1, y = 0})
    end
    old_set_sprites(self, _center, _front)
    if _front and hit_minor_arcana_suits[_front.suit] then 
        self.children.center:set_sprite_pos({x = 999, y = 999})
    end
end

----------------------------------------------
------------MOD CODE END----------------------
