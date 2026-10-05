import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/car_filter_search/model/car_filter.dart';
import 'package:riverpod_learning/features/car_filter_search/provider/filter_notifier.dart';

// ---------------- Data (options) ----------------
const Color redColor = Color(0xFFE8384F);

const Map<String, List<String>> brandModels = {
  'Audi': ['Audi A6', 'Audi A8 L', 'Audi Q3'],
  'BMW': ['BMW 3 Series', 'BMW X1', 'BMW X5'],
  'Maruti': ['Wagon R', 'Swift', 'Baleno'],
  'Datsun': ['Redi-GO', 'GO'],
};

const List<String> bodyTypes = ['SUV', 'Sedan', 'Van', 'MUV'];
const List<String> variants = ['Automatic', 'Manual'];
const List<String> fuels = ['Petrol', 'Diesel', 'CNG', 'Hybrid', 'Electric'];

// slider min-max limit
const RangeValues budgetLimit = RangeValues(300000, 10000000);
const RangeValues mileageLimit = RangeValues(10, 100);
const RangeValues ccLimit = RangeValues(600, 2000);

// ---------------- Sheet ----------------
class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  // left menu la ippo edhu click pannirukkom
  FilterSection selected = FilterSection.brand;

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(draftFilterProvider); // tick values
    final notifier = ref.read(draftFilterProvider.notifier); // methods

    // left menu rows ah oru list la serkkrom
    List<Widget> menuRows = [];
    print('===================>');
    print(menuRows);
    for (final section in FilterSection.values) {
      menuRows.add(buildMenuItem(section, draft));
    }

    return Material(
      color: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          children: [
            buildHeader(),


            // naduvula: left menu + right panel
            Expanded(
              child: Row(
                children: [
                  // LEFT MENU
                  Container(
                    width: 125,
                    color: Colors.grey.shade100,
                    child: ListView(children: menuRows),
                  ),
                  // RIGHT PANEL
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildRightPanel(draft, notifier),
                    ),
                  ),
                ],
              ),
            ),


            buildFooter(notifier),
          ],
        ),
      ),
    );
  }

  // ---------------- Header ----------------
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: Text('Filter', style: TextStyle(fontSize: 16)),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context); // sheet close
            },
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  // ---------------- Footer (Clear All / Apply) ----------------
  Widget buildFooter(DraftFilterNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                notifier.clear(); // draft mattum clear
              },
              child: const Text('Clear All'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // 1. draft values eduthuko
                final draftValues = ref.read(draftFilterProvider);
                // 2. applied la save pannu
                ref.read(appliedFilterProvider.notifier).apply(draftValues);
                // 3. sheet close
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Left menu row ----------------
  Widget buildMenuItem(FilterSection section, CarFilter draft) {
    bool isSelected = (section == selected);
    int count = draft.countFor(section);

    return InkWell(
      onTap: () {
        setState(() {
          selected = section; // right panel maarum
        });
      },
      child: Container(
        color: isSelected ? Colors.white : null,
        padding: const EdgeInsets.all(14),
        child: Text(
          '${section.label} ($count)', // Example: Brands (1)
          style: TextStyle(color: isSelected ? redColor : Colors.black),
        ),
      ),
    );
  }

  // ---------------- Right panel: edhu kaattanum? ----------------
  Widget buildRightPanel(CarFilter draft, DraftFilterNotifier notifier) {
    if (selected == FilterSection.brand) {
      return buildBrandPanel(draft, notifier);
    }
    if (selected == FilterSection.bodyType) {
      return buildCheckPanel(
          'Body Types', bodyTypes, draft.bodyTypes, notifier.toggleBodyType);
    }
    if (selected == FilterSection.budget) {
      return buildRangePanel('Budget range', budgetLimit,
          draft.budget ?? budgetLimit, notifier.setBudget, '₹ ', '');
    }
    if (selected == FilterSection.mileage) {
      return buildRangePanel('Mileage range', mileageLimit,
          draft.mileage ?? mileageLimit, notifier.setMileage, '', ' km');
    }
    if (selected == FilterSection.variant) {
      return buildCheckPanel(
          'Variants', variants, draft.variants, notifier.toggleVariant);
    }
    if (selected == FilterSection.engineCc) {
      return buildRangePanel('Engine cc range', ccLimit,
          draft.engineCc ?? ccLimit, notifier.setEngineCc, '', ' cc');
    }
    if (selected == FilterSection.fuel) {
      return buildCheckPanel('Fuel', fuels, draft.fuels, notifier.toggleFuel);
    }

    // meedhi irukkradhu Ratings
    return buildRatingPanel(draft, notifier);
  }

  // ---------------- One checkbox row ----------------
  Widget buildCheckRow(String label, bool checked, Function() onTap) {
    return CheckboxListTile(
      title: Text(label),
      value: checked,
      activeColor: redColor,
      controlAffinity: ListTileControlAffinity.trailing, // checkbox right la
      onChanged: (value) {
        onTap();
      },
    );
  }

  // ---------------- Checkbox list (Body, Variant, Fuel) ----------------
  Widget buildCheckPanel(String title, List<String> options,
      Set<String> ticked, Function(String) onToggle) {
    List<Widget> rows = [];

    for (final option in options) {
      bool isTicked = ticked.contains(option);

      rows.add(
        buildCheckRow(option, isTicked, () {
          onToggle(option); // example: toggleFuel('Diesel')
        }),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Expanded(child: ListView(children: rows)),
      ],
    );
  }

  // ---------------- Brand panel ----------------
  Widget buildBrandPanel(CarFilter draft, DraftFilterNotifier notifier) {
    List<Widget> groups = [];
    print(groups);

    for (final entry in brandModels.entries) {
      String brandName = entry.key; // 'Audi'
      List<String> models = entry.value; // Audi models list

      // Select All tick-a nu check (basket logic)
      bool allSelected = true;
      for (final model in models) {
        if (!draft.brands.contains(model)) {
          allSelected = false;
        }
      }

      // Audi kulla irukkra checkbox rows
      List<Widget> rows = [];
      rows.add(
        buildCheckRow('Select All', allSelected, () {
          notifier.toggleBrandGroup(models);
        }),
      );
      for (final model in models) {
        rows.add(
          buildCheckRow(model, draft.brands.contains(model), () {
            notifier.toggleBrand(model);
          }),
        );
      }

      groups.add(
        ExpansionTile(
          title: Text(brandName),
          children: rows,
        ),
      );
      print('Brand: $brandName');
      print('Models: $models');
      print('Rows count: ${rows.length}');
      print('Groups count: ${groups.length}');
      print('Groups: $groups');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Brands list', style: TextStyle(color: Colors.grey)),
        Expanded(child: ListView(children: groups)),
      ],
    );
  }

  // ---------------- Ratings panel ----------------
  Widget buildRatingPanel(CarFilter draft, DraftFilterNotifier notifier) {
    List<Widget> rows = [];

    for (final star in [5, 4, 3, 2, 1]) {
      bool isTicked = draft.ratings.contains(star);

      rows.add(
        CheckboxListTile(
          title: Row(
            children: [
              Text('$star'),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 16, color: Colors.amber),
            ],
          ),
          value: isTicked,
          activeColor: redColor,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            notifier.toggleRating(star);
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ratings', style: TextStyle(color: Colors.grey)),
        Expanded(child: ListView(children: rows)),
      ],
    );
  }

  // ---------------- Slider panel (Budget, Mileage, CC) ----------------
  Widget buildRangePanel(
      String title,
      RangeValues limit, // min-max limit
      RangeValues current, // ippo thumb irukkra edam
      Function(RangeValues) onChanged,
      String prefix, // '₹ '
      String suffix, // ' km'
      ) {
    String minText = '$prefix${current.start.round()}$suffix';
    String maxText = '$prefix${current.end.round()}$suffix';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),

        // mela: min value
        Center(child: Text(minText)),

        // naduvula: slider (90 degree thiruppi nettu)
        Expanded(
          child: Center(
            child: RotatedBox(
              quarterTurns: 1,
              child: RangeSlider(
                min: limit.start,
                max: limit.end,
                values: current,
                activeColor: redColor,
                onChanged: (newRange) {
                  onChanged(newRange); // example: setBudget(newRange)
                },
              ),
            ),
          ),
        ),

        // keezha: max value
        Center(child: Text(maxText)),
        const SizedBox(height: 12),
      ],
    );
  }
}