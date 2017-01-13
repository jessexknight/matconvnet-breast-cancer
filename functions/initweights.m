function [net] = initweights(net, imdb)

psize = size(net.layers{1}.weights{1});
for k = 1:psize(end)
    ipatch = single(impatch(imdb,psize));
    net.layers{1}.weights{1}(:,:,:,k) = 1.0 * ipatch ...
                                      + 0.0 * randn(psize(1),psize(2),psize(3),1, 'single');
end

function [ip] = impatch(imdb, psize)
pad  = ceil([psize(1:2)]/2);
rngy = imdb.size(1)-2*pad(1)-1;
rngx = imdb.size(2)-2*pad(2)-1;
y    = ceil(rngy*rand(1)+pad(1));
x    = ceil(rngx*rand(1)+pad(2));
z    = ceil(size(imdb.im.data,4)*rand(1));
yidx = y-(pad(1)-1):y+(pad(1)-1);
xidx = x-(pad(2)-1):x+(pad(2)-1);

ip = imdb.im.data(yidx,xidx,:,z);
