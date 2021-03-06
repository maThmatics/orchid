import 'package:flutter/material.dart';
import 'package:orchid/api/orchid_api.dart';
import 'package:orchid/api/orchid_api_real.dart';
import 'package:orchid/api/orchid_crypto.dart';
import 'package:orchid/api/orchid_vpn_config.dart';
import 'package:orchid/api/user_preferences.dart';
import 'package:orchid/pages/circuit/model/circuit.dart';
import 'package:orchid/pages/circuit/model/circuit_hop.dart';
import 'package:orchid/pages/circuit/model/orchid_hop.dart';
import 'package:orchid/pages/common/formatting.dart';
import 'package:orchid/pages/common/page_tile.dart';
import 'package:orchid/pages/common/screen_orientation.dart';
import 'package:orchid/pages/common/titled_page_base.dart';
import 'package:orchid/pages/settings/import_export_config.dart';

import '../app_text.dart';

/// The manage configuration page allows export and import of the hops config
class ManageConfigPage extends StatefulWidget {
  @override
  _ManageConfigPageState createState() => _ManageConfigPageState();
}

class _ManageConfigPageState extends State<ManageConfigPage> {
  @override
  void initState() {
    super.initState();
    ScreenOrientation.portrait();
    initStateAsync();
  }

  void initStateAsync() async {
  }

  Widget build(BuildContext context) {
    var instructionsStyle = AppText.listItem.copyWith(
        color: Colors.black54, fontStyle: FontStyle.italic, fontSize: 14);
    return TitledPage(
      title: "Manage Configuration",
      child: Column(
        children: <Widget>[
          pady(24),
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
            child: Text(
                'Warning: These features are intended for advanced users only.  Please read all instructions.',
                style: instructionsStyle),
          ),
          Divider(),
          pady(16),
          PageTile(
            title: "Export Hops Configuration",
            trailing: RaisedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.save),
                  padx(8),
                  Text("Export"),
                ],
              ),
              onPressed: _doExport,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
            child: Text(
                "Warning: Exported configuration includes the signer private key secrets for the exported hops."
                "  Revealing private keys exposes you to loss of all funds in the associated Orchid accounts.",
                style: instructionsStyle),
          ),
          Divider(),
          pady(16),
          PageTile(
            title: "Import Hops Configuration",
            trailing: RaisedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.input),
                  padx(8),
                  Text("Import"),
                ],
              ),
              onPressed: _doImport,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
            child: Text(
                "Warning: Imported configuration will replace any existing hops that you have created in the app."
                "  Signer keys previously generated or imported on this device will be retained and remain"
                " accessible for creating new hops, however all other configuration including OpenVPN hop configuration will be lost.",
                style: instructionsStyle),
          ),
          pady(16),
          Divider(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    ScreenOrientation.reset();
  }

  void _doExport() async {
    String hopsConfig = await OrchidVPNConfig.generateHopsConfig();
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ImportExportConfig.export(
        title: "Export Hops Configuration",
        config: hopsConfig,
      );
    }));
  }

  void _doImport() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ImportExportConfig.import(
        title: "Import Hops Configuration",
        validator: OrchidVPNConfigValidation.configValid,
        onImport: _importConfig,
      );
    }));
  }

  void _importConfig(String config) async {
    await OrchidVPNConfig.importConfig(config);
    Navigator.pop(context);
  }
}

