game = Easy21Env();

while true % Rounds
    game.reset();

    % Show Hands
    disp('==============================')
    disp('==============================')

    disp('Your Initial Cards');
    disp(get(game, 'playerCards'))
    disp('My Initial Cards');
    disp(get(game, 'dealerCards'))

    while true % Player hit loop
		prompt = 'Hit (H) or Stick (S)? ';
		A = input(prompt, 's');
		switch A
			case 'h' 
				disp('Player Hit!')
				game.playerHit();
				disp('********************')

				if get(game, 'playerBust')
					disp('Bust! Sucker');
					win = -1;
					break;
				end
				
			    disp('Your Sum:');
			    disp(get(game, 'playerSum'))
			case 's' 
				disp('You Stick!')
				game.playerStick();
				win = get(game, 'win')
				break;

			otherwise
		end
	end


	disp('******Summery**********')
    disp('Your Sum:');
    disp(get(game, 'playerSum'))
    disp('***********************')
    disp('My Sum:')
	disp(get(game, 'dealerSum'))

	if win == 1
		disp('You woooooon! You lucky bitch!')
	elseif win == 0
		disp('We draw!')
	else
		disp('You Looooost! Sucker!')
	end

	input('Press Any Key to Continue', 's');
end