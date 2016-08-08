$(document).ready(function(){
  if($('#videos-container').length === 1) {
    loadVideos('#videos-container', '/videos?page=1');

    $(document).on('click', '.videos-pager-link', function(e) {
      e.preventDefault();

      loadVideos('#videos-container', $(this).attr('href'));
    });
  }
});

function loadVideos(containerId, url){
  $.ajax({
    url: url,
    type: 'get'
  }).done(function(data){
    $(containerId).html(data);
  });
}
