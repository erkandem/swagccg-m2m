classdef client_template_swagccg_m2m < handle %{{classname}}
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
        function self = iVolClient(deployment) %{{constructor_def}}
        %% ClassConstructor equivalent of __init__
        %
        % .. todo:: almost everything here should be configured during client creation
        %
        %
        
            %{{constructor}}
            if nargin == 0
                deployment = 'remote';
            end
            self.DEPLOYMENT = deployment ;
            if strcmp(deployment, 'remote')
                self.API_PORT = '';
                self.API_URL_BASE = '';
                self.API_PROTOCOL = '';
            elseif strcmp(deployment, '')
                self.API_PORT = '';
                self.API_URL_BASE = '';
                self.API_PROTOCOL = '';
            end    
            self.BASE_PATH = '';
            %{{/constructor}}
            
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
        %{{methods}} the methods will later be  placed here       

        function print_property_two(self)
        %% a default getter for a private property 
            fprintf('%s\n', self.property_two);
        end
    end
    
end
