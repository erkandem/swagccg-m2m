function swagccg_m2m(confi_path)
    %% renders ``swagger.json`` and ``confi.json`` to a client
    %
    % Args:
    %    confi_path: optional path to a configuration json file :ref:`confi.json`
    %
    % .. todo:: be more granular on the used templates(i.e. addpath(), login()
    %          .. code:: matlab
    %       
    %             % i.e.
    %             client_imports = client_imports_f();
    %             client_point_of_execution = client_point_of_execution_f();
    %             
    % .. todo:: complete packaging
    % .. todo:: setup script
    % .. todo:: client setup script
    
    %% read in the configuration file
    if nargin == 0
        dir_path = pwd();
        confi_path = fullfile(dir_path, 'confi.json');
    end
    
    c = save_fread_f(confi_path);
    c = jsondecode(c);
    
    %% decode the modified JSON to MATLAB datatyps
    script_dir = fileparts(which('main_logic_f.m'));
    swagger_data = load_swagger_f(c.swagger_path);
     
    %% create methods code
    methods_list = create_methods_code_f(swagger_data);
    client_methods = {' '};
    for i = 1 : numel(methods_list)
        client_methods = [client_methods; methods_list{i}];
    end

    %% read in the template
    header_str = client_imports_f();
    template = read_in_template_f();

    %% rename class
    classdef_line = {['classdef ', c.class_name, ' < handle ']};
    s = mustache_scanner_f(template, 'classname');
    template(s.start) = classdef_line;

    %% render the constructor
    constructor_def_line = {['        function self = ', c.class_name,'(deployment)']};
    s = mustache_scanner_f(template, 'constructor_def');
    template(s.start) = constructor_def_line;

    c.base_path = swagger_data.basePath;
    s = mustache_scanner_f(template, 'constructor');
    codelet = render_constructor_f(c);
    template = [template(1 : (s.start-1));
                codelet;
                template((s.end_ind + 1) : end)];
    s = mustache_scanner_f(template, 'methods');

    %% compose the various parts
    all_in_one = [header_str;
                  template(1 : (s.start-1));
                  client_methods;
                  template((s.start + 1) : end)];

    %% create client code file and directory

    [target_dir, ~, ~] = fileparts(c.target_path);
    if ~isempty(target_dir)
        if exist(target_dir, 'dir') ~= 7
            mkdir(target_dir);
        end
    end   
    is_ok = utf8_write_to_file_f(c.target_path, all_in_one);
    
    %% packaging the client (not yet properly implements)
    do_package = false;
    if do_package
        if is_ok
            package_opt = struct(); 
            package_opt.input.client = c.target_path;
            package_opt.client_dependencies = which('swagccg_m2m_client_dependencies.zip');
            % package_opt.input.setup = ...
            % package_opt.input.license =  ...
            % package_opt.input.readme = ...
            % ...

            package_opt.output = target_dir;
            package_swagccg_m2m_client(package_opt),
        else
            fprintf('Could not write file. Skipping packaging.\n')
        end
    end
    
end


function header_str = client_imports_f()
    %% create a header for the client class file
    %
    % Returns:
    %    header_str (nx1 cell): warnings, disclaimer, timestamp etc.
    %

    time_stamp = time_stamp_f();
    header_str = {...
    ['% auto-generated ', time_stamp];
    ['% ... using [swagccg_m2m](https://erkandem.github.io/swagccg_m2m)'];
    ['% DO NOT MODIFY THIS FILE.'];
    ['% Your changes will be lost! Edit the template'];
    ['% {e.g. your message }  '];
    ['%  '];
    ['        '];
    };

end


function method_cellstr = client_method_template_f(confi)
    %% create a method from details of ressource
    % publicly exposed method which will accept path, query body and header 
    % parameters or inputs. Depending on the web API, certain parameters
    % may be omitted using ``[]`` within the call
    % 
    % Returns:
    %    method_cellstr (nx1 cell): method ready to append
    %                               ``method_cellstr`` depends on :ref:`do_call`
    %    
    %
    
    s = confi;
    fns = fieldnames(s);
    if ~ismember('doc', fns)
        s.('doc') =  {'            '};
    end

    path_param_str = ' ';
    endpoint = ['            endpoint = ''', s.api_end_point, ''';'];
    method_def_str = ['        function r = ', s.method_name, '(self, fields, body, headers)'];

    % thread for path parameters
    matches = regexp(s.api_end_point, '[{]{1}[a-zA-Z_0-9-]+[}]{1}', 'match');
    if ~isempty(matches)
        debraced = regexprep(matches, '[{}]', '');
        path_param_str = strjoin(debraced, ', ');

        for i = 1 : numel(debraced)
            s.api_end_point = strrep(s.api_end_point, matches{i}, '%s');
            if i == numel(debraced)
                s.api_end_point  = [s.api_end_point]; % do sth
            end
        end
        method_def_str = ['        function r = ', s.method_name, '(self, ', path_param_str, ', fields, body, headers)'];
        endpoint = ['            endpoint = sprintf(''', s.api_end_point, ''', ', path_param_str, ');'];
    end
 
    method_cellstr = [...
        {method_def_str}
        {['            %% ', s.doc_string,' ']}
                             s.doc
        {['            ']}
        {endpoint}
        {['            methdod = ''', upper(s.http_verb),''';']}
        {['            if ~exist(''headers'', ''var'')']}
        {['                headers = struct();']}
        {['            end']}
        {['            ']}
        {['            q_string  = '''';']}
        {['            if exist(''fields'', ''var'')']}
        {['                if ~isempty(fields)']}
        {['                    [q_string, ~] = self.param_formatter(fields);']}
        {['                    q_string = [''?'' q_string];']}
        {['                end']}
        {['            end']}
        {['            ']}
        {['            if ~exist(''body'', ''var'')']}
        {['                body = struct();']}
        {['            end']}
        {['            ']}
        {['            url = [self.API_BASE_URL endpoint q_string];']}
        {['            r = self.do_call(methdod, url, body, headers);']}
        {['        end']}];
    
