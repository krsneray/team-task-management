import { describe, expect, it, vi, beforeEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { MemoryRouter } from 'react-router-dom'
import type { ReactNode } from 'react'
import { AuthProvider } from '../auth/AuthContext'
import { ToastProvider } from '../components/Toast'
import { LoginPage } from './LoginPage'
import { TasksPage } from './TasksPage'
import { api } from '../api/client'

function wrap(ui: ReactNode, route = '/') {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } })
  return render(
    <QueryClientProvider client={client}>
      <MemoryRouter initialEntries={[route]}>
        <ToastProvider>
          <AuthProvider>{ui}</AuthProvider>
        </ToastProvider>
      </MemoryRouter>
    </QueryClientProvider>,
  )
}

beforeEach(() => {
  localStorage.clear()
  vi.restoreAllMocks()
})

describe('LoginPage', () => {
  it('boş formda doğrulama mesajları gösterir', async () => {
    wrap(<LoginPage />)
    await userEvent.click(screen.getByRole('button', { name: 'Giriş yap' }))
    expect(await screen.findByText('E-posta zorunludur.')).toBeInTheDocument()
    expect(screen.getByText('Şifre zorunludur.')).toBeInTheDocument()
  })

  it('API hatasını ekranda gösterir', async () => {
    vi.spyOn(api, 'post').mockRejectedValue({
      isAxiosError: true,
      response: { status: 401, data: { title: 'Yetkisiz', statusCode: 401, errors: ['E-posta veya şifre hatalı.'] } },
    })
    wrap(<LoginPage />)
    await userEvent.type(screen.getByLabelText('E-posta'), 'a@b.co')
    await userEvent.type(screen.getByLabelText('Şifre'), 'yanlis')
    await userEvent.click(screen.getByRole('button', { name: 'Giriş yap' }))
    await waitFor(() => expect(screen.getByRole('alert')).toHaveTextContent('E-posta veya şifre hatalı.'))
  })
})

describe('TasksPage', () => {
  it('görev yoksa boş durumu gösterir', async () => {
    vi.spyOn(api, 'get').mockResolvedValue({ data: [] })
    wrap(<TasksPage />, '/tasks')
    expect(await screen.findByText('Henüz görev yok')).toBeInTheDocument()
  })

  it('hata olursa hata durumunu gösterir', async () => {
    vi.spyOn(api, 'get').mockRejectedValue(new Error('ağ hatası'))
    wrap(<TasksPage />, '/tasks')
    expect(await screen.findByRole('alert')).toBeInTheDocument()
  })
})
