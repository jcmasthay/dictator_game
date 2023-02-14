function program = setup(conf)

comp_updater = ptb.ComponentUpdater();

windows = create_windows( conf );

program = ptb.Reference();
program.Value.windows = windows;
program.Value.component_updater = comp_updater;
program.Value.stimuli = create_stimuli( conf );
program.Value.gaze_sources = create_gaze_sources( conf, comp_updater );
program.Value.gaze_samplers = create_gaze_samplers( ...
  program.Value.gaze_sources, comp_updater );
program.Value.targets = create_targets(...
  conf, program.Value.stimuli, program.Value.gaze_samplers, windows, comp_updater );
program.Value.states = create_states( program, conf );
program.Value.arduino_reward_manager = create_reward_manager( conf );
program.Value.conf = conf;

program.Destruct = @dg.task.shutdown;

end

function states = create_states(program, conf)

states = containers.Map();
state_names = { 'fixation', 'cue_on', 'cue_off', 'mag_cue', 'new_trial', 'end_trial' ...
  , 'cued_decision', 'true_decision', 'iti', 'delay_to_decision' ...
  , 'delay_to_reward', 'reward', 'train_decision' };
args = { {}, {}, {}, {}, {}, {}, {}, {}, {'end_trial'}, {}, {}, {}, {} };

for i = 1:numel(state_names)
  arg = args{i};
  state = eval( sprintf('dg.states.%s(program, conf, arg{:});', state_names{i}) );
  states(state_names{i}) = state;
end

end

function wins = create_windows(conf)

wins = struct();

win_names = fieldnames( conf.windows );
for i = 1:numel(win_names)
  win_desc = conf.windows.(win_names{i});
  win = ptb.Window( win_desc.rect );
  win.Index = win_desc.index;
  win.SkipSyncTests = true; % @NOTE
  wins.(win_names{i}) = win;
end

end

function sources = create_gaze_sources(conf, comp_updater)

sources = struct();

source_names = fieldnames( conf.sources );
for i = 1:numel(source_names)
  src_name = source_names{i};
  source_desc = conf.sources.(src_name);
  
  switch ( source_desc.type )
    case 'digital_eyelink'
      source = ptb.sources.Eyelink();
      initialize( source );
      start_recording( source );
      
    case 'mouse'
      source = ptb.sources.Mouse();      
    otherwise
      error( 'Unrecognized source type "%s".', source_desc.type );
  end
  
  sources.(src_name) = source;
  add_component( comp_updater, source );
end

end

function samplers = create_gaze_samplers(sources, comp_updater)

samplers = struct();

source_names = fieldnames( sources );
for i = 1:numel(source_names)
  src = sources.(source_names{i});
  sampler = ptb.samplers.Pass( src );
  samplers.(source_names{i}) = sampler;
  add_component( comp_updater, sampler );
end

end

function targets = create_targets(conf, stimuli, samplers, windows, comp_updater)

match_stim = conf.targets.matching_stimuli;

targets = struct();
for i = 1:numel(match_stim)
  assert( isstruct(match_stim{i}) );
  
  stim_name = match_stim{i}.name;
  source_name = match_stim{i}.source;
  dur = match_stim{i}.duration;
  
  assert( isfield(stimuli, stim_name) ...
    , 'Reference to non-existent stimulus "%s".', stim_name ); 
  assert( isfield(samplers, source_name) ...
    , 'Reference to non-existent source "%s".', source_name ); 
  
  stim = stimuli.(stim_name);
  sampler = samplers.(source_name);
  
  if ( isfield(match_stim{i}, 'window') )
    win_name = match_stim{i}.window;
    assert( isfield(windows, win_name) ...
      , 'Reference to non-existent window "%s".', win_name ); 
    stim.Window = windows.(win_name);
  end
  
  targ = ptb.XYTarget(...
    sampler, ptb.bounds.Rect(ptb.rects.MatchRectangle(stim)));
  targ.Duration = dur;
  targets.(stim_name) = targ;
  
  add_component( comp_updater, targ );
end

end

function stimuli = create_stimuli(conf)

stimuli = struct();

fs = fieldnames( conf.stimuli );
for i = 1:numel(fs)
  desc = conf.stimuli.(fs{i});
  
  switch ( desc.type )
    case 'ptb.stimuli.Rect'
      stim = ptb.stimuli.Rect();
      stim.Position = desc.position;
      stim.Position.Units = 'norm';
      stim.Scale = desc.scale;
      stim.Scale.Units = 'px';      
      stim.FaceColor = desc.color;
    otherwise
      error( 'Unrecognized stimulus type "%s".', desc.type );
  end
  
  stimuli.(fs{i}) = stim;
end

end

function arduino_reward_manager = create_reward_manager(conf)

serial = conf.serial;

if ( serial.disabled )
  arduino_reward_manager = [];
  return
end

port = serial.port;
messages = struct();
channels = serial.channels;

arduino_reward_manager = serial_comm.SerialManager( port, messages, channels );
start( arduino_reward_manager );

end