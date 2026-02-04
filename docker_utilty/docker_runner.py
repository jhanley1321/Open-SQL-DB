from pathlib import Path
import subprocess


class DockerRunner:
    def __init__(self, bat_name: str = "run-open-sql-db.bat"):
        """
        bat_name:
            Name of the .bat file expected to live in the project root.
            Can be overridden if the user renames it.
        """

        # Project root = folder containing this file's parent (repo root)
        self.project_root = Path(__file__).resolve().parent
        self.bat_path = self.project_root / bat_name

        if not self.bat_path.exists():
            raise FileNotFoundError(
                f"Could not find {bat_name} in project root: {self.project_root}"
            )

    def run(self) -> None:
        result = subprocess.run(
            [str(self.bat_path)],
            cwd=str(self.project_root),  # critical for relative paths in .bat
            shell=True,
            text=True,
            capture_output=True
        )

        if result.returncode != 0:
            raise RuntimeError(
                "Docker BAT failed\n\n"
                f"STDOUT:\n{result.stdout}\n\n"
                f"STDERR:\n{result.stderr}"
            )

        print("Docker containers started successfully.")