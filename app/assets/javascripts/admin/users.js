Users = function() {
  this._input = $('#users-search-txt');
  this._initAutocomplete();
};

Users.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: 'users/',
        appendTo: '#users-search-results',
        select: $.proxy(this._select, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
  },

  _render: function(ul, item) {
    var markup = [
      '<span class="img">',
        '<img src="' + item.image_url + '" />',
      '</span>',
      '<span class="email">' + item.email + '</span>',
      '<span class="name">' + item.name + '</span>',
      '<span class="added">' + item.created_at + '</span>',
      '<span class="is-admin"> Admin: ' + item.admin + '</span>'
    ];
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    //this._input.val(ui.item.email + ' - ' + ui.item.name);
    //return false;
    window.location.href = ui.item.edit_url;
  }
};
