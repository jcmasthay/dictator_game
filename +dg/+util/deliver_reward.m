function deliver_reward(program, channel, duration_s)

reward_manager = program.Value.arduino_reward_manager;
if ( ~isempty(reward_manager) && isvalid(reward_manager) )
  reward( reward_manager, channel, duration_s * 1e3 ); % to ms
end

end