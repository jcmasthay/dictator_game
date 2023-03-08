conf = dg.config.create();

channels = 1:2;
reward_duration_s = 0.5;
reward_interval_s = 5;

dg_periodic_reward( conf, channels, reward_duration_s, reward_interval_s );