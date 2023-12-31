// Utility Functions for Running Scheme in CSharp
/*
  ;; Calico Scheme interpreter with support for choose
  ;;
  ;; Written by Douglas S. Blank and James B. Marshall
  ;; dblank@brynmawr.edu
  ;; http://cs.brynmawr.edu/~dblank
  ;; jmarshall@slc.edu
  ;; http://science.slc.edu/~jmarshall
*/

using System;
using System.IO; // File
using System.Reflection; // Assembly
using System.Threading;
//using Microsoft.Scripting.Math;
using System.Numerics;
using Mono.Math;
using Microsoft.Scripting.Hosting;
using System.Collections; // Hashtable
using System.Collections.Generic; // List
using IronPython;

public static class ReflectionExtensions {

    public static object InvokeWithNamedParameters(this MethodBase self, object obj, object [] args, IDictionary<string, object> namedParameters) { 
        try {
            return self.Invoke(obj, MapParameters(self, args, namedParameters));
        } catch {
            return String.Format("ERROR: Scheme unable to invoke ({0} {1})", obj, Scheme.array_to_string(args));
        }
    }

    public static object[] MapParameters(MethodBase method, object [] args, IDictionary<string, object> namedParameters)
    {
        var parms = method.GetParameters();
        string[] paramNames = new string[parms.Length];
        object[] parameters = new object[parms.Length];
        int i = 0;
        foreach (var parm in parms) {
            if (i < args.Length) {
                parameters[i] = args[i];
            } else {
                parameters[i] = parm.RawDefaultValue;
            }
            paramNames[i] = parm.Name;
            i++;
        }
        foreach (var item in namedParameters) {
            var paramName = item.Key;
            var paramIndex = Array.IndexOf(paramNames, paramName);
            parameters[paramIndex] = item.Value;
        }
        return parameters;
    }
}

public class Method {
    public object classobj;
    public MethodInfo method;
    public string name;
    public Type type;

    public Method(object classobj, string name) {
        this.classobj = classobj;
        this.name = name;
    }

    public object Invoke(object [] args) {
        if (this.type == null) {
            this.type = classobj.GetType();
        }
        // then invoke 
        // FIXME: this two step method doesn't work with those
        // functions that have some default args with parameter names
        // does work with fully specified args (all), or with functions
        // that have default args for all.
        this.method = type.GetMethod(this.name, Scheme.get_types(args));
        if (this.method == null) {
            var parameters = new Dictionary<string, object>();
            // Add parameters to dict
            this.method = type.GetMethod(this.name);
            object retval = this.method.InvokeWithNamedParameters(this.classobj, args, parameters); 
            if (this.method != null) {
                return retval != null ? retval : PJScheme.symbol_b_void_d;
            } else {
                System.Console.Error.WriteLine("invoke failed!");
                return PJScheme.symbol_b_void_d;
            }
        } else {
            object retval = this.method.Invoke(this.classobj, args);
            return retval != null ? retval : PJScheme.symbol_b_void_d;
        }
    }
}

public class Config {
  public int DEBUG = 0;
  public bool NEED_NEWLINE = false;
  public List<Assembly> assemblies = new List<Assembly>();

  public Config() {
  }

  public void AddAssembly(Assembly assembly) {
        assemblies.Add(assembly);
  }
}

public class Symbol {
    public string symbol;

    public Symbol(String ssymbol) {
        symbol = ssymbol;
    }
    
    public override string ToString() {
        return symbol;
    }
    
    public String __repr__() {
        return symbol;
    }
}

public class Scheme {

    public static Hashtable symbol_table = null;

    public static object make_symbol(object symbol) {
        if (symbol_table == null) {
            symbol_table = new Hashtable(); // Singleton
        }
        string ssymbol = symbol.ToString();
        if (!symbol_table.ContainsKey(ssymbol)) {                         
            var newsym = new Symbol(ssymbol);         
            symbol_table.Add(ssymbol, newsym);         
        }                 
        return symbol_table[ssymbol];
    }

  private static ScriptScope _dlr_env;
  private static ScriptRuntime _dlr_runtime;

    //static LineEditor lineEditor = new LineEditor(null);
    public static Config config = new Config();

  public delegate object Closure(params object[] args);
  public delegate void Function();
  public delegate bool Predicate(object obj);
  public delegate bool Predicate2(object obj1, object obj2);

  public delegate object Procedure0();
  public delegate void Procedure0Void();
  public delegate bool Procedure0Bool();

  public delegate object Procedure1(object args);
  public delegate void Procedure1Void(object args);
  public delegate bool Procedure1Bool(object args);

  public delegate object Procedure2(object args1, object args2);
  public delegate void Procedure2Void(object args1, object args2);
  public delegate bool Procedure2Bool(object args1, object args2);

  public delegate object Procedure3(object args1, object args2, object args3);
  public delegate void Procedure3Void(object args1, object args2, object args3);
  public delegate bool Procedure3Bool(object args1, object args2, object args3);

    public delegate object Procedure4(object a0, object a1, object a2, object a3);
    public delegate object Procedure5(object a0, object a1, object a2, object a3, object a4);
    public delegate object Procedure6(object a0, object a1, object a2, object a3, object a4, object a5);
    public delegate object Procedure7(object a0, object a1, object a2, object a3, object a4, object a5, object a6);
    public delegate object Procedure8(object a0, object a1, object a2, object a3, object a4, object a5, object a6, object a7);
    public delegate object Procedure9(object a0, object a1, object a2, object a3, object a4, object a5, object a6, object a7, object a8);
    public delegate object Procedure10(object a0, object a1, object a2, object a3, object a4, object a5, object a6, object a7, object a8, object a9);

    public delegate object ProcedureN(params object [] args);

    public static Function pc_halt_signal = (Function) null;

    public static object sList(params object [] args) {
        // make Scheme cons based list from multiple args
        object retval = PJScheme.symbol_emptylist;
        int i = 0;
        while (i < args.Length) {
            object arg = args[args.Length - i - 1];
            retval = cons(arg, retval);
            i++;
        }
        return retval;
    }

    public static object box(object item) {
        return sList(item);
    }

  public static BigInteger makeBigInteger(int value) {
        return new BigInteger(value);
  }

  public static BigInteger BigIntegerParse(string value) {
        int radix = 10;
        BigInteger multiplier = makeBigInteger(1);
        BigInteger result = makeBigInteger(0);
        value = (value.ToUpper()).Trim();
        int limit = 0;
        if(value[0] == '-')
          limit = 1;
        for(int i = value.Length - 1; i >= limit ; i--) {
          int posVal = (int)value[i];
          if(posVal >= '0' && posVal <= '9')
                posVal -= '0';
          else if(posVal >= 'A' && posVal <= 'Z')
                posVal = (posVal - 'A') + 10;
          else
                posVal = 9999999;       // error flag
          
          if(posVal >= radix)
                throw(new ArithmeticException("Invalid string in constructor."));
          else {
                if(value[0] == '-')
                  posVal = -posVal;
                result = result + (multiplier * posVal);
                if((i - 1) >= limit)
                  multiplier = multiplier * radix;
          }
        }
        return result;
  }
  
  public class Proc {
        object proc = null;
        int args = -1;
        int returntype = 1;
        public string repr = null;

        public Proc(string repr, object proctype, int args, int returntype) {
          this.repr = repr;
          this.proc = proctype;
          this.args = args;
          this.returntype = returntype;
        }
        public object Call(object actual) {
          object retval = null;
          if (returntype == 0) { // void return
                if (args == -1) 
                  ((Procedure1Void)proc)(actual);
                else if (args == 0) 
                  ((Procedure0Void)proc)();
                else if (args == 1) {
                  if (pair_q(actual))
                        ((Procedure1Void)proc)(car(actual));
                  else
                        ((Procedure1Void)proc)(actual);
                } else if (args == 2) {
                  ((Procedure2Void)proc)(car(actual), cadr(actual));
                } else if (args == 3) {
                  ((Procedure3Void)proc)(car(actual), cadr(actual), caddr(actual));
                } else {
                  throw new Exception(string.Format("error in call: invalid args count"));
                }
          } else if (returntype == 1) { // return object
                if (args == -1) 
                  retval = ((Procedure1)proc)(actual);
                else if (args == 0) 
                  retval = ((Procedure0)proc)();
                else if (args == 1) {
                  if (pair_q(actual))
                        retval = ((Procedure1)proc)(car(actual));
                  else
                        retval = ((Procedure1)proc)(actual);
                } else if (args == 2) {
                  retval = ((Procedure2)proc)(car(actual), cadr(actual));
                } else if (args == 3) {
                  retval = ((Procedure3)proc)(car(actual), cadr(actual), caddr(actual));
                } else {
                  throw new Exception(string.Format("error in call: invalid args count"));
                }
          } else if (returntype == 2) { // return bool
                if (args == -1) 
                  retval = ((Procedure1Bool)proc)(actual);
                else if (args == 0) 
                  retval = ((Procedure0Bool)proc)();
                else if (args == 1) {
                  if (pair_q(actual))
                        retval = ((Procedure1Bool)proc)(car(actual));
                  else
                        retval = ((Procedure1Bool)proc)(actual);
                } else if (args == 2) {
                  retval = ((Procedure2Bool)proc)(car(actual), cadr(actual));
                } else if (args == 3) {
                  retval = ((Procedure3Bool)proc)(car(actual), cadr(actual), caddr(actual));
                } else {
                  throw new Exception(string.Format("error in call: invalid args count"));
                }
          } else {
            throw new Exception(string.Format("error in call: invalid return type"));
          }
          return retval;
        }

        public object Call(object args1, object args2) {
          object retval = null;
          if (returntype == 0) { // return void
                ((Procedure2Void)proc)(args1, args2);
          } else if (returntype == 1) { // return object
                retval = ((Procedure2)proc)(args1, args2);
          } else if (returntype == 2) { // return bool
                retval = ((Procedure2Bool)proc)(args1, args2);
          } else {
            throw new Exception(string.Format("error in call: invalid return type"));
          }
          return retval;
        }

        public String __repr__() {
            return ToString();
        }

        public override string ToString() {
          return String.Format("#<procedure {0}>", repr);
        }

  }

  // ProcedureN - N is arg count coming in
  // -1, 1, 2 - number of pieces to call app with (-1 is all)
  // 0, 1, 2 - return type 0 = void, 1 = object, 2 = bool

    public enum ReturnType { ReturnVoid=0, ReturnObject=1, ReturnBool=2 };
    public enum TakesType { TakesAll=-1, TakesOne=1, TakesTwo=2 };

  // FIXME: make these four different:
    /*
      1. eq? evaluates to #f unless its parameters represent the same
      data object in memory;
      
      2. eqv? is generally the same as eq? but treats primitive
      objects (e.g. characters and numbers) specially so that numbers
      that represent the same value are eqv? even if they do not refer
      to the same object;
      
      3. equal? compares data structures such as lists, vectors and
      strings to determine if they have congruent structure and eqv?
      contents.(R5RS sec. 6.1)[3]

      4. = compares numbers
      
    */

