function flipTSeries(view,scanList)%% function flipTSeries(view,[scanList])%% Flips (time reverses) the time series.% This is useful for averaging normal and reversed retinotopies% to remove the hemodynamic delay.%% scanList: vector of scan numbers to flip. Default: prompt user.%% If you change this function make parallel changes in:%    shiftTSeries% % djh, 6/2001if ~exist('scanList','var')    scanList = er_selectScans(view);endwaitHandle = waitbar(0,'Flipping (time-reversing) tSeries.  Please wait...');for iScan=1:length(scanList)    scan = scanList(iScan);    for slice=sliceList(view,scan);        tSeries = loadtSeries(view, scan, slice);        tSeries = flipud(tSeries);        savetSeries(tSeries,view,scan,slice);    end     waitbar(iScan/length(scanList))endclose(waitHandle);return