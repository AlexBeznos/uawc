$(document).ready(function() {
  var form_alert = function(error) {
    var st = "<div class='alert alert-warning' role='alert'><button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>";
    var ct = "Url ";

    for (index = 0; index < error.url.length; ++index) {
      if(index < error.url.length -1) {
        var coma = ', '
      } else {
        var coma = ''
      }

      ct = ct + (error.url[index] + coma);
      console.log(ct);

    }

    return st + ct + "</div>"
  }

  $('form').submit(function(e) {
    e.preventDefault();
    $('#submit').button('loading');

    $.ajax({
      url: '/sitemaps',
      method: 'POST',
      data: {url: $('#sitemap_url').val()}
    }).fail(function(res) {
      $('#main').prepend(form_alert(JSON.parse(res.responseText).errors));
      $('#submit').button('reset');
    }).success(function(res) {
      $('.panel-body').html(res);
    })
  });
});
