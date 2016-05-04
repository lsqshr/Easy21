function MC(p)
    if p.plot
    	f1 = figure(1);
    end

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

		dc = get(game, 'dealerSum'); % Dealer Card
    	while true % One Round 
    		ps = get(game, 'playerSum'); % Player Sum
    		q = Q(:, int16(ps), int16(dc));
            eps = (100 / (100 + sum(C(:, int16(ps), int16(dc))))); % occurance varying eps

            if ps > 10
                disp(ps)
            end

            if rand() < eps
                A = randi(2);
            else
    	    	[~, A] = max(q, [], 1);
            end

	    	game = takeAction(game, A);
	    	r = get(game, 'win');

            if ~p.test
    	    	E(A, ps, dc) = 1;
    	    	C(A, ps, dc) = C(A, ps, dc) + 1; % Increment the total S,A count
            end

	    	if r ~= -2 % The game on-going
                if ~p.test % Skip the Q update when test
                    G(E) = r;
                    R = R + G;
                    idx2update = C ~= 0;
    		    	Q(idx2update) = R(idx2update) ./ C(idx2update);
                end

		    	winctr = winctr + double(r > 0);
		    	winrate(i) = winctr / i;
	    		break;
	    	end
	    end

        if rem(i, p.showevery) == 0
            fprintf('Episode:%d\t \tWinRate: %f\n', i, winctr / i);

            if p.plot
                clf(f1);
                subplot(2, 1, 1);
                maxQ = squeeze(max(Q, [], 1));
                surf(maxQ);

                subplot(2, 1, 2);
                plot(winrate(1:i));
                drawnow;
            end
        end

        if rem(i, p.snapshotevery) == 0
            save(sprintf('Q-Episode-%d.mat', i), 'Q', 'p', 'winrate', 'i');
        end
    end
end

function game = takeAction(game, A)
	switch A
		case 1
			game.playerHit();
		case 2
			game.playerStick();
		otherwise
	end
end