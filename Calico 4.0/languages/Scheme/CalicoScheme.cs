//
//  CalicoScheme.cs
//  
//  Author:
//       Douglas S. Blank <dblank@cs.brynmawr.edu>
// 
//  Copyright (c) 2011 The Calico Project
// 
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

using System;
using System.Collections.Generic;
using System.IO;
using Calico;
using System.Text.RegularExpressions;
using Mono.Terminal;

public class CalicoSchemeEngine : Engine
{
  public CalicoSchemeEngine (LanguageManager manager) : base(manager)
  {
  }

  public override void PostSetup(MainWindow calico) {
    base.PostSetup(calico);
    this.calico = calico;
    PJScheme.initialize_method_info ();
    Scheme.set_dlr(manager.scope, manager.scriptRuntime);
    Scheme.reset_toplevel_env();
    initialize_execute();
  }

  public void initialize_execute() {
      bool use_stack_trace;
      try {
	  use_stack_trace = (bool)calico.config.GetValue("scheme-language", "use-stack-trace");
      } catch {
	  use_stack_trace = true;
      }
      PJScheme.set_use_stack_trace(use_stack_trace);
  }

  public override bool Execute(string text, bool ok) {
    initialize_execute();
    object result = PJScheme.execute_string_rm(text);
    if (CheckGood(result))
	return HandleOutput(result, ok);
    else
	return false;
  }

  public bool CheckGood(object result) {
      string resultString = Scheme.repr(result);
      if (resultString.StartsWith("(exception ")) {
	  System.Console.Error.WriteLine("Traceback (most recent call last):");
	  if (Scheme.list_q(result) && ((int)Scheme.length(result)) == 2) {
	      object list = Scheme.cadr(result);
	      if (Scheme.list_q(list) && ((int)Scheme.length(list)) == 6) {
		  object error = ((Scheme.Cons)list)[0];
		  object message = ((Scheme.Cons)list)[1];
		  object src_file = ((Scheme.Cons)list)[2];
		  object src_line = ((Scheme.Cons)list)[3];
		  object src_col = ((Scheme.Cons)list)[4];
		  object stack = ((Scheme.Cons)list)[5];
		  format_trace_back(stack);
		  if (src_file.ToString() != "none") {
		      System.Console.Error.WriteLine(String.Format("  File \"{0}\", line {1}, col {2}", 
								   src_file, src_line, src_col));
		  }
		  System.Console.Error.WriteLine(String.Format("{0}: {1}", error, message));
	      } else {
		  System.Console.Error.WriteLine(list);
	      }
	  } else {
	      System.Console.Error.WriteLine(resultString);
	  }
	  return false;
      }
      return true;
  }

  public override void RequestPause () {
      PJScheme.set_trace_pause(true);
  }

  public void format_trace_back(object list) {
      object current = list;
      while (current != PJScheme.symbol_emptylist) {
          object info = Scheme.car(current);
	  if (info.ToString() == "macro-generated-exp") {
              // nothing to print
          } else {
              object message = Scheme.car(info);
              object line = Scheme.cadr(info);
              object column = Scheme.caddr(info);
              object proc_name = Scheme.cadddr(info);
              System.Console.Error.WriteLine(String.Format("  File \"{0}\", line {1}, col {2}, in {3}", 
                                                           message, line, column, proc_name));
          }
	  current = Scheme.cdr(current);
      }
  }

  public bool HandleOutput(object result, bool ok) {
    string resultString = Scheme.repr(result);
    if (result != null) {
	System.Console.WriteLine(resultString);
    }
    if (ok) {
	try {
	    calico.manager.stderr.PrintLine(Calico.Tag.Info, "Done");
	} catch {
	    System.Console.WriteLine("Done");
	}
    }
    return true;
  }

  public override bool Execute(string text) {
    initialize_execute();
    object result = PJScheme.execute_string_rm(text);
    if (CheckGood(result))
	return HandleOutput(result, true);
    return false;
  }

  public override object Evaluate(string text) {
    initialize_execute();
    object result = PJScheme.execute_string_rm(text);
    if (CheckGood(result))
	return result;
    else
	return null;
  }

  public override bool ExecuteFile(string filename) {
    initialize_execute();
    object obj = PJScheme.execute_file_rm(filename);
    if (CheckGood(obj))
	return HandleOutput(obj, true);
    return false;
  }

