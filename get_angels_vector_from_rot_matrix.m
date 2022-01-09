function angels_vector = get_angels_vector_from_rot_matrix(mat)
% Author: Dennis - dennis.komarov@intel.com
% Version: 1
% Desciption: get_angels_vector_from_rot_matrix - yealds the rottation angls from rottation matrix
%
% Syntax: angels_vector = get_angels_vector_from_rot_matrix(mat)
% ====================================================================================
    
% check if the matrix has valid dimentions
if isequal(size(mat), [4 4])
    beta = -asind(mat(3,1));
    gama = asind(mat(3,2)/cosd(b));
    alpha = asind(mat(2,1)/cosd(b));

    angels_vector = [alpha beta gama]
else
    % alerts if the matrix is not valid
    disp('The matrix dimentions are diffrent from 4x4')
end