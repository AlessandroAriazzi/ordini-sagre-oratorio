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
            width: isExpanded ? 260 : 68,
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.navbarBackground,
                border: Border(
                  right: BorderSide(color: Color(0xFF1E293B), width: 1),
                ),
              ),
              child: Column(
                children: [
                  // Header / Brand
                  SizedBox(
                    height: 72,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.restaurant_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          if (isExpanded) ...[
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Festa Ordini',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  Text(
                                    'Gestionale',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const Divider(color: Color(0xFF1E293B), height: 1),

                  // Navigation Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                              widget.currentPath.startsWith('/serata/') ||
                              widget.currentPath.startsWith('/ordine/') ||
                              widget.currentPath.startsWith('/resoconto/'),
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

                  const Divider(color: Color(0xFF1E293B), height: 1),

                  // Settings nav item (bottom)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _NavItem(
                      icon: Icons.settings_rounded,
                      label: 'Impostazioni',
                      isSelected: widget.currentPath == '/settings',
                      isExpanded: isExpanded,
                      onTap: () => context.go('/settings'),
                    ),
                  ),

                  const Divider(color: Color(0xFF1E293B), height: 1),

                  // Toggle Button
                  InkWell(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: SizedBox(
                      height: 52,
                      child: Row(
                        mainAxisAlignment: isExpanded
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: isExpanded ? 16 : 0,
                            ),
                            child: Icon(
                              isExpanded
                                  ? Icons.chevron_left_rounded
                                  : Icons.chevron_right_rounded,
                              color: const Color(0xFF64748B),
                              size: 20,
                            ),
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
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              // Left indicator bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 3,
                height: widget.isSelected ? 44 : 0,
                decoration: const BoxDecoration(
                  color: AppTheme.navbarSelected,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
              ),
              // Item content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? AppTheme.navbarSelected.withValues(alpha: 0.12)
                        : isHovered
                            ? const Color(0xFF1E293B)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        widget.icon,
                        color: widget.isSelected
                            ? AppTheme.navbarSelected
                            : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      if (widget.isExpanded) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.label,
                            style: TextStyle(
                              color: widget.isSelected
                                  ? Colors.white
                                  : const Color(0xFF94A3B8),
                              fontSize: 14,
                              fontWeight: widget.isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ],
                    ],
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
