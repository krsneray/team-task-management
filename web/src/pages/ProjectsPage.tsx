import { useMemo, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { Plus, Search } from 'lucide-react'
import { useAuth } from '../auth/AuthContext'
import { projectsApi } from '../api/endpoints'
import { getErrorMessage } from '../api/client'
import { Button, Card, EmptyState, ErrorState, Input, PageHeader, Pagination, ProgressBar, Spinner } from '../components/ui'
import { Modal } from '../components/Modal'
import { ProjectStatusBadge } from '../components/badges'
import { useToast } from '../components/Toast'
import { ProjectForm } from '../forms/ProjectForm'
import { useDashboardQuery, useProjectsQuery, qk } from '../hooks/queries'
import { deriveProjectStatus } from '../lib/projectStatus'
import { formatDate, norm, pageCount, paginate } from '../lib/format'

const PAGE_SIZE = 9

export function ProjectsPage() {
  const { isManagerRole } = useAuth()
  const { data: projects, isLoading, error, refetch } = useProjectsQuery()
  const { data: dashboard } = useDashboardQuery()
  const [params, setParams] = useSearchParams()
  const [creating, setCreating] = useState(false)
  const queryClient = useQueryClient()
  const toast = useToast()

  const q = params.get('q') ?? ''
  const page = Math.max(1, Number(params.get('page') ?? 1) || 1)

  const create = useMutation({
    mutationFn: projectsApi.create,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: qk.projects })
      void queryClient.invalidateQueries({ queryKey: qk.dashboard })
      toast.success('Proje oluşturuldu.')
      setCreating(false)
    },
  })

  const filtered = useMemo(
    () => (projects ?? []).filter((p) => norm(`${p.name} ${p.description ?? ''}`).includes(norm(q))),
    [projects, q],
  )
  const pages = pageCount(filtered.length, PAGE_SIZE)
  const current = Math.min(page, pages)
  const visible = paginate(filtered, current, PAGE_SIZE)

  const setParam = (key: string, value: string) => {
    const next = new URLSearchParams(params)
    if (value) next.set(key, value)
    else next.delete(key)
    if (key !== 'page') next.delete('page')
    setParams(next, { replace: true })
  }

  if (isLoading) return <Spinner />
  if (error) return <ErrorState message={getErrorMessage(error)} onRetry={() => void refetch()} />

  return (
    <div>
      <PageHeader
        title="Projeler"
        description="Dahil olduğun ve yönettiğin projeler."
        actions={
          isManagerRole && (
            <Button onClick={() => setCreating(true)}>
              <Plus className="h-4 w-4" aria-hidden /> Yeni proje
            </Button>
          )
        }
      />

      <div className="relative mb-4 max-w-sm">
        <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted" aria-hidden />
        <Input
          aria-label="Proje ara"
          placeholder="Proje ara..."
          className="pl-9"
          value={q}
          onChange={(e) => setParam('q', e.target.value)}
        />
      </div>

      <Card>
        {filtered.length === 0 ? (
          <EmptyState
            title={projects?.length ? 'Aramanla eşleşen proje yok' : 'Henüz proje yok'}
            description={projects?.length ? undefined : isManagerRole ? 'İlk projeni oluşturarak başla.' : 'Bir projeye eklendiğinde burada görünür.'}
          />
        ) : (
          <>
            <ul className="grid gap-4 p-4 sm:grid-cols-2 xl:grid-cols-3">
              {visible.map((p) => {
                const progress = dashboard?.projects.find((x) => x.projectId === p.id)
                return (
                  <li key={p.id}>
                    <Link to={`/projects/${p.id}`} className="block h-full rounded-xl border border-line p-4 transition hover:border-primary/60">
                      <div className="mb-2 flex items-start justify-between gap-2">
                        <h2 className="font-semibold text-ink">{p.name}</h2>
                        <ProjectStatusBadge status={deriveProjectStatus(progress)} />
                      </div>
                      <p className="line-clamp-2 min-h-[2.5rem] text-sm text-muted">{p.description || 'Açıklama yok.'}</p>
                      <div className="mt-3">
                        <ProgressBar value={progress?.progressPercent ?? 0} />
                      </div>
                      <p className="mt-2 text-xs text-muted">
                        {formatDate(p.startDate)} – {formatDate(p.targetEndDate)}
                      </p>
                    </Link>
                  </li>
                )
              })}
            </ul>
            <Pagination page={current} pages={pages} total={filtered.length} onChange={(n) => setParam('page', String(n))} />
          </>
        )}
      </Card>

      <Modal open={creating} title="Yeni proje" onClose={() => setCreating(false)}>
        <ProjectForm
          submitLabel="Oluştur"
          onSubmit={(v) => create.mutateAsync({ ...v, description: v.description || null })}
          onCancel={() => setCreating(false)}
        />
      </Modal>
    </div>
  )
}
