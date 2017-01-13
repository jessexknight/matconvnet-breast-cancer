function [] = superwrap()

k = 1;
for n = 0:0 % normalized?
for r = 5:5 % downsample ratio
for f = 1:1 % flipped? = larged imdb
for v = 1:4 % cross validation instance
    [net{k}, bestnet{k}, opts{k}, errors{k}] = traincnnx(n,r,f,v);
    k = k + 1;
end
end
end
end
save('data/loo/SUPERWRAP.mat','net','bestnet','opts','errors','-v7.3');

