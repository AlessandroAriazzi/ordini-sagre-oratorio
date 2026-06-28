---
name: Nexus Terminal
colors:
  surface: '#f7f9fb'
  surface-dim: '#d8dadc'
  surface-bright: '#f7f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f6'
  surface-container: '#eceef0'
  surface-container-high: '#e6e8ea'
  surface-container-highest: '#e0e3e5'
  on-surface: '#191c1e'
  on-surface-variant: '#45464d'
  inverse-surface: '#2d3133'
  inverse-on-surface: '#eff1f3'
  outline: '#76777d'
  outline-variant: '#c6c6cd'
  surface-tint: '#565e74'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#131b2e'
  on-primary-container: '#7c839b'
  inverse-primary: '#bec6e0'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#0b1c30'
  on-tertiary-container: '#75859d'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae2fd'
  primary-fixed-dim: '#bec6e0'
  on-primary-fixed: '#131b2e'
  on-primary-fixed-variant: '#3f465c'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#d3e4fe'
  tertiary-fixed-dim: '#b7c8e1'
  on-tertiary-fixed: '#0b1c30'
  on-tertiary-fixed-variant: '#38485d'
  background: '#f7f9fb'
  on-background: '#191c1e'
  surface-variant: '#e0e3e5'
typography:
  display-price:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-mono:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  button-text:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 4px
  sidebar-width: 280px
  gutter: 16px
  margin-page: 24px
  touch-target-min: 48px
---

## Brand & Style

This design system is engineered for high-stakes, fast-paced food service environments. The brand personality is rooted in **Reliability, Precision, and Velocity**. It targets professional operators who require a tool that feels less like a website and more like a high-performance instrument.

The aesthetic follows a **Corporate / Modern** direction with a focus on functional density. It prioritizes clarity over decoration, using a structured layout and high-contrast elements to minimize cognitive load during peak hours. The visual language utilizes subtle depth to separate global navigation from the active workspace, ensuring the user's focus remains on transaction processing.

## Colors

The palette is designed for maximum legibility under varying restaurant lighting conditions.

*   **Primary (Deep Navy):** Used for structural elements, sidebars, and primary headers to establish authority and trust.
*   **Secondary (Emerald Green):** Reserved exclusively for "Success" states, "Pay" actions, and order confirmations. It serves as a high-visibility psychological trigger for completed tasks.
*   **Tertiary (Slate):** Utilized for secondary actions, iconography, and supporting text to provide hierarchy without distraction.
*   **Backgrounds:** A tiered system of light grays (`#F8FAFC` to `#F1F5F9`) distinguishes the sidebar from the main canvas and item grids.

## Typography

The typography system uses **Inter** for all interface elements to ensure maximum readability and a clean, neutral tone. For data-heavy contexts like receipt numbers, inventory counts, and SKU codes, **JetBrains Mono** is employed to provide clear character distinction and vertical alignment in tables.

Large-scale prices utilize the `display-price` role with tight tracking and heavy weights to ensure the total amount is the most visible element on the screen. All interactive labels use a medium weight to maintain visibility against colored backgrounds.

## Layout & Spacing

The layout utilizes a **Fixed Sidebar** model with a **Fluid Grid** workspace. This design system treats the screen as a workspace rather than a document.

*   **Sidebar:** Positioned on the left at a fixed 280px, housing global navigation and terminal status.
*   **Workspace:** A flexible area that adapts to the screen width, containing a multi-column grid for food items.
*   **The 8px Grid:** All margins and paddings must be multiples of 4px, with 8px and 16px being the standard increments for component spacing.
*   **Touch Optimization:** Despite being a desktop application, all primary interaction zones (item selection, payment) must respect a 48px minimum touch target for hybrid touch-monitor environments.

## Elevation & Depth

Visual hierarchy is established through **Tonal Layers** and crisp **Low-Contrast Outlines**. 

*   **Level 0 (Background):** Slate-50 `#F8FAFC`.
*   **Level 1 (Cards/Panels):** Pure white with a 1px border in Slate-200. No shadows are used for static containers to maintain a clean, "flat" professional feel.
*   **Level 2 (Interactive/Floating):** For modals and dropdowns, a subtle, 8% opacity navy shadow with a 12px blur is used to denote temporary elevation above the workspace.
*   **Active State:** Elements being interacted with use a 2px Primary Blue border rather than a shadow to indicate focus.

## Shapes

The design system uses a **Soft** shape language. This provides a professional, "software-tool" aesthetic that feels modern but remains grounded. 

*   **Standard Components:** 0.25rem (4px) border radius for buttons and input fields.
*   **Containers:** 0.5rem (8px) for cards, food item tiles, and modal windows.
*   **Visual Indicators:** Status dots and notification badges remain fully circular.

## Components

### Buttons
*   **Action Buttons:** Large height (56px) with bold text. Primary buttons use the Primary Navy; "Pay" buttons use the Secondary Emerald.
*   **Item Tiles:** Large squares (minimum 120x120px) with a Level 1 container style. Text is bottom-aligned, bold, and high-contrast.

### Data Tables & Lists
*   **Inventory Tables:** No vertical borders. Horizontal borders in Slate-100. Header row in Slate-50 with `label-mono` typography.
*   **Cart List:** Structured with high-density rows. Quantity controls are persistent and large enough for rapid adjustment.

### Input Fields
*   **Search/Text:** Inset 1px border. Focus state switches to a 2px Primary Navy border. 
*   **Keypads:** Integrated numeric inputs for custom prices or quantities, using large, flat keys with clear hit states.

### Navigation Sidebar
*   Vertical orientation with icons on the left. Active state indicated by a 4px vertical bar on the left edge and a subtle tonal shift to the background.

### Status Indicators
*   Used for printer connectivity, internet status, and kitchen sync. Represented by a small circle icon with a corresponding label in `label-mono`.