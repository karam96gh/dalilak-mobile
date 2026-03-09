import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_providers.dart';

class OnboardingPage {
  final int index;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  OnboardingPage({
    required this.index,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      index: 0,
      title: 'مرحباً بـ دليلك',
      description: 'اكتشف أفضل المتاجر والخدمات حول بك',
      icon: Icons.location_on,
      iconColor: Colors.green,
    ),
    OnboardingPage(
      index: 1,
      title: 'تصفح التصنيفات',
      description: 'اختر من بين آلاف التصنيفات المختلفة',
      icon: Icons.category,
      iconColor: Colors.blue,
    ),
    OnboardingPage(
      index: 2,
      title: 'ابحث بسهولة',
      description: 'ابحث بسرعة عن ما تحتاجه',
      icon: Icons.search,
      iconColor: Colors.orange,
    ),
    OnboardingPage(
      index: 3,
      title: 'تواصل مباشرة',
      description: 'اتصل برقم الهاتف أو واتس مباشرة',
      icon: Icons.phone,
      iconColor: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding(BuildContext context, WidgetRef ref) async {
    // Mark as first run completed
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool('first_run', false);
    
    // Navigate to home
    if (context.mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final page = pages[index];
              return OnboardingPageWidget(page: page);
            },
          ),
          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () => _skipOnboarding(context, ref),
              child: Text(
                'تخطي',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          // Bottom navigation
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page indicator
                Row(
                  children: List.generate(
                    pages.length,
                    (index) => Container(
                      width: _currentPage == index ? 30 : 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _currentPage == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                ),
                // Next/Finish button
                ElevatedButton.icon(
                  onPressed: _currentPage == pages.length - 1
                      ? () => _skipOnboarding(context, ref)
                      : _nextPage,
                  icon: Icon(
                    _currentPage == pages.length - 1
                        ? Icons.check
                        : Icons.arrow_forward,
                  ),
                  label: Text(
                    _currentPage == pages.length - 1 ? 'ابدأ' : 'التالي',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            page.iconColor.withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.icon,
            size: 120,
            color: page.iconColor,
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              page.description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