  // public static Proc append_proc = new Proc("append", (Procedure1) append, -1, 1);
  // public static Proc make_binding_proc = new Proc("make-binding",(Procedure2)make_binding, 2, 1);
  public static Proc apply_with_keywords_proc = new Proc("apply_with_keywords", (Procedure1)apply_with_keywords, 1, 1);
  public static Proc globals_proc = new Proc("globals", (Procedure0)globals, 0, 1);
  public static Proc float__proc = new Proc("float", (Procedure1)float_, 1, 1);
  public static Proc int__proc = new Proc("int", (Procedure1)int_, 1, 1);
  public static Proc Add_proc = new Proc("+", (Procedure1)Add, -1, 1);
  public static Proc Divide_proc = new Proc("/", (Procedure1) Divide, -1, 1);
  public static Proc Eq_proc = new Proc("eq?", (Procedure1Bool) Eq, -1, 2);
  public static Proc EqualSign_proc = new Proc("=", (Procedure1Bool) EqualSign, -1, 2);
  public static Proc procedure_q_proc = new Proc("procedure?", (Procedure1Bool) procedure_q, 1, 2);
  public static Proc Equal_proc = new Proc("equal?", (Procedure1Bool) Equal, -1, 2);
  public static Proc Eqv_proc = new Proc("eqv?", (Procedure1Bool) Eqv, -1, 2);
  public static Proc GreaterThan_proc = new Proc(">", (Procedure1Bool) GreaterThan, -1, 2);
  public static Proc GreaterThanEqual_proc = new Proc(">=", (Procedure1Bool) GreaterThanEqual, -1, 2);
  public static Proc LessThanEqual_proc = new Proc("<=", (Procedure1Bool) LessThanOrEqual, -1, 2);
  public static Proc LessThan_proc = new Proc("<", (Procedure1Bool) LessThan, -1, 2);
  public static Proc symbolLessThan_q_proc = new Proc("symbol<?", (Procedure2Bool) PJScheme.symbolLessThan_q, 2, 2);
  public static Proc Multiply_proc = new Proc("*", (Procedure1) Multiply, -1, 1);
  public static Proc Subtract_proc = new Proc("-", (Procedure1) Subtract, -1, 1);
  public static Proc abs_proc = new Proc("abs", (Procedure1) abs, -1, 1);
  public static Proc assq_proc = new Proc("assq", (Procedure2) assq, 2, 1);
  public static Proc atom_q_proc = new Proc("atom?", (Procedure1Bool) atom_q, 1, 2);
  public static Proc aunparse_proc = new Proc("unparse", (Procedure1) PJScheme.aunparse, 1, 1);
  public static Proc boolean_q_proc = new Proc("boolean?", (Procedure1Bool) boolean_q, 1, 2);
  public static Proc list_q_proc = new Proc("list?", (Procedure1Bool) list_q, 1, 2);
  public static Proc cadddr_hat_proc = new Proc("cadddr^",(Procedure1)PJScheme.cadddr_hat, 1, 1);
  public static Proc caddr_hat_proc = new Proc("caddr^",(Procedure1)PJScheme.caddr_hat, 1, 1);
  public static Proc cadr_hat_proc = new Proc("cadr^",(Procedure1)PJScheme.cadr_hat, 1, 1);
  public static Proc cadr_proc = new Proc("cadr", (Procedure1) cadr, 1, 1);
  public static Proc car_hat_proc = new Proc("car^",(Procedure1)PJScheme.car_hat, 1, 1);
  public static Proc car_proc = new Proc("car", (Procedure1) car, 1, 1);
  public static Proc caar_proc = new Proc("caar", (Procedure1) caar, 1, 1);
  public static Proc cdar_proc = new Proc("cdar", (Procedure1) cdar, 1, 1);
  public static Proc cddr_proc = new Proc("cddr", (Procedure1) cddr, 1, 1);
  public static Proc caaar_proc = new Proc("caaar", (Procedure1) caaar, 1, 1);
  public static Proc caadr_proc = new Proc("caadr", (Procedure1) caadr, 1, 1);
  public static Proc cadar_proc = new Proc("cadar", (Procedure1) cadar, 1, 1);
  public static Proc caddr_proc = new Proc("caddr", (Procedure1) caddr, 1, 1);
  public static Proc cdaar_proc = new Proc("cdaar", (Procedure1) cdaar, 1, 1); 
  public static Proc cdadr_proc = new Proc("cdadr", (Procedure1) cdadr, 1, 1);
  public static Proc cddar_proc = new Proc("cddar", (Procedure1) cddar, 1, 1); 
  public static Proc cdddr_proc = new Proc("cdddr", (Procedure1) cdddr, 1, 1);
  public static Proc caaaar_proc = new Proc("caaaar", (Procedure1) caaaar, 1, 1);
  public static Proc caaadr_proc = new Proc("caaadr", (Procedure1) caaadr, 1, 1);
  public static Proc caadar_proc = new Proc("caadar", (Procedure1) caadar, 1, 1);
  public static Proc caaddr_proc = new Proc("caaddr", (Procedure1) caaddr, 1, 1);
  public static Proc cadaar_proc = new Proc("cadaar", (Procedure1) cadaar, 1, 1); 
  public static Proc cadadr_proc = new Proc("cadadr", (Procedure1) cadadr, 1, 1);
  public static Proc caddar_proc = new Proc("caddar", (Procedure1) caddar, 1, 1); 
  public static Proc cadddr_proc = new Proc("cadddr", (Procedure1) cadddr, 1, 1);
  public static Proc cdaaar_proc = new Proc("cdaaar", (Procedure1) cdaaar, 1, 1);
  public static Proc cdaadr_proc = new Proc("cdaadr", (Procedure1) cdaadr, 1, 1);
  public static Proc cdadar_proc = new Proc("cdadar", (Procedure1) cdadar, 1, 1);
  public static Proc cdaddr_proc = new Proc("cdaddr", (Procedure1) cdaddr, 1, 1);
  public static Proc cddaar_proc = new Proc("cddaar", (Procedure1) cddaar, 1, 1);
  public static Proc cddadr_proc = new Proc("cddadr", (Procedure1) cddadr, 1, 1);
  public static Proc cdddar_proc = new Proc("cdddar", (Procedure1) cdddar, 1, 1);
  public static Proc cddddr_proc = new Proc("cddddr", (Procedure1) cddddr, 1, 1);
  public static Proc cdddr_hat_proc = new Proc("cdddr^",(Procedure1)PJScheme.cdddr_hat, 1, 1);
  public static Proc cddr_hat_proc = new Proc("cddr^",(Procedure1)PJScheme.cddr_hat, 1, 1);
  public static Proc cdr_hat_proc = new Proc("cdr^",(Procedure1)PJScheme.cdr_hat, 1, 1);
  public static Proc cdr_proc = new Proc("cdr", (Procedure1) cdr, 1, 1);
  public static Proc char_alphabetic_q_proc = new Proc("char-alphabetic?", (Procedure1Bool) char_alphabetic_q, 1, 2);
  public static Proc char_is__q_proc = new Proc("char=?", (Procedure2Bool) char_eq_q, 2, 2);
  public static Proc char_numeric_q_proc = new Proc("char-numeric?", (Procedure1Bool) char_numeric_q, 1, 2);
  public static Proc char_q_proc = new Proc("char?", (Procedure1Bool) char_q, 1, 2);
  public static Proc char_to_string_proc = new Proc("char->string", (Procedure1) char_to_string, 1, 1);
  public static Proc symbol_to_string_proc = new Proc("symbol->string", (Procedure1) symbol_to_string, 1, 1);
  public static Proc char_to_integer_proc = new Proc("char->integer", (Procedure1) char_to_integer, 1, 1);
  public static Proc integer_to_char_proc = new Proc("integer->char", (Procedure1) integer_to_char, 1, 1);
  public static Proc char_whitespace_q_proc = new Proc("char-whitespace?", (Procedure1Bool) char_whitespace_q, 1, 2);
  public static Proc cons_proc = new Proc("cons", (Procedure2) cons, 2, 1);
  public static Proc display_proc = new Proc("display", (Procedure1Void) display, 1, 0);
  public static Proc dlr_env_contains_proc = new Proc("dlr-env-contains",(Procedure1Bool)dlr_env_contains, 1, 2);
  public static Proc dlr_env_lookup_proc = new Proc("dlr-env-lookup",(Procedure1)dlr_env_lookup, 1, 1);
  public static Proc format_proc = new Proc("format", (Procedure1) format, -1, 1);
  public static Proc format_stack_trace_proc = new Proc("format-stack-trace", (Procedure1) PJScheme.format_stack_trace, 1, 1);
  public static Proc list_ref_proc = new Proc("list-ref", (Procedure2) list_ref, 2, 1);
  public static Proc list_to_string_proc = new Proc("list->string", (Procedure1) list_to_string, 1, 1);
  public static Proc list_to_vector_proc = new Proc("list->vector", (Procedure1) list_to_vector, 1, 1);
  public static Proc vector_to_list_proc = new Proc("vector->list", (Procedure1) vector_to_list, 1, 1);
  public static Proc eq_q_proc = new Proc("eq?", (Procedure2Bool) Eq, 2, 2);  
  public static Proc eqv_q_proc = new Proc("eqv?", (Procedure2Bool) Eqv, 2, 2);  
  public static Proc vector_q_proc = new Proc("vector?", (Procedure1Bool) vector_q, 1, 2);  
  public static Proc iter_q_proc = new Proc("iter?", (Procedure1Bool) iter_q, 1, 2);  
  public static Proc make_binding_proc = new Proc("make-binding",(Procedure2)PJScheme.make_binding, 2, 1);
  public static Proc make_external_proc_proc = new Proc("make-external-proc", (Procedure1) PJScheme.make_external_proc, 1, 1);
  public static Proc make_vector_proc = new Proc("make-vector", (Procedure1) make_vector, 1, 1);
  public static Proc make_string_proc = new Proc("make-string", (Procedure1) make_string, -1, 1);
  public static Proc memq_proc = new Proc("memq", (Procedure2) memq, 2, 1);
  public static Proc modulo_proc = new Proc("%", (Procedure1) modulo, -1, 1);
  public static Proc min_proc = new Proc("min", (Procedure1) min, -1, 1);
  public static Proc max_proc = new Proc("max", (Procedure1) max, -1, 1);
  public static Proc null_q_proc = new Proc("null?", (Procedure1Bool) null_q, 1, 2);
  public static Proc number_q_proc = new Proc("number?", (Procedure1Bool) number_q, 1, 2);
  public static Proc pair_q_proc = new Proc("pair?", (Procedure1Bool) pair_q, 1, 2);
  public static Proc pretty_print_proc = new Proc("pretty-print", (Procedure1Void) pretty_print, -1, 0);
  public static Proc printf_proc = new Proc("printf",(Procedure1)printf, -1, 1);
  public static Proc quotient_proc = new Proc("quotient", (Procedure2) quotient, 2, 1);
  public static Proc Range_proc = new Proc("range", (Procedure1) range, -1, 1);
  public static Proc remainder_proc = new Proc("modulo", (Procedure2) modulo, 2, 1);
  public static Proc reverse_proc = new Proc("reverse", (Procedure1) reverse, 1, 1);
  public static Proc safe_print_proc = new Proc("safe-print", (Procedure1Void)safe_print, 1, 0);
  public static Proc set_car_b_proc = new Proc("set-car!", (Procedure2Void) set_car_b, 2, 0);
  public static Proc set_cdr_b_proc = new Proc("set-cdr!", (Procedure2Void) set_cdr_b, 2, 0);
  public static Proc sort_proc = new Proc("sort", (Procedure2) sort, 2, 1);
  public static Proc sqrt_proc = new Proc("sqrt", (Procedure1) sqrt, -1, 1);
  public static Proc stringLessThan_q_proc = new Proc("string<?", (Procedure2Bool) stringLessThan_q, 2, 2);
  public static Proc string_append_proc = new Proc("string-append", (Procedure1) string_append, -1, 1);
  public static Proc string_is__q_proc = new Proc("string=?", (Procedure1Bool) PJScheme.string_eq_q, -1, 2);
  public static Proc string_length_proc = new Proc("string-length", (Procedure1) string_length, 1, 1);
  public static Proc string_q_proc = new Proc("string?", (Procedure1Bool) string_q, 1, 2);
  public static Proc string_ref_proc = new Proc("string-ref", (Procedure2) string_ref, 2, 1);
  public static Proc string_to_number_proc = new Proc("string->number", (Procedure1) string_to_number, 1, 1);
  public static Proc string_to_symbol_proc = new Proc("string->symbol", (Procedure1) string_to_symbol, 1, 1);
  public static Proc string_to_list_proc = new Proc("sting->list", (Procedure1) string_to_list, 1, 1);
  public static Proc symbol_q_proc = new Proc("symbol?", (Procedure1Bool) symbol_q, 1, 2);
  public static Proc vector_length_proc = new Proc("vector-length", (Procedure1) vector_length, 1, 1);
  public static Proc vector_native_proc = new Proc("vector", (Procedure1) vector_native, -1, 1);
  public static Proc vector_proc = new Proc("vector", (ProcedureN) vector, -1, 1);
  public static Proc vector_ref_proc = new Proc("vector-ref", (Procedure2) vector_ref, 2, 1);
  public static Proc snoc_proc = new Proc("snoc", (Procedure2) PJScheme.snoc, 2, 1);
  public static Proc rac_proc = new Proc("rac", (Procedure1) PJScheme.rac, 1, 1);
  public static Proc rdc_proc = new Proc("rdc", (Procedure1) PJScheme.rdc, 1, 1);
  public static Proc get_variables_from_frame_proc = new Proc("get_variables_from_frame", 
                                                                (Procedure1) PJScheme.get_variables_from_frame,
                                                                1, 1);
    public static Proc use_lexical_address_proc = new Proc("use-lexical-address", (Procedure1Bool)PJScheme.use_lexical_address, -1, 2);
    public static Proc dict_proc = new Proc("dict", (Procedure1)dict, 1, 1);
    public static Proc contains_native_proc = new Proc("contains", (Procedure2)contains_native, 2, 1);
    public static Proc getitem_native_proc = new Proc("getitem", (Procedure2)getitem_native, 2, 1);
    public static Proc setitem_native_proc = new Proc("setitem", (Procedure3)setitem_native, 3, 1);
    public static Proc property_proc = new Proc("property", (Procedure1)property, 1, 1);
    public static Proc reset_toplevel_env_proc = new Proc("reset-toplevel-env", (Procedure0Void)reset_toplevel_env, 0, 0);
    public static Proc string_split_proc = new Proc("string-split", (Procedure2)string_split, 2, 1);
    public static Proc make_symbol_proc = new Proc("make-symbol", (Procedure1)make_symbol, 1, 1);
    public static Proc type_proc = new Proc("type", (Procedure1)type, 1, 1);
    //public static Proc apply_lexical_address_proc = new Proc("apply-lexical-address", (Procedure1)apply_lexical_address, 1, 1);
    
    // Add new procedures above here!
    // Then add low-level C# code below

  public static char TILDE = '~';
  public static char NULL = '\0';
  public static char NEWLINE = '\n';
  public static char SINGLEQUOTE = '\'';
  public static char DOUBLEQUOTE = '"';
  public static char BACKQUOTE = '`';
  public static char BACKSPACE = '\b';
  public static char BACKSLASH = '\\';
  public static char SLASH = '/';
  public static char[] SPLITSLASH = {SLASH};
  public static string NEWLINE_STRING = "\n";

  public static bool true_q (object v) {
      // only #f is false, everything else is true
      if (v is bool) {
          return ((bool) v);
      } else
          return true;
  }

    public static bool procedure_q(object item) {
        return pair_q(item) && (Eq(car(item), PJScheme.symbol_procedure));
    }

  public static object get_current_time() {
        DateTime baseTime = new DateTime(1970, 1, 1, 8, 0, 0);
        DateTime nowInUTC = DateTime.UtcNow;
        return ((nowInUTC - baseTime).Ticks / 10000000.0);
  }

  public static object symbol_to_string (object x) {
        return x.ToString();
  }

  public static object string_split(object str, object delimiter) {
        return list(((String)str).Split((char) delimiter));
  }

  public static object make_proc(params object[] args) {
        return new Cons(PJScheme.symbol_procedure, list(args));
  }

  // given a name, return a function that given an array, returns object
  public static Procedure2 make_instance_proc(object tname) {
        return (path, args) => call_external_proc(tname, path, args);
  }
  
    public static object make_initial_env_extended (object names, object procs, object docstrings) {
      object primitives = PJScheme.symbol_emptylist;
      // add to this list
      object current = primitives;
      while (current != PJScheme.symbol_emptylist) {
                object sym = caar(current);
          if (true_q(member(sym, names))) {
              printf("WARNING: C# overwrites Scheme function '~s'\n", sym);
          }
          current = cdr(current);
      }
      /// -------------------
      names = PJScheme.append(names, map(car_proc, primitives));
      procs = PJScheme.append(procs, map(PJScheme.make_external_proc_proc, map(cadr_proc, primitives)));
      docstrings = PJScheme.append(docstrings, map(caddr_proc, primitives));
      return PJScheme.make_initial_environment(names, procs, docstrings);
  }
  
  public static void reset_toplevel_env() {
      PJScheme.initialize_globals();
  }
    
  public static object debug(object args) {
        if (((int) length(args)) == 0)
          return config.DEBUG;
        else 
          config.DEBUG = (int)car(args);
        return config.DEBUG;
  }

  public static object get_type(object obj) {
      // implements "typeof"
      if (obj == null)
          return null;
      return obj.GetType();
  }

  public static string[] get_parts(String filename, String delimiter) {
        int pos = filename.IndexOf(delimiter);
        string[] parts = null;
        if (pos != -1) {
          parts = new string[2];
          parts[0] = filename.Substring(0, pos);
          parts[1] = filename.Substring(pos + 1, filename.Length - pos - 1);
        } else {
          parts = new string[1];
          parts[0] = filename;
        }
        return parts;
  }

  static public Type[] get_arg_types(object objs) {
        int i = 0;
        Type[] retval = new Type[(int)length(objs)];
        object current = objs;
        while (!Eq(current, PJScheme.symbol_emptylist)) {
          object obj = car(current);
          if (Equal(obj, "null"))
                retval[i] = Type.GetType("System.Object");
          else
                retval[i] = obj.GetType();
          i++;
          current = cdr(current);
        }
        return retval;
  }

  public static Type get_the_type(String tname) {
        foreach (Assembly assembly in config.assemblies) {
          Type type = assembly.GetType(tname);
          if (type != null) {
                return type;
          }
        }
        return null;
  }

  public static object property (object args) {
        object the_obj = car(args);
        object property_list = cdr(args);
        return call_external_proc(the_obj, property_list, null);
  }

    public static bool odd_q(object obj) {
        return !Eq(modulo(obj, 2), 0);
    }

    public static bool even_q(object obj) {
        return Eq(modulo(obj, 2), 0);
    }

  public static object ToDouble(object obj) {
        try {
          return Convert.ToDouble(obj);
        } catch {
          if (obj is Rational) {
                return (double)((Rational)obj);
          } else
                throw new Exception(string.Format("can't convert object of type '{0}' to float", obj.GetType()));
        }
  }

  public static object ToInt(object obj) {
        try {
          return Convert.ToInt32(obj);
        } catch {
          if (obj is Rational) {
                return (int)((Rational)obj);
          } else {
              try {
                  return Convert.ToInt32(obj.ToString());
              } catch {
                  throw new Exception(string.Format("can't convert object of type '{0}' to int", obj.GetType()));
              }
          }
        }
  }
  
  public static object ToInteger(object obj) {
        try {
          return Convert.ToInt32(obj);
        } catch {
          if (obj is Rational) {
                return (int)((Rational)obj);
          } else if (obj is BigInteger) {
                 return obj;
          } else          
                throw new Exception(string.Format("can't convert object of type '{0}' to int", obj.GetType()));
        }
  }
  
