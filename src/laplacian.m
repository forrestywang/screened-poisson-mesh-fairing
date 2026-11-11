% laplacian computes the discrete Laplace-Beltrami operator L and mass 
% matrix D for a 3D triangle mesh.
function [L, D] = laplacian(V, F)
    % Variables
    n = size(V, 1);
    m = size(F, 1);
    
    i1 = F(:,1); i2 = F(:,2); i3 = F(:,3);
    v1 = V(i1,:); v2 = V(i2,:); v3 = V(i3,:);
    
    % Calculations
    % Edge vectors opposite to each vertex
    e1 = v3 - v2;
    e2 = v1 - v3;
    e3 = v2 - v1;
    
    % Double triangle areas via cross product magnitude
    double_areas = vecnorm(cross(e2, -e3, 2), 2, 2);
    
    % Compute cotangents of angles using dot(u,v) / norm(cross(u,v))
    cot1 = dot(e2, e3, 2) ./ double_areas;
    cot2 = dot(e3, e1, 2) ./ double_areas;
    cot3 = dot(e1, e2, 2) ./ double_areas;
    
    % Assemble sparse cotangent weight matrix W
    ii = [i2; i3; i3; i1; i1; i2];
    jj = [i3; i2; i1; i3; i2; i1];
    s  = 0.5 * [cot1; cot1; cot2; cot2; cot3; cot3];
    
    W = sparse(ii, jj, s, n, n);
    W = max(W, W'); % Symmetric
    
    % Discrete Laplace-Beltrami operator L = D_w - W
    diags = sum(W, 2);
    L = sparse(1:n, 1:n, diags, n, n) - W;
    
    % Mass matrix D (1/3 of surrounding triangle areas per vertex)
    triangle_areas = double_areas / 2;
    vertex_areas = zeros(n, 1);

    for t = 1:m
        vertex_areas(F(t, 1)) = vertex_areas(F(t, 1)) + triangle_areas(t) / 3;
        vertex_areas(F(t, 2)) = vertex_areas(F(t, 2)) + triangle_areas(t) / 3;
        vertex_areas(F(t, 3)) = vertex_areas(F(t, 3)) + triangle_areas(t) / 3;
    end
    
    D = sparse(1:n, 1:n, vertex_areas, n, n);
end
