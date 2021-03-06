!>@file   copy_rtp_data_to_FFTPACK.f90
!!@brief  module copy_rtp_data_to_FFTPACK
!!
!!@author H. Matsui
!!@date Programmed in Oct., 2012
!
!>@brief  communication table from FFTPACK5
!!
!!@verbatim
!!      subroutine copy_FFTPACK_to_rtp_field(nnod_rtp, nidx_rtp,        &
!!     &          irt_rtp_smp_stack, ncomp_bwd, X_FFT, X_rtp)
!!      subroutine copy_FFTPACK_from_rtp_field(nnod_rtp, nidx_rtp,      &
!!     &          irt_rtp_smp_stack, ncomp_fwd, X_rtp, X_FFT)
!!
!!      subroutine copy_FFTPACK_to_rtp_comp(nnod_rtp, nidx_rtp,         &
!!     &          irt_rtp_smp_stack, X_FFT, X_rtp)
!!      subroutine copy_FFTPACK_from_rtp_comp(nnod_rtp, nidx_rtp,       &
!!     &          irt_rtp_smp_stack, X_rtp, X_FFT)
!!
!!      subroutine copy_FFTPACK_to_prt_field                            &
!!     &         (nnod_rtp, ncomp_bwd, X_FFT, X_prt)
!!      subroutine copy_FFTPACK_from_prt_field                          &
!!     &         (nnod_rtp, ncomp_fwd, X_prt, X_FFT)
!!
!!      subroutine copy_FFTPACK_to_prt_comp(nnod_rtp, X_prt, X_FFT)
!!@endverbatim
!!
      module copy_rtp_data_to_FFTPACK
!
      use m_precision
      use m_constants
      use m_machine_parameter
!
      implicit none
!
! ------------------------------------------------------------------
!
      contains
!
! ------------------------------------------------------------------
!
      subroutine copy_FFTPACK_to_rtp_field(nnod_rtp, nidx_rtp,          &
     &          irt_rtp_smp_stack, ncomp_bwd, X_FFT, X_rtp)
!
      integer(kind = kint), intent(in) :: nnod_rtp
      integer(kind = kint), intent(in) :: nidx_rtp(3)
      integer(kind = kint), intent(in) :: irt_rtp_smp_stack(0:np_smp)
!
      integer(kind = kint), intent(in) :: ncomp_bwd
      real(kind = kreal), intent(in) :: X_FFT(ncomp_bwd*nnod_rtp)
!
      real(kind = kreal), intent(inout)                                 &
     &     :: X_rtp(irt_rtp_smp_stack(np_smp),nidx_rtp(3),ncomp_bwd)
!
!
      integer(kind = kint) :: m, j, ip, ist, num, nd
      integer(kind = kint) :: inod_c, ist_fft
!
!
!$omp parallel do private(ip,m,j,nd,ist,num,inod_c,ist_fft)
      do ip = 1, np_smp
        ist = irt_rtp_smp_stack(ip-1)
        num = irt_rtp_smp_stack(ip) - irt_rtp_smp_stack(ip-1)
        ist_fft = irt_rtp_smp_stack(ip-1) * nidx_rtp(3)
        do nd = 1, ncomp_bwd
          do m = 1, nidx_rtp(3)
            do j = 1, num
              inod_c = nd + ((j-1) + (m-1)*num + ist_fft) * ncomp_bwd
              X_rtp(j+ist,m,nd) = X_FFT(inod_c)
            end do
          end do
        end do
      end do
!$omp end parallel do
!
      end subroutine copy_FFTPACK_to_rtp_field
!
! ------------------------------------------------------------------
!
      subroutine copy_FFTPACK_from_rtp_field(nnod_rtp, nidx_rtp,        &
     &          irt_rtp_smp_stack, ncomp_fwd, X_rtp, X_FFT)
!
      integer(kind = kint), intent(in) :: nnod_rtp
      integer(kind = kint), intent(in) :: nidx_rtp(3)
      integer(kind = kint), intent(in) :: irt_rtp_smp_stack(0:np_smp)
!
      integer(kind = kint), intent(in) :: ncomp_fwd
      real(kind = kreal), intent(in)                                    &
     &     :: X_rtp(irt_rtp_smp_stack(np_smp),nidx_rtp(3),ncomp_fwd)
!
      real(kind = kreal), intent(inout) :: X_FFT(ncomp_fwd*nnod_rtp)
!
      integer(kind = kint) :: m, j, ip, ist, num
      integer(kind = kint) :: inod_c, ist_fft
!
!
!$omp parallel do private(m,j,ist,num,inod_c,ist_fft)
      do ip = 1, np_smp
        ist = irt_rtp_smp_stack(ip-1)
        num =  irt_rtp_smp_stack(ip) - irt_rtp_smp_stack(ip-1)
        ist_fft = irt_rtp_smp_stack(ip-1) * nidx_rtp(3)
!
        do m = 1, nidx_rtp(3)
          do j = 1, num
            inod_c = ((j-1) + (m-1)*num + ist_fft) * ncomp_fwd
            X_FFT(inod_c+1:inod_c+ncomp_fwd)                            &
     &             = X_rtp(j+ist,m,1:ncomp_fwd)
          end do
        end do
      end do
!$omp end parallel do
!
      end subroutine copy_FFTPACK_from_rtp_field
!
! ------------------------------------------------------------------
! ------------------------------------------------------------------
!
      subroutine copy_FFTPACK_to_rtp_comp(nnod_rtp, nidx_rtp,           &
     &          irt_rtp_smp_stack, X_FFT, X_rtp)
