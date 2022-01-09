clear all
clc

% ==================== Matrices segment ==============================
mat=[1.000000 0.000590 -0.000200 0.029279
-0.000590 1.000000 -0.000125 -0.514763
0.000199 0.000125 1.000000 0.047628
0.000000 0.000000 0.000000 1.000000]


dmat = [1.000000 0.000590 -0.000199 0.000000
    -0.000590 1.000000 -0.000125 0.000000
    0.000200 0.00012 1.000000 0.000000
    0.029279 0.514763 -0.047628 1.000000]

rot_mat125_142 = [0.917227 -0.398229 0.010445 0.798829
            0.398359 0.917049 -0.018231 -7.272229
            -0.002318 0.020883 0.999779 -0.091628
            0.000000 0.000000 0.000000 1.000000]

B = [ 0.999996 -0.002205 0.001909 0.066557
      0.002189 0.999962 0.008412 -2.271765
      -0.001927 -0.008408 0.999963 -0.009906
      0.000000 0.000000 0.000000 1.000000]

  % value matrix aligment - tester 
pb = mat(3,1)

% ============ Angeles values calculation segment ======================= 
b = -asind(mat(3,1))
c = asind(mat(3,2)/cosd(b))
a = asind(mat(2,1)/cosd(b))
gxyz_46_56 = [c b a]

b_b = -asind(B(3,1))
c_c = asind(B(3,2)/cosd(b_b))
a_a = asind(B(2,1)/cosd(b_b))

b_142 = -asind(rot_mat125_142(3,1))
c_142 = asind(rot_mat125_142(3,2)/cosd(b_142))
a_142 = asind(rot_mat125_142(2,1)/cosd(b_142))

% ================= x y z placement ====================================
gxyz_50_66 = [c_c b_b a_a]

gxyz_125_142 = [c_142 b_142 a_142]

tx = mat(1,4)
ty = mat(2,4)
tz = mat(3,4)

t_x = B(1,4)
t_y = B(2,4)
t_z = B(3,4)

f_x = rot_mat125_142(1,4)
f_y = rot_mat125_142(2,4)
f_z = rot_mat125_142(3,4)

% system error spec
err_const = 0.2
% ================ Data Vectors from csv files =========================== 
% ----------------------------------------------                
vec_rpy_46 = [-0.811919	0.491879	-96.264058]

vec_rpy_56 = [-0.894032	0.874318	-96.290286]

delta_vec_rpy_56_vec_rpy_46 = vec_rpy_56 - vec_rpy_46

delta_imu_velo_46_56 = delta_vec_rpy_56_vec_rpy_46 - gxyz_46_56
%-----------------------------------------------

vec_rpy_50 = [-0.827549	0.512714	-96.263757]

vec_rpy_66 = [-0.884442	0.871637	-96.302744]

delta_vec_rpy_66_vec_rpy_50 = vec_rpy_66 - vec_rpy_50

delta_imu_velo_50_66 = delta_vec_rpy_66_vec_rpy_50 - gxyz_50_66

%-----------------------------------------------
vec_rpy_125 = [0.02169	0.045296	-155.135794]

vec_rpy_142 = [-0.208262	-0.263029	-179.321207]

delta_vec_rpy_142_vec_rpy_125 = vec_rpy_142 - vec_rpy_125 

delta_imu_velo_142_125 = delta_vec_rpy_142_vec_rpy_125 - gxyz_125_142


%-----------------------------------------------
vec_rpy_356 = [-0.279984	0.07492	-165.881007]

vec_rpy_412 = [0.117685	0.990732	-119.694981]

delta_vec_rpy_412_vec_rpy_356 =  vec_rpy_412 - vec_rpy_356

% -----------------------------------------------
disp('simple delta:')

delta_prox_gap = delta_imu_velo_46_56 - delta_imu_velo_50_66

delta_prox_gap_125_142 = delta_vec_rpy_142_vec_rpy_125 - gxyz_125_142

disp('average delta:')

