!>@file   solver_SR_6.f90
!!@brief  module solver_SR_6
!!
!!@author coded by K.Nakajima (RIST)
!!@date coded by K.Nakajima (RIST) on jul. 1999 (ver 1.0)
!!@n    modified by H. Matsui (U. of Chicago) on july 2007 (ver 1.1)
!
!>@brief  MPI SEND and RECEIVE routine for six components fields
!!        in overlapped partitioning
!!
!!@verbatim
!!      subroutine  SOLVER_SEND_RECV_6(N, NEIBPETOT, NEIBPE,            &
!!     &                               STACK_IMPORT, NOD_IMPORT,        &
!!     &                               STACK_EXPORT, NOD_EXPORT,        &
!!     &                               SR_sig, SR_r, X)
!!@endverbatim
!!
!!@n @param  N     Number of data points
!!@n
!!@n @param  NEIBPETOT    Number of processses to communicate
!!@n @param  NEIBPE(NEIBPETOT)      Process ID to communicate
!!@n @param  STACK_IMPORT(0:NEIBPETOT)
!!                    End points of import buffer for each process
!!@n @param  NOD_IMPORT(STACK_IMPORT(NEIBPETOT))
!!                    local node ID to copy in import buffer
!!@n @param  STACK_EXPORT(0:NEIBPETOT)
!!                    End points of export buffer for each process
!!@n @param  NOD_EXPORT(STACK_IMPORT(NEIBPETOT))
!!                    local node ID to copy in export buffer
!!
!!@n @param  X(6*N)   field data with 6 components
!
      module solver_SR_6
!
      use m_precision
      use m_constants
      use t_solver_SR
      use calypso_mpi
!
      implicit none
!
! ----------------------------------------------------------------------
!
      contains
!
! ----------------------------------------------------------------------
!C
      subroutine  SOLVER_SEND_RECV_6(N, NEIBPETOT, NEIBPE,              &
     &                               STACK_IMPORT, NOD_IMPORT,          &
     &                               STACK_EXPORT, NOD_EXPORT,          &
     &                               SR_sig, SR_r, X)
!
!>       number of nodes
      integer(kind=kint )                , intent(in)   ::  N
!>       total neighboring pe count
      integer(kind=kint )                , intent(in)   ::  NEIBPETOT
!>       neighboring pe id                        (i-th pe)
      integer(kind=kint ), dimension(NEIBPETOT) :: NEIBPE
!>       imported node count for each neighbor pe (i-th pe)
      integer(kind=kint ), dimension(0:NEIBPETOT) :: STACK_IMPORT
!>       imported node                            (i-th dof)
      integer(kind=kint ), dimension(STACK_IMPORT(NEIBPETOT))           &
     &        :: NOD_IMPORT
!>       exported node count for each neighbor pe (i-th pe)
      integer(kind=kint ), dimension(0:NEIBPETOT) :: STACK_EXPORT
!>       exported node                            (i-th dof)
      integer(kind=kint ), dimension(STACK_EXPORT(NEIBPETOT))           &
     &        :: NOD_EXPORT
!>       communicated result vector
      real   (kind=kreal), dimension(6*N), intent(inout):: X
!
!>      Structure of communication flags
      type(send_recv_status), intent(inout) :: SR_sig
!>      Structure of communication buffer for 8-byte real
      type(send_recv_real_buffer), intent(inout) :: SR_r
!
      integer (kind = kint) :: neib, istart, inum, k, ii
!
!
      call resize_work_SR(isix, NEIBPETOT, NEIBPETOT,                   &
     &    STACK_EXPORT(NEIBPETOT), STACK_IMPORT(NEIBPETOT),             &
     &    SR_sig, SR_r)
!C
!C-- SEND
      
      do neib= 1, NEIBPETOT
        istart= STACK_EXPORT(neib-1)
        inum  = STACK_EXPORT(neib  ) - istart
        
        do k= istart+1, istart+inum
               ii   = 6*NOD_EXPORT(k)
           SR_r%WS(6*k-5)= X(ii-5)
           SR_r%WS(6*k-4)= X(ii-4)
           SR_r%WS(6*k-3)= X(ii-3)
           SR_r%WS(6*k-2)= X(ii-2)
           SR_r%WS(6*k-1)= X(ii-1)
           SR_r%WS(6*k  )= X(ii  )
        enddo
        call MPI_ISEND(SR_r%WS(6*istart+1), int(6*inum), CALYPSO_REAL,  &
     &                 int(NEIBPE(neib)), 0, CALYPSO_COMM,              &
     &                 SR_sig%req1(neib), ierr_MPI)
      enddo

!C
!C-- RECEIVE
      do neib= 1, NEIBPETOT
        istart= STACK_IMPORT(neib-1)
        inum  = STACK_IMPORT(neib  ) - istart
        call MPI_IRECV(SR_r%WR(6*istart+1), int(6*inum), CALYPSO_REAL,  &
     &                 int(NEIBPE(neib)), 0, CALYPSO_COMM,              &
     &                 SR_sig%req2(neib), ierr_MPI)
      enddo

      call MPI_WAITALL                                                  &
     &   (int(NEIBPETOT), SR_sig%req2(1), SR_sig%sta2(1,1), ierr_MPI)
   
      do neib= 1, NEIBPETOT
        istart= STACK_IMPORT(neib-1)
        inum  = STACK_IMPORT(neib  ) - istart
        do k= istart+1, istart+inum
          ii   = 6*NOD_IMPORT(k)
          X(ii-5)= SR_r%WR(6*k-5)
          X(ii-4)= SR_r%WR(6*k-4)
          X(ii-3)= SR_r%WR(6*k-3)
          X(ii-2)= SR_r%WR(6*k-2)
          X(ii-1)= SR_r%WR(6*k-1)
          X(ii  )= SR_r%WR(6*k  )
        enddo
      enddo

      call MPI_WAITALL                                                  &
     &   (int(NEIBPETOT), SR_sig%req1(1), SR_sig%sta1(1,1), ierr_MPI)

      end subroutine SOLVER_SEND_RECV_6
!
! ----------------------------------------------------------------------
!
      end module     solver_SR_6
