function newTypeNum = addDataType(dataTypeName);    
% newTypeNum = addDataType(dataTypeName);
%
% Add a new dataType to mrSESSION.  Then, update the UI for
% all open view windows
% dataTypeName: string specifying the name for this dataType (e.g., 'Average').
% newTypeNum: returns the new data type's index in dataTYPES.
% baw, 12/26/2000
% djh, 2/21/2001, updated to mrLoadRet-3 implementation
% rfd, 3/08/2002, added return value 'num', clean stale comments

%mrGlobals
global mrSESSION
global dataTYPES
global INPLANE
global VOLUME
global FLAT
if isempty(mrSESSION)|isempty(dataTYPES);
    error('mrSESSION not loaded. Try loadSession');
end
if existDataType(dataTypeName)
    myErrorDlg(['Data type ',dataTypeName,' already exists.']);
end
newTypeNum = length(dataTYPES)+1;
dataTYPES(newTypeNum).name = dataTypeName;
saveSession;

% Loop through the open views, reselecting their curDataType to update the popups 
INPLANE = resetDataTypes(INPLANE);
VOLUME = resetDataTypes(VOLUME);
FLAT = resetDataTypes(FLAT);
return;

