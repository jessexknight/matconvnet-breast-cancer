function [imdb] = buildimdb()

% imdb parameters
isfresh  = 1; % redefine or just load?

isresize = 5; % downsampling
isflip   = 1; % flip 4 times = larger imdb
isnorm   = 0; % normalize images
val      = 4; % validation set

nx       = 2; % number of subs in x
ny       = 2; % number of subs in y

datadir  = [cd,'/data/'];
imdir    = [datadir,'img'];
datafile = [datadir,'imdb','_n',num2str(isnorm),...
                           '_r',num2str(isresize),...
                           '_f',num2str(isflip),...
                           '_v',num2str(val),'.mat'];
rawfile  = [datadir,'imdb_raw.mat'];
imftype  = '.tif';
labels   = {'benign','malignant'};



% load existing imdb - no work
if exist(datafile,'file') && ~isfresh
    fprintf('...LOADING IMDB\n');
    load(datafile);
    return;
end

% load existing raw - still need to parse
if exist(rawfile,'file');
    fprintf('...LOADING RAW\n');
    load(rawfile);
else
% load images - happens once
    fprintf('...BUILDING RAW\n');
    [ims,y] = rawread(imdir, imftype, labels);
    save(rawfile,'ims','y','-v7.3');
    fprintf('...SAVING RAW\n');
end

% parse imdb - varies with parameters above
fprintf('...BUILDING IMDB\n');
[imdb]  = parseims(ims, y, nx, ny, isnorm, isresize, isflip, val);
fprintf('...SAVING IMDB\n');
save(datafile,'imdb','-v7.3');

function [ims,y] = rawread(imdir, imftype, labels)
D = rdir(imdir);

k = 1;
for d = 1:numel(D)
    if strcmp(filetype(D(d).name),imftype);
        im = single(imread(D(d).pathname))./255;
        ims(:,:,:,k) = im;
        y(k) = any(strfind(D(d).name,labels{2}));
        k = k + 1;
    end
end

function [imdb] = parseims(ims, y, nx, ny, isnorm, isresize, isflip, val)
Ni    = size(ims,4);
isize = [size(ims,1),size(ims,2)];
psize = isize./[ny,nx];
setr  = [1,1,2,3];
setr  = circshift(setr',val)';
ns    = numel(setr);

k = 1;                              % k ~ output images
for n = 1:Ni                        % n ~ input images
    j = mod(n,ns); j(j==0) = ns;    % j ~ image set
    for yi = 1:ny
        yidx = 1 + (yi-1) * psize(1) : yi * psize(1);
        for xi = 1:nx
            xidx = 1 + (xi-1) * psize(2) : xi * psize(2);
            % grab frame
            imi = ims(yidx,xidx,:,n);
            % resize(?)
            if isresize
                imi = imresize(imi,1/isresize);
            end
            % normalize(?)
            if isnorm
                imi = imnormalize(imi);
            end
            % assign 1
            imdb.im.set(k)        = setr(j);
            imdb.im.data(:,:,:,k) = single(imi);
            imdb.im.mal(k)        = single(y(n));
            k = k + 1;
            % assign flips(?)
            if isflip
                for c = 1:3
                    imdb.im.data(:,:,c,k)   = single(fliplr(imi(:,:,c)));   % lr
                    imdb.im.data(:,:,c,k+1) = single(flipud(imi(:,:,c)));   % ud
                    imdb.im.data(:,:,c,k+2) = single( rot90(imi(:,:,c),2)); % lr+ud
                end
                imdb.im.mal(k:k+2) = single(y(n));
                imdb.im.set(k:k+2) = setr(j); 
                k = k + 3;
            end
        end
    end
    fprintf('%03d\n',n);
end
imdb.size = [size(imdb.im.data,1),size(imdb.im.data,2)];

function [imn] = imnormalize(im)
K   = ones(7);
km  = 25;
imk = kernelcat(im,K);
imn = 0.5 + ( squeeze(imk(km,:,:,:)) - squeeze(mean(imk,1)) );% ./ squeeze(magnitude(imk,1));
imn(isnan(imn)) = 0;
imn(isinf(imn)) = 0;






