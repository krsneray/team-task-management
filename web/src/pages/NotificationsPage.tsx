import { useNavigate } from 'react-router-dom'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { Bell } from 'lucide-react'
import { notificationsApi } from '../api/endpoints'
import { getErrorMessage } from '../api/client'
import { Button, Card, EmptyState, ErrorState, PageHeader, Spinner } from '../components/ui'
import { useToast } from '../components/Toast'
import { qk, useNotificationsQuery } from '../hooks/queries'
import { timeAgo } from '../lib/format'
import { NotificationType, type AppNotification } from '../types/api'

export function NotificationsPage() {
  const { data, isLoading, error, refetch } = useNotificationsQuery()
  const queryClient = useQueryClient()
  const navigate = useNavigate()
  const toast = useToast()

  const markRead = useMutation({
    mutationFn: notificationsApi.markRead,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: qk.notifications })
      void queryClient.invalidateQueries({ queryKey: qk.dashboard })
    },
    onError: (e) => toast.error(getErrorMessage(e)),
  })

  const markAll = async (items: AppNotification[]) => {
    await Promise.allSettled(items.map((n) => notificationsApi.markRead(n.id)))
    void queryClient.invalidateQueries({ queryKey: qk.notifications })
    void queryClient.invalidateQueries({ queryKey: qk.dashboard })
  }

  const open = (n: AppNotification) => {
    if (!n.isRead) markRead.mutate(n.id)
    // relatedEntityId: proje üyeliği bildiriminde proje, diğerlerinde görev kimliği
    navigate(n.type === NotificationType.ProjectMemberAdded ? `/projects/${n.relatedEntityId}` : `/tasks/${n.relatedEntityId}`)
  }

  if (isLoading) return <Spinner />
  if (error) return <ErrorState message={getErrorMessage(error)} onRetry={() => void refetch()} />

  const items = data ?? []
  const unread = items.filter((n) => !n.isRead)

  return (
    <div>
      <PageHeader
        title="Bildirimler"
        description={unread.length ? `${unread.length} okunmamış bildirim` : 'Tüm bildirimler okundu.'}
        actions={
          unread.length > 0 && (
            <Button variant="secondary" onClick={() => void markAll(unread)}>
              Tümünü okundu işaretle
            </Button>
          )
        }
      />
      <Card>
        {items.length === 0 ? (
          <EmptyState title="Bildirim yok" description="Yeni gelişmeler burada görünür." />
        ) : (
          <ul className="divide-y divide-line">
            {items.map((n) => (
              <li key={n.id}>
                <button
                  type="button"
                  onClick={() => open(n)}
                  className={`flex w-full items-start gap-3 px-4 py-3 text-left hover:bg-primary/5 ${n.isRead ? '' : 'bg-primary/5'}`}
                >
                  <Bell className={`mt-0.5 h-4 w-4 shrink-0 ${n.isRead ? 'text-muted' : 'text-primary'}`} aria-hidden />
                  <span className="min-w-0 flex-1">
                    <span className={`block text-sm ${n.isRead ? 'text-ink' : 'font-semibold text-ink'}`}>{n.title}</span>
                    <span className="block text-sm text-muted">{n.message}</span>
                    <span className="block text-xs text-muted">{timeAgo(n.createdDate)}</span>
                  </span>
                  {!n.isRead && <span className="mt-1 h-2 w-2 shrink-0 rounded-full bg-primary" aria-label="Okunmadı" />}
                </button>
              </li>
            ))}
          </ul>
        )}
      </Card>
    </div>
  )
}
