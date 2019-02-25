.. figure:: https://img.shields.io/badge/License-BSD3-green.svg
   :alt: License1

   License1

swagccg_m2m
===========

*100% MatLab only client code generator for swagger (OpenAPI 2.0). Using
MatLab. For MatLab*

Summary
-------

Immediately testing new resources is important if resources are going to
be co-dependent. While the tools at SwaggerHub are mind blowing they may
represent an overkill for *not yet production* code. Typing a single
query can be done in any browser or with tools like curl. This tool aims
to place itself between those two categories.

On top of that, I would expect a programming language to be able to
create its own tools. While Java is a mature and well established
language, it might not be within the proficiency portfolio of each and
everyone.

Installation
------------

Download the distribution
=========================

🚨 **not yet**

.. code:: matlab

   mpm install swagccg-m2m

**Bro, WT! is mpm?**

`Simple MATLAB package management inspired by
pip <http://mobeets.github.io/mpm/>`__

or clone it into your development folder

.. code:: bash

   git clone https://github.com/erkandem/swagccg-m2m.git

Usage
-----

a) Client Code Generation
~~~~~~~~~~~~~~~~~~~~~~~~~

Fresh clients can be generated as easy as:

.. code:: matlab

   swagccg_m2m

the ``swagccg_m2m`` assumes that a ``confi.json`` file is in your
working directory. If that’s not the case you may pass the path as a
char array (string) to such a json

.. code:: matlab

   swagccg_m2m('abs/or/relative/path/to/your/jsonfile.json')

Below is an example of susch a file

**confi.json**

.. code:: json

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

b) Client Code Usage
~~~~~~~~~~~~~~~~~~~~

🚨 **the tool is not designed to work out of the box** It’s not that I
dont’t believe in miracles. But I’d expect that you will need to work on
the client after generating the code. Specifically, everything around
*Authentification*

Have a look at the petstore example and test in the tests folder.

Now, you or your end users could access the API via

.. code:: matlab

   credentials.('username') = 'username';
   credentials.('password') = 'youd_never_guess_that'

   my_client = MyApiClient('local')
   my_client.login_with_api(credentials)

###h a Word on JSON in MatLab

MatLab has a built in function to encode and decode JSON objects to
MatLab types The\ ``paths`` object within a ``swagger.json`` API
definition has characters like ``/`` or curly braces in case of path
parameters ``/{pathParam}``. Obviously strings with these chracters are
not valid variable or fieldnames in MatLab. Lacking the hackability of
the built-in function I modified ``loadjson`` from ``jsonlab``.

gotchas
-------

-  authorization is highly custom
-  most of the swagger details are not parsed
-  models and mapping is omitted
-  little to none ``HTTP status codes`` parsing
-  assumes knowledge on HTTP HEADER, BODY, METHODs

recommended reading
-------------------

Mark Masse, REST API Design Rulebook - Designing Consistent RESTful Web
Service Interfaces

`Petstore - API <http://petstore.swagger.io>`__

`OpenAPI
Specififcation <https://github.com/OAI/OpenAPI-Specification>`__

`Open-MBEE/swagger-codegen-matlab-client <https://github.com/Open-MBEE/swagger-codegen-matlab-client>`__

Contact
-------

``Email`` erkan@erkan.io

``Issues``:
`github.com/erkandem/swagccg-m2m/issues <https://github.com/erkandem/swagccg/issues>`__

``Source``:
`github.com/erkandem/swagccg-m2m <https://github.com/erkandem/swagccg-m2m/>`__

``Documentation``:
`erkandem/github.io/swagccg-m2m <https://erkandem.github.io/swagccg_m2m>`__

License
-------

My part of the cake is licensed under terms of BSD. (approx: MIT +
“Don’t use my name to advertise your code”) For details please see the
```license`` <LICENSE>`__ file of this project.

This project is dependent on code by: -
```urlread2 v 2012`` <https://www.mathworks.com/matlabcentral/fileexchange/35693-urlread2>`__
- ```jsonlab  v 1.5`` <https://github.com/fangq/jsonlab>`__

Client Code License
-------------------

Show some love and leave a project link.

and a modified version ``loadjson`` as well as the license files of
other projects within the source code.

Click Bait
----------

Visitors who were interested in this repo also took a look at:
`swagccg-py2py - Python to Python Client Code
Generator <https://github.com/erkandem/swagccg_py2py>`__
