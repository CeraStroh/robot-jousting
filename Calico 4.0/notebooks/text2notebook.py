#-----------------------------------------------------------------------------
#  Copyright (C) 2014, Doug Blank <doug.blank@gmail.com>
#
#  Distributed under the terms of the BSD License.  The full license is in
#  the file COPYING, distributed as part of this software.
#-----------------------------------------------------------------------------

# based on code in IPython

import os
import json
import uuid
import hmac
import hashlib

def read_secret_key():
    filename = os.path.expanduser("~/.ipython/profile_calico/security/notebook_secret")
    with open(filename, 'rb') as f:
        return f.read()

encoder = json.encoder.JSONEncoder(sort_keys=True, indent=1)
unicode_type = unicode
key = read_secret_key()
SECRET = unicode(key).encode("ascii")

def parse_markdown(text):
    if text.startswith("# "):
        text = text.replace("# ", "1. ")
    elif text.startswith("="):
        text = text.replace("=", "#")
    text = text.replace("'''", "**")
    return text

def parse_pre(text):
    if ">>>" in text:
        text = text.split(">>>")[1].strip()
    return text

def parse(text):
    ## returns a list of [clist, ctype, clang]. 
    ## Every clist is a list of lines
    retval = []
    current_cell = []
    state = None
    for line in text:
        sline = line.strip()
        if state is None:
            if sline.startswith("<pre>"):
                if current_cell:
                    retval.append((current_cell, "markdown", "python"))
                    current_cell = []
                state = "pre"
            elif line.startswith(" "):
                if current_cell:
                    retval.append((current_cell, "markdown", "python"))
                    current_cell = []
                current_cell.append(parse_pre(line))
                state = ">>>"
            else:
                current_cell.append(parse_markdown(line))
        elif state == "pre":
            if sline.startswith("</pre>"):
                retval.append((current_cell, "code", "python"))
                current_cell = []
                state = None
            else:
                current_cell.append(line)
        elif state == ">>>":
            if not line.startswith(" "):
                retval.append((current_cell, "code", "python"))
                current_cell = []
                state = None
            else:
                current_cell.append(parse_pre(line))
    if current_cell:
        if state is None:
            retval.append((current_cell, "markdown", "python"))
        else:
            retval.append((current_cell, "code", "python"))
    return retval

def convert(py_file):
    py_full_path = os.path.abspath(py_file)
    base_path, base_name = os.path.split(py_full_path)
    base, ext = os.path.splitext(base_name)
    nb_full_path = os.path.join(base_path, base + ".ipynb")
    text = parse(open(py_full_path).readlines())
    notebook = make_notebook()
    for ctext,ctype,clang in text:
        add_cell(notebook, make_cell(ctext, ctype, clang))
    ## ---------------------
    sign(notebook)
    save(notebook, nb_full_path)

def sign(notebook):
    notebook["metadata"]["signature"] = sign_notebook(notebook)

def save(notebook, filename):
    fp = open(filename, "w")
    fp.write(encoder.encode(notebook))
    fp.close()

def cast_bytes(s, encoding=None):
    if not isinstance(s, bytes):
        return encode(s, encoding)
    return s

def yield_everything(obj):
    if isinstance(obj, dict):
        for key in sorted(obj):
            value = obj[key]
            yield cast_bytes(key)
            for b in yield_everything(value):
                yield b
    elif isinstance(obj, (list, tuple)):
        for element in obj:
            for b in yield_everything(element):
                yield b
    elif isinstance(obj, unicode_type):
        yield obj.encode('utf8')
    else:
        yield unicode_type(obj).encode('utf8')

def sign_notebook(notebook, digestmod=hashlib.sha256):
    h = hmac.HMAC(SECRET, digestmod=digestmod)
    for b in yield_everything(notebook):
        h.update(b)
    return "sha256:" + h.hexdigest()

def make_notebook(code_list=None):
    notebook = {}
    notebook["metadata"] = {
        "name": "",
        "signature": "", ## to be signed later
    }
    notebook["nbformat"] = 3
    notebook["nbformat_minor"] = 0
    notebook["worksheets"] = [make_worksheet(code_list)]
    return notebook

def make_worksheet(code_list=None, cell_type="code", language="python"):
    worksheet = {}
    if code_list:
        worksheet["cells"] = [make_cell(code_list, cell_type="code", language="python")]
    else:
        worksheet["cells"] = []
    worksheet["metadata"] = {}
    return worksheet

def add_cell(notebook, cell):
    notebook["worksheets"][0]["cells"].append(cell)

def make_cell(code_list=None, cell_type="code", language="python"):
    cell = {
        "cell_type": cell_type, # markdown, code, 
        "collapsed": False,
        "metadata": {},
    }
    if cell_type == "code":
        cell["input"] = code_list
        cell["language"] = language
        cell["outputs"] = []
    elif cell_type == "markdown":
        cell["source"] = code_list
    return cell

if __name__ == '__main__':
    import sys
    for arg in sys.argv[1:]:
        convert(arg)