  public static object ToRational(object obj1, object obj2) {
    return new Rational((int) obj1, (int)obj2);
  }
  
  public static object range(object args) { // range(start stop incr)
        if (list_q(args)) {
          int len = (int) length(args);
          if (len == 1) { // (range 100)
            return make_range(0, car(args), 1); 
          } else if (len == 2) { // (range start stop)
            return make_range(car(args), cadr(args), 1); 
          } else if (len == 3) { // (range start stop incr)
            return make_range(car(args), cadr(args), caddr(args)); 
          }
        }
        throw new Exception("improper args to range");
  }

  public static object make_range(object start, object stop, object incr) {
        object retval = PJScheme.symbol_emptylist;
        object tail = PJScheme.symbol_emptylist;
        if (LessThan(start, stop)) {
          for (object i = start; LessThan(i, stop); i = Add(i, incr)) {
            if (Eq(tail, PJScheme.symbol_emptylist)) {
              retval = list(i); // start of list
              tail = retval;
            } else { // a pair
              set_cdr_b(tail, new Cons(i, PJScheme.symbol_emptylist));
              tail = cdr(tail);
            }
          }
        } else {
          for (object i = start; GreaterThan(i, stop); i = Add(i, incr)) {
            if (Eq(tail, PJScheme.symbol_emptylist)) {
              retval = list(i); // start of list
              tail = retval;
            } else { // a pair
              set_cdr_b(tail, new Cons(i, PJScheme.symbol_emptylist));
              tail = cdr(tail);
            }
          }
        }
        return retval;
  }

  public static object list_tail(object lyst, object pos) {
        if (null_q(lyst)) {
          if (EqualSign(pos, 0))
                return PJScheme.symbol_emptylist;
          else
                throw new Exception("list-tail position beyond list");
        } else if (pair_q(lyst)) {
          object current = lyst;
          int current_pos = 0;
          while (!EqualSign(current_pos, pos)) {
                current = cdr(current);
                current_pos++;
          }
          return current;
        }
        throw new Exception("list-tail takes a list and a pos");
  }

  public static object list_head(object lyst, object pos) {
        if (null_q(lyst)) {
          if (EqualSign(pos, 0))
                return PJScheme.symbol_emptylist;
          else
                throw new Exception("list-head position beyond list");
        } else if (pair_q(lyst)) {
          object retval = PJScheme.symbol_emptylist;
          object current = lyst;
          object tail = PJScheme.symbol_emptylist;
          int current_pos = 0;
          while (!EqualSign(current_pos, pos)) {
                if (Eq(retval, PJScheme.symbol_emptylist)) {
                  retval = new Cons(car(current), PJScheme.symbol_emptylist);
                  tail = retval;
                } else {
                  set_cdr_b(tail, new Cons(car(current), PJScheme.symbol_emptylist));
                  tail = cdr(tail);
                }
                current = cdr(current);
                current_pos++;
          }
          return retval;
        }
        throw new Exception("list-head takes a list and a pos");
  }

  public static bool file_exists_q(object path_filename) {
        return File.Exists(path_filename.ToString());
  }

  public static bool stringLessThan_q(object a, object b) {
        // third argument is ignoreCase
        return (String.Compare(a.ToString(), b.ToString(), false) < 0);
  }

  public static object string_length(object str) {
        return str.ToString().Length;
  }

  public static object substring(object str, object start, object stop) {
        return str.ToString().Substring(((int)start), ((int)stop) - ((int)start));
  }

  public static void for_each(object proc, object items) {
        object current1 = items;
        // FIXME: compare on empty list assumes proper list
        // fix to work with improper lists
        while (!Eq(current1, PJScheme.symbol_emptylist)) {
          apply(proc, list(car(current1)));
          current1 = cdr(current1);
        }
  }

    public static object apply(object proc, object args) {
        if (proc is Proc)
            return ((Proc)proc).Call(args);
        else if (procedure_q(proc) && Eq(cadr(proc), PJScheme.symbol_b_extension_d)) {
            return ((Proc)caddr(proc)).Call(args);
        }
        throw new Exception(string.Format("invalid procedure: '{0}'", proc));
    }

  public static object apply(object proc, object args1, object args2) {
        if (proc is Proc)
          return ((Proc)proc).Call(args1, args2);
        else
          if (procedure_q(proc) && Eq(cadr(proc), PJScheme.symbol_b_extension_d))
                return ((Proc)caddr(proc)).Call(args1, args2);
          else
                throw new Exception(string.Format("invalid procedure: {0}", proc));
  }

  public static object filter(object proc, object args) {
        object retval = PJScheme.symbol_emptylist;
        object tail = retval;
        object current1 = args;
        while (!Eq(current1, PJScheme.symbol_emptylist)) {
          object result;
          if (pair_q(car(current1)))
                result = apply(proc, list(car(current1)));
          else
                result = apply(proc, car(current1));
          if (true_q(result)) {
              if (Eq(tail, PJScheme.symbol_emptylist)) {
                  retval = list(result); // start of list
                  tail = retval;
              } else { // pair
                  set_cdr_b(tail, new Cons(result, PJScheme.symbol_emptylist));
                  tail = cdr(tail);
              }
          }
          current1 = cdr(current1);
        }
        return retval;
  }

    public static object map_hat (object f_hat, object asexp) {
        if ((bool)PJScheme.null_q_hat(asexp))
            return list(PJScheme.atom_tag, PJScheme.symbol_emptylist, PJScheme.symbol_none);
        else
            return PJScheme.cons_hat(apply(f_hat, list(PJScheme.car_hat (asexp))),
                                     map_hat (f_hat, PJScheme.cdr_hat (asexp)),
                                     PJScheme.symbol_none);
    }

  public static object map(object proc, object args) {
      object retval = PJScheme.symbol_emptylist;
      object tail = retval;
      object current1 = args;
      while (!Eq(current1, PJScheme.symbol_emptylist)) {
          object result;
          if (pair_q(car(current1)))
              result = apply(proc, list(car(current1)));
          else
              result = apply(proc, car(current1));
          if (Eq(tail, PJScheme.symbol_emptylist)) {
              retval = list(result); // start of list
              tail = retval;
          } else { // pair
              set_cdr_b(tail, new Cons(result, PJScheme.symbol_emptylist));
              tail = cdr(tail);
          }
          current1 = cdr(current1);
      }
      return retval;
  }

  public static object map(object proc, object args1, object args2) {
        object retval = PJScheme.symbol_emptylist;
        object tail = PJScheme.symbol_emptylist;
        object current1 = args1;
        object current2 = args2;
        while (!Eq(current1, PJScheme.symbol_emptylist)) {
          object result = apply(proc, car(current1), car(current2));
          if (Eq(retval, PJScheme.symbol_emptylist)) {
                retval = new Cons( result, PJScheme.symbol_emptylist);
                tail = retval;
          } else {
                set_cdr_b( tail, new Cons(result, PJScheme.symbol_emptylist));
                tail = cdr(tail);
          }
          current1 = cdr(current1);
          current2 = cdr(current2);
        }
        return retval;
  }
        
    public static Func<object,bool> tagged_list_hat(object tag_symbol, object pred, object value) {
        return (object asexp) => {
            return (PJScheme.list_q_hat(asexp) && 
                    ((bool)(apply(pred, list(PJScheme.length_hat(asexp), value)))) &&
                    ((bool)(PJScheme.symbol_q_hat(PJScheme.car_hat(asexp)))) &&
                    ((bool)(PJScheme.eq_q_hat(PJScheme.car_hat(asexp), tag_symbol)))
                    );
        };
    }
        
  public static object vector_to_list(object obj) {
    return ((Vector)obj).ToList();
  }

  public static object apply_with_keywords(object args) {
      // proc '(1 2 3) (dict '("option4" 4) '("option5" 5))
      object proc = car(args);
      object pargs = cadr(args);
      object [] positional_args;      
      Hashtable named_args;

      if (pargs is Hashtable) { // no positional arguments
          positional_args = new object[0];
          named_args = (Hashtable)pargs; // hashtable
      } else { // some positional arguments
          positional_args = list_to_array(pargs);
          named_args = (Hashtable)caddr(args); // hashtable
      }

      // Make room for all args:
      object [] all_args = new object[positional_args.Length + named_args.Count];
      // Copy the passed in args:
      int i;
      for (i=0; i < positional_args.Length; i++) {
          all_args[i] = positional_args[i];
      }
      // Get the ones from the hashtable:
      int pos = positional_args.Length;
      i = 0;
      string [] names = new string[named_args.Count];
      foreach (DictionaryEntry pair in (System.Collections.Hashtable)named_args) {
          all_args[pos++] = pair.Value;
          names[i++] = pair.Key.ToString();
      }
      //System.Console.WriteLine("all_args: " + repr(all_args));
      //System.Console.WriteLine("names: " + repr(names));
      object retval = IronPython.Runtime.Operations.PythonCalls.CallWithKeywordArgs(
                 IronPython.Runtime.DefaultContext.Default, 
                 proc, 
                 all_args,
                 names);
      return retval;
  }

  public static object make_dict(object args) {
      Hashtable hashtable = new Hashtable();
      object current = args;
      while (!Eq(current, PJScheme.symbol_emptylist)) {
          hashtable[caar(current)] = cadar(current);
          current = cdr(current);
      }
      return hashtable;
  }

  public static object list_to_vector(object lyst) {
      if (list_q(lyst)) {
          int len = (int) length(lyst);
          object current = lyst;
          object[] retval = new object[len];
          for (int i = 0; i < len; i++) {
              retval[i] = car(current);
              current = cdr(current);
          }
          return new Vector(retval);
      } else {
          throw new Exception("argument is not a proper list");
      }
  }

    public static object vector_native(object lyst) {
        return list_to_vector(lyst);
    }

  public static object vector(params object [] array) {
          object lyst = list (array);
      return list_to_vector(lyst);
  }

  public static object make_vector(object size) {
    int len = (int) size;
    object[] retval = new object[len];
    for (int i = 0; i < len; i++) {
      retval[i] = 0;
    }
    return new Vector(retval);
  }

  public static object vector_set_b(object vector, object index, object value) {
    Vector v = (Vector) vector;
    int pos = (int) index;
    v.set(pos, value);
    return vector;
  }

  public static object vector_ref(object vector, object index) {
    Vector v = (Vector) vector;
    int pos = (int) index;
    return v.get(pos);
  }

  public static object vector_length(object vector) {
    Vector v = (Vector) vector;
    return v.length();
  }

  public static object [] list_to_array(object lyst) {
                return list_to_array(lyst, 0);
  }
        
  public static object [] list_to_array(object lyst, int start) {
        int len = (int) length(lyst) - start;
        object current = lyst;
        int j = 0;
        while (j < start) {
                current = cdr(current);
                j++;
        }
        object[] retval = new object[len];
        for (int i = 0; i < len; i++) {
          retval[i] = car(current);
          current = cdr(current);
        }
        return retval;
  }

  public static object string_ref(object args) {
      object s = car(args);
      object i = cadr(args);
      return string_ref(s, i);
  }

    public static object string_ref(object s, object i) {
        return Convert.ToChar(s.ToString()[Convert.ToInt32(i)]);
    }

  public static object make_string(object obj) {
      if (obj == null || obj == (object) NULL) {
          return (object) "\0";
      } else if (obj is Cons || obj == PJScheme.symbol_emptylist) {
          System.Text.StringBuilder retval = new System.Text.StringBuilder();
          while (obj != PJScheme.symbol_emptylist) {
              object car_lst = car(obj);
              retval.Append(char_to_string(car_lst));
              obj = cdr(obj);
          }
          return retval.ToString();
      } else {
          return obj.ToString();
      }
  }

  public static bool number_q(object datum) {
        return ((datum is int) ||
                (datum is double) ||
                (datum is Rational) ||
                (datum is BigInteger));
  }

  public static bool boolean_q(object datum) {
        return (datum is bool);
  }

  public static bool char_q(object datum) {
        return (datum is char);
  }

    public static bool char_eq_q(object c1, object c2) {
      return Equals(c1, c2);
  }

  public static bool string_q(object datum) {
        return (datum is string);
  }

  public static bool vector_q(object obj) {
        return (obj is Vector);
  }

  public static bool char_numeric_q(object c) {
        if (c == null) return false;
        return (('0' <= ((char)c)) && (((char)c) <= '9'));
  }

  public static bool symbol_q(object x) {
        return (x is Symbol && x != PJScheme.symbol_emptylist);
  }

  public static bool char_alphabetic_q(object o) {
        if (o is char) {
          char c = (char) o;
          return ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'));
        } 
        return false;
  }

  public static bool char_whitespace_q(object o) {
        if (o is char) {
          char c = (char) o;
          return (c == ' ' || c == '\t' || c == '\n' || c == '\r');
        }
        return false;
  }

  public static bool char_is__q(object c1, object c2) {
        return ((c1 is char) && (c2 is char) && ((char)c1) == ((char)c2));
  }

  public static bool string_is__q(object o1, object o2) {
        return ((o1 is string) && (o2 is string) && ((string)o1) == ((string)o2));
  }
  
  public static object string_to_list(object str) {
        object retval = PJScheme.symbol_emptylist;
        object tail = PJScheme.symbol_emptylist;
        if (str != null) {
            for (int i = 0; i < str.ToString().Length; i++) {
                if (Eq(retval, PJScheme.symbol_emptylist)) {
                    retval = new Cons(string_ref(str, i), PJScheme.symbol_emptylist);
                    tail = retval;
                } else {
                    set_cdr_b(tail, new Cons(string_ref(str, i), PJScheme.symbol_emptylist));
                    tail = cdr(tail);
                }
            }
        }
        return retval;
  }

  public static object string_to_symbol(object s) {
        return make_symbol(s.ToString());
  }

  public static object string_to_number(object s) {
      string ss = s.ToString();
      if (ss.Contains("."))
          return string_to_decimal(ss);
      else if (ss.Contains("/"))
          return string_to_rational(ss);
      else
          return string_to_integer(ss);
  }

  public static object string_to_integer(object str) {
        try {
          return int.Parse(str.ToString());
        } catch (OverflowException) {
          return BigIntegerParse(str.ToString());
        }
  }

  public static object string_to_decimal(object str) {
        return double.Parse(str.ToString());
  }

  public static object string_to_rational(object str) {
      try {
          string[] part = (str.ToString()).Split(SPLITSLASH);
          Rational retval = new Rational(part[0], part[1]);
          if (retval.denominator == 1)
              return retval.numerator;
          else
              return retval;
      } catch {
          return false;
      }
  }

  public static void error(object code, object msg) {
      throw new Exception(String.Format("Exception in {0}: {1}", code, msg));
  }

  public static void newline() {
        config.NEED_NEWLINE = false;
        Console.WriteLine("");
  }

  public static void display(object obj) {
        // FIXME: pass stdout port setting
        display(obj, null);
  }

  public static void display(object obj, object port) {
        // FIXME: add output port type
        string s = ToString(obj);
        int len = s.Length;
        if (s.Substring(len - 1, 1) != "\n") 
          config.NEED_NEWLINE = true;
        Console.Write(s);
  }

  public static Type[] get_types(object [] objects) {
    Type [] retval = new Type[objects.Length];
    int count = 0;
    foreach (object obj in objects) {
      retval[count] = obj.GetType();
      count++;
    }
    return retval;
  }

  public static object get_external_member(object obj, object parts_list) {
      return dlr_lookup_components(obj, cdr(parts_list));
  }

