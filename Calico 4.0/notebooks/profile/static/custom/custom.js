/**
 * Calico Jupyter Notebooks Extensions
 *
 * Copyright (c) The Calico Project
 * http://calicoproject.org/ICalico
 *
 * Released under the BSD Simplified License
 *
 **/

$([IPython.events]).on('app_initialized.NotebookApp', function() {
    require(['/static/custom/drag-and-drop.js']);
    /* Logo for Calico */
    var img = $('.container img')[0];
    img.src = "/static/custom/icalico_logo.png";
});

IPython.load_extensions("calico-spell-check", 
			"calico-document-tools", 
			"calico-cell-tools");
