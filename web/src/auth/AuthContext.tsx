import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react'
import { useQueryClient } from '@tanstack/react-query'
import { authApi } from '../api/endpoints'
import { setUnauthorizedHandler } from '../api/client'
import { clearAuth, loadAuth, saveAuth } from './storage'
import type { AuthResponse, Project, RoleName } from '../types/api'

interface AuthContextValue {
  user: AuthResponse | null
  isAdmin: boolean
  /** Admin veya Proje Yöneticisi */
  isManagerRole: boolean
  login: (email: string, password: string) => Promise<void>
  logout: () => void
  hasRole: (...roles: RoleName[]) => boolean
  /** Proje düzenleme/silme/üye yönetimi yalnızca projenin yöneticisine açıktır. */
  canManageProject: (project: Pick<Project, 'managerUserId'>) => boolean
}

const AuthContext = createContext<AuthContextValue | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthResponse | null>(() => loadAuth())
  const queryClient = useQueryClient()

  const logout = useCallback(() => {
    clearAuth()
    setUser(null)
    queryClient.clear()
  }, [queryClient])

  useEffect(() => {
    setUnauthorizedHandler(logout)
    return () => setUnauthorizedHandler(null)
  }, [logout])

  const login = useCallback(
    async (email: string, password: string) => {
      const auth = await authApi.login(email, password)
      queryClient.clear()
      saveAuth(auth)
      setUser(auth)
    },
    [queryClient],
  )

  const value = useMemo<AuthContextValue>(() => {
    const roles = user?.roles ?? []
    const hasRole = (...wanted: RoleName[]) => wanted.some((r) => roles.includes(r))
    const isAdmin = roles.includes('Admin')
    const isManagerRole = isAdmin || roles.includes('ProjectManager')
    return {
      user,
      isAdmin,
      isManagerRole,
      login,
      logout,
      hasRole,
      canManageProject: (project) => isManagerRole && !!user && project.managerUserId === user.userId,
    }
  }, [user, login, logout])

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth, AuthProvider içinde kullanılmalıdır.')
  return ctx
}
