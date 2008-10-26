var LocationAndHoursEdit = {
  init: function() {
    $$('.app-location-and-hours').each(function(el) { 
      el.getElementsBySelector('.directions a').each(function(a) {
        a.observe('click', function() { LocationAndHoursEdit.updateMap(el); });
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
    
    // Doesn't support just replacing the src without hitting the back button
    // var iframe = map.getElementsBySelector('iframe')[0];
    // var host = iframe.src.substring(0, iframe.src.indexOf('?'))
    // iframe.src.replace(
    //   host + 
    //   "?a="  + escape(location) + 
    //   "&af=" + escape(location + (name.value ? name.value : ''))
    // );
  }
}
LocationAndHoursEdit.init();