!
      integer(kind = kint), intent(in) :: nnod_rtp
      integer(kind = kint), intent(in) :: nidx_rtp(3)
      integer(kind = kint), intent(in) :: irt_rtp_smp_stack(0:np_smp)
!
      real(kind = kreal), intent(in) :: X_FFT(nnod_rtp)
!
      real(kind = kreal), intent(inout)                                 &
     &     :: X_rtp(irt_rtp_smp_stack(np_smp),nidx_rtp(3))
!
!
      integer(kind = kint) :: m, j, ip, ist, num
      integer(kind = kint) :: inod_c, ist_fft
!
!
!$omp parallel do private(ip,m,j,ist,num,inod_c,ist_fft)
      do ip = 1, np_smp
        ist = irt_rtp_smp_stack(ip-1)
        num = irt_rtp_smp_stack(ip) - irt_rtp_smp_stack(ip-1)
        ist_fft = irt_rtp_smp_stack(ip-1) * nidx_rtp(3)
        do m = 1, nidx_rtp(3)
          inod_c = (m-1)*num + ist_fft
          do j = 1, num
            X_rtp(j+ist,m) = X_FFT(j+inod_c)
          end do
        end do
      end do
!$omp end parallel do
!
      end subroutine copy_FFTPACK_to_rtp_comp
!
! ------------------------------------------------------------------
!
      subroutine copy_FFTPACK_from_rtp_comp(nnod_rtp, nidx_rtp,         &
     &          irt_rtp_smp_stack, X_rtp, X_FFT)
!
      integer(kind = kint), intent(in) :: nnod_rtp
      integer(kind = kint), intent(in) :: nidx_rtp(3)
      integer(kind = kint), intent(in) :: irt_rtp_smp_stack(0:np_smp)
!
      real(kind = kreal), intent(in)                                    &
     &     :: X_rtp(irt_rtp_smp_stack(np_smp),nidx_rtp(3))
!
      real(kind = kreal), intent(inout) :: X_FFT(nnod_rtp)
!
      integer(kind = kint) :: m, j, ip, ist, num
      integer(kind = kint) :: inod_c, ist_fft
!
!
!$omp parallel do private(m,j,ist,num,inod_c,ist_fft)
      do ip = 1, np_smp
        ist = irt_rtp_smp_stack(ip-1)
        num =  irt_rtp_smp_stack(ip) - irt_rtp_smp_stack(ip-1)
        ist_fft = irt_rtp_smp_stack(ip-1) * nidx_rtp(3)
!
        do m = 1, nidx_rtp(3)
          inod_c = (m-1)*num + ist_fft
          do j = 1, num
            X_FFT(j+inod_c) = X_rtp(j+ist,m)
          end do
        end do
      end do
!$omp end parallel do
!
      end subroutine copy_FFTPACK_from_rtp_comp
!
! ------------------------------------------------------------------
! ------------------------------------------------------------------
!
      subroutine copy_FFTPACK_to_prt_field                              &
     &         (nnod_rtp, ncomp_bwd, X_FFT, X_prt)
!
      integer(kind = kint), intent(in) :: nnod_rtp
!
      integer(kind = kint), intent(in) :: ncomp_bwd
      real(kind = kreal), intent(in) :: X_FFT(ncomp_bwd*nnod_rtp)
!
      real(kind = kreal), intent(inout) :: X_prt(nnod_rtp,ncomp_bwd)
!
      integer(kind = kint) :: nd, inod_c, inod
!
!
!$omp parallel do private(inod,nd,inod_c)
      do inod = 1, nnod_rtp
        do nd = 1, ncomp_bwd
          inod_c = nd + (inod-1) * ncomp_bwd
          X_prt(inod_c,nd) = X_FFT(inod_c)
        end do
      end do
!$omp end parallel do
!
      end subroutine copy_FFTPACK_to_prt_field
!
! ------------------------------------------------------------------
!
      subroutine copy_FFTPACK_from_prt_field                            &
     &         (nnod_rtp, ncomp_fwd, X_prt, X_FFT)
!
      integer(kind = kint), intent(in) :: nnod_rtp
!
      integer(kind = kint), intent(in) :: ncomp_fwd
      real(kind = kreal), intent(in) :: X_prt(nnod_rtp,ncomp_fwd)
!
      real(kind = kreal), intent(inout) :: X_FFT(ncomp_fwd*nnod_rtp)
!
      integer(kind = kint) :: inod, inod_c
!
!
!$omp parallel do private(inod,inod_c)
      do inod = 1, nnod_rtp
        inod_c = (inod-1) * ncomp_fwd
        X_FFT(inod_c+1:inod_c+ncomp_fwd) = X_prt(inod,1:ncomp_fwd)
      end do
!$omp end parallel do
!
      end subroutine copy_FFTPACK_from_prt_field
!
! ------------------------------------------------------------------
! ------------------------------------------------------------------
!
      subroutine copy_FFTPACK_to_prt_comp(nnod_rtp, X_prt, X_FFT)
!
      integer(kind = kint), intent(in) :: nnod_rtp
      real(kind = kreal), intent(in):: X_prt(nnod_rtp)
!
      real(kind = kreal), intent(inout) :: X_FFT(nnod_rtp)
!
!
!$omp parallel workshare
      X_FFT(1:nnod_rtp) = X_prt(1:nnod_rtp)
!$omp end parallel workshare
!
      end subroutine copy_FFTPACK_to_prt_comp
!
! ------------------------------------------------------------------
!
      end module copy_rtp_data_to_FFTPACK