end


function s = mustache_scanner_f(template, expression)
    %% returns mustache start, end  and the match
    % implement handling multiple pairs
    % 
    % Args:
    %    - template (nx1 cell): the strings to scan
    %    - expression (1xn char): term within the mustaches (i.e ``{{}}``)
    %
    % Returns:
    %    - s: struct with position indications
    %          - .start (double):
    %          - .match (double):
    %          - .end (double):
    %          - .all (nx1 double):
    

    fmt = repmat({['[%?{]{2}/?', expression, '[}]{2}']}, numel(template), 1);
    match = cellfun(@regexp, template, fmt,  'UniformOutput', false);
    is_empty = cell2mat(cellfun(@isempty, match,   'UniformOutput', false));
    liner = (1:numel(template))';
    indices  = liner(~is_empty);

    s = struct();
    if numel(indices) >= 1
        s.start = indices(1);
        if numel(indices) >= 2
            s.end_ind = indices(2);
            s.match = template((s.start + 1) : (s.end_ind - 1));
            if numel(indices) > 2
                s.all = indices;
                msg= ['found more than two (%d) matches, for ``%s``\n', ...
                      'All matched lines are included within ``s.all``\n'];
                fprintf(msg, numel(indices), expression);
            end
        end
    else
        fprintf('Did find token in the strings.\n');
    end
    
end


function template = read_in_template_f(abs_path)
    %% read in the client template
    % template - classdef template | 1 cell per 1 line of code
    %
    % Args:
    %    abs_path (str):  takes an optional absolute path to a template
    %                     will use the package default if omitted
    %
    % .. todo:: move filename to ``confi.json`` to use custome templates
    %
    
    if nargin == 0
        file_name = 'client_template_swagccg_m2m.m';
        abs_path = which(file_name);
    end
    % dir_path = pwd();
    % abs_path = fullfile(dir_path,  file_name);
    if ~exist(abs_path, 'file')
        error('file does not exist: \n%s\n', abs_path);
    end
    template = cell(1, 1);
        fid = fopen(abs_path, 'r');
        if fid  == 3
            try
                k = 1;
                str = 'first line to be discarded';
                while isa(str, 'char')
                    template{k, 1} = str;
                    str = fgetl(fid);
                    k = k + 1;
                end
                fclose(fid);
            catch ME
                error('Could not open %s\n%s\n', abs_path, ME.message);
            end
        else
            error('Could not open %s', abs_path);
        end
    template = template(2:end);

end


