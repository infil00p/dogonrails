// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* Google Earth Marker Creation */
function showNodeData(point, id, info_string) {
  var marker = new GMarker(point);
  marker.value = id;
  GEvent.addListener(marker, "click", function() {
    var myHtml = info_string;
    map.openInfoWindowHtml(point, myHtml);
  });
  return marker;
}

function showBandwidth() {
	if ($('bandwidth').style.display == 'none') {
		new Effect.BlindUp($('usage'));
		new Effect.BlindDown($('bandwidth'));
	}
}

function showUsage() {
	if ($('usage').style.display == 'none') {
		new Effect.BlindUp($('bandwidth'));
		new Effect.BlindDown($('usage'));
	}
}


function createIcon(active, alert, users)
{

  var i;
  if (!active) {
    if (users >= 10) {
      i = {image:"/images/bubbles-grey-10.png", x:41, y:41};
    } else if (users == 9) {
      i = {image:"/images/bubbles-grey-9.png", x:35, y:35};
    } else if (users == 8) {
      i = {image:"/images/bubbles-grey-8.png", x:34, y:34};
    } else if (users == 7) {
      i = {image:"/images/bubbles-grey-7.png", x:30, y:30};
    } else if (users == 6) {
      i = {image:"/images/bubbles-grey-6.png", x:29, y:29};
    } else if (users == 5) {
      i = {image:"/images/bubbles-grey-5.png", x:28, y:29};
    } else if (users == 4) {
      i = {image:"/images/bubbles-grey-4.png", x:27, y:26};
    } else if (users == 3) {
      i = {image:"/images/bubbles-grey-3.png", x:25, y:25};
    } else if (users == 2) {
      i = {image:"/images/bubbles-grey-2.png", x:24, y:24};
    } else if (users == 1) {
      i = {image:"/images/bubbles-grey-1.png", x:23, y:22};
    } else {
      i = {image:"/images/bubbles-grey-0.png", x:17, y:17};
    }
  } else if (alert) {
    if (users >= 10) {
      i = {image:"/images/bubbles-red-10.png", x:41, y:41};
    } else if (users == 9) {
      i = {image:"/images/bubbles-red-9.png", x:35, y:35};
    } else if (users == 8) {
      i = {image:"/images/bubbles-red-8.png", x:34, y:34};
    } else if (users == 7) {
      i = {image:"/images/bubbles-red-7.png", x:30, y:30};
    } else if (users == 6) {
      i = {image:"/images/bubbles-red-6.png", x:29, y:29};
    } else if (users == 5) {
      i = {image:"/images/bubbles-red-5.png", x:28, y:29};
    } else if (users == 4) {
      i = {image:"/images/bubbles-red-4.png", x:27, y:26};
    } else if (users == 3) {
      i = {image:"/images/bubbles-red-3.png", x:25, y:25};
    } else if (users == 2) {
      i = {image:"/images/bubbles-red-2.png", x:24, y:24};
    } else if (users == 1) {
      i = {image:"/images/bubbles-red-1.png", x:23, y:22};
    } else {
      i = {image:"/images/bubbles-red-0.png", x:17, y:17};
    }
  } else {
    if (users >= 10) {
      i = {image:"/images/bubbles-10.png", x:41, y:41};
    } else if (users == 9) {
      i = {image:"/images/bubbles-9.png", x:35, y:35};
    } else if (users == 8) {
      i = {image:"/images/bubbles-8.png", x:34, y:34};
    } else if (users == 7) {
      i = {image:"/images/bubbles-7.png", x:30, y:30};
    } else if (users == 6) {
      i = {image:"/images/bubbles-6.png", x:29, y:29};
    } else if (users == 5) {
      i = {image:"/images/bubbles-5.png", x:28, y:29};
    } else if (users == 4) {
      i = {image:"/images/bubbles-4.png", x:27, y:26};
    } else if (users == 3) {
      i = {image:"/images/bubbles-3.png", x:25, y:25};
    } else if (users == 2) {
      i = {image:"/images/bubbles-2.png", x:24, y:24};
    } else if (users == 1) {
      i = {image:"/images/bubbles-1.png", x:23, y:22};
    } else {
      i = {image:"/images/bubbles-0.png", x:17, y:17};
    }
  }
  
  
    var baseIcon = new GIcon();
    baseIcon.iconSize = new GSize(i.x, i.y);
    baseIcon.transparent = i.image;
    baseIcon.image = i.image;
    baseIcon.shadow=null;
    baseIcon.iconAnchor = new GPoint(i.x / 2, i.y / 2);
    baseIcon.infoWindowAnchor = new GPoint(10, 1);
    
    return baseIcon;
  
  
  
}

function createMarker(point, logged_in, active, alert, id, users, html)
{
    var icon = createIcon(active, alert, users);
    markerOptions = { icon:icon, draggable:logged_in };
    var marker = new GMarker(point, markerOptions);
    GEvent.addListener(marker, "click", function() {
        marker.openInfoWindowHtml(html);
    });
    GEvent.addListener(marker, "dragend", function() {
		    var new_coords = marker.getLatLng();
		    var newlat = new_coords.lat();
		    var newlng = new_coords.lng();
		    new Ajax.request('/access_nodes/moving?node_id=' + id + "&lat=" + lat + " &lng=" + lng);		 
		    });
    
    return marker;

}
