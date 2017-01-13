function [K] = kernelshow(net,isgray)
j = 1;
data   = net.layers{1}.weights{1};
q1     = quantile(data(:),0.002);
q2     = quantile(data(:),0.998);
scale  = q2-q1;
offset = q1;

for k = 1:size(data,4)
    im = data(:,:,:,k);
    if isgray
        for c = 1:3
            K(k).im = (im(:,:,c) - offset) ./ 50*scale;
            j = j + 1;
        end
    else
        K(k).im = (im - offset) ./ scale;
    end
end
timshow(K(:).im);
drawnow;