  public static object get_external_members(object obj) {
      object retval = PJScheme.symbol_emptylist;
      foreach (string name in _dlr_runtime.Operations.GetMemberNames(obj)) {
          retval = new Cons(name, retval);
      }
      return sort(PJScheme.make_external_proc(stringLessThan_q_proc), retval);
  }

    // FIXME: can't get Myro.robot.name after (Myro.init "sim")
    // Why not? I don't know;;; because it is a Python Member?

    public static object get_external_member(object obj, string name) {
        Type type = obj.GetType();
        MethodInfo method;
        try {
            method = type.GetMethod(name);
        } catch (System.Reflection.AmbiguousMatchException) {
            return new Method(obj, name);
        }
        if (method != null) { // not ambiguous
            //printf("GetMethod: {0}\n", method);
            return new Method(obj, name);
        }
        FieldInfo field = type.GetField(name);
        if (field != null) {
            //printf("GetField: {0}\n", field.GetValue(obj));
            return field.GetValue(obj);
        }
        PropertyInfo property = type.GetProperty(name);
        if (property != null) {
            //printf("GetProperty: {0}\n", property);
            return property;
            //return IronPython.Runtime.Types.DynamicHelpers.
            //GetPythonTypeFromType(property.GetType());
        }
        try {
            return _dlr_runtime.Operations.GetMember(obj, name);
        } catch {
            //pass
        }
        try {
            return _dlr_runtime.Operations.GetMember(obj, "get_Item");
        } catch {
            //pass
        }
        throw new Exception(String.Format("no such member: '{0}'", name));
    }
    
  public static object call_external_proc(object obj, object path, object args) {
      //string name = obj.ToString();
      //Type type = null;
      //type = get_the_type(name.ToString());
      Type type = obj.GetType();
      if (type != null) {
          //Type[] types = get_arg_types(args);
          object[] arguments = list_to_array(args);
          object result = get_external_member(obj, car(path).ToString());
          if (!null_q(result)) {
                if (Eq(car(result), PJScheme.symbol_method)) {
                  string method_name = cadr(result).ToString();
                  MethodInfo method = (MethodInfo) caddr(result);
                  object retval = method.Invoke(method_name, arguments);
                  return retval;
                } else if (Eq(car(result), PJScheme.symbol_field)) {
                  //string field_name = (string) cadr(result);
                  FieldInfo field = (FieldInfo) caddr(result);
                  try {
                        return field.GetValue(null); // null for static
                  } catch {
                        return field.GetValue(obj); // use obj for instance
                  }
                } else if (Eq(car(result), PJScheme.symbol_constructor)) {
                  //string ctor_name = (string) cadr(result);
                  ConstructorInfo constructor = (ConstructorInfo) caddr(result);
                  object retval = constructor.Invoke(arguments);
                  return retval;
                } else if (Eq(car(result), PJScheme.symbol_property)) {
                  string property_name = cadr(result).ToString();
                  PropertyInfo property = (PropertyInfo) caddr(result);
                  // ParameterInfo[] indexes = property.GetIndexParameters();
                  // to use interface, OR
                  // PropertyType.IsArray; to just get object then access
                  return property.GetValue(property_name, null); // non-indexed
                  //property.GetValue(property_name, index); // indexed
                } else {
                  throw new Exception(String.Format("don't know how to handle '{0}'?", result));
                }
          }
          return result;
        }
        throw new Exception(String.Format("no such external type '{0}'", type));
  }

  public static object import_as_native(object module, object name, object env) {
      object retval = list();
      // FIXME: not implemented!
      return retval;
  }

  public static object import_from_native(object module, object name_list, object env) {
      object retval = list();
      // FIXME: not implemented!
      return retval;
  }

  public static object import_native(object args, object env) {
      // Works with Python Types
      // implements "using"
      Assembly assembly = null;
      object retval = list();
      if (list_q(args)) {
          int len = (int) length(args);
          if (len > 0) { // (using "file.dll"), (using "System")
              String filename = car(args).ToString();
              try {
                  // FAILS without trying/catch when DEBUG in MonoDevelop
                  assembly = Assembly.Load(filename);
              } catch {
#pragma warning disable 612
                      assembly = Assembly.LoadWithPartialName(filename);
#pragma warning restore 612
              }
              // add assembly to assemblies
              if (assembly != null) {
                  config.AddAssembly(assembly);
                  if (_dlr_runtime != null) {
                      _dlr_runtime.LoadAssembly(assembly);
                      // then add each type to environment
                      // FIXME: optionally module name
                      foreach (Type type in assembly.GetTypes()) {
                          if (type.IsPublic) {
                              _dlr_env.SetVariable(type.Name, 
                                                   // Wrap with Python methods to make easy to use:
                                                   IronPython.Runtime.Types.DynamicHelpers.GetPythonTypeFromType(type));
                              retval = new Cons(type.Name, retval);
                          }
                      }
                  } else {
                      throw new Exception("DLR Runtime not available");
                  }
              } else {
                  throw new Exception(String.Format("external library '{0}' could not be loaded", filename));
              }
          } else {
              throw new Exception("using takes a DLL name, and optionally a moduleName");
          }
      } else {
          throw new Exception("using takes a DLL name, and optionally a moduleName");
      }
      return retval;
  }

  public static bool dlr_proc_q(object rator) {
      // Works with Python Types
      //Console.WriteLine("dlr-proc? {0}");
      //return (! pair_q(rator));
      return ((rator is IronPython.Runtime.Types.BuiltinFunction) ||
              (rator is IronPython.Runtime.PythonFunction) ||
              (rator is IronPython.Runtime.Method) ||
              (rator is Method) ||
              (rator is IronPython.Runtime.Types.PythonType) ||
              (rator is Closure));
  }
  
  public static object dlr_apply(object proc, object args) {
      // Works with Python Types
        //printf("dlr_apply({0}, {1})\n", proc, args);
        object retval;
        if (proc is Method) {
            retval = ((Method)proc).Invoke( list_to_array(args));
              return retval != null ? retval : PJScheme.symbol_b_void_d;
        } else if (proc is Closure) {
            return (proc as Closure)(list_to_array(args));
        } else {
            if (_dlr_runtime != null) {
                retval = _dlr_runtime.Operations.Invoke(proc, list_to_array(args));
                return retval != null ? retval : PJScheme.symbol_b_void_d;
            } else {
                throw new Exception(String.Format("DLR Runtime not available"));
            }
        }
  }

  public static bool dlr_env_contains(object variable) {
        bool retval = true;
        if (_dlr_env != null) {
            try {
                _dlr_env.GetVariable(variable.ToString());
            } catch {
                retval = false;
            }
        } else {
            retval = false;
        }
        return retval;
  }

  public static object dlr_env_lookup(object variable) {
        if (_dlr_env != null)  {
            return _dlr_env.GetVariable(variable.ToString());
        } else {
            throw new Exception(String.Format("DLR Environment not available"));
        }
  }

  public static object dlr_env_list() {
    object retval = list();
    try {
          if (_dlr_env != null) {
                foreach (string variable in _dlr_env.GetVariableNames()) {
                  retval = new Cons(variable, retval);
                }
          } else {
                throw new Exception(String.Format("DLR Environment not available"));
          }
    } catch {
    }
    return retval;
  }

  public static bool dlr_object_contains(object result, object components) {
      // checks to see if a dlr_object contains the parts_list
      //printf("dlr_object_contains: {0}, {1}\n", result, components);
      object parts_list = cdr(components); // skip the first component, the object
      object retobj = result;
      if (_dlr_runtime != null) {
          while (pair_q(parts_list)) {
              //printf("   dlr_object_contains: part: {0}, '{1}'\n", retobj, car(parts_list));
              //printf("members: {0}", get_external_members(retobj));
              try{
                  retobj = _dlr_runtime.Operations.GetMember(retobj, car(parts_list).ToString());
                  //retobj = IronPython.Runtime.Types.DynamicHelpers.GetPythonTypeFromType(retobj);
              } catch {
                  //printf("contains, trying : message is {0}\n", e.Message);
                  try {
                      //printf("members: {0}", get_external_members(retobj));
                      if (true_q(member(car(parts_list).ToString(), get_external_members(retobj)))) {
                          //printf("return true (member)\n");
                          return true;
                      }
                      //retobj = _dlr_runtime.Operations.GetMember(retobj, 
                      //                                         format("Get__{0}__", car(parts_list).ToString()));
                      //retobj = retobj.Invoke();
                  } catch {
                      //printf("contains: false {0}(catch catch)\n", e.Message);
                      return false;
                  }
              }
              parts_list = cdr(parts_list);
          }
      } else {
          //printf("contains: false (no dlr)\n");
          return false;
      }
      //printf("contains: true\n");
      return true;
  }

  public static object dlr_lookup_components(object result, object parts_list) {
      //printf("dlr_lookup_components: {0}, {1}\n", result, parts_list);
      object retobj = result;
      if (_dlr_runtime != null) {
          while (pair_q(parts_list)) {
              //printf("   dlr_object_contains: part: {0}, '{1}'\n", retobj, car(parts_list));
              //printf("members: {0}", get_external_members(retobj));
               // fixme: needs to use args to get method
              try {
                  retobj = _dlr_runtime.Operations.GetMember(retobj, car(parts_list).ToString());
                  //retobj = IronPython.Runtime.Types.DynamicHelpers.GetPythonTypeFromType(retobj.GetType());
              } catch {
                  return get_external_member(result, car(parts_list).ToString());
                  //throw new Exception(String.Format("invalid member of {0}: '{1}'", retobj, car(parts_list).ToString()));
              }
              parts_list = cdr(parts_list);
          }
      } else {
          throw new Exception(String.Format("DLR Runtime not available"));
      }
      return retobj;
  }

  public static object printf(object args) {
        int len = ((int) length(args)) - 1;
        // FIXME: surely there is a better way?:
        if (len == 0)
          Console.Write(format(car(args), PJScheme.symbol_emptylist));
        else if (len == 1)
          Console.Write(format(car(args), cadr(args)));
        else if (len == 2)
          Console.Write(format(car(args), cadr(args), caddr(args)));
        else if (len == 3)
          Console.Write(format(car(args), cadr(args), caddr(args), cadddr(args)));
        else if (len == 4)
          Console.Write(format(car(args), cadr(args), caddr(args), cadddr(args), 
                          cadddr(cdr(args))));
        else if (len == 5)
          Console.Write(format(car(args), cadr(args), caddr(args), cadddr(args), 
                          cadddr(cdr(args)), cadddr(cdr(cdr(args)))));
        else if (len == 6)
            Console.Write(format(car(args), cadr(args), caddr(args), cadddr(args), 
                                 cadddr(cdr(args)), cadddr(cdr(cdr(args))), cadddr(cdr(cdr(cdr(args))))));
        return null;
  }
  
  public static object printf(object fmt, params object[] objs) {
        Console.Write(format(fmt, objs));
        return null;
  }

  public static string ToString(object obj) {
      Dictionary<int,bool> ids = new Dictionary<int,bool>();
      return repr(obj, ids, false);
  }

  public static string repr(object obj) {
      Dictionary<int,bool> ids = new Dictionary<int,bool>();
      return repr(obj, ids, true);
  }

    public static string repr(object obj, Dictionary<int,bool> ids, bool require_quotes) {
        if (obj == null) {
          return "<void>"; // FIXME: should give void when forced
        } else if (obj is System.Char) {
          return String.Format("#\\{0}", obj.ToString());
        } else if (obj is System.Boolean) {
          return ((bool)obj) ? "#t" : "#f";
        } else if (obj is IronPython.Runtime.List) {
          return ((IronPython.Runtime.List)obj).__repr__(
                  IronPython.Runtime.DefaultContext.Default);
        } else if (obj is IronPython.Runtime.PythonDictionary) {
          return ((IronPython.Runtime.PythonDictionary)obj).__repr__(
                  IronPython.Runtime.DefaultContext.Default);
        } else if (obj is IronPython.Runtime.PythonTuple) {
          return obj.ToString();
        } else if (obj is System.Collections.Hashtable) {
            string retval = "";
            foreach (DictionaryEntry pair in (System.Collections.Hashtable)obj) {
                retval += String.Format(" '({0} {1})", repr(pair.Key), repr(pair.Value));
            }
            return "(dict" + retval + ")";
        } else if (obj is Array) {
            //System.Console.WriteLine("Here 1");
          return (string)array_to_string((object[]) obj);
        } else if (obj is double) {
          string s = obj.ToString();
          if (s.Contains("."))
                return s;
          else
                return String.Format("{0}.0", s);
        } else if (obj is String) {
            if (require_quotes) {
                return String.Format("\"{0}\"", obj);
            } else {
                return String.Format("{0}", obj);
            }
        } else if (obj is Symbol) {
            //System.Console.WriteLine("Here 2");
          return obj.ToString();
        } else if (pair_q(obj)) {
            //System.Console.WriteLine("Here 3");
          if (procedure_q(obj)) {
                return "#<procedure>";
          } else if (Eq(car(obj), PJScheme.symbol_environment)) {
                return "#<environment>"; //, car(obj));
          } else {
              return obj.ToString(); /// FIXME:
          }
        } else {
            return obj.ToString();
        }
  }

  public static string format_list(object args) {
        if (pair_q(args)) {
          int len = (int)length(args);
          if (len == 1)
                return format(car(args), new object[0]);
          else if (len > 1) {
                object[] options = list_to_array(cdr(args));
                return format(car(args), options);
          }
        }
        throw new Exception("invalid args to format");
  }

  public static MethodInfo get_method(object obj, string method_name) {
      Type t = obj.GetType();
      MethodInfo[] mi = t.GetMethods();
      foreach(MethodInfo m in mi) {
          if (m.Name == method_name) {
              return m;
          }
      }
      return null;
  }

  public static string format(object msg, params object[] rest) {
        System.Text.StringBuilder new_msg = new System.Text.StringBuilder();
        string smsg = msg.ToString();
        int count = 0;
        for (int i = 0; i < smsg.Length; i++) {
            if (smsg[i] == TILDE) {
                if (smsg[i+1] == 's') {
                    new_msg.Append(repr(rest[count]));
                    count += 1;
                    i++;
                } else if (smsg[i+1] == 'a') {
                    new_msg.Append(ToString(rest[count]));
                    count += 1;
                    i++;
                } else if (smsg[i+1] == '%') {
                    new_msg.Append("\n");
                    i++;
                } else
                    throw new Exception(string.Format("format needs to handle: \"{0}\"", 
                                                      smsg));
            } else {
                new_msg.Append(smsg[i]);
            }
        }
        return new_msg.ToString();
  }

    public static bool string_eq_q(object args) {
        return (car(args).ToString() == (cadr(args).ToString()));
    }

  public static bool GreaterOrEqual(object args) {
        return GreaterOrEqual(car(args), cadr(args));
  }

  public static bool GreaterOrEqual(object obj1, object obj2) {
        if (obj1 is Symbol) {
          //           if (obj2 is Symbol) {
          //                 return (((Symbol)obj1) >= ((Symbol)obj2));
          //           } else 
          return false;
        } else {
          try {
                return (ObjectType.ObjTst(obj1, obj2, false) >= 0);
          } catch {
                return false;
          }
        }
  }

