% DEVDATA = import('DEVDATA.mat');

[r,c] = size(DEVDATA);


for i = 1:r

% OUTER CIRCLE
%------------------------------
rout = 1200;
ang=0:0.01:2*pi; 
xc=0;
yc=0;
outer_xp = rout*cos(ang) + xc;
outer_yp = rout*sin(ang) + yc;


% INNER CIRCLE
%------------------------------
rin = rout/20;
ang=0:0.01:2*pi; 
xc=0;
yc=0;
inner_xp = rin*cos(ang) + xc;
inner_yp = rin*sin(ang) + yc;


% VERTICAL CROSS
%------------------------------
r1 = sqrt(abs((rout^2)-(min(hdevs(i)).^2))); 
vCross.top.x =  min(DEVDATA(i)); % motion
vCross.top.y =  r1; % static
vCross.bot.x =  min(DEVDATA(i)); % motion
vCross.bot.y = -r1; % static


% HORIZONTAL CROSS
%------------------------------
r2 = sqrt(abs((rout^2)-(vdevs(i)).^2)); 
hCross.lef.x = -r2; % static
hCross.lef.y =  vdevmeters(i); % motion
hCross.rit.x =  r2; % static
hCross.rit.y =  vdevmeters(i); % motion

end
%-----------------------------
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
    xlim([-1200 1200]); ylim([-1200 1200]); hold on;

ph01 = plot(ax01, outer_xp, outer_yp,'LineWidth',3,'LineStyle','-','Color',[.1 .3 .5]);
hold on
ph02 = plot(ax02, inner_xp, inner_yp,'LineWidth',5,'LineStyle','-','Color',[.1 .3 .5]);
hold on
ph03 = plot(ax03, [vCross.bot.x vCross.top.x], [vCross.bot.y vCross.top.y],...
    'LineWidth',3,'LineStyle','-','Color',[.9 .6 .1]);
ph04 = plot(ax04, [hCross.lef.x hCross.rit.x], [hCross.lef.y hCross.rit.y],...
    'LineWidth',3,'LineStyle','-','Color',[.9 .6 .1]);
%--------------------------------
for ii = 1:r
    wmmarker(data.VarName2(ii), data.VarName3(ii),'Icon', icon2);
    wmremove;

    ph03.XData = [vCross.bot.x(ii)      vCross.top.x(ii)];
    ph03.YData = [vCross.bot.y          vCross.top.y];

    ph04.XData = [hCross.lef.x          hCross.rit.x];
    ph04.YData = [hCross.lef.y(ii)      hCross.rit.y(ii)];

    pause(.02)
end