function state = reward(program, conf)

state = ptb.State();
state.Name = 'reward';
state.Duration = conf.time_in.(state.Name);
state.Entry = @(state) entry(state, program);
state.Exit = @(state) exit(state, program);

end

function entry(~, program)

structfun( @flip, program.Value.windows );

channel_index = program.Value.reward_channel_index;

if ( isempty(channel_index) )
  warning( ['Empty reward channel index implies no choice was made;' ...
    , ' no reward will be delivered.'] );
else
  reward_info = program.Value.conf.reward;
  channels = program.Value.trial_descriptor.RewardChannels;
  assert( channel_index <= numel(channels), 'Out of bounds reward channel index.' );

  for i = 1:numel(channels{channel_index})
    dg.util.deliver_reward( ...
      program, channels{channel_index}(i), reward_info.main );
  end
end

end

function exit(state, program)

next( state, program.Value.states('iti') );

end