  public static int cmp(object obj1, object obj2) {
        if (obj1 is Symbol) {
          if (obj2 is Symbol) {
                return cmp(obj1.ToString(), obj2.ToString());
          } else 
                return cmp(obj1.ToString(), obj2);
        } else {
          if (obj2 is Symbol) {
                return cmp(obj1, obj2.ToString());
          } else {
                return ObjectType.ObjTst(obj1, obj2, false);
          }
        }
  }

  public static bool Equal(object obj) {
        object item = car(obj);
        object current = cdr(obj);
        while (!Eq(current, PJScheme.symbol_emptylist)) {
          if (! Equal(item, car(current)))
                return false;
          current = cdr(current);
        }
        return true;
  }

  public static bool EqualSign(object obj) {
        object item = car(obj);
        object current = cdr(obj);
    return EqualSign(item, car(current));
  }

  public static bool Eq(object obj) {
    return Eq(car(obj), cadr(obj));
  }

  public static bool Eqv(object obj) {
      object item = car(obj);
      object current = cadr(obj);
      return Eqv(item, current);
  }

  public static bool Eq(object obj1, object obj2) {
      if ((obj1 is bool) && (obj2 is bool))
          return ((bool)obj1) == ((bool)obj2);
      else if ((obj1 is int) && (obj2 is int))
          return ((int)obj1) == ((int)obj2);
      else if ((obj1 is float) && (obj2 is float))
          return ((float)obj1) == ((float)obj2);
      else if ((obj1 is BigInteger) && (obj2 is BigInteger))
          return ((BigInteger)obj1) == ((BigInteger)obj2);
      else if ((obj1 is Rational) && (obj2 is Rational))
          return ((Rational)obj1) == ((Rational)obj2);
      return Object.ReferenceEquals(obj1, obj2);
  }

  public static bool Eqv(object a, object b) {
      if (number_q(a) && number_q(b)) {
          // but be same type, and value
          return a.GetType() == b.GetType() && Equal(a, b);
      } else if (char_q(a) && char_q(b)) {
          return a == b;
      } else {
          return Eq(a, b);
      }
  }

