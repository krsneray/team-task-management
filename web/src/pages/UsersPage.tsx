import { useMemo, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { Search, UserPlus } from 'lucide-react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useAuth } from '../auth/AuthContext'
import { authApi, usersApi } from '../api/endpoints'
import { getErrorMessage, getErrorMessages } from '../api/client'
import { Alert, Avatar, Button, Card, EmptyState, ErrorState, Field, Input, PageHeader, Pagination, Select, Spinner } from '../components/ui'
import { Modal } from '../components/Modal'
import { RoleBadge } from '../components/badges'
import { useToast } from '../components/Toast'
import { qk, useUsersQuery } from '../hooks/queries'
import { norm, pageCount, paginate } from '../lib/format'
import { registerSchema, type RegisterValues } from '../lib/schemas'
import { ROLE_LABELS, type AppUser } from '../types/api'

const PAGE_SIZE = 10

export function UsersPage() {
  const { user: me } = useAuth()
  const { data, isLoading, error, refetch } = useUsersQuery()
  const [params, setParams] = useSearchParams()
  const [roleTarget, setRoleTarget] = useState<AppUser | null>(null)
  const [role, setRole] = useState('TeamMember')
  const [roleErrors, setRoleErrors] = useState<string[]>([])
  const [registering, setRegistering] = useState(false)
  const queryClient = useQueryClient()
  const toast = useToast()

  const q = params.get('q') ?? ''
  const page = Math.max(1, Number(params.get('page') ?? 1) || 1)
  const setParam = (key: string, value: string) => {
    const next = new URLSearchParams(params)
    if (value) next.set(key, value)
    else next.delete(key)
    if (key !== 'page') next.delete('page')
    setParams(next, { replace: true })
  }

  const refresh = () => void queryClient.invalidateQueries({ queryKey: qk.users })

  const setActive = useMutation({
    mutationFn: ({ id, active }: { id: string; active: boolean }) => usersApi.setActive(id, active),
    onSuccess: (_d, v) => {
      refresh()
      toast.success(v.active ? 'Kullanıcı aktifleştirildi.' : 'Kullanıcı pasifleştirildi.')
    },
    onError: (e) => toast.error(getErrorMessage(e)),
  })
  const assign = useMutation({
    mutationFn: ({ email, r }: { email: string; r: string }) => authApi.assignRole(email, r),
    onSuccess: () => {
      refresh()
      toast.success('Rol eklendi.')
      setRoleTarget(null)
    },
    onError: (e) => setRoleErrors(getErrorMessages(e)),
  })
  const register = useMutation({
    mutationFn: authApi.register,
    onSuccess: () => {
      refresh()
      toast.success('Kullanıcı oluşturuldu.')
      setRegistering(false)
    },
  })

  const filtered = useMemo(
    () => (data ?? []).filter((u) => norm(`${u.fullName} ${u.email}`).includes(norm(q))),
    [data, q],
  )
  const pages = pageCount(filtered.length, PAGE_SIZE)
  const current = Math.min(page, pages)

  if (isLoading) return <Spinner />
  if (error) return <ErrorState message={getErrorMessage(error)} onRetry={() => void refetch()} />

  return (
    <div>
      <PageHeader
        title="Kullanıcılar"
        description="Kullanıcıları ara, rol ekle, aktif/pasif yap."
        actions={
          <Button onClick={() => setRegistering(true)}>
            <UserPlus className="h-4 w-4" aria-hidden /> Yeni kullanıcı
          </Button>
        }
      />
      <div className="relative mb-4 max-w-sm">
        <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted" aria-hidden />
        <Input aria-label="Kullanıcı ara" placeholder="Ad veya e-posta ara..." className="pl-9" value={q} onChange={(e) => setParam('q', e.target.value)} />
      </div>
      <Card>
        {filtered.length === 0 ? (
          <EmptyState title="Kullanıcı bulunamadı" />
        ) : (
          <>
            <ul className="divide-y divide-line">
              {paginate(filtered, current, PAGE_SIZE).map((u) => (
                <li key={u.id} className="flex flex-wrap items-center gap-3 px-4 py-3">
                  <Avatar name={u.fullName} size={36} />
                  <div className="min-w-0 flex-1">
                    <p className="truncate font-medium text-ink">
                      {u.fullName} {!u.isActive && <span className="text-xs text-danger">(pasif)</span>}
                    </p>
                    <p className="truncate text-xs text-muted">{u.email}</p>
                  </div>
                  <div className="flex flex-wrap gap-1">
                    {u.roles.map((r) => (
                      <RoleBadge key={r} label={ROLE_LABELS[r] ?? r} />
                    ))}
                  </div>
                  <Button size="sm" variant="secondary" onClick={() => { setRoleErrors([]); setRole('TeamMember'); setRoleTarget(u) }}>
                    Rol ekle
                  </Button>
                  <Button
                    size="sm"
                    variant={u.isActive ? 'danger' : 'secondary'}
                    disabled={u.id === me?.userId || setActive.isPending}
                    onClick={() => setActive.mutate({ id: u.id, active: !u.isActive })}
                  >
                    {u.isActive ? 'Pasifleştir' : 'Aktifleştir'}
                  </Button>
                </li>
              ))}
            </ul>
            <Pagination page={current} pages={pages} total={filtered.length} onChange={(n) => setParam('page', String(n))} />
          </>
        )}
      </Card>

      <Modal open={!!roleTarget} title={`Rol ekle: ${roleTarget?.fullName ?? ''}`} onClose={() => setRoleTarget(null)}>
        <div className="space-y-4">
          <Alert messages={roleErrors} />
          <Select aria-label="Rol" value={role} onChange={(e) => setRole(e.target.value)}>
            {Object.entries(ROLE_LABELS).map(([k, label]) => (
              <option key={k} value={k}>
                {label}
              </option>
            ))}
          </Select>
          <p className="text-xs text-muted">Rol eklenir, mevcut roller kaldırılmaz.</p>
          <div className="flex justify-end gap-2">
            <Button variant="secondary" onClick={() => setRoleTarget(null)}>
              Vazgeç
            </Button>
            <Button loading={assign.isPending} onClick={() => roleTarget && assign.mutate({ email: roleTarget.email, r: role })}>
              Ekle
            </Button>
          </div>
        </div>
      </Modal>

      <Modal open={registering} title="Yeni kullanıcı" onClose={() => setRegistering(false)}>
        <RegisterForm onSubmit={(v) => register.mutateAsync(v)} onCancel={() => setRegistering(false)} />
      </Modal>
    </div>
  )
}

function RegisterForm({ onSubmit, onCancel }: { onSubmit: (v: RegisterValues) => Promise<unknown>; onCancel: () => void }) {
  const [serverErrors, setServerErrors] = useState<string[]>([])
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<RegisterValues>({ resolver: zodResolver(registerSchema) })
  const submit = handleSubmit(async (v) => {
    setServerErrors([])
    try {
      await onSubmit(v)
    } catch (e) {
      setServerErrors(getErrorMessages(e))
    }
  })
  return (
    <form onSubmit={submit} className="space-y-4" noValidate>
      <Alert messages={serverErrors} />
      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Ad" htmlFor="reg-first" required error={errors.firstName?.message}>
          <Input id="reg-first" {...register('firstName')} />
        </Field>
        <Field label="Soyad" htmlFor="reg-last" required error={errors.lastName?.message}>
          <Input id="reg-last" {...register('lastName')} />
        </Field>
      </div>
      <Field label="E-posta" htmlFor="reg-email" required error={errors.email?.message}>
        <Input id="reg-email" type="email" {...register('email')} />
      </Field>
      <Field label="Şifre" htmlFor="reg-password" required error={errors.password?.message}>
        <Input id="reg-password" type="password" autoComplete="new-password" {...register('password')} />
      </Field>
      <div className="flex justify-end gap-2">
        <Button variant="secondary" onClick={onCancel}>
          Vazgeç
        </Button>
        <Button type="submit" loading={isSubmitting}>
          Oluştur
        </Button>
      </div>
    </form>
  )
}
