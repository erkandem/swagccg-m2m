function data = load_swagger_f(fname)
    % wrapper around :func:`loadjson_mod` which parses a swagger compliant 
    % ``.json`` file into a MatLab readable. The function was customized
    % for that specific purpose but could be generalized.
    %
    % Background is that the maximum fieldname length of a MatLab structure
    % is limited to around 63 characters. The rules for valid fieldnames
    % are simialer to valid variablenames which excludes e.g. ``/``.
    %
    % :func:`loadjson` leaves a HEX representation of a removed character
    % which with multiple deleted charackters surpasses the 63 character
    % limit quite often with regard to URLs 
    % 
    % The original API definition:...
    %
    % .. code-block:: json
    %
    %    {
    %         "swagger": "2.0",
    %         "basePath": "/api/v1",
    %         "paths": {
    %             "/really/fancy/path": {
    %                 "get": {...}, ...
    %             },...
    %         },...
    %     }
    %
    % ...is modified to:
    %
    % .. code-block:: json
    %
    %     {
    %         "swagger": "2.0",
    %         "basePath": "/api/v1",
    %         "paths": {
    %             "generic_name_1": {
    %                 "path": "/really/fancy/path",
    %                 "methods": {
    %                     "get": {...},
    %                     ...}
    %             },...
    %         },...
    %     }
    % 
    % 



    data = loadjson_mod(fname);

end
