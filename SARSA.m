function [winrate, Q] = SARSA(p)
	f1 = figure();
	Q = zeros(2, 22, 10); % Value Function
	                      % The 22th player state is terminal

	% Count the winned rounds 
    winctr = 0;	
    winrate = zeros(5e7, 1);
    i = 0;

	C = zeros(size(Q)); % Counter of the S,A pair amoung episodes
    game = Easy21Env();
	while true % Episodes
		if i > p.nepisode
			break;
		end

		i = i + 1;
    	game.reset(); % Start a new round

		E = zeros(size(Q)); % Eligibility trace 
		dc = uint8(get(game, 'dealerSum')); % Dealer Card
		ps = uint8(get(game, 'playerSum')); % Player Sum
        eps = (100 / (100 + sum(C(:, ps, dc)))); % Occurance varying eps

        if rand() < eps
            A = randi(2);
        else
    		q = Q(:, ps, dc);
	    	[~, A] = max(q, [], 1);
        end

        eDelta = [];

    	while get(game, 'win') == -2 % One episode 
            eps = (100 / (100 + sum(C(:, ps, dc)))); % Occurance varying eps
	    	game.takeAction(A);
	    	r = get(game, 'win');
	    	C(A, ps, dc) = C(A, ps, dc) + 1; % Increment the total S,A count

	    	if r == -2 % The game is on-going
	    		r = 0;
	    	end

			ps_ = uint8(get(game, 'playerSum')); % Player Sum

			if ps_ > 21 || ps_ < 1 % Terminate state
				ps_ = 22;
			end

            if rand() < eps
                A_ = randi(2);
            else
	    		q = Q(:, ps_, dc);
    	    	[~, A_] = max(q, [], 1);
            end

            delta = r + p.gamma * Q(A_, ps_, dc) - Q(A, ps, dc);
            eDelta = [eDelta, delta];
            alpha = 1 / C(A, ps, dc);
            E(A, ps, dc) = (1 - alpha) * E(A, ps, dc) + 1;

            % idx2update = E ~= 0;
	    	Q = Q + alpha * delta * E;
	    	E = p.gamma * p.lambda * E;

	    	ps = ps_;
	    	A = A_;
	    end

	    eDelta = eDelta .^ 2;
	    eDelta = sum(eDelta(:));
	    eDelta = eDelta ^ 0.5;

		winctr = winctr + double(r > 0);
		winrate(i) = winctr / i;
		if rem(i, p.showevery) == 0
			fprintf('Episode:%d\t \tWinRate: %f\n', i, winctr / i);
			show(f1, Q, winrate(1:i));
		end
	end

	winrate = winrate(1:i);

end	