# fedora-harden.sh

Security hardening baseline for a **personal Fedora Workstation laptop**
(single user, GNOME, developer machine). Threat model: lost/stolen laptop,
untrusted Wi-Fi, malicious downloads. Not a server — server/enterprise
controls (banners, password aging, umask, remote logging, USB lockdown, most
sysctl tweaks) are intentionally omitted; the script header explains each.

## What it does

| Section    | Action |
|------------|--------|
| `preflight`| Verify Fedora, non-root, sudo, network. Always runs. |
| `report`   | Read-only status: firewall, SELinux, LUKS, Secure Boot, dev services, auto-updates. Always runs. |
| `updates`  | `dnf upgrade`, install + enable `dnf-automatic` with `apply_updates = yes`. |
| `firewall` | Default zone → `public` (Fedora's default zone opens all ports >1024). |
| `audit`    | Lynis audit, saved to a file, laptop-relevant suggestions only. |
| `rkhunter` | Install, fix `WEB_CMD`, set baseline, run check, label benign warnings. |
| `aide`     | Init file-integrity database (skipped if one exists; `--force` to redo). |
| `services` | Offer to disable `httpd`/`mariadb`/`mysqld` at boot — asks per service, never touches docker. |
| `helpers`  | Install `sec-check` and `sec-rebaseline` to `/usr/local/bin`. |

It **never** disables SELinux, and only *reports* disk-encryption and Secure
Boot status (those need a reinstall / firmware access).

## Flags

```
./fedora-harden.sh                # dry run (default) — prints, changes nothing
./fedora-harden.sh --apply        # make changes, confirm each section
./fedora-harden.sh --apply --yes  # no section prompts (service disables still ask)
--only <section>                  # run just one section (repeatable)
--skip <section>                  # skip a section (repeatable)
--force                           # re-init AIDE db even if one exists
```

Idempotent — safe to re-run any time; already-correct items print `[ok]`.
Edited configs are backed up to `<file>.bak-<timestamp>` and listed at the
end. Everything is logged to `/var/log/fedora-harden.log`.

## Maintenance rhythm

```
sec-check        # BEFORE a system update — verify nothing is off
sec-rebaseline   # AFTER a system update — accept new files as the trusted baseline
```

Skip the rebaseline and every future check drowns in update noise; skip the
check and you can't tell an update's changes from an intruder's.
