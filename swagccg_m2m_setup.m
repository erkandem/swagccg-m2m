function swagccg_m2m_setup()
    %% will install the package and dependencies on the :func:`userpath()`
    %
    %  1. suggest a target directory and let you confirm or change it
    %  2. unpack swagccg_m2m into the confirmed location
    %  3. add the path and supaths to the MATLAB searchpath
    %  4. finally, save your current MATLAB searchpath
    %
    %
    
    % suggest a installation path
    install_path    =  fullfile(userpath(), 'swagccg_m2m');
    opt.Interpreter = 'tex';
    opt.Resize      = 'on';
    prompt = ['\fontsize{12} swagccg_m2m will be installed here ',... 
              '(will be created if it doesn`t exist)'];
    
    install_path = inputdlg(...
        prompt, ...         % question
        'Setup', ...        % window title
        [1 90], ...         % window size
        {install_path}, ... % suggestion
        opt);               % styling options
    
    install_path = install_path{1};      % cast from cell
    
    if exist(install_path, 'dir') ~= 7  
        mkdir(install_path)
    end
    
    unzip('swagccg_m2m_static_bundle.zip', install_path);
    addpath(genpath(install_path));
    savepath();
    
    
    fprintf('%s\n', 'Done. swagccg_m2m was installed in:')
    fprintf('%s\n', install_path);
    fprintf('%s\n', ' ');
    fprintf('%s\n', '<strong>Next Steps:</strong>');
    fprintf('%s\n', '<strong>Create a Client for the ``PetStore``:</strong>');
    fprintf('%s\n', ' ');
    fprintf('%s\n', 'mkdir(''playground'');');
    fprintf('%s\n', 'cd(''playground'');');
    fprintf('%s\n', 'confi_path = fullfile(fileparts(which(''swagccg_m2m__init__'')), ''examples'', ''example_confi.json'' );');
    fprintf('%s\n', 'swagccg_m2m(confi_path)');
    fprintf('%s\n', ' ');
    fprintf('%s\n', ' ');
    fprintf('%s\n', '<strong>Client Usage:</strong>');
    fprintf('%s\n', ' ');
    fprintf('%s\n', 'Usage can be seen in test_petstore_play_book located:');
    fprintf('%s\n', which('test_petstore_play_book'));
    
end
