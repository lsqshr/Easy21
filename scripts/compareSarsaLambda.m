lambdalist = 0:0.1:1;

lwinrate = {};

figure()

parfor i = 1 : numel(lambdalist)
	p = struct();
	p.gamma = 0.5;
	p.plot = false;
	p.test = false;
	p.showevery = 5e5;
	p.snapshotevery = 5e5;
	p.nepisode = 5e5;
    p.lambda = lambdalist(i);
    lwinrate{i}.lambda = p.lambda;
    lwinrate{i}.winrate = SARSA(p);
    legendstr{i} = sprintf('lambda = %.1f', lambdalist(i));
end

cmap = hsv(11);  %# Creates a 6-by-3 set of colors from the HSV colormap
hold on
for i = 1 : numel(lambdalist)
	plot(lwinrate{i}.winrate, '-', 'Color', cmap(i,:));
end

hold off
legend(legendstr)

save('Lambda-Compare.mat', 'lwinrate');