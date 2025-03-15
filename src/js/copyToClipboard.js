export function copy_to_clipboard() {
  var copyText = document.getElementById("output-box");

  copyText.select();
  copyText.setSelectionRange(0, 99999);

  navigator.clipboard.writeText(copyText.value);

  alert("Copied the text: " + copyText.value);
}