function bi = bin_trials(I, bin_size)

bi = cell( size(I) );
for i = 1:numel(I)
  bi{i} = shared_utils.vector.slidebin( 1:numel(I{i}), bin_size );
end

end