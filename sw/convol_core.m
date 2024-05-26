clc
clear

%% Parameters
% Generating the signal vectors
X = 5; 
Y = 10; 
Start = 1; 
Shape = 0; % 1 for "full" 0 for "same"

S_X = randi(10,1,X);
S_Y = randi(10,1,Y);

S_X_bin = dec2hex(S_X,8);
addressX = 'C:\Dani\Doctorado\CONV_AIP\IP_MOD_CONV\simulation\modelsim\S_X.txt'; 
% filename1 = 'S_X.txt';
fileID1 = fopen(addressX, 'w');
for i = 1:numel(S_X_bin(:,1))
    fprintf(fileID1, '%s\n', S_X_bin(i,:));
end

addressY = 'C:\Dani\Doctorado\CONV_AIP\IP_MOD_CONV\simulation\modelsim\S_Y.txt'; 
S_Y_bin = dec2hex(S_Y,8);
%%filename2 = 'S_Y.txt';
fileID2 = fopen(addressY, 'w');
for i = 1:numel(S_Y_bin(:,1))
    fprintf(fileID2, '%s\n', S_Y_bin(i,:));
end

% Signal Sizes and "Full" or "Same" Conv type
SizeX = numel(S_X);
SizeY = numel(S_Y);
Sz_full = (SizeX+SizeY)-1;
Sz_same = SizeX;

% Convolution using Matlab's function - Golden Model
Conv_Full = conv(S_X,S_Y,"full");
Conv_Same = conv(S_X,S_Y,"same");

Result = 'C:\Dani\Doctorado\CONV_AIP\IP_MOD_CONV\simulation\modelsim\S_Z.txt'; 
S_Z_bin = dec2hex(Conv_Full,8);
fileID3 = fopen(Result, 'w');
for i = 1:numel(S_Z_bin(:,1))
    fprintf(fileID3, '%s\n', S_Z_bin(i,:));
end

%% Convolution Algorithm 
S_Z = zeros(1,Sz_full);
S_Z_same = zeros(1,Sz_same); 
while 1
    if Start == 1
        Z_Ind = 1;
        aux = 1;
        fprintf("Busy\n");
        for i = 1:SizeY
            for ii = 1:SizeX
                Mult = S_X(1,ii)*S_Y(1,i);
                S_Z(1,Z_Ind) = S_Z(1,Z_Ind) + Mult;
                Z_Ind = Z_Ind + 1;
                fprintf("Busy\n");
            end
            aux = aux + 1; 
            Z_Ind = aux;
            fprintf("Busy\n");
        end
        
        if Shape == 0
            ptr = ceil((SizeY+1)/2);
            fprintf("Busy\n");
            for same = 1:Sz_same
                S_Z_same(1,same) = S_Z(1,ptr);
                ptr = ptr + 1;
                fprintf("Busy\n");
            end
            break;
        end
    else
        fprintf("Busy\n");
    end
    break;
end 
fprintf("Done\n");