delta_imu_velo_46_56 = delta_vec_rpy_56_vec_rpy_46 - gxyz_46_56
delta_imu_velo_50_66 = delta_vec_rpy_66_vec_rpy_50 - gxyz_50_66
delta_imu_velo_125_142 = delta_imu_velo_142_125 - gxyz_125_142

avg_prox_gap = (delta_imu_velo_46_56 + delta_imu_velo_50_66)/2

% ============== Avarage velocity between time stamps ================
x_avg_velocity_46_56 = 0.3633
y_avg_velocity_46_56 = -0.001
z_avg_velocity_46_56 = -0.002

x_avg_velocity_50_66 = 1.194
y_avg_velocity_50_66 = 0.001
z_avg_velocity_50_66 = 0.005

x_avg_velocity_46_102 = 2.89
y_avg_velocity_46_102 = 0.012
z_avg_velocity_46_102 = 0.012

x_avg_velocity_125_142 = 4.502
y_avg_velocity_125_142 = 0.1794
z_avg_velocity_125_142 = 0.067

x_avg_velocity_356_416 = 2.569
y_avg_velocity_356_416 = 0.847
z_avg_velocity_356_416 = 0.0287

% ================= Time stamp align constants ==========================
time_46_56 = 1
time_50_66 = 1.61
time_46_102 = (102-46)*0.1
time_125_142 = (142-125)*0.1  %1.70
time_356_416 = (416-356)*0.1

% translation = distance
% ================== Distance calculation ================================
tx46_56_imu =  x_avg_velocity_46_56*time_46_56+(time_46_56*err_const)
tx50_66_imu = x_avg_velocity_50_66*time_50_66+(time_50_66*err_const)
tx46_102_imu = x_avg_velocity_46_102*time_46_102+(time_46_102*err_const)



total_velocity46_102 = (x_avg_velocity_46_102 + y_avg_velocity_46_102 + z_avg_velocity_46_102)
total_velocity125_142 = (x_avg_velocity_125_142 + y_avg_velocity_125_142 + z_avg_velocity_125_142)
total_velocity356_416 = (x_avg_velocity_356_416 + y_avg_velocity_356_416 + z_avg_velocity_356_416)

tx46_102_imu = x_avg_velocity_46_102*time_46_102+(time_46_102*err_const*(x_avg_velocity_46_102/total_velocity46_102))
ty46_102_imu = y_avg_velocity_46_102*time_46_102+(time_46_102*err_const*(y_avg_velocity_46_102/total_velocity46_102))
tz46_102_imu = z_avg_velocity_46_102*time_46_102+(time_46_102*err_const*(z_avg_velocity_46_102/total_velocity46_102))

tx125_142_imu = x_avg_velocity_125_142*time_125_142+(time_125_142*err_const*(x_avg_velocity_125_142/total_velocity125_142))
ty125_142_imu = y_avg_velocity_125_142*time_125_142+(time_125_142*err_const*(y_avg_velocity_125_142/total_velocity125_142))
tz125_142_imu = z_avg_velocity_125_142*time_125_142+(time_125_142*err_const*(z_avg_velocity_125_142/total_velocity125_142))

tx356_416_imu = x_avg_velocity_356_416*time_356_416+(time_356_416*err_const*(x_avg_velocity_356_416/total_velocity356_416))
ty356_416_imu = y_avg_velocity_356_416*time_356_416+(time_356_416*err_const*(y_avg_velocity_356_416/total_velocity356_416))
tz356_416_imu = z_avg_velocity_356_416*time_356_416+(time_356_416*err_const*(z_avg_velocity_356_416/total_velocity356_416))

 
vec_rpy102 =[-1.658617	0.642297	-95.004018]

% ====================== RESOLTS ==========================================
disp('____________RESOLTS:_____________')
d_rpy102_46 = vec_rpy102 - vec_rpy_46


gxyz_125_142
delta_vec_rpy_142_vec_rpy_125 = vec_rpy_142 - vec_rpy_125

delta_accurancy_imu = abs(delta_vec_rpy_142_vec_rpy_125)-abs(gxyz_125_142)

delta_vec_rpy_412_vec_rpy_356

vec_xyz_356_416 = [-tx356_416_imu -ty356_416_imu tz356_416_imu]



