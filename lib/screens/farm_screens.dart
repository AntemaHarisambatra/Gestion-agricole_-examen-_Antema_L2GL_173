import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/farm_models.dart';
import '../providers/farm_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@ferme.com');
  final _passwordController = TextEditingController(text: 'admin123');

  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final provider = context.read<FarmProvider>();

    final success = await provider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Erreur de connexion')),
      );
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF81C784)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.agriculture_rounded,
                          size: 56,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Gestion agricole',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Connexion',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Saisir l’e-mail.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Saisir le mot de passe.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _isSubmitting ? null : _login,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.login),
                          label: Text(
                            _isSubmitting ? 'Connexion...' : 'Se connecter',
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Comptes de démonstration :\nadmin@ferme.com / admin123\nagriculteur@ferme.com / agri123',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FarmProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final stats = [
          _StatCard(
            title: 'Parcelles',
            value: '${provider.parcels.length}',
            icon: Icons.map_rounded,
            color: Colors.green,
          ),
          _StatCard(
            title: 'Cultures',
            value: '${provider.crops.length}',
            icon: Icons.grass_rounded,
            color: Colors.teal,
          ),
          _StatCard(
            title: 'Semences',
            value: '${provider.seeds.length}',
            icon: Icons.eco_rounded,
            color: Colors.lightGreen,
          ),
          _StatCard(
            title: 'Dépenses',
            value: '${provider.totalExpenses.toStringAsFixed(0)} €',
            icon: Icons.money_off_csred_rounded,
            color: Colors.orange,
          ),
          _StatCard(
            title: 'Récoltes',
            value: '${provider.totalHarvestedKg.toStringAsFixed(0)} kg',
            icon: Icons.park_rounded,
            color: Colors.deepPurple,
          ),
          _StatCard(
            title: 'Rendement',
            value: '${provider.averageYield.toStringAsFixed(1)} kg/ha',
            icon: Icons.trending_up_rounded,
            color: Colors.indigo,
          ),
        ];

        return DefaultTabController(
          length: 7,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Gestion agricole'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Text(
                      provider.currentUser?.role ?? 'Rôle',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Déconnexion',
                  onPressed: () {
                    provider.logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ],
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Parcelles'),
                  Tab(text: 'Cultures'),
                  Tab(text: 'Semences'),
                  Tab(text: 'Engrais'),
                  Tab(text: 'Récoltes'),
                  Tab(text: 'Dépenses'),
                  Tab(text: 'Rendements'),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(16),
                    childAspectRatio: 1.7,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: stats,
                  ),
                ),
                const SizedBox(
                  height: 420,
                  child: TabBarView(
                    children: [
                      ParcelScreen(),
                      CropScreen(),
                      SeedScreen(),
                      FertilizerScreen(),
                      HarvestScreen(),
                      ExpenseScreen(),
                      YieldScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withAlpha(32),
                  child: Icon(icon, color: color),
                ),
                const Spacer(),
                Text(value, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class ParcelScreen extends StatefulWidget {
  const ParcelScreen({super.key});

  @override
  State<ParcelScreen> createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, provider, _) {
        final filtered = provider.parcels.where((parcel) {
          final query = _searchController.text.trim().toLowerCase();
          if (query.isEmpty) return true;
          return parcel.name.toLowerCase().contains(query) ||
              parcel.location.toLowerCase().contains(query) ||
              parcel.cropType.toLowerCase().contains(query);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Rechercher une parcelle',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final parcel = filtered[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(parcel.name),
                      subtitle: Text(
                        '${parcel.surfaceHa} ha • ${parcel.location} • ${parcel.cropType}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openForm(context, parcel),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(context, parcel.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context, [Parcel? parcel]) async {
    final data = await showDialog<bool>(
      context: context,
      builder: (context) => _ParcelFormDialog(parcel: parcel),
    );
    if (data == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Parcelle enregistrée')));
    }
  }

  Future<void> _delete(BuildContext context, int id) async {
    final provider = context.read<FarmProvider>();
    await provider.deleteParcel(id);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Parcelle supprimée')));
    }
  }
}

class _ParcelFormDialog extends StatefulWidget {
  final Parcel? parcel;

  const _ParcelFormDialog({this.parcel});

  @override
  State<_ParcelFormDialog> createState() => _ParcelFormDialogState();
}

class _ParcelFormDialogState extends State<_ParcelFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _locationController = TextEditingController();
  final _cropController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final parcel = widget.parcel;
    if (parcel != null) {
      _nameController.text = parcel.name;
      _surfaceController.text = parcel.surfaceHa.toString();
      _locationController.text = parcel.location;
      _cropController.text = parcel.cropType;
      _notesController.text = parcel.notes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surfaceController.dispose();
    _locationController.dispose();
    _cropController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.parcel == null ? 'Nouvelle parcelle' : 'Modifier la parcelle',
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Champ requis'
                      : null,
                ),
                TextFormField(
                  controller: _surfaceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Surface (ha)'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Champ requis'
                      : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Localisation'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Champ requis'
                      : null,
                ),
                TextFormField(
                  controller: _cropController,
                  decoration: const InputDecoration(
                    labelText: 'Culture principale',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Champ requis'
                      : null,
                ),
                TextFormField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final provider = context.read<FarmProvider>();
            final item = Parcel(
              id: widget.parcel?.id,
              name: _nameController.text.trim(),
              surfaceHa: double.tryParse(_surfaceController.text) ?? 0,
              location: _locationController.text.trim(),
              cropType: _cropController.text.trim(),
              notes: _notesController.text.trim(),
            );
            if (widget.parcel == null) {
              await provider.createParcel(item);
            } else {
              await provider.updateParcel(item);
            }
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, provider, _) {
        final filtered = provider.crops.where((crop) {
          final q = _searchController.text.trim().toLowerCase();
          if (q.isEmpty) return true;
          return crop.name.toLowerCase().contains(q) ||
              crop.type.toLowerCase().contains(q) ||
              crop.season.toLowerCase().contains(q);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Rechercher une culture',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final crop = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text(crop.name),
                      subtitle: Text(
                        '${crop.type} • ${crop.season} • ${crop.areaHa} ha',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openForm(context, crop),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context
                                .read<FarmProvider>()
                                .deleteCrop(crop.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context, [Crop? crop]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _CropFormDialog(crop: crop),
    );
  }
}

class _CropFormDialog extends StatefulWidget {
  final Crop? crop;

  const _CropFormDialog({this.crop});

  @override
  State<_CropFormDialog> createState() => _CropFormDialogState();
}

class _CropFormDialogState extends State<_CropFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _seasonController = TextEditingController();
  final _areaController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final crop = widget.crop;
    if (crop != null) {
      _nameController.text = crop.name;
      _typeController.text = crop.type;
      _seasonController.text = crop.season;
      _areaController.text = crop.areaHa.toString();
      _notesController.text = crop.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.crop == null ? 'Nouvelle culture' : 'Modifier culture',
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _seasonController,
                  decoration: const InputDecoration(labelText: 'Saison'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _areaController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Surface (ha)'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final provider = context.read<FarmProvider>();
            final item = Crop(
              id: widget.crop?.id,
              name: _nameController.text.trim(),
              type: _typeController.text.trim(),
              season: _seasonController.text.trim(),
              areaHa: double.tryParse(_areaController.text) ?? 0,
              notes: _notesController.text.trim(),
            );
            if (widget.crop == null) {
              await provider.createCrop(item);
            } else {
              await provider.updateCrop(item);
            }
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Champ requis' : null;
}

class SeedScreen extends StatefulWidget {
  const SeedScreen({super.key});

  @override
  State<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<SeedScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, provider, _) {
        final filtered = provider.seeds.where((seed) {
          final q = _searchController.text.trim().toLowerCase();
          if (q.isEmpty) return true;
          return seed.name.toLowerCase().contains(q) ||
              seed.variety.toLowerCase().contains(q) ||
              seed.supplier.toLowerCase().contains(q);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Chercher une semence',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final seed = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text(seed.name),
                      subtitle: Text(
                        '${seed.variety} • ${seed.quantityKg} kg • ${seed.supplier}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openForm(context, seed),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context
                                .read<FarmProvider>()
                                .deleteSeed(seed.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context, [Seed? seed]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _SeedFormDialog(seed: seed),
    );
  }
}

class _SeedFormDialog extends StatefulWidget {
  final Seed? seed;

  const _SeedFormDialog({this.seed});

  @override
  State<_SeedFormDialog> createState() => _SeedFormDialogState();
}

class _SeedFormDialogState extends State<_SeedFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _quantityController = TextEditingController();
  final _supplierController = TextEditingController();
  bool _certified = false;

  @override
  void initState() {
    super.initState();
    if (widget.seed != null) {
      _nameController.text = widget.seed!.name;
      _varietyController.text = widget.seed!.variety;
      _quantityController.text = widget.seed!.quantityKg.toString();
      _supplierController.text = widget.seed!.supplier;
      _certified = widget.seed!.isCertified;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.seed == null ? 'Nouvelle semence' : 'Modifier semence',
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _varietyController,
                  decoration: const InputDecoration(labelText: 'Variété'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Quantité (kg)'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _supplierController,
                  decoration: const InputDecoration(labelText: 'Fournisseur'),
                  validator: _required,
                ),
                CheckboxListTile(
                  value: _certified,
                  onChanged: (v) => setState(() => _certified = v ?? false),
                  title: const Text('Semence certifiée'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final provider = context.read<FarmProvider>();
            final item = Seed(
              id: widget.seed?.id,
              name: _nameController.text.trim(),
              variety: _varietyController.text.trim(),
              quantityKg: double.tryParse(_quantityController.text) ?? 0,
              supplier: _supplierController.text.trim(),
              isCertified: _certified,
            );
            if (widget.seed == null) {
              await provider.createSeed(item);
            } else {
              await provider.updateSeed(item);
            }
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Champ requis' : null;
}

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, provider, _) {
        final filtered = provider.fertilizers.where((f) {
          final q = _searchController.text.trim().toLowerCase();
          if (q.isEmpty) return true;
          return f.name.toLowerCase().contains(q) ||
              f.type.toLowerCase().contains(q) ||
              f.supplier.toLowerCase().contains(q);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Chercher un engrais',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final item = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        '${item.type} • ${item.quantityKg} kg • ${item.unitCost} €/kg',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openForm(context, item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context
                                .read<FarmProvider>()
                                .deleteFertilizer(item.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context, [Fertilizer? item]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _FertilizerFormDialog(item: item),
    );
  }
}

class _FertilizerFormDialog extends StatefulWidget {
  final Fertilizer? item;

  const _FertilizerFormDialog({this.item});

  @override
  State<_FertilizerFormDialog> createState() => _FertilizerFormDialogState();
}

class _FertilizerFormDialogState extends State<_FertilizerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitCostController = TextEditingController();
  final _supplierController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _typeController.text = widget.item!.type;
      _quantityController.text = widget.item!.quantityKg.toString();
      _unitCostController.text = widget.item!.unitCost.toString();
      _supplierController.text = widget.item!.supplier;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Nouvel engrais' : 'Modifier engrais'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Quantité (kg)'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _unitCostController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Coût unitaire (€)',
                  ),
                  validator: _required,
                ),
                TextFormField(
                  controller: _supplierController,
                  decoration: const InputDecoration(labelText: 'Fournisseur'),
                  validator: _required,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final provider = context.read<FarmProvider>();
            final item = Fertilizer(
              id: widget.item?.id,
              name: _nameController.text.trim(),
              type: _typeController.text.trim(),
              quantityKg: double.tryParse(_quantityController.text) ?? 0,
              unitCost: double.tryParse(_unitCostController.text) ?? 0,
              supplier: _supplierController.text.trim(),
            );
            if (widget.item == null) {
              await provider.createFertilizer(item);
            } else {
              await provider.updateFertilizer(item);
            }
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Champ requis' : null;
}

class HarvestScreen extends StatefulWidget {
  const HarvestScreen({super.key});

  @override
  State<HarvestScreen> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends State<HarvestScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, provider, _) {
        final filtered = provider.harvests.where((item) {
          final q = _searchController.text.trim().toLowerCase();
          if (q.isEmpty) return true;
          return item.cropName.toLowerCase().contains(q) ||
              item.parcelName.toLowerCase().contains(q);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Chercher une récolte',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final item = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text('${item.cropName} - ${item.parcelName}'),
                      subtitle: Text(
                        '${item.quantityKg} kg • ${DateFormat('dd/MM/yyyy').format(item.harvestDate)} • ${item.moisture}%',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openForm(context, item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context
                                .read<FarmProvider>()
                                .deleteHarvest(item.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context, [Harvest? item]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _HarvestFormDialog(item: item),
    );
  }
}

class _HarvestFormDialog extends StatefulWidget {
  final Harvest? item;

  const _HarvestFormDialog({this.item});

  @override
  State<_HarvestFormDialog> createState() => _HarvestFormDialogState();
}

class _HarvestFormDialogState extends State<_HarvestFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cropController = TextEditingController();
  final _parcelController = TextEditingController();
  final _quantityController = TextEditingController();
  final _moistureController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _cropController.text = widget.item!.cropName;
      _parcelController.text = widget.item!.parcelName;
      _quantityController.text = widget.item!.quantityKg.toString();
      _moistureController.text = widget.item!.moisture.toString();
      _notesController.text = widget.item!.notes;
      _selectedDate = widget.item!.harvestDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.item == null ? 'Nouvelle récolte' : 'Modifier récolte',
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _cropController,
                  decoration: const InputDecoration(labelText: 'Culture'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _parcelController,
                  decoration: const InputDecoration(labelText: 'Parcelle'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Quantité (kg)'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _moistureController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Humidité (%)'),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date : ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) setState(() => _selectedDate = date);
                      },
                      child: const Text('Choisir'),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final provider = context.read<FarmProvider>();
            final item = Harvest(
              id: widget.item?.id,
              cropName: _cropController.text.trim(),
              parcelName: _parcelController.text.trim(),
              quantityKg: double.tryParse(_quantityController.text) ?? 0,
              harvestDate: _selectedDate,
              moisture: double.tryParse(_moistureController.text) ?? 0,
              notes: _notesController.text.trim(),
            );
            if (widget.item == null) {
              await provider.createHarvest(item);
            } else {
              await provider.updateHarvest(item);
            }
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Champ requis' : null;
}

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, provider, _) {
        final filtered = provider.expenses.where((item) {
          final q = _searchController.text.trim().toLowerCase();
          if (q.isEmpty) return true;
          return item.label.toLowerCase().contains(q) ||
              item.category.toLowerCase().contains(q);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Chercher une dépense',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final item = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.label),
                      subtitle: Text(
                        '${item.category} • ${DateFormat('dd/MM/yyyy').format(item.expenseDate)}',
                      ),
                      trailing: Text('${item.amount.toStringAsFixed(2)} €'),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context, [Expense? item]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _ExpenseFormDialog(item: item),
    );
  }
}

class _ExpenseFormDialog extends StatefulWidget {
  final Expense? item;

  const _ExpenseFormDialog({this.item});

  @override
  State<_ExpenseFormDialog> createState() => _ExpenseFormDialogState();
}

class _ExpenseFormDialogState extends State<_ExpenseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _labelController.text = widget.item!.label;
      _categoryController.text = widget.item!.category;
      _amountController.text = widget.item!.amount.toString();
      _descriptionController.text = widget.item!.description;
      _selectedDate = widget.item!.expenseDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.item == null ? 'Nouvelle dépense' : 'Modifier dépense',
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _labelController,
                  decoration: const InputDecoration(labelText: 'Libellé'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Montant (€)'),
                  validator: _required,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date : ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) setState(() => _selectedDate = date);
                      },
                      child: const Text('Choisir'),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final provider = context.read<FarmProvider>();
            final item = Expense(
              id: widget.item?.id,
              label: _labelController.text.trim(),
              category: _categoryController.text.trim(),
              amount: double.tryParse(_amountController.text) ?? 0,
              expenseDate: _selectedDate,
              description: _descriptionController.text.trim(),
            );
            if (widget.item == null) {
              await provider.createExpense(item);
            } else {
              await provider.updateExpense(item);
            }
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Champ requis' : null;
}

class YieldScreen extends StatefulWidget {
  const YieldScreen({super.key});

  @override
  State<YieldScreen> createState() => _YieldScreenState();
}

class _YieldScreenState extends State<YieldScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmProvider>(
      builder: (context, provider, _) {
        final filtered = provider.yieldRecords.where((item) {
          final q = _searchController.text.trim().toLowerCase();
          if (q.isEmpty) return true;
          return item.cropName.toLowerCase().contains(q) ||
              item.parcelName.toLowerCase().contains(q);
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Chercher un rendement',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final item = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text('${item.cropName} – ${item.parcelName}'),
                      subtitle: Text(
                        'Rendement : ${item.yieldKg} kg • Productivité : ${item.productivity} kg/ha',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openForm(context, item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context
                                .read<FarmProvider>()
                                .deleteYieldRecord(item.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openForm(BuildContext context, [YieldRecord? item]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _YieldFormDialog(item: item),
    );
  }
}

class _YieldFormDialog extends StatefulWidget {
  final YieldRecord? item;

  const _YieldFormDialog({this.item});

  @override
  State<_YieldFormDialog> createState() => _YieldFormDialogState();
}

class _YieldFormDialogState extends State<_YieldFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _parcelController = TextEditingController();
  final _cropController = TextEditingController();
  final _yieldController = TextEditingController();
  final _productivityController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _parcelController.text = widget.item!.parcelName;
      _cropController.text = widget.item!.cropName;
      _yieldController.text = widget.item!.yieldKg.toString();
      _productivityController.text = widget.item!.productivity.toString();
      _notesController.text = widget.item!.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.item == null ? 'Nouveau rendement' : 'Modifier rendement',
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _parcelController,
                  decoration: const InputDecoration(labelText: 'Parcelle'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _cropController,
                  decoration: const InputDecoration(labelText: 'Culture'),
                  validator: _required,
                ),
                TextFormField(
                  controller: _yieldController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Rendement total (kg)',
                  ),
                  validator: _required,
                ),
                TextFormField(
                  controller: _productivityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Productivité (kg/ha)',
                  ),
                  validator: _required,
                ),
                TextFormField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final provider = context.read<FarmProvider>();
            final item = YieldRecord(
              id: widget.item?.id,
              parcelName: _parcelController.text.trim(),
              cropName: _cropController.text.trim(),
              yieldKg: double.tryParse(_yieldController.text) ?? 0,
              productivity: double.tryParse(_productivityController.text) ?? 0,
              notes: _notesController.text.trim(),
            );
            if (widget.item == null) {
              await provider.createYieldRecord(item);
            } else {
              await provider.updateYieldRecord(item);
            }
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Champ requis' : null;
}
