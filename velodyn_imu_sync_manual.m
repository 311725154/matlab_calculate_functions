function data_struct = velodyn_imu_sync_manual(trans_mat, m_time_stamp,imuFilePath,velodyne_1st_frame, vlodyne_2nd_frame)
% Author: Dennis - dennis.komarov@intel.com
% Version: 1
% Description: 
% C:\$work\free_ride\free_ride\free_ride (Frame 0125).csv
% 56104269080
% mat=[1.000000 0.000590 -0.000200 0.029279
% -0.000590 1.000000 -0.000125 -0.514763
% 0.000199 0.000125 1.000000 0.047628
% 0.000000 0.000000 0.000000 1.000000]
% Syntax: output = myFun(input)
% velodyn_imu_sync_manual(mat, 56104269080,'C:\$work\free_ride\free_ride\free_ride (Frame 0125).csv','C:\$work\free_ride\free_ride\free_ride (Frame 0125).csv','C:\$work\free_ride\free_ride\free_ride (Frame 0125).csv


% constants 
    imu_err = 0.2;
    frec_line_range = 0.6;
    DEBUGER = 0;

% variables
    velodyne_time_stamp_vector = ["0" "0"];
    data_struct = struct("velodyne_time_stamp",{0,0},"velodyne_imu_lines",{0,0},"rottation_mat",mat,"rottation_angels",{0,0,0},"move_xyz_coordinates",{0,0,0},"velodyne_frame_RPY_vectors",{[0 0 0],[0 0 0]},"delta_imu_velodyne_rottation_measurement",[0 0 0],"imu_avarage_RPY_velocity",{0,0,0},"imu_frames_average_velocity_vector",[0 0 0],"delta_accurancy_imu_vector",[0 0 0],"distance_translation_vector",[0 0 0]);
    sorce_str_vec = [velodyne_1st_frame ,vlodyne_2nd_frame]; 

    if trans_mat ~= NaN
        % rottation angels
        beta = -asind(trans_mat(3,1));
        gama = asind(trans_mat(3,2)/cosd(beta));
        alpha = asind(trans_mat(2,1)/cosd(beta));

        data_struct(1).rottation_angels = alpha;
        data_struct(2).rottation_angels = beta;
        data_struct(3).rottation_angels = gama;

        % movement coordinats 
    
        data_struct(1).move_xyz_coordinates = trans_mat(1,4);
        data_struct(2).move_xyz_coordinates = trans_mat(2,4);
        data_struct(3).move_xyz_coordinates = trans_mat(3,4);

        data_struct(1).rottation_mat = trans_mat;
    else
        disp("Error: rottation matrix not valid");
        exit(0);
    end
    % open IMU file and find the start of motion time stamp
    %==== 


    % open first velodyne file and get the first line time stamp
    parfor i = 1:length(sorce_str_vec)
        if (DEBUGER==1)
            disp(sorce_str_vec(1,i));
        end
        table = readtable(sorce_str_vec(1,i));
        rows = table.adjustedtime;
        data_struct(i).velodyne_time_stamp = rows(1,1);
        
    end

    if (DEBUGER==1)
        disp(velodyne_time_stamp_vector);
    end

    % translate the imu time stamp to utc time with decimal accurancy
    parfor i=1:2
        if isa(data_struct(i).velodyne_time_stamp,'double')
        
            % initializig external variable
            micro_time_stamp = data_struct(i).velodyne_time_stamp;

            % hours calculation
            hour_raw = floor(micro_time_stamp/1000000/3600);
    
            % minutes calculation
            minute_raw = floor((micro_time_stamp- hour_raw*1000000*3600)/1000000/60);
    
            % seconds calculation
            second_raw = floor((micro_time_stamp - (hour_raw*1000000*3600) - (minute_raw)*1000000*60)/1000000);
    
            % miliseconds calculation
            miliseconds_raw = round((micro_time_stamp - (hour_raw*1000000*3600) - ((minute_raw)*1000000*60) - (second_raw*1000000))/10000);

            % zero decimal correction to string snity
            if (miliseconds_raw<10)
                miliseconds_to_str = "0"+string(miliseconds_raw); 
            else
                miliseconds_to_str = string(miliseconds_raw);  
            end

    
            % full stamp calculation and conversation to string valid time stamp - as reqiered in csv file distribution
            time_stamp = string(hour_raw)+':'+string(minute_raw)+':'+string(second_raw)+':'+miliseconds_to_str;

            % apply for real file format
            data_struct(i).velodyne_time_stamp = time_stamp;
        else
            disp('Error: invalid variable type')
            time_stamp = 0;
            quit(0); 
        end
        
    

        % time stamp adjustment for IMU file format
        adj_stamp = "";
        tune_digit = -1;
        if time_stamp =~ 0
            raw_str = split(data_struct(i).velodyne_time_stamp,":");
            m_tune = raw_str(3);
            digit = split(m_tune,"");
            stamp_digit = digit(2);
            tune_digit = str2num(digit(3));
            adj_stamp = raw_str(1)+":"+raw_str(2)+":"+stamp_digit; 
        else
            adj_stamp = "";
            disp('Error: Not valid time stamp receivd');
            exit(0);
        end
    
       

        % open imu file and search for explicit instance of given time stamp
        table_imu = readtable(imuFilePath);
        stamp_line = 0;

        for l=3:length(imu_table.(2))
            if strcmpi(imu_table.(2)(l:l),{adj_stamp});
                
                % line spec tuning 
                data_struct(i).velodyne_imu_lines = l + ceil(frec_line_range*tune_digit);
                
                % RPY vector update
                data_struct(i).velodyne_frame_RPY_vectors =  [imu_table.(5)(data_struct(i).velodyne_imu_lines:data_struct(i).velodyne_imu_lines) imu_table.(6)(data_struct(i).velodyne_imu_lines:data_struct(i).velodyne_imu_lines) imu_table.(7)(data_struct(i).velodyne_imu_lines:data_struct(i).velodyne_imu_lines)] ;
                
            
                break;
            end
        end
        
        

    end


    % delta INU velodyne rottation measurments
    data_struct(1).delta_imu_velodyne_rottation_measurement = (data_struct(2).velodyne_frame_RPY_vectors - data_struct(1).velodyne_frame_RPY_vectors) -[data_struct(1).rottation_angels data_struct(2).rottation_angels data_struct(3).rottation_angels];


    % average velocity between time stamps
    time_align_coficient = (data_struct(2).velodyne_imu_lines - data_struct(1).velodyne_imu_lines)*0.1;

    table_avg_calc = readtable(imuFilePath);

    arr_x = [];
    arr_y = [];
    arr_z = [];

    for idx = data_struct(1).velodyne_imu_lines:data_struct(2).velodyne_imu_lines
        arr_x = [arr_x, table_avg_calc.(12)(idx:idx)];
        arr_y = [arr_y, table_avg_calc.(13)(idx:idx)];
        arr_z = [arr_z, table_avg_calc.(14)(idx:idx)];
    end

    data_struct(1).imu_frames_average_velocity_vector = [ mean(arr_x,'all') mean(arr_y,'all') mean(arr_z,'all')];
    
    % delta_accurancy_imu_vector_calculation
    data_struct(1).delta_accurancy_imu_vector = abs(data_struct(2).velodyne_frame_RPY_vectors - data_struct(1).velodyne_frame_RPY_vectors)-abs([data_struct(1).rottation_angels data_struct(2).rottation_angels data_struct(3).rottation_angels]);

    % translation calculation - normal calculation
    data_struct(1).distance_translation_vector = [data_struct(1).imu_frames_average_velocity_vector(1)*time_align_coficient+(time_align_coficient*imu_err*(data_struct(1).imu_frames_average_velocity_vector(1)/sum(data_struct(1).imu_frames_average_velocity_vector))) data_struct(1).imu_frames_average_velocity_vector(2)*time_align_coficient+(time_align_coficient*imu_err*(data_struct(1).imu_frames_average_velocity_vector(2)/sum(data_struct(1).imu_frames_average_velocity_vector))) data_struct(1).imu_frames_average_velocity_vector(3)*time_align_coficient+(time_align_coficient*imu_err*(data_struct(1).imu_frames_average_velocity_vector(3)/sum(data_struct(1).imu_frames_average_velocity_vector)))];

   

    data_struct
    
end