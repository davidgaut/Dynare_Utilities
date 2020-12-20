function fig = fisubplot(Mat,varargin)

[~,n] = size(Mat);

if ~isempty(varargin)
    Names = varargin{1};
else
    Names = num2cell(1:n);
end

m = ceil((n/3)); r = 3;
fig = figure;
for p = 1 : n
    subplot(m,r,p);
    plot(Mat(:,p)); hold on; title((Names(p)))
    grid on
    axis tight
% 	hline(0)
end
