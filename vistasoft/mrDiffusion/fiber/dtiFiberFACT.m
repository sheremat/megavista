function fiberPath = dtiFiberFACT(seedPoint, vecImg, faImg, voxSize, direction, faThresh, rThresh, angleThresh, options)
if(~exist('angleThresh','var') | isempty(angleThresh))
% Parse options

% Mori likes to use '4' for this parameter, which is related to the
% voxel face coordinates (from center of voxel)
% The coordinate ordering is x,y,z,-x,-y,-z
inVoxThresh = voxSize/2 + 0.001;
% set trace direction (order that faces in voxel are searched for closest)

% vCoord holds the coordinates of the current voxel and vPos holds the
% We no longer start at the voxel center. Now, we let the caller specify

%==================
% MAIN TRACING LOOP
%==================
iter = 0;
    if(any(vCoord<1) | any(vCoord>imSize'))
        disp('Tracking terminated: path wandered outside image data.');
        
        % Get direction vector for this voxel
        vDir = [ vecImg(vCoord(1), vCoord(2), vCoord(3), 1); ...
        
        % Get the FA for this voxel
        
        % Compute R, the sum of the inner-product of the neighbors

        
        % check vDir data is valid (we are in range)
        if (isnan(fa) | fa < faThresh | sum(vDir) == 0)
            disp(['Tracking terminated: fa=',num2str(fa)]);
            done = 1;
        else
            % calculate where this vector intersects the planes of the voxel faces. 
            % We only need a scalar for each face- essentially, the magnitude
            % of the direction vector along each axis in both + and - directions.
            % Eg., the coordinates of the intersection point for the first face is 
            % vPos + voxFaces(1) .* vDir.
            voxFaces = (vFace - [vPos; vPos]) ./ [vDir; vDir];
            
            % now, find the nearest non-zero face. Note that zero values
            % indicate faces that contain the origin of this vector (ie.
            % vPos == vFace).
            index = [];
            for k=traceDir 
                % isInVoxel(vPos + voxFaces(k).*vDir, voxSize)
                %[k,abs(vPos + voxFaces(k).*vDir)']
                if (voxFaces(k)~=0 & all(abs(vPos + voxFaces(k).*vDir) <= inVoxThresh))
                    index(end+1) = k;
                end            
            end
            if (isempty(index))
                disp('Tracking terminated: index empty');
                done = 1;
            else            
                vCoordNew = repmat(vCoord,1,length(index)) + vIndex(:,index);
                % The position within the next voxel is the intersection

                if(size(vCoordPath,1)>1 & length(index)>1)
                    % select the direction that gives the smoothest fiber
                    prevPos = vCoordPath(end-1,:) + vPosPath(end-1,:)./voxSize';
                        vCoordNew = vCoordNew(:,1);
                        vPosNew = vPosNew(:,1);
                    else
                        vCoordNew = vCoordNew(:,2);
                        vPosNew = vPosNew(:,2);
                    end
                else
                    vCoordNew = vCoordNew(:,1);
                    vPosNew = vPosNew(:,1);
                end
                
                % Check the angle threshold
                if(angleThresh < 180 & size(vCoordPath,1)>1)
                    backTwoPos = vCoordPath(end-1,:) + vPosPath(end-1,:)./voxSize';
                    backOnePos = vCoordPath(end,:) + vPosPath(end,:)./voxSize';
                    % The angle between two vectors is given by acos(A*B/a*b)  
                    % (A*B is the dot-product of the two vectors and a*b is the
                    % product of their magnitudes)
                    A = backOnePos - backTwoPos;
                    B = (vCoordNew' + vPosNew'./voxSize') - backOnePos;
                    magProd = (sqrt(sum(A.^2)) * sqrt(sum(B.^2)));
                    if(abs(magProd)>0)
                        angle = abs(acos( (A*B') ./ magProd)/pi*180);
                    else
                        angle = 0;
                    end
                    %disp(['angle: ' num2str(angle)]);
                    if(angle>angleThresh)
                        disp(['Tracking terminated: angle (' num2str(round(angle)) ') exceeds threshold.']);
                        done = 1;
                    end
                end
                
                % Don't allow a fiber to loop back on itself
                if(~done & ~noCrossPath | isempty(intersect(vCoordPath, vCoordNew', 'rows')))
                    disp('Tracking terminated: path folded on itself');
                    done = 1;
                end
            end
        end
    end
    iter = iter+1;
end
% Return the real-valued fiber path:
fiberPath = vCoordPath + vPosPath./repmat(voxSize',size(vPosPath,1),1);
%disp(fiberPath);


% --------------------------------------------------------------------
function  inVoxel = isInVoxel(point, Vsize)

% Following is a fudge factor to allow for small precision-limit errors.
epsilon = 0.01;
inVoxel = all(abs(point) <= Vsize/2+epsilon);
return;