// public/javascripts/application.js
$(function() {

  $("form.delete").submit(function(event) { //targers elements with type form and class delete
    event.preventDefault(); //prevents default form action
    event.stopPropagation(); //prevents parent even handlers from being notified of the event

    var ok = confirm("Are you sure? This cannot be undone!");
    if (ok) { // instead of allowing the form to be submitted we create an ajax request
      var form = $(this); // wrap the form in a jquery object

      var request = $.ajax({ // $ is used to access the jquery requestobject, object returned by calling ajax on jquery request object
        url: form.attr("action"), // url is where we're going to send the request to,
        method: form.attr("method")
      });

      request.done(function(data, textStatus, jqXHR) { // data that comes back from the server; executes only if request status is less than 400
        if (jqXHR.status === 204) {
          form.parent("li").remove(); //returns the first list item parent of the form
        } else if (jqXHR.status === 200) {
          document.location = data; //data is the URL that's returned by the route defined in todo.rb 
        }
      });
    }
  });

});