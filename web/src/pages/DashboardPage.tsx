import { Link } from 'react-router-dom'
import { AlertTriangle, CheckCircle2, FolderKanban, ListTodo, UserCheck } from 'lucide-react'
import type { ReactNode } from 'react'
import { useAuth } from '../auth/AuthContext'
import { Card, ErrorState, PageHeader, ProgressBar, Spinner, Avatar, EmptyState } from '../components/ui'
import { useDashboardQuery } from '../hooks/queries'
import { getErrorMessage } from '../api/client'
import { timeAgo } from '../lib/format'

function Stat({ icon, label, value, to, tone }: { icon: ReactNode; label: string; value: number; to?: string; tone?: string }) {
  const body = (
    <Card className="flex items-center gap-3 p-4 transition hover:border-primary/50">
      <span className={`flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 ${tone ?? 'text-primary'}`}>{icon}</span>
      <div>
        <p className="text-2xl font-semibold text-ink">{value}</p>
        <p className="text-xs text-muted">{label}</p>
      </div>
    </Card>
  )
  return to ? <Link to={to}>{body}</Link> : body
}

export function DashboardPage() {
  const { user, isManagerRole } = useAuth()
  const { data, isLoading, error, refetch } = useDashboardQuery()

  if (isLoading) return <Spinner />
  if (error || !data) return <ErrorState message={getErrorMessage(error)} onRetry={() => void refetch()} />

  return (
    <div>
      <PageHeader title={`Merhaba, ${user?.fullName.split(' ')[0] ?? ''}`} description="Projelerinin ve görevlerinin genel görünümü." />

      <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        <Stat icon={<FolderKanban className="h-5 w-5" />} label="Projeler" value={data.projectCount} to="/projects" />
        <Stat icon={<ListTodo className="h-5 w-5" />} label="Açık görevler" value={data.openTasks} to="/tasks" />
        <Stat icon={<AlertTriangle className="h-5 w-5" />} label="Geciken görevler" value={data.overdueTasks} to="/tasks?overdue=1" tone="text-danger" />
        <Stat icon={<CheckCircle2 className="h-5 w-5" />} label="Tamamlanan görevler" value={data.completedTasks} to="/tasks?status=3" tone="text-success" />
      </div>

      <div className="mt-3 grid gap-3 sm:grid-cols-2">
        <Stat icon={<UserCheck className="h-5 w-5" />} label="Bana atanan açık görevler" value={data.myOpenTasks} to="/tasks?mine=1" />
        <Stat icon={<AlertTriangle className="h-5 w-5" />} label="Bana atanan geciken görevler" value={data.myOverdueTasks} to="/tasks?mine=1&overdue=1" tone="text-danger" />
      </div>

      <div className="mt-6 grid gap-6 lg:grid-cols-2">
        <Card className="p-4">
          <h2 className="mb-3 font-semibold text-ink">Proje ilerlemesi</h2>
          {data.projects.length === 0 ? (
            <EmptyState title="Henüz proje yok" />
          ) : (
            <ul className="space-y-4">
              {data.projects.map((p) => (
                <li key={p.projectId}>
                  <div className="mb-1 flex justify-between text-sm">
                    <Link to={`/projects/${p.projectId}`} className="font-medium text-ink hover:text-primary">
                      {p.name}
                    </Link>
                    <span className="text-muted">
                      {p.completedTasks}/{p.totalTasks} · %{Math.round(p.progressPercent)}
                    </span>
                  </div>
                  <ProgressBar value={p.progressPercent} />
                  {p.overdueTasks > 0 && <p className="mt-1 text-xs text-danger">{p.overdueTasks} geciken görev</p>}
                </li>
              ))}
            </ul>
          )}
        </Card>

        <Card className="p-4">
          <h2 className="mb-3 font-semibold text-ink">Son hareketler</h2>
          {data.recentActivities.length === 0 ? (
            <EmptyState title="Henüz hareket yok" />
          ) : (
            <ul className="space-y-3">
              {data.recentActivities.map((a) => (
                <li key={a.id} className="flex gap-3 text-sm">
                  <Avatar name={a.userFullName} size={28} />
                  <div className="min-w-0">
                    <p className="text-ink">
                      <span className="font-medium">{a.userFullName}</span> · {a.description}
                    </p>
                    <Link to={`/tasks/${a.taskId}`} className="block truncate text-primary hover:underline">
                      {a.taskTitle}
                    </Link>
                    <p className="text-xs text-muted">{timeAgo(a.createdDate)}</p>
                  </div>
                </li>
              ))}
            </ul>
          )}
        </Card>

        {isManagerRole && (
          <Card className="p-4 lg:col-span-2">
            <h2 className="mb-3 font-semibold text-ink">Ekip iş yükü</h2>
            {data.workload.length === 0 ? (
              <EmptyState title="Veri yok" />
            ) : (
              <ul className="grid gap-3 sm:grid-cols-2">
                {data.workload.map((w) => (
                  <li key={w.userId} className="flex items-center gap-3 text-sm">
                    <Avatar name={w.fullName} size={28} />
                    <span className="flex-1 truncate text-ink">{w.fullName}</span>
                    <span className="text-muted">{w.openTasks} açık · {w.completedTasks} biten</span>
                  </li>
                ))}
              </ul>
            )}
          </Card>
        )}
      </div>
    </div>
  )
}
