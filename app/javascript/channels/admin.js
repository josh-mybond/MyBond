import consumer from "./consumer";


document.addEventListener("DOMContentLoaded", () => {
  const meta_tag = document.querySelector('meta[name="admin-user"]');

  if (meta_tag) {
    let admin_id = meta_tag.dataset.id;

    let admin_channel = consumer.subscriptions.create(
      { channel: "AdminChannel", room: "messenges" },
      {
        // TODO: remove logging after logic added

        connected() {
          console.log("AdminChannel: Subscribed");
        },

        received(data) {
          console.log("AdminChannel: received data");
          console.log(data);
        },

        disconnected() {
          console.log("AdminChannel Disconnected!");
        }
      }
    );

  }
});
