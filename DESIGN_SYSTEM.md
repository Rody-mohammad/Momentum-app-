# Momentum Design System
## Inspired by Linear

Version: 1.0  
Created: July 2026  
Inspiration: Linear Design System

---

## Design Philosophy

Momentum's design system is built on the principles of **precision engineering** and **dark-mode-native minimalism**. Like Linear, we treat the interface as a tool that should disappear during use—every element exists to serve the user's habit-tracking goals, not to call attention to itself.

**Core Principles:**

1. **Dark-Mode Native**: The dark canvas is the default, not a theme toggle. Light mode exists as an accessibility option, but the design is conceived for darkness first.

2. **Content-First, Chrome-Second**: Habits, streaks, and progress are the heroes. UI elements (borders, shadows, decorations) are whisper-thin and purposeful.

3. **Precision Through Restraint**: Every pixel is intentional. We use limited color palettes, controlled typography scales, and measured spacing to create a sense of engineering precision.

4. **Depth Through Luminance**: On dark surfaces, traditional shadows are invisible. We use background luminance stepping and semi-transparent borders to communicate elevation.

5. **Single Accent for Hierarchy**: Momentum Purple is the only chromatic color in the core UI. It guides the eye to CTAs, active states, and progress indicators without competing with content.

---

## 1. Colors

### Decision Rationale

Linear's color system is built on near-black backgrounds with white text and a single indigo accent. For Momentum, we adapt this by:

- Keeping the dark-mode-native canvas approach
- Replacing Linear's indigo with a purple that aligns with habit tracking's gamification aspect
- Adding semantic colors for success (completion), warning (streak at risk), and error (missed habits)
- Using semi-transparent white borders instead of solid dark borders

### Color Palette

#### Background Surfaces

| Token | Hex | Usage | Rationale |
|-------|-----|-------|-----------|
| `canvas` | `#08090a` | Deepest background, hero sections | Near-pure black with imperceptible blue-cool undertone. Creates the "darkness as space" foundation. |
| `panel` | `#0f1011` | Sidebar, bottom navigation, card backgrounds | One step up from canvas. Provides subtle separation without visible borders. |
| `surface` | `#191a1b` | Elevated cards, dialogs, dropdowns | Two steps up from canvas. Used for elements that need to "float" above content. |
| `surfaceHighlight` | `#28282c` | Hover states, slightly elevated components | Lightest dark surface. Creates interactive feedback through luminance change. |

#### Text & Content

| Token | Hex | Usage | Rationale |
|-------|-----|-------|-----------|
| `textPrimary` | `#f7f8f8` | Headlines, primary labels, habit names | Near-white with barely-warm cast. Prevents eye strain on dark backgrounds while maintaining high contrast. |
| `textSecondary` | `#d0d6e0` | Body text, descriptions, secondary labels | Cool silver-gray. Lower contrast than primary, creating natural hierarchy. |
| `textTertiary` | `#8a8f98` | Captions, metadata, timestamps | Muted gray. For de-emphasized content that shouldn't compete for attention. |
| `textQuaternary` | `#62666d` | Disabled states, subtle labels | Most subdued text. Used when content should be present but not prominent. |

#### Brand & Accent

| Token | Hex | Usage | Rationale |
|-------|-----|-------|-----------|
| `accentPrimary` | `#7c3aed` | Primary CTA backgrounds, active states | Momentum Purple. Vibrant violet-purple that feels gamified and premium. |
| `accentSecondary` | `#8b5cf6` | Interactive accents, hover states | Lighter variant. Creates hover feedback while maintaining brand identity. |
| `accentHover` | `#a78bfa` | Bright hover state on accent elements | Further lightened for clear interactive feedback. |
| `accentSubtle` | `rgba(124, 58, 237, 0.15)` | Tinted backgrounds, badges | Low-opacity purple for subtle brand presence without overwhelming. |

#### Semantic Colors

| Token | Hex | Usage | Rationale |
|-------|-----|-------|-----------|
| `success` | `#10b981` | Completion indicators, success states | Emerald green. Universally positive, high contrast on dark backgrounds. |
| `successSubtle` | `rgba(16, 185, 129, 0.15)` | Success backgrounds, completion badges | Low-opacity variant for backgrounds. |
| `warning` | `#f59e0b` | Streak at risk, caution states | Amber. Attention-grabbing but not alarming. |
| `warningSubtle` | `rgba(245, 158, 11, 0.15)` | Warning backgrounds | Low-opacity amber for subtle warnings. |
| `error` | `#ef4444` | Missed habits, error states | Red. Universally understood as negative/alert. |
| `errorSubtle` | `rgba(239, 68, 68, 0.15)` | Error backgrounds | Low-opacity red for error contexts. |

#### Border & Divider

| Token | Value | Usage | Rationale |
|-------|-------|-------|-----------|
| `borderSubtle` | `rgba(255, 255, 255, 0.05)` | Default borders, card outlines | Ultra-subtle semi-transparent white. Creates structure without visual noise. |
| `borderStandard` | `rgba(255, 255, 255, 0.08)` | Standard borders, inputs | Slightly more visible. Used for interactive elements. |
| `borderStrong` | `rgba(255, 255, 255, 0.12)` | Focus states, active borders | More visible for interactive feedback. |
| `divider` | `#141516` | Section dividers, list separators | Nearly invisible line. Separates without drawing attention. |

