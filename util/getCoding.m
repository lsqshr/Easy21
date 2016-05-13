function F = getCoding(A, ps, dc)
   F = logical(ones(2, 6, 3)); 
   dcidx = zeros(3,1);
   Aidx = zeros(2,1);
   Aidx(A) = 1;
   if dc >=1 && dc <=4
	   dcidx(1) = 1;
   end
    
   if dc >=4 && dc <=7
	   dcidx(2) = 1;
   end

   if dc >=7 && dc <=10
	   dcidx(3) = 1;
   end

   psidx = zeros(6, 1);
   if ps >=1 && ps <=6
	   psidx(1) = 1;
   end

   if ps >=4 && ps <=9
	   psidx(2) = 1;
   end

   if ps >=7 && ps <=12
	   psidx(3) = 1;
   end

   if ps >=10 && ps <=15
	   psidx(4) = 1;
   end

   if ps >=13 && ps <=18
	   psidx(5) = 1;
   end

   if ps >=16 && ps <=21
	   psidx(6) = 1;
   end

   F(:, :, ~dcidx) = 0;
   F(:, ~psidx, :) = 0;
   F(~Aidx,:,:) = 0;

end