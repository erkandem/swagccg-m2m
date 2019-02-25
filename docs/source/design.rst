Design
======

MatLab doesn't have to suck.
Developers should be to create code within the language they are using.
Full 100 % ``schmatlab`` + ``X`` .
+ ``X`` should be only affecting devs on this package rather than users of the package.
The secret sauce ``X`` which is done better by third party tools is the ``documentation``

Let me walk you through.

Swagger / OpenAPI 2.0
-------------------------
OpenAPI is standard for web API design. There are others like GraphQL by facebook
It emerged from Swagger which was ex post set to 2.0 of the OpenAPI
Human friendly version of swagger is expressed in YAML. Because JSON parsing
tools where more readily available I focused on the machine friendly JSON version.
 - JSON is easier to validate
 - but lacks the ability to set comments

Don't worry you can convert YAML to JSON and vice versa.


The Client Class Template
--------------------------
Core of any code generation tool are the templates.
Currently, the static structure is read from an .m file.
The advantage of using a ``.m`` file is that users could spot
potential errors syntax checkers can access the code while you are writing it.

The dynamic part is generated entirely from strings within subfunctions.

The pieces are joined by mustache like token ``%{{PartXYZ}}`` within the template.
The tokens will be replaced with the actual code.
You might add your own tokens and queue in your rendering logic.

Keep in mind that it is mustache-like but is not conforming


Class Defintion
^^^^^^^^^^^^^^^^^
In MatLab the name of the class must match the filename.

.. todo:: reflect filename[.m] == classname in logic


Attributes
^^^^^^^^^^^^^
public / private / static

Client Methods
^^^^^^^^^^^^^^


Request Dispatching
^^^^^^^^^^^^^^^^^^^^^


Response Handling
^^^^^^^^^^^^^^^^^^^^^


Models
^^^^^^^^^^^^^^

ORM to create models are not included.
The default assumption is that JSON is primary content.


Client Usage
-----------------

Instantiate it 
^^^^^^^^^^^^^^^^^^^^


Call a Resource
^^^^^^^^^^^^^^^^^^^^


Handle the Response
^^^^^^^^^^^^^^^^^^^^


