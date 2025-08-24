import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _TopNav(),
      drawer: const _MobileDrawer(), // shows on small screens
      body: const _HomeBody(),
      bottomNavigationBar: const _Footer(),
    );
  }
}

class _TopNav extends StatelessWidget implements PreferredSizeWidget {
  const _TopNav();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return AppBar(
      toolbarHeight: 64,
      titleSpacing: 16,
      title: Row(
        children: [
          // Logo
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/potbot_logo-512x512.png',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'PotBot',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          const Spacer(),
          if (isWide) ...[
            _NavLink(label: 'Home', onTap: () => _go(context, '/')),
            _NavLink(label: 'Bud Bot', onTap: () => _go(context, '/scan')),
            _NavLink(label: 'Grower Mode', onTap: () => _go(context, '/grower')),
            _NavLink(label: 'Pro Mode', onTap: () => _showSoon(context)),
          ],
        ],
      ),
    );
  }

  static void _go(BuildContext ctx, String route) {
    if (ModalRoute.of(ctx)?.settings.name == route) return;
    Navigator.of(ctx).pushNamed(route);
  }

  static void _showSoon(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(content: Text('Pro Mode is coming soon!')),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(label, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    if (isWide) return const SizedBox.shrink();

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => _go(context, '/'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Bud Bot'),
              onTap: () => _go(context, '/scan'),
            ),
            ListTile(
              leading: const Icon(Icons.eco_outlined),
              title: const Text('Grower Mode'),
              onTap: () => _go(context, '/grower'),
            ),
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Pro Mode'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pro Mode is coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext ctx, String route) {
    Navigator.pop(ctx);
    if (ModalRoute.of(ctx)?.settings.name == route) return;
    Navigator.of(ctx).pushNamed(route);
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 64 : 20,
          vertical: isWide ? 40 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        isWide ? CrossAxisAlignment.start : CrossAlignment.center,
                    children: [
                      Text(
                        'Scan Your Bud.\nKnow Your Quality.',
                        textAlign: isWide ? TextAlign.left : TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'PotBot uses AI to analyze trichomes, structure and color — then gives you a clean quality score with tips.',
                        textAlign: isWide ? TextAlign.left : TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment:
                            isWide ? WrapAlignment.start : WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(context, '/scan'),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Scan bud'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/grower'),
                            icon: const Icon(Icons.eco_outlined),
                            label: const Text('Grower mode'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isWide) const SizedBox(width: 40),
                if (isWide)
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/potbot_logo-512x512.png',
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 40),

            // Features
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                _FeatureCard(
                  icon: Icons.analytics_outlined,
                  title: 'AI Quality Score',
                  desc:
                      'Fast analysis of structure, color and trichomes to estimate quality.',
                ),
                _FeatureCard(
                  icon: Icons.eco_outlined,
                  title: 'Grower Mode',
                  desc:
                      'Upload plant photos and get care tips, stress detection and stage notes.',
                ),
                _FeatureCard(
                  icon: Icons.leaderboard_outlined,
                  title: 'Leaderboard',
                  desc:
                      'Share your scans and see how your buds stack up against the community.',
                ),
              ],
            ),

            const SizedBox(height: 40),

            // CTA
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ready to rate your stash?',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No signup required. Works on mobile and desktop.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/scan'),
                      icon: const Icon(Icons.camera_enhance_outlined),
                      label: const Text('Start Scanning'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 260),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 10),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              desc,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0E12),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('© 2025 PotBot. All rights reserved.',
              style: TextStyle(color: Colors.white70)),
          _FooterLink(label: 'Privacy Policy', onTap: () {}),
          _FooterLink(label: 'Terms of Service', onTap: () {}),
          _FooterLink(label: 'Security', onTap: () {}),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child:
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
    );
  }
}
