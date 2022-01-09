
function xyz_vector_from_rot_mat = xyz_move_vector(mat)
%xyz_move_vector - Gets rottation matrix and returns the x,y,z delta as vector 
%
% Syntax: xyz_vector_from_rot_mat = xyz_move_vector(mat)
% =============================================================================

% check if the matrix has valid dimentions
if isequal(size(mat), [4 4])
    xyz_vector_from_rot_mat = [mat(1,4) mat(2,4) mat(3,4)] 
else
    % alerts if the matrix is not valid
    disp('The matrix dimentions are diffrent from 4x4')
    
end