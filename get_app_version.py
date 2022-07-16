"""Prints the version of the app for use in container builds."""

with open("pubspec.yaml", "r", encoding="utf-8") as infile:
    lines = infile.readlines()
version_start = "version:"
version_line = next(
    line for line in lines if line.startswith(version_start)
)
version_line = version_line[len(version_start):]
print(version_line.strip())