  public static bool Equal(object obj1, object obj2) {
      while (true) {
          if (obj1 == null) {
              return (obj2 == null);
          } else if (obj2 == null) {
              return false;
          } else if ((obj1 is Symbol) || (obj2 is Symbol)) { 
              if ((obj1 is Symbol) && (obj2 is Symbol))
                  return ((Symbol)obj1).Equals(obj2);
              else 
                  return false;
          } else if (pair_q(obj1) && pair_q(obj2)) {
              if (null_q(obj1) && null_q(obj2)) {
                  return true;
              } else if (null_q(obj1) || null_q(obj2)) {
                  return false;
              } else if (Equal(car(obj1),  car(obj2))) {
                  // recursive:
                  obj1 = cdr(obj1);
                  obj2 = cdr(obj2);
              } else {
                  return false;
              }
          } else if (pair_q(obj1) || pair_q(obj2)) {
              return false;
          } else {
              if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
                  try {
                      return (ObjectType.ObjTst(obj1, obj2, false) == 0);
                  } catch {
                      return false;
                  }
              } else {
                  if (obj1 is BigInteger) {
                      return ((BigInteger)obj1).Equals(obj2);
                  } else {
                      return ((BigInteger)obj2).Equals(obj1);
                  }
              }
          }
      }
  }

  public static bool EqualSign(object obj1, object obj2) {
         if ((obj1 is Symbol) && (obj2 is Symbol)) {
           return (((Symbol)obj1).Equals(obj2));
        } else if ((obj1 is int) && (obj2 is int)) {
          return ((int)obj1) == ((int)obj2);
        } else if ((obj1 is double) && (obj2 is double)) {
          return ((double)obj1) == ((double)obj2);
        } else if (obj1 is Rational) {
      if (obj2 is Rational) {
        return (((Rational)obj1).Equals((Rational)obj2));
      } else if (obj2 is int) {
        return (((double)((Rational)obj1)) == ((int)obj2));
      } else if (obj2 is double) {
        return (((double)((Rational)obj1)) == ((double)obj2));
      } else {
        throw new Exception("can't compare rational with this object");
      }
    } else if (obj2 is Rational) {
      if (obj1 is Rational) {
        return (((Rational)obj2).Equals((Rational)obj1));
      } else if (obj1 is int) {
        return (((double)((Rational)obj2)) == ((int)obj1));
      } else if (obj1 is double) {
        return (((double)((Rational)obj2)) == ((double)obj1));
      } else {
        throw new Exception("can't compare rational with this object");
      }
    } else {
          if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
        try {
          return (ObjectType.ObjTst(obj1, obj2, false) == 0);
        } catch {
          return false;
        }
      } else {
        if (obj1 is BigInteger) {
          return ((BigInteger)obj1).Equals(obj2);
        } else {
          return ((BigInteger)obj2).Equals(obj1);
        }
      }
        }
  }

  public static bool LessThan(object obj) {
        return LessThan(car(obj), cadr(obj));
  }

  public static bool LessThan(object obj1, object obj2) {
        if (obj1 is Rational) {
          if (obj2 is Rational) {
                return (((Rational)obj1) < ((Rational)obj2));
          } else if (obj2 is int) {
                return (((Rational)obj1) < ((int)obj2));
          } else if (obj2 is double) {
                return (((double)((Rational)obj1)) < ((double)obj2));
          }
        } else if (obj2 is Rational) {
          if (obj1 is Rational) {
                return (((Rational)obj1) < ((Rational)obj2));
          } else if (obj1 is int) {
                return (((Rational)obj2) < ((int)obj1));
          } else if (obj1 is double) {
                return (((double)((Rational)obj2)) < ((double)obj1));
          }
        } else {
          if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
                try {
                  return (ObjectType.ObjTst(obj1, obj2, false) < 0);
                } catch {
                  // ignore and continue
                }
          }
          BigInteger? b1 = null;
          BigInteger? b2 = null;
          if (obj1 is int) {
                b1 = makeBigInteger((int) obj1);
          } else if (obj1 is BigInteger) {
                b1 = (BigInteger)obj1;
          } else
                throw new Exception(string.Format("can't convert {0} to bigint", obj1.GetType()));
          if (obj2 is int) {
                b2 = makeBigInteger((int) obj2);
          } else if (obj2 is BigInteger) {
                b2 = (BigInteger)obj2;
          } else
                throw new Exception(string.Format("can't convert {0} to bigint", obj2.GetType()));
          return b1 < b2;
        }
        throw new Exception(String.Format("unable to compare {0} and {1}", 
                        obj1.GetType().ToString(), obj2.GetType().ToString()));
  }

  public static bool LessThanOrEqual(object obj) {
        return (LessThan(car(obj), cadr(obj)) || Equal(car(obj), cadr(obj)));
  }

  public static bool GreaterThanEqual(object obj) {
        return (GreaterThan(car(obj), cadr(obj)) || Equal(car(obj), cadr(obj)));
  }

  public static bool GreaterThanEqual(object obj1, object obj2) {
        if (obj1 is Rational) {
          if (obj2 is Rational) {
                return (((Rational)obj1) >= ((Rational)obj2));
          } else if (obj2 is int) {
                return (((Rational)obj1) >= ((int)obj2));
          } else if (obj2 is double) {
                return (((double)((Rational)obj1)) >= ((double)obj2));
          }
        } else if (obj2 is Rational) {
          if (obj1 is Rational) {
                return (((Rational)obj1) >= ((Rational)obj2));
          } else if (obj1 is int) {
                return (((Rational)obj2) >= ((int)obj1));
          } else if (obj1 is double) {
                return (((double)((Rational)obj2)) >= ((double)obj1));
          }
        } else {
          if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
        try {
          return (ObjectType.ObjTst(obj1, obj2, false) >= 0);
        } catch {
          // continue
        }
      }
      BigInteger? b1 = null;
      BigInteger? b2 = null;
      if (obj1 is int) {
        b1 = makeBigInteger((int) obj1);
      } else if (obj1 is BigInteger) {
        b1 = (BigInteger)obj1;
      } else
        throw new Exception(string.Format("can't convert {0} to bigint", obj1.GetType()));
      if (obj2 is int) {
        b2 = makeBigInteger((int) obj2);
      } else if (obj2 is BigInteger) {
        b2 = (BigInteger)obj2;
      } else
        throw new Exception(string.Format("can't convert {0} to bigint", obj2.GetType()));
      return b1 >= b2;
        }
        throw new Exception(String.Format("unable to compare {0} and {1}", 
                        obj1.GetType().ToString(), obj2.GetType().ToString()));
  }

  public static bool GreaterThan(object args) {
        return GreaterThan(car(args), cadr(args));
  }

  public static bool GreaterThan(object obj1, object obj2) {
        if (obj1 is Rational) {
          if (obj2 is Rational) {
                return (((Rational)obj1) > ((Rational)obj2));
          } else if (obj2 is int) {
                return (((Rational)obj1) > ((int)obj2));
          } else if (obj2 is double) {
                return (((double)((Rational)obj1)) > ((double)obj2));
          }
        } else if (obj2 is Rational) {
          if (obj1 is Rational) {
                return (((Rational)obj1) > ((Rational)obj2));
          } else if (obj1 is int) {
                return (((Rational)obj2) > ((int)obj1));
          } else if (obj1 is double) {
                return (((double)((Rational)obj2)) > ((double)obj1));
          }
        } else {
          if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
        try {
          return (ObjectType.ObjTst(obj1, obj2, false) > 0);
        } catch {
          // continue
        }
      }
      BigInteger? b1 = null;
      BigInteger? b2 = null;
      if (obj1 is int) {
        b1 = makeBigInteger((int) obj1);
      } else if (obj1 is BigInteger) {
        b1 = (BigInteger)obj1;
      } else
        throw new Exception(string.Format("can't convert {0} to bigint", obj1.GetType()));
      if (obj2 is int) {
        b2 = makeBigInteger((int) obj2);
      } else if (obj2 is BigInteger) {
        b2 = (BigInteger)obj2;
      } else
        throw new Exception(string.Format("can't convert {0} to bigint", obj2.GetType()));
      return b1 > b2;
        }
        throw new Exception(String.Format("unable to compare {0} and {1}", 
                        obj1.GetType().ToString(), obj2.GetType().ToString()));
  }

  public static bool not(object obj) {
        return (! true_q(obj));
  }

  public static object Add(object obj) {
        // For adding 0 or more numbers in list
        object retval = 0;
        object current = obj;
        while (!Eq(current, PJScheme.symbol_emptylist)) {
          retval = Add(retval, car(current));
          current = cdr(current);
        }
        return retval;
  }

  public static object Multiply(object obj) {
        // For multiplying 0 or more numbers in list
        object retval = 1;
        object current = obj;
        while (!Eq(current, PJScheme.symbol_emptylist)) {
          retval = Multiply(retval, car(current));
          current = cdr(current);
        }
        return retval;
  }

  public static object Subtract(object obj) {
        // For subtracting 1 or more numbers in list
        object retval = car(obj);
        object current = cdr(obj);
        if (((int)length(current)) == 0) {
          retval = Multiply(-1, retval);
        } else {
          while (!Eq(current, PJScheme.symbol_emptylist)) {
                retval = Subtract(retval, car(current));
                current = cdr(current);
          }
        }
        return retval;
  }
        
  public static object quotient(object num1, object num2) {
      return ToInteger(Divide(num1, num2));
  }

  public static object Divide(object obj) {
        // For dividing 1 or more numbers in list
        object retval = car(obj);
        object current = cdr(obj);
        if (((int)length(current)) == 0) {
          retval = Divide(1, retval);
        } else {
          while (!Eq(current, PJScheme.symbol_emptylist)) {
                retval = Divide(retval, car(current));
                current = cdr(current);
          }
        }
        return retval;
  }

    public static object min(object obj) {
        object retval = car(obj);
        object current = cdr(obj);
        while (!Eq(current, PJScheme.symbol_emptylist)) {
            object current_value = car(current);
            if (LessThan(current_value, retval))
                retval = current_value;
            current = cdr(current);
        }
        return retval;
    }

    public static object max(object obj) {
        object retval = car(obj);
        object current = cdr(obj);
        while (!Eq(current, PJScheme.symbol_emptylist)) {
            object current_value = car(current);
            if (GreaterThan(current_value, retval))
                retval = current_value;
            current = cdr(current);
        }
        return retval;
    }

    public static object modulo(object obj) {
        object obj1 = car(obj);
        object obj2 = cadr(obj);
        return modulo(obj1, obj2);
    }
    
    public static object modulo(object obj1, object obj2) {
        if (obj1 is Rational) {
          if (obj2 is Rational) {
                return (((Rational)obj1) % ((Rational)obj2));
          } else if (obj2 is int) {
                return (((Rational)obj1) % ((int)obj2));
          } else if (obj2 is double) {
                return (((double)((Rational)obj1)) % ((double)obj2));
          }
        } else if (obj2 is Rational) {
          if (obj1 is Rational) {
                return (((Rational)obj1) % ((Rational)obj2));
          } else if (obj1 is int) {
                return (((Rational)obj2) % ((int)obj1));
          } else if (obj1 is double) {
                return (((double)((Rational)obj2)) % ((double)obj1));
          }
        } else {
          if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
                try {
                  return (ObjectType.Modulo(obj1, obj2));
                } catch {
                  // pass
                }
          }
          BigInteger? b1 = null;
          BigInteger? b2 = null;
          if (obj1 is int) {
                b1 = makeBigInteger((int) obj1);
          } else if (obj1 is BigInteger) {
                b1 = (BigInteger)obj1;
          } else
                throw new Exception(string.Format("can't convert {0} to bigint", obj1.GetType()));
          if (obj2 is int) {
                b2 = makeBigInteger((int) obj2);
          } else if (obj2 is BigInteger) {
                b2 = (BigInteger)obj2;
          } else
                throw new Exception(string.Format("can't convert {0} to bigint", obj2.GetType()));
          return b1 % b2;
        }
        throw new Exception(String.Format("unable to add {0} and {1}", 
                        obj1.GetType().ToString(), obj2.GetType().ToString()));
  }

  public static object Add(object obj1, object obj2) {
        if (obj1 is Rational) {
          if (obj2 is Rational) {
                return (((Rational)obj1) + ((Rational)obj2));
          } else if (obj2 is int) {
                return (((Rational)obj1) + ((int)obj2));
          } else if (obj2 is double) {
                return (((double)((Rational)obj1)) + ((double)obj2));
          }
        } else if (obj2 is Rational) {
          if (obj1 is Rational) {
                return (((Rational)obj1) + ((Rational)obj2));
          } else if (obj1 is int) {
                return (((Rational)obj2) + ((int)obj1));
          } else if (obj1 is double) {
                return (((double)((Rational)obj2)) + ((double)obj1));
          }
        } else {
          if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
                try {
                  return (ObjectType.AddObj(obj1, obj2));
                } catch {
                  // pass
                }
          }
          BigInteger? b1 = null;
          BigInteger? b2 = null;
          if (obj1 is int) {
                b1 = makeBigInteger((int) obj1);
          } else if (obj1 is BigInteger) {
                b1 = (BigInteger)obj1;
          } else
                throw new Exception(string.Format("can't convert {0} to bigint", obj1.GetType()));
          if (obj2 is int) {
                b2 = makeBigInteger((int) obj2);
          } else if (obj2 is BigInteger) {
                b2 = (BigInteger)obj2;
          } else
                throw new Exception(string.Format("can't convert {0} to bigint", obj2.GetType()));
          return b1 + b2;
        }
        throw new Exception(String.Format("unable to add {0} and {1}", 
                        obj1.GetType().ToString(), obj2.GetType().ToString()));
  }

  public static object Subtract(object obj1, object obj2) {
        if (obj1 is Rational) {
          if (obj2 is Rational) {
                return (((Rational)obj1) - ((Rational)obj2));
          } else if (obj2 is int) {
                return (((Rational)obj1) - ((int)obj2));
          } else if (obj2 is double) {
                return (((double)((Rational)obj1)) - ((double)obj2));
          }
        } else if (obj2 is Rational) {
          if (obj1 is Rational) {
                return (((Rational)obj1) - ((Rational)obj2));
          } else if (obj1 is int) {
                return (((int)obj1) - ((Rational)obj2));
          } else if (obj1 is double) {
                return (((double)((double)obj1)) - ((Rational)obj2));
          }
        } else {
          if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
        try {
          return (ObjectType.SubObj(obj1, obj2));
        } catch {
          // ignore and continue
        }
      }
      BigInteger? b1 = null;
      BigInteger? b2 = null;
      if (obj1 is int) {
        b1 = makeBigInteger((int) obj1);
      } else if (obj1 is BigInteger) {
        b1 = (BigInteger)obj1;
      } else
        throw new Exception(string.Format("can't convert {0} to bigint", obj1.GetType()));
      if (obj2 is int) {
        b2 = makeBigInteger((int) obj2);
      } else if (obj2 is BigInteger) {
        b2 = (BigInteger)obj2;
      } else
        throw new Exception(string.Format("can't convert {0} to bigint", obj2.GetType()));
      return b1 - b2;
        }
        throw new Exception(String.Format("unable to subtract {0} and {1}", 
                        obj1.GetType().ToString(), obj2.GetType().ToString()));
  }

  public static object Multiply(object obj1, object obj2) {
        // FIXME: need hierarchy of numbers, handle rational/complex/etc
        if (obj1 is int && ((int)obj1) == 1) return obj2;
        if (obj2 is int && ((int)obj2) == 1) return obj1;
        if (obj1 is Rational) {
          if (obj2 is Rational) {
                return (((Rational)obj1) * ((Rational)obj2));
          } else if (obj2 is int) {
                return (((Rational)obj1) * ((int)obj2));
          } else if (obj2 is double) {
                return (((double)((Rational)obj1)) * ((double)obj2));
          }
        } else if (obj2 is Rational) {
          if (obj1 is Rational) {
                return (((Rational)obj1) * ((Rational)obj2));
          } else if (obj1 is int) {
                return (((Rational)obj2) * ((int)obj1));
          } else if (obj1 is double) {
                return (((double)((Rational)obj2)) * ((double)obj1));
          }
        } else {
          if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
        try {
          return ObjectType.MulObj(obj1, obj2);
        } catch {
          // continue
        }
      }
      BigInteger? b1 = null;
      BigInteger? b2 = null;
      if (obj1 is int) {
        b1 = makeBigInteger((int) obj1);
      } else if (obj1 is BigInteger) {
        b1 = (BigInteger)obj1;
      } else
        throw new Exception(string.Format("can't convert {0} to bigint", obj1.GetType()));
      if (obj2 is int) {
        b2 = makeBigInteger((int) obj2);
      } else if (obj2 is BigInteger) {
        b2 = (BigInteger)obj2;
      } else
        throw new Exception(string.Format("can't convert {0} to bigint", obj2.GetType()));
      return b1 * b2;
        }
        throw new Exception(String.Format("unable to multiply {0} and {1}", 
                        obj1.GetType().ToString(), obj2.GetType().ToString()));
  }

  public static object Divide(object obj1, object obj2) {
      Rational rat;
      if ((obj1 is int) && (obj2 is int)) {
          rat = new Rational((int)obj1, (int)obj2);
          if (rat.denominator == 1)
              return rat.numerator;
          else
              return rat;
      } else {
          if (obj1 is Rational) {
              if (obj2 is Rational) {
                  rat = (((Rational)obj1) / ((Rational)obj2));
                  if (rat.denominator == 1)
                      return rat.numerator;
                  else
                      return rat;
              } else if (obj2 is int) {
                  rat = (((Rational)obj1) / ((int)obj2));
                  if (rat.denominator == 1)
                      return rat.numerator;
                  else
                      return rat;
              } else if (obj2 is double) {
                  return (((double)((Rational)obj1)) / ((double)obj2));
              }
          } else if (obj2 is Rational) {
              if (obj1 is Rational) {
                  rat = (((Rational)obj1) / ((Rational)obj2));
          if (rat.denominator == 1)
            return rat.numerator;
          else
            return rat;
                } else if (obj1 is int) {
                  rat = (((int)obj1) / ((Rational)obj2));
          if (rat.denominator == 1)
            return rat.numerator;
          else
            return rat;
                } else if (obj1 is double) {
                  return (((double)obj1) / ((Rational)obj2));
                }
          } else {
        if (! ((obj1 is BigInteger) || (obj2 is BigInteger))) {
          try {
            return (ObjectType.DivObj(obj1, obj2));
          } catch {
            // ignore and continue
          }
        }
        BigInteger? b1 = null;
        BigInteger? b2 = null;
        if (obj1 is int) {
          b1 = makeBigInteger((int) obj1);
        } else if (obj1 is BigInteger) {
          b1 = (BigInteger)obj1;
        } else
          throw new Exception(string.Format("can't convert {0} to bigint", obj1.GetType()));
        if (obj2 is int) {
          b2 = makeBigInteger((int) obj2);
        } else if (obj2 is BigInteger) {
          b2 = (BigInteger)obj2;
        } else
          throw new Exception(string.Format("can't convert {0} to bigint", obj2.GetType()));
        return b1 / b2;
          }
        }
        throw new Exception(String.Format("unable to divide {0} and {1}", 
                        obj1.GetType().ToString(), obj2.GetType().ToString()));
  }

  // List functions -----------------------------------------------

  public static object member(object obj1, object obj2) {
        if (null_q(obj2)) {
          return false;
        } else if (pair_q(obj2)) {
          object current = obj2;
          while (pair_q(current)) {
                if (Equal(obj1, car(current)))
                  return current;
                current = cdr(current);
          }
          return false;
        }
        throw new Exception("member takes an object and a list");
  }

  public static object array_ref(object array, object pos) {
        return ((object [])array)[(int) pos];
  }

    // Add new low-level procedures here!

    public static object round(object number) {
        return ToInteger(number);
    }

    public static object current_directory() {
        return System.IO.Directory.GetCurrentDirectory();
    }

    public static object current_directory(object path) {
        System.IO.Directory.SetCurrentDirectory(path.ToString());
        return System.IO.Directory.GetCurrentDirectory();
    }

    public static object number_to_string(object number) {
        return ((number != null) ? number.ToString() : "");
    }

    public static object char_to_string(object thing) {
        return ((thing != null) ? thing.ToString() : "");
    }

    public static object char_to_integer(object thing) {
        if (thing is char) {
            return Convert.ToInt32(thing);
        } else {
            throw new Exception(String.Format("char->integer: invalid character: '{0}'", thing));
        }
    }

    public static object integer_to_char(object thing) {
        if (thing is int) {
            return Convert.ToChar(thing);
        } else {
            throw new Exception(String.Format("integer->char: invalid integer: '{0}'", thing));
        }
    }

  public static object list_ref(object obj, object pos) {
        //printf("calling list-ref({0}, {1})\n", obj, pos);
        if (obj is Cons) {
          Cons result = ((Cons)obj);
          for (int i = 0; i < ((int)pos); i++) {
                try {
                  result = (Cons) cdr(result);
                } catch {
                  throw new Exception(string.Format("error in list_ref: improper access (list_ref {0} {1})",
                                  obj, pos));
                }
          }
          return (object)car(result);
        } else
          throw new Exception(string.Format("list_ref: object is not a list: list-ref({0},{1})",
                          obj, pos));
  }

  public static bool null_q(object o1) {
      return Object.ReferenceEquals(o1, PJScheme.symbol_emptylist);
  }

  public static bool pair_q(object x) {
    return (x is Cons);
  }

  public static bool iter_q(object x) {
    return (pair_q(x) || vector_q(x) || string_q(x));
  }

  public static object length(object obj) {
        if (null_q(obj)) {
          return 0;
        } else if (pair_q(obj)) {
          int len = 0;
          object current = (Cons)obj;
          while (pair_q(current)) {
                len++;
                current = cdr(current);
          }
          if (Eq(current, PJScheme.symbol_emptylist)) {
                return len;
          } else {
                throw new Exception(
            String.Format("attempt to take length of an improper list: {0}", obj));
          }
        } else if (string_q(obj)) {
          return obj.ToString().Length;
        } else if (vector_q(obj)) {
          return ((Vector)obj).length();
        } else
          throw new Exception(
          String.Format("attempt to take length of a non-iterator: {0}", obj));
  }
  
  public static object length_safe(object obj) {
        if (null_q(obj)) {
          return 0;
        } else if (pair_q(obj)) {
          int len = 0;
          object current = (Cons)obj;
          while (pair_q(current)) {
                len++;
                current = cdr(current);
          }
          return len;
        }
        return -1;
  }

  public static IEnumerator get_iterator(object obj) {
    if (obj is IEnumerable)
      return ((IEnumerable)obj).GetEnumerator();
    else
      throw new Exception("not an enumerable");
  }

  public static object next_item(object iterator) {
    object retval = PJScheme.symbol_emptylist;
    if (((IEnumerator)iterator).MoveNext()) {
      retval = ((IEnumerator)iterator).Current;
    }
    return retval;
  }

  public static bool iterator_q(object obj) {
    //System.Console.WriteLine("iterator_q: {0} {1}", obj.ToString(), (! list_q(obj)));
    return (! list_q(obj));
  }

  public static bool list_q(object obj) {
                  while (obj is Cons) {
                        obj = cdr(obj);
                  }
                return Eq(obj, PJScheme.symbol_emptylist);
  }

  public static object list_to_string(object lyst) {
      System.Text.StringBuilder retval = new System.Text.StringBuilder();
      if (lyst is Cons) {
          object current = lyst;
          while (!Eq(current, PJScheme.symbol_emptylist)) {
              retval.Append(make_string(car(current)));
              current = cdr(current);
          }
      }
      return retval.ToString();
  }

    public static object pivot (object p, object l) {
        if (null_q(l))
            return PJScheme.symbol_done;
        else if (null_q(cdr(l)))
            return PJScheme.symbol_done;
        bool result = apply_comparison(p, car(l), cadr(l));
        if (result)
            return pivot(p, cdr(l));
        else
            return car(l);
    }

    public static bool apply_comparison(object p, object carl, object cadrl) {
        object result = null;
        if (p is Proc) {
            result = apply(p, list(carl, cadrl));
        } else if (p is Procedure2Bool) {
            Procedure2Bool f = (Procedure2Bool)p;
            try {
                result = f(carl, cadrl);
            } catch (Exception e) {
                throw new Exception("error in sort comparison predicate: " + e.Message);
            }
        } else if (p is Predicate2) {
            Predicate2 f = (Predicate2)p;
            try {
                result = f(carl, cadrl);
            } catch (Exception e) {
                throw new Exception("error in sort comparison predicate: " + e.Message);
            }
        } else if (procedure_q(p)) {
            try {
                result = PJScheme.apply_comparison_rm(p, carl, cadrl);
            } catch (Exception e) {
                throw new Exception("error in sort comparision procedure: " + e.Message);
            }
        } else {
            throw new Exception("error in sort comparision result: " + result);
        }
        if (result is bool) {
            return (bool)result;
        } else {
            throw new Exception("sort comparision function did not return a boolean, but " + result);
        }
    }

  // usage: (partition 4 '(6 4 2 1 7) () ()) -> returns partitions
  public static object partition (object p, object piv,  object l, object p1, object p2) {
      if (null_q(l))
          return list(p1, p2);
      bool result = apply_comparison(p, car(l), piv);
      if (result)
          return partition(p, piv, cdr(l), new Cons(car(l), p1), p2);
      else
          return partition(p, piv, cdr(l), p1, new Cons(car(l), p2));
  }

  public static object sort(object p, object l) {
        object piv = pivot(p, l);
        if (Eq(piv, PJScheme.symbol_done)) return l;
        object parts = partition(p, piv, l, PJScheme.symbol_emptylist, PJScheme.symbol_emptylist);
        return append(sort(p, car(parts)),
                sort(p, cadr(parts)));
  }
  
  public static object reverse(object lyst) {
        if (lyst is Cons) {
          object result = PJScheme.symbol_emptylist;
          object current = ((Cons)lyst);
          while (!Eq(current, PJScheme.symbol_emptylist)) {
                result = new Cons(car(current), result);
                current = cdr(current);
          }
          return result;
        } else {
          return PJScheme.symbol_emptylist;
        }
  }

  public static object array_to_string(object[] args) {
      System.Text.StringBuilder retval = new System.Text.StringBuilder();
      if (args != null) {
          int count = ((Array)args).Length;
          for (int i = 0; i < count; i++) {
              if (args[i] is object[]) {
                  retval.Append(array_to_string((object[])args[i]));
              } else {
                  if (retval.Length != 0)
                      retval.Append(" ");
                  retval.Append(args[i]);
              }
          }
      }
      return retval.Insert(0, "(vector ").Append(")").ToString();
  }

  public static object array_to_list(object[] args) {
        Object result = PJScheme.symbol_emptylist;
        if (args != null) {
            int count = ((Array)args).Length;
            for (int i = 0; i < count; i++) {
                Object item = args[count - i - 1];
                result = new Cons(item, result);
            }
        }
        return result;
  }
  
    public static object list(params object[] args) {
        Object result = PJScheme.symbol_emptylist;
        if (args != null) {
            int count = ((Array)args).Length;
            for (int i = 0; i < count; i++) {
                Object item = args[count - i - 1];
                result = new Cons(item, result);
            }
        }
        return result;
  }

  public static void set_cdr_b(object obj) {
        set_cdr_b(car(obj), cadr(obj));
  }
  
  public static void set_cdr_b(object lyst, object item) {
        Cons cell = (Cons) lyst;
        cell.cdr = item;
  }
  
  public static void set_car_b(object obj) {
        set_car_b(car(obj), cadr(obj));
  }

  public static void set_car_b(object lyst, object item) {
        Cons cell = (Cons) lyst;
        cell.car = item;
  }

    public static object append (params object[] obj)
        {
                // proper-list, proper-list, ..., thing
                // (a) (b)
                object retval = PJScheme.symbol_emptylist;
                object last_cell = null;
                object lyst;
                // put all items from all but last into retval
                for (int i = 0; i < obj.Length - 1; i++) {
                        lyst = obj[i];
                        if (list_q (lyst)) {
                                if (null_q (lyst)) {
                                        // done!
                                } else { // proper list for all but last
                                        object current = lyst;
                                        while (current != PJScheme.symbol_emptylist) {
                                                if (last_cell == null) {
                                                        retval = new Cons(((Cons)current).car, PJScheme.symbol_emptylist);
                                                        last_cell = retval;
                                                } else {
                                                        ((Cons)last_cell).cdr = new Cons(((Cons)current).car, PJScheme.symbol_emptylist);
                                                        last_cell = ((Cons)last_cell).cdr;
                                                }
                                                // advance current
                                                current = cdr(current);
                                        }
                                }
                        } else { // not a list!
                                throw new Exception (string.Format ("error in append: {0} is not a list", lyst));
                        }
                }
                // last element can be anything
                lyst = obj[obj.Length - 1];
                if (null_q (lyst)) {
                        // done!
                } else { // last one is any kind of list or thing
                        object current = lyst;
                        if (pair_q(lyst)) {
                                while (current != null) {
                                        if (last_cell == null) {
                                                retval = new Cons(((Cons)current).car, PJScheme.symbol_emptylist);
                                                last_cell = retval;
                                        } else {
                                                ((Cons)last_cell).cdr = new Cons(((Cons)current).car, PJScheme.symbol_emptylist);
                                                last_cell = ((Cons)last_cell).cdr;
                                        }
                                        // advance current
                                        if (((Cons)current).cdr is Cons) {
                                                current = ((Cons)current).cdr;
                                        } else if (((Cons)current).cdr == PJScheme.symbol_emptylist) {
                                                current = null;
                                        } else { // improper list
                                                ((Cons)last_cell).cdr = ((Cons)current).cdr;
                                                current = null;
                                        }
                                }
                        } else {
                                if (last_cell == null) {
                                        retval = current;
                                        last_cell = retval;
                                } else {
                                        ((Cons)last_cell).cdr = current;
                                }
                        }
                }
                return retval;
        }

  public static string format(object obj) {
        return format(car(obj), list_to_array(obj, 1));
  }
        
  public static object sqrt(object obj) {
        if (pair_q(obj)) {
          obj = car(obj);
          if (obj is int)
              return Math.Sqrt((int)obj);
          else if (obj is float || obj is double)
              return Math.Sqrt((double)obj);
          else if (obj is Rational || obj is BigInteger)
              return Math.Sqrt((double)ToDouble(obj));
          else
              throw new Exception(String.Format("can't take sqrt of this type of number: {0}", obj));
        }
        throw new Exception("need to apply procedure to list");
  }

  public static object abs(object obj) {
        if (pair_q(obj)) {
          obj = car(obj);
          if (obj is int)
              return Math.Abs((int)obj);
          else if (obj is float || obj is double)
              return Math.Abs((double)obj);
          else if (obj is BigInteger)
              return BigInteger.Abs((BigInteger)obj);
          else if (obj is Rational)
              return Math.Abs((double)ToDouble(obj));
          else
              throw new Exception(String.Format("can't take absolute value of this type of number: {0}", obj));
        }
        throw new Exception("abs() needs a list");
  }

  public static object cons(object obj) {
        return cons(car(obj), cadr(obj));
  }

  public static object cons(object obj1, object obj2) {
        return (object) new Cons(obj1, obj2);
  }

  public static object cdr(object obj) {
        if (obj is Cons) 
          return ((Cons)obj).cdr;
        else
          throw new Exception(string.Format("cdr: object is not a pair: {0}",
                          obj));
  }

  public static object car(object obj) {
        if (obj is Cons) 
          return ((Cons)obj).car;
        else
          throw new Exception(string.Format("car: object is not a pair: {0}",
                          obj));
  }

  public static object   caar(object x) {        return car(car(x));   }
  public static object   cadr(object x) {         return car(cdr(x));   }
  public static object   cdar(object x) {        return cdr(car(x));   }
  public static object   cddr(object x) {        return cdr(cdr(x));   }
  public static object  caaar(object x) {        return car(car(car(x)));   }
  public static object  caadr(object x) {         return car(car(cdr(x)));   }
  public static object  cadar(object x) {        return car(cdr(car(x)));   }
  public static object  caddr(object x) {        return car(cdr(cdr(x)));   }
  public static object  cdaar(object x) {        return cdr(car(car(x)));   }
  public static object  cdadr(object x) {         return cdr(car(cdr(x)));   }
  public static object  cddar(object x) {        return cdr(cdr(car(x)));   }
  public static object  cdddr(object x) {        return cdr(cdr(cdr(x)));   }
  public static object caaaar(object x) {        return car(car(car(car(x))));   }
  public static object caaadr(object x) {        return car(car(car(cdr(x))));   }
  public static object caadar(object x) {        return car(car(cdr(car(x))));   }
  public static object caaddr(object x) {        return car(car(cdr(cdr(x))));   }
  public static object cadaar(object x) {        return car(cdr(car(car(x))));   }
  public static object cadadr(object x) {        return car(cdr(car(cdr(x))));   }
  public static object caddar(object x) {        return car(cdr(cdr(car(x))));   }
  public static object cadddr(object x) {        return car(cdr(cdr(cdr(x))));   }
  public static object cdaaar(object x) {        return cdr(car(car(car(x))));   }
  public static object cdaadr(object x) {        return cdr(car(car(cdr(x))));   }
  public static object cdadar(object x) {        return cdr(car(cdr(car(x))));   }
  public static object cdaddr(object x) {        return cdr(car(cdr(cdr(x))));   }
  public static object cddaar(object x) {        return cdr(cdr(car(car(x))));   }
  public static object cddadr(object x) {        return cdr(cdr(car(cdr(x))));   }
  public static object cdddar(object x) {        return cdr(cdr(cdr(car(x))));   }
  public static object cddddr(object x) {        return cdr(cdr(cdr(cdr(x))));   }

  public static void pretty_print(object obj) {
      // FIXME: repr is safe, just not pretty
      System.Console.WriteLine(ToString(obj));
  }  

  public static void safe_print(object arg) {
    config.NEED_NEWLINE = false;
    object sarg = make_safe(arg);
    pretty_print(sarg);
  }

  // FIXME: need to cps/registerize this to avoid reliance on C-sharp's stack
  public static object make_safe(object x) {
    if (x == null)
        return "<void>";
    else if (PJScheme.procedure_object_q(x))
      return (PJScheme.symbol_b_procedure_d);
    else if (PJScheme.environment_object_q(x))
      return (PJScheme.symbol_b_environment_d);
    else if (pair_q(x))
      return (new Cons(make_safe(car(x)), make_safe(cdr(x))));
    else if (vector_q(x))
      // FIXME: too expensive and weird:
      return list_to_vector(make_safe(vector_to_list(x)));
    else
      return (x);
  }

  public static string string_append(object x) {
      System.Text.StringBuilder text = new System.Text.StringBuilder();
      while (! null_q(x)) {
          text.Append(car(x).ToString());
          x = cdr(x);
      }
      return text.ToString();
  }

  public static object string_append(object obj1, object obj2) {
      System.Text.StringBuilder text = new System.Text.StringBuilder(obj1.ToString());
      return text.Append(obj2.ToString()).ToString();
  }

  public static object string_append(object obj1, 
				     object obj2,
				     object obj3) {
      System.Text.StringBuilder text = new System.Text.StringBuilder(obj1.ToString());
      return text.Append(obj2.ToString()).Append(obj3.ToString()).ToString();
  }

  public static object string_append(object obj1, 
				     object obj2,
				     object obj3,
				     object obj4) {
      System.Text.StringBuilder text = new System.Text.StringBuilder(obj1.ToString());
      return text.Append(obj2.ToString()).Append(obj3.ToString()).Append(obj4.ToString()).ToString();
  }

  public static object string_append(object obj1, 
				     object obj2,
				     object obj3,
				     object obj4,
				     object obj5) {
      System.Text.StringBuilder text = new System.Text.StringBuilder(obj1.ToString());
      return text.Append(obj2.ToString()).Append(obj3.ToString()).Append(obj4.ToString()).Append(obj5.ToString()).ToString();
  }

  public static object string_append(object obj1, 
				     object obj2,
				     object obj3,
				     object obj4,
				     object obj5,
				     object obj6) {
      System.Text.StringBuilder text = new System.Text.StringBuilder(obj1.ToString());
      return text.Append(obj2.ToString())
	  .Append(obj3.ToString())
	  .Append(obj4.ToString())
	  .Append(obj5.ToString())
	  .Append(obj6.ToString()).ToString();
  }

  public static object string_append(object obj1, 
				     object obj2,
				     object obj3,
				     object obj4,
				     object obj5,
				     object obj6,
				     object obj7) {
      System.Text.StringBuilder text = new System.Text.StringBuilder(obj1.ToString());
      return text.Append(obj2.ToString())
	  .Append(obj3.ToString())
	  .Append(obj4.ToString())
	  .Append(obj5.ToString())
	  .Append(obj6.ToString())
	  .Append(obj7.ToString()).ToString();
  }

  public static object assq(object x, object ls) {
      object current = ls;
      while (! null_q(current)) {
          if (Eq(x, caar(current))) {
              return car(current);
          }
          current = cdr(current);
      }
      return false;
  }

