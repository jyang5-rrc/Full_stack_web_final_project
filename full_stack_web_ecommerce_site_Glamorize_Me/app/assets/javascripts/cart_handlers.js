document.addEventListener('turbolinks:load', function() {
  setupCartEventHandlers();
});

function setupCartEventHandlers() {
  var useDefaultAddressCheckbox = document.getElementById('use_default_address');
  var defaultAddressDiv = document.getElementById('default-address');
  var newAddressFields = document.getElementById('new-address-fields');

  // Handling the change of address selection
  useDefaultAddressCheckbox.addEventListener('change', function() {
    if(this.checked) {
      newAddressFields.style.display = 'none';
      defaultAddressDiv.style.display = 'block';
    } else {
      newAddressFields.style.display = 'block';
      defaultAddressDiv.style.display = 'none';
    }
  });

  // More event bindings for AJAX actions
}
