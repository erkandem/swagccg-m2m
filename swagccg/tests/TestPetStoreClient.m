% auto-generated 2019-02-26 23:29:09
% ... using [swagccg_m2m](https://erkandem.github.io/swagccg_m2m)
% DO NOT MODIFY THIS FILE.
% Your changes will be lost! Edit the template
% {e.g. your message }  
%  
        
classdef TestPetStoreClient < handle 
    %%  Summary of this class goes here
    %   Detailed explanation goes here
    
    % contact details could be placed here ?     
    properties (Constant)
        search_url = 'duckduckgo.com' % dummy property
    end
    %
    %
    properties (Access = public)
        METHODS_WITH_BODY = {'POST', 'PUT', 'PATCH'}
        API_PORT = '';
        API_URL_BASE = '';
        API_PROTOCOL = '';
        API_LOGIN_URL  = '';
        BASE_PATH = '';
        LOGIN_TIMESTAMP = '';
        API_TOKEN = '';
        REFRESH_TIMESTAMP = '';
        API_ENDPOINTS = '';  % dummy
        API_REFRESH_URL = '';
        API_URL = '';
        API_BASE_URL = '';
        DEPLOYMENT = '';
        
        AUTH_HEADER_NAME = 'Authorization';
        AUTH_PREFIX = 'Bearer ';  % mind the whitespace
        AUTH_TOKEN_KEY = 'access_token';
        AUTH_TOKEN_KEY_REFRESH = 'refreshed_token';
        REFRESH_KEY = 'token';
    end
    %
    %
    properties (Access = private)
        property_two;  % dummy property
    end
    %
    %   
    methods (Static)
        function self = TestPetStoreClient(deployment)
        %% ClassConstructor equivalent of __init__
        %
        % .. todo:: almost everything here should be configured during client creation
        %
        %
        
           if nargin == 0
               deployment = 'remote';
           end
           self.DEPLOYMENT = deployment;
           if strcmp(deployment, 'remote')
               self.API_PORT = '80';
               self.API_URL_BASE = 'petstore.swagger.io';
               self.API_PROTOCOL = 'https';
           elseif strcmp(deployment, 'local')
               self.API_PORT = '5000';
               self.API_URL_BASE = '127.0.0.1';
               self.API_PROTOCOL = 'http';
           end    
           self.BASE_PATH = '/v2';
            
            self.LOGIN_TIMESTAMP;
            self.API_TOKEN;
            self.REFRESH_TIMESTAMP;
            % `API_ENDPOINTS` currently for REFERENCE only
            self.API_ENDPOINTS = '';
            if strcmp(self.API_PORT, '80')
                self.API_URL = ...
                    [self.API_PROTOCOL, '://', self.API_URL_BASE];
            else
                self.API_URL = ...
                    [self.API_PROTOCOL, '://', self.API_URL_BASE, ':', self.API_PORT];
            end
            self.API_LOGIN_URL = [self.API_URL, '/login'];
            self.API_REFRESH_URL = [self.API_URL, '/refresh'];
            self.API_BASE_URL = [self.API_URL, self.BASE_PATH];
        end
        
        function dt = timestamp()
            %% conveniniece method to return now() as a string
            dt = datestr(now(), 'yyyy-mm-dd HH:MM:SS');
        end
        
        function dt = timestamp2num(dt)
            %% conveniniece method to parse a timestamp
            dt = datenum(dt, 'yyyy-mm-dd HH:MM:SS');
        end
        
    end
    %
    % 
    methods (Access = private)
        function data_encoded = encode(self, data)
            %% abstracted encoding point
            %
            % Mount your custom function. Focus here is on JSON.
            %
            % MatLab users may prefer the built in :func:`jsonencode`
            % while octave users may prefer :func:`jsonsave` from :func:`jsonlab`.
            % data could also be a struct with encoding instructions which
            % could be parsed HERE.
            %
            % Args:
            %    data: raw matlab/octave objects
            % 
            % Returns:
            %    data_encoded: encoded raw matlab/octave objects
            %
            
            data_encoded = jsonencode(data);
            
        end
        
        
        function data_decoded = decode(self, data)
            %% abstracted decoding point 
            %
            % Mount your custom function. Focus here is on JSON.
            %
            % MatLab users may prefer the built in :func:`jsondecode`
            % while octave users may prefer :func:`loadjson` from :func:`jsonlab`.
            % data could also be a struct with encoding instructions which
            % could be parsed HERE.
            %
            % Args:
            %    data: raw MatLab/Octave object
            % 
            % Returns:
            %    data_encoded: encoded raw matlab/octave objects
            %
            
            data_decoded = jsondecode(data);
            
        end
        
        function r = is_it_time_to_refresh_the_token(self) 
            %% check whether ``LOGIN_TIMESTAMP`` or ``REFRESH_TIMESTAMP``
            % as surpassed a set duratation which would then require 
            % additional action (i.e. re-login or token refreshment)
            %
            %
            
            DURATION_VALID = 10/24; % (1 (double) == 1 day (duration)) 
            r = false;
            
            if isempty(self.REFRESH_TIMESTAMP)
                if (self.timestamp2num(self.LOGIN_TIMESTAMP) + DURATION_VALID) < now()
                    self.refresh_the_login();
                    r = true;
                end
            else
                if (self.timestamp2num(self.REFRESH_TIMESTAMP) + DURATION_VALID) < now()
                    self.refresh_the_login();
                    r = true;
                end
            end
        end
        
        function refresh_the_login(self)
            %%
            s = struct();
            s.(self.REFRESH_KEY) = self.API_TOKEN;
            data_json = self.encode(s);
            body =  uint8(data_json);
            headers = {'Content-Type', 'application/json'};
            
            r = self.do_call('POST', ...
                             self.API_REFRESH_URL, ...
                             body, ...  
                             headers);  
 
            res = self.decode(r);
            self.API_TOKEN = res.(self.AUTH_TOKEN_KEY_REFRESH);
            self.REFRESH_TIMESTAMP = self.timestamp();
        end
        
        function [res, r_header] = do_call(self, method, url, body, headers)
            %% execute request do external function
            % one central method to dispatched external request
            % essentially wrapping :func:`urlread2()`. but could be
            % replaced.
            % 
            % Depending on the method, body will be 
            % .. todo:: shouting for switch/case - seperate function
            %
            auth_cell = {self.AUTH_HEADER_NAME, ...
                         sprintf('%s%s', ...
                                  self.AUTH_PREFIX, ... 
                                  self.API_TOKEN) ... 
            };
            auth_header = cell2struct(auth_cell, {'name', 'value'}, 2);
            
            if exist('headers', 'var')
                if isa(headers, 'struct')
                    if ~isempty(fieldnames(headers))
                        if ismember('name', fieldnames(headers))
                            if ~ismember(self.AUTH_HEADER_NAME, {headers.name})
                                headers = [headers, auth_header];
                            else
                                % nothing
                            end
                        else
                            headers = auth_header;
                        end
                    else
                        headers = auth_header;
                    end
                else
                    headers = auth_header;
                end
            else
                headers = auth_header;
            end
            % handling for empty body, because urlread2 expects char, int8
            % or uint8
            if isa(body, 'struct')
                if numel(fieldnames(body)) == 0
                    body = '';
                end
            end
            
            [r, r_header] = urlread2(url, method, body, headers);
            if r_header.status.value == 200
                if numel(r) > 0
                    res = self.decode(r);
                else
                    res = r_header.status.value;
                end
            elseif r_header.status.value == 401
                self.refresh_the_login()
                res = 0;
                sprintf('<strong> Return code: %d </strong>\n', r_header.status.value);
            else
                sprintf('<strong> Return code: %d </strong>\n', r_header.status.value);
                res = 0;
            end
        end
        
        function [param_string, headers] = param_formatter(self, fields)
            %% return an URL-endoed 'ready to attach' querystring
            % create a vector (n*2 x 1) from array (n x 2), if needed
            
            if size(fields, 1) > 1
                flat_fields = cell(1); 
                for i = 1 : size(fields, 1)    
                    flat_fields = [flat_fields, fields(i, :)];
                end
                fields = flat_fields(2:end);    
            end
            [param_string, headers] = http_paramsToString(fields, 1);
        end
    end
    %
    %
    methods (Access = public)
        function login_with_api(self, data)
            %% login with the target API and 
            % save the resonse (JWT token) within a class property
            %
            % Args:
            %    data: login data, externally supplied as a struct
            %          .. code:: matlab
            %
            %             data.username = 'username';
            %             data.password = 'password';
            %
            %
            
            data_json = self.encode(data);
            body = uint8(data_json);
            headers.name = 'Content-Type';
            headers.value = 'application/json';
            
            r = self.do_call('POST', ...
                             self.API_LOGIN_URL, ...  
                             body, ...
                             headers);
            %res = decode(r);
            self.API_TOKEN = r.(self.AUTH_TOKEN_KEY);
            self.LOGIN_TIMESTAMP = self.timestamp();
            self.REFRESH_TIMESTAMP = '';
        end
        % API endpoints
 
        function r = post_add_pet_r(self, fields, body, headers)
            %% Add a new pet to the store 
            
            
            endpoint = '/pet';
            methdod = 'POST';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = put_update_pet_r(self, fields, body, headers)
            %% Update an existing pet 
            
            
            endpoint = '/pet';
            methdod = 'PUT';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = get_find_pets_by_status_r(self, fields, body, headers)
            %% Finds Pets by status 
            
            
            endpoint = '/pet/findByStatus';
            methdod = 'GET';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = get_find_pets_by_tags_r(self, fields, body, headers)
            %% Finds Pets by tags 
            
            
            endpoint = '/pet/findByTags';
            methdod = 'GET';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = get_pet_by_id_r(self, petId, fields, body, headers)
            %% Find pet by ID 
            
            
            endpoint = sprintf('/pet/%s', petId);
            methdod = 'GET';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = post_update_pet_with_form_r(self, petId, fields, body, headers)
            %% Updates a pet in the store with form data 
            
            
            endpoint = sprintf('/pet/%s', petId);
            methdod = 'POST';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = delete_pet_r(self, petId, fields, body, headers)
            %% Deletes a pet 
            
            
            endpoint = sprintf('/pet/%s', petId);
            methdod = 'DELETE';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = post_upload_file_r(self, petId, fields, body, headers)
            %% uploads an image 
            
            
            endpoint = sprintf('/pet/%s/uploadImage', petId);
            methdod = 'POST';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = get_inventory_r(self, fields, body, headers)
            %% Returns pet inventories by status 
            
            
            endpoint = '/store/inventory';
            methdod = 'GET';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = post_place_order_r(self, fields, body, headers)
            %% Place an order for a pet 
            
            
            endpoint = '/store/order';
            methdod = 'POST';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = get_order_by_id_r(self, orderId, fields, body, headers)
            %% Find purchase order by ID 
            
            
            endpoint = sprintf('/store/order/%s', orderId);
            methdod = 'GET';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = delete_order_r(self, orderId, fields, body, headers)
            %% Delete purchase order by ID 
            
            
            endpoint = sprintf('/store/order/%s', orderId);
            methdod = 'DELETE';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = post_create_user_r(self, fields, body, headers)
            %% Create user 
            
            
            endpoint = '/user';
            methdod = 'POST';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = create_users_with_array_input_r(self, fields, body, headers)
            %% Creates list of users with given input array 
            
            
            endpoint = '/user/createWithArray';
            methdod = 'POST';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = create_users_with_list_input_r(self, fields, body, headers)
            %% Creates list of users with given input array 
            
            
            endpoint = '/user/createWithList';
            methdod = 'POST';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = get_login_user_r(self, fields, body, headers)
            %% Logs user into the system 
            
            
            endpoint = '/user/login';
            methdod = 'GET';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = get_logout_user_r(self, fields, body, headers)
            %% Logs out current logged in user session 
            
            
            endpoint = '/user/logout';
            methdod = 'GET';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = get_user_by_name_r(self, username, fields, body, headers)
            %% Get user by user name 
            
            
            endpoint = sprintf('/user/%s', username);
            methdod = 'GET';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = put_update_user_r(self, username, fields, body, headers)
            %% Updated user 
            
            
            endpoint = sprintf('/user/%s', username);
            methdod = 'PUT';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function r = delete_user_r(self, username, fields, body, headers)
            %% Delete user 
            
            
            endpoint = sprintf('/user/%s', username);
            methdod = 'DELETE';
            if ~exist('headers', 'var')
                headers = struct();
            end
            
            q_string  = '';
            if exist('fields', 'var')
                if ~isempty(fields)
                    [q_string, ~] = self.param_formatter(fields);
                    q_string = ['?' q_string];
                end
            end
            
            if ~exist('body', 'var')
                body = struct();
            end
            
            url = [self.API_BASE_URL endpoint q_string];
            r = self.do_call(methdod, url, body, headers);
        end
        function print_property_two(self)
        %% a default getter for a private property 
            fprintf('%s\n', self.property_two);
        end
    end
    
end
