#!/usr/bin/env python3
"""Build a hooked coreauthd launchd plist from the Apple original."""
import plistlib
import sys

src, binary, hook, out = sys.argv[1:5]
with open(src, "rb") as f:
    d = plistlib.load(f)
d["ProgramArguments"] = [binary]
env = d.get("EnvironmentVariables", {})
env["DYLD_INSERT_LIBRARIES"] = hook
env["ACERFP_FORCE_GESTALT"] = "1"
env["MallocSpaceEfficient"] = "1"
d["EnvironmentVariables"] = env
d["StandardOutPath"] = "/private/tmp/acerfp-coreauthd.out"
d["StandardErrorPath"] = "/private/tmp/acerfp-coreauthd.err"
with open(out, "wb") as f:
    plistlib.dump(d, f)
