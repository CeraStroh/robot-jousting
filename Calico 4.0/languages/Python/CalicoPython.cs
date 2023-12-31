//
//  CalicoPython.cs
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

namespace CalicoPython
{
	public class CalicoPythonEngine : DLREngine
	{
	
	        static string trace_filename = null;
	        static bool trace_pause = false;

		public CalicoPythonEngine (LanguageManager manager) : base(manager)
		{
			dlr_name = "py";
			scriptRuntimeSetup = new Microsoft.Scripting.Hosting.ScriptRuntimeSetup ();
			languageSetup = IronPython.Hosting.Python.CreateLanguageSetup (null);
			// Set LanguageSetup options here:
			languageSetup.Options ["FullFrames"] = true; // for debugging
			languageSetup.Options ["MaxRecursion"] = 1000; // for debugging
			scriptRuntimeSetup.LanguageSetups.Add (languageSetup); // add to local
			// Create a Python-only scope:
			scriptRuntime = new Microsoft.Scripting.Hosting.ScriptRuntime (scriptRuntimeSetup);
			scope = scriptRuntime.CreateScope ();
		}
	
		public override void Start (string path)
		{
			// Get engine from manager:
			if (manager != null) {
				engine = manager.scriptRuntime.GetEngine (dlr_name);  
			} else {
				engine = scriptRuntime.GetEngine (dlr_name);  
			}
			scope = IronPython.Hosting.Python.CreateModule(engine, "__main__");

			// FIXME: before a executefile, __name__ is "__builtin__";
			//        after it is "<module>"
			// FIXME: this doesn't work:
			//options.ModuleName = "__main__";
			//options.Module |= IronPython.Runtime.ModuleOptions.Initialize;
			// Set paths:
			ICollection<string > paths = engine.GetSearchPaths ();
			// Let users find Calico modules:
			foreach (string folder in new string[] { "modules", "src", "languages/Python/modules" }) {
				paths.Add (Path.GetFullPath(String.Format("{0}/{1}/{2}", path, "..", folder)));
			}
			engine.SetSearchPaths (paths);
		}
		
		public override Microsoft.Scripting.Hosting.CompiledCode SetDLRSpecificCompilerOptions(
					  Microsoft.Scripting.Hosting.ScriptSource source, 
					  Microsoft.Scripting.CompilerOptions compiler_options) {
		    IronPython.Compiler.PythonCompilerOptions options = (IronPython.Compiler.PythonCompilerOptions)compiler_options;
		    if (calico != null && (bool)calico.config.GetValue("python-language", "python2-mode")) {
			options.PrintFunction = false;
			options.AllowWithStatement = false;
			options.TrueDivision = false;
		    } else {
			options.PrintFunction = true;
			options.AllowWithStatement = true;
			options.TrueDivision = true;
		    }
		    return source.Compile(options);
		}

		public override void RequestPause () {
		  trace_pause = true;
		}

		public IronPython.Runtime.Exceptions.TracebackDelegate OnTraceBack (
				  IronPython.Runtime.Exceptions.TraceBackFrame frame, 
				  string ttype, object retval)
		{
		  // If in another file, don't stop:
		  if (ttype == "call") { 
		      if (frame.f_code.co_filename != trace_filename)
		      return null;
		  }
		  // If in correct file, and speed is less than full speed, show line:
		  Calico.MainWindow.Invoke (delegate {
		      if (calico.CurrentDocument != null 
			  && calico.CurrentDocument.filename == frame.f_code.co_filename
			  && (calico.ProgramSpeedValue != 100
			      || calico.CurrentDocument.HasBreakpointSetAtLine ((int)frame.f_lineno))) {
			  calico.CurrentDocument.GotoLine ((int)frame.f_lineno);
			  calico.CurrentDocument.SelectLine((int)frame.f_lineno);
		      }
		      //calico.Print(calico.Repr(((IDictionary<object,object>)frame.f_locals).Keys));
		      calico.UpdateLocal((IDictionary<object,object>)frame.f_locals);
		    });
		  // If a stopping criteria:
		  if ((calico.CurrentDocument != null 
		       && calico.CurrentDocument.filename == frame.f_code.co_filename
		       && calico.CurrentDocument.HasBreakpointSetAtLine ((int)frame.f_lineno)) 
		      || calico.ProgramSpeedValue == 0 
		      || trace_pause) {
		    Calico.MainWindow.Invoke (delegate {
			calico.PlayButton.Sensitive = true;
			calico.PauseButton.Sensitive = false;
			if (ttype == "return")
			  calico.Print(String.Format("Trace: Will return {0}\n", retval));
			else 
			  calico.Print(String.Format("Trace: Paused!\n"));
		      });
		    calico.playResetEvent.WaitOne ();
		    calico.playResetEvent.Reset ();
		    trace_pause = false;
		  } else { // then we are in a delay:
		      // Use the same delay as Jigsaw
		      // We know that it is 0 < value <= 100
		      int pause = (int)(2000.0 / calico.ProgramSpeedValue);
		      // Force at least a slight sleep, else no GUI controls
		      System.Threading.Thread.Sleep (Math.Max (pause, 1));
		  }
		  // return the call back for this frame trace
		  return OnTraceBack;
		}
		
