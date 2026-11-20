import { useState } from 'react'
import { Navigate, useLocation, useNavigate } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { ClipboardList } from 'lucide-react'
import { useAuth } from '../auth/AuthContext'
import { getErrorMessages } from '../api/client'
import { Alert, Button, Field, Input } from '../components/ui'
import { loginSchema, type LoginValues } from '../lib/schemas'

export function LoginPage() {
  const { user, login } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const from = (location.state as { from?: string } | null)?.from ?? '/'
  const [errors, setErrors] = useState<string[]>([])
  const {
    register,
    handleSubmit,
    formState: { errors: fieldErrors, isSubmitting },
  } = useForm<LoginValues>({ resolver: zodResolver(loginSchema) })

  if (user) return <Navigate to={from} replace />

  const submit = handleSubmit(async (values) => {
    setErrors([])
    try {
      await login(values.email, values.password)
      navigate(from, { replace: true })
    } catch (error) {
      setErrors(getErrorMessages(error))
    }
  })

  return (
    <div className="flex min-h-screen items-center justify-center bg-page px-4">
      <div className="w-full max-w-sm rounded-2xl border border-line bg-card p-6 shadow-sm">
        <div className="mb-6 flex flex-col items-center gap-2 text-center">
          <span className="flex h-12 w-12 items-center justify-center rounded-xl bg-primary text-primary-fg">
            <ClipboardList className="h-6 w-6" aria-hidden />
          </span>
          <h1 className="text-xl font-semibold text-ink">Team Task Manager</h1>
          <p className="text-sm text-muted">Devam etmek için giriş yapın.</p>
        </div>
        <form onSubmit={submit} className="space-y-4" noValidate>
          <Alert messages={errors} />
          <Field label="E-posta" htmlFor="login-email" error={fieldErrors.email?.message}>
            <Input id="login-email" type="email" autoComplete="username" {...register('email')} />
          </Field>
          <Field label="Şifre" htmlFor="login-password" error={fieldErrors.password?.message}>
            <Input id="login-password" type="password" autoComplete="current-password" {...register('password')} />
          </Field>
          <Button type="submit" loading={isSubmitting} className="w-full">
            Giriş yap
          </Button>
        </form>
      </div>
    </div>
  )
}
