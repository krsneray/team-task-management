import { useCallback } from 'react'
import { useQuery } from '@tanstack/react-query'
import {
  attachmentsApi,
  commentsApi,
  dashboardApi,
  notificationsApi,
  projectsApi,
  tasksApi,
  usersApi,
} from '../api/endpoints'

export const qk = {
  projects: ['projects'] as const,
  project: (id: number) => ['project', id] as const,
  members: (id: number) => ['members', id] as const,
  tasks: ['tasks'] as const,
  task: (id: number) => ['task', id] as const,
  comments: (taskId: number) => ['comments', taskId] as const,
  attachments: (taskId: number) => ['attachments', taskId] as const,
  notifications: ['notifications'] as const,
  users: ['users'] as const,
  dashboard: ['dashboard'] as const,
}

export const useProjectsQuery = () => useQuery({ queryKey: qk.projects, queryFn: projectsApi.list })
export const useProjectQuery = (id: number) =>
  useQuery({ queryKey: qk.project(id), queryFn: () => projectsApi.get(id), enabled: Number.isFinite(id) })
export const useMembersQuery = (id: number) =>
  useQuery({ queryKey: qk.members(id), queryFn: () => projectsApi.members(id), enabled: Number.isFinite(id) })
export const useTasksQuery = () => useQuery({ queryKey: qk.tasks, queryFn: tasksApi.list })
export const useTaskQuery = (id: number) =>
  useQuery({ queryKey: qk.task(id), queryFn: () => tasksApi.get(id), enabled: Number.isFinite(id) })
export const useCommentsQuery = (taskId: number) =>
  useQuery({ queryKey: qk.comments(taskId), queryFn: () => commentsApi.list(taskId), enabled: Number.isFinite(taskId) })
export const useAttachmentsQuery = (taskId: number) =>
  useQuery({
    queryKey: qk.attachments(taskId),
    queryFn: () => attachmentsApi.list(taskId),
    enabled: Number.isFinite(taskId),
  })
export const useNotificationsQuery = () =>
  useQuery({ queryKey: qk.notifications, queryFn: notificationsApi.list, refetchInterval: 30000 })
export const useUsersQuery = () => useQuery({ queryKey: qk.users, queryFn: usersApi.list, staleTime: 60000 })
export const useDashboardQuery = () => useQuery({ queryKey: qk.dashboard, queryFn: dashboardApi.summary })

/** Kullanıcı kimliğinden ad soyad döndürür (kullanıcı listesi yüklenene kadar boş döner). */
export function useUserName(): (id: string | null | undefined) => string {
  const { data } = useUsersQuery()
  return useCallback(
    (id) => {
      if (!id) return '-'
      return data?.find((u) => u.id === id)?.fullName ?? '...'
    },
    [data],
  )
}
