function loop(program, task)

update( program.Value.component_updater );
update_reward_manager( program );

end

function update_reward_manager(program)

reward_manager = program.Value.arduino_reward_manager;
if ( ~isempty(reward_manager) && isvalid(reward_manager) )
  update( reward_manager );
end

end