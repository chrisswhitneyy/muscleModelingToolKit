function [ x ] = OAT_Sampling( bounds, n )
% function: Generates a sampling matrix for n parameters in an one-at-a-time
% style (i.e. incremental steps)
%
% Input:
%   - bounds = { [lower bound, upper bound ], ...}
%   - n = number of samples

  for i = 1:numel(bounds)
    x(:,i) = linspace(bounds{i}(1),bounds{i}(2),n)';
  end

end  % function
