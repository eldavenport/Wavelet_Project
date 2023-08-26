breeds = ["Beagle", "Chihuahua", "French Bulldog", "German Shepherd", "Golden Retriever", "Labrador Retriever", "Poodle", "Samoyed", "Schnauzer", "Shiba Inu", "West Highland White Terrier"];

for i = breeds
    srcBase = '/home/ellen/Documents/Courses/ECE251C/Project/dogs/';
    srcDir = strcat(srcBase, i);
    srcFin = strcat(srcDir,"/");

    destBase = '/home/ellen/Documents/Courses/ECE251C/Project/Gaus_2_dogs_1/';
    destDir = strcat(destBase, i);
    destFin = strcat(destDir,"/");

    imagefiles = dir(fullfile(srcFin,'*.jpg'));      
    nfiles = length(imagefiles);    % Number of files found
    fprintf("total %d\n", nfiles)
    mkdir(destFin) 
    wavelet_type = 'gaus2';
    
    % loop through the files within the dog breed class
    index = 0;
    for ii=1:nfiles
       currentfilename = imagefiles(ii).name;
       path = strcat(srcFin,currentfilename);
    
       I = imread(path);
%        colormap gray

       I = double(I);
       Xrgb  = 0.2990*I(:,:,1) + 0.5870*I(:,:,2) + 0.1140*I(:,:,3); 
       NbColors = 255; 
       X = wcodemat(Xrgb,NbColors);
        
       map = pink(NbColors);
       colormap(map)
    
       [c,s]=wavedec2(X,4,wavelet_type);
    
       [H1,V1,D1] = detcoef2('all',c,s,1);
       A1 = appcoef2(c,s,wavelet_type,1);
        
       V1img = wcodemat(V1,255,'mat',1);
       H1img = wcodemat(H1,255,'mat',1);
       D1img = wcodemat(D1,255,'mat',1);
       A1img = wcodemat(A1,255,'mat',1);

       image(A1img)
       
       fprintf("%s\n", destFin);
       fprintf("%s\n", currentfilename);
       newFileName = strcat(currentfilename(1:end-4), ".png");
       imwrite(A1img, map, fullfile(destFin, newFileName))
    end
end
