import 'package:material_ui/material_ui.dart';
import 'package:movie_match/models/country.dart';
import 'package:movie_match/widgets/pill.dart';
import '../../l10n/app_localizations.dart';

class MediaCountryFilter extends StatelessWidget {
  const MediaCountryFilter({
    required this.countries,
    required this.selectedCountry,
    required this.onChanged,
    super.key,
  });

  final List<Country> countries;
  final String? selectedCountry;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => Pill(
    onTap: () => _showCountries(context),
    borderRadius: .circular(20),
    padding: const .symmetric(horizontal: 12, vertical: 4),
    child: Text(
      selectedCountry == null
          ? AppLocalizations.of(context)!.filter_country
          : countries
                .firstWhere((country) => country.code == selectedCountry)
                .nativeName,
      style: Theme.of(context).textTheme.bodyLarge,
    ),
  );

  void _showCountries(BuildContext context) {
    String? selected = selectedCountry;

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const .all(16),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.filter_choose_country,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => selected = null);
                      },
                      child: Text(AppLocalizations.of(context)!.filter_reset),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: RadioGroup<String>(
                  groupValue: selected,
                  onChanged: (value) {
                    setState(() {
                      selected = value;
                    });
                  },
                  child: ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];

                      return RadioListTile<String>(
                        title: Text(country.nativeName),
                        value: country.code,
                      );
                    },
                  ),
                ),
              ),

              Padding(
                padding: const .all(16),
                child: SizedBox(
                  width: .infinity,
                  child: FilledButton(
                    onPressed: () {
                      onChanged(selected);
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.filter_apply),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