#### Overlay

| Token | Value | Usage | Rationale |
|-------|-------|-------|-----------|
| `overlay` | `rgba(0, 0, 0, 0.85)` | Modal/dialog backdrop | Extremely dark for focus isolation. Higher opacity than typical overlays to ensure content readability. |

---

## 2. Typography

### Decision Rationale

Linear uses Inter Variable with specific OpenType features (cv01, ss03) and a signature weight of 510. For Momentum:

- We use Inter (available in Google Fonts) as the primary font family
- We implement the negative letter-spacing pattern at display sizes
- We use a three-weight system (400, 500, 600) for clear hierarchy
- We add tabular numerals for streak counts and statistics
- We maintain tight line heights for headlines and relaxed heights for body text

### Font Family

**Primary:** `Inter`  
**Fallback:** `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue'`

**Monospace:** `JetBrains Mono`  
**Fallback:** `ui-monospace, SF Mono, Menlo, Monaco, 'Courier New'`

### Typography Scale

| Role | Size | Weight | Line Height | Letter Spacing | Usage |
|------|------|--------|-------------|----------------|-------|
| `displayHero` | 56px | 600 | 1.00 | -1.4px | Hero headlines, maximum impact |
| `displayLarge` | 48px | 600 | 1.00 | -1.2px | Secondary hero text |
| `display` | 40px | 600 | 1.00 | -1.0px | Section headlines |
| `heading1` | 32px | 500 | 1.13 | -0.7px | Major section titles |
| `heading2` | 24px | 500 | 1.33 | -0.3px | Sub-section headings |
| `heading3` | 20px | 600 | 1.33 | -0.2px | Feature titles, card headers |
| `bodyLarge` | 18px | 400 | 1.60 | -0.15px | Introduction text, feature descriptions |
| `body` | 16px | 400 | 1.50 | normal | Standard reading text |
| `bodyMedium` | 16px | 500 | 1.50 | normal | Navigation, labels |
| `bodySemibold` | 16px | 600 | 1.50 | normal | Strong emphasis |
| `small` | 14px | 400 | 1.50 | -0.15px | Secondary body text |
| `smallMedium` | 14px | 500 | 1.50 | -0.15px | Emphasized small text |
| `caption` | 13px | 500 | 1.50 | -0.15px | Sub-labels, category headers |
| `label` | 12px | 500 | 1.40 | normal | Button text, small labels |
| `micro` | 11px | 500 | 1.40 | normal | Tiny labels |
| `monoBody` | 14px | 400 | 1.50 | normal | Code blocks, streak counts |
| `monoCaption` | 12px | 400 | 1.50 | normal | Code labels, statistics |

### Typography Principles

**1. Compression at Scale**
Display sizes use progressively tighter letter-spacing: -1.4px at 56px, -1.2px at 48px, -1.0px at 40px. This creates dense, authoritative headlines that feel engineered.

**2. Three-Weight Hierarchy**
- **400 (Regular)**: Reading text, descriptions
- **500 (Medium)**: UI elements, navigation, emphasis
- **600 (Semibold)**: Headlines, strong labels

This narrow range creates hierarchy through size and spacing rather than weight variation.

**3. Line Height Strategy**
- Headlines: 1.00-1.13 (tight, impactful)
- Body: 1.50-1.60 (relaxed, readable)
- Captions: 1.40-1.50 (compact but legible)

**4. Tabular Numerals**
Use monospace font or tabular numeral feature for streak counts, momentum scores, and statistics to ensure vertical alignment in lists and grids.

---

## 3. Spacing

### Decision Rationale

Linear uses an 8px base unit with micro-adjustments (7px, 11px) for optical alignment. Momentum adopts this with simplification:

- 8px base unit for consistency
- 4px scale for micro-spacing
- 16px, 24px, 32px for component spacing
- 48px, 64px, 80px for section spacing
- No fractional values for Flutter implementation simplicity

### Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| `space0` | 0px | No spacing |
| `space1` | 4px | Micro-spacing, icon gaps |
| `space2` | 8px | Base unit, small component padding |
| `space3` | 12px | Small component padding, list item spacing |
| `space4` | 16px | Standard component padding |
| `space5` | 20px | Medium component padding |
| `space6` | 24px | Large component padding |
| `space8` | 32px | Section spacing |
| `space10` | 40px | Large section spacing |
| `space12` | 48px | Major section spacing |
| `space16` | 64px | Hero section spacing |
| `space20` | 80px | Maximum section spacing |

### Spacing Guidelines

**Component Internal Padding:**
- Small components (buttons, inputs): 8-12px
- Medium components (cards, list items): 16-20px
- Large components (dialogs, panels): 20-24px

**Component External Spacing:**
- Related components: 8-12px
- Unrelated components: 16-24px
- Section breaks: 32-48px
- Major sections: 64-80px

**Grid Gutter:**
- Mobile: 12px
- Tablet: 16px
- Desktop: 24px

---

## 4. Border Radius

### Decision Rationale

Linear uses a precise radius scale from 2px to 22px plus pill and circle variants. Momentum adapts this for Flutter's rounded rectangle system:

- Micro radii (2-4px) for subtle elements
- Standard radii (6-8px) for interactive elements
- Large radii (12-16px) for cards and panels
- Pill (9999px) for badges and tags
- Circle (50%) for avatars and icon buttons

