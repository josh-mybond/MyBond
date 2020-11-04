//
// document.addEventListener("DOMContentLoaded", () => {
//   console.log("split_payments: 1");
//
//   let split = document.getElementById("split_payments_iframe");
//   if (!split) { return }
//
//   console.log("split_payments: 2");
//
//   window.addEventListener(
//     "message",
//     (event) => {
//       console.log("split_payments: 4");
//       split_complete(event);
//     },
//     false
//   );
//
//   console.log("split_payments: 3");
//
//   // handle event returned from split iframe
//   async function split_complete(event) {
//     console.log("split_complete_event: 1");
//     console.log(event);
//     // Ignore the event if it's not from Split
//     if (
//       event.origin !== "https://go.sandbox.split.cash" &&
//       event.origin !== "https://go.split.cash"
//     ) {
//       console.log("split_complete_event: 2");
//       return;
//     }
//
//     console.log("split_complete_event: 3");
//
//     // Ensure event is sane
//     if (event.isTrusted !== true && data !== null) {
//       console.log("split_complete_event: 4");
//       // TODO return an error message here
//       console.log(event);
//       return;
//     }
//
//     // populate page elements with the data
//     console.log("split_complete_event: 5");
//     console.log(event);
//
//     // submit hidden form
//   };
//
// });
