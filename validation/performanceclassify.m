function [M, TP_FP_TN_FN] = performanceclassify(y, yp, metric)
    
TP_FP_TN_FN = confusion(y,yp);

for m = 1:numel(metric)
    switch metric{m}
        case 'acc'
            metricfcn = @accuracy;
        case 'sen'
            metricfcn = @sensitivity;
        case 'spe'
            metricfcn = @specificity;
        case 'ppv'
            metricfcn = @pospredvalue;
        case 'npv'
            metricfcn = @negpredvalue;
        case 'fpr'
            metricfcn = @falseposrate;
        case 'fnr'
            metricfcn = @falsenegrate;
        otherwise
            error('Metric not recognized.');
    end
    M(m) = metricfcn(TP_FP_TN_FN);
end

function [TP_FP_TN_FN] = confusion(y,yp)
TP_FP_TN_FN(1) = sum( (y(:) == 1) & (yp(:) == 1) );
TP_FP_TN_FN(2) = sum( (y(:) == 0) & (yp(:) == 1) );
TP_FP_TN_FN(3) = sum( (y(:) == 0) & (yp(:) == 0) );
TP_FP_TN_FN(4) = sum( (y(:) == 1) & (yp(:) == 0) );

function [acc] = accuracy(TP_FP_TN_FN)
TP = TP_FP_TN_FN(1);
TN = TP_FP_TN_FN(3);
acc = (TP + TN) / sum(TP_FP_TN_FN);

function [sen] = sensitivity(TP_FP_TN_FN)
TP = TP_FP_TN_FN(1);
FN = TP_FP_TN_FN(4);
sen = TP / (TP + FN); 

function [spe] = specificity(TP_FP_TN_FN)
FP = TP_FP_TN_FN(2);
TN = TP_FP_TN_FN(3);
spe = TN / (TN + FP);

function [ppv] = pospredvalue(TP_FP_TN_FN)
TP = TP_FP_TN_FN(1);
FP = TP_FP_TN_FN(2);
ppv = TP / (TP + FP);

function [npv] = negpredvalue(TP_FP_TN_FN)
TN = TP_FP_TN_FN(3);
FN = TP_FP_TN_FN(4);
npv = TN / (TN + FN);

function [fpr] = falseposrate(TP_FP_TN_FN)
FP = TP_FP_TN_FN(2);
TN = TP_FP_TN_FN(3);
fpr = FP / (FP + TN);

function [fnr] = falsenegrate(TP_FP_TN_FN)
FN = TP_FP_TN_FN(4);
TP = TP_FP_TN_FN(1);
fnr = FN / (FN + TP);


