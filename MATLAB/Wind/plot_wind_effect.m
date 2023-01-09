function drifters = plot_wind_effect(drifter_data, considered_drifters, wind_data, pause_seconds);
%PLOT_TRAJECTORY Summary of this function goes here
%   Detailed explanation goes here

% Drifter Data
for i = 1:length(considered_drifters)
    pos = find([drifter_data.name] == considered_drifters(i))

    drifters(i).T_data = [drifter_data(pos).Times];
    drifters(i).LAT_data = [drifter_data(pos).Lats];
    drifters(i).LONG_data = [drifter_data(pos).Longs];
    

    drifters(i).LONG = [];
    drifters(i).LAT = [];

    drifters(i).deploy_time = drifters(i).T_data(1);
    drifters(i).recov_time = drifters(i).T_data(end);

    drifters(i).coasted = false;
    drifters(i).recovered = false;
    drifters(i).plot_mode = false;

end

% Wind Data
T_model = wind_data.time;
U_model = wind_data.U_Arome; V_model = wind_data.V_Arome;
LONG_data = wind_data.XX; LAT_data = wind_data.YY;

% Initialize Quiver Plot
figure(1)

quiverplot = quiver(LONG_data, LAT_data, U_model(:, :, 1), V_model(:, :, 1), "Color", "b");
xlabel("Longitudes")
ylabel("Latitude")
hold on

% Simulation Timing
start_time = min([drifters.deploy_time]);
end_time = max([drifters.deploy_time]);

dt = datenum(datetime("2020-01-01 00:01:00", "InputFormat", "yyyy-MM-dd HH:mm:ss")) - datenum(datetime("2020-01-01 00:0:00", "InputFormat", "yyyy-MM-dd HH:mm:ss"));


T = start_time:dt:end_time;
time_text = text(5.955, 43.135, "Current time: ");

for t = 1:length(T)-1

    current_time = T(t);
    time_t = "Current time: " + datestr(datetime(current_time, "ConvertFrom", "datenum"));
    delete(time_text); time_text = text(5.955, 43.135, time_t);

    for i = 1:length(drifters)
        if (current_time > drifters(i).deploy_time) && (current_time < drifters(i).recov_time)
            drifters(i).plot_mode = true;
        else
            drifters(i).plot_mode = false;
        end
    end

    U_permuted = interp1(T_model, permute(U_model, [3, 1, 2]), current_time);
    U = permute(U_permuted, [2, 3, 1]);
    V_permuted = interp1(T_model, permute(V_model, [3, 1, 2]), current_time);
    V = permute(V_permuted, [2, 3, 1]);

    for i = 1:length(drifters)
        if drifters(i).plot_mode
            long  = interp1(drifters(i).T_data, drifters(i).LONG_data, current_time);
            lat  = interp1(drifters(i).T_data, drifters(i).LAT_data, current_time);

            plot( long, lat, 'or' )
            
            drifters(i).LONG(end+1) = long;
            drifters(i).LAT(end+1) = lat;

            hold on
        end
    end

    delete(quiverplot)
    quiverplot = quiver( LONG_data, LAT_data, U(:, :), V(:, :), "Color", "b");

    for i = 1:length(drifters)
        if drifters(i).plot_mode
            plot( drifters(i).LONG, drifters(i).LAT, 'k', 'MarkerSize', 12, 'LineWidth', 2)
            hold on
        end
    end

    pause(pause_seconds)

end

end

