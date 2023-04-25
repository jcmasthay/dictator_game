function loop(program, task)

update( program.Value.component_updater );
update_reward_manager( program );

end

function update_reward_manager(program)

reward_manager = program.Value.arduino_reward_manager;
if ( ~isempty(reward_manager) && isvalid(reward_manager) )

  if ( ~isfield(program.Value, 'reward_key_timer') )
    program.Value.reward_key_timer = tic;
  end
  if ( ptb.util.is_key_down(ptb.keys.r) && toc(program.Value.reward_key_timer) > 0.25 )
    reward_info = program.Value.conf.reward;
    dg.util.deliver_reward( program, 1, reward_info.key_press );
    program.Value.reward_key_timer = tic;
  end
  
  update( reward_manager );
end

end