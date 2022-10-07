# Tank-Battle
 A Garry's Mod addon made for a friend event. Has miniature gamemodes that attach to the Sandbox gamemode.

## Commands
| **Command** | **Description** |
|---|---|
| tb_enabled \<num true> | Enables/Disables the addon. |
| tb_start_match | Starts the match. |
| tb_end_match | Forces the match to stop and reset, if one is ongoing. |
| tb_create_team \<string name> [num red] [num green] [num blue] | Creates a team with the given name (use quotation marks) and color (defaults to a random color) |
| tb_remove_team \<string name> | Removes the team with the given name, if it exists. |
| tb_join_team \<string name> | Joins the team with the given name, if it exists. |
| tb_leave_team \<string name> | Leaves the team with the given name, if it exists. |
| tb_capture_speed_multiplier \<num mul=1.5> | The capture point capture speed multiplier when multiple people of the same team are on one point. |
| tb_airdrop_capture_radius <num radius=128> | Sets the radius where air dropped crates can be captured. |
___
 
## Edit Mode Commands

These commands only work when `tb_edit` is set to 1, and can only be changed by superadmins. Each command's value is saved to config files to make different matches, and is loaded when the config is loaded.
 
| **Command** | **Description** |
|---|---|
| tb_edit \<num true> | Enter or exit edit mode by passing 1 or 0 respectively. Superadmin only. This needs to be enabled to do the below commands. |
| tb_save \<string name> | Saves a map-specific config with the name specified. |
| tb_load \<string name> | Loads a map-specific config with the name specified, if it exists. |
| tb_list_configs | Lists all saved configs available on the current map. |
| tb_create_capture_point \<string name> \<num radius> [num time_to_capture=20] [num points_instant=20] [num points/sec=1] | Creates a capture point at your current position with the given name, radius in source units, seconds it takes to capture it (default 20), points given instantly after capturing (default 20), and points per second after capturing (default 1) |
| tb_removes_capture_point \<string name> | Removes the capture point with the given name, if it exists. |
| tb_create_airdrop_spawn \<string name> | Creates a spawn point for air dropped crates to land on with the given name at your current position. |
| tb_remove_airdrop_spawn \<string name> | Removes the airdrop spawn with the given name, if it exists. |
| tb_match_time_limit \<num seconds=600> | Length of the match in seconds. (Set to 0 for matches where one side must reach the point goal to end) |
| tb_player_lives \<num lives=1> | Number of lives that a player gets before being considered dead. (0 for infinite) |
| tb_win_amount \<num points=250> | Sets the number of points needed for a team to win the match. (Set to 0 if you want a match that is purely time restrained and the team with the most points at the end wins) |
| tb_kill_points \<num points=25> | Sets the number of points given to a player for killing an enemy. |
| tb_teamkill_penalty \<num points=25> | Sets the number of points deducted from a player for teamkilling. (0 for none, or negative to reward) |
 
