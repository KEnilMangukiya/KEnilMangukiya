# Screenshots & Visual Guide

## Application Screens

### 1. Welcome/Search Screen

**Purpose**: Initial landing screen where agents search for customers

**Key Features**:
- Large search bar with phone/ID input
- Feature showcase cards
- Clean, inviting design
- Call-to-action messaging

**User Flow**:
1. Agent enters phone number or customer ID
2. Clicks search button or presses Enter
3. System performs CRM lookup
4. Routes to appropriate view based on results

---

### 2. CRM Info View (Customer Found)

**Purpose**: Display comprehensive customer information from CRM

**Key Features**:
- **Live Call Timer**: Shows active call duration with pulsing indicator
- **Customer Profile**: 
  - Avatar with initials
  - Full name and contact details
  - Customer type badge (Premium, VIP, Regular)
  - Complete address
- **Quick Stats Dashboard**:
  - Total calls made
  - Total amount spent
  - Account status
- **Tabbed Information**:
  - **History Tab**: Past calls with dates, durations, and notes
  - **Orders Tab**: Recent purchases and transactions
  - **Notes Tab**: View existing CRM notes and add new call notes
- **Action Buttons**:
  - Save Notes (saves current call notes to CRM)
  - End Call (completes call and saves data)

**User Flow**:
1. View customer information automatically
2. Navigate between tabs to see different data
3. Add notes about current call
4. Save notes or end call when finished

---

### 3. Customer Form View (Customer Not Found)

**Purpose**: Capture new customer information when not found in CRM

**Key Features**:
- **Alert Banner**: Clear indication customer was not found
- **Section-based Form**:
  - **Personal Information**: Name, email, phone
  - **Address**: Complete address fields
  - **Call Information**: Purpose, priority, notes
- **Smart Form Elements**:
  - Dropdown selectors for standardized data
  - Date picker for follow-up scheduling
  - Multi-line text area for detailed notes
  - Form validation with helpful error messages
- **Action Buttons**:
  - Cancel (returns to search)
  - Save Customer (creates new CRM entry)

**User Flow**:
1. Agent sees "Customer Not Found" notification
2. Fills in required customer information
3. Selects appropriate options from dropdowns
4. Adds call notes and sets follow-up date
5. Saves customer to create new CRM record

---

## UI Elements Detail

### Color-Coded Status Badges

- **🟡 Premium/VIP**: Gold badge - High-value customers
- **🔵 Regular**: Blue badge - Standard customers  
- **🟢 Active**: Green badge - Active account status
- **🟠 New**: Orange badge - New customer type

### Icon System

- **📞 Phone**: Call-related actions and information
- **✉️ Email**: Email addresses and communication
- **📍 Location**: Address and location information
- **💵 Money**: Financial information and spending
- **📊 Stats**: Analytics and metrics
- **📝 Notes**: Text notes and documentation
- **📅 Calendar**: Dates and scheduling
- **🔍 Search**: Search functionality
- **💾 Save**: Save actions
- **🔄 Refresh**: Reload/reset actions
- **❌ Close**: Cancel/close actions

### Gradient Combinations

1. **Primary Gradient**: Indigo (#6366F1) → Purple (#8B5CF6)
   - Used for: Main buttons, headers, active states
   
2. **Success Gradient**: Green (#10B981) → Light Green
   - Used for: Active calls, success messages
   
3. **Alert Gradient**: Orange (#FB923C) → Deep Orange
   - Used for: Warnings, new customer alerts

### Shadow System

- **Subtle Elevation**: rgba(0,0,0,0.05) with 10px blur
  - Used for: Cards, containers
  
- **Colored Glow**: Primary color at 0.3 opacity with 12px blur
  - Used for: Important buttons, active elements
  
- **Lift Effect**: Larger blur (16px) with slight offset
  - Used for: Floating elements, modals

---

## Interaction States

### Button States

1. **Normal**: Default appearance
2. **Hover**: Slight scale increase (1.02x)
3. **Active/Pressed**: Scale decrease (0.98x)
4. **Loading**: Spinner animation replaces content
5. **Disabled**: Reduced opacity (0.5), no interaction

### Input Field States

1. **Empty**: Placeholder text, gray border
2. **Focused**: Indigo border (2px), slightly elevated
3. **Filled**: Content visible, maintains style
4. **Error**: Red border, error message below
5. **Disabled**: Gray background, no interaction

### Tab States

1. **Active**: Gradient background, white text
2. **Inactive**: Transparent background, gray text
3. **Hover**: Slight background tint
4. **Transition**: Smooth slide animation (300ms)

---

## Data Display Patterns

### Customer Profile Card
```
┌────────────────────────────────┐
│ [Avatar] Name          [Badge] │
│          📞 Phone              │
│          ✉️  Email             │
│                                │
│ 📍 [Address in gray box]       │
└────────────────────────────────┘
```

### Stats Card
```
┌──────────────┐
│   [Icon]     │
│              │
│    Value     │
│    Label     │
└──────────────┘
```

### History Item
```
┌─────────────────────────────────┐
│ [Icon] Type            Date     │
│        ⏱️ Duration [Status]     │
│        Notes text...            │
└─────────────────────────────────┘
```

### Order Item
```
┌─────────────────────────────────┐
│ Order ID            [Status]    │
│ Product Name                    │
│ 📅 Date              $Amount    │
└─────────────────────────────────┘
```

---

## Animation Timings

- **Quick**: 150ms - Small UI changes
- **Standard**: 300ms - Tab switches, transitions
- **Smooth**: 600ms - Screen changes, fades
- **Slow**: 1000ms - Special emphasis

---

## Responsive Breakpoints

- **Mobile**: < 600px
  - Single column
  - Full-width components
  - Stacked cards
  
- **Tablet**: 600px - 1024px
  - Two columns where appropriate
  - Wider forms
  - Side-by-side stats
  
- **Desktop**: > 1024px
  - Max width: 800px
  - Centered layout
  - Optimal spacing

---

## Best Practices Implemented

✅ **Material Design 3** principles
✅ **Consistent spacing** using 8px grid
✅ **Accessible colors** (WCAG AA compliant)
✅ **Touch-friendly** targets (minimum 44x44)
✅ **Clear visual hierarchy**
✅ **Responsive design**
✅ **Loading states** for async operations
✅ **Error handling** with helpful messages
✅ **Form validation** with inline feedback
✅ **Smooth animations** for better UX
