#!/usr/bin/env python3
"""Check that the public stable profile and its published archives agree."""

import argparse
import hashlib
import plistlib
import re
from pathlib import Path, PurePosixPath
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
PROFILE = ROOT / "stable/SF514-53T-Sequoia-15.8.3"
ARCHIVES = ROOT / "experiments/2026-11-20"
CORE_FILES = (
    "EFI/BOOT/BOOTx64.efi",
    "EFI/OC/OpenCore.efi",
    "EFI/OC/Drivers/OpenRuntime.efi",
    "EFI/OC/Drivers/OpenCanopy.efi",
    "EFI/OC/Drivers/ResetNvramEntry.efi",
)
KEXT_ARCHIVES = (
    (
        "intel9560-airdrop/Intel9560-AirDrop-Sequoia-dwell-ac9560.zip",
        "AirportItlwm.kext",
        "AirportItlwm.kext",
    ),
    (
        "intel9560-airdrop/BlueToolFixup-AirDrop-2.7.4.zip",
        "BlueToolFixup-AirDrop.kext",
        "BlueToolFixup.kext",
    ),
    ("intel-sst-mic/Swift5-TGLDmic-0.5.0-test.zip", "TGLDmic.kext", "TGLDmic.kext"),
)


def read_manifest(path):
    manifest = {}
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        match = re.fullmatch(r"([0-9a-f]{64})  (EFI/(?:BOOT|OC)/.+)", line)
        if not match:
            raise SystemExit(f"Invalid manifest entry on line {number}")
        digest, name = match.groups()
        if name in manifest or ".." in PurePosixPath(name).parts or str(PurePosixPath(name)) != name:
            raise SystemExit(f"Invalid or duplicate manifest path on line {number}")
        manifest[name] = digest
    return manifest


def required_files(config):
    yield from CORE_FILES
    configured_paths = (
        ("ACPI", "Add", "ACPI"),
        ("UEFI", "Drivers", "Drivers"),
        ("Misc", "Tools", "Tools"),
    )
    for section, key, folder in configured_paths:
        for entry in config[section][key]:
            if entry["Enabled"]:
                yield f"EFI/OC/{folder}/{entry['Path']}"
    for entry in config["Kernel"]["Add"]:
        if entry["Enabled"]:
            bundle = f"EFI/OC/Kexts/{entry['BundlePath']}"
            yield f"{bundle}/{entry['PlistPath']}"
            if entry["ExecutablePath"]:
                yield f"{bundle}/{entry['ExecutablePath']}"


def verify_archive(package, paths, manifest):
    for source, destination in paths:
        digest = hashlib.sha256(package.read(source)).hexdigest()
        if digest != manifest.get(destination):
            archive = Path(package.filename).name
            raise SystemExit(f"{archive} does not match SHA256SUMS for {destination}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("opencore_archive", type=Path, help="OpenCore 1.0.9 DEBUG ZIP from build ebea824")
    args = parser.parse_args()

    with (PROFILE / "config.plist").open("rb") as file:
        config = plistlib.load(file)
    generic = config["PlatformInfo"]["Generic"]
    for key, expected in {"MLB": "", "SystemSerialNumber": "", "SystemUUID": "", "ROM": bytes(6)}.items():
        if generic[key] != expected:
            raise SystemExit(f"Clear PlatformInfo > Generic > {key} before publishing")

    manifest = read_manifest(PROFILE / "SHA256SUMS")
    missing = set(required_files(config)) - manifest.keys()
    if missing:
        raise SystemExit("Missing boot files in SHA256SUMS:\n" + "\n".join(sorted(missing)))

    with ZipFile(args.opencore_archive) as package:
        verify_archive(package, ((f"X64/{path}", path) for path in CORE_FILES), manifest)
    for archive, source_name, installed_name in KEXT_ARCHIVES:
        source_prefix = f"{source_name}/"
        destination_prefix = f"EFI/OC/Kexts/{installed_name}/"
        with ZipFile(ARCHIVES / archive) as package:
            paths = {
                source: destination_prefix + source[len(source_prefix):]
                for source in package.namelist()
                if source.startswith(source_prefix) and not source.endswith("/")
            }
            expected = {path for path in manifest if path.startswith(destination_prefix)}
            if not paths or set(paths.values()) != expected:
                raise SystemExit(f"Bundle file list in {archive} does not match SHA256SUMS")
            verify_archive(package, paths.items(), manifest)

    print("Public identity fields, boot-file manifest and pinned archives verified.")


if __name__ == "__main__":
    main()
