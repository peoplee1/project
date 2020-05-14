function [fh01,ax01,ax02,ax03,ax04] = makexfig()


fh01 = figure('Units','pixels','Position',[100 100 700 600],'Color','w');
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

end