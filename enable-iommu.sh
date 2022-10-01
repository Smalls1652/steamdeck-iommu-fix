#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Check to see if the change has already been applied
doesUpdatedGrubExist=$(cat /etc/default/grub | grep -E -i 'GRUB_CMDLINE_LINUX_DEFAULT=".+(amd_iommu=on iommu=pt).+"')

if [ -z "$doesUpdatedGrubExist" ]
then
    # If the change hasn't been made, then modify the GRUB config.

    # Disable the read-only filesystem for SteamOS to make the changes.
    echo -e "- Disabling read-only filesystem"
    steamos-readonly disable

    # Backup the current GRUB config to the user's home dir.
    currentDateTime=$(date +"%Y-%m-%d_%H-%M-%S")
    echo -e "- Backing up current GRUB config to '~/grub.${currentDateTime}.bak'"
    cp /etc/default/grub "~/grub.${currentDateTime}.bak"

    # Replace 'amd_iommu=off' to 'amd_iommu=on iommu=pt' in the GRUB config.
    echo -e "- Replacing 'amd_iommu=off' to 'amd_iommu=on iommu=pt'"
    cat /etc/default/grub |  sed -E 's/amd_iommu=off/amd_iommu=on iommu=pt/' > /etc/default/grub

    # Run 'grub-mkconfig' to use the updated parameters.
    echo -e "- Rebuilding GRUB with updated parameters\n-----------------------\n"
    grub-mkconfig -o /efi/EFI/steamos/grub.cfg
    echo -e "\n-----------------------\n"

    # Re-enable the read-only filesystem
    echo -e "- Enabling read-only filesystem"
    steamos-readonly enable

    echo -e "\nFinished! Reboot your system for the changes to take effect."
else
    # If the change has been made, do nothing.
    echo -e "Nothing to do. GRUB has already been updated."
fi