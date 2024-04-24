// If you're using ES6 import to get the stimulus library or others:
// import { Controller } from "@hotwired/stimulus"

document.addEventListener("DOMContentLoaded", () => {
  const checkbox = document.querySelector('#order_use_default_address');
  const addressFields = document.querySelector('#new-address-fields');

  checkbox.addEventListener('change', () => {
    addressFields.style.display = checkbox.checked ? 'none' : 'block';
  });
});
