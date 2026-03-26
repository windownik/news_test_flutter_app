/// States for image save and share operations.
sealed class OpenImageState {
  const OpenImageState();
}

class OpenImageIdle extends OpenImageState {
  const OpenImageIdle();
}

class OpenImageBusy extends OpenImageState {
  const OpenImageBusy();
}

class OpenImageMessage extends OpenImageState {
  const OpenImageMessage(this.text);

  final String text;
}
