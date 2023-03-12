from setuptools import setup, find_packages

setup(
    name="cms-nio-pypy",
    version="1.0",
    packages=find_packages(),
    entry_points={
        "cms.grading.languages": [
            "NIOPython3PyPy=niopypy:NIOPython3PyPy"
        ]
    }
)
