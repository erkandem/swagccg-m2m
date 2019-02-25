function swagccg_m2m_uninstall()
    install_path = fileparts(which('swagccg_m2m__init__'));
    if numel(install_path) > 0 
        try
            rmpath(genpath(fileparts(install_path)));
            fprintf('swagccg_m2m was successfully removed from the MATLAB searchpath');
            savepath();
            fprintf('%s\n', ' ');          
            ask_to_remove_folder(install_path);
            fprintf('%s\n', 'uninstall script still present within:');
            fprintf('%s\n', ' ');          
            fprintf('%s\n', fileparts(install_path));
        catch ME
            fprintf('%s\n', ME.message);
        end
    else
        fprintf('%s\n',  'swagccg_m2m could <strong>NOT</strong> be removed from the MATLAB searchpath');
        fprintf('%s\n', 'the command to locate the installation folder failed.');
        fprintf('%s\n', '>> which(''swagccg_m2m__init__'')');
        fprintf('%s\n', 'The default location was set to be on userpath().');
        fprintf('%s\n', '>> userpath()');
    end
end

function ask_to_remove_folder(install_path)
    q = sprintf('remove files located in: ?\n\n%s\n', install_path);
    a = questdlg(q, ...
                      'Remove swagccg_m2m completly', ...
                        'yes', 'no', 'no');
    switch a
        case 'yes'
            rmdir(install_path, 's');
        case 'no'
            fprintf('%s\n', 'files are still present within:');
            fprintf('%s\n', install_path);
    end
end