### Radius Scale

| Token | Value | Usage |
|-------|-------|-------|
| `radiusNone` | 0px | Sharp corners (rare) |
| `radiusMicro` | 2px | Inline badges, tiny tags |
| `radiusSmall` | 4px | Small containers, list items |
| `radiusMedium` | 6px | Buttons, inputs, functional elements |
| `radiusStandard` | 8px | Cards, dropdowns, popovers |
| `radiusLarge` | 12px | Panels, featured cards |
| `radiusXL` | 16px | Large panels, hero cards |
| `radiusPill` | 9999px | Chips, filter pills, status tags |
| `radiusCircle` | 50% | Icon buttons, avatars, status dots |

### Radius Guidelines

**Buttons & Inputs:** 6px (medium) - comfortable but not pill-shaped  
**Cards:** 8px (standard) for regular cards, 12px (large) for featured cards  
**Badges/Tags:** 9999px (pill) - creates friendly, modern feel  
**Icon Buttons:** 50% (circle) - clear touch targets with geometric precision

---

## 5. Elevation

### Decision Rationale

Linear uses background luminance stepping and semi-transparent borders for elevation on dark surfaces. Traditional shadows are nearly invisible on dark backgrounds, so we:

- Use background color steps to indicate depth
- Use semi-transparent white borders for structure
- Use multi-layer shadow stacks with very low opacity
- Reserve shadows for floating elements (dialogs, dropdowns)

### Elevation Scale

| Level | Background | Border | Shadow | Usage |
|-------|------------|--------|--------|-------|
| `elevation0` | `canvas` | none | none | Page background, flat content |
| `elevation1` | `panel` | `borderSubtle` | none | Bottom navigation, sidebars |
| `elevation2` | `surface` | `borderStandard` | `shadowSm` | Cards, input fields |
| `elevation3` | `surfaceHighlight` | `borderStandard` | `shadowMd` | Hover states, elevated cards |
| `elevation4` | `surface` | `borderStandard` | `shadowLg` | Dropdowns, popovers |
| `elevation5` | `surface` | `borderStandard` | `shadowXl` | Dialogs, modals |

### Shadow Definitions

| Token | Value | Usage |
|-------|-------|-------|
| `shadowSm` | `rgba(0, 0, 0, 0.2) 0px 1px 2px` | Subtle card lift |
| `shadowMd` | `rgba(0, 0, 0, 0.3) 0px 4px 8px` | Standard elevation |
| `shadowLg` | `rgba(0, 0, 0, 0.4) 0px 8px 16px` | Floating elements |
| `shadowXl` | `rgba(0, 0, 0, 0.5) 0px 16px 32px` | Dialogs, modals |

### Elevation Guidelines

**Background Stepping:**
- Level 0: `#08090a` (canvas)
- Level 1: `#0f1011` (panel)
- Level 2: `#191a1b` (surface)
- Level 3: `#28282c` (highlight)

Each step is approximately 10-15% lighter in luminance, creating perceptible depth without visible borders.

**Border Strategy:**
- Use `borderSubtle` (5% opacity) for most elements
- Use `borderStandard` (8% opacity) for interactive elements
- Use `borderStrong` (12% opacity) for focus/active states

---

## 6. Buttons

### Decision Rationale

Linear's button system uses ghost buttons with near-transparent backgrounds and subtle borders. Momentum adapts this with:

- Primary button with purple fill for main CTAs
- Ghost button with transparent background for secondary actions
- Subtle button with background fill for tertiary actions
- Icon-only button for toolbars
- Consistent 6px radius across all button types

### Button Variants

#### Primary Button

**Background:** `accentPrimary` (`#7c3aed`)  
**Text:** `textPrimary` (`#f7f8f8`)  
**Border:** none  
**Radius:** `radiusMedium` (6px)  
**Padding:** 12px 20px  
**Font:** `bodyMedium` (16px, weight 500)  
**Shadow:** `shadowSm`  
**Hover:** Background shifts to `accentSecondary` (`#8b5cf6`)  
**Active:** Scale 0.98  
**Disabled:** Opacity 0.5

**Usage:** Main CTAs (Add Habit, Complete Habit, Save Changes)

**Rationale:** The purple fill creates clear visual hierarchy. The 6px radius is comfortable without being pill-shaped. Subtle shadow adds depth without noise.

#### Ghost Button

**Background:** transparent  
**Text:** `textPrimary` (`#f7f8f8`)  
**Border:** `borderStandard`  
**Radius:** `radiusMedium` (6px)  
**Padding:** 12px 20px  
**Font:** `bodyMedium` (16px, weight 500)  
**Hover:** Background shifts to `surfaceHighlight` (`#28282c`), border to `borderStrong`  
**Active:** Scale 0.98  
**Disabled:** Opacity 0.5

**Usage:** Secondary actions (Cancel, Skip, View Details)

**Rationale:** Transparent background keeps visual weight low. Border provides structure. Hover feedback through background luminance change.

#### Subtle Button

**Background:** `surfaceHighlight` (`#28282c`)  
**Text:** `textPrimary` (`#f7f8f8`)  
**Border:** none  
**Radius:** `半径Medium` (6px)  
**Padding:** 12px 20px  
**Font:** `bodyMedium` (16px, weight 500)  
**Hover:** Background shifts to lighter variant  
**Active:** Scale 0.98  
**Disabled:** Opacity 0.5

