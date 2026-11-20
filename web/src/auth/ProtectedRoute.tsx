import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { useAuth } from './AuthContext'
import type { RoleName } from '../types/api'

/** Giriş yapmamış kullanıcıyı login sayfasına yönlendirir. */
export function ProtectedRoute() {
  const { user } = useAuth()
  const location = useLocation()
  if (!user) return <Navigate to="/login" replace state={{ from: location.pathname + location.search }} />
  return <Outlet />
}

/** Rol bazlı rota. Yetkinin asıl kaynağı API'dir; bu yalnızca arayüzü sadeleştirir. */
export function RoleRoute({ roles }: { roles: RoleName[] }) {
  const { hasRole } = useAuth()
  if (!hasRole(...roles)) return <Navigate to="/" replace />
  return <Outlet />
}
