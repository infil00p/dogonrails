/**
 * $Id: editor_plugin_src.js 126 2006-10-22 16:19:55Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright � 2004-2006, Moxiecode Systems AB, All rights reserved.
 */

var TinyMCE_NonEditablePlugin = {
	getInfo : function() {
		return {
			longname : 'Non editable elements',
			author : 'Moxiecode Systems AB',
			authorurl : 'http://tinymce.moxiecode.com',
			infourl : 'http://tinymce.moxiecode.com/tinymce/docs/plugin_noneditable.html',
			version : tinyMCE.majorVersion + "." + tinyMCE.minorVersion
		};
	},

	initInstance : function(inst) {
		tinyMCE.importCSS(inst.getDoc(), tinyMCE.baseURL + "/plugins/noneditable/css/noneditable.css");

		// Ugly hack
		if (tinyMCE.isMSIE5_0)
			tinyMCE.settings['plugins'] = tinyMCE.settings['plugins'].replace(/noneditable/gi, 'Noneditable');
	},

	handleEvent : function(e) {
		return this._moveSelection(e, tinyMCE.selectedInstance);
	},

	cleanup : function(type, content, inst) {
		// Pass through Gecko
		if (tinyMCE.isGecko)
			return content;

		switch (type) {
			case "insert_to_editor_dom":
				var nodes = tinyMCE.getNodeTree(content, new Array(), 1);
				var editClass = tinyMCE.getParam("noneditable_editable_class", "mceItemEditable");
				var nonEditClass = tinyMCE.getParam("noneditable_noneditable_class", "mceItemNonEditable");

				for (var i=0; i<nodes.length; i++) {
					var elm = nodes[i];

					// Convert contenteditable to classes
					var editable = tinyMCE.getAttrib(elm, "contenteditable");
					if (new RegExp("true|false","gi").test(editable))
						TinyMCE_NonEditablePlugin._setEditable(elm, editable == "true");

					if (tinyMCE.isMSIE) {
						var className = elm.className ? elm.className : "";

						if (className.indexOf(editClass) != -1)
							elm.contentEditable = true;

						if (className.indexOf(nonEditClass) != -1)
							elm.contentEditable = false;
					}
				}

				break;

			case "insert_to_editor":
				if (tinyMCE.isMSIE) {
					var editClass = tinyMCE.getParam("noneditable_editable_class", "mceItemEditable");
					var nonEditClass = tinyMCE.getParam("noneditable_noneditable_class", "mceItemNonEditable");

					content = content.replace(new RegExp("class=\"(.*)(" + editClass + ")([^\"]*)\"", "gi"), 'class="$1$2$3" contenteditable="true"');
					content = content.replace(new RegExp("class=\"(.*)(" + nonEditClass + ")([^\"]*)\"", "gi"), 'class="$1$2$3" contenteditable="false"');
				}

				break;

			case "get_from_editor_dom":
				if (tinyMCE.getParam("noneditable_leave_contenteditable", false)) {
					var nodes = tinyMCE.getNodeTree(content, new Array(), 1);

					for (var i=0; i<nodes.length; i++)
						nodes[i].removeAttribute("contenteditable");
				}

				break;
		}

		return content;
	},

	_moveSelection : function(e, inst) {
		var s, r, sc, ec, el, c = tinyMCE.getParam('noneditable_editable_class', 'mceItemNonEditable');

		if (!inst)
			return true;

		// Always select whole element
		if (tinyMCE.isGecko) {
			s = inst.selection.getSel();
			r = s.getRangeAt(0);
			sc = tinyMCE.getParentNode(r.startContainer, function (n) {return tinyMCE.hasCSSClass(n, c);});
			ec = tinyMCE.getParentNode(r.endContainer, function (n) {return tinyMCE.hasCSSClass(n, c);});

			sc && r.setStartBefore(sc);
			ec && r.setEndAfter(ec);

			if (sc || ec) {
				if (e.type == 'keypress' && e.keyCode == 39) {
					el = sc || ec;

					// Try!!
				}

				s.removeAllRanges();
				s.addRange(r);

				return tinyMCE.cancelEvent(e);
			}
		}

		return true;
	},

	_setEditable : function(elm, state) {
		var editClass = tinyMCE.getParam("noneditable_editable_class", "mceItemEditable");
		var nonEditClass = tinyMCE.getParam("noneditable_noneditable_class", "mceItemNonEditable");

		var className = elm.className ? elm.className : "";

		if (className.indexOf(editClass) != -1 || className.indexOf(nonEditClass) != -1)
			return;

		if ((className = tinyMCE.getAttrib(elm, "class")) != "")
			className += " ";

		className += state ? editClass : nonEditClass;

		elm.setAttribute("class", className);
		elm.className = className;
	}
};

tinyMCE.addPlugin("noneditable", TinyMCE_NonEditablePlugin);
