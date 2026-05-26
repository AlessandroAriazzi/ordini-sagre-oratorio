import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';


class MainLayout extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isExpanded ? 280 : 80,
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.navbarBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        if (isExpanded) ...[
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Festa Ordini',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Gestionale',
                                  style: TextStyle(
                                    color: AppTheme.textLight,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const Divider(color: AppTheme.navbarHover, height: 1),
                  
                  // Navigation Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: [
                        _NavItem(
                          icon: Icons.home_rounded,
                          label: 'Home',
                          isSelected: widget.currentPath == '/',
                          isExpanded: isExpanded,
                          onTap: () => context.go('/'),
                        ),
                        _NavItem(
                          icon: Icons.event_rounded,
                          label: 'Serate',
                          isSelected: widget.currentPath.startsWith('/serate') ||
                              widget.currentPath.startsWith('/serata/'),
                          isExpanded: isExpanded,
                          onTap: () => context.go('/serate'),
                        ),
                        _NavItem(
                          icon: Icons.restaurant_menu_rounded,
                          label: 'Menù',
                          isSelected: widget.currentPath.startsWith('/menu'),
                          isExpanded: isExpanded,
                          onTap: () => context.go('/menu/new'),
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(color: AppTheme.navbarHover, height: 1),

                  // Settings Item
                  _NavItem(
                    icon: Icons.settings_rounded,
                    label: 'Impostazioni',
                    isSelected: widget.currentPath == '/settings',
                    isExpanded: isExpanded,
                    onTap: () => context.go('/settings'),
                  ),

                  const Divider(color: AppTheme.navbarHover, height: 1),
                  
                  // Toggle Button
                  InkWell(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: isExpanded 
                            ? MainAxisAlignment.end 
                            : MainAxisAlignment.center,
                        children: [
                          Icon(
                            isExpanded 
                                ? Icons.chevron_left_rounded 
                                : Icons.chevron_right_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Main Content
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppTheme.navbarSelected
                  : isHovered
                      ? AppTheme.navbarHover
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 24,
                ),
                if (widget.isExpanded) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}