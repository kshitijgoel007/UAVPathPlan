function resultStruct = genetic_tsp(xy, dmat, popSize, numIter, showProg, showResult)
%% Genetic Algorithm starts here ::   
    %Condition imposed when dmat : if cost matrix, is empty
    if isempty(dmat)
        nPoints = size(xy,1);
        a = meshgrid(1:nPoints); %Generation of mesh grid in the dmat matrix
        dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),nPoints,nPoints); %%Distances calculated and substituted in the dmat matrix
    end
    
    % Verify Inputs
    [N,dims] = size(xy);
    [nr,nc] = size(dmat);
    if N ~= nr || N ~= nc
        error('Invalid XY or DMAT inputs!')
    end
    n = N;
    disp (dims);
    
    popSize     = 4*ceil(popSize/4);
    numIter     = max(1,round(real(numIter(1))));
    showProg    = logical(showProg(1));
    showResult  = logical(showResult(1));
    
    % Initialize the Population by random permutations
    pop = zeros(popSize,n); %Initialized all to zero
    pop(1,:) = (1:n); %1st row assigned the no. 1 to n
    for k = 2:popSize
        pop(k,:) = randperm(n); % Rest of the rows assigned random permutations
    end
    
    % Run the GA by defining the following parameters
    globalMin = Inf; %Defined a global Min dummy variable
    totalDist = zeros(1,popSize); %Total distance of a path initialized
    distHistory = zeros(1,numIter); % Array for maintaining the history of distance calcucalated
    tmpPop = zeros(4,n); %Temporary population
    newPop = zeros(popSize,n); %Next generation
    
    %% VISUALIZATION
    % To see the evolution of the algorithm in animation ::
    if showProg
        figure('Name','TSP_GA | Current Best Solution','Numbertitle','off');
        hAx = gca; %Current Axes Handle
    end
    %% GENETIC ALGORITHM LOOP
    %Generation loop starts here [Operators and Generations get updated here] ::
    for iter = 1:numIter %numIter defined by the user
        for p = 1:popSize
       % Evaluate Each Population Member (Calculate Total Distance) =
       % Fitness Value
            d = dmat(pop(p,n),pop(p,1)); % Closed Path
            for k = 2:n
                d = d + dmat(pop(p,k-1),pop(p,k));
            end
            totalDist(p) = d; %Total Distance through popSize candidate paths is calculated and stored in totalDist array
        end
        
        %Optimal Path Calculation starts here::
        [minDist,index] = min(totalDist); %Minima of the popSize no. of candidate solutions calculated above is taken out.
        distHistory(iter) = minDist; %distHistory updated with the current minima at iteration "iter".
        if minDist < globalMin %globalMin : Minima in all the "iter" that have gone over till now.
            globalMin = minDist; 
            optRoute = pop(index,:); %pop out the route corresponding to minDist in the current 
            if showProg
                % Plot the Best Route
                rte = optRoute([1:n 1]);
                if dims > 2, plot3(hAx,xy(rte,1),xy(rte,2),xy(rte,3),'r.-');
                else plot(hAx,xy(rte,1),xy(rte,2),'b.-'); 
                end
                title(hAx,sprintf('Total Distance = %1.4f, Iteration = %d',minDist,iter));
                drawnow;
            end
        end
        
        % Genetic Algorithm Operators
        randomOrder = randperm(popSize);
        for p = 4:4:popSize %This is why popSize should be divisible by 4
            rtes = pop(randomOrder(p-3:p),:); %routes
            dists = totalDist(randomOrder(p-3:p)); %distances corresponding to the routes
            %Find the best route out of 4.
            [ignore,idx] = min(dists); %#ok
            bestOf4Route = rtes(idx,:);
            routeInsertionPoints = sort(ceil(n*rand(1,2)));
            I = routeInsertionPoints(1);
            J = routeInsertionPoints(2);
            for k = 1:4 % Mutate the Best to get Three New Routes
                tmpPop(k,:) = bestOf4Route;
                switch k
                    case 2 % Flip
                        tmpPop(k,I:J) = tmpPop(k,J:-1:I);
                    case 3 % Swap
                        tmpPop(k,[I J]) = tmpPop(k,[J I]);
                    case 4 % Slide
                        tmpPop(k,I:J) = tmpPop(k,[I+1:J I]);
                    otherwise % Do Nothing
                end
            end
            newPop(p-3:p,:) = tmpPop;
        end
        pop = newPop;
    end
%%  PLOTTING  
    if showResult
        % Plots the GA Results
        figure('Name','TSP_GA | Results','Numbertitle','off');
        subplot(2,2,1);
        pclr = ~get(0,'DefaultAxesColor');
        if dims > 2, plot3(xy(:,1),xy(:,2),xy(:,3),'.','Color',pclr);
        else plot(xy(:,1),xy(:,2),'.','Color',pclr); end
        title('City Locations');
        subplot(2,2,3);
        rte = optRoute([1:n 1]);
        if dims > 2, plot3(xy(rte,1),xy(rte,2),xy(rte,3),'r.-');
        else plot(xy(rte,1),xy(rte,2),'r.-'); end
        title(sprintf('Total Distance = %1.4f',minDist));
        subplot(2,2,4);
        plot(distHistory,'b','LineWidth',2);
        title('Best Solution History');
        set(gca,'XLim',[0 numIter+1],'YLim',[0 1.1*max([1 distHistory])]);
    end
    
    % Return Output
        resultStruct = struct( ...
            'xy',          xy, ...
            'dmat',        dmat, ...
            'popSize',     popSize, ...
            'numIter',     numIter, ...
            'showProg',    showProg, ...
            'showResult',  showResult, ...
            'optRoute',    optRoute, ...
            'minDist',     minDist);  
end