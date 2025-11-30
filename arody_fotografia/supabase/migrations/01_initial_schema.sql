-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Clients / Profiles (Linked to auth.users)
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT,
    phone_number TEXT,
    preferred_contact_method TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Sessions
CREATE TABLE public.sessions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    client_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    session_date TIMESTAMPTZ NOT NULL,
    location TEXT,
    session_type TEXT NOT NULL, -- e.g., 'studio', 'outdoors', 'product'
    status TEXT DEFAULT 'planned' CHECK (status IN ('planned', 'confirmed', 'delivered', 'cancelled')),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Session Assets
CREATE TABLE public.session_assets (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    session_id UUID REFERENCES public.sessions(id) ON DELETE CASCADE NOT NULL,
    storage_path TEXT NOT NULL,
    asset_type TEXT DEFAULT 'preview' CHECK (asset_type IN ('preview', 'final', 'bts')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Inspiration Items
CREATE TABLE public.inspiration_items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT,
    description TEXT,
    image_url TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Payments
CREATE TABLE public.payments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    client_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    session_id UUID REFERENCES public.sessions(id) ON DELETE SET NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency TEXT DEFAULT 'USD',
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue')),
    payment_date TIMESTAMPTZ,
    due_date TIMESTAMPTZ,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security (RLS) Policies

-- Profiles: Users can view and update their own profile.
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Sessions: Users can view their own sessions.
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own sessions" ON public.sessions FOR SELECT USING (auth.uid() = client_id);
CREATE POLICY "Users can create booking requests" ON public.sessions FOR INSERT WITH CHECK (auth.uid() = client_id);

-- Session Assets: Users can view assets for their sessions.
ALTER TABLE public.session_assets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own session assets" ON public.session_assets FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.sessions WHERE id = session_assets.session_id AND client_id = auth.uid())
);

-- Inspiration: Publicly readable (or authenticated only).
ALTER TABLE public.inspiration_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Everyone can view inspiration" ON public.inspiration_items FOR SELECT USING (true);

-- Payments: Users can view their own payments.
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own payments" ON public.payments FOR SELECT USING (auth.uid() = client_id);

-- Indexes for performance
CREATE INDEX idx_sessions_client_id ON public.sessions(client_id);
CREATE INDEX idx_session_assets_session_id ON public.session_assets(session_id);
CREATE INDEX idx_payments_client_id ON public.payments(client_id);
