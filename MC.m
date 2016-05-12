function MC(p)
	f1 = figure();

    if p.test
        Q = p.Q;
    else
    	Q = zeros(2, 21, 10); % Value Function
    end

	G = zeros(size(Q));
	E = logical(zeros(size(Q))); % Track the episode
	R = zeros(size(Q)); % Total reward
	C = zeros(size(Q)); % Counter of the S,A pair amoung episodes

    % Count the winned rounds 
    winctr = 0;	
    winrate = zeros(5e7, 1);

	i = 0;
	game = Easy21Env();
    while true % Episodes
    	i = i + 1;
    	game.reset(); % Start a new round

    	% Clear the total reward and the episode
    	G(:) = 0;
    	E(:) = 0;

		dc = uint8(get(game, 'dealerSum')); % Dealer Card
    	while get(game, 'win') == -2 % One Round 
    		ps = uint8(get(game, 'playerSum')); % Player Sum
    		q = Q(:, ps, dc);
            eps = (100 / (100 + sum(C(:, ps, dc)))); % Occurance varying eps

            if rand() < eps
                A = randi(2);
            else
    	    	[~, A] = max(q, [], 1);
            end

	    	game.takeAction(A);
	    	% r = get(game, 'win');

            if ~p.test
    	    	E(A, ps, dc) = 1;
    	    	C(A, ps, dc) = C(A, ps, dc) + 1; % Increment the total S,A count
            end

	    end

        r = get(game, 'win');
        
        if ~p.test % Skip the Q update when test
            G(E) = r;
            R = R + G;
            idx2update = C ~= 0; % Avoid NaN
            Q(idx2update) = R(idx2update) ./ C(idx2update);
        end

        winctr = winctr + double(r > 0);
        winrate(i) = winctr / i;

        if rem(i, p.showevery) == 0
            fprintf('Episode:%d\t \tWinRate: %f\n', i, winctr / i);
            show(f1, Q, winrate(1:i));
        end

        if rem(i, p.snapshotevery) == 0
            save(sprintf('Q-Episode-%d.mat', i), 'Q', 'p', 'winrate', 'i');
        end
    end
end
