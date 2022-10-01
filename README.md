# Enable IOMMU on the Steam Deck

I'll need to elaborate further, at a later time, on why I needed to enable IOMMU, but it involves _"potentially"_ fixing a GPU reset problem when playing games on the Steam Deck. 

## Enabling

**This requires you to have a password set on the `deck` user account.**

Open **Konsole** and run the following command:

```bash
curl -L "https://raw.githubusercontent.com/Smalls1652/steamdeck-iommu-fix/main/enable-iommu.sh" | sh
```

Enter your password when requested. Once it's finished, shutdown your Steam Deck, boot into the BIOS, enable IOMMU, and then exit saving changes.
