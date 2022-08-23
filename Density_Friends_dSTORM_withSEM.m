files = R_AP5.Blind_File;

N = length(files);

Total_Red = [];
Total_Green = [];

Total_Red_Per = []; 
Total_Green_Per = [];

Tot_L_Red = [];
Tot_L_Green = [];

for i = 1:N
    thisfile = convertStringsToChars(files(i));
    disp(thisfile)
    other = thisfile(1:end-7);
    other = strcat(other,'561.csv');
    Red = readtable(thisfile); % Alexa647
    Green = readtable(other); % CF568
    
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation

    [ID,D] = nearestNeighbor(DT,Green.dX,Green.dY); %Nearest 568 to a 647
    set = [ID,D];
    set = set(set(:,2)<25); %Filters out those above 25 nm away
    set = set(:,1);

    N = TP(set,:);
    N_areas = r(ID,:);

    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end

    tess_area_coloc=zeros(size(N_areas,1),1);

    for i = 1 : size(N_areas ,1)
      ind = N_areas{i}';
     if ind~=1
      tess_area_coloc(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end

    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
    Green_Individual = tess_area_coloc(tess_area_coloc<1000 & tess_area_coloc>5);
    
    Red_Clust = length(Red_Individual(Red_Individual<200))/length(Red_Individual);
    Green_Clust = length(Green_Individual(Green_Individual<200))/length(Green_Individual);
    
    edges = [0:5:1000];
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    HC_Green = histcounts(Green_Individual,edges,'Normalization','pdf');
    L_Red=length(Red_Individual);
    L_Green=length(Green_Individual);
    
    Total_Red_Per = [Total_Red_Per;Red_Clust];
    Total_Green_Per = [Total_Green_Per;Green_Clust];
    
    Total_Red = [Total_Red;HC_Red];
    Total_Green = [Total_Green;HC_Green];
    
    Tot_L_Red = [Tot_L_Red,L_Red];
    Tot_L_Green = [Tot_L_Green,L_Green];
     
    
end

%%
% figure()
M_Red = nanmean(Total_Red);
M_Green = nanmean(Total_Green)*nanmean(Tot_L_Green)/nanmean(Tot_L_Red);

nonan_std = nanstd(Total_Green);
nonan_len = length(Total_Green);
semval = nonan_std / sqrt(nonan_len)*nanmean(Tot_L_Green)/nanmean(Tot_L_Red);


% bar(edges(1:end-1),M_Red,1,'red')
% hold on
% bar(edges(1:end-1),M_Green,1,'blue')
% ylim([0 6E-3])

curve1 = medfilt1(M_Green-semval,5);
curve2 = medfilt1(M_Green+semval,5);
x2 = [edges(1:end-1), fliplr(edges(1:end-1))];
inBetween = [curve1, fliplr(curve2)];
patch = fill(x2, inBetween, 'b','edgecolor', 'none','FaceAlpha', 0.3);

hold on
% ylim([0 6E-3])
bar(edges(1:end-1),medfilt1(M_Green,5),1,'b', 'LineWidth', 2)



%% %% DF for 5 groups
files = Control.Blind_File;
files2 = JHW.Blind_File;
files3 = Nor.Blind_File;
files4 = Nom.Blind_File;
files5 = Cocaine.Blind_File;

edges = [0:5:5000];

N = length(files);

Total_Red = [];

Total_Red_Per = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);       
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per = [Total_Red_Per;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end

M_Red_C = nanmean(Total_Red);
nonan_std = nanstd(Total_Red);
nonan_len = length(Total_Red);
semval_C = nonan_std / sqrt(nonan_len);

N = length(files2);

Total_Red = [];

Total_Red_Per = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files2(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);  
    
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per = [Total_Red_Per;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end





M_Red_Drug = nanmean(Total_Red);
nonan_std = nanstd(Total_Red);
nonan_len = length(Total_Red);
semval_Drug = nonan_std / sqrt(nonan_len);



N = length(files3);

Total_Red = [];

Total_Red_Per = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files3(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);  
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per = [Total_Red_Per;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end

M_Red_Antag = nanmean(Total_Red);
nonan_std = nanstd(Total_Red);
nonan_len = length(Total_Red);
semval_Antag = nonan_std / sqrt(nonan_len);

N = length(files4);

Total_Red = [];

Total_Red_Per = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files4(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);  
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per = [Total_Red_Per;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end

M_Red_C4 = nanmean(Total_Red);
nonan_std = nanstd(Total_Red);
nonan_len = length(Total_Red);
semval_C4 = nonan_std / sqrt(nonan_len);

N = length(files5);

Total_Red = [];

Total_Red_Per = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files5(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);  
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per = [Total_Red_Per;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end

M_Red_C5 = nanmean(Total_Red);
nonan_std = nanstd(Total_Red);
nonan_len = length(Total_Red);
semval_C5 = nonan_std / sqrt(nonan_len);

%%

figure()


bar(edges(1:end-1),M_Red_C,1,'red')
hold on
bar(edges(1:end-1),M_Red_Drug,1,'blue')
bar(edges(1:end-1),M_Red_Antag,1,'green')
bar(edges(1:end-1),M_Red_C4,1,'yellow')
bar(edges(1:end-1),M_Red_C5,1,'blue')
% ylim([0 6E-3])
xlim([0 250])

%%
figure()


hold on
curve1 = medfilt1(M_Red_C-semval_C,5);
curve2 = medfilt1(M_Red_C+semval_C,5);
x2 = [edges(1:end-1), fliplr(edges(1:end-1))];
inBetween = [curve1, fliplr(curve2)];
patch = fill(x2, inBetween, 'k');
set(patch, 'edgecolor', 'none');
set(patch, 'FaceAlpha', 0.3);
% ylim([0 6E-3])
bar(edges(1:end-1),medfilt1(M_Red_C,5),1,'k', 'LineWidth', 2)


curve1 = medfilt1(M_Red_Drug-semval_Drug,5);
curve2 = medfilt1(M_Red_Drug+semval_Drug,5);
x2 = [edges(1:end-1), fliplr(edges(1:end-1))];
inBetween = [curve1, fliplr(curve2)];
patch2 = fill(x2, inBetween, 'y');
set(patch2, 'edgecolor', 'none');
set(patch2, 'FaceAlpha', 0.3);
% ylim([0 6E-3])
bar(edges(1:end-1),medfilt1(M_Red_Drug,5),1,'y', 'LineWidth', 2)

curve1 = medfilt1(M_Red_Antag-semval_Antag,5);
curve2 = medfilt1(M_Red_Antag+semval_Antag,5);
x2 = [edges(1:end-1), fliplr(edges(1:end-1))];
inBetween = [curve1, fliplr(curve2)];
patch3 = fill(x2, inBetween, 'b');
set(patch3, 'edgecolor', 'none');
set(patch3, 'FaceAlpha', 0.3);
% ylim([0 6E-3])
bar(edges(1:end-1),medfilt1(M_Red_Antag,5),1,'b', 'LineWidth', 2)

curve1 = medfilt1(M_Red_C4-semval_C4,5);
curve2 = medfilt1(M_Red_C4+semval_C4,5);
x2 = [edges(1:end-1), fliplr(edges(1:end-1))];
inBetween = [curve1, fliplr(curve2)];
patch3 = fill(x2, inBetween, 'm');
set(patch3, 'edgecolor', 'none');
set(patch3, 'FaceAlpha', 0.3);
% ylim([0 6E-3])
bar(edges(1:end-1),medfilt1(M_Red_C4,5),1,'m', 'LineWidth', 2)

curve1 = medfilt1(M_Red_C5-semval_C5,5);
curve2 = medfilt1(M_Red_C5+semval_C5,5);
x2 = [edges(1:end-1), fliplr(edges(1:end-1))];
inBetween = [curve1, fliplr(curve2)];
patch3 = fill(x2, inBetween, 'c');
set(patch3, 'edgecolor', 'none');
set(patch3, 'FaceAlpha', 0.3);
% ylim([0 6E-3])
bar(edges(1:end-1),medfilt1(M_Red_C5,5),1,'c', 'LineWidth', 2)


xlim([0 300])


%% DF focr 3 groups
files = G_Cont_N.Blind_File;
files2 = G_NMDA.Blind_File;
files3 = G_AP5.Blind_File;

% files = Control.ROI;
% files2 = NMDA.ROI;
% files3 = AP5.ROI;

edges = [0:5:5000];

N = length(files);

Total_Red = [];

Total_Red_Per1 = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);       
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per1 = [Total_Red_Per1;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end

M_Red_C = nanmean(Total_Red);
nonan_std = nanstd(Total_Red);
nonan_len = length(Total_Red);
semval_C = nonan_std / sqrt(nonan_len);


N = length(files2);

Total_Red = [];

Total_Red_Per2 = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files2(i))
    Red = readtable(thisfile); % Alexa647
    if height(Red)>50
        [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
        [V,r] = voronoiDiagram(DT); %Vorroni of 647
        C = DT.ConnectivityList; %Verticies of triangualtion
        TP = DT.Points; %pts of tirangulation


        tess_area=zeros(size(r,1),1);

        for i = 1 : size(r ,1)
          ind = r{i}';
         if ind~=1
          tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
         end
        end


        Red_Individual = tess_area(tess_area<1000 & tess_area>5);
        

        Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);


        HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');

        L_Red=length(Red_Individual);


        Total_Red_Per2 = [Total_Red_Per2;Red_Clust];

        Total_Red = [Total_Red;HC_Red];

        Tot_L_Red = [Tot_L_Red,L_Red];
        
    end
end





M_Red_Drug = nanmean(Total_Red);
nonan_std = nanstd(Total_Red);
nonan_len = length(Total_Red);
semval_Drug = nonan_std / sqrt(nonan_len);



N = length(files3);

Total_Red = [];

Total_Red_Per3 = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files3(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);  
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per3 = [Total_Red_Per3;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end

M_Red_Antag = nanmean(Total_Red);
nonan_std = nanstd(Total_Red);
nonan_len = length(Total_Red);
semval_Antag = nonan_std / sqrt(nonan_len);

%%
% figure()


bar(edges(1:end-1),M_Red_C,1,'black')
hold on
bar(edges(1:end-1),M_Red_Drug,1,'green')
bar(edges(1:end-1),M_Red_Antag,1,'blue')

% ylim([0 6E-3])
xlim([0 300])

%%
figure()



hold on
curve1 = medfilt1(M_Red_C-semval_C,5);
curve2 = medfilt1(M_Red_C+semval_C,5);
x2 = [edges(1:end-1), fliplr(edges(1:end-1))];
inBetween = [curve1, fliplr(curve2)];
patch = fill(x2, inBetween, 'k');
set(patch, 'edgecolor', 'none');
set(patch, 'FaceAlpha', 0.3);
% ylim([0 6E-3])
bar(edges(1:end-1),medfilt1(M_Red_C,5),1,'k', 'LineWidth', 2)


curve1 = medfilt1(M_Red_Drug-semval_Drug,5);
curve2 = medfilt1(M_Red_Drug+semval_Drug,5);
x2 = [edges(1:end-1), fliplr(edges(1:end-1))];
inBetween = [curve1, fliplr(curve2)];
patch2 = fill(x2, inBetween, 'g');
set(patch2, 'edgecolor', 'none');
set(patch2, 'FaceAlpha', 0.3);
% ylim([0 6E-3])
bar(edges(1:end-1),medfilt1(M_Red_Drug,5),1,'g', 'LineWidth', 2)

curve1 = medfilt1(M_Red_Antag-semval_Antag,5);
curve2 = medfilt1(M_Red_Antag+semval_Antag,5);
x2 = [edges(1:end-1), fliplr(edges(1:end-1))];
inBetween = [curve1, fliplr(curve2)];
patch3 = fill(x2, inBetween, 'b');
set(patch3, 'edgecolor', 'none');
set(patch3, 'FaceAlpha', 0.3);
% ylim([0 6E-3])
bar(edges(1:end-1),medfilt1(M_Red_Antag,5),1,'b', 'LineWidth', 2)


xlim([0 300])


%% %% DF for 4 groups
files = Control.ROI;
files2 = T1.ROI;
files3 = T2.ROI;
files4 = T3.ROI;


edges = [0:5:5000];

N = length(files);

Total_Red = [];

Total_Red_Per1 = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);       
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per1 = [Total_Red_Per1;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end

M_Red_C = nanmean(Total_Red);


N = length(files2);

Total_Red = [];

Total_Red_Per2 = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files2(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);  
    
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per2 = [Total_Red_Per2;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end





M_Red_Drug = nanmean(Total_Red);




N = length(files3);

Total_Red = [];

Total_Red_Per3 = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files3(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);  
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per3 = [Total_Red_Per3;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end

M_Red_Antag = nanmean(Total_Red);


N = length(files4);

Total_Red = [];

Total_Red_Per4 = [];

Tot_L_Red = [];

for i = 1:N
    thisfile = convertStringsToChars(files4(i))
    Red = readtable(thisfile); % Alexa647
       
    [DT] = delaunayTriangulation([Red.dX,Red.dY]); %Triangulates 647
    [V,r] = voronoiDiagram(DT); %Vorroni of 647
    C = DT.ConnectivityList; %Verticies of triangualtion
    TP = DT.Points; %pts of tirangulation


    tess_area=zeros(size(r,1),1);

    for i = 1 : size(r ,1)
      ind = r{i}';
     if ind~=1
      tess_area(i,1) = polyarea( V(ind,1) , V(ind,2) );
     end
    end


    Red_Individual = tess_area(tess_area<1000 & tess_area>5);
%     Red_Individual = Red_Individual(Red_Individual>5);  
    Red_Clust = length(Red_Individual(Red_Individual<150))/length(Red_Individual);
        
    
    HC_Red = histcounts(Red_Individual,edges,'Normalization','pdf');
    
    L_Red=length(Red_Individual);
    
    
    Total_Red_Per4 = [Total_Red_Per4;Red_Clust];
        
    Total_Red = [Total_Red;HC_Red];
        
    Tot_L_Red = [Tot_L_Red,L_Red];
        
    
end

M_Red_C4 = nanmean(Total_Red);





figure()


bar(edges(1:end-1),M_Red_C,1,'black')
hold on
bar(edges(1:end-1),M_Red_Drug,1,'red')
bar(edges(1:end-1),M_Red_Antag,1,'green')
bar(edges(1:end-1),M_Red_C4,1,'blue')

% ylim([0 6E-3])
xlim([0 1000])
