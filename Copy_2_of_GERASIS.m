%{
kyviskiu aeorodromas:
c 54.668056         25.515556 ; L=540m, W=23m ; HASL = 153m.
pradzia 54.66986    25.51339
pabaiga 54.66637    25.51847
az = 325 (nuo c iki pradzios)
az = 145 (nuo c iki pabaigos)
%}

e = referenceEllipsoid('wgs84');
icon1 = fullfile('MATLAB', 'localizer1.png');
icon2 = fullfile('MATLAB', 'dotas5.png');

%----------------INPUT------------------------------------------------------

prompt1 = {'Centerlat:','Centerlon:','Runway heading'};
dlgtitle = 'COORDINATES OF A RUNWAY(TAKEOFF)';
dims = [1 35];
definput = {'54.63769','25.28736','345'};
answer = inputdlg(prompt1,dlgtitle,dims,definput);
ktlat = str2double(answer{1});
ktlon = str2double(answer{2});
ktheading = str2double(answer{3});


prompt2 = {'Length:','Width:'};
dlgtitle = 'KILIMO TAKO DUOMENYS';
definput = {'700','30'};
answer = inputdlg(prompt2,dlgtitle,dims,definput);
Lkt = str2double(answer{1});
Wkt = str2double(answer{2});


prompt3 = {'centerlat:','centerlon:','runway heading'};
dlgtitle = 'nusileidimo tako koordinates';
dims = [1 35];
definput = {'54.668056','25.515556','145'};
answer = inputdlg(prompt3,dlgtitle,dims,definput);
ltlat = str2double(answer{1});
ltlon = str2double(answer{2});
ltheading = str2double(answer{3});


prompt4 = {'Length:','Width:'};
dlgtitle = 'NUSILEIDIMO TAKO DUOMENYS';
definput = {'540','23'};
answer = inputdlg(prompt4,dlgtitle,dims,definput);
Llt = str2double(answer{1});
Wlt = str2double(answer{2});


prompt5 = {'Angle of glideslope:'};
dlgtitle = 'ANGLE OF GLIDESLOPE';
definput = {'3'};
dims = [1 35];
answer = inputdlg(prompt5,dlgtitle,dims,definput);
angleGP = str2double(answer{1});

prompt6 = {'Altitude of cruise flight: '};
dlgtitle = 'CRUISING ALTITUDE';
dims = [1 35];
definput = {'7100'};
answer = inputdlg(prompt6,dlgtitle,dims,definput);
cruiseALT = str2double(answer{1});

if ltheading >= 0 && ltheading < 180
    ltazi = ltheading + 180;
    
elseif ltheading >= 180 && ltheading <= 360
    ltazi = ltheading - 180;
    
else
    f = errordlg('Wrong data input');
end

prompt7 = {'How many waypoints?'};
dlgtitle = 'waypoints';
dims = [1 35];
definput = {'3'};
answer = inputdlg(prompt7,dlgtitle,dims,definput);
Nwaypoints = str2double(answer{1});
%------------------------------------------------------------------------%
[tplat,tplon] = reckon(ltlat,ltlon,Llt/3,ltazi,e);

[lat3km,lon3km] = reckon(tplat,tplon,3000,ltazi,e);    

[GP1lat,GP1lon] = reckon(tplat,tplon,3250,ltazi-5,e);
[GP2lat,GP2lon] = reckon(tplat,tplon,3250,ltazi+5,e);

[tofflat,tofflon] = reckon(ktlat,ktlon,Lkt/3,ktheading,e);

[toff3kmlat,toff3kmlon] = reckon(tofflat,tofflon,3000,ktheading,e);

