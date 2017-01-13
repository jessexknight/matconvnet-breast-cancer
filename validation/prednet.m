function [y, yp] = prednet(net, imdb, sets)
iset = zeros(size(imdb.im.set));
for s = 1:numel(sets)
    iset = (iset | imdb.im.set == sets(s));
end
data = imdb.im.data(:,:,:,iset);
labs = imdb.im.mal(iset);
N = sum(iset);
for k = 1:N
    net.layers{end}.class = labs(k);
    res   = vl_simplenn(net, data(:,:,:,k));
    yp(k) = res(end-1).x;
    y(k)  = labs(k);
end
   
    
    