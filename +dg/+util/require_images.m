function require_images(prog)

win = prog.Value.windows.main;
ims = prog.Value.images;
im_names = fieldnames( ims );
src_ims = ims;

for i = 1:numel(im_names)
  if ( ~isa(ims.(im_names{i}), 'ptb.Image') )
    ims.(im_names{i}) = ptb.Image( win, ims.(im_names{i}) );
  end
end

prog.Value.images = ims;
prog.Value.image_matrices = src_ims;

end