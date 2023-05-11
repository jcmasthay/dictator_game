mat_file = '11-May-2023 15_34_45';

mat_data = load( mat_file );
edf_filename = mat_data.conf.sources.m1_gaze.edf_filename;

sesh = strsplit( mat_file, ' ' );
sesh_p = datestr( sesh{1}, 'mmddyyyy' );
edf_file = Edf2Mat( fullfile(dg.util.data_root, 'edf', sesh_p, edf_filename) );

trial_num = 2;
trial_start = mat_data.data(trial_num).Fixation.EntryTime;

edf_sync_ts = edf_file.Events.Messages.time(strcmp(edf_file.Events.Messages.info, 'SYNC'));
mat_sync_ts = mat_data.m1_el_sync_times;

edf_start = floor( shared_utils.sync.cinterp(trial_start, mat_sync_ts, edf_sync_ts) );
edf_start = find( edf_file.Samples.time == edf_start );
num_samples = 1000; % 1 second
edf_end = edf_start + num_samples - 1;

x = edf_file.Samples.posX(edf_start:edf_end);
y = edf_file.Samples.posY(edf_start:edf_end);
t = linspace( trial_start, trial_start + num_samples/1e3, num_samples );

figure(1); clf;
h = gobjects( 0 );
h(end+1) = plot( t, x, 'displayname', 'x' );
hold on;
h(end+1) = plot( t, y, 'displayname', 'y' );
legend( h );