**Usage:** Tertiary actions (Filter, Sort, Settings)

**Rationale:** Background fill provides more visual weight than ghost but less than primary. Good for utility actions.

#### Icon Button

**Background:** `surfaceHighlight` (`#28282c`)  
**Icon:** `textPrimary` (`#f7f8f8`)  
**Border:** `borderStandard`  
**Radius:** `radiusCircle` (50%)  
**Padding:** 12px (square)  
**Size:** 40px × 40px  
**Hover:** Background shifts to lighter variant  
**Active:** Scale 0.95  
**Disabled:** Opacity 0.5

**Usage:** Toolbar actions (Edit, Delete, Archive, Menu)

**Rationale:** Circular shape creates clear touch targets. Background fill provides structure. Consistent size across all icon buttons.

#### Success Button

**Context-specific variant for completion actions**

**Background:** `success` (`#10b981`)  
**Text:** `textPrimary` (`#f7f8f8`)  
**Border:** none  
**Radius:** `radiusMedium` (6px)  
**Padding:** 12px 20px  
**Font:** `bodyMedium` (16px, weight 500)  
**Hover:** Background shifts to lighter green variant  
**Active:** Scale 0.98

**Usage:** Mark habit as complete, confirm streak

**Rationale:** Green provides positive feedback. Used sparingly for completion actions only.

### Button States

**Default:** Standard appearance per variant  
**Hover:** Background luminance shift, scale 1.02  
**Active:** Scale 0.98, darker background  
**Focus:** 2px solid `accentPrimary` outline with 2px offset  
**Disabled:** Opacity 0.5, cursor not-allowed

### Button Sizes

| Size | Padding | Font Size | Icon Size | Usage |
|------|---------|-----------|-----------|-------|
| `small` | 8px 16px | 14px | 16px | Compact contexts |
| `medium` | 12px 20px | 16px | 20px | Standard (default) |
| `large` | 16px 24px | 18px | 24px | Emphasized CTAs |

---

## 7. Cards

### Decision Rationale

Linear's cards use background luminance stepping with semi-transparent borders. Momentum cards follow this pattern:

- Surface background with subtle border
- 8px radius for standard cards, 12px for featured cards
- Internal padding of 16-20px
- Subtle shadow for elevation
- Hover state with background luminance shift

### Card Variants

#### Standard Card

**Background:** `surface` (`#191a1b`)  
**Border:** `borderStandard`  
**Radius:** `radiusStandard` (8px)  
**Padding:** 20px  
**Shadow:** `shadowSm`  
**Hover:** Background shifts to `surfaceHighlight` (`#28282c`)

**Usage:** Habit cards, stat cards, list items

**Rationale:** 8px radius is comfortable without being pill-shaped. Subtle border provides structure. Shadow adds depth without noise.

#### Featured Card

**Background:** `surface` (`#191a1b`)  
**Border:** `borderStandard`  
**Radius:** `radiusLarge` (12px)  
**Padding:** 24px  
**Shadow:** `shadowMd`  
**Hover:** Background shifts to `surfaceHighlight` (`#28282c`)

**Usage:** Hero cards, featured habits, important stats

**Rationale:** Larger radius creates visual emphasis. More padding gives content breathing room. Stronger shadow for elevation.

#### Interactive Card

**Background:** `surface` (`#191a1b`)  
**Border:** `borderStandard`  
**Radius:** `radiusStandard` (8px)  
**Padding:** 20px  
**Shadow:** `shadowSm`  
**Hover:** Background shifts to `surfaceHighlight` (`#28282c`), border to `borderStrong`  
**Active:** Scale 0.98

**Usage:** Tappable habit cards, navigation items

**Rationale:** Enhanced hover feedback for interactive elements. Scale transform provides tactile feedback.

#### Success Card

**Context-specific for completion feedback**

**Background:** `successSubtle` (`rgba(16, 185, 129, 0.15)`)  
**Border:** `success` (`#10b981`) at 20% opacity  
**Radius:** `radiusStandard` (8px)  
**Padding:** 20px

**Usage:** Completion confirmation, streak milestone achieved

**Rationale:** Green tint provides positive feedback without overwhelming. Used sparingly.

### Card Structure

**Header (optional):**
- Title: `heading3` (20px, weight 600)
- Subtitle: `small` (14px, weight 400)
- Spacing: 12px between title and subtitle

**Body:**
- Content: `body` (16px, weight 400)
- Spacing: 16px between paragraphs

**Footer (optional):**
- Actions: Button row with 8px spacing
- Metadata: `caption` (13px, weight 500)

### Card Content Guidelines

**Single-line content:** 20px padding  
**Multi-line content:** 24px padding  
**With header:** Add 12px top padding for header  
**With footer:** Add 12px bottom padding for footer

---

## 8. Dialogs

### Decision Rationale

Linear's dialogs use backdrop blur with centered panels. Momentum dialogs follow this pattern:

- Semi-transparent backdrop with blur
- Centered panel with surface background
- 12px radius for modern feel
- 22px internal padding
- Pop-in animation with scale transform
- Clear action hierarchy in footer

### Dialog Structure

#### Backdrop

**Background:** `overlay` (`rgba(0, 0, 0, 0.85)`)  
**Blur:** 4px backdrop-filter  
**Animation:** Fade in 160ms ease-out

**Rationale:** High opacity ensures content readability. Blur creates depth without obscuring context.

#### Panel

**Background:** `surface` (`#191a1b`)  
**Border:** `borderStandard`  
**Radius:** `radiusLarge` (12px)  
**Padding:** 22px  
**Width:** 520px (max)  
**Max Width:** `calc(100vw - 32px)`  
**Shadow:** `shadowXl`  
**Animation:** Pop in 220ms cubic-bezier(0.21, 1.02, 0.73, 1)

**Rationale:** 520px is optimal for readability on desktop. 12px radius is modern but not pill-shaped. Pop-in animation feels responsive and polished.

#### Header

**Title:** `heading2` (24px, weight 500)  
**Description:** `body` (16px, weight 400, color `textSecondary`)  
**Spacing:** 4px between title and description, 16px to body

**Rationale:** Clear hierarchy with title and description. 4px spacing keeps them visually connected.

#### Body

**Content:** `body` (16px, weight 400)  
**Spacing:** 16px between paragraphs  
**Scroll:** Max height 60vh with scroll if needed

**Rationale:** 16px spacing provides readable rhythm. 60vh max height ensures dialog fits on screen.

#### Footer

**Actions:** Right-aligned button row  
**Spacing:** 8px between buttons  
**Border Top:** `borderStandard` (if sectioned dialog)  
**Padding Top:** 16px (if sectioned)

**Rationale:** Right alignment follows platform conventions. 8px spacing keeps buttons distinct but related.

### Dialog Variants

#### Standard Dialog

Header + Body + Footer in single container with 22px padding.

#### Sectioned Dialog

Header, Body, and Footer in separate sections with borders between them.

**Header Padding:** 22px 22px 0  
**Body Padding:** 16px 22px 0  
**Footer Padding:** 16px 22px 16px  
**Border:** `borderStandard` between sections

**Rationale:** Sectioned layout provides visual structure for complex dialogs with multiple content areas.

### Dialog Animations

**Backdrop Fade In:**
```css
from { opacity: 0; }
to { opacity: 1; }
```
Duration: 160ms, Easing: ease-out

**Panel Pop In:**
```css
from { opacity: 0; transform: scale(0.97); }
to { opacity: 1; transform: scale(1); }
```
Duration: 220ms, Easing: cubic-bezier(0.21, 1.02, 0.73, 1)

**Rationale:** Fast backdrop fade (160ms) feels responsive. Slightly slower panel pop (220ms) with overshoot (cubic-bezier) feels polished and deliberate.

---

## 9. Bottom Navigation

### Decision Rationale

Linear uses a sidebar for navigation, but mobile apps require bottom navigation. Momentum's bottom navigation adapts Linear's principles:

- Panel background with subtle top border
- 3-5 tabs maximum
- Icon + label layout
- Active state with purple accent
- Subtle hover/active feedback

### Navigation Structure

**Background:** `panel` (`#0f1011`)  
**Border Top:** `borderStandard`  
**Height:** 64px  
**Padding:** 8px horizontal (safe area)

**Rationale:** Panel background distinguishes navigation from content. 64px height provides comfortable touch targets. Top border creates separation from content.

### Tab Item

**Layout:** Column (icon above label)  
**Spacing:** 4px between icon and label  
**Padding:** 8px 16px  
**Min Width:** 64px  
**Border Radius:** `radiusMedium` (6px) (optional, for tap feedback)

**Icon:**
- Size: 24px
- Default color: `textTertiary` (`#8a8f98`)
- Active color: `accentPrimary` (`#7c3aed`)

**Label:**
- Font: `label` (12px, weight 500)
- Default color: `textTertiary` (`#8a8f98`)
- Active color: `accentPrimary` (`#7c3aed`)

**Active State:**
- Icon and label color: `accentPrimary`
- Background: `accentSubtle` (optional, for emphasis)
- Scale: 1.05 (subtle)

**Rationale:** Icon + label layout is standard and recognizable. Color change on active is clear feedback. Subtle scale adds polish.

### Navigation Guidelines

**Tab Count:** 3-5 tabs maximum  
**Icon Style:** Outline icons for inactive, filled for active (or consistent style with color change)  
**Label Style:** Sentence case, single word preferred  
**Active Tab:** Purple accent color  
**Inactive Tabs:** Muted gray color  
**Tap Feedback:** Scale 0.95 on press

### Navigation Items

**Recommended for Momentum:**
1. **Habits** (Home icon) - Default tab
2. **Stats** (Chart icon)
3. **Settings** (Settings icon)

**Optional:**
4. **Calendar** (Calendar icon) - If calendar view is added
5. **Profile** (User icon) - If user accounts are added

---

## 10. Icons

### Decision Rationale

Linear uses custom iconography with consistent stroke width and geometric precision. For Momentum:

- Use a consistent icon set (Lucide, Material Symbols, or custom)
- 2px stroke width for outline icons
- 24px standard size
- Geometric, minimalist style
- Consistent corner radius

### Icon Specifications

**Style:** Outline (stroke-based)  
**Stroke Width:** 2px  
**Corner Radius:** 2px (for rounded joins)  
**Standard Size:** 24px  
**Grid:** 24px × 24px canvas

**Color:**
- Default: `textSecondary` (`#d0d6e0`)
- Muted: `textTertiary` (`#8a8f98`)
- Active: `accentPrimary` (`#7c3aed`)
- Success: `success` (`#10b981`)
- Warning: `warning` (`#f59e0b`)
- Error: `error` (`#ef4444`)

### Icon Sizes

| Token | Size | Usage |
|-------|------|-------|
| `iconXs` | 16px | Compact contexts, inline icons |
| `iconSm` | 20px | Small buttons, list items |
| `iconMd` | 24px | Standard (default) |
| `iconLg` | 32px | Large buttons, featured content |
| `iconXl` | 48px | Hero sections, empty states |

### Icon Usage Guidelines

**Button Icons:** 20px (small buttons) or 24px (standard buttons)  
**Navigation Icons:** 24px  
**List Item Icons:** 20px  
**Status Icons:** 16px (badges), 24px (cards)  
**Hero Icons:** 48px or larger

### Icon Sets

**Recommended:** Lucide Icons
- Consistent stroke width
- Geometric, minimalist style
- Comprehensive set
- Open source
- Available in multiple formats

**Alternative:** Material Symbols
- Google's official icon set
- Multiple styles (outlined, rounded, sharp)
- Comprehensive set
- Well-maintained

**Custom:** If brand-specific icons are needed, maintain consistency with the chosen set's stroke width and corner radius.

---

## 11. Animations

### Decision Rationale

Linear uses fast, subtle animations (120-220ms) with ease-out easing. Momentum follows this pattern:

- Fast durations (120-220ms) for responsive feel
- Ease-out or custom easing for natural motion
- Subtle transforms (scale, opacity) rather than complex motion
- Consistent easing curves across all animations

### Animation Durations

| Token | Duration | Usage |
|-------|-----------|-------|
| `durationFast` | 120ms | Hover states, focus transitions |
| `durationNormal` | 160ms | Fade transitions, simple motion |
| `durationSlow` | 220ms | Dialog open/close, complex motion |
| `durationSlower` | 300ms | Page transitions, major state changes |

### Animation Easing

| Token | Curve | Usage |
|-------|-------|-------|
| `easeOut` | ease-out | Standard transitions |
| `easeInOut` | ease-in-out | Bidirectional motion |
| `easeOutBack` | cubic-bezier(0.21, 1.02, 0.73, 1) | Dialog pop-in, overshoot effects |
| `easeOutQuart` | cubic-bezier(0.25, 1, 0.5, 1) | Smooth deceleration |

### Animation Types

#### Hover Animations

**Background Color Shift:**
- Duration: 120ms
- Easing: ease-out
- Property: background-color

**Scale Transform:**
- Duration: 120ms
- Easing: ease-out
- Property: transform (scale 1.02)

**Border Color Shift:**
- Duration: 120ms
- Easing: ease-out
- Property: border-color

**Rationale:** Fast duration (120ms) feels responsive. Ease-out provides natural deceleration.

#### Press Animations

**Scale Transform:**
- Duration: 100ms
- Easing: ease-out
- Property: transform (scale 0.98)

**Rationale:** Quick scale provides tactile feedback. 100ms is fast enough to feel immediate.

#### Focus Animations

**Outline Fade In:**
- Duration: 120ms
- Easing: ease-out
- Property: outline-opacity

**Shadow Fade In:**
- Duration: 120ms
- Easing: ease-out
- Property: box-shadow

**Rationale:** 120ms matches hover duration for consistency. Ease-out feels natural.

#### Dialog Animations

**Backdrop Fade In:**
- Duration: 160ms
- Easing: ease-out
- Property: opacity (0 → 1)

**Panel Pop In:**
- Duration: 220ms
- Easing: cubic-bezier(0.21, 1.02, 0.73, 1)
- Property: opacity (0 → 1), transform (scale 0.97 → 1)

**Rationale:** Backdrop fade (160ms) is faster than panel (220ms) for layered feel. Overshoot easing (cubic-bezier) adds polish.

#### Page Transitions

**Fade In:**
- Duration: 300ms
- Easing: ease-out
- Property: opacity (0 → 1)

**Slide In (optional):**
- Duration: 300ms
- Easing: ease-out
- Property: transform (translateX 20px → 0)

**Rationale:** 300ms is slow enough to be noticeable but fast enough to not feel sluggish. Slide adds directionality.

#### Loading Animations

**Spinner:**
- Duration: 1000ms (infinite)
- Easing: linear
- Property: transform (rotate)

**Skeleton Shimmer:**
- Duration: 1500ms (infinite)
- Easing: ease-in-out
- Property: background-position

**Rationale:** Linear spinner for continuous loading. Shimmer for content placeholders.

### Animation Guidelines

**Keep it subtle:** Animations should enhance, not distract  
**Be consistent:** Use the same duration/easing for similar interactions  
**Respect preferences:** Honor reduced motion settings  
**Test performance:** Ensure 60fps on target devices  
**Avoid over-animation:** One animation per interaction maximum

---

## 12. ThemeData Structure

### Decision Rationale

Flutter's ThemeData is the central place for defining app-wide theme properties. Momentum's theme structure follows Flutter conventions while implementing Linear-inspired design tokens.

### Theme Structure

```dart
ThemeData(
  // Color Scheme
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: accentPrimary,
    onPrimary: textPrimary,
    secondary: accentSecondary,
    onSecondary: textPrimary,
    surface: surface,
    onSurface: textPrimary,
    error: error,
    onError: textPrimary,
  ),
  
  // Scaffold Background
  scaffoldBackgroundColor: canvas,
  
  // Card Theme
  cardTheme: CardTheme(
    color: surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusStandard),
    ),
  ),
  
  // App Bar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: panel,
    foregroundColor: textPrimary,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: heading2,
  ),
  
  // Button Themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentPrimary,
      foregroundColor: textPrimary,
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
    ),
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: accentPrimary,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: textPrimary,
      side: BorderSide(color: borderStandard),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
    ),
  ),
  
  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      borderSide: BorderSide(color: borderStandard),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      borderSide: BorderSide(color: borderStandard),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      borderSide: BorderSide(color: accentPrimary),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  
  // Text Theme
  textTheme: TextTheme(
    displayLarge: displayHero,
    displayMedium: displayLarge,
    displaySmall: display,
    headlineLarge: heading1,
    headlineMedium: heading2,
    headlineSmall: heading3,
    titleLarge: bodyLarge,
    bodyLarge: body,
    bodyMedium: bodyMedium,
    bodySmall: small,
    labelLarge: caption,
    labelMedium: label,
    labelSmall: micro,
  ),
  
  // Icon Theme
  iconTheme: IconThemeData(
    color: textSecondary,
    size: 24,
  ),
  
  // Divider Theme
  dividerTheme: DividerThemeData(
    color: divider,
    thickness: 1,
    space: 1,
  ),
  
  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: panel,
    selectedItemColor: accentPrimary,
    unselectedItemColor: textTertiary,
    selectedLabelStyle: label,
    unselectedLabelStyle: label,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
  
  // Dialog Theme
  dialogTheme: DialogTheme(
    backgroundColor: surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLarge),
    ),
    elevation: 8,
  ),
  
  // Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: accentPrimary,
    foregroundColor: textPrimary,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
  ),
  
  // Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: surfaceHighlight,
    labelStyle: label,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusPill),
    ),
  ),
  
  // Switch Theme
  switchTheme: SwitchThemeData(
    thumbColor: accentPrimary,
    trackColor: accentSubtle,
  ),
  
  // Slider Theme
  sliderTheme: SliderThemeData(
    activeTrackColor: accentPrimary,
    inactiveTrackColor: borderStandard,
    thumbColor: accentPrimary,
  ),
)
```

### Light Mode Variant

For light mode (accessibility option), invert the color scheme while maintaining the same design principles:

```dart
ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: accentPrimary,
    onPrimary: textPrimary,
    surface: surfaceLight, // #f5f5f7
    onSurface: textPrimaryLight, // #1d1d1f
  ),
  scaffoldBackgroundColor: canvasLight, // #ffffff
  // ... other properties adapted for light mode
)
```

---

## 13. Component Naming

### Decision Rationale

Consistent naming conventions make the codebase predictable and maintainable. Momentum uses descriptive, Flutter-standard naming with Linear-inspired prefixes where applicable.

### Naming Conventions

#### Widget Names

**Pattern:** `[Purpose][Component]`  
**Examples:**
- `HabitCard` - Card displaying a habit
- `StreakBadge` - Badge showing streak count
- `MomentumScoreCard` - Card displaying momentum score
- `HabitOrb` - Orb-shaped habit indicator
- `CompletionButton` - Button for marking completion

**Rationale:** Purpose-first naming makes widgets self-documenting. Component type suffix indicates the visual pattern.

#### Theme Token Names

**Pattern:** `[category][purpose][variant]`  
**Examples:**
- `colorAccentPrimary` - Primary accent color
- `colorSurfaceHighlight` - Highlighted surface color
- `spacingSpace4` - 16px spacing token
- `radiusRadiusMedium` - Medium border radius
- `shadowShadowLg` - Large shadow

**Rationale:** Category prefix groups related tokens. Purpose describes the token's use. Variant distinguishes similar tokens.

#### Text Style Names

**Pattern:** `[role][variant]` or `[size][weight]`  
**Examples:**
- `textDisplayHero` - Hero display text
- `textHeading1` - Level 1 heading
- `textBodyMedium` - Medium body text
- `textCaption` - Caption text

**Rationale:** Role-based naming matches Flutter's TextTheme structure. Variant distinguishes size/weight variations.

#### Animation Names

**Pattern:** `[action][component][type]`  
**Examples:**
- `animationDialogOpen` - Dialog open animation
- `animationButtonHover` - Button hover animation
- `animationPageTransition` - Page transition animation

**Rationale:** Action describes what's animating. Component identifies the element. Type specifies the animation kind.

### File Naming

**Pattern:** `snake_case.dart`  
**Examples:**
- `habit_card.dart`
- `streak_badge.dart`
- `momentum_score_card.dart`
- `habit_orb.dart`

**Rationale:** Flutter convention. Snake_case is standard for Dart files.

### Directory Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radius.dart
│   │   └── app_shadows.dart
│   └── constants/
│       └── app_constants.dart
├── widgets/
│   ├── buttons/
│   │   ├── primary_button.dart
│   │   ├── ghost_button.dart
│   │   └── icon_button.dart
│   ├── cards/
│   │   ├── habit_card.dart
│   │   ├── stat_card.dart
│   │   └── momentum_card.dart
│   ├── navigation/
│   │   └── bottom_nav_bar.dart
│   ├── dialogs/
│   │   ├── confirmation_dialog.dart
│   │   └── habit_detail_dialog.dart
│   └── badges/
│       ├── streak_badge.dart
│       └── milestone_badge.dart
└── screens/
    ├── home/
    ├── stats/
    └── settings/
```

**Rationale:** Organized by type (theme, widgets, screens). Widgets grouped by component category. Clear separation of concerns.

---

## Implementation Guidelines

### 1. Token Usage

**Always use theme tokens, never hardcode values.**

❌ Bad:
```dart
Container(
  color: Color(0xFF191A1B),
  padding: EdgeInsets.all(20),
  borderRadius: BorderRadius.circular(8),
)
```

✅ Good:
```dart
Container(
  color: theme.colorScheme.surface,
  padding: EdgeInsets.all(spacing.space4),
  borderRadius: BorderRadius.circular(radius.radiusStandard),
)
```

### 2. Component Composition

**Build complex components from simple primitives.**

Instead of creating a monolithic `HabitCard` widget, compose it from:
- `Card` (base container)
- `HabitOrb` (visual indicator)
- `StreakBadge` (streak display)
- `CompletionButton` (action button)

This makes components reusable and testable.

### 3. Responsive Design

**Use the spacing scale for responsive adjustments.**

- Mobile: `space2` (8px) - `space4` (16px)
- Tablet: `space4` (16px) - `space6` (24px)
- Desktop: `space6` (24px) - `space8` (32px)

### 4. Accessibility

**Ensure minimum contrast ratios:**

- Normal text: 4.5:1 (WCAG AA)
- Large text: 3:1 (WCAG AA)
- UI components: 3:1 (WCAG AA)

**Support reduced motion:**
```dart
final animationCurve = MediaQuery.of(context).disableAnimations
    ? Curves.linear
    : Curves.easeOut;
```

### 5. Testing

**Create widget tests for all custom components.**

Test:
- Color tokens are applied correctly
- Spacing follows the scale
- Border radius matches tokens
- Hover/active states work
- Responsive behavior

---

## Migration Strategy

### Phase 1: Foundation (Week 1-2)

1. Create theme token files (colors, spacing, radius, shadows)
2. Define text styles
3. Set up ThemeData structure
4. Create base widget primitives (Button, Card, Badge)

### Phase 2: Core Components (Week 3-4)

1. Implement navigation components (BottomNavBar)
2. Create dialog components
3. Build habit-specific components (HabitCard, HabitOrb)
4. Implement stat components (MomentumScoreCard, StreakBadge)

### Phase 3: Screen Migration (Week 5-6)

1. Migrate HomeScreen to new design system
2. Migrate StatsScreen to new design system
3. Migrate SettingsScreen to new design system
4. Migrate HabitDetailScreen to new design system

### Phase 4: Polish (Week 7)

1. Add animations
2. Implement light mode variant
3. Accessibility audit
4. Performance optimization
5. Documentation updates

---

## Conclusion

This design system adapts Linear's precision engineering and dark-mode-native minimalism for Momentum's habit-tracking context. The system provides:

- **Consistent visual language** through defined tokens
- **Clear hierarchy** through typography and color
- **Subtle depth** through luminance stepping and borders
- **Responsive feedback** through animations and states
- **Accessibility** through contrast ratios and reduced motion support

The design system is intentionally comprehensive but not prescriptive—use it as a foundation, adapt it as needed, and maintain consistency across the application.

---

## Appendix: Quick Reference

### Color Quick Reference

```dart
// Backgrounds
canvas: #08090a
panel: #0f1011
surface: #191a1b
surfaceHighlight: #28282c

// Text
textPrimary: #f7f8f8
textSecondary: #d0d6e0
textTertiary: #8a8f98
textQuaternary: #62666d

// Accent
accentPrimary: #7c3aed
accentSecondary: #8b5cf6
accentHover: #a78bfa
accentSubtle: rgba(124, 58, 237, 0.15)

// Semantic
success: #10b981
warning: #f59e0b
error: #ef4444

// Borders
borderSubtle: rgba(255, 255, 255, 0.05)
borderStandard: rgba(255, 255, 255, 0.08)
borderStrong: rgba(255, 255, 255, 0.12)
divider: #141516

// Overlay
overlay: rgba(0, 0, 0, 0.85)
```

### Spacing Quick Reference

```dart
space0: 0px
space1: 4px
space2: 8px
space3: 12px
space4: 16px
space5: 20px
space6: 24px
space8: 32px
space10: 40px
space12: 48px
space16: 64px
space20: 80px
```

### Radius Quick Reference

```dart
radiusNone: 0px
radiusMicro: 2px
radiusSmall: 4px
radiusMedium: 6px
radiusStandard: 8px
radiusLarge: 12px
radiusXL: 16px
radiusPill: 9999px
radiusCircle: 50%
```

### Animation Quick Reference

```dart
durationFast: 120ms
durationNormal: 160ms
durationSlow: 220ms
durationSlower: 300ms

easeOut: ease-out
easeInOut: ease-in-out
easeOutBack: cubic-bezier(0.21, 1.02, 0.73, 1)
easeOutQuart: cubic-bezier(0.25, 1, 0.5, 1)
```
