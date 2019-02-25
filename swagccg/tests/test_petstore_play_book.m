function test_petstore_play_book(confi_path)
    %% wrapper around the core logic
    % which currently consists of 5 (6) tests:
    %
    %  0. client creation
    %  1. post with body
    %  2. put with body
    %  3. get with query string
    %  4. post with path parameter and query string
    %  5. delete with path param and query string
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
    file_path = which('petstore_play_book.m');
    [root_folder, ~, ~] = fileparts(file_path);
    if nargin == 0
        confi_path = fullfile(root_folder, 'confi.json');
    end
    
    swagccg_m2m(confi_path);
    CLIENT = TestPetStoreClient('remote');  % instantiate client
    PET_ID = randi([10 ^ 5, 9 ^ 6], 1);  % range bound pseudo random pet-id


    %% read in default request body
    f = fopen(fullfile(root_folder, 'body.json'));
    BODY = fread(f, '*char')';
    fclose(f);
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

    %% authorization settings
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
        fprintf('TEST 1 SUCCESSFULL %d == %d \n', r1.id, PET_ID);
    else
        fprintf('<strong>TEST 1 failed %d == %d </strong>\n', r1.id, PET_ID); 
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
        fprintf('TEST 2 SUCCESSFULL %s == %s \n', r2.photoUrls{1}, NEW_URL);
    else
        fprintf('<strong>TEST 2 FAILED %s == %s</strong>\n', r2.photoUrls{1}, NEW_URL);
    end


    %% 3. Test
    implemented  = false;
    if implemented == true
        fields = struct();
        fields.('name') ='status';
        fields.('value') = 'available';
    else
        fields = {'status', 'available'};    
    end
    r3 = CLIENT.get_find_pets_by_status_r(fields, [], []);

    % evaluate
    id = zeros(numel(r3), 1);

    for i = 1 : numel(r3)
        id(i, 1) = r3{i}.id;
    end

    test_3_result = false;
    if sum(PET_ID == id) == 1
        test_3_result = true;
    end

    if test_3_result
        fprintf('TEST 3 SUCCESSFULL %d in results \n', PET_ID);
    else
        fprintf('<strong>TEST 3 FAILED %d NOT in results </strong> \n', PET_ID);

    end


    %% 4. Test
    implemented  = false;
    if implemented == true
        update = struct();
        update.('name') ='status';
        update.('value') = 'available';
    else
        update = {'name', 'koalabaerchen_updated'; 'status', 'pending'};
    end

    r4  = CLIENT.post_update_pet_with_form_r(sprintf('%d', PET_ID), update, [], []);

    test_4_result = false;
    if isa(r4 , 'double') 
        if r4 == 200
            test_4_result  = true;
        end
    end

    if test_4_result
        fprintf('TEST 4 SUCCESSFULL ``%d`` \n', r4);
    else
        fprintf('<strong>TEST 4 FAILED ``%d``</strong>\n', r4);
    end


    %% 5. Test
    test_final_result = false;
    r_final = CLIENT.delete_pet_r(sprintf('%d', PET_ID), update, [], []);
    if isa(r_final , 'double') 
        if r_final == 200
            test_final_result = true;
        end
    end

    if test_final_result 
        fprintf('TEST 5 SUCCESSFULL ``%d`` \n', r_final);
    else
        fprintf('<strong>TEST 5 FAILED ``%d``</strong>\n', r_final); 
    end

end