% LOAD_MESH Loads a 3D surface mesh from a PLY file. V is an n×3 matrix, 
% where n is the number of vertices and row i contains the (x, y, z)
% coordinates of vertex i. F is an m×3 matrix, where m is the number of 
% faces and row i contains the list vertex indices connecting the face.
function [V, F] = load_mesh(filename)
    % Check compatibility
    if ~isfile(filename)
        error("File not found: %s", filename);
    end
    
    [~, ~, ext] = fileparts(filename);
    if ~strcmpi(ext, ".ply")
        error("Unsupported file format %s. Only .ply files are supported.", ext);
    end
    
    % Output
    mesh = readSurfaceMesh(filename);
    V = double(mesh.Vertices);
    F = double(mesh.Faces);
    
    fprintf("Loaded successfully: %d vertices, %d faces\n", size(V, 1), size(F, 1));
end