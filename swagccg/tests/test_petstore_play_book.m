function test_petstore_play_book(confi_path)
    %% wrapper around the core logic
    % which currently consists of 8 tests:
    % %will be updated / refactored
    %
    %  0. client creation
    %  1. post with UINT8 body 
    %  2. put with body
    %  3. post with form data
    %  4. get with query string
    %  5. post with form data
    %  6. get with query string
    %  7. delete with path param and query string
    %
    % Gotchas:
    %     - Since the current version is dependent on :func:`urlread2()`,
    %       the body content of a request should be encoded using :func:`uint8()`.
    %       This will prohibit further meddling with the request body
    %       on behalf of :func:`urlread2`.
    %
    %     - The URL of Some ressources require the usage of path parameters:
    %
    %       .. code:: matlab
    %
    %          sprintf('%d', PET_ID)
    %
    %       A formatting string (e.g. ``%d``) is required since the tool in its current
    %       conditon doesn't parse/store the data type of the parameter.
    %
    %
    % .. todo:: ``implemented = false;`` refers to the usage of structs rather
    %           than cellstrings. :func:`struct2cell`
    %

    %% test fixtures
    file_path = which('test_petstore_play_book.m');
    [root_folder, ~, ~] = fileparts(file_path);
    
    if nargin == 0
        confi_path = fullfile(root_folder, 'confi.json');
    end
    test_0_result = false;
    try
        swagccg_m2m(confi_path);
        test_0_result = true;
        fprintf('Test 0 Success - client created\n');
    catch ME
        fprintf('Test 0 Failed \n%s\n', ME.message)
    end
    
    CLIENT = TestPetStoreClient('remote');  % instantiate client
    PET_ID = randi([10 ^ 10, 9 ^ 11], 1);  % range bound pseudo random pet-id


    %% read in default request body
    BODY = {...
                '{';
                '  "id": "PET_ID",';
                '  "category": {';
                '    "id": "PET_ID",';
                '    "name": "string"';
                '  },';
                '  "name": "koalabaerchen",';
                '  "photoUrls": [';
                '    "https://duckduckgo.com/koala"';
                '  ],';
                '  "tags": [';
                '    {';
                '      "id": "PET_ID",';
                '      "name": "string"';
                '    }';
                '  ],';
                '  "status": "available"';
                '}';
               };
    BODY = strjoin(BODY);
    BODY (BODY == ' ') = [];
    BODY = regexprep(BODY, '(["]PET_ID["])', sprintf('%d', PET_ID));
    BODY_JSON = uint8(BODY);


    %% read in authorization header
    HEADERS = struct();
    HEADERS.('name') = 'Content-Type';
    HEADERS.('value') = 'application/json';

    meta_header = struct();
    meta_header.('name') = 'api-key';
    meta_header.('value') = 'special-key';

    HEADERS = [HEADERS , meta_header];

    meta_header = struct();
    meta_header.('name') = 'accept';
    meta_header.('value') = 'application/json';


    HEADERS = [HEADERS , meta_header];
    HEADERS = HEADERS';

    % or use http_createHeader(name, value)

    % f = fopen('headers.json');
    % HEADERS = fread(f, '*char')';
    % close(f);

    %% setting petstore specific authorization settings
    CLIENT.API_TOKEN = 'special-key';
    CLIENT.AUTH_HEADER_NAME = 'api-key';
    CLIENT.AUTH_PREFIX = '';
    CLIENT.AUTH_TOKEN_KEY = '';
    CLIENT.AUTH_TOKEN_KEY_REFRESH = '';
    CLIENT.REFRESH_KEY = '';


    %% 1. Test
    test_1_result = false;
    r1 = CLIENT.post_add_pet_r([], BODY_JSON, HEADERS);
    if isa(r1, 'struct')
        if r1.id == PET_ID
           test_1_result = true;
        end
    end

    if test_1_result 
        fprintf('Test 1 Success %d == %d \n', r1.id, PET_ID);
    else
        fprintf('Test 1 failed %d == %d\n', r1.id, PET_ID); 
    end


    %% 2. Test
    NEW_URL = 'https://updatedurl.de';
    BODY_TEST2 = regexprep(BODY ,'(https://duckduckgo.com/koala)', NEW_URL);
    BODY_TEST2_JSON = uint8(BODY_TEST2);

    r2 = CLIENT.put_update_pet_r([], BODY_TEST2_JSON , HEADERS);
    test_2_result = false;

    if isa(r2, 'struct')
        if r2.id == PET_ID
            if strcmp(r2.photoUrls{1}, NEW_URL)
                test_2_result = true;
            end
        end
    end

    if test_2_result 
        fprintf('Test 2 Success %s == %s \n', r2.photoUrls{1}, NEW_URL);
    else
        fprintf('Test 2 failed %s == %s\n', r2.photoUrls{1}, NEW_URL);
    end

    %% 3. Test
    % set pet status to pending
    % main reason is response time: 143912 available, 149 pending, 78 sold)
    
    implemented  = false;
    if implemented == true
        body = struct();
        body.('name') ='status';
        body.('value') = 'pending';
    else
        body = {'status', 'pending'};
        body = sprintf('%s=%s', body{1,1},  body{1, 2});
    end
    
    headers = struct();
    headers.name = 'Content-Type';
    headers.value = 'application/x-www-form-urlencoded';
    r3  = CLIENT.post_update_pet_with_form_r(sprintf('%d', PET_ID), [], body, headers);

    test_3_result = false;
    if isa(r3 , 'double') 
        if r3 == 200
            test_3_result  = true;
        end
    end

    if test_3_result
        fprintf('Test 3 Success ``%d``\n', r3);
    else
        fprintf('Test 3 failed ``%d``\n', r3);
    end


    %% 4. Test
    % query the pets with ``pending`` ``status``
    implemented  = false;
    if implemented == true
        fields = struct();
        fields.('name') ='status';
        fields.('value') = 'pending';
    else
        fields = {'status', 'pending'};  
    end
    r4 = CLIENT.get_find_pets_by_status_r(fields, [], []);

    % evaluate
    id = zeros(numel(r4), 1);

    for i = 1 : numel(r4)
        id(i, 1) = r4{i}.id;
    end
    
    % for i = 1 : numel(id)
    % fprintf('%d\n', id(i));
    % end
    
    test_4_result = false;
    if sum(PET_ID == id) == 1
        test_4_result = true;
    end

    if test_4_result
        fprintf('Test 4 Success %d in results\n', PET_ID);
    else
        fprintf('Test 4 failed %d NOT in results\n', PET_ID);
    end


    %% 5. Test
    % change status to sold
    implemented  = false;
    if implemented == true
        body = struct();
        body.('name') ='status';
        body.('value') = 'sold';
    else
        body = {'name', 'koalabaerchen_updated'; 'status', 'sold'};
        body_str = sprintf('%s=%s', body{1, 1},  body{1, 2});
        body_str = [body_str, '&', sprintf('%s=%s', body{2, 1},  body{2, 2})];
        body = body_str;
    end
    
    headers = struct();
    headers.name = 'Content-Type';
    headers.value = 'application/x-www-form-urlencoded';
        
    r5  = CLIENT.post_update_pet_with_form_r(sprintf('%d', PET_ID), [], body, headers);

    test_5_result = false;
    if isa(r5 , 'double') 
        if r5 == 200
            test_5_result  = true;
        end
    end

    if test_5_result
        fprintf('Test 5 Success ``%d`` \n', r5);
    else
        fprintf('Test 5 failed ``%d``\n', r5);
    end
    %% test 6
    % query the pets with ``pending`` ``status``
    implemented  = false;
    if implemented == true
        fields = struct();
        fields.('name') ='status';
        fields.('value') = 'sold';
    else
        fields = {'status', 'sold'};  
    end
    r6 = CLIENT.get_find_pets_by_status_r(fields, [], []);

    % evaluate
    id = zeros(numel(r6), 1);

    for i = 1 : numel(r6)
        id(i, 1) = r6{i}.id;
    end
    
    % for i = 1 : numel(id)
    % fprintf('%d\n', id(i));
    % end
    
    test_6_result = false;
    if sum(PET_ID == id) == 1
        test_6_result = true;
    end

    if test_6_result
        fprintf('Test 6 Success %d in results \n', PET_ID);
    else
        fprintf('Test 6 failed %d NOT in results\n', PET_ID);
    end
    
    %% 7. Test
    test_final_result = false;
    body = {'name', 'koalabaerchen_updated'; 'status', 'sold'};

    r_final = CLIENT.delete_pet_r(sprintf('%d', PET_ID), body, [], []);
    if isa(r_final , 'double') 
        if r_final == 200
            test_final_result = true;
        end
    end

    if test_final_result 
        fprintf('Test 7 Success ``%d``\n', r_final);
    else
        fprintf('Test 7 failed ``%d``\n', r_final); 
    end

end