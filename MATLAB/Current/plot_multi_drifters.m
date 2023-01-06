function [drifters] = plot_multi_drifters(longs_sim, lats_sim, depth, model_data, deploy_longs, deploy_lats, deploy_time, ret_time, dt )
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
    
    for i = 1:length(longs_sim)
        drifters(i).LONG(1) = longs_sim(i);
        drifters(i).LAT(1) = lats_sim(i);
        drifters(i).coast_check = true;
    end
    
    % Obtain Necessary data
    
    T = model_data.time;  z = 0:1: length(T)-1 ; 
    U = model_data.U_current; V = model_data.V_current; 
    LONG_data = model_data.xx; LAT_data = model_data.yy;
    
    % creating 3D mesh data
    [y_grid, x_grid, z_grid] = meshgrid(LAT_data(:,1), LONG_data(1,:),z) ;
    
    U_mesh = squeeze(U(:,:,depth_val,:)) ;
    V_mesh = squeeze(V(:,:,depth_val,:)) ;
    % unit conversions 
    m2deg_long = 78567 ;
    m2deg_lat  = 110000 ;
    h_s = 60*60 ;
    
    long_conv = h_s/ m2deg_long ;
    lat_conv = h_s/ m2deg_lat ;
    % Plot Data
    
    figure(1)
    
    quiverplot = quiver(LONG_data, LAT_data, U(:, :, depth_val, 1), V(:, :, depth_val, 1), "Color", "b");
    xlabel("Longitude")
    ylabel("Latitude")
    hold on
    
    t_range = deploy_time: dt: ret_time ; 
    
    for t = 1: length(t_range) 
        for i = 1:length(longs_sim)
            plot( drifters(i).LONG(t), drifters(i).LAT(t), 'or' )
            hold on
        end
    
        
    
        for i = 1:length(longs_sim)
            plot( drifters(i).LONG, drifters(i).LAT, 'k', 'MarkerSize', 12, 'LineWidth', 2)
            hold on
        end
        
        
        %dt = T(t+1) - T(t);
    
        for i = 1:length(longs_sim)
            u = interp3( y_grid, x_grid, z_grid, U_mesh , drifters(i).LAT(t), drifters(i).LONG(t),t_range(t) );
            v = interp3( y_grid, x_grid, z_grid, V_mesh , drifters(i).LAT(t), drifters(i).LONG(t),t_range(t) );
            
            drifters(i).LONG(t+1) = drifters(i).LONG(t) + dt * u * long_conv;
            drifters(i).LAT(t+1) = drifters(i).LAT(t) + dt * v * lat_conv;
        end 
        delete(quiverplot)
        % slicing through the 3d grid to get velocity layer at certain time
        
        u = interp3( y_grid, x_grid, z_grid, U_mesh , LAT_data(:,1), LONG_data(1,:),t_range(t) );
        v = interp3( y_grid, x_grid, z_grid, V_mesh , LAT_data(:,1), LONG_data(1,:),t_range(t) );
        quiverplot = quiver( LONG_data, LAT_data, u,v, "Color", "b");
        
    
        pause(1)
    
        for i = 1:length(longs_sim)
        
            long_diff = drifters(i).LONG(t+1) - drifters(i).LONG(t); 
            lat_diff = drifters(i).LAT(t+1) - drifters(i).LAT(t);
    
            if ((long_diff == 0) || (lat_diff == 0)) && drifters(i).coast_check
                disp("The drifter " + num2str(i) + " has reached the coast")
                drifters(i).coast_check = false;
                break
            end
        end
    end
    
    
    for i = 1:length(longs_sim)
        plot( deploy_longs(:,i), deploy_lats(:,i), 'g', 'MarkerSize', 12, 'LineWidth', 2)
    end

end

