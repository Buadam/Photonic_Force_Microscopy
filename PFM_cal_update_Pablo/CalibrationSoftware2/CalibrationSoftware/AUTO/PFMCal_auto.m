% Script for the calibration of the optical tweezers setup 
% via the Velocity-Autocorrelation.
clear all;

%This method of loading files works for every OS
%System-dependent character used to separate directory names. 
sep = filesep();

mkdir('output');

%Graphics in gnuplot
if (isOctave)
  graphics_toolkit ('gnuplot');
  %graphics_toolkit ('fltk');
end;

% Temperature in Celsius
T= 21;

%% Using particle radius instead of eta (m)
a=(1.88/2.0)*1e-6;

% Density of the particle (gr/cm^3)
rhop = 1570;
% Density of the fluid (gr/cm^3)
rhof = 1000;
rho = [rhop rhof];

%Load water data
path = strcat('.',sep,'Testdata',sep,'water',sep);
msdfile = 'BIN_MSD_X_01_H2O_Res_1.88um_ND2_2MHz.txt';
vaffile = 'BIN_VAF_X_01_H2O_Res_1.88um_ND2_2MHz.txt';
psdfile = 'BIN_PSD_X_01_H2O_Res_1.88um_ND2_2MHz.txt';
%Or load acetone data
%path = strcat('.',sep,'Testdata',sep,'acetone',sep);
%msdfile = 'BIN_MSD_X_13_Acet_Res_1.88um_ND2_2MHz.txt';
%vaffile = 'BIN_VAF_X_13_Acet_Res_1.88um_ND2_2MHz.txt';
%psdfile = 'BIN_PSD_X_13_Acet_Res_1.88um_ND2_2MHz.txt';

msd = datawithoutheader(strcat(path,msdfile));
vaf = datawithoutheader(strcat(path,vaffile));
psd = datawithoutheader(strcat(path,psdfile));

%Calibrates. Only needs to identify where noise begins in graph
calculateCalibration(a,T,rho,msd,vaf,psd);





