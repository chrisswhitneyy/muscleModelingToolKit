function [normEMG] = RawEMGNormalizer(SignalIn)
%%EMGNormalizer: This function converts a raw EMG signal to percentage of
% activation coeficent between 0-1. This is accomplished by:
% 1. A Butterworth band filter 20hz to 380hz
% 2. Rectifying the signal
% 3. A low pass filter at 10hz
% 4. A moving average with a window set with the parameter "wndw"
% 5. Normalizes by the max value
% 6. Subtracting the min signal to zero
%
% Author: Christopher D. Whitney (chris@northerncomputing.io)
% Last Modified: Aug. 1st 2019

  %% PARAMETERS
  wndw = 600; % Window for the moving average
  sampleFrequency = 5000; % Sample frequency of SignalIn
  beginAt = 50; % Number of samples cut from the begin of the signal

  % Sets up output vector
  Size = length(SignalIn);
  normEMG = zeros(Size,1);

  % Butterworth band filter 20hz to 380hz
  [bb,aa]=butter(4,[20/(sampleFrequency/2) 380/(sampleFrequency/2)]);
  normEMG=filtfilt(bb,aa,SignalIn);

  % Rectify signal
  abs_data=abs(normEMG);

  % Low pass Butterworth at 10hz
  [bbb,aaa]=butter(4,10/(sampleFrequency/2),'low');
  normEMG=filtfilt(bbb,aaa,abs_data);

  % Moving average
  normEMG = filtfilt(ones(wndw,1)/wndw, 1, normEMG);

  % Normalizes by the max value
  peak = max( normEMG(beginAt:end) );
  normEMG = normEMG ./ peak;

  % Subtracting the min signal to zero
  normEMG = normEMG - min(normEMG);

end
