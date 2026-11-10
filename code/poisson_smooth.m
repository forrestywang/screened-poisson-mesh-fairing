% poisson_smooth exports a simulation of mesh fairing by solving the
% Screened Poisson equation. For each frame, we solve the system for a new 
% value of the smoothing parameter α. The α values are logarithmically 
% spaced in [3, 0.001]. The exported video's format is MP4 with the desired
% FPS and duration.
function poisson_smooth(filename, output, fps, secs)
    % Variables
    [V, F] = load_mesh(filename);
    [L, D] = laplacian(V, F);
    D = D / mean(diag(D));

    frames = fps * secs;
    alphas = logspace(log10(3) / 2, -3, frames);
    
    if min(diag(L)) < 0
        L = -L; % PSD
    end
    
    % Plot
    fig = figure(Color = [0.1, 0.1, 0.1], Position = [100, 100, 800, 600]);
    ax = axes(Parent = fig, Color = [0.1, 0.1, 0.1]);
    h_plot = trisurf(F, V(:,1), V(:,2), V(:,3), ...
        Parent = ax, ...
        EdgeColor = "none", ...
        FaceColor = [0.8 0.8 0.8]);
    axis equal tight off; view(2); camlight; lighting gouraud; % view(...) controls the viewing angle
    
    % Open VideoWriter
    v_writer = VideoWriter(output + ".mp4", "MPEG-4");
    v_writer.FrameRate = fps;
    open(v_writer);
    
    fprintf("Starting animation export (%d frames)...\n", frames);

    % Compute frames
    tic;
    for i = 1:frames
        % Solve system
        alpha = alphas(i)^2;
        A = alpha * D + L;
    
        for c = 1:3
            b = alpha * D * V(:, c);
            V(:, c) = A \ b;
        end
    
        % Update plot, write frame to video
        h_plot.Vertices = V;
        title(sprintf("Screened Poisson Smoothing"), ...
            FontSize = 14, ...
            Color = "w", ...
            FontWeight = "bold");
        subtitle(ax, sprintf("\x03B1 = %.6f", alpha), Color = "w");
        drawnow;
        writeVideo(v_writer, getframe(fig));
        
        fprintf("Frame %d/%d | \x03B1 = %.6f | %d seconds elapsed\n", ...
            i, frames, alpha, round(toc));
    end
    
    % Close VideoWriter
    mins = toc / 60;
    close(v_writer);
    fprintf("----------\n");
    fprintf("VIDEO EXPORT COMPLETE! Runtime: %.2f minutes\n", mins);
end