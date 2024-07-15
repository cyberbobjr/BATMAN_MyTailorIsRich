local HTC_MTIR_ContextMenu = require("HTC_Tailoring_context")

Events.OnFillInventoryObjectContextMenu.Add(HTC_MTIR_ContextMenu.BuildContext);
