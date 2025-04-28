return {
    descriptions = {
        Back = {
            b_hit_aced = {
                name = "Aced Deck",
                text = {
                    "{C:attention}Blackjack Mode{}",
                    "Start with {C:attention}4{} extra",
                    "{C:attention}Aces{}",
                }
            },
            b_hit_overload = {
                name = "Overload Deck",
                text = {
                    "{C:attention}Blackjack Mode{}",
                    "{C:attention}+10{} Bust Limit",
                }
            },
            b_hit_arcane = {
                name = "Arcane Deck",
                text = {
                    "{C:attention}Blackjack Mode{}",
                    "{C:attention}Untarot Cards{} show up",
                    "{C:attention}X2{} times more often",
                    "{C:red}-1{} Bust Limit",
                }
            },
            b_hit_temporary = {
                name = "[DECK] ==",
                text = {
                    "{C:attention}Blackjack Mode{}",
                    "[{C:attention}MINOR ARCANA{}] = 16"
                }
            },
            b_hit_mystic = {
                name = "Mystic Deck",
                text = {
                    "{C:attention}Blackjack Mode{}",
                    "If {C:attention}deck{} and {C:attention}hand{} are empty,",
                    "shuffle {C:attention}discard pile{} into {C:attention}deck{}",
                    "{C:red}0{} discards per round"
                }

            }
        },
        Sleeve = {
            sleeve_hit_aced_sl = {
                name = "Aced Sleeve",
                text = { 
					"{C:attention}Blackjack Mode{}",
                    "Start with {C:attention}4{} extra",
                    "{C:attention}Aces{}",
				}
            },
            sleeve_hit_aced_sl_alt = {
                name = "Aced Sleeve",
                text = { 
                    "Start with {C:attention}4{} more extra",
                    "{C:attention}Aces{}",
				}
			},		
		},
        Other = {
            undiscovered_untarot = {
                name = "Not Discovered",
                text = {
                    "Purchase or use",
                    "this card in an",
                    "unseeded run to",
                    "learn what it does"
                }
            },
            hit_hermit_indicator = {
                name = "Note",
                text = {
                    "Shuffled to bottom",
                    "of deck for {C:attention}#1#{} rounds",
                }
            },
            hit_moon_indicator = {
                name = "Note",
                text = {
                    "Shuffled to top of",
                    "deck for {C:attention}#1#{} rounds",
                }
            },
            revert_base = {
                name = "Note",
                text = {
                    "Reverts to a {C:attention}#1#{}",
                    "of {C:attention}#2#{} at",
                    "in {C:attention}#3#{} rounds"
                }
            },
            mega_ace = {
                text = {
                    "Mega Ace",
                }
            },
            sun_two = {
                text = {
                    "Sun Two",
                }
            },
            adrenalten = {
                text = {
                    "Adrenalten",
                }
            },
            bottomless_pit = {
                text = {
                   "Bottomless Pit",
                }
            },
            hydra = {
                text = {
                   "Hydra",
                }
            },
            fleeting = {
                name = "Fleeting",
                text = {
                    "{C:red}Deleted{} at end",
                    "of {C:attention}round{}",
                },
            },
            perfect = {
                name = "Perfect",
                text = {
                    "{C:attention}Hand sum{} is equal",
                    "to {C:attention}bust limit{}",
                },
            },
            hit_blue_seal = {
                name = 'Blue Seal',
                text = {
                    'On {C:attention}Push{} or {C:attention}Lose{},',
                    '{C:attention}Upgrade{} held in',
                    'hand {C:attention}poker hand{}'
                }
            }
        },
        Untarot = {
            c_hit_unfool = {
                name = "The Reversed Fool",
                text = {
                    "Add a {C:attention}#1#{}",
                    "to {C:attention}Full Deck{}"
                },
            },
            c_hit_unmagician = {
                name = "The Reversed Magician",
                text = {
                    "Converts up to {C:attention}#1#{}",
                    "selected cards to {C:attention}#2#s{}",
                    "for {C:attention}#3#{} rounds"
                }
            },
            c_hit_unhigh_priestess = {
                name = "The Reversed High Priestess",
                text = {
                    "Add {C:attention}1{} card of your most",
                    "played {C:attention}rank{} and {C:attention}1{} of your",
                    "most played {C:attention}suit{} to {C:attention}Full Deck{}",
                    "{C:inactive}({C:attention}#1#{C:inactive}, {C:attention}#2#{C:inactive}){}"
                }
            },
            c_hit_unempress = {
                name = "The Reversed Empress",
                text = {
                    "Creates up to {C:attention}#1#",
                    "random {C:attention}Untarot{} cards",
                    "{C:inactive}(Must have room)"
                }
            },
            c_hit_unemperor = {
                name = "The Reversed Emperor",
                text = {
                    "Converts up to {C:attention}#1#{}",
                    "selected cards to {C:attention}#2#s{}",
                }
            },
            c_hit_unheirophant = {
                name = "The Reversed Heirophant",
                text = {
                    "Convert all {C:attention}selected{} cards",
                    "to the most currently {C:attention}selected{}",
                    "{C:attention}suit{}"
                }
            },
            c_hit_unlovers = {
                name = "The Reversed Lovers",
                text = {
                    "Converts {C:attention}#1#{} selected",
                    "cards to {C:attention}#2#s{}",
                }
            },
            c_hit_unchariot = {
                name = "The Reversed Chariot",
                text = {
                    "Converts up to {C:attention}#1#{}",
                    "selected cards to {C:attention}random{}",
                    "{C:attention}higher ranks{}"
                }
            },
            c_hit_unjustice = {
                name = "Reversed Justice",
                text = {
                    "Lose {C:red}$#1#{}, Increases",
                    "rank of up to {C:attention}#2#{}",
                    "selected cards by {C:attention}2{}"

                }
            },
            c_hit_unhermit = {
                name = "The Reversed Hermit",
                text = {
                    "Up to {C:attention}#1#{} selected cards will",
                    "be shuffled to the {C:attention}bottom{} of the",
                    "deck at the start of the {C:attention}next{}",
                    "{C:attention}#2# rounds{}"
                }
            },
            c_hit_unwheel_of_fortune = {
                name = "The Reversed Wheel of Fortune",
                text = {
                    "Earn {C:money}$#1#{}, {C:green}#2# in #3#{}",
                    "chance to add a",
                    "{C:attention}#4#{} to {C:attention}Full Deck{}"
                }
            },
            c_hit_unstrength = {
                name = "Reversed Strength",
                text = {
                    "Enhances up to {C:attention}#1#{} selected",
                    "cards, {C:green}#2# in #3#{} chance to",
                    "{C:red}debuff{} selected cards"

                }
            },
            c_hit_unhanged_man = {
                name = "The Reversed Hanged Man",
                text = {
                    "Add {C:attention}#1#{} Enhanced",
                    "cards to {C:attention}Full Deck{}",
                }
            },
            c_hit_undeath = {
                name = "Reversed Death",
                text = {
                    "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s{}"
                }
            },
            c_hit_untemperance = {
                name = "Reversed Temperance",
                text = {
                    "Converts up to {C:attention}#1#{}",
                    "selected cards to {C:attention}#2#s{}",
                    "and {C:attention}Face Cards{}"
                }
            },
            c_hit_undevil = {
                name = "The Reversed Devil",
                text = {
                    "Converts up to {C:attention}#1#{}",
                    "selected cards to",
                    "{C:red}debuffed{} {C:attention}#2#s{}"
                }
            },
            c_hit_untower = {
                name = "The Reversed Tower",
                text = {
                    "Enhances {C:attention}#1#{} selected",
                    "card into a",
                    "{C:attention}#2#{}"
                }
            },
            c_hit_unstar = {
                name = "The Reversed Star",
                text = {
                    "Destroy {C:attention}#1#{} random",
                    "cards in hand",
                }
            },
            c_hit_unmoon = {
                name = "The Reversed Moon",
                text = {
                    "Up to {C:attention}#1#{} selected cards will",
                    "be shuffled to the {C:attention}top{} of the",
                    "deck at the start of the {C:attention}next{}",
                    "{C:attention}#2# rounds{}"
                }
            },
            c_hit_unsun = {
                name = "The Reversed Sun",
                text = {
                    "Converts up to {C:attention}#1#{}",
                    "selected cards to {C:attention}random{}",
                    "{C:attention}lower ranks{}"
                }
            },
            c_hit_unjudgement = {
                name = "Reversed Judgement",
                text = {
                    "Converts up to {C:attention}#1#{}",
                    "selected cards to the",
                    "{C:attention}rank{} of the {C:attention}leftmost{}",
                    "card in hand"
                }
            },
            c_hit_unworld = {
                name = "The Reversed World",
                text = {
                    "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s{}"
                }
            },
        },
        Enhanced = {
            m_hit_blackjack = {
                name = 'Mega Blackjack Card',
                text = {
                    "{C:attention}+1{}, {C:attention}2{}, {C:attention}3{}, or {C:attention}4{} extra",
                    "hand sum"
                }
            },
            m_hit_nope = {
                name = 'Nope Card',
                text = {
                    "{C:attention}+13{} extra hand sum",
                }
            },
            m_hit_garnet = {
                name = 'Garnet Card',
                text = {
                    "On {C:attention}Stand{}, this card",
                    "is not {C:attention}discarded{}",
                }
            },
            m_hit_crazy = {
                name = 'Crazy Card',
                text = {
                    "{C:chips}+#1#{} Chips",
                    "no rank or suit",
                    "Contributes {C:attention}-3{} or",
                    "{C:attention}7{} to hand sums",
                }
            },
            m_hit_osmium = {
                name = 'Osmium Card',
                text = {
                    "On player {C:attention}Stand{}, {C:attention}+2{}",
                    "hand sum. On enemy {C:attention}Stand{},",
                    "{C:attention}+2{} enemy hand sum"
                }
            },
        },
        CustomCard = {
            mega_ace = {
                text = {
                    "{C:attention}Ace{}, {C:blue}+#1#{} Chips",
                    "Contributes {C:attention}11{} or",
                    "{C:attention}21{} to hand sums",
                }
            },
            sun_two = {
                text = {
                    "{C:attention}2{}, {C:attention}Face Card{}",
                    "On {C:attention}Stand{}, all {C:attention}Non-Bust{} hand",
                    "sums are considered {C:attention}0{}",
                }
            },
            adrenalten = {
                text = {
                   "{C:attention}10{}, {C:hearts}#1#{}",
                    "On {C:attention}Hit{}, Gains {C:red}+1{} Mult",
                    "{C:inactive}(Currently {C:red}+#3# {C:inactive}Mult){}",
                }
            },
            bottomless_pit = {
                text = {
                   "{C:attention}10{}, {C:blue}+#1#{} Chips",
                    "On {C:attention}Stand{} if {C:attention}Bust{},",
                    "{C:red}#2#{} hand value",
                    "{C:inactive}(Currently {C:attention}#3# {C:inactive}hand value){}",
                }
            },
            hydra = {
                text = {
                   "{C:attention}3{}, {C:blue}+#1#{} Chips, {C:attention}Face Card{}",
                    "On {C:attention}Hit{}, Create a {C:attention}Fleeting{}",
                    "copy of this card",
                }
            },
        },
        Joker = {
            j_hit_social = {
                name = "Social Joker",
                text = {
                    "{C:red}+#1#{} Mult if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_hit_manipulative = {
                name = "Manipulative Joker",
                text = {
                    "{C:red}+#1#{} Mult if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_hit_creative = {
                name = "Creative Joker",
                text = {
                    "{C:red}+#1#{} Mult if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_hit_merry = {
                name = "Merry Joker",
                text = {
                    "{C:blue}+#1#{} Chips if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_hit_secretive = {
                name = "Secretive Joker",
                text = {
                    "{C:blue}+#1#{} Chips if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_hit_hoarding = {
                name = "Hoarding Joker",
                text = {
                    "{C:blue}+#1#{} Chips if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_hit_friends = {
                name = "The Friends",
                text = {
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_hit_pair = {
                name = "The Pair",
                text = {
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_hit_bundle = {
                name = "The Bundle",
                text = {
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contains",
                    "a {C:attention}#2#"
                }
            },
            j_hit_constructing_primes = {
                name = "Constructing Primes",
                text = {
                    "Each played {C:attention}2{}, {C:attention}3{},",
                    "{C:attention}5{}, {C:attention}7{}, or {C:attention}Ace{} gives",
                    "{X:mult,C:white} X#1# {} Mult when scored",
                }
            },
            j_hit_tiebreaker = {
                name = "Tiebreaker",
                text = {
                    "On {C:attention}Push{},",
                    "{C:attention}Player{} wins",
                }
            },
            j_hit_jackpot = {
                name = "Jackpot",
                text = {
                    "If {C:attention}played hand{} contains {C:attention}3{}",
                    "{C:attention}7s{}, add a {C:attention}Lucky{}",
                    "{C:attention}7{} to deck"
                }
            },
            j_hit_supernatural_stars = {
                name = "Supernatural Stars",
                text = {
                    "On winning {C:green}Stand{}, Create",
                    "a {C:spectral}Spectral{} card if hand",
                    "contains exactly {C:attention}7{} cards."
                }
            },
            j_hit_perfect_crystal = {
                name = "Perfect Crystal",
                text = {
                    "If hand is {C:attention}Perfect{},",
                    "and has no {C:attention}Aces{},",
                    "{X:mult,C:white} X#1# {} Mult"
                }
            },
            j_hit_big_chip = {
                name = "Big Chip",
                text = {
                    "{C:attention}+#1#{} Bust Limit",
                }
            }
        },
        MinorArcana = {
            ["Ace of hit_pentacles"] = {
                name = '',
                text = {
                    "Add an {C:attention}Ace{} of {C:diamonds}Diamonds{}",
                    "to hand, then {C:red}Discard{}"
                }
            },
            ["Ace of hit_cups"] = {
                name = '',
                text = {
                    "Move to {C:attention}top{} of deck,",
                    "then move all cards",
                    "of a {C:attention}random suit{} in deck",
                    "to {C:attention}top{} of deck"
                }
            },
            ["Ace of hit_swords"] = {
                name = '',
                text = {
                    "Shuffle {C:attention}4 Fleeting Mega{}",
                    "{C:attention}Blackjack 0s{} into",
                    "deck, then {C:red}Discard{}"
                }
            },
            ["Ace of hit_wands"] = {
                name = '',
                text = {
                    "{C:attention}Hit{}, {C:green}Stand{}, then {X:mult,C:white} X2 {}",
                    "Mult at end of either",
                    "{C:attention}scoring{}"
                }
            },
            ["2 of hit_pentacles"] = {
                name = '',
                text = {
                    "Shuffle a {C:attention}Fleeting 2{} of",
                    "{C:diamonds}Diamonds{} and {C:attention}Fleeting Ace{}",
                    "of {C:diamonds}Diamonds{} into the",
                    "deck, then {C:red}Discard{}"
                }
            },
            ["2 of hit_cups"] = {
                name = '',
                text = {
                    "Draw a {C:attention}Queen{} of {C:hearts}Hearts{}",
                    "or {C:attention}King{} of {C:hearts}Hearts{}",
                    "from deck",
                }
            },
            ["2 of hit_swords"] = {
                name = '',
                text = {
                    "Add {C:attention}2 Fleeting{} {C:dark_edition}Foil{} {C:attention}Stone{}",
                    "{C:attention}Cards{} to deck then",
                    "{C:attention}Push{}, then {C:red}Discard{}",
                }
            },
            ["2 of hit_wands"] = {
                name = '',
                text = {
                    "Reveal the {C:attention}rank{} and {C:attention}suit{}",
                    "of the {C:attention}2{} cards atop the",
                    "deck, then {C:red}Discard{}"
                }
            },
            ["3 of hit_pentacles"] = {
                name = '',
                text = {
                    "Add a {C:attention}Fleeting{} card to {C:attention}hand{}",
                    "which would make the hand {C:attention}Perfect{}",
                    "if a {C:attention}rank{} that could do so",
                    "{C:attention}exists{}, then {C:red}Discard{}"
                }
            },
            ["3 of hit_cups"] = {
                name = '',
                text = {
                    "Convert {C:attention}3{} cards in",
                    "hand to a single random",
                    "{C:attention}suit{}, then {C:green}Stand{}",
                },
            },
            ["3 of hit_swords"] = {
                name = '',
                text = {
                    "{C:red}Debuff{} {C:attention}foe's{} enhanced",
                    "cards for the next",
                    "{C:attention}3{} {C:green}stands{}, then {C:red}Discard{}",
                }
            },
            ["3 of hit_wands"] = {
                name = '',
                text = {
                    "If {C:attention}Bust{}, discard {C:attention}1{}",
                    "selected card, then",
                    "{C:attention}Hit{}, then {C:green}Stand{}"
                }
            },
            ["4 of hit_pentacles"] = {
                name = '',
                text = {
                    "Shuffle all {C:attention}Aces{}",
                    "in {C:attention}Full Deck{} to deck,",
                    "then {C:red}Discard{}"
                }
            },
            ["4 of hit_cups"] = {
                name = '',
                text = {
                    "Lock score at {C:attention}0{}",
                    "until {C:attention}4{} suits drawn",
                    "{C:inactive}({C:attention}#1#{C:inactive}/{C:attention}4{C:inactive}){}"
                }
            },
            ["4 of hit_swords"] = {
                name = '',
                text = {
                    "Shuffle {C:attention}14 Fleeting Bonus{}",
                    "{C:attention}Cards{} into {C:attention}deck{}, then {C:green}Stand{}",
                }
            },
            ["4 of hit_wands"] = {
                name = '',
                text = {
                    "Return the card atop the",
                    "{C:attention}discard pile{} to hand, {C:red}Discard{}",
                    "after {C:attention}4{} uses this {C:attention}round{}",
                    "{C:inactive}({C:attention}#1#{C:inactive}/{C:attention}4{C:inactive}, {C:attention}#2#{C:inactive}){}",
                }
            }
        },
        Spectral = {
            c_hit_trance = {
                name = "Trance",
                text = {
                    "Add a {C:blue}Blue Seal{}",
                    "to {C:attention}1{} selected",
                    "card in your hand"
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_blindeffect = "Blind Effect",
            b_blindeffect_cards = "Blind Effects",
            b_loot = "Loot",
            b_common_loot = "Common",
            b_uncommon_loot = "Uncommon",
            b_rare_loot = "Rare",
            b_hit = "Hit",
            b_stand = "Stand",
            ph_blackjack_lost = "You Lost",
            b_choose_cards = "Choose Cards",
            b_exit = "Exit",
            ph_test_memory = "Test your Memory!",
            b_enemy_deck = "Enemy Deck",
            k_untarot = "Untarot",
            b_untarot_cards = "Untarot Cards",
            k_unarcana_pack = "Unarcana Pack",
            ow_ex = "Ow!",
            k_lucky_ex = "Jackpot",
            k_minorarcana_pack = "Minor Arcana Pack",
        },
        v_text = {
            ch_c_ante_hand_discard_reset = {"{C:blue}Hands{} and {C:red}Discards{} are only reset each {C:attention}Ante{}."},
            ch_c_dungeon = {"{C:attention}Blackjack Mode{}"},
        },
        v_dictionary = {
            stands_on = "Stands on #1#"
        },
        challenge_names = {
            c_blackjack = "Blackjack"
        },
        labels = {
            hit_blue_seal = "Blue Seal"
        },
        ranks = {
            hit_0 = '0'
        },
        suits_singular = {
            hit_pentacles = "Pentacle",
            hit_cups = "Cup",
            hit_swords = "Sword",
            hit_wands = "Wand",
        },
        suits_plural = {
            hit_pentacles = "Pentacles",
            hit_cups = "Cups",
            hit_swords = "Swords",
            hit_wands = "Wands",
        },
        poker_hands = {
            ["hit_High Card0"] = "High Card",
            ["hit_Court"] = "Court",
            ["hit_Duo"] = "Duo",
            ["hit_Batch"] = "Batch",
            ["hit_Blackjack"] = "Blackjack",
            ["hit_Duo+"] = "Duo+",
            ["hit_Batch+"] = "Batch+",
            ["hit_Blackjack Batch"] = "Blackjack Batch",
            ["hit_Supreme"] = "Supreme",
        },
        poker_hand_descriptions = {
            ["hit_High Card0"] = {
                "If the played hand is not any of the above",
                "hands, only the highest ranked card scores"
            },
            ["hit_Court"] = {
                "2 face cards. They may be played",
                "with up to 3 other unscored cards"
            },
            ["hit_Duo"] = {
                "2 cards that share the same rank and another",
                "card of another rank. They may be played",
                "with up to 2 other unscored cards"
            },
            ["hit_Batch"] = {
                "3 cards that share the same suit. They may",
                "be played with up to 2 other unscored cards"
            },
            ["hit_Blackjack"] = {
                "Cards where hand sum is",
                "equal to bust limit"
            },
            ["hit_Duo+"] = {
                "3 or more cards that share the same rank and",
                "another card of another rank. They may be played",
                "with up to 1 other unscored card"
            },
            ["hit_Batch+"] = {
                "4 cards that share the same suit. They may",
                "be played with up to 1 other unscored card"
            },
            ["hit_Blackjack Batch"] = {
                "3 or more cards all the same suit where",
                "hand sum is equal to bust limit"
            },
            ["hit_Supreme"] = {
                "6 or more cards with a rank"
            },
        }
    }
}
