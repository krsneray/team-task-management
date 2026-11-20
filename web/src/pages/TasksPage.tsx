import { useMemo, useState, type DragEvent } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { KanbanSquare, List, Plus, Search } from 'lucide-react'
import { useAuth } from '../auth/AuthContext'
import { tasksApi } from '../api/endpoints'
import { getErrorMessage } from '../api/client'
import { Button, Card, EmptyState, ErrorState, Input, PageHeader, Pagination, Select, Spinner } from '../components/ui'
import { Modal } from '../components/Modal'
import { PriorityBadge, StatusBadge } from '../components/badges'
import { useToast } from '../components/Toast'
import { TaskForm } from '../forms/TaskForm'
import { qk, useProjectsQuery, useTasksQuery, useUserName } from '../hooks/queries'
import { toTaskCreateInput } from '../lib/taskInput'
import { formatDate, isOverdue, norm, pageCount, paginate } from '../lib/format'
import {
  TASK_PRIORITY_LABELS,
  TASK_STATUS_LABELS,
  TaskStatus,
  type Task,
  type TaskStatus as Status,
} from '../types/api'

const PAGE_SIZE = 10
const BOARD_COLUMNS: Status[] = [TaskStatus.New, TaskStatus.InProgress, TaskStatus.OnHold, TaskStatus.Completed, TaskStatus.Cancelled]

type SortKey = 'due' | 'priority' | 'title' | 'created'

