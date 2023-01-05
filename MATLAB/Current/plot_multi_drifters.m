function [drifters] = plot_multi_drifters(longs, lats, depth, model_data)
%PLOT_TRAJECTORY Summary of this function goes here
%   Detailed explanation goes here

% Specify the Depth

if strcmp(depth, "Surface")
    depth_val = 1;
elseif strcmp(depth, "60cm Depth")
    depth_val = 2;
elseif strcmp(depth, "1m Depth")
    depth_val = 3;
end

% Initialize Output

for i = 1:length(longs)
    drifters(i).LONG(1) = longs(i);
    drifters(i).LAT(1) = lats(i);
    drifters(i).coast_check = true;
end

% Obtain Necessary data

T = model_data.time;
U = model_data.U_current; V = model_data.V_current;
LONG_data = model_data.xx; LAT_data = model_data.yy;



% Plot Data

figure(1)

quiverplot = quiver(LONG_data, LAT_data, U(:, :, depth_val, 1), V(:, :, depth_val, 1), "Color", "b");
xlabel("Longitudes")
ylabel("Latitude")
hold on

for t = 1:length(T)-1
    for i = 1:length(longs)
        plot( drifters(i).LONG(t), drifters(i).LAT(t), 'or' )
        hold on
    end

    delete(quiverplot)
    quiverplot = quiver( LONG_data, LAT_data, U(:, :, depth_val, t), V(:, :, depth_val, t), "Color", "b");

    for i = 1:length(longs)
        plot( drifters(i).LONG, drifters(i).LAT, 'k', 'MarkerSize', 12, 'LineWidth', 2)
        hold on
    end
    
    
	dt = T(t+1) - T(t);

    for i = 1:length(longs)
        u = interp2( LAT_data, LONG_data, U(:, :, depth_val, t), drifters(i).LAT(t), drifters(i).LONG(t) );
        v = interp2( LAT_data, LONG_data, V(:, :, depth_val, t), drifters(i).LAT(t), drifters(i).LONG(t) );
        
        drifters(i).LONG(t+1) = drifters(i).LONG(t) + dt * u;
        drifters(i).LAT(t+1) = drifters(i).LAT(t) + dt * v;
    end 
    
    

    pause(1)

    for i = 1:length(longs)
    
        long_diff = drifters(i).LONG(t+1) - drifters(i).LONG(t); 
        lat_diff = drifters(i).LAT(t+1) - drifters(i).LAT(t);

        if ((long_diff == 0) || (lat_diff == 0)) && drifters(i).coast_check
            disp("The drifter " + num2str(i) + " has reached the coast")
            drifters(i).coast_check = false;
            break
        end
    end
end

end

