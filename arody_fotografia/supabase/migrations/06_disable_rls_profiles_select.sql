-- Solución: Permitir a usuarios autenticados ver todos los profiles
-- La seguridad real está en sessions y session_assets
-- Profiles solo contiene información básica no sensible (nombre, teléfono)

-- Eliminar todas las políticas de SELECT problemáticas
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Super admins can view all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Users can view own profile or admin can view all" ON public.profiles;
DROP FUNCTION IF EXISTS public.current_user_role();

-- Permitir a todos los usuarios autenticados ver todos los profiles
-- Esto es seguro porque profiles solo tiene información básica (nombre, teléfono)
-- La información sensible (sesiones, fotos) está protegida por sus propias políticas
CREATE POLICY "Authenticated users can view all profiles" 
ON public.profiles FOR SELECT 
TO authenticated
USING (true);

-- Las políticas de INSERT y UPDATE siguen siendo restrictivas
-- (solo puedes insertar/actualizar tu propio perfil)

