function f_DA_preview_all_struct(app)


%% First find structures for all sLambda

tempParams = app.params;
numSLambda = length(tempParams.s_lambda_sequence_LASSO);

wb = CmdLineProgressBar('Learning All Structures'); %feedback
fprintf('\n');

tempParams.rawCoef = cell(1,numSLambda);
tempParams.learned_structures = cell(1, numSLambda);
tempParams.s_lambda_sequence = tempParams.s_lambda_sequence_LASSO;
for i = 1:numSLambda
    [tempParams.rawCoef{i}] = learn_structures(tempParams,tempParams.s_lambda_sequence_LASSO(i)); %learn structures at each s_lambda
    tempParams.learned_structures{i} = processStructure(tempParams.rawCoef{i},tempParams.density,tempParams.absolute); %binarize
    wb.print(i,numSLambda); %feedback update
end

% create needs, form this way because easiest to write, could be refactored
% later
models = pre_allocate_models(tempParams);
numModels = length(models);
%collect stats on passed structures

% find the unique structures
sLambdas = nan(1,numModels);
for i = 1:length(models)
    sLambdas(i) = models{i}.s_lambda;
end
%[uval,uidx] = sort(unique(sLambdas), 'ascend');
[uval,uidx] = unique(sLambdas);

%for unique structures find max, mean, median, rms, complexity
Lunique = length(uidx);
maxD = nan(1,Lunique);
meanD = nan(1,Lunique);
medianD = nan(1,Lunique);
rmsD = nan(1,Lunique);
complexityD = nan(1,Lunique);
for i = 1:Lunique
    maxD(i) = models{uidx(i)}.max_degree;
    meanD(i) = models{uidx(i)}.mean_degree;
    medianD(i) = models{uidx(i)}.median_degree;
    rmsD(i) = models{uidx(i)}.rms_degree;
    complexityD(i) = sum(sum(models{uidx(i)}.structure));
end

f_DA_plot_degree_dist(app, uval, maxD, meanD, medianD, rmsD, complexityD);

end
