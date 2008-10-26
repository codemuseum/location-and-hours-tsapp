var LocationAndHoursEdit = {
  init: function() {
    $$('.app-location-and-hours').each(function(el) { 
      el.getElementsBySelector('.directions a').each(function(a) {
        a.observe('click', function() { LocationAndHoursEdit.updateMap(el); });
      });
      
      el.getElementsBySelector('.day').each(function(day) {
        day.getElementsBySelector('a.toggler').each(function(a) {
          a.observe('click', function() { LocationAndHoursEdit.updateClosed(day, a); });
        });
      });
    });
  },
  
  updateMap: function(map) {
    var name = map.getElementsBySelector('h2 input')[0];
    var street = map.getElementsBySelector('.street-line1 input')[0];
    var city = map.getElementsBySelector('.city input')[0];
    var state = map.getElementsBySelector('.state input')[0];
    var zip = map.getElementsBySelector('.zip input')[0];
    var country = map.getElementsBySelector('.country select')[0];
    var location = street.value + ", " + city.value + " " + state.value + (country.value ? ", " + country.value : "");
    
    var iframeObj = map.getElementsBySelector('iframe')[0]
    var iframe = window.frames[iframeObj.name];
    var previous_url = iframeObj.src;
    var host = previous_url.substring(0, previous_url.indexOf('?'))
    iframe.location.replace(
      host + 
      "?a="  + escape(location) + 
      "&af=" + escape(location + (name.value ? name.value : ''))
    );
  },
  
  updateClosed: function(day, a) {
    var closed = day.getElementsBySelector('.day-name input')[0];
    if (closed.value == '' || closed.value == 'false' || closed.value == '0') {  
      a.removeClassName('toggled-on');
      day.addClassName('closed');
      closed.value = 'true';
      
    }
    else {
      
      a.addClassName('toggled-on');
      day.removeClassName('closed');
      closed.value = 'false';
      day.getElementsBySelector('select')[0].focus();
    }
  }
}
LocationAndHoursEdit.init();