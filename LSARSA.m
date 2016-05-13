function [winrate, Q] = lsarsa(p)
% Sarsa Lambda with linear function approximation
	f1 = figure();

	% Count the winned rounds 
    i = 0;
    winctr = zeros(5e7, 1);	
    winrate = zeros(5e7, 1);

    Theta = zeros(2,6,3);
    game = Easy21Env();

	while true % Episodes
		if i > p.nepisode
			break;
		end

		i = i + 1;
    	game.reset(); % Start a new round
		E = zeros(size(Theta)); % Eligibility trace 
		dc = uint8(get(game, 'dealerSum')); % Dealer Card
		ps = uint8(get(game, 'playerSum')); % Player Sum
        eps = 0.05; % Constant eps

        % Get initial action
        if rand() < eps
            A = randi(2);
			F = getCoding(A, ps, dc);
        else
        	F = getCoding([1,2], ps, dc);
    		q = Theta .* F;
    		q = sum(sum(q, 3), 2);
	    	[~, A] = max(q, [], 1);
        end

        % fprintf('Initial action: %d\n', A);

    	while get(game, 'win') == -2 % One episode 
    		F = getCoding(A, ps, dc);
            E(F) = E(F) + 1; % Accumulating Trace 
	    	game.takeAction(A);
	    	r = get(game, 'win');

	    	if r == -2 % The game is on-going
	    		r = 0;
	    	end

            S = Theta(F);
            delta = r - sum(S(:));
			ps_ = uint8(get(game, 'playerSum')); % Player Sum

			if ps_ > 21 || ps_ < 1 % Terminate state
				% ps_ = 22;
				Theta = Theta + p.alpha * delta * E;
				break;
			end

        	F_ = getCoding([1,2], ps_, dc);
    		q = Theta .* F;
    		q = sum(sum(q, 3), 2);

            if rand() < eps
                A_ = randi(2);
            else
		    	[~, A_] = max(q, [], 1);
            end

			delta = delta + p.gamma * q(A_);
			Theta = Theta + p.alpha * delta * E;
	    	E = p.gamma * p.lambda * E; % Decay the elligibility trace

	    	ps = ps_;
	    	A = A_;
	    end

		winctr(i) = double(r > 0);

		if i <= 10000
			winrate(i) = 0;
		else
			winrate(i) = sum(winctr(i - 10000 : i)) / 10000;
		end

		if rem(i, p.showevery) == 0
			fprintf('Episode:%d\t \tWinRate: %f\n', i, winrate(i));
			Q = Theta;
			show(f1, Q, winrate(1:i));
		end
	end

	winrate = winrate(1:i);

end	


