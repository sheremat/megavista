function mrGrayResampleNiftiClass(t1File, classFile, outMm)
% Resample NIFTI class file to voxel size.
% mrGrayResampleNiftiClass(t1File, classFile, outMm)
% 
% Resamples a nifti class file (and the corresponding t1 NIFTI vAnatomy file)
% to a new voxel size. Could be easily modified to allow rotations and translations
% of the class data.
%
% HISTORY:
% 2008.02.04 RFD wrote it.

if(~exist('t1File','var')||isempty(t1File))
    opts = {'*.nii;*.nii.gz', 'NIFTI files (*.nii,*.nii.gz)'; '*.*','All Files (*.*)'};
    [f, p] = uigetfile(opts, 'Pick a NIFTI t1 (vAnatomy) file');
    if(isequal(f,0)|| isequal(p,0)) disp('user canceled.'); return; end
    t1File = fullFile(p,f);
end
if(~exist('classFile','var')||isempty(classFile))
    default = fullfile(fileparts(t1File),'t1_class.nii.gz');
    opts = {'*.nii;*.nii.gz', 'NIFTI files (*.nii,*.nii.gz)'; '*.*','All Files (*.*)'};
    [f, p] = uigetfile(opts, 'Pick a NIFTI class file',default);
    if(isequal(f,0)|| isequal(p,0)) disp('user canceled.'); return; end
    classFile = fullFile(p,f);
end
if(~exist('outMm','var')||isempty(outMm))
   a = inputdlg('Out voxel size (mm):','Specify output resolution',1,{'1 1 1'});
   if(isempty(a)) error('user canceled.'); end
   outMm = str2num(a{1});
end

t1 = readFileNifti(t1File);

% If outMm is a char, assume that it is a nifti filename
if(ischar(outMm))
    outMm = readFileNifti(outMm);
end
if(isstruct(outMm))
    ref = outMm;
    outMm = ref.pixdim(1:3);
    refImg = ref.data;
    Vref.uint8 = uint8(round(mrAnatHistogramClip(double(refImg), 0.4, 0.99).*255+.5));
    Vref.mat = ref.qto_xyz;
    Vin.uint8 = uint8(round(mrAnatHistogramClip(double(t1.data(:,:,:,1)), 0.4, 0.99).*255+0.5));
    Vin.mat = t1.qto_xyz;
    transRot = spm_coreg(Vref, Vin);
    xform = inv(Vin.mat)*spm_matrix(transRot(end,:));
    bb = [1 1 1; ref.dim(1:3)];
    bb = round(mrAnatXformCoords(ref.qto_xyz,bb));
    outSz = size(ref.data);
    [p,f,e] = fileparts(ref.fname);
    if(isempty(p)) p = pwd; end
    if(strcmpi(e,'.gz')) [junk,f] = fileparts(f); end
    outClassFileName = fullfile(p, [f '_class.nii.gz']);
    clear ref Vref Vin;
else
    [p,f,e] = fileparts(t1File);
    if(isempty(p)) p = pwd; end
    if(strcmpi(e,'.gz')) [junk,f] = fileparts(f); end
    outT1FileName = fullfile(p, [f '_resamp.nii.gz']);
    [f,p] = uiputfile('*.nii.gz','Save new NIFTI t1 file as...',outT1FileName);
    if(isequal(f,0)|| isequal(p,0)) disp('user canceled.'); return; end
    outT1FileName = fullfile(p,f);

    xform = t1.qto_ijk;
    % Resample the t1
    disp('resampling the t1...');
    bb = [1 1 1; t1.dim(1:3)];
    bb = round(mrAnatXformCoords(t1.qto_xyz,bb));
    
    % JW Somehow the bspline parameters ([7 7 7 0 0 0]) seem to have
    % gotten changed to the incorrect values ([0 0 0 7 7 7]). The values [0
    % 0 0 7 7 7] produce errors, so I am switching them back. 
    %[t1New,xformNew] = mrAnatResliceSpm(double(t1.data),xform,bb,outMm,[0 0 0 7 7 7],0);
    [t1New,xformNew] = mrAnatResliceSpm(double(t1.data),xform,bb,outMm,[7 7 7 0 0 0],0);
    
    t1New = single(t1New);
    dtiWriteNiftiWrapper(t1New,xformNew,outT1FileName);
    outSz = size(t1New);
    [p,f,e] = fileparts(classFile);
    if(isempty(p)) p = pwd; end
    if(strcmpi(e,'.gz')) [junk,f] = fileparts(f); end
    outClassFileName = fullfile(p, [f '_resamp.nii.gz']);
end

[f,p] = uiputfile('*.nii.gz','Save new NIFTI class file as...',outClassFileName);
if(isequal(f,0)|| isequal(p,0)) disp('user canceled.'); return; end
outClassFileName = fullfile(p,f);

% Resample the class file.
% This is harder since we need to keep them integers and the classes have no ordered 
% relationship to one another. Therefore, it doesn't make sense to interpolate between class values.
% So, we convert each class into a binary image, interpolate it, and then pack it into
% the new output image. Note that the order in which we process the class values matters
% since some overlap might be generated by the interpolation. Here we just allow higher class
% values to replace smaller ones.
disp('resampling the classes...');
cls = readFileNifti(classFile);
clsBins = unique(cls.data(cls.data(:)>0));
clsNew = zeros(outSz,'uint8');
for(ii=1:length(clsBins))
   [tmp,xformNew] = mrAnatResliceSpm(double(cls.data==clsBins(ii)),xform,bb,outMm,[0 0 0 1 1 1],0);
   clsNew(tmp>=0.5) = clsBins(ii);
end

dtiWriteNiftiWrapper(clsNew,xformNew,outClassFileName);

return;
