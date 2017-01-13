function [net, bestnet, opts, errors] = traincnn(n,r,f,v)

% -------------------------------------------------------------------------
% LOAD DEFS
% -------------------------------------------------------------------------

paramstr = ['_n',num2str(n),'_r',num2str(r),'_f',num2str(f),'_v',num2str(v)];
load(['data/imdb',paramstr,'.mat']);
[net,opts] = defnet; % r = 5!
opts.train = find(imdb.im.set == 1);
opts.valid = find(imdb.im.set == 2);

% -------------------------------------------------------------------------
% INIT
% -------------------------------------------------------------------------

% net layers
for i = 1:numel(net.layers)
    if isfield(net.layers{i},'weights')
        J = numel(net.layers{i}.weights);
        for j = 1:J
            net.layers{i}.momentum{j} = zeros(size(net.layers{i}.weights{j}), 'single');
        end
        if ~isfield(net.layers{i},'learningrate')
            net.layers{i}.learningrate = ones(1, J, 'single');
        end
        if ~isfield(net.layers{i},'weightdecay')
            net.layers{i}.weightdecay = ones(1, J, 'single');
        end
    end
end

% -------------------------------------------------------------------------
% TRAIN AND VALIDATE
% -------------------------------------------------------------------------

fprintf(['TRAINING: ',paramstr,'\n']);

errors  = [];
besterr = 0.5;
bestnet = net;
besti   = 1;
for epoch = 1:opts.numepochs
    fprintf('%03d ', epoch);
    learningrate = opts.learningrate(min(epoch, numel(opts.learningrate)));
    train        = opts.train(randperm(numel(opts.train)));
    valid        = opts.valid;
	
    % train and validate
    [net, errors(end+1,1)] = trainepoch(opts, train, learningrate, imdb, net, epoch);
    [~,   errors(end,  2)] = trainepoch(opts, valid,            0, imdb, net, epoch);
    errors(end,3) = mean(errors(max(1,end-20):end,2));
    
    % best net saving (in case manual stop)
    if errors(end,2) < besterr
        besterr = errors(end,2);
        bestnet = net;
        save(['data/loo/best/bestnet',paramstr,'_',num2str(besti),'.mat'],...
              'bestnet','opts','errors','-v7.3');
        besti = besti + 1;
    end
    
    % show
    if ~mod(epoch,25)
        fprintf('\n');
        figure(1), plot(errors), ylim([0,1]);
        figure(2), kernelshow(net,0);
        drawnow;
        save(['data/loo/interval/net',paramstr,'_',num2str(epoch,'%04d'),'.mat'],...
              'net','opts','errors','-v7.3');
    end
end

save(['data/loo/TRIAL',paramstr,'.mat'],'net','bestnet','opts','errors','-v7.3');

function [net,error] = trainepoch(opts, subset, learningrate, imdb, net, epoch)
training = learningrate > 0;

res    = [];
errors = [];

for t = 1:numel(subset)
            
    % fetch batch
    batch = subset(t);
    batchsize = numel(batch);
    [im, labels] = getbatch(imdb,batch);
    
    % eval cnn
    net.layers{end}.class = labels;
    if training
        dzdy = 1;
    else
        dzdy = [];
    end
    [res] = vl_simplenn(net, im, dzdy, res, ...
                        'accumulate',     batchsize ~= 1, ...
                        'disableDropout', ~training, ...
                        'conserveMemory', opts.conservememory, ...
                        'backPropDepth',  opts.backpropdepth, ...
                        'sync',           opts.sync, ...
                        'cudnn',          opts.cudnn);
    % error
    errors(end+1) = opts.errorfunction(opts, labels, res);
    
    % accumulate gradients
    if training
        [net, res] = accumulategradients(opts, learningrate, 1, net, res);
    end
end
error = mean(abs(errors));

function [net, res] = accumulategradients(opts, LR, batchsize, net, res)

for l = numel(net.layers):-1:1
    for j = 1:numel(res(l).dzdw)
        idecay = opts.weightdecay * net.layers{l}.weightdecay(j);
        iLR    = LR * net.layers{l}.learningrate(j);
        
        if isfield(net.layers{l}, 'weights')
            net.layers{l}.momentum{j} = ...
                opts.momentum * net.layers{l}.momentum{j} ...
                     - idecay * net.layers{l}.weights{j}  ...
                     - (1/batchsize) * res(l).dzdw{j};
            net.layers{l}.weights{j} = ...
                net.layers{l}.weights{j} ...
                + iLR * net.layers{l}.momentum{j};
        end
    end
end



