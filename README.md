- 👋 Hi, I’m @KEnilMangukiya
- 👀 I’m interested in ...
- 🌱 I’m currently learning ...
- 💞️ I’m looking to collaborate on ...
- 📫 How to reach me ...

<!---
KEnilMangukiya/KEnilMangukiya is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->

## Flutter: Create Call Info (CRM + Non‑CRM)

This repo now contains a drop‑in Flutter screen that lets an agent create **call info** with:
- **CRM mode**: render **dynamic CRM fields** from a schema (server-driven UI).
- **Non‑CRM mode**: show a **simple customer detail form** (name/phone/email/company/address).

### File

- `lib/create_call_info_view.dart`

### Usage (example)

```dart
import 'package:flutter/material.dart';
import 'create_call_info_view.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateCallInfoView(
                      crm: demoCrmContext(), // CRM flow (dynamic)
                      onSubmit: (draft) async {
                        // TODO: call your API
                        debugPrint(draft.toJson().toString());
                      },
                    ),
                  ),
                );
              },
              child: const Text('Create CRM call info'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateCallInfoView(
                      crm: null, // Non‑CRM flow (simple customer form)
                      onSubmit: (draft) async {
                        debugPrint(draft.toJson().toString());
                      },
                    ),
                  ),
                );
              },
              child: const Text('Create manual call info'),
            ),
          ],
        ),
      ),
    );
  }
}
```
