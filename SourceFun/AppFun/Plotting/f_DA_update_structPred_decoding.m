function f_DA_update_structPred_decoding(app)

%% Documentation Contents
% Darik O"Neil 1-12-2022
% Function to visualize decoding performance frame by frame (structured
% prediction)

%% Function Contents

%% Initialize
%we gotta do this for this one idk why Darik 5/9/2022
cla(app.EvalModel2);
v=app.StimulusEM.Value;
params = app.params;
LL = app.FrameLikelihoodByNode(size(params.data,2)+v,:); %grab framewise likelihood
Thresh = app.completePerf.thcell{v}; %grab threshold
true_labels = params.UDF(:,v)';
newcolors = app.newcolors;

% make binary vector of LL over/under threshold
binLL = zeros(size(LL)); 
posIdx = find(LL>=Thresh);
binLL(posIdx)=1;

% preallocate indices of true pos / false neg / false pos / true neg 
% (form is label/prediction)
oneOne = [];
oneNil = [];
nilOne = [];
nilNil = [];

%% Find Indices
    for i = 1:length(true_labels)
        if (true_labels(i)==1)
            switch binLL(i)
                case 0
                    oneNil = [oneNil i];
                case 1
                    oneOne = [oneOne i];
            end
        else
            switch binLL(i)
                case 0
                    nilNil = [nilNil i];
                case 1
                    nilOne = [nilOne i];
            end
        end
    end
    
% Grab Indexed Values    
oneOne_LL = LL(oneOne);
oneNil_LL = LL(oneNil);
nilOne_LL = LL(nilOne);
nilNil_LL = LL(nilNil);

% Arrange the indexed values
[~,oneOne_I] = maxk(oneOne_LL,length(oneOne_LL));
[~,oneNil_I] = maxk(oneNil_LL,length(oneNil_LL));
[~,nilOne_I] = maxk(nilOne_LL,length(nilOne_LL));
[~,nilNil_I] = maxk(nilNil_LL,length(nilNil_LL));

% Compile
LLC = [oneOne_LL(oneOne_I) oneNil_LL(oneNil_I) nilOne_LL(nilOne_I) nilNil_LL(nilNil_I)];

%% Visualize

% formulate X-axis vector
X=1:length(LL);
% fine min/max for plotting
a = max(LL);
b = min(LL);
% Index highlights adjustments
startIdx = 1;
endAdj = 0;

% plot standard
line(app.EvalModel2,[1 length(LLC)],[Thresh Thresh], 'LineStyle','--','color','k','LineWidth',1);
hold(app.EvalModel2,'on');
area(app.EvalModel2,X,LLC,b,'FaceColor',[0.85,0.80,0.92], 'EdgeColor',[0.47 0.25 0.8],'FaceAlpha',1,'LineWidth',2,'EdgeAlpha',1);
line(app.EvalModel2,[1 length(LLC)],[Thresh Thresh], 'LineStyle','--','color','k','LineWidth',1);

% Plot Highlights

% Plot true pos highlights
LabelTP = ones(size(LL)).*b;
LabelTP((startIdx:(length(oneOne_LL))))=a;
area(app.EvalModel2,X,LabelTP,b,'FaceAlpha',0.25,'FaceColor', newcolors(4,:),'EdgeColor',newcolors(4,:),'EdgeAlpha',0);
line(app.EvalModel2,[startIdx startIdx],[b a], 'color','k','LineStyle','--','LineWidth',1);
startIdx = startIdx+length(oneOne_LL); 
endAdj = startIdx-1;
app.TruePositiveEditField_Decoding.FontColor = newcolors(4,:);

% Plot false neg highlights
LabelFN = ones(size(LL)).*b;
LabelFN(startIdx:(endAdj+length(oneNil_LL)))=a;
area(app.EvalModel2,X,LabelFN,b,'FaceAlpha',0.25,'FaceColor',newcolors(5,:),'EdgeColor',newcolors(5,:),'EdgeAlpha',0);
line(app.EvalModel2,[startIdx startIdx],[b a], 'color','k','LineStyle','--','LineWidth',1);
startIdx = startIdx+length(oneNil_LL);
endAdj = startIdx-1;
app.FalseNegativeEditField_Decoding.FontColor = newcolors(5,:);

% Plot false pos highlights
LabelFP = ones(size(LL)).*b;
LabelFP(startIdx:(endAdj+length(nilOne_LL)))=a;
area(app.EvalModel2,X,LabelFP,b,'FaceAlpha',0.25,'FaceColor',newcolors(3,:),'EdgeColor',newcolors(3,:),'EdgeAlpha',0);
line(app.EvalModel2,[startIdx startIdx],[b a], 'color','k','LineStyle','--','LineWidth',1);
startIdx = startIdx+length(nilOne_LL);
endAdj=startIdx-1;
app.FalsePositiveEditField_Decoding.FontColor = newcolors(3,:);

% Plot true neg highlights
LabelTN = ones(size(LL)).*b;
LabelTN(startIdx:(endAdj+length(nilNil_LL)))=a;
area(app.EvalModel2,X,LabelTN,b,'FaceAlpha',0.25,'FaceColor',newcolors(2,:),'EdgeColor',newcolors(2,:),'EdgeAlpha',0);
line(app.EvalModel2,[startIdx startIdx],[b a], 'color','k','LineStyle','--','LineWidth',1);
app.TrueNegativeEditField_Decoding.FontColor = newcolors(2,:);

hold(app.EvalModel2,'off');
app.EvalModel2.XLabel.String='Frame # (Sorted TP-FN-FP-TN)';
app.EvalModel2.YLabel.String='Log-Likelihood Ratio';
app.EvalModel2.Title.String='Structured Prediction Visualized';

axis(app.EvalModel2,'tight');

%grab and flip children
chi = get(app.EvalModel2,'Children');
set(app.EvalModel2,'Children',flipud(chi));

% Set Font Color

end

