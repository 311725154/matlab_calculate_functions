function time_stamp = convert_microsecond(adj_time)
% Author: Dennis - dennis.komarov@intel.com
% Verssion: 2 , BUG of decimal microseconds representatopn fixed
% Description: convert_microsecond - Gets as a parameter double integer means the GPS time in microseconds and converts it to work valid time stamp for validation team internal use
%              the algorithm is fully compitable to www.convert-me.com - calculator that we used so far.
%              The development preformed on back engineering to up mentioned web calculator algorithm.
%
% Syntax: convert_microsecond(adj_time)
% ===================================================================================================================================================================================
%                                                                    START OF CODE 
if isa(adj_time,'double')


    % hours calculation
    hour_raw = floor(adj_time/1000000/3600);

    % minutes calculation
    minute_raw = floor((adj_time- hour_raw*1000000*3600)/1000000/60);

    % seconds calculation
    second_raw = floor((adj_time - (hour_raw*1000000*3600) - (minute_raw)*1000000*60)/1000000);

    % miliseconds calculation
    miliseconds_raw = round((adj_time - (hour_raw*1000000*3600) - ((minute_raw)*1000000*60) - (second_raw*1000000))/10000);

    % zero decimal correction to string snity
    if (miliseconds_raw<10)
         miliseconds_to_str = "0"+string(miliseconds_raw); 
    else
        miliseconds_to_str = string(miliseconds_raw);  
    end


    % full stamp calculation and conversation to string valid time stamp - as reqiered in csv file distribution
    time_stamp = string(hour_raw)+':'+string(minute_raw)+':'+string(second_raw)+':'+miliseconds_to_str
else
    disp('invalid variable type')
    time_stamp = 0 
end
%                                                                    END OF CODE 
end