[toff1lat,toff1lon] = reckon(tofflat,tofflon,2750,ktheading-5,e);
[toff2lat,toff2lon] = reckon(tofflat,tofflon,2750,ktheading+5,e);
%------------------------HEADING---------------------------------------
LATS = zeros(1,Nwaypoints);
LONS = zeros(1,Nwaypoints);
if Nwaypoints >= 1
    for k = 1:Nwaypoints
        
        promptn = {['latitude of waypoint #' num2str(k)],...
                   ['longitude of waypoint #' num2str(k)']};
        

        dlgtitle = ['coordinates of waypoint #' num2str(k)]; 
        dims = [1 50];
        definput{1} = {'54.69222','25.31762'};
        definput{2} = {'54.70081','25.36251'};
        definput{3} = {'54.70826','25.44969'};
        answer = inputdlg(promptn,dlgtitle,dims,definput{k});
        LATS(k) = str2double(answer{1});
        LONS(k) = str2double(answer{2});
        
        LATLIST = [toff3kmlat,LATS];
        LONLIST = [toff3kmlon,LONS];        

    end
else
    f = errordlg('Wrong data input');
end

%wmline(LATLIST,LONLIST);
%wmline([LATS(end) lat3km],[LONS(end) lon3km]);

%------------------------------------------------------------------------------

   data = flight8;
   acDATA = [data.VarName2 data.VarName3 data.VarName4];

%--- DEVIATION OF TAKEOFF
 
distFP1AC = distance (toff3kmlat,toff3kmlon,data.VarName2,data.VarName3,e);
 
azFP1AC = azimuth(toff3kmlat,toff3kmlon,data.VarName2,data.VarName3,e);
azFP1KT = azimuth(toff3kmlat,toff3kmlon,tofflat,tofflon,e);
 
alpha1 = azFP1KT - azFP1AC ;
hdev1 = sind(alpha1).*distFP1AC;                                       %SAVE
 

%--- DEVIATION OF FIXED POINT TO FIRST WAYPOINT

 distWP1AC = distance(LATS(1),LONS(1),data.VarName2,data.VarName3,e);
 
azWP1AC = azimuth(LATS(1),LONS(1),data.VarName2,data.VarName3,e);
azWP1FP1 = azimuth(LATS(1),LONS(1),toff3kmlat,toff3kmlon,e);
 
alpha2 = azWP1FP1 - azWP1AC;
hdev2 = sind(alpha2).*distWP1AC;                                       %SAVE
 
%--- DEVIATION OF WP TO WP+1
 
distWPkAC = distance(LATS(k),LONS(k),data.VarName2,data.VarName2,e);
 
azWPkAC = azimuth(LATS(k),LONS(k),data.VarName2,data.VarName3,e);
azWPkWP = azimuth(LATS(k),LONS(k),LATS(k-1),LONS(k-1),e);
 
alphak = azWPkWP - azWPkAC;
hdevk = sind(alphak).*distWPkAC;                                       %SAVE
 
%--- DEVIATION OF LAST WP FP2(3KM OFF TOUCHPOINT)
 
distFP2AC = distance(lat3km,lon3km,data.VarName2,data.VarName3,e);
 
azFP2AC = azimuth(lat3km,lon3km,data.VarName2,data.VarName3,e);
azFP2WPend = azimuth(lat3km,lon3km,LATS(end),LONS(end),e);
 
alpha4 = azFP2WPend - azFP2AC;
hdev4 = sind(alpha4).*distFP2AC;                                       %SAVE
 
%--- DEVIATION OF LANDING
 
distTPAC = distance(tplat,tplon,data.VarName2,data.VarName3,e);
 
azTPAC = azimuth(tplat,tplon,data.VarName2,data.VarName3,e);
azTPGP = azimuth(tplat,tplon,lat3km,lon3km,e);
 
hdeviation = azTPGP - azTPAC ;
hdev5 = sind(hdeviation).*distTPAC;                               %SAVE

%--- SAVE DEV DATA

DEVDATA = [hdev1 hdev2 hdevk hdev4 hdev5];

%--- VERTICAL DEVIATIONS

    
hdevs = abs(DEVDATA);

    if min(hdevs) == hdevs(5)

        angleTPAC = atan2d(data.VarName4,distTPAC);
        vdeviation = angleTPAC - angleGP;
        vdevmeters = distTPAC*(tand(vdeviation));              %SAVE

    else
        vdevmeters = data.VarName4 - cruiseALT;                               %SAVE
    end
    
    vdevs = abs(vdevmeters);
[r,c] = size(DEVDATA);
for i = 1:r

% OUTER CIRCLE
%------------------------------
rout = 1200;
ang=0:0.01:2*pi; 
xc=0;
yc=0;
xp1 = rout*cos(ang) + xc;
yp1 = rout*sin(ang) + yc;


% INNER CIRCLE
%------------------------------
rin = rout/20;
ang=0:0.01:2*pi; 
xc=0;
yc=0;
xp2 = rin*cos(ang) + xc;
yp2 = rin*sin(ang) + yc;


% VERTICAL CROSS
%------------------------------
r1 = sqrt(abs((rout^2)-(min(DEVDATA(i)).^2))); 
vCross.top.x(i) =  min(DEVDATA(i)); % motion
vCross.top.y =  r1; % static
vCross.bot.x(i) =  min(DEVDATA(i)); % motion
vCross.bot.y = -r1; % static


% HORIZONTAL CROSS
%------------------------------
r2 = sqrt(abs((rout^2)-(vdevmeters(i)).^2)); 
hCross.lef.x = -r2; % static
hCross.lef.y(i) =  vdevmeters(i); % motion
hCross.rit.x =  r2; % static
hCross.rit.y(i) =  vdevmeters(i); % motion

end
h01 = figure('Units','pixels','Position',[100 100 700 600],'Color','w');h01 = figure('Units','pixels','Position',[100 100 700 600],'Color','w');
ax01 = axes('Position',[.1 .1 .8 .8],'Color','none',...
    'XColor','none','YColor','none'); axis square; 
    xlim([-1200 1200]); ylim([-1200 1200]); hold on;
ax02 = axes('Position',[.1 .1 .8 .8],'Color','none',...
    'XColor','none','YColor','none'); axis square;
    xlim([-1200 1200]); ylim([-1200 1200]); hold on;
ax03 = axes('Position',[.1 .1 .8 .8],'Color','none',...
    'XColor','none','YColor','none'); axis square; 
    xlim([-1200 1200]); ylim([-1200 1200]); hold on;
ax04 = axes('Position',[.1 .1 .8 .8],'Color','none',...
    'XColor','none','YColor','none'); axis square;
    xlim([-1200 1200]); ylim([-1200 1200]);
    hold(ax04,'on');

ph01 = plot(ax01, xp1, yp1,'LineWidth',3,'LineStyle','-','Color',[.1 .3 .5]);
hold on
ph02 = plot(ax02, xp2, yp2,'LineWidth',5,'LineStyle','-','Color',[.1 .3 .5]);
hold on
ph03 = plot(ax03, [vCross.bot.x(i) vCross.top.x(i)], [vCross.bot.y vCross.top.y],...
    'LineWidth',3,'LineStyle','-','Color',[.9 .6 .1]);
ph04 = plot(ax04, [hCross.lef.x hCross.rit.x], [hCross.lef.y(i) hCross.rit.y(i)],...
    'LineWidth',3,'LineStyle','-','Color',[.9 .6 .1]);

for ii = 1:r
    wmmarker(data.VarName2(ii), data.VarName3(ii),'Icon', icon2);
    wmremove;

    ph03.XData = [vCross.bot.x(ii)      vCross.top.x(ii)];
    ph03.YData = [vCross.bot.y      vCross.top.y];

    ph04.XData = [hCross.lef.x      hCross.rit.x];
    ph04.YData = [hCross.lef.y(ii)      hCross.rit.y(ii)];

    pause(.02)
end


%------------------------------------------------------------------

%{
if min(hdevs) == abs(hdev1) && hdev1 > 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azFP1AC+(90-alpha1),e);
    wmline ([aclat linelat],[aclon linelon]);
elseif min(hdevs) == abs(hdev1) && hdev1 < 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azFP1AC+(180+90-alpha1),e);
    wmline ([aclat linelat],[aclon linelon]);  
end

if min(hdevs) == abs(hdev2) && hdev2 > 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azWP1AC+(90-alpha2),e);
    wmline ([aclat linelat],[aclon linelon]);
    elseif min(hdevs) == abs(hdev2) && hdev2 < 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azWP1AC+(180+90-alpha2),e);
    wmline ([aclat linelat],[aclon linelon]);  
