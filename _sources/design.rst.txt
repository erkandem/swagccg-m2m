Design
=======
Developers should be able to create code within the language they are using.
The tool was originally design to cover only GET requests with
a possibility for a  query string. The response was (and is) assumed to be
``JSON only``. But since the outwards facing parts are located in :func:`_do_call`,
:func:`_encode` and :func:`_decode` it's easy to add your logic.


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


Client Class Definition
^^^^^^^^^^^^^^^^^^^^^^^
In MatLab the name of the class must match the filename.

Drop in the desired class name here.
Class and class-instance properties can be placed here.


.. todo:: reflect filename[.m] == classname in logic



Point of Execution - POE
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Well not really, since the POE only dispatches it to an external component.
Drop in your preferred way.

Response Handling
^^^^^^^^^^^^^^^^^^^^^
By default, any request  body will be encoded to JSON and than UINT8.
Any response body will be decoded assuming JSON content.

One exception is if you want to encode ``formData``.
This is not handled on the client class level yet.
See :ref:`Specifications` for details.

Models
^^^^^^^^^^^^^^

ORM to create models are not included.
The default assumption is that JSON is primary content.



Client Class Methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Each **http-method** will be rendered to one **client-class-method**
The name for the client-class-method  is derived from the ``operationId``
within swagger. The actual name of the client-class-method will be
http-method + the OperationId + ``_r``.

Each http-method has an operationId which may or may not include the http-method name.
If doesn't it will be attached.

Examples:

- A ``GET`` http-method on a ``getRessource`` OperationId would render to
  ``get_ressource_r``

- A ``GET`` http-method on a ``Ressource`` OperationId would also render to
  ``get_ressource_r``


Weak Point:

- A ``POST`` http-method on a ``getRessource`` OperationId would render to
  ``get_ressource_r`` because a


The parsing logic can be found within :func:`create_methods_code_f`

The client-class-method rendering logic is placed :func:`src.client_template.create_methods_code_f`



