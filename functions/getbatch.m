function [im, labels] = getbatch(imdb, idx)

im     = imdb.im.data(:,:,:,idx) ;
labels = imdb.im.mal(idx) ;