function makeFigurePanels
% makeFigurePanels uses the simulated data to reproduce the panels used in
% the paper
% 
% Chen Chen

warning('off', 'MATLAB:MKDIR:DirectoryExists');
%% Specify Target Figure to Plot (Change this as needed)
% Target figure panel
%    Choose one of the following:
%       'fig1'   -  panels for figure 1
%       'fig2'   -  panels for figure 2
%       'fig3'   -  panels for figure 3, note that the EIH simulation data
%                   is shared for figure 2 and the function will try to
%                   copy them over from figure 2 data folders. Make sure
%                   you have simulated figure 2 before using 
%                   USE_PREV_DATASET = 0
%      'sm-fig1' -  panels for supplement figure 1, note that the EIH 
%                   simulation and behavioral data for electric fish and 
%                   rat are taken from figure 2 and the function will try 
%                   to copy them over from figure 2 data folders. Make sure 
%                   you have simulated figure 2 before using 
%                   USE_PREV_DATASET = 0
%      'sm-fig2' -  panels for supplement figure 2
%      'sm-fig3' -  panels for supplement figure 3, note that the EIH 
%                   simulation for figure 2 is required to use
%                   USE_PREV_DATASET = 0
%      'sm-fig4' -  panels for supplement figure 4
%      'sm-fig5' -  panels for supplement figure 5
%      'sm-fig6' -  panels for supplement figure 6. Note that this figure 
%                   does not require any simulation data and therefore
%                   USE_PREV_DATASET will be ignored
% 
targetFig = 'sm-fig4';

% Choose whether or not to use previously simulated dataset
% Use
%   USE_PREV_DATASET = 1; % if local simulation step is skipped
%   USE_PREV_DATASET = 0; % if local simulation is done
USE_PREV_DATASET = 1;

%% Internal parameters (do not change)
if USE_PREV_DATASET
    DATA_PATH = './FigureCode/';
    FIG_DATA_PATH = sprintf([DATA_PATH,'%s/Data/'], targetFig);
else
    DATA_PATH = '../SimulationCode/SimData/';
    FIG_DATA_PATH = sprintf([DATA_PATH,'%s/'], targetFig);
end
FIG_OUTPUT_PATH = sprintf('./FigureOutput/%s/', targetFig);
FIG_CODE_PATH = sprintf('./FigureCode/%s/', targetFig);

%% Make production figure panels (do not change)
addpath(FIG_CODE_PATH);
mkdir(FIG_OUTPUT_PATH);
switch targetFig
    case 'fig1'
        makeFig1Plot(FIG_DATA_PATH, FIG_OUTPUT_PATH);
    case 'fig2'
        makeFig2Plots(FIG_DATA_PATH, FIG_OUTPUT_PATH);
    case 'fig3'
        if ~USE_PREV_DATASET
            mkdir(FIG_DATA_PATH);
            cpySimDataFiles('../SimulationCode/SimData/fig2/*ElectricFish*', ...
                FIG_DATA_PATH);
            cpySimDataFiles('../SimulationCode/SimData/fig2/*Mole*', ...
                FIG_DATA_PATH);
        end
        makeFig3Plot(FIG_DATA_PATH, FIG_OUTPUT_PATH);
    case 'sm-fig1'
        if ~USE_PREV_DATASET
            mkdir(FIG_DATA_PATH);
            cpySimDataFiles('../SimulationCode/SimData/fig2/*ElectricFish*', ...
                FIG_DATA_PATH);
            cpySimDataFiles('../SimulationCode/SimData/fig2/*Rat*', ...
                FIG_DATA_PATH);
        end
        makeSMFig1Plot(FIG_DATA_PATH, FIG_OUTPUT_PATH);
    case 'sm-fig2'
        makeSMFig2Plot(FIG_DATA_PATH, FIG_OUTPUT_PATH, USE_PREV_DATASET);
    case 'sm-fig3'
        if ~USE_PREV_DATASET
            mkdir(FIG_DATA_PATH);
            cpySimDataFiles('../SimulationCode/SimData/fig2/fig2-ErgodicHarvest-ElectricFish-SNR-30*', ...
                FIG_DATA_PATH);
        end
        makeSMFig3Plots(FIG_DATA_PATH, FIG_OUTPUT_PATH);
    case 'sm-fig4'
        makeSMFig4Plot(FIG_DATA_PATH, FIG_OUTPUT_PATH);
    case 'sm-fig5'
        makeSMFig5Plot(FIG_DATA_PATH, FIG_OUTPUT_PATH);
    case 'sm-fig6'
        makeSMFig6Plot(FIG_OUTPUT_PATH);
    otherwise
        error('Target figure not found!');
end

function cpySimDataFiles(srcPattern, dstDir)
fileList = dir(srcPattern);
if isempty(fileList)
    error('No matching data found, have you chosen the right parameters?');
end
for i = 1:length(fileList)
    copyfile(fullfile(fileList(i).folder,fileList(i).name), ...
        fullfile(dstDir, fileList(i).name));
end