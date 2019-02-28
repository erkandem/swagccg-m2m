![](https://img.shields.io/badge/License-BSD-green.svg)


# swagccg_m2m

*100% MatLab only client code generator for swagger (OpenAPI 2.0). Using MatLab. For MatLab*

## Summary

Immediately testing new resources is important if resources are going to be 
co-dependent. While the tools at SwaggerHub are mind blowing 
they may represent an overkill for *not yet production* code.
Typing a single query can be done in any browser or with tools like ``curl``.
This tool aims to place itself between those two extreme categories. 

## Installation

1. GitHub

Releases are published on GitHub and mirrored on the file-exchange. If you have trouble related to ``newline`` try a ``git clone``

```bash
https://github.com/erkandem/swagccg-m2m/releases/latest
```



2. MPM

🚨 **not yet**

```MATLAB
mpm install swagccg-m2m
```

[Simple MATLAB package management inspired by pip](http://mobeets.github.io/mpm/)



3. git clone 

```bash
git clone https://github.com/erkandem/swagccg-m2m.git swagccg-m2m 
```
The ``git clone`` way  is rather for developers of this repo. Nonetheless, running ``swagccg_m2m_package`` after cloning will package a ``user version``
Currently, all dependencies are included in a .zip file.

## Usage 

### a) Client Code Generation
Fresh clients can be generated as easy as:


```MATLAB
swagccg_m2m
```
the ``swagccg_m2m`` assumes that a ``confi.json`` file is in your working directory.
If that's not the case you may pass the path as a char array (string) to such a json

```MATLAB
swagccg_m2m('abs/or/relative/path/to/your/jsonfile.json')
```
Below is an example.

#### confi.json

```JSON
{
  "swagger_path": "C:/Users/Abuser/your_project/swagger.json",
  "target_path": "C:/Users/Abuser/your_project/MyApiClient.m",
  "class_name": "MyApiClient",

  "api_port_local": "5000",
  "api_url_base_local": "127.0.0.1",
  "api_protocol_local": "http",

  "api_port_remote": "80",
  "api_url_base_remote": "deployed.com",
  "api_protocol_remote": "https"
}
```


### b) Client Code Usage

🚨 **the tool is not designed to work out of the box**
It's not that I don't believe in miracles. But I'd expect that you will need to work
on the client code after generating the client code. Specifically, everything around *Authentication*

Have a look at the pet store example and test in the tests folder.


Now, after you've polished up the code, you or your end users could access the API via
```matlab
credentials.('username') = 'username';
credentials.('password') = 'youd_never_guess_that'

my_client = MyApiClient('local')
my_client.login_with_api(credentials)
```

###  a Word on JSON in MatLab

MatLab has a built-in function to encode and decode JSON objects to  MatLab types.
The``paths`` object within  a  ``swagger.json``  API definition has characters like ``/``
or curly braces in case of path parameters like  ``/{pathParam}``. Obviously strings with these 
characters are not valid variables or fieldnames in MatLab.
Therefore a version of ``loadjson`` from ``jsonlab`` was modified to  overcome that hurdle.

## gotchas
- authorization is likely to be a break-point
- most of the swagger details are not parsed
- data models and mapping is omitted but adaptable
- little to none ``HTTP status codes`` parsing
- assumes knowledge on HTTP HEADER, BODY, METHODs

## Further Reading

[Project Documentation](https://erkandem.github.io/swagccg-m2m)

Mark Masse, REST API Design Rulebook - Designing Consistent RESTful Web Service Interfaces

[Petstore API - An Open Source Example](http://petstore.swagger.io)

[OpenAPI Specififcation](https://github.com/OAI/OpenAPI-Specification)

If you want to go for the full swagger codegen way there have a look at this: 
[Open-MBEE/swagger-codegen-matlab-client](https://github.com/Open-MBEE/swagger-codegen-matlab-client)

[Create Read Update Delete - CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)

[Overview of RESTful API Description_Languages](https://en.wikipedia.org/wiki/Overview_of_RESTful_API_Description_Languages)

[HTTP methods summary table](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Summary_table)

## Contact

``Email`` [erkan@erkan.io](mailto:erkan@erkan.io)

``Issues``: [github.com/erkandem/swagccg-m2m/issues](https://github.com/erkandem/swagccg/issues)

``Source``: [github.com/erkandem/swagccg-m2m](https://github.com/erkandem/swagccg-m2m/)

``Documentation``: [erkandem.github.io/swagccg-m2m](https://erkandem.github.io/swagccg-m2m)


## License
My part of the cake is licensed under terms of BSD.
(approx: MIT + "Don't use my name to advertise your code")
For details please see the [``license``](LICENSE) file of this project.

This project is dependent on code by:
 - [urlread2 v2012](https://www.mathworks.com/matlabcentral/fileexchange/35693-urlread2)

 - [jsonlab v1.5](https://github.com/fangq/jsonlab)


## Client Code License
Show some love and leave a project link.
That's all I ask for.

## Click Bait

Visitors who were interested in this repo also took a look at:
[swagccg-py2py - Python to Python Client Code Generator](https://github.com/erkandem/swagccg-py2py)

