function [] = printstats(stats)
SET = {'TRAINING','VALIDATION','TEST'};
params = {'err','acc','sen','spe'};
for s = 1:3
    fprintf([SET{s},'\n']);
    for p = 1:4
        fprintf([params{p},': ']);
        data = stats.(params{p})(:,:,s);
        u = median(data(:));
        q = iqr(data(:));
        fprintf('%.02f <%.02f>\n',u,q);
    end
end