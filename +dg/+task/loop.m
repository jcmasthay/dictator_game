function loop(program, task)

update( program.Value.component_updater );
update_reward_manager( program );
update_eyelink_sync( program, task );

end

function update_eyelink_sync(program, task)

if ( isfield(program.Value.gaze_sources, 'm1_gaze') ) 
  if ( isnan(program.Value.m1_eyelink_sync_timer) || ...
      toc(program.Value.m1_eyelink_sync_timer) >= 1 )
    
    program.Value.m1_eyelink_sync_timer = tic;
    curr_t = elapsed( task );
    program.Value.gaze_sources.m1_gaze.send_message( 'SYNC' );
    
    program.Value.m1_eyelink_sync_times(end+1, 1) = curr_t;
  end
end

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