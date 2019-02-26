swagccg core API
-------------------
.. contents:: Contents
   :depth: 2

Entry Point
^^^^^^^^^^^^^^^^^^^^

.. currentmodule:: swagccg.src

.. autofunction:: swagccg_m2m


Template
^^^^^^^^^^^^^^^^^^

.. function:: client_imports_f

.. function:: render_constructor_f

.. function:: client_point_of_execution_f

.. function:: create_methods_code_f

.. function:: client_method_template_f


IO
^^^^^^^^^^^^^^

.. function:: utf8_write_to_file_f

.. function:: save_fread_f

.. function:: read_in_template_f

utilities
^^^^^^^^^^^^^^

.. function:: timestamp

.. function:: convert_to_snake_case_f

.. function:: mustache_scanner_f



handling ``Swagger.json``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. autofunction:: modify_swagger

.. autofunction:: loadjson_mod


Developement
^^^^^^^^^^^^^^^^

.. autofunction:: swagccg.swagccg_m2m__init__

Primary usage of ``swagccg_m2m__init__.m`` to identify the installation path.
Later on this could act as storage for machine readable meta data (i.e. version, contact, docs).


.. autofunction:: swagccg_m2m_package

.. autofunction:: swagccg_m2m_setup

.. autofunction:: swagccg_m2m_uninstall

.. autofunction:: a

.. autofunction:: d
