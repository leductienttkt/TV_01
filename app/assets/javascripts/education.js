// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap-sprockets
//= require jquery-ui/autocomplete
//= require education/feedback_map.js
//= require education/growl.custom
//= require js-routes
//= require social-share-button
//= require education/projects
//= require cocoon
//= require education/course
//= require education/course_member
//= require education/project_member
//= require education/users
//= require education/posts
//= require i18n
//= require i18n.js
//= require i18n/translations

function showEditForm(id) {
  $.ajax({
    url: Routes.edit_education_project_path(id) ,
    type:'GET',
    dataType: 'json',
    complete: function(xhr){
      var html_text = xhr.responseText;
      $('#show-edit-form').html(html_text);
      $('#edit-modal').modal('show');
    }
  })
}