// assq compares keys with eq?
// assv uses eqv? 
// assoc uses equal?. 

// FIXME: Rewrite without recursion
  public static object assv(object x, object ls) {
      if (null_q(ls)) 
          return false;
      else if (Eqv(x, caar(ls)))
          return car(ls);
      else
          return assv(x, cdr(ls));
  }

// FIXME: Rewrite without recursion
  public static object assoc(object x, object ls) {
      if (null_q(ls)) 
          return false;
      else if (Equal(x, caar(ls)))
          return car(ls);
      else
          return assv(x, cdr(ls));
  }

  public static bool atom_q(object item) {
      return (number_q(item) || symbol_q(item) || string_q(item));
  }

  public static bool isTokenType(List<object> token, string tokenType) {
        return Equal(token[0], tokenType);
  }
  
  public static string arrayToString(object[] array) {
      System.Text.StringBuilder retval = new System.Text.StringBuilder();
      foreach (object item in array) {
          if (retval.Length != 0)
              retval.Append(" ");
          retval.Append(item.ToString());
      }
      return retval.ToString();
  }

  public static object memq(object obj) {
        return memq(car(obj), cadr(obj));
  }

  public static object memq(object item1, object list) {
        if (list is Cons) {
          object current = list;
          while (! Eq(current, PJScheme.symbol_emptylist)) {
                if (Eq(item1, car(current))) {
                    return current;
                }
                current = cdr(current);
          }
          return false;
        }
        return false;
  }

  public static object memv(object obj) {
        return memv(car(obj), cadr(obj));
  }

  public static object memv(object item1, object list) {
        if (list is Cons) {
          object current = list;
          while (! Eq(current, PJScheme.symbol_emptylist)) {
                if (Equal(item1, car(current))) {
                    return current;
                }
                current = cdr(current);
          }
          return false;
        }
        return false;
  }

  public static object read_content(object filename) {
    System.IO.StreamReader fp = File.OpenText(filename.ToString());
        string text = fp.ReadToEnd();
    fp.Close();
    return text;
  }

  //--------------------------------------------------------------------------------------------

  public class Cons : IList {
      public object car;
      public object cdr;
  
      public Cons(object a, object b) {
          this.car = a;
          if (b is object[] || b == null) 
              this.cdr = list(b);
          else
              this.cdr = b;
      }
      
      // Items necessary for it to be an IList
      public bool IsFixedSize {
          get {
              return false;
          }
      }
      
      public bool IsReadOnly {
          get {
              return false;
          }
      }
      
      public bool IsSynchronized {
          get {
              return false;
          }
      }
      
      public void CopyTo(System.Array array, int index) {
      }
      
      public int Add(object value) {
          return 1; // should return count
      }
      
      public int Count {
          get {
              if (cdr(this) == PJScheme.symbol_emptylist)
                  return 1;
              else
                  return 1 + ((Cons)cdr(this)).Count;
          }
      }
      
      public void Remove(object value) {
      }
      
      public void RemoveAt(int index) {
      }
      
      public void Clear() {
      }
      
      public bool Contains(object value) {
          return (bool)member(value, this);
      }
      
      public int IndexOf(object value) {
          return -1;
      }
      
      public void Insert(int index, object value) {
      }
      
      public object this[int index] {
          get {
              object retval = null;
              object mylist = (object)this;
              while (index != -1) {
                  if (mylist is Cons) {
                      retval = ((Cons)mylist).car;
                      mylist = ((Cons)mylist).cdr;
                  }
                  index--;
              }
              return retval;
          }
          set { // value is the item
          }
      }
      public object SyncRoot {
          get {
              return this;
          }
      }
      public IEnumerator GetEnumerator() {
          return new ConsEnum(this);
      }
      
      public string to_s() { 
	  if (car == PJScheme.symbol_procedure) {
	      return "#<procedure>";
	  } else if (car == PJScheme.symbol_environment) {
	      return "#<environment>";
	  } else {
	      return this.ToString();
	  }
      }

      public override string ToString() { 
          string retval = "";
          object current = this;
          while (current is Cons) {
              if (retval != "") {
                  retval += " ";
              }
              retval += repr(((Cons)current).car);
              current = ((Cons)current).cdr;
          } 
          if (current != PJScheme.symbol_emptylist) {
              retval += " . " + repr(current);
          }
          return "(" + retval + ")";
      }
  }
    

  public class ConsEnum : IEnumerator {
      object _list = PJScheme.symbol_emptylist;
      object _orig = PJScheme.symbol_emptylist;

      public ConsEnum(Cons list) {
          _list = list;
          _orig = list;
      }

      public bool MoveNext() {
          _list = ((Cons)_list).cdr;
          return (_list != PJScheme.symbol_emptylist);
      }

      public void Reset() {
          _list = _orig;
      }

      object IEnumerator.Current {
          get {
              return ((Cons)_list).car;
          }
      }
  }

  public class Vector : IList {
  
  private object[] values;
  
  public Vector(object[] args) {
    values = args;
  }

  public object get(int index) {
    return values[index];
  }

  public object length() {
    return values.Length;
  }

  public object ToList() {
    return list(values);
  }

  public void set(int index, object value) {
    values[index] = value;
  }

  public override string ToString() {
      System.Text.StringBuilder retval = new System.Text.StringBuilder();
      for (int i = 0; i < values.Length; i++) {
          retval.Append(values[i].ToString());
          if (i < values.Length-1) {
              retval.Append(" ");
          }
      }
      return String.Format("#{0}({1})", values.Length, retval);
  }

  public String __repr__() {
      return ToString();
  }
  
  // Items necessary for it to be an IList
  public bool IsFixedSize {
        get {
          return true;
        }
  }

  public bool IsReadOnly {
        get {
          return true;
        }
  }

  public bool IsSynchronized {
        get {
          return false;
        }
  }

  public void CopyTo(System.Array array, int index) {
  }

  public int Add(object value) {
        return 0; // should return count
  }

  public int Count {
    get {
      return values.Length;
    }
  }

  public void Remove(object value) {
  }

  public void RemoveAt(int index) {
  }

  public void Clear() {
  }

  public bool Contains(object value) {
      return (bool)member(value, this);
  }

  public int IndexOf(object value) {
      for (int i = 0; i < values.Length; i++) {
          if (Eq(values[i], value)) {
              return i;
          }
      }
      return -1;
  }

  public void Insert(int index, object value) {
  }

  public object this[int index] {
        get {
            return values[index];
        }
        set { // value is the item
            values[index] = value;
        }
  }
  public object SyncRoot {
        get {
          return this;
        }
  }
  public IEnumerator GetEnumerator() {
    // FIXME: return enumerator that returns nothing
    // Refer to the IEnumerator documentation for an example of
    // implementing an enumerator.
    throw new Exception("The method or operation is not implemented.");
  }
}

  public static void Main(string [] args) {
        //printf(append(list(symbol("a")), symbol("b")));
        //printf(append(list(symbol("a"), symbol("b")), list(symbol("c"))));
        //printf(append(list(symbol("a")), list(symbol("b")), list(symbol("c"))));
                        
        //printf ("  (load \"sllgen.ss\"): {0}\n",
        //                PJScheme.execute_string_rm("(load \"/home/dblank/Calico/trunk/examples/scheme/sllgen.ss\")"));
        //PJScheme.execute_string_rm("(define fact2 (lambda fact2 (n) (if (= n 1) 1 (* (fact2 (- n 1)) n))))");
        //printf ("  (fact2 5): {0}\n",
        //                PJScheme.execute_string_rm("(fact2 5)"));

                PJScheme.initialize_method_info ();
                PJScheme.start_rm();

      //PJScheme.execute_string_rm("(define fact (lambda (n) (if (= n 1) 1 (* n (fact (- n 1))))))");
      //printf ("  (fact 1000): {0}\n",
      //                PJScheme.execute_string_rm("(fact 1000)"));
        //printf ("  (1): {0}\n",
                //PJScheme.execute_string_rm("(1)"));
        // ----------------------------------
        // Math:
//        if (false) {
//                printf ("  (using \"Graphics\"): {0}\n",
//                        PJScheme.execute("(using \"Graphics\")"));
//                } else {
//        printf ("  Add(1,1), Result: {0}, Should be: {1}\n", 
//                Add(1, 1), 1 + 1);
//        printf ("  Multiply(10,2), Result: {0}, Should be: {1}\n", 
//                Multiply(10, 2), 10 * 2);
//        printf ("  Divide(5,2), Result: {0}, Should be: {1}\n", 
//                Divide(5, 2), 5/2.0);
//        printf ("  Subtract(22,7), Result: {0}, Should be: {1}\n", 
//                Subtract(22, 7), 22 - 7);
//        // -----------------------------------
//        // Equal tests:
//        printf("hello == hello: {0}\n", Equal("hello", "hello"));
//        printf("hello == hel: {0}\n", Equal("hello", "hel"));
//        printf("hello == helloo: {0}\n", Equal("hello", "helloo"));
//        printf("4.1 == 4: {0}\n", Equal(4.1, 4));
//        printf("hello == true: {0}\n", Equal("hello", true));
//        
//        printf("() == (): {0}\n", Equal(list(), list()));
//
//        object t = list(2);
//        printf("t = list(2): {0}\n", t);
//        printf("list? t: {0}\n", list_q(t));
//        printf("null? t: {0}\n", null_q(t));
//
//        //cons("a", symbol_emptylist).ToString();
//        printf("cons('a', ()): {0}\n", cons("a", symbol_emptylist));
//        
//        t = cons("b", cons("a", t));
//        t = cons("c", cons("a", t));
//        t = cons("d", cons("a", t));
//        printf("t = : {0}\n", t);
//
//        printf("null? cdr(t): {0} {1}\n", 
//                null_q(cdr(t)), 
//                cdr(t));
//        printf("null? cddr(t): {0}\n", null_q(cddr(t)));
//
//        //        printf("null? cdddr(t): {0}\n", null_q(cdddr(t)));
//         printf("Member test: \n");
//        t = cons("hello", t);
//        printf("t = {0}\n", repr(t));
//        printf("member(hello, t) : {0}\n", repr(member("hello", t)));
//        printf("member(a, t) : {0}\n", repr(member("a", t)));
//        printf("member(c, t) : {0}\n", repr(member("c", t)));
//        printf("(): {0}\n", repr(list()));
//        printf("list(t): {0}\n", repr(list(t)));
//        printf("length(list(t)): {0}\n", length(list(t)));
//        printf("length(cdr(list(t))): {0}\n", length(cdr(list(t))));
//        printf("length(car(list(t))): {0}\n", length(car(list(t))));
//        printf("cons(\"X\", list(t))): {0}\n", repr(cons("X", list(t))));
//        printf("x is: {0}\n", repr("x"));
//        printf("t is: {0}\n", repr(t));
//        printf("list(): {0}\n", list());
//        printf("cons('a', list()): {0}\n", cons("a", list()));
//        printf("cons('a', 'b'): {0}\n", cons("a", "b"));
//
//        printf("cons('a', null): {0}\n", cons("a", null));
//
//        printf("string-append('test', NULL): \"{0}\"\n",          
//                string_append ((object) "test",
//                        (object) make_string ((object) NULL)));
//
//        int val = 15;
//        printf("BigInteger, long, int:\n");
//        printf("  {0}: {1} == {2} == WRONG! {3}\n", val,
//                bigfact(makeBigInteger(val)), longfact(val), intfact(val));
//        printf("Multiply:\n");
//        printf("15: {0} \n", Multiply(Multiply( Multiply( intfact(12), 13), 14), 15));
//
//        printf("1827391823712983712983712938: {0}\n", BigIntegerParse("1827391823712983712983712938"));
//
//    printf("display(list_to_vector( list(1, 2, 3))): ");
//    display(list_to_vector( list(1, 2, 3)));
//    printf("\n");
//                }
  }

  public static long longfact(long n) {
        if (n == 1) return n;
        return n * longfact(n - 1);
  }

  public static int intfact(int n) {
        if (n == 1) return n;
        return n * intfact(n - 1);
  }

  public static BigInteger bigfact(BigInteger n) {
        if (n == 1) return n;
        return n * bigfact(n - 1);
  }

  public static void set_dlr(ScriptScope scope, ScriptRuntime runtime) {
    _dlr_env = scope;
    _dlr_runtime = runtime;
  }

  public static void SetVariable(string variable, object value) {
      if (variable.Contains(".")) {
          string [] parts = variable.Split('.');
          object obj = _dlr_env.GetVariable(parts[0]);
          for (int i = 1; i < parts.Length - 1; i++) {
              obj = _dlr_env.Engine.Operations.GetMember(obj, parts[i]);
          }
          if (obj != null) {
              _dlr_env.Engine.Operations.SetMember(obj, parts[parts.Length - 1], value);
          } else {
              throw new Exception(String.Format("no such item: '{0}'", variable));
          }
      } else {
          _dlr_env.SetVariable(variable, value);
      }
  }
    
  public static void set_global_value_b(object var, object value) {
        if (_dlr_env != null) {
            SetVariable(var.ToString(), value);
        } else {
          throw new Exception(String.Format("DLR Environment not available"));
        }
  }

  public static double currentTime () {
      System.TimeSpan t = System.DateTime.UtcNow - new System.DateTime (1970, 1, 1);
      return t.TotalSeconds;
  }

    public delegate void InvokeDelegate ();
    
    public static void Invoke (InvokeDelegate invoke)
    {
        if (needInvoke ()) {
            Gtk.Application.Invoke (delegate {
                    invoke ();});
        } else {
            invoke ();
        }
    }
    
    public static bool needInvoke ()
    {
        return (Thread.CurrentThread.ManagedThreadId != 1);
    }
    
    static void invoke_function (Func<object,object> function, object args)
    {
        try {
            Gtk.Application.Invoke (delegate {
                    function (args);
                });
        } catch (Exception e) {
            Console.Error.WriteLine ("Error in function");
            Console.Error.WriteLine (e.Message);
        }        
    }
    
    
    public static void wait (double seconds) {
      if (seconds < .1)
          System.Threading.Thread.Sleep ((int)(seconds * 1000));
      else {
          double start = currentTime ();
          ManualResetEvent ev = new ManualResetEvent (false);
          while (seconds > currentTime () - start) {
              Invoke( delegate {
                      while (Gtk.Application.EventsPending ())
                          Gtk.Application.RunIteration ();
                      ev.Set();
                  });
              ev.WaitOne();
              ev.Reset();
          }
      }
  }

  public static void highlight_expression(object exp) {
      // This should be made fast, as it happens on each step!
      Calico.MainWindow calico;
      object info = PJScheme.rac(exp);
      if (Equal(info, PJScheme.symbol_none)) {
          return;
      }
      int start_line = (int)PJScheme.get_start_line(info);
           if (_dlr_env != null) {
          calico = (Calico.MainWindow)_dlr_env.GetVariable("calico");
          if (calico != null) {
              if (calico.CurrentDocument == null) {
                  return;
              } else if (calico.CurrentDocument.HasBreakpointSetAtLine(start_line)) {
                  // don't return! Fall through and print
              } else if (calico.ProgramSpeedValue == 100) {
                  return;
              }
          } else {
              return;
          }
      } else {
          return;
      }
      string filename = PJScheme.get_srcfile(info).ToString();
      Calico.TextDocument document = (Calico.TextDocument)calico.GetDocument(filename);
      int start_col = (int)PJScheme.get_start_char(info);
      int end_line = (int)PJScheme.get_end_line(info);
      int end_col = (int)PJScheme.get_end_char(info);
      calico.playResetEvent.Reset (); 
      Calico.MainWindow.Invoke ( delegate {
              document.GotoLine(start_line);
              document.texteditor.SetSelection(start_line, start_col, end_line, end_col + 1);
          });
      if (! Equal(car(exp), PJScheme.symbol_lit_aexp)) {
          printf("~acall: ", 
                 string_append(PJScheme.repeat(" |", 
                                               (object)PJScheme.get_closure_depth())));
          printf("~a~%", PJScheme.aunparse(exp));
          PJScheme.increment_closure_depth();
      }
  }

  public static void handle_debug_info(object exp, object result) {
      // This should be made fast, as it happens on each step!
      Calico.MainWindow calico;
      object info = PJScheme.rac(exp);
      if (Equal(info, PJScheme.symbol_none)) {
          return;
      }
      int start_line = (int)PJScheme.get_start_line(info);
      if (_dlr_env != null) {
          calico = (Calico.MainWindow)_dlr_env.GetVariable("calico");
          if (calico != null) {
              if (calico.CurrentDocument == null) {
                  return;
              } else if (calico.CurrentDocument.HasBreakpointSetAtLine(start_line)) {
                  // don't return! Fall through and wait
              } else if (calico.ProgramSpeedValue == 100) {
                  return;
              }
          } else {
              return;
          }
      } else {
          return;
      }
      // We have a calico defined and we should trace and/or stop
      string filename = PJScheme.get_srcfile(info).ToString();
      Calico.TextDocument document = (Calico.TextDocument)calico.GetDocument(filename);
      // (lit-aexp (a b c) (stdin 1 1 1 1 8 8))
      // <sourcefile>    1  1
      // <startline>     1  8
      // <startchar>     1  8
      // <startposition> 1  1 
      // <endline>       1  8
      // <endchar>       8  8
      // <endposition>   8  1
      //                   17
      //                   17

      int start_col = (int)PJScheme.get_start_char(info);
      int end_line = (int)PJScheme.get_end_line(info);
      int end_col = (int)PJScheme.get_end_char(info);
      calico.playResetEvent.Reset (); 
      Calico.MainWindow.Invoke ( delegate {
              calico.PlayButton.Sensitive = true;
              calico.PauseButton.Sensitive = false;
              document.GotoLine(start_line);
              document.texteditor.SetSelection(start_line, start_col, end_line, end_col + 1);
          });
      if (! Equal(car(exp), PJScheme.symbol_lit_aexp)) {
          PJScheme.decrement_closure_depth();
          try {
              printf("~areturn: ", 
                     string_append(PJScheme.repeat(" |", 
                                                   (object)PJScheme.get_closure_depth())));
              printf("~a~%", repr(result));
          } catch {
              printf("~areturn: ERROR in PRINTING RESULT!~%", 
                     string_append(PJScheme.repeat(" |", 
                                                   (object)PJScheme.get_closure_depth())));
          }
      }
      double psv = calico.ProgramSpeedValue;
      if (psv == 0 || 
          calico.CurrentDocument.HasBreakpointSetAtLine(start_line) ||
          PJScheme.get_trace_pause()) {
          printf("~atrace: Paused!~%", 
                 string_append(PJScheme.repeat(" |", 
                                               (object)PJScheme.get_closure_depth())));
          calico.playResetEvent.WaitOne();
      } else if (psv < 100) { // then we are in a delay:
          double pause = (2.0 / psv);
          // Force at least a slight sleep, else no GUI controls
          wait(pause);
      }
  }

  public static object search_frame(object frame, object variable) {
      if (frame is Cons) {
          Vector bindings = (Vector) car(frame);
          object variables = cadr(frame);
          int i = 0;
          while (!null_q(variables)) {
              if (Eq(car(variables), variable)) {
                  return bindings.get(i);
              }
              variables = cdr(variables);
              i++;
          }
          return false;
      } else {
          throw new Exception("invalid frame");
      }
  }

    public static void set_use_stack_trace(bool value) {
        PJScheme._staruse_stack_trace_star = value;
    }

    public static string read_multiline(object prompt) {
        Console.Write(prompt.ToString());
        string retval = Console.ReadLine();
        if (retval == null)
            retval = "(exit)";
        return retval;
    }    

    public static void ApplyPlus(object what, object slist) {
        // what is "cont", "cont2", "macro"
        // first arg is id
        // rest of args are arguments
        string kind = (string) what;
        int id = (int)car(slist);
        object[] args = (object [])cadr(slist);
        //Console.WriteLine("apply_native: <{0}-{1}>", kind, id);
        //Console.WriteLine("args: " + repr(args));
        //object [] args = list_to_array(lyst);
        if (kind == "cont") {
            //Console.WriteLine("Executing cont[{0}]...", id);
            PJScheme.mi_cont[id].Invoke(PJScheme.mi_cont[id], args);
            //Console.WriteLine("done!");
        } else if (kind == "cont2") {
            PJScheme.mi_cont2[id].Invoke(PJScheme.mi_cont2[id], args);
        } else if (kind == "cont3") {
            PJScheme.mi_cont3[id].Invoke(PJScheme.mi_cont3[id], args);
        } else if (kind == "cont4") {
            PJScheme.mi_cont4[id].Invoke(PJScheme.mi_cont4[id], args);
        } else if (kind == "macro") {
            PJScheme.mi_macro[id].Invoke(PJScheme.mi_macro[id], args);
        } else if (kind == "fail") {
            PJScheme.mi_fail[id].Invoke(PJScheme.mi_fail[id], args);
        } else if (kind == "handler") {
            PJScheme.mi_handler[id].Invoke(PJScheme.mi_handler[id], args);
        } else if (kind == "handler2") {
            PJScheme.mi_handler2[id].Invoke(PJScheme.mi_handler2[id], args);
        } else if (kind == "proc") {
            PJScheme.mi_proc[id].Invoke(PJScheme.mi_proc[id], args);
        } else {
            throw new Exception("invalid kind: " + kind);
        }
    }

    public static object set_external_member_b(object obj, object components, object value) {
        // FIXME: 
        return null;
    }

    public static void set_global_docstring_b(object var, object value) {
        // FIXME: how to set docstring?
    }

    public static object float_(object obj) {
        return ToDouble(obj);
    }

    public static object int_(object obj) {
        return Convert.ToInt32(ToDouble(obj));
    }

    public static object globals() {
        return dlr_env_list();
    }

    public static object dict(object obj) {
        object current = obj;
        Dictionary<object,object> dictionary = new Dictionary<object,object>();
        while (current != PJScheme.symbol_emptylist) {
            object pair = car(current);
            dictionary[car(pair)] = cadr(pair);
            current = cdr(current);
        }
        return dictionary;
    }

    public static object type(object obj) {
        return obj.GetType();
    }

    public static object help(object obj) {
	return "No available help for host-system item.";
    }
    
    public static object contains_native(object obj, object item) {
	return ((IDictionary)obj).Contains(item);
    }

    public static object getitem_native(object obj, object item) {
	return ((IDictionary)obj)[item];
    }

    public static object setitem_native(object obj, object item, object value) {
	((IDictionary)obj)[item] = value;
	return value;
    }
}