  public override bool ReadyToExecute(string text) {
    //Return True if expression parses ok.
    string [] lines = text.Split('\n');
    if (lines[lines.Length - 1].Trim() == "") {
      return true; // force it
    }
    // else, only if valid parse
    return (bool) PJScheme.try_parse(text);
  }

  public override void SetTraceOn(MainWindow calico) {
      PJScheme.tracing_on(PJScheme.list(true));
  }

  public override void SetTraceOff() {
      PJScheme.tracing_on(PJScheme.list(false));
  }

  public static void Main(string[] args) {
      LanguageManager manager = new LanguageManager(new List<string>(){"scheme"}, 
						    "..", 
						    new Dictionary<string, Language>());
	CalicoSchemeLanguage scheme = new CalicoSchemeLanguage();
	scheme.MakeEngine(manager);
	bool interactive = false;

	if (args.Length > 0) {
	  foreach (string file in args) {
		if (file.StartsWith("-")) {
		  if (file == "-i") {
			interactive = true;
		  }
		} else {
		  scheme.engine.ExecuteFile(file);
		}
	  } 
	} else {
	  interactive = true;
	}
	
	if (interactive) {
	  LineEditor le = new LineEditor ("Calico Scheme", 1000);
	  le.TabAtStartCompletes = false;
	  string line, expr = "";
	  string prompt = "scheme>>> ";
	  string indent = "";
	  while ((line = le.Edit(prompt, indent)) != null) {
	      if (expr != "")
		  expr = expr + "\n" + line;
	      else
		  expr = line;
	      if (scheme.engine.ReadyToExecute(expr)) {
		  scheme.engine.Execute(expr, true);
		  expr = "";
		  prompt = "scheme>>> ";
		  indent = "";
	    } else {
		  prompt = "......>>> ";
		  Match match = Regex.Match(line, "^\t*");
		  if (match.Success)
		    indent = match.Value;
	    }
	  }
	}
  }
}

public class CalicoSchemeDocument : TextDocument {

	public override string [] GetAuthors() 
	{
        return new string[] {
			"Jim Marshall <jmarshall@sarahlawrence.edu>",
			"Doug Blank <dblank@cs.brynmawr.edu>"
		};
    }

	public CalicoSchemeDocument(MainWindow calico, string filename, string language, string mimetype) :
            	   base(calico, filename, language, mimetype) {
    }

}
	
public class CalicoSchemeLanguage : Language
{
	public CalicoSchemeLanguage () : 
	    base("scheme",  "Scheme", new string[] { "ss", "scm", "s" }, "text/x-scheme")
	{
	    LineComment = ";;";
	}
    
	public override void MakeEngine (LanguageManager manager)
	{
		engine = new CalicoSchemeEngine (manager);
	}

        public override Document MakeDocument(MainWindow calico, string filename) {
	        return new CalicoSchemeDocument(calico, filename, name, mimetype);
        }

	public static new Language MakeLanguage ()
	{
		return new CalicoSchemeLanguage ();
	}

        public override string GetUseLibraryString(string fullname) {
		string bname = System.IO.Path.GetFileNameWithoutExtension(fullname);
                return String.Format("(using \"{0}\")\n", bname);
        }

	public override void InitializeConfig() {
	    base.InitializeConfig();
	    if (local_config != null && !local_config.HasValue("scheme-language", "use-stack-trace")) {
		// add it! 
		local_config.SetValue("scheme-language", "use-stack-trace", "bool", (bool)PJScheme.get_use_stack_trace());
	    }
	}

	public override void SetAdditionalOptionsMenu(Gtk.Menu submenu) {
	    // Put language specific stuff in overloaded version
	    bool use_stack_trace = (bool)config.GetValue("scheme-language", "use-stack-trace");
	    Gtk.CheckMenuItem menu_item = new Gtk.CheckMenuItem("Use Stack Trace");
	    menu_item.Active = use_stack_trace;
	    menu_item.Activated += delegate(object sender, EventArgs e) {
		bool value = ((Gtk.CheckMenuItem)sender).Active;
		config.SetValue("scheme-language", "use-stack-trace", value);
		PJScheme.set_use_stack_trace(value);
	    };
	    ((Gtk.Menu)submenu).Add(menu_item);
	}
}
