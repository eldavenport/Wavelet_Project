breeds = ["Beagle", "Chihuahua", "French Bulldog", "German Shepherd", "Golden Retriever", "Labrador Retriever", "Poodle", "Samoyed", "Schnauzer", "Shiba Inu", "West Highland White Terrier"];

for i = breeds
    srcBase = '/home/ellen/Documents/Courses/ECE251C/Project/dogs/';
    srcDir = strcat(srcBase, i);
    srcFin = strcat(srcDir,"/");

    destBase = '/home/ellen/Documents/Courses/ECE251C/Project/Wavelet_packet_test_db2_v2/';
    destDir = strcat(destBase, i);
    destFin = strcat(destDir,"/");

    imagefiles = dir(fullfile(srcFin,'*.jpg'));      
    nfiles = length(imagefiles);    % Number of files found
    fprintf("total %d\n", nfiles)
    mkdir(destFin) 
    wavelet_type = 'db2';
    
    % loop through the files within the dog breed class
    index = 0;
    for ii=1:nfiles
       currentfilename = imagefiles(ii).name;
       path = strcat(srcFin,currentfilename);
    
       I = imread(path);

       I = double(I);
       Xrgb  = 0.2990*I(:,:,1) + 0.5870*I(:,:,2) + 0.1140*I(:,:,3); 
       NbColors = 255; 
       X = wcodemat(Xrgb,NbColors);
        
       map = pink(NbColors);
       colormap(map)
    
       t = wpdec2(X,2,wavelet_type);
       topt = besttree(t);
       LPLP = wprcoef(t,5);
       HorizLP = wprcoef(t, 6);
       VertLP = wprcoef(t, 7);
       [c,s]=wavedec2(X,2,wavelet_type);

       packetImg = imfuse(LPLP, HorizLP);
       packetImg = imfuse(packetImg, VertLP);
              
       fprintf("%s\n", destFin);
       fprintf("%s\n", currentfilename);
       newFileName = strcat(currentfilename(1:end-4), ".png");
       imwrite(packetImg, map, fullfile(destFin, newFileName))
    end
end
