# Feature Backlog - Arody Fotografía

## M1: Supabase Setup + Auth
- [ ] Setup Supabase project (SQL Schema).
- [ ] Configure Flutter app with Supabase URL/Key.
- [ ] Implement `AuthRepository`.
- [ ] Create Login Screen.
- [ ] Create Sign Up Screen.
- [ ] Create "Profile" setup screen (basic client info).
- [ ] Handle Auth State (redirect to Home if logged in).

## M2: Sessions List/Detail
- [ ] Create `Session` entity and model.
- [ ] Implement `SessionsRepository` (fetch list, fetch detail).
- [ ] Create "My Sessions" list screen.
- [ ] Create Session Detail screen (Date, Location, Status, Notes).
- [ ] Display session assets (mocked or real from Storage).

## M3: Inspiration Section
- [ ] Create `InspirationItem` entity and model.
- [ ] Implement `InspirationRepository`.
- [ ] Create Inspiration Grid view (filtered by category).
- [ ] Create Inspiration Detail view (large image, description).

## M4: Calendar & Booking
- [ ] Create Calendar view showing booked sessions.
- [ ] Implement "Request Booking" flow:
    - [ ] Date/Time picker.
    - [ ] Category selection.
    - [ ] Save to Supabase with status "pending".

## M5: Payments Screen
- [ ] Create `Payment` entity and model.
- [ ] Implement `PaymentsRepository`.
- [ ] Create Payments List screen (Status: Pending/Paid).
- [ ] Show total due/paid.

## M6: Polish & Quality
- [ ] Error handling (Snackbars, retry logic).
- [ ] Loading states (Shimmer effects).
- [ ] Basic Unit Tests (AuthRepo, SessionsRepo).
- [ ] Widget Test (Sessions List).
- [ ] Dark Mode support.
