% Script for the calibration of the optical tweezers setup 
% via histogram of positions
% IMPORTANT: With octave 4.0 it is need to update Forge packages 'strut' and 'optim'
% in Octave command window: 
% pkg install -forge struct
% pkg install -forge optim
clear all;

%This method of loading files works for every OS
%System-dependent character used to separate directory names. 
sep = filesep();

mkdir('output');

%Graphics in gnuplot
if (isOctave)
  graphics_toolkit ('gnuplot');
end;

% Temperature in Celsius
T= 21;

%IMPORTANT: Estimated value for the trap stiffness
%water, from PFMCal_auto
ksti = 6.29*1e-6;
%acetone, from PFMCal_auto
%ksti = 6.06*1e-6;

%Load water data
path = strcat('.',sep,'Testdata',sep,'water',sep);
histofile = 'HISTO_X_01_H2O_Res_1.88um_ND2_2MHz.txt';
%Or load acetone data
%path = strcat('.',sep,'data_250313',sep,'acetone',sep);
%histofile = 'HISTO_X_13_Acet_Res_1.88um_ND2_2MHz.txt';

histo = datawithoutheader(strcat(path,histofile));


%%%%%%%%%%%%%%%%%%%%%%
% Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%
calculateCalibrationHisto(T,ksti,histo);



