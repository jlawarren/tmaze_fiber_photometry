%% wxrecordsignals
 % Display Ca 2+ and licking signals using the National Instruments USB-6218 device
 % JL Alatorre-Warren
 
%% Initial setup

% Get relevant information from wxtmaze
[ pathRoot,...
 pathData,...
 pathRois,...
 pathTrials,...
 pathTrialList,...
 structureOfTrials,...
 listOfTrials,...
 trialName,...
 pathCurrentTrial,...
 mouseName,...
 experimentName,...
 timestampVector,...
 dateString,...
 timeString] = wxlistentowxtmaze;

% Get the rest of the information
[~,...
 ~,...
 ~,...
 ~,...
 ~,...
 ~,...
 pathMouseName,...
 pathDateString,...
 pathExperimentName,...
 pathTimeString,...
 pathFlags,...
 pathSignals,...
 pathFrames] = wxcreatedirectories(timestampVector,... 
                                   mouseName,...
                                   dateString,...
                                   experimentName,...
                                   timeString);
                                  
% Send flag to wxtmaze
flagRecordSignalsReady = true;
save([pathFlags '/' 'flagrecordsignalsready.mat'], 'flagRecordSignalsReady');

%% Record signals
%  National Instruments DAQ (Multifunction Data Acquisition)
%  National Instruments USB-6218

% Setup DAQ session
[daqDevice, daqSession] = wxnibox6218;
daqSession.IsContinuous = 0;
daqSession.DurationInSeconds = 60*60;
listenerObject = addlistener(daqSession,'DataAvailable',@(src,event)wxwritesignals(src,event,pathSignals));

% Start DAQ session on the background
startBackground(daqSession)

% Chill out until flag sent from wxtmaze is found
flagFound = false;
while flagFound == false
  
  % Just wait a bit
  pause(3)
  
  % Search flag and break the loop if found
  flagSequenceCompleted = exist([pathFlags '/' 'flagsequencecompleted.mat'],'file');  
  if (flagSequenceCompleted == 2)
    flagFound = true;
  end
  
end

% Stop DAQ session
stop(daqSession)

% Just wait a bit
pause(1)

% Close MATLAB session
exit