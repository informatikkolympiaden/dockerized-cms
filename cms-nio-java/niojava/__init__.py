#!/usr/bin/env python3

# Contest Management System - http://cms-dev.github.io/
# Copyright © 2016-2017 Stefano Maggiolo <s.maggiolo@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""Java programming language definition, using the default JDK installed
in the system.
"""

from shlex import quote as shell_quote

from cms.grading import Language


__all__ = ["NIOJavaJDK"]


class NIOJavaJDK(Language):
    """This defines the Java programming language, compiled and executed using
    the Java Development Kit available in the system.
    """

    USE_JAR = True

    @property
    def name(self):
        """See Language.name."""
        return "NIO Java / JDK"

    @property
    def source_extensions(self):
        """See Language.source_extensions."""
        return [".java"]

    @property
    def requires_multithreading(self):
        """See Language.requires_multithreading."""
        return True

    def get_compilation_commands(self,
                                 source_filenames, executable_filename,
                                 for_evaluation=True):
        """See Language.get_compilation_commands."""
        compile_command1 = ["/bin/mv", source_filenames[0], "Main.java"]
        compile_command2 = ["/usr/bin/javac", "Main.java"]
        # We need to let the shell expand *.class as javac create
        # a class file for each inner class.
        jar_command = ["/bin/sh", "-c",
                       " ".join(["jar", "cf",
                                 shell_quote(executable_filename),
                                 "*.class"])]
        #if NIOJavaJDK.USE_JAR:
        #    jar_command = ["/bin/sh", "-c",
        #                   " ".join(["jar", "cf",
        #                             shell_quote(executable_filename),
        #                             "*.class"])]
        #    #return [compile_command1, compile_command2, jar_command]
        #    return [["/usr/bin/true"]]
        #else:
        #    zip_command = ["/bin/sh", "-c",
        #                   " ".join(["zip", "-r", "-", "*.class", ">",
        #                             shell_quote(executable_filename)])]
        #    #return [compile_command1, compile_command2, zip_command]
        #    return [["/usr/bin/true"]]

        return [compile_command1, compile_command2, jar_command]

    def get_evaluation_commands(
            self, executable_filename, main=None, args=None):
        """See Language.get_evaluation_commands."""
        args = args if args is not None else []

        nio_main = "Main"

        if NIOJavaJDK.USE_JAR:
            # executable_filename is a jar file, main is the name of
            # the main java class
            return [["/usr/bin/java", "-Deval=true", "-Xmx512M", "-Xss64M",
                     "-cp", executable_filename, nio_main] + args]
        else:
            unzip_command = ["/usr/bin/unzip", executable_filename]
            command = ["/usr/bin/java", "-Deval=true", "-Xmx512M", "-Xss64M",
                       nio_main] + args
            return [unzip_command, command]
