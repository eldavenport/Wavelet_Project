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
        
       map = copper(NbColors);
       colormap(map)
    
       [c,s]=wavedec2(X,2,'db4');
    
       [H1,V1,D1] = detcoef2('all',c,s,1);
       A1 = appcoef2(c,s,'db4',1);
        
       V1img = wcodemat(V1,255,'mat',1);
       H1img = wcodemat(H1,255,'mat',1);
       D1img = wcodemat(D1,255,'mat',1);
       A1img = wcodemat(A1,255,'mat',1);

       RGB = ind2rgb(A1img,map);
       LAB = rgb2lab(RGB);
       L = LAB(:,:,1)/100;
       L = adapthisteq(L,'NumTiles',[8 8],'ClipLimit',0.005);
       LAB(:,:,1) = L*100;
       J = lab2rgb(LAB);
       
       [A,map] = rgb2ind(J,256);

       fprintf("%s\n", destFin);
       fprintf("%s\n", currentfilename);
       newFileName = strcat(currentfilename(1:end-4), ".jpg")
       imwrite(A, map, fullfile(destFin, newFileName))
    end
end
