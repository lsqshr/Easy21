classdef Easy21Env < matlab.mixin.SetGet
    properties
        playerSum
        dealerSum
        playerCards
        dealerCards
        playerBust
        dealerBust
        win = -2;
	end

    methods
        function obj = reset(obj)
        	% At the begining, player and dealer both draw a black card (positive)
        	obj.playerSum = obj.drawCard(true);
        	obj.dealerSum = obj.drawCard(true);
    		obj.playerCards = [obj.playerSum];
    		obj.dealerCards = [obj.dealerSum];

        end

        function obj = playerHit(obj)
        	card = obj.drawCard(false);
        	obj.playerSum = obj.playerSum + card;
        	obj.playerCards = [obj.playerCards; card];
        	obj.playerBust = obj.isBust(obj.playerSum);

        	if obj.playerBust
        		obj.win = -1;
        	end
        end

    	function obj = playerStick(obj)
    	    % Return: 1 win; 0 draw; -1 lost;
    		% The playerSum no longer changes
    		% The dealer keeps hitting until dealer bust or dealerSum > 17
    		while obj.dealerSum < 17
    			obj.dealerHit();

    			if obj.dealerBust
                    obj.win = 1;
                    return
    			end
    		end
            
            % The dealer did not bust, then we compare the sum
            if obj.playerSum > obj.dealerSum
            	obj.win = 1;
            elseif obj.playerSum == obj.dealerSum
            	obj.win = 0;
            else
            	obj.win = -1;
            end
    	end
	end

	methods (Access = private)
        function obj = dealerHit(obj)
        	card = drawCard(obj, false);
    		obj.dealerSum = obj.dealerSum + card;
    		obj.dealerCards = [obj.dealerCards; card];
    		obj.dealerBust = obj.isBust(obj.dealerSum);
        end

        function c = drawCard(obj, black)
        	c = randi(10);

        	if rand() < 1.0 / 3.0
        		c = -c;
        	end

        	if black
        		c = abs(c);
        	end
        end

        function bust = isBust(obj, cardsum)
        	if cardsum > 21 || cardsum < 1
        		bust = true;
        	else
        		bust = false;
        	end
        end
	end
end