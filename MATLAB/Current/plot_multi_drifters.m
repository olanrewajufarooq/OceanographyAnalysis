function [drifters] = plot_multi_drifters(longs, lats, deploy_times, recov_times, depth, model_data)
%PLOT_TRAJECTORY Summary of this function goes here
%   Detailed explanation goes here

% CONSTANTS
R = 6370; % Radius of Earth (in km)

start_time = min(datenum(datetime(deploy_times, "InputFormat", "yyyy-MM-dd HH:mm:ss")));
end_time = max(datenum(datetime(recov_times, "InputFormat", "yyyy-MM-dd HH:mm:ss")));

dt = datenum(datetime("2020-01-01 00:05:00", "InputFormat", "yyyy-MM-dd HH:mm:ss")) - datenum(datetime("2020-01-01 00:0:00", "InputFormat", "yyyy-MM-dd HH:mm:ss"));

% Specify the Depth

if depth == 0.0
    depth_val = 1;
elseif depth == 0.6
    depth_val = 2;
elseif depth == 1.0
    depth_val = 3;
end

% Initialize Output

for i = 1:length(longs)
    drifters(i).LONG(1) = longs(i);
    drifters(i).LAT(1) = lats(i);
    drifters(i).deploy_time = datenum(deploy_times(i));
    drifters(i).recov_time = datenum(recov_times(i));
    drifters(i).coasted = false;
    drifters(i).recovered = false;
    drifters(i).plot_mode = false;
    drifters(i).plot_start_index_checked = false;
end

% Obtain Necessary data

T_model = model_data.time;
U_model = model_data.U_current; V_model = model_data.V_current;
LONG_data = model_data.xx; LAT_data = model_data.yy;

% Plot Data

figure(1)

quiverplot = quiver(LONG_data, LAT_data, U_model(:, :, depth_val, 1), V_model(:, :, depth_val, 1), "Color", "b");
xlabel("Longitudes")
ylabel("Latitude")
hold on

T = start_time:dt:end_time;
time_text = text(5.955, 43.125, "Current time: ");

for t = 1:length(T)-1

    current_time = T(t);
    time_t = "Current time: " + datestr(datetime(current_time, "ConvertFrom", "datenum"));
    delete(time_text); time_text = text(5.955, 43.125, time_t);

    for i = 1:length(longs)
        if (current_time > drifters(i).deploy_time) && (current_time < drifters(i).recov_time)
            drifters(i).plot_mode = true;
            if ~drifters(i).plot_start_index_checked
                drifters(i).plot_start_index = t;
                drifters(i).plot_start_index_checked = true; 
            end
        else
            drifters(i).plot_mode = false;
        end
    end

    U_permuted = interp1(T_model, permute(U_model, [4, 1, 2, 3]), current_time);
    U = permute(U_permuted, [2, 3, 4, 1]);
    V_permuted = interp1(T_model, permute(V_model, [4, 1, 2, 3]), current_time);
    V = permute(V_permuted, [2, 3, 4, 1]);

    for i = 1:length(longs)
        if drifters(i).plot_mode
            plot( drifters(i).LONG(t), drifters(i).LAT(t), 'or' )
            hold on
        end
    end

    delete(quiverplot)
    quiverplot = quiver( LONG_data, LAT_data, U(:, :, depth_val), V(:, :, depth_val), "Color", "b");

    for i = 1:length(longs)
        if drifters(i).plot_mode
            plot( drifters(i).LONG(drifters(i).plot_start_index:end), drifters(i).LAT(drifters(i).plot_start_index:end), 'k', 'MarkerSize', 12, 'LineWidth', 2)
            hold on
        end
    end
    
	dt = T(t+1) - T(t);

    for i = 1:length(longs)
        if drifters(i).coasted || drifters(i).recovered
            drifters(i).LONG(t+1) = drifters(i).LONG(t);
            drifters(i).LAT(t+1) = drifters(i).LAT(t);
            continue
        end

        u = interp2( LAT_data, LONG_data, U(:, :, depth_val), drifters(i).LAT(t), drifters(i).LONG(t) );
        v = interp2( LAT_data, LONG_data, V(:, :, depth_val), drifters(i).LAT(t), drifters(i).LONG(t) );

        drifters(i).LONG(t+1) = drifters(i).LONG(t) + (dt * 60 * 60)* u / abs(R * cos(drifters(i).LAT(t)));
        drifters(i).LAT(t+1) = drifters(i).LAT(t) + (dt * 60 * 60)* v / abs(R * cos(drifters(i).LAT(t)));
    end 
    
    

    pause(0.3)

    for i = 1:length(longs)
        if drifters(i).coasted || drifters(i).recovered 
            continue
        end
        
        long_diff = drifters(i).LONG(t+1) - drifters(i).LONG(t); 
        lat_diff = drifters(i).LAT(t+1) - drifters(i).LAT(t);

        if ((long_diff == 0) && (lat_diff == 0)) && ~drifters(i).coasted
            disp("The drifter " + num2str(i) + " has reached the coast and has been recovered")
            drifters(i).coasted = true;
            drifters(i).recovered = true;
            break
        end
    end

    if (length(longs) - sum([drifters.recovered]) == 0)
        disp("All drifters recovered.")
        break
    end

end

end

