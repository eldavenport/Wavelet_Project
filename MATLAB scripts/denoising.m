
breeds = ["Beagle", "Chihuahua", "French Bulldog", "German Shepherd", "Golden Retriever", "Labrador Retriever", "Poodle", "Samoyed", "Schnauzer", "Shiba Inu", "West Highland White Terrier"]

for i = breeds
    srcBase = '/Users/isamu/Desktop/ECE251C/cropped dogs/'
    srcDir = strcat(srcBase, i)
    srcFin = strcat(srcDir,"/")

    destBase = '/Users/isamu/Desktop/ECE251C/1-D_horizontal dogs/'
    destDir = strcat(destBase, i)
    destFin = strcat(destDir,"/")

    imagefiles = dir(fullfile(srcFin,'*.jpg'));      
    nfiles = length(imagefiles);    % Number of files found
    fprintf("total %d\n", nfiles)
    mkdir(destFin) 
    index = 0;

    for ii=1:nfiles
        currentfilename = imagefiles(ii).name;
        path = strcat(srcFin,currentfilename);
        
        I = imread(path);
        % convert to grayscale
        I = rgb2gray(I);
        
        % add noise (gaussian) to image
        In = imnoise(I, 'gaussian');
        
        % choose type of thresholding (hard or soft)
        type = 'h';
        
        % apply 3-level DWT2D (for 2D images)
        [cA1, cH1, cV1, cD1] = dwt2(In, 'db1'); % level - 1
        [cA2, cH2, cV2, cD2] = dwt2(cA1, 'db1'); % level - 2
        [cA3, cH3, cV3, cD3] = dwt2(cA2, 'db1'); % level - 3
        
        %% LEVEL - 3
        % find threshold on detail components
        T_cH3 = sigthresh(cH3, 3, cH3);
        T_cV3 = sigthresh(cV3, 3, cV3);
        T_cD3 = sigthresh(cD3, 3, cD3);
        % apply threshold, these matrices are denoised before image reconstruction
        Y_cH3 = wthresh(cH3, type, T_cH3);
        Y_cV3 = wthresh(cH3, type, T_cV3);
        Y_cD3 = wthresh(cH3, type, T_cD3);
        
        %% LEVEL - 2
        % find threshold on detail components
        T_cH2 = sigthresh(cH2, 2, cH2);
        T_cV2 = sigthresh(cV2, 2, cV2);
        T_cD2 = sigthresh(cD2, 2, cD2);
        % apply threshold, these matrices are denoised before image reconstruction
        Y_cH2 = wthresh(cH2, type, T_cH2);
        Y_cV2 = wthresh(cV2, type, T_cV2);
        Y_cD2 = wthresh(cD2, type, T_cD2);
        
        %% LEVEL - 1
        % find threshold on detail components
        T_cH1 = sigthresh(cH1, 1, cH1);
        T_cV1 = sigthresh(cV1, 1, cV1);
        T_cD1 = sigthresh(cD1, 1, cD1);
        % apply threshold, these matrices are denoised before image reconstruction
        Y_cH1 = wthresh(cH1, type, T_cH1);
        Y_cV1 = wthresh(cV1, type, T_cV1);
        Y_cD1 = wthresh(cD1, type, T_cD1);
        
        % apply inverse discrete wavelet transform on all levels
        Y_cA2 = idwt2(cA3, Y_cH3, Y_cV3, Y_cD3, 'db1');
        Y_cA1 = idwt2(cA2, Y_cH2, Y_cV2, Y_cD2, 'db1');
        Y_cA = idwt2(cA1, Y_cH1, Y_cV1, Y_cD1, 'db1');

        newFileName = strcat(currentfilename(1:end-4), ".jpg");
        imwrite(uint8(Y_cA), fullfile(destFin, newFileName))
        
    end
end

%% sigthresh() method
function [T] = sigthresh(M, level, test_matrix)

C = 0.6745;
variance = (median(abs(M(:)))/C)^2;

beta = sqrt(log(length(M)/level));


T = beta*variance/std2(test_matrix);

end