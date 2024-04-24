// app/assets/javascripts/cart_controller.js
(function() {
  const application = Stimulus.Application.start();

  application.register("cart", class extends Stimulus.Controller {
    static get targets() {
      return ["quantity"];
    }

    connect() {
      console.log("Cart controller connected"); // This will log to the console when the controller is successfully connected.
      // You can also add other initialization code here if needed.
    }

    update(event) {
      event.preventDefault();
      let formData = new FormData(event.target.form);
      fetch(event.target.form.action, {
        method: 'PATCH',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content"),
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      }).then(response => response.json())
        .then(data => {
          console.log('Updated successfully', data);
        }).catch(error => {
          console.log('Update failed', error);
        });
    }
  });
})();
