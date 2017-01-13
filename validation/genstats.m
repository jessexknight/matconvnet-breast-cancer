function [stats] = genstats(imdb)
iset = 3;
dirname = '\\north.cfs.uoguelph.ca\soe-other-home$\jknigh04\My Documents\MATLAB\cnn\data\x\best\';
D = dir(dirname);
k = k + 1;
for d = 3:numel(D)
    if strfind(D(d).name,'_n_');
        fprintf([D(d).name,'\n']);
        load([dirname,D(d).name]);
        [y,yp] = prednet(bestnet,imdb,iset);
        stats.err(k) = mean(abs(y-yp));
        ypx = round(yp);
        stats.acc(k) = performanceclassify(y, ypx, {'acc'});
        stats.sen(k) = performanceclassify(y, ypx, {'sen'});
        stats.spe(k) = performanceclassify(y, ypx, {'spe'});
        k = k + 1;
    end
end

