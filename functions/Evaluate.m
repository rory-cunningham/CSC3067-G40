function [ tPos, tNeg, fPos, fNeg ] = Evaluate(Objects, TestAnswers, windowCount, marginPercent)

TestAnswers = cell2mat(TestAnswers.');

% Set the TP counter.
tPos = 0;

% Calculate TP
for i=1:1:size(Objects,1)
        horizontalMargin = Objects(i,3) * marginPercent / 100;
        verticalMargin = Objects(i,4) * marginPercent / 100;
        
        O = repmat(Objects(i,1:4), size(TestAnswers, 1), 1);
        
        withinVerticalMargin = TestAnswers(:,2)-verticalMargin < O(:,2) & O(:,2) < TestAnswers(:,2)+verticalMargin;
        withinHorizontalMargin = TestAnswers(:,1)-horizontalMargin < O(:,1) & O(:,1) < TestAnswers(:,1)+horizontalMargin;
        
        matchFound = withinVerticalMargin & withinHorizontalMargin;
        tPos = tPos + any(matchFound);
end

% Calculate the false positives.
fPos = size(Objects, 1) - tPos;

% Calculate the false negatives.
fNeg = size(TestAnswers, 1) - tPos;

% Calculate the true negatives.
tNeg = windowCount - tPos - fPos - fNeg;

end