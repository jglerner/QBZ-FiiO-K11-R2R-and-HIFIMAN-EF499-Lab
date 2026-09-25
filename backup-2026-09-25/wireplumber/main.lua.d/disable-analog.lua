rule = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.pci-0000_65_00.6" },
    },
  },
  apply_properties = {
    ["device.disabled"] = true,
  },
}

table.insert(alsa_monitor.rules, rule)
