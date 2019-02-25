function swagccg_m2m_package()
    %% creates a redistributable zip
    %
    % Args: 
    %    opt (struct): has a struct object for each category.
    %                  currently: ``input``, ``client_dependencies``, ``output``
    %                   - ``input`` will be copied
    %                   - ``client_dependencies`` will be unzipped
    %                   - ``output`` will be target directory for the final zip
    %
    
    package_script_location = which('swagccg_m2m_package');
    p_root_path_master = fileparts(package_script_location);
    p_root_path = fileparts(p_root_path_master);

    dir_name = ['swagccg_m2m_dist', sprintf('_%d_%d', randi([10^6, 10^7], [1,2]))];
    tmp_path = fullfile(tempdir(), dir_name);
    sub_path = fullfile(tmp_path, 'swagccg_m2m');
    mkdir(tmp_path);
    mkdir(sub_path);
    
    package_content = {
        'README.md'
        'LICENSE'
        which('swagccg_m2m_uninstall');
        'swagccg/swagccg_m2m__init__.m'
        'swagccg/src';
        'swagccg/tests';
        'swagccg/examples';
        'swagccg/jsonlab_master';
        'swagccg/urlread2';
        'swagccg/urlread2_fragments';
     };
    
    zip_name = 'swagccg_m2m_static_bundle';
    zip(fullfile(tmp_path, zip_name), package_content, p_root_path_master);
    package_content = {
        which('swagccg_m2m_setup');
        fullfile(tmp_path, 'swagccg_m2m_static_bundle.zip');
     };
    zip_name_final = ['swagccg_m2m_dist_', datestr(now(), 'yyyymmdd_HH_MM_SS')];
    zip_path = fullfile(tmp_path, zip_name_final);
    zip(fullfile(p_root_path,'packages', zip_name_final), package_content, tmp_path);
    
    rmdir(tmp_path, 's');
    
end