end

if min(hdevs) == abs(hdevk) && hdevk > 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azWPkAC+(90-alphak),e);
    wmline ([aclat linelat],[aclon linelon]);
    elseif min(hdevs) == abs(hdevk) && hdevk < 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azWPkAC+(180+90-alphak),e);
    wmline ([aclat linelat],[aclon linelon]);      
end

if min(hdevs) == abs(hdev4) && hdev4 > 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azFP2AC+(90-alpha4),e);
    wmline ([aclat linelat],[aclon linelon]);
    elseif min(hdevs) == abs(hdev4) && hdev4 < 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azFP2AC+(180+90-alpha4),e);
    wmline ([aclat linelat],[aclon linelon]);  
end

if min(hdevs) == abs(hdevmeters) && hdevmeters > 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azTPAC+(90-hdeviation),e);
    wmline ([aclat linelat],[aclon linelon]);
    elseif min(hdevs) == abs(hdevmeters) && hdevmeters < 0
    [linelat,linelon] = reckon(aclat,aclon,min(hdevs),azTPAC+(180+90-hdeviation),e);
    wmline ([aclat linelat],[aclon linelon]);  
end






    %{
if azwpfp1 - azwpac < 0

    hdevheading = azfp1wp+90;
else 
    hdevheading = azfp1wp+90+180;
    %}
    
%[linelat,linelon] = reckon(aclat,aclon,min(hdevs),az????,e); 
%lineaz = 

%wmline([aclat aclon],[])

wmmarker(tplat,tplon,'Icon',icon1);
wmline([tplat lat3km], [tplon lon3km]);

wmline([GP1lat lat3km], [GP1lon lon3km],'LineWidth',0.5,'Alpha',0.75);
wmline([GP2lat lat3km], [GP2lon lon3km],'LineWidth',0.5,'Alpha',0.75);
wmline([tplat GP1lat], [tplon GP1lon],'LineWidth',0.5,'Alpha',0.75);
wmline([tplat GP2lat], [tplon GP2lon],'LineWidth',0.5,'Alpha',0.75);

wmmarker(tofflat,tofflon,'Icon',icon1);
wmline([tofflat toff3kmlat],[tofflon toff3kmlon]);

wmline([toff1lat toff3kmlat], [toff1lon toff3kmlon],'LineWidth',0.5,'Alpha',0.75);
wmline([toff2lat toff3kmlat], [toff2lon toff3kmlon],'LineWidth',0.5,'Alpha',0.75);
wmline([tofflat toff1lat], [tofflon toff1lon],'LineWidth',0.5,'Alpha',0.75);
wmline([tofflat toff2lat], [tofflon toff2lon],'LineWidth',0.5,'Alpha',0.75);

wmline(LATLIST,LONLIST);
wmline([LATS(end) lat3km],[LONS(end) lon3km]);

%------------------------------------------------------------------------------
%}
%}
%}

