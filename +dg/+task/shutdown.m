function shutdown(program)

close_arduino( program );
close_windows( program );
stop_recording_gaze( program );

end

function stop_recording_gaze(program)

try
  fs = fieldnames( program.Value.gaze_sources );
  for i = 1:numel(fs)
    try
      stop_recording( program.Value.gaze_sources.(fs{i}) );
    catch
      %
    end
  end
catch err 
  warning( err.message );
end

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