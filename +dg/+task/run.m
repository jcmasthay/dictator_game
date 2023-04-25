function data = run(conf, trial_set)

prog = dg.task.setup( conf );
prog.Value.trial_set = trial_set;
prog.Value.data = dg.task.TrialData.empty();

structfun( @open, prog.Value.windows );

task = ptb.Task();
task.Loop = @(task) dg.task.loop(prog, task);
task.Duration = inf;
exit_on_key_down( task, ptb.keys.esc );

prog.Value.task = task;
dg.util.require_images( prog );
run( task, prog.Value.states('new_trial') );

data = prog.Value.data;

delete( prog );

end