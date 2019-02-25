function package_swagccg_m2m_client(opt)
    %% creates a redistributable zip
    %
    % Args: 
    %    opt (struct): has a struct object for each category.
    %                  currently: ``input``, ``client_dependencies``, ``output``
    %                   - ``input`` will be copied
    %                   - ``client_dependencies`` will be unzipped
    %                   - ``output`` will be target directory for the final zip
    % 
    
    dir_name = ['swagccg_m2m', sprintf('_%d_%d', randi([10^6, 10^7], [1,2]))];
    tmp_path = fullfile(tempdir(), dir_name);
    sub_path = fullfile(tmp_path, 'swagccg_m2m_client');
    mkdir(tmp_path);
    mkdir(sub_path);
    
    fn = fieldnames(opt.input);
    for i = 1 : numel(fn)
        copyfile(opt.input.(fn{i}), sub_path, 'f');
    end
    
    unzip(opt.client_dependencies, sub_path);
    zip_name = ['swagccg_m2m_client_', datestr(now(), 'yyyymmdd_HHMMSS')];
    zip_path = fullfile(opt.output, zip_name);
    zip(zip_path, sub_path);
    rmdir(tmp_path, 's');
    
end
