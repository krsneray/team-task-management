import { useState } from 'react'
import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { Bell, CheckSquare, FolderKanban, LayoutDashboard, LogOut, Menu, Moon, Sun, Users, X } from 'lucide-react'
import { useAuth } from '../auth/AuthContext'
import { useNotificationsQuery } from '../hooks/queries'
import { useTheme } from '../hooks/useTheme'
import { ROLE_LABELS } from '../types/api'
import { Avatar, cx } from './ui'

export function Layout() {
  const { user, logout, isAdmin } = useAuth()
  const navigate = useNavigate()
  const { dark, toggle } = useTheme()
  const [open, setOpen] = useState(false)
  const { data: notifications } = useNotificationsQuery()
  const unread = notifications?.filter((n) => !n.isRead).length ?? 0

  const links = [
    { to: '/', label: 'Dashboard', icon: LayoutDashboard, end: true },
    { to: '/projects', label: 'Projeler', icon: FolderKanban },
    { to: '/tasks', label: 'Görevler', icon: CheckSquare },
    { to: '/notifications', label: 'Bildirimler', icon: Bell, badge: unread },
    ...(isAdmin ? [{ to: '/users', label: 'Kullanıcılar', icon: Users }] : []),
  ]

  const roleLabel = user?.roles.map((r) => ROLE_LABELS[r] ?? r).join(', ') ?? ''

  const nav = (
    <nav className="flex flex-1 flex-col gap-1 px-3" aria-label="Ana menü">
      {links.map(({ to, label, icon: Icon, end, badge }) => (
        <NavLink
          key={to}
          to={to}
          end={end}
          onClick={() => setOpen(false)}
          className={({ isActive }) =>
            cx(
              'flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors',
              isActive ? 'bg-white/15 text-white' : 'text-white/65 hover:bg-white/10 hover:text-white',
            )
          }
        >
          <Icon className="h-5 w-5" aria-hidden />
          <span className="flex-1">{label}</span>
          {!!badge && (
            <span className="rounded-full bg-danger px-1.5 py-0.5 text-[11px] font-semibold leading-none text-white">
              {badge > 99 ? '99+' : badge}
            </span>
          )}
        </NavLink>
      ))}
    </nav>
  )

  const brand = (
    <div className="flex items-center gap-3 px-5 py-5">
      <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-primary-fg">
        <CheckSquare className="h-5 w-5" aria-hidden />
      </span>
      <span className="text-base font-semibold leading-tight text-white">
        Team Task
        <br />
        Manager
      </span>
    </div>
  )

  return (
    <div className="flex min-h-full">
      {/* Masaüstü yan menü */}
      <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col bg-sidebar lg:flex">
        {brand}
        {nav}
      </aside>

      {/* Mobil yan menü */}
      {open && (
        <div className="fixed inset-0 z-40 lg:hidden">
          <div className="absolute inset-0 bg-black/50" onClick={() => setOpen(false)} aria-hidden />
          <aside className="relative flex h-full w-64 flex-col bg-sidebar">
            <button
              onClick={() => setOpen(false)}
              aria-label="Menüyü kapat"
              className="absolute right-3 top-4 rounded-md p-1 text-white/70 hover:text-white"
            >
              <X className="h-5 w-5" />
            </button>
            {brand}
            {nav}
          </aside>
        </div>
      )}

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="sticky top-0 z-30 flex items-center gap-3 border-b border-line bg-card/90 px-4 py-3 backdrop-blur sm:px-6">
          <button
            onClick={() => setOpen(true)}
            aria-label="Menüyü aç"
            className="rounded-md p-1.5 text-muted hover:bg-ink/5 hover:text-ink lg:hidden"
          >
            <Menu className="h-5 w-5" />
          </button>
          <div className="flex-1" />
          <button
            onClick={toggle}
            aria-label={dark ? 'Açık temaya geç' : 'Koyu temaya geç'}
            className="rounded-lg p-2 text-muted hover:bg-ink/5 hover:text-ink"
          >
            {dark ? <Sun className="h-5 w-5" /> : <Moon className="h-5 w-5" />}
          </button>
          <button
            onClick={() => navigate('/notifications')}
            aria-label={`Bildirimler${unread ? `, ${unread} okunmamış` : ''}`}
            className="relative rounded-lg p-2 text-muted hover:bg-ink/5 hover:text-ink"
          >
            <Bell className="h-5 w-5" />
            {unread > 0 && (
              <span className="absolute right-1 top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-danger px-1 text-[10px] font-semibold text-white">
                {unread > 9 ? '9+' : unread}
              </span>
            )}
          </button>
          <div className="mx-1 hidden h-8 w-px bg-line sm:block" />
          <div className="flex items-center gap-3">
            <Avatar name={user?.fullName ?? '?'} size={36} />
            <div className="hidden leading-tight sm:block">
              <p className="text-sm font-medium text-ink">{user?.fullName}</p>
              <p className="text-xs text-muted">{roleLabel}</p>
            </div>
            <button
              onClick={logout}
              aria-label="Çıkış yap"
              title="Çıkış yap"
              className="rounded-lg p-2 text-muted hover:bg-ink/5 hover:text-danger"
            >
              <LogOut className="h-5 w-5" />
            </button>
          </div>
        </header>

        <main className="mx-auto w-full max-w-7xl flex-1 px-4 py-6 sm:px-6 sm:py-8">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
