function show(f1, Q, winrate)

    clf(f1);
    subplot(2, 1, 1);
    maxQ = squeeze(max(Q, [], 1));
    surf(maxQ);

    subplot(2, 1, 2);
    hold on
    plot(winrate);
    plot([1, numel(winrate)], [0.5, 0.5]);
    hold off
    drawnow;
end