		public override object GetDefaultContext ()
		{
			return IronPython.Runtime.DefaultContext.Default;
		}
		
		public override void ConfigureTrace ()
		{
		    try {
			  if (trace) {
			    trace_filename = calico.CurrentDocument.filename;
			    trace_pause = false;
			    IronPython.Hosting.Python.SetTrace (engine, OnTraceBack);
			  }
		    } catch { 
		       Console.Error.WriteLine("Error in setting trace.");
		    }
		}
		
		public override void PostSetup(MainWindow calico) {
		    base.PostSetup(calico);
		    // Set the compiler options here:
		    compiler_options = engine.GetCompilerOptions ();
		    IronPython.Compiler.PythonCompilerOptions options = (IronPython.Compiler.PythonCompilerOptions)compiler_options;
		    options.ModuleName = "__main__";
		    options.Module |= IronPython.Runtime.ModuleOptions.Initialize;
		    // Set up input and recursion limit
		    if (Calico.MainWindow.gui_thread_id != -1) {
			Execute(
				"from Myro import ask as _ask;" +
				"from sys import setrecursionlimit as _srl;" +
				"__builtins__['input'] = lambda p='': calico.input(p) if calico.GetSession() else _ask(p);" +
				"__builtins__['raw_input'] = lambda p='': calico.input(p) if calico.GetSession() else _ask(p);" +
				"__builtins__['calico'] = calico;" +
				"_srl(1024);" + 
				"del _srl;", false);
		    } else {
			Execute(
				"from sys import setrecursionlimit as _srl;" +
				"__builtins__['input'] = raw_input;" +
				"__builtins__['calico'] = calico;" +
				"_srl(1024);" + 
				"del _srl;", false);
		    }
		}
	}

	public class CalicoPythonDocument : TextDocument
	{

		public CalicoPythonDocument (MainWindow calico, string filename, string language, string mimetype) :
            	   base(calico, filename, language, mimetype)
		{
		}
		
		public override string [] GetAuthors() 
		{
    	    return new string[] {
				"Microsoft Corporation",
				"The IronPython Team"
			};
    	}
	}
	
	public class CalicoPythonLanguage : Language
	{
		public CalicoPythonLanguage () : 
			base("python",  "Python", new string[] { "py", "pyw" }, "text/x-python")
		{
		  LineComment = "##";
		}
		
		public override void MakeEngine (LanguageManager manager)
		{
			engine = new CalicoPythonEngine (manager);
		}

		public override Document MakeDocument (MainWindow calico, string filename)
		{
			return new CalicoPythonDocument (calico, filename, name, mimetype);
		}

		public static new Language MakeLanguage ()
		{
			return new CalicoPythonLanguage ();
		}

		public override void InitializeConfig() {
		    base.InitializeConfig();
		    local_config.SetValue("python-language", "python2-mode", "bool", false);
		}

		public override void SetAdditionalOptionsMenu(Gtk.Menu submenu) {
		    // Put language specific stuff in overloaded version
		    bool python2_mode = (bool)config.GetValue("python-language", "python2-mode");
		    Gtk.CheckMenuItem python2_mode_menu_item = new Gtk.CheckMenuItem(_("Python2 Mode"));
		    python2_mode_menu_item.Active = python2_mode;
		    python2_mode_menu_item.Activated += OnChangePython2Mode;
		    submenu.Add(python2_mode_menu_item);
		}

		public void OnChangePython2Mode (object sender, EventArgs e)
		{
		    config.SetValue("python-language", "python2-mode", ((Gtk.CheckMenuItem)sender).Active);
		}
     
		public override string GetUseLibraryString(string fullname) {
			string bname = System.IO.Path.GetFileNameWithoutExtension (fullname);
			return String.Format ("import {0}\n", bname);
		}		
	}
}
