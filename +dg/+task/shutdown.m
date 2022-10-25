function shutdown(program)

close_arduino( program );
close_windows( program );

end

function close_arduino(program)

try
  reward_manager = program.Value.arduino_reward_manager;
  
  if ( ~isempty(reward_manager) )
    close( reward_manager );
  end
  
catch err
  warning( err.message );
end

end

function close_windows(program)

try
  structfun( @close, program.Value.windows );
catch err
  warning( err.message );
end

end