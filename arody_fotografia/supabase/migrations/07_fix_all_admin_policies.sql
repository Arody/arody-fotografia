-- Actualizar todas las políticas para usar la función current_user_role() sin recursión

-- === SESSIONS ===
DROP POLICY IF EXISTS "Users can view own sessions or admin can view all" ON public.sessions;

CREATE POLICY "Users can view own sessions or admin can view all" 
ON public.sessions FOR SELECT 
USING (
  auth.uid() = client_id 
  OR 
  public.current_user_role() = 'super_admin'
);

-- Agregar política para que admin pueda actualizar sessions
CREATE POLICY "Super admin can update sessions" 
ON public.sessions FOR UPDATE 
USING (public.current_user_role() = 'super_admin')
WITH CHECK (public.current_user_role() = 'super_admin');

-- === SESSION ASSETS ===
DROP POLICY IF EXISTS "Users can view own session assets or admin can view all" ON public.session_assets;
DROP POLICY IF EXISTS "Super admin can insert session assets" ON public.session_assets;
DROP POLICY IF EXISTS "Super admin can delete session assets" ON public.session_assets;

CREATE POLICY "Users can view own session assets or admin can view all" 
ON public.session_assets FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM public.sessions 
    WHERE id = session_assets.session_id 
    AND client_id = auth.uid()
  )
  OR 
  public.current_user_role() = 'super_admin'
);

CREATE POLICY "Super admin can insert session assets" 
ON public.session_assets FOR INSERT 
WITH CHECK (public.current_user_role() = 'super_admin');

CREATE POLICY "Super admin can delete session assets" 
ON public.session_assets FOR DELETE 
USING (public.current_user_role() = 'super_admin');

-- === STORAGE OBJECTS ===
DROP POLICY IF EXISTS "Users can view own session photos" ON storage.objects;
DROP POLICY IF EXISTS "Admin can view all session photos" ON storage.objects;
DROP POLICY IF EXISTS "Super admin can upload photos" ON storage.objects;
DROP POLICY IF EXISTS "Super admin can update photos" ON storage.objects;
DROP POLICY IF EXISTS "Super admin can delete photos" ON storage.objects;

-- Política para que usuarios vean fotos de sus propias sesiones
CREATE POLICY "Users can view own session photos"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'session-photos' 
  AND auth.uid() IN (
    SELECT client_id 
    FROM public.sessions 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

-- Política para que admin vea todas las fotos
CREATE POLICY "Admin can view all session photos"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'session-photos' 
  AND public.current_user_role() = 'super_admin'
);

-- Política para que admin suba fotos
CREATE POLICY "Super admin can upload photos" 
ON storage.objects FOR INSERT 
WITH CHECK (
  bucket_id = 'session-photos'
  AND public.current_user_role() = 'super_admin'
);

-- Política para que admin actualice fotos
CREATE POLICY "Super admin can update photos" 
ON storage.objects FOR UPDATE 
USING (
  bucket_id = 'session-photos'
  AND public.current_user_role() = 'super_admin'
);

-- Política para que admin elimine fotos
CREATE POLICY "Super admin can delete photos" 
ON storage.objects FOR DELETE 
USING (
  bucket_id = 'session-photos'
  AND public.current_user_role() = 'super_admin'
);

