function [err] = errorfun(opts, labels, res)
predictions = squeeze(res(end-1).x);
err         = bsxfun(@minus, predictions, labels);