export function TasksPage() {
  const { user, isManagerRole } = useAuth()
  const { data: tasks, isLoading, error, refetch } = useTasksQuery()
  const { data: projects = [] } = useProjectsQuery()
  const nameOf = useUserName()
  const [params, setParams] = useSearchParams()
  const [creating, setCreating] = useState(false)
  const [dragOver, setDragOver] = useState<number | null>(null)
  const queryClient = useQueryClient()
  const toast = useToast()

  const q = params.get('q') ?? ''
  const status = params.get('status') ?? ''
  const priority = params.get('priority') ?? ''
  const projectId = params.get('project') ?? ''
  const mine = params.get('mine') === '1'
  const overdue = params.get('overdue') === '1'
  const sort = (params.get('sort') as SortKey) || 'due'
  const view = params.get('view') === 'board' ? 'board' : 'list'
  const page = Math.max(1, Number(params.get('page') ?? 1) || 1)

  const setParam = (key: string, value: string) => {
    const next = new URLSearchParams(params)
    if (value) next.set(key, value)
    else next.delete(key)
    if (key !== 'page') next.delete('page')
    setParams(next, { replace: true })
  }

  const create = useMutation({
    mutationFn: tasksApi.create,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: qk.tasks })
      void queryClient.invalidateQueries({ queryKey: qk.dashboard })
      toast.success('Görev oluşturuldu.')
      setCreating(false)
    },
  })

  const move = useMutation({
    mutationFn: ({ id, status: s }: { id: number; status: Status }) => tasksApi.updateStatus(id, s),
    onMutate: async ({ id, status: s }) => {
      await queryClient.cancelQueries({ queryKey: qk.tasks })
      const previous = queryClient.getQueryData<Task[]>(qk.tasks)
      queryClient.setQueryData<Task[]>(qk.tasks, (old) => old?.map((t) => (t.id === id ? { ...t, status: s } : t)))
      return { previous }
    },
    onError: (e, _v, ctx) => {
      if (ctx?.previous) queryClient.setQueryData(qk.tasks, ctx.previous)
      toast.error(getErrorMessage(e))
    },
    onSettled: () => {
      void queryClient.invalidateQueries({ queryKey: qk.tasks })
      void queryClient.invalidateQueries({ queryKey: qk.dashboard })
    },
  })

  const filtered = useMemo(() => {
    const list = (tasks ?? []).filter((t) => {
      if (q && !norm(`${t.title} ${t.description ?? ''}`).includes(norm(q))) return false
      if (status !== '' && t.status !== Number(status)) return false
      if (priority !== '' && t.priority !== Number(priority)) return false
      if (projectId && t.projectId !== Number(projectId)) return false
      if (mine && t.assignedUserId !== user?.userId) return false
      if (overdue && !isOverdue(t)) return false
      return true
    })
    const sorters: Record<SortKey, (a: Task, b: Task) => number> = {
      due: (a, b) => a.dueDate.localeCompare(b.dueDate),
      priority: (a, b) => b.priority - a.priority,
      title: (a, b) => a.title.localeCompare(b.title, 'tr'),
      created: (a, b) => b.createdDate.localeCompare(a.createdDate),
    }
    return [...list].sort(sorters[sort] ?? sorters.due)
  }, [tasks, q, status, priority, projectId, mine, overdue, sort, user?.userId])

  const projectName = (id: number) => projects.find((p) => p.id === id)?.name ?? '-'
  const pages = pageCount(filtered.length, PAGE_SIZE)
  const current = Math.min(page, pages)
  const hasFilters = !!(q || status || priority || projectId || mine || overdue)

  if (isLoading) return <Spinner />
  if (error) return <ErrorState message={getErrorMessage(error)} onRetry={() => void refetch()} />

  const onDrop = (e: DragEvent, target: Status) => {
    e.preventDefault()
    setDragOver(null)
    const id = Number(e.dataTransfer.getData('text/plain'))
    const task = (tasks ?? []).find((t) => t.id === id)
    if (task && task.status !== target) move.mutate({ id, status: target })
  }

  return (
    <div>
      <PageHeader
        title="Görevler"
        description="Görevleri filtrele, sırala ve durumlarını güncelle."
        actions={
          <>
            <div className="inline-flex overflow-hidden rounded-lg border border-line" role="group" aria-label="Görünüm">
              <button
                type="button"
                aria-pressed={view === 'list'}
                onClick={() => setParam('view', '')}
                className={`flex items-center gap-1 px-3 py-1.5 text-sm ${view === 'list' ? 'bg-primary text-primary-fg' : 'text-muted hover:bg-primary/10'}`}
              >
                <List className="h-4 w-4" aria-hidden /> Liste
              </button>
              <button
                type="button"
                aria-pressed={view === 'board'}
                onClick={() => setParam('view', 'board')}
                className={`flex items-center gap-1 px-3 py-1.5 text-sm ${view === 'board' ? 'bg-primary text-primary-fg' : 'text-muted hover:bg-primary/10'}`}
              >
                <KanbanSquare className="h-4 w-4" aria-hidden /> Pano
              </button>
            </div>
            {isManagerRole && (
              <Button onClick={() => setCreating(true)}>
                <Plus className="h-4 w-4" aria-hidden /> Yeni görev
              </Button>
            )}
          </>
        }
      />

      <div className="mb-4 grid gap-3 sm:grid-cols-2 lg:grid-cols-6">
        <div className="relative lg:col-span-2">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted" aria-hidden />
          <Input aria-label="Görev ara" placeholder="Görev ara..." className="pl-9" value={q} onChange={(e) => setParam('q', e.target.value)} />
        </div>
        <Select aria-label="Durum" value={status} onChange={(e) => setParam('status', e.target.value)}>
          <option value="">Tüm durumlar</option>
          {BOARD_COLUMNS.map((s) => (
            <option key={s} value={s}>
              {TASK_STATUS_LABELS[s]}
            </option>
          ))}
        </Select>
        <Select aria-label="Öncelik" value={priority} onChange={(e) => setParam('priority', e.target.value)}>
          <option value="">Tüm öncelikler</option>
          {Object.entries(TASK_PRIORITY_LABELS).map(([k, label]) => (
            <option key={k} value={k}>
              {label}
            </option>
          ))}
        </Select>
        <Select aria-label="Proje" value={projectId} onChange={(e) => setParam('project', e.target.value)}>
          <option value="">Tüm projeler</option>
          {projects.map((p) => (
            <option key={p.id} value={p.id}>
              {p.name}
            </option>
          ))}
        </Select>
        <Select aria-label="Sıralama" value={sort} onChange={(e) => setParam('sort', e.target.value === 'due' ? '' : e.target.value)}>
          <option value="due">Bitiş tarihi</option>
          <option value="priority">Öncelik</option>
          <option value="title">Başlık</option>
          <option value="created">En yeni</option>
        </Select>
      </div>

      <div className="mb-4 flex flex-wrap gap-4 text-sm">
        <label className="inline-flex items-center gap-2 text-ink">
          <input type="checkbox" checked={mine} onChange={(e) => setParam('mine', e.target.checked ? '1' : '')} />
          Bana atananlar
        </label>
        <label className="inline-flex items-center gap-2 text-ink">
          <input type="checkbox" checked={overdue} onChange={(e) => setParam('overdue', e.target.checked ? '1' : '')} />
          Gecikenler
        </label>
        {hasFilters && (
          <button type="button" className="text-primary hover:underline" onClick={() => setParams({}, { replace: true })}>
            Filtreleri temizle
          </button>
        )}
      </div>

      {view === 'list' ? (
        <Card>
          {filtered.length === 0 ? (
            <EmptyState
              title={hasFilters ? 'Filtrelerle eşleşen görev yok' : 'Henüz görev yok'}
              description={hasFilters ? 'Filtreleri değiştirmeyi dene.' : undefined}
            />
          ) : (
            <>
              <ul className="divide-y divide-line">
                {paginate(filtered, current, PAGE_SIZE).map((t) => (
                  <li key={t.id}>
                    <Link to={`/tasks/${t.id}`} className="flex flex-wrap items-center gap-3 px-4 py-3 hover:bg-primary/5">
                      <div className="min-w-0 flex-1">
                        <p className="truncate font-medium text-ink">{t.title}</p>
                        <p className="truncate text-xs text-muted">
                          {projectName(t.projectId)} · {nameOf(t.assignedUserId)}
                        </p>
                      </div>
                      <span className={`text-xs ${isOverdue(t) ? 'font-medium text-danger' : 'text-muted'}`}>
                        {isOverdue(t) ? 'Gecikti · ' : ''}
                        {formatDate(t.dueDate)}
                      </span>
                      <PriorityBadge priority={t.priority} />
                      <StatusBadge status={t.status} />
                    </Link>
                  </li>
                ))}
              </ul>
              <Pagination page={current} pages={pages} total={filtered.length} onChange={(n) => setParam('page', String(n))} />
            </>
          )}
        </Card>
      ) : (
        <div className="grid auto-cols-[minmax(220px,1fr)] grid-flow-col gap-3 overflow-x-auto pb-2">
          {BOARD_COLUMNS.map((col) => {
            const items = filtered.filter((t) => t.status === col)
            return (
              <section
                key={col}
                aria-label={TASK_STATUS_LABELS[col]}
                onDragOver={(e) => {
                  e.preventDefault()
                  setDragOver(col)
                }}
                onDragLeave={() => setDragOver((c) => (c === col ? null : c))}
                onDrop={(e) => onDrop(e, col)}
                className={`rounded-xl border p-2 ${dragOver === col ? 'border-primary bg-primary/5' : 'border-line bg-card'}`}
              >
                <h2 className="mb-2 flex items-center justify-between px-1 text-sm font-semibold text-ink">
                  {TASK_STATUS_LABELS[col]}
                  <span className="text-xs font-normal text-muted">{items.length}</span>
                </h2>
                <ul className="space-y-2">
                  {items.map((t) => (
                    <li
                      key={t.id}
                      draggable
                      onDragStart={(e) => e.dataTransfer.setData('text/plain', String(t.id))}
                      className="cursor-grab rounded-lg border border-line bg-page p-2 text-sm active:cursor-grabbing"
                    >
                      <Link to={`/tasks/${t.id}`} className="font-medium text-ink hover:text-primary">
                        {t.title}
                      </Link>
                      <p className="mt-1 truncate text-xs text-muted">{nameOf(t.assignedUserId)}</p>
                      <div className="mt-2 flex items-center justify-between">
                        <PriorityBadge priority={t.priority} />
                        <span className={`text-xs ${isOverdue(t) ? 'text-danger' : 'text-muted'}`}>{formatDate(t.dueDate)}</span>
                      </div>
                    </li>
                  ))}
                  {items.length === 0 && <li className="px-1 py-4 text-center text-xs text-muted">Görev yok</li>}
                </ul>
              </section>
            )
          })}
        </div>
      )}

      <Modal open={creating} title="Yeni görev" onClose={() => setCreating(false)} wide>
        <TaskForm
          onSubmit={(v) => create.mutateAsync(toTaskCreateInput(v))}
          onCancel={() => setCreating(false)}
        />
      </Modal>
    </div>
  )
}
