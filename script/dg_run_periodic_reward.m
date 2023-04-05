conf = dg.config.create();

channels =  2;
reward_duration_s = 0.3;
reward_interval_s = 7;

dg_periodic_reward( conf, channels, reward_duration_s, reward_interval_s );