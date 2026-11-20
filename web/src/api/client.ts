import axios, { AxiosError } from 'axios'
import { clearAuth, getToken } from '../auth/storage'
import type { ApiErrorBody } from '../types/api'

export const API_URL: string = import.meta.env.VITE_API_URL ?? 'http://localhost:5052'

export const api = axios.create({ baseURL: API_URL })

let onUnauthorized: (() => void) | null = null

/** 401 gelince oturumu kapatıp login sayfasına yönlendirmek için AuthProvider tarafından kaydedilir. */
export function setUnauthorizedHandler(handler: (() => void) | null): void {
  onUnauthorized = handler
}

api.interceptors.request.use((config) => {
  const token = getToken()
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

api.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    const isLogin = error.config?.url?.includes('/api/Auth/login')
    if (error.response?.status === 401 && !isLogin) {
      clearAuth()
      onUnauthorized?.()
    }
    return Promise.reject(error)
  },
)

/** API hatasından kullanıcıya gösterilecek mesajları çıkarır. */
export function getErrorMessages(error: unknown): string[] {
  if (axios.isAxiosError(error)) {
    if (!error.response) return ['Sunucuya ulaşılamadı. Bağlantınızı kontrol edip tekrar deneyin.']
    const data = error.response.data as ApiErrorBody | string | undefined
    if (typeof data === 'string' && data.trim()) return [data]
    if (data && typeof data === 'object') {
      if (Array.isArray(data.errors) && data.errors.length > 0) return data.errors
      if (data.title) return [data.title]
    }
    if (error.response.status === 403) return ['Bu işlem için yetkiniz yok.']
    if (error.response.status === 404) return ['Kayıt bulunamadı.']
    if (error.response.status >= 500) return ['Sunucuda beklenmeyen bir hata oluştu.']
    return ['İşlem tamamlanamadı.']
  }
  if (error instanceof Error) return [error.message]
  return ['Beklenmeyen bir hata oluştu.']
}

export function getErrorMessage(error: unknown): string {
  return getErrorMessages(error).join(' ')
}
