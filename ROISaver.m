%% Import
filename = '78.csv';
fn = filename(1:end-4);


org647 = readtable(filename);

a=dir('ROIS/*.csv');
b={a.name};
c = cellfun(@(x) startsWith(x,strcat(fn,'_')),b);
d = char(b{c});
temp = size(d);
count = 0;

for co = 1:temp(1)
sss = strsplit(d(co,:),'_');
nnn = strsplit(sss{2},'.');
c_new = cellfun(@str2num,nnn(1));
if c_new>count
    count = c_new;
end
end

%%

figure('units','normalized','outerposition',[0 0 1 1])
h1 = axes   

X647=table2array([org647(:,'dX'),org647(:,'dY')] ); %makes a matrix of the localizations


% 
% X647 = datasample(X647,10000);

scatter(X647(:,1),X647(:,2),'.','k') 

hold on


if count > 0
       
    for r =1:count
       id = strcat('ROIS/',fn,'_',num2str(r),'.csv'); 
       idro = readtable(id);
       scatter(idro.dX,idro.dY,'.','r')
     end
end
axis('equal')
h = imfreehand


%% Save the ROIs
points = [15361.3788749182 31842.0045250158;15361.3788749182 31831.5251437694;15361.3788749182 31873.442668755;15508.0902123679 32166.8653436543;15602.4046435855 32313.576681104;15644.3221685712 32418.3704935681;15728.1572185424 32502.2055435393;15853.9097934993 32565.0818310177;15927.2654622241 32586.0405935105;15937.7448434705 32586.0405935105;16063.4974184274 32606.9993560033;16168.2912308914 32617.4787372497;16262.605662109 32617.4787372497;16325.4819495875 32617.4787372497;16409.3169995587 32586.0405935105;16514.1108120228 32523.1643060321;16650.342768226 32439.3292560609;16671.3015307188 32439.3292560609;16713.2190557045 32365.973587336;16744.6571994437 32250.7003936256;16755.1365806901 32219.2622498864;16776.0953431829 32135.4271999151;16786.5747244293 31988.7158624654;16786.5747244293 31862.9632875086;16786.5747244293 31821.045762523;16734.1778181973 31621.9375188413;16650.342768226 31391.3911314204;16618.9046244868 31108.4478377674;16608.4252432404 30919.8189753321;16587.4664807476 30752.1488753897;16556.0283370084 30553.040631708;16545.548955762 30458.7262004903;16535.0695745156 30416.8086755047;16514.1108120228 30343.4530067799;16493.15204953 30322.4942442871;16440.7551432979 30249.1385755622;16409.3169995587 30228.1798130694;16367.3994745731 30207.2210505766;16325.4819495875 30186.2622880838;16283.5644246019 30186.2622880838;16168.2912308914 30207.2210505766;15885.3479372385 30353.9323880263;15382.337637411 30815.0251628681;15382.337637411 30825.5045441145];



count = count + 1;
ROInumber= strcat('_',num2str(count));
ptsDAT = [org647(:,'id'),org647(:,'dX'),org647(:,'dY')];
DAT = table2array(ptsDAT);
in2 = inpolygon(DAT(:,2),DAT(:,3),points(:,1),points(:,2));
org647.ROI = in2;
ROI647 = org647(org647.ROI == 1,:);





writetable(ROI647,strcat('ROIS/',fn,ROInumber,'.csv'))



