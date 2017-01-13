function [stats] = genstats8show()

x{1} = load('data\loo1\SUPERWRAP.mat');
x{2} = load('data\loo2\SUPERWRAP.mat');

for v = 3:3
    load(['data/imdb_n0_r5_f1_v',num2str(v),'.mat']);
    for l = 2:2
        for s = 3:3
            fprintf('L%d:v%d:s%d\n',l,v,s);
            [y,yp] = prednet(x{l}.bestnet{v}, imdb, s);
            ypx    = round(yp);
            stats.err(l,v,s) = mean(abs(y-yp));
            stats.acc(l,v,s) = performanceclassify(y, ypx, {'acc'});
            stats.sen(l,v,s) = performanceclassify(y, ypx, {'sen'});
            stats.spe(l,v,s) = performanceclassify(y, ypx, {'spe'});
            j = 1;va
            for k = 1:numel(imdb.im.set)
                if imdb.im.set(k) == s
                    if (ypx(j) - y(j)) == -1
                        timshow(imdb.im.data(:,:,:,k));
                        set(gcf,'position',[100,100,350,300]);
                        pause;
                    end
                    j = j + 1;
                end
            end
        end
    end
end

