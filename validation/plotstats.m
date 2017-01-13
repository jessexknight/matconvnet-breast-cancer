function [] = plotstats(stats, leg)
clr1 = [255,51,51]./255;
clr2 = [0,191,191]./255;

figure;
subplot(2,2,1); hold on;
plot(stats{1}.err,'color',clr1);
plot(stats{2}.err,'color',clr2);
ylim([0.3,0.6]);
labelz(leg,'Error');

subplot(2,2,2); hold on;
plot(stats{1}.acc,'color',clr1);
plot(stats{2}.acc,'color',clr2);
ylim([0.2,0.8]);
labelz(leg,'Accuracy');

subplot(2,2,3); hold on;
plot(stats{1}.sen,'color',clr1);
plot(stats{2}.sen,'color',clr2);
ylim([-0.001,0.7]);
labelz(leg,'Sensitivity');

subplot(2,2,4); hold on;
plot(stats{1}.spe,'color',clr1);
plot(stats{2}.spe,'color',clr2);
ylim([0.8,1.001]);
labelz(leg,'Specificity');


function labelz(leg,lab)
set(gca,'fontsize',16);
xlabel('New Best Validation Error');
ylabel(['Test ',lab]);
legend(leg,'location','best');




