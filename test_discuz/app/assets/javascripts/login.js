$(function($) {
    $('#lf').bind(
        'ajax:success',
        function(data, status, xhr) {
            $("#login").html(status);
        }).bind(
        'ajax:error',
        function(xhr, status, error) {
            alert(error);
        });
});