function codelet = render_constructor_f(c)
%% apply details of the client to the client class

    codelet = {...
        ['           if nargin == 0'];
        ['               deployment = ''remote'';'];
        ['           end'];
        ['           self.DEPLOYMENT = deployment;'];
        ['           if strcmp(deployment, ''remote'')'];
        ['               self.API_PORT = ''', c.api_port_remote, ''';'];
        ['               self.API_URL_BASE = ''', c.api_url_base_remote, ''';'];
        ['               self.API_PROTOCOL = ''', c.api_protocol_remote, ''';'];
        ['           elseif strcmp(deployment, ''local'')'];
        ['               self.API_PORT = ''', c.api_port_local, ''';'];
        ['               self.API_URL_BASE = ''', c.api_url_base_local, ''';'];
        ['               self.API_PROTOCOL = ''', c.api_protocol_local, ''';'];
        ['           end    '];
        ['           self.BASE_PATH = ''', c.base_path, ''';'];
    };

end


function poe_str = client_point_of_execution_f()
    %% pass
    poe_str = 'pass';
end


function data = save_fread_f(file_path)
    %% read a file and ensure it's closed afterwards
    if ~exist(file_path, 'file')
        error('file does not exist:\n%s\n', file_path);
    end
    fid = fopen(file_path, 'r');
    if fid == 3 || fid == 4
        try
            data = char(fread(fid))';
            fclose(fid);
        catch
            fclose(fid);
            error('Could not read %s', file_path);
        end
    else
        fclose(fid);
        error('Could not open %s', file_path);
    end

end


function dt = time_stamp_f()
    %% conveniniece method to return now() as a string
    
    dt = datestr(now(), 'yyyy-mm-dd HH:MM:SS');
    
end


function snake_name = convert_to_snake_case_f(name)
    %% convert CamelCase to snake_case
    % via https://stackoverflow.com/a/1176023

    snake_name = regexprep(name, '(.)([A-Z][a-z]+)', '$1_$2');
    snake_name = regexprep(snake_name, '([a-z0-9])([A-Z])', '$1_$2');
    snake_name = lower(snake_name);

end


function methods_list = create_methods_code_f(swagger_data)
    %% extract the  ressource details from swagger.json and 
    % calls :ref:`client_method_template_f()` to crete methods
    % 
    % Args:
    %    swagger_data (struct): MatLab-y-fyed and parsed :ref:`swagger.json`
    %
    %

    verbs_list = {'GET', 'POST', 'DELETE', 'PATCH', 'PUT'};

    % extract some key variables
    generic_name = fieldnames(swagger_data.('paths'));
    methods_list = cell(1, 1);
    loop_counter = 1;

    for g =  1 : numel(generic_name)
        ressource = swagger_data.('paths').(generic_name{g});
        http_verbs = fieldnames(ressource.('methods'));
        endpoint = ressource.('path');

        for i = 1: numel(http_verbs)
            operation = sprintf('xyz_{%d}', loop_counter); 
            doc_string = ' ';
            fn = fieldnames(ressource.('methods').(http_verbs{i}));

            if ismember('operationId', fn)
                operation = ressource.('methods').(http_verbs{i}).('operationId');
            end
            if ismember('summary', fn)
                doc_string = ressource.('methods').(http_verbs{i}).('summary');
            end

            % check if the http verb is already part of the operation name
            operation = convert_to_snake_case_f(operation);
            scan = false(numel(verbs_list), 1);
            for verb = 1 : numel(verbs_list)
                scan(verb) = any(regexpi(operation, verbs_list{verb}));
            end

            if  sum(scan) == 0 
                method_name = sprintf('%s_%s_r', http_verbs{i}, operation);
                method_name = lower(method_name);
            else
                method_name = sprintf('%s_r', operation);
                method_name = lower(method_name);
            end

            conf = struct();
            conf.('method_name') = method_name;
            conf.('http_verb') = http_verbs{i};
            conf.('api_end_point') = endpoint;
            conf.('doc_string') = doc_string;

            methods_list{loop_counter, 1} = client_method_template_f(conf);
            loop_counter = loop_counter + 1;
        end
    end

end


function is_ok = utf8_write_to_file_f(target_path, my_m_code)
    %% Write code [n x 1] cell array to text-file in unicode encoding
    % 
    % Args:
    %    target_path (str): desired path for file generation
    %    
    %    my_m_code (nx1 cell): code to be written down
    %
    %
    %
    
    is_ok = false;
    fid = fopen(target_path, 'w');
    if fid == 3 
        try
            for i = 1 : numel(my_m_code)
                if ~isempty(my_m_code{i})
                    encoded_str = unicode2native(my_m_code{i}, 'UTF-8'); 
                    fwrite(fid, [encoded_str, 10], 'uint8');
                end
            end
            fclose(fid);
            fprintf('%s | new file created:\n%s \n', time_stamp_f(), target_path);
        catch ME
            error('Could not create file %s:\n%s\n', target_path, ME.message);
        end
    else
        error('Could not create file %s', target_path);
    end
    is_ok = true;
    
end
