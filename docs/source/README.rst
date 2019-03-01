|image0|

swagccg_m2m
===========

*MatLab only client code generator for swagger (OpenAPI 2.0). Using
MatLab. For MatLab*

Summary
-------

Immediately testing new resources is important if resources are going to
be co-dependent. While the tools at SwaggerHub are mind blowing they may
represent an overkill for *not yet production* code. Typing a single
query can be done in any browser or with tools like ``curl``. This tool
aims to place itself between those two extreme categories.

Installation
------------

1. Download the User Distribution
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Releases are published on GitHub and mirrored on the file-exchange. If
you have trouble related to ``newline`` try a ``git clone``.

I. Download the user distribution from GitHub
``https://github.com/erkandem/swagccg-m2m/releases/latest``

II.  Unzip it

III. Run the ``swagccg_m2m_setup``. It will put static files like the
     template, the creation script and a zip file with client
     dependencies in location of your choice and add them to search
     path.

2. MPM
~~~~~~

🚨 **not yet**

.. code:: matlab

   mpm install swagccg-m2m

`Simple MATLAB package management inspired by
pip <http://mobeets.github.io/mpm/>`__

3. git clone
~~~~~~~~~~~~

I. Clone it.

.. code:: bash

   git clone https://github.com/erkandem/swagccg-m2m.git tmpdir

II.  create a user distribution ``swagccg_m2m_package``

III. change to ``../packages``

IV.  follow the steps 1.II

The ``git clone`` way is rather for developers of this repo.
Nonetheless, running ``swagccg_m2m_package`` after cloning will package
a ``user version``. Currently, all dependencies are included in a .zip
file.

Getting Started
---------------

Client Code Generation
~~~~~~~~~~~~~~~~~~~~~~

Let’s start with the usual.

.. code:: matlab

   mkdir('playground');
   cd('playground');

The ``swagccg_m2m`` assumes that a ``confi.json`` file is in your
working directory. Below is an example of such a JSON-file. Create this
file yourself or copy it from this location:

.. code:: matlab

   confi_path = fullfile(fileparts(which('swagccg_m2m__init__')), 'examples', 'example_confi.json' );

confi.json
^^^^^^^^^^

The ``swagger_path`` key accepts a file path or web URL

.. code:: json

   {
     "swagger_path": "https://petstore.swagger.io/v2/swagger.json",
     "target_path": "PetStoreClient.m",
     "class_name": "PetStoreClient",

     "api_port_local": "5000",
     "api_url_base_local": "127.0.0.1",
     "api_protocol_local": "http",

     "api_port_remote": "80",
     "api_url_base_remote": "petstore.swagger.io",
     "api_protocol_remote": "https"
   }

You can now call the code generator with:

.. code:: matlab

   swagccg_m2m;

Or pass the path string.

.. code:: matlab

   swagccg_m2m(confi_path);

So now check whether you got your client in your working directory.

🎉🎉🎈🎉

Client Code Usage
~~~~~~~~~~~~~~~~~

Take a look at the ``test`` and click your way through section by
section. Meanwhile you could use the Swagger User Interface in parallel
``https://petstore.swagger.io`` to test the test.

.. code:: matlab

   playbook_location = fullfile(fileparts(which('swagccg_m2m__init__')), 'tests', 'test_petstore_play_book.m');
   copyfile(playbook_location, 'test_template.m');
   edit test_template

a Word on JSON in MatLab
~~~~~~~~~~~~~~~~~~~~~~~~

MatLab has a built-in function to encode and decode JSON objects to
MatLab types. The\ ``paths`` object within a ``swagger.json`` API
definition has characters like ``/`` or curly braces in case of path
parameters like ``/{pathParam}``. Obviously strings with these
characters are not valid variables or fieldnames in MatLab. Therefore a
version of ``loadjson`` from ``jsonlab`` was modified to overcome that
hurdle.

Finally
-------

🚨 **the tool is not designed to work out of the box for your project**

It’s not that I don’t believe in miracles. But I’d expect that you will
need to work on the client code after generating the client code.
Specifically, everything around *Authentication*. This is because most
of the swagger details are not parsed.

gotchas
-------

-  authorization is likely to be a break-point
-  most of the swagger details are not parsed
-  data models and mapping is omitted but adaptable
-  little to none ``HTTP status codes`` parsing
-  assumes some knowledge on HTTP HEADER, BODY, METHODs

Further Reading
---------------

`Project Documentation <https://erkandem.github.io/swagccg-m2m>`__

Mark Masse, REST API Design Rulebook - Designing Consistent RESTful Web
Service Interfaces

`Petstore API - An Open Source Example <http://petstore.swagger.io>`__

`OpenAPI
Specififcation <https://github.com/OAI/OpenAPI-Specification>`__

If you want to go for the full swagger codegen way there have a look at
this:
`Open-MBEE/swagger-codegen-matlab-client <https://github.com/Open-MBEE/swagger-codegen-matlab-client>`__

`Create Read Update Delete -
CRUD <https://en.wikipedia.org/wiki/Create,_read,_update_and_delete>`__

`Overview of RESTful API
Description_Languages <https://en.wikipedia.org/wiki/Overview_of_RESTful_API_Description_Languages>`__

`HTTP methods summary
table <https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Summary_table>`__

Contact
-------

``Email`` erkan@erkan.io

``Issues``:
`github.com/erkandem/swagccg-m2m/issues <https://github.com/erkandem/swagccg/issues>`__

``Source``:
`github.com/erkandem/swagccg-m2m <https://github.com/erkandem/swagccg-m2m/>`__

``Documentation``:
`erkandem.github.io/swagccg-m2m <https://erkandem.github.io/swagccg-m2m>`__

License
-------

My part of the cake is licensed under terms of BSD. For details please
see the ```license`` <LICENSE>`__ file of this project.

This project is dependent on code by: - `urlread2
v2012 <https://www.mathworks.com/matlabcentral/fileexchange/35693-urlread2>`__

-  `jsonlab v1.5 <https://github.com/fangq/jsonlab>`__

Client Code License
-------------------

Show some love and leave a project link. That’s all I ask for.

Click Bait
----------

Visitors who were interested in this repo also took a look at:
`swagccg-py2py - Python to Python Client Code
Generator <https://github.com/erkandem/swagccg-py2py>`__

.. |image0| image:: https://img.shields.io/badge/License-BSD-green.svg

