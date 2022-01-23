local status_ok, lightspeed = pcall(require, "lightspeed")
if not status_ok then
  return
end
lightspeed.setup {
  ignore_case = true,
  exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },

  -- s/x
  jump_to_unique_chars = { safety_timeout = 400 },
  match_only_the_start_of_same_char_seqs = true,
  substitute_chars = { ['\r'] = '¬' },
  force_beacons_into_match_width = false,
  -- Leaving the appropriate list empty effectively disables
  -- "smart" mode, and forces auto-jump to be on or off.
  -- safe_labels = { . . . },
  -- labels = { . . . },
  --[[ cycle_group_fwd_key = '<space>',
  cycle_group_bwd_key = '<tab>', ]]

  -- f/t
  limit_ft_matches = 4,
  repeat_ft_with_target_char = false,
}
