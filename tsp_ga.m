%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimate an optimal path plan for UAV across the given number of points in 2D/3D space
%Kshitij Goel (13AE10013) - Intelligent Control Term Project
%Autumn Semester - 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Travelling Salesman Problem:
%     1. Salesman travels to each of the cities and completes the
%        route by returning to the city he started from
%     2. Each city is visited by the salesman exactly once
%     3. Cities are assigned random coordinates. No. of cities are user
%     input.
%%
function varargout = tsp_ga(varargin)
    close all;
    %Opening Data Files
    selectPoints = fopen('points.txt', 'w+');
    datafile = fopen('optimPath.txt', 'w+');
    %I/O starts here. ::
    % Initialize default configuration structure
    xy          = 100*rand(40,2); %first arg - No. of points , second arg - no. of dimensions.
    dmat        = []; %Distance Matrix between every pair of random points selected.
    popSize     = 100;
    numIter     = 1e4;
    showProg    = true;
    showResult  = true;
    formatSpec = '\n%f \t  %f';
    fprintf(selectPoints, ':::::::selected points in the analysis::::::');
    fprintf(selectPoints,formatSpec, xy);
    resultStruct = genetic_tsp(xy, dmat, popSize, numIter, showProg, showResult);
    if nargout        
        varargout = {resultStruct};
    end
    formatSpec = '\n%f';
    opt_path = resultStruct.optRoute;
    fprintf(datafile,'::::: Optimal Path is given by the following sequence :::::');
    k = size(opt_path');
    for idx = 1:1:k
       fprintf(datafile,formatSpec,opt_path(idx));
    end
end