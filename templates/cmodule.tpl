#include <erl_nif.h>
#include <string.h>
#include <stdint.h>

#include <stdio.h>

#include "{{header|absname}}"

#if _WIN32 || _WIN64
	#if _WIN64
typedef unsigned __int64 uint64_t;
		#define ENV64BIT
	#else
typedef unsigned __int32 uint32_t;
		#define ENV32BIT
	#endif
#else // clang gcc
#include <stdint.h>
	#if __x86_64__
		#define ENV64BIT
	#else
		#define ENV32BIT
	#endif
#endif 

/*
 * forward declarations
 */
{% with prototypes=1 %}
{% include "structures.tpl" %}
{% endwith %}

/*
 * Structs
 */
{% include "structures.tpl" %}

/*
 * Build Function Definitions
 */
{% include "function.tpl" %}

/*
 * Function definitions for ErLang
 */
static ErlNifFunc nif_functions[] = {
	{% with fn=symbols|fetch_keys %}{% for name in fn %}
	{"{{name}}", {{ symbols|fetch:name|length|add:-1 }}, _nifty_{{name}}},
	{% endfor %}{% endwith %}
	{"erlptr_to_record", 1, erlptr_to_record},
	{"record_to_erlptr", 1, record_to_erlptr},
	{"new", 1, new_type_object},
	{"size_of", 1, size_of}
	};

int upgrade(ErlNifEnv* env, void** priv_data, void** old_priv_data, ERL_NIF_TERM load_info)
{
	return 0;
}

ERL_NIF_INIT({{module}}, nif_functions, NULL, NULL, upgrade, NULL);