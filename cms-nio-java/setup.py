from setuptools import setup, find_packages

setup(
    name="cms-nio-java",
    version="1.0",
    packages=find_packages(),
    entry_points={
        "cms.grading.languages": [
            "NIOJavaJDK=niojava:NIOJavaJDK"
        ]
    }
)
