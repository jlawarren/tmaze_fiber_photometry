%% wxgeneraterandomsequence
 % Generates a random sequence for the learning period
 % JL Alatorre Warren

function sequenceOfSides = wxgeneraterandomsequence(numberOfDecisions)

% Notes about sequenceOfSides
% Column 01: randomized sequence of sides
% Column 02: flags with forced changes to avoid 4 or more consecutives
% Column 03: sides chosen by the mouse
% Column 04: correct (1) or wrong (0) choice
% Column 05: cummulative correct choices
% Column 06: current success rate
% Column 07: timestamps: start forced run (date and time)
% Column 08: timestamps: stop forced run (date and time)
% Column 09: timestamps: start free (open) run (date and time)
% Column 10: timestamps: stop free (open) run (date and time)
% Column 11: elapsed time (seconds): forced run
% Column 12: elapsed time (seconds): free run
% Column 13: elapsed time (seconds): full trial (forced run + free run)

% Create cell array sequenceOfSides
sequenceOfSides = cell(numberOfDecisions,13);

consecutiveRight = 0;
consecutiveLeft = 0;

for ii = 1:numberOfDecisions

  % Get a pseudorandom integer: 1 (right gate) or 2 (left gate)
	% Here, rng('shuffle') avoids repeting a result from a previous MATLAB session
  rng('shuffle');
  currentValue = randi(2,1);
  
  % Count number 1s or 2s in a row
  if currentValue == 1
    consecutiveRight = consecutiveRight+1;
    consecutiveLeft = 0;    
  elseif currentValue == 2
    consecutiveLeft = consecutiveLeft+1;
    consecutiveRight = 0;
  end
  
  % If the consecutive counter is greater than 3, force a change
  if consecutiveRight > 3
    currentValue = 2;
    consecutiveRight = 0;
    consecutiveLeft = consecutiveLeft + 1;
    sequenceOfSides{ii,2} = 1;
  elseif consecutiveLeft > 3
    currentValue = 1;
    consecutiveLeft = 0;
    consecutiveRight = consecutiveRight + 1;
    sequenceOfSides{ii,2} = 1;
  else
    sequenceOfSides{ii,2} = 0;
  end
  
  % Fill the vector with 'R's and 'L's
  if currentValue == 1
    sequenceOfSides{ii,1} = 'R';
  elseif currentValue == 2
    sequenceOfSides{ii,1} = 'L';
  end

end