# UI/UX Design Documentation

## Design System

### Color Palette

#### Primary Colors
- **Indigo**: `#6366F1` - Main brand color, buttons, icons
- **Purple**: `#8B5CF6` - Gradient accent, secondary elements
- **Pink**: `#EC4899` - Feature highlights

#### Status Colors
- **Green**: `#10B981` - Success, active calls, positive actions
- **Orange**: `#FB923C` - Warnings, new customer alerts
- **Red**: `#EF4444` - End call, errors
- **Yellow/Gold**: `#EAB308` - Premium/VIP badges

#### Neutral Colors
- **Gray 50**: `#F9FAFB` - Background
- **Gray 200**: `#E5E7EB` - Borders
- **Gray 600**: `#6B7280` - Secondary text
- **Gray 900**: `#1F2937` - Primary text

### Typography

- **Header**: 24px, Bold, Gray 900
- **Subheader**: 18px, Semi-bold, Gray 900
- **Body**: 16px, Regular, Gray 700
- **Caption**: 14px, Regular, Gray 600
- **Small**: 12px, Regular, Gray 600

### Spacing System

- **XS**: 4px
- **S**: 8px
- **M**: 12px
- **L**: 16px
- **XL**: 24px
- **XXL**: 32px

### Border Radius

- **Small**: 8px - Badges, small buttons
- **Medium**: 12px - Input fields, cards
- **Large**: 16px - Major containers
- **XLarge**: 20px - Hero sections

## Screen Layouts

### 1. Welcome Screen (Initial State)

```
┌─────────────────────────────────────────┐
│  ┌─┐  Call Information                  │
│  │📞│  Manage customer calls & details   │
│  └─┘                                     │
├─────────────────────────────────────────┤
│  ┌────────────────────────┬────┬────┐   │
│  │ 🔍 Search phone/ID...  │ 🔍 │    │   │
│  └────────────────────────┴────┴────┘   │
├─────────────────────────────────────────┤
│                                         │
│           ┌─────────┐                   │
│           │    🔍   │                   │
│           │ Search  │                   │
│           └─────────┘                   │
│                                         │
│     Search for a Customer               │
│                                         │
│  Enter a phone number or customer      │
│  ID to fetch their information         │
│  from the CRM                           │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ 🔄  CRM Integration               │ │
│  │     Auto fetch customer data      │ │
│  │                                   │ │
│  │ 👤  New Customer                  │ │
│  │     Add info for new customers    │ │
│  │                                   │ │
│  │ 📋  Call History                  │ │
│  │     Track all interactions        │ │
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

### 2. CRM Info View (Customer Found)

```
┌─────────────────────────────────────────┐
│  ┌─┐  Call Information                  │
│  │📞│  Manage customer calls & details   │
│  └─┘                                     │
├─────────────────────────────────────────┤
│  ┌────────────────────────┬────┬────┐   │
│  │ 🔍 +1234567890         │ 🔍 │ 🔄 │   │
│  └────────────────────────┴────┴────┘   │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────────┐│
│  │ 📞 Call in Progress    00:05:23   ⚪││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │  ┌───┐                              ││
│  │  │ JD│  John Doe         [Premium]  ││
│  │  └───┘  📞 +1234567890              ││
│  │         ✉️  john.doe@email.com      ││
│  │                                     ││
│  │  📍 123 Main Street, Apt 4B...      ││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐   │
│  │📞  24   │ │💵 1249  │ │✓ Active │   │
│  │Calls    │ │Spent    │ │Status   │   │
│  └─────────┘ └─────────┘ └─────────┘   │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ [History] [Orders]  [Notes]         ││
│  ├─────────────────────────────────────┤│
│  │ 📥 Incoming         Dec 10, 2024    ││
│  │    ⏱️ 12:34  [Completed]            ││
│  │    Customer inquired about...       ││
│  │                                     ││
│  │ 📤 Outgoing         Nov 25, 2024    ││
│  │    ⏱️ 8:15   [Completed]            ││
│  │    Follow-up on previous order      ││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌──────────────┬──────────────────────┐│
│  │ Save Notes   │   🔴 End Call        ││
│  └──────────────┴──────────────────────┘│
└─────────────────────────────────────────┘
```

### 3. Customer Form View (Customer Not Found)

```
┌─────────────────────────────────────────┐
│  ┌─┐  Call Information                  │
│  │📞│  Manage customer calls & details   │
│  └─┘                                     │
├─────────────────────────────────────────┤
│  ┌────────────────────────┬────┬────┐   │
│  │ 🔍 +1234567890         │ 🔍 │ 🔄 │   │
│  └────────────────────────┴────┴────┘   │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────────┐│
│  │     👤 Customer Not Found           ││
│  │  Add new customer information       ││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 👤 Personal Information             ││
│  │                                     ││
│  │ First Name  [________________]      ││
│  │ Last Name   [________________]      ││
│  │ Email       [________________]      ││
│  │ Phone       [+1234567890    ]       ││
│  │                                     ││
│  │ 📍 Address                          ││
│  │                                     ││
│  │ Street      [________________]      ││
│  │ City        [_____]  State [____]   ││
│  │ ZIP         [_____]  Country[____]  ││
│  │                                     ││
│  │ 📞 Call Information                 ││
│  │                                     ││
│  │ Customer Type  [New        ▼]       ││
│  │ Call Purpose   [Inquiry    ▼]       ││
│  │ Priority       [Medium     ▼]       ││
│  │ Follow-up      [Select date... >]   ││
│  │                                     ││
│  │ Call Notes                          ││
│  │ [____________________________]      ││
│  │ [____________________________]      ││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌──────────┬──────────────────────────┐│
│  │ Cancel   │  💾 Save Customer        ││
│  └──────────┴──────────────────────────┘│
└─────────────────────────────────────────┘
```

## Component Details

### 1. Header Component
- **Height**: 96px
- **Background**: White with bottom shadow
- **Icon**: 44x44 gradient circle with phone icon
- **Title**: "Call Information" - 24px bold
- **Subtitle**: "Manage customer calls & details" - 14px regular

### 2. Search Bar Component
- **Height**: 56px
- **Background**: Gray 50
- **Border**: Gray 200, 1px
- **Border Radius**: 12px
- **Icon**: Indigo search icon (left)
- **Button**: Gradient circle (right), 56x56
- **Refresh**: Gray circle (far right when active)

### 3. Call Status Bar
- **Background**: Green gradient
- **Padding**: 16px
- **Border Radius**: 16px
- **Shadow**: Green glow
- **Elements**: 
  - White circle icon (left)
  - "Call in Progress" text
  - Live timer
  - Pulsing dot indicator (right)

### 4. Customer Header Card
- **Background**: White
- **Padding**: 24px
- **Border Radius**: 20px
- **Shadow**: Subtle elevation
- **Avatar**: 80x80 gradient circle
- **Badge**: Rounded pill with color coding
- **Address Bar**: Gray 50 background inset

### 5. Stats Cards
- **Size**: Equal width, responsive
- **Padding**: 16px
- **Border Radius**: 16px
- **Icon**: Colored background circle
- **Value**: 18px bold
- **Label**: 12px gray

### 6. Tab Bar
- **Background**: White
- **Active Tab**: Gradient background
- **Inactive Tab**: Gray text
- **Border Radius**: 12px
- **Height**: 48px

### 7. Form Components

#### Text Input
- **Height**: 56px
- **Background**: Gray 50
- **Border**: Gray 200 (normal), Indigo (focused)
- **Border Radius**: 12px
- **Icon**: Colored prefix icon
- **Padding**: 16px

#### Dropdown
- **Same as text input**
- **Suffix**: Down arrow icon
- **Dropdown**: White background, rounded

#### Date Picker
- **Trigger**: Tap-able container
- **Display**: Selected date or placeholder
- **Icon**: Calendar icon (left), Arrow (right)

### 8. Action Buttons

#### Primary (Save/End Call)
- **Height**: 56px
- **Background**: Gradient or solid color
- **Text**: White, 16px semi-bold
- **Border Radius**: 12px
- **Icon**: Optional left icon
- **Shadow**: Colored glow

#### Secondary (Cancel/Save Notes)
- **Height**: 56px
- **Background**: Transparent
- **Border**: 1px solid color
- **Text**: Colored, 16px semi-bold
- **Border Radius**: 12px

## Interactions & Animations

### 1. Screen Transitions
- **Fade In**: 600ms ease-in-out
- **Content Slide**: Smooth vertical slide

### 2. Button States
- **Hover**: Slight scale (1.02)
- **Press**: Scale down (0.98)
- **Loading**: Spinner animation

### 3. Form Validation
- **Success**: Green border pulse
- **Error**: Red border with shake
- **Error Text**: Fade in below field

### 4. Call Timer
- **Update**: Every 1 second
- **Format**: HH:MM:SS
- **Indicator**: Pulsing white dot

### 5. Tab Switching
- **Animation**: Slide and fade
- **Duration**: 300ms
- **Indicator**: Smooth gradient slide

## Responsive Behavior

### Mobile (< 600px)
- Single column layout
- Full-width components
- Stacked stats cards
- Collapsible sections

### Tablet (600px - 1024px)
- Two-column layout where applicable
- Side-by-side stats
- Wider form fields

### Desktop (> 1024px)
- Maximum width: 800px centered
- Optimal spacing
- Larger touch targets

## Accessibility

### Color Contrast
- All text meets WCAG AA standards
- Important actions have AAA contrast

### Touch Targets
- Minimum 44x44 points
- Adequate spacing between interactive elements

### Screen Readers
- Semantic HTML structure
- Descriptive labels
- Status announcements

### Keyboard Navigation
- Tab order follows visual flow
- Focus indicators visible
- Enter/Space for actions

## Design Principles

1. **Clarity**: Clear hierarchy and purpose for each element
2. **Consistency**: Repeated patterns throughout the app
3. **Feedback**: Visual response to all user actions
4. **Efficiency**: Minimal steps to complete tasks
5. **Delight**: Smooth animations and beautiful gradients
6. **Professional**: Clean, modern business appearance
7. **Accessible**: Usable by everyone regardless of ability
