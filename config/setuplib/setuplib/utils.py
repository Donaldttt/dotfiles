import sys
import os

class setup():
    def __init__(self):
        pass

    def _has_path(self, path):
        """
        Check if path exists(is file or directory)
        """
        return os.path.exists(path)

    def _is_file(self, path):
        """
        Check if path is file
        """
        return os.path.isfile(path)

    def _is_dir(self, path):
        """
        Check if path is directory
        """
        return os.path.isdir(path)


