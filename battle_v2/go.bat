(load 0_Main.clp)
(load 1_Env.clp)
(load case1_obs_2.clp)
(load 3_Agent.clp)
(reset)
(set-break game-over)
(run)
(run 2)
(focus ENV)
(facts)

(and
(clear)
(load /Users/RED1/Desktop/battle_v1/0_Main.clp)
(load /Users/RED1/Desktop/battle_v1/1_Env.clp)
(load /Users/RED1/Desktop/battle_v1/2_case1_4.clp)
(load /Users/RED1/Desktop/battle_v1/3_Action_v2.clp)
(reset)
)

(and
(dribble-on /Users/RED1/Desktop/battle_v2/outputAGENT.clp)
(facts AGENT)
(dribble-off)
)


(and
(clear)
(load /Users/RED1/Desktop/battle_v2/0_Main.clp)
(load /Users/RED1/Desktop/battle_v2/1_Env.clp)
(load /Users/RED1/Desktop/map/map4/map_4_no_know.clp)
(load /Users/RED1/Desktop/battle_v2/main_agent.clp)
(load /Users/RED1/Desktop/battle_v2/main_control.clp)
(load /Users/RED1/Desktop/battle_v2/after_no_know.clp)
(load /Users/RED1/Desktop/battle_v2/know_double_middle.clp)
(load /Users/RED1/Desktop/battle_v2/know_two.clp)
(load /Users/RED1/Desktop/battle_v2/know_one.clp)
(load /Users/RED1/Desktop/battle_v2/know_one_indecision.clp)
(load /Users/RED1/Desktop/battle_v2/know_middle.clp)
(load /Users/RED1/Desktop/battle_v2/no_know.clp)
(reset)
)

