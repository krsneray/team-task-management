import type { AuthResponse } from '../types/api'

const KEY = 'ttm_auth'

export function loadAuth(): AuthResponse | null {
  try {
    const raw = localStorage.getItem(KEY)
    if (!raw) return null
    const auth = JSON.parse(raw) as AuthResponse
    if (!auth.token || new Date(auth.expiresAt).getTime() <= Date.now()) {
      localStorage.removeItem(KEY)
      return null
    }
    return auth
  } catch {
    return null
  }
}

export function saveAuth(auth: AuthResponse): void {
  try {
    localStorage.setItem(KEY, JSON.stringify(auth))
  } catch {
    /* depolama kapalıysa oturum yalnızca bellekte kalır */
  }
}

export function clearAuth(): void {
  try {
    localStorage.removeItem(KEY)
  } catch {
    /* yoksay */
  }
}

export function getToken(): string | null {
  return loadAuth()?.token ?? null
}
