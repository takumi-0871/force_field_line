!>@file  gz_edge_data_IO_b.f90
!!      module gz_edge_data_IO_b
!!
!!@author  H. Matsui
!!@date Programmed in Aug., 2006
!
!>@brief data IO orutines for edge
!!
!!@verbatim
!!      subroutine gz_read_edge_connection_b                            &
!!     &         (id_rank, bflag, comm_IO, ele_IO, sfed_IO)
!!        type(binary_IO_flags), intent(inout) :: bflag
!!        type(communication_table), intent(inout) :: comm_IO
!!        type(element_data), intent(inout) :: ele_IO
!!        type(surf_edge_IO_data), intent(inout) :: sfed_IO
!!      subroutine gz_write_edge_connection_b                           &
!!     &         (id_rank, comm_IO, ele_IO, sfed_IO, bflag)
!!        type(communication_table), intent(in) :: comm_IO
!!        type(element_data), intent(in) :: ele_IO
!!        type(surf_edge_IO_data), intent(in) :: sfed_IO
!!        type(binary_IO_flags), intent(inout) :: bflag
!!
!!      subroutine gz_read_edge_geometry_b(bflag, nod_IO, sfed_IO)
!!        type(binary_IO_flags), intent(inout) :: bflag
!!        type(node_data), intent(inout) :: nod_IO
!!        type(element_data), intent(inout) :: ele_IO
!!        type(surf_edge_IO_data), intent(inout) :: sfed_IO
!!      subroutine gz_write_edge_geometry_b(nod_IO, sfed_IO)
!!        type(node_data), intent(in) :: nod_IO
!!        type(element_data), intent(in) :: ele_IO
!!        type(surf_edge_IO_data), intent(in) :: sfed_IO
!!@endverbatim
!
!
      module gz_edge_data_IO_b
!
      use m_precision
!
      use t_comm_table
      use t_geometry_data
      use t_read_mesh_data
      use t_surf_edge_IO
      use binary_IO
      use m_fem_surface_labels
!
      implicit none
!
!------------------------------------------------------------------
!
       contains
!
!------------------------------------------------------------------
!
      subroutine gz_read_edge_connection_b                              &
     &         (id_rank, bflag, comm_IO, ele_IO, sfed_IO)
!
      use m_fem_mesh_labels
      use gz_domain_data_IO_b
      use gz_element_connect_IO_b
!
      integer, intent(in) :: id_rank
      type(binary_IO_flags), intent(inout) :: bflag
      type(communication_table), intent(inout) :: comm_IO
      type(element_data), intent(inout) :: ele_IO
      type(surf_edge_IO_data), intent(inout) :: sfed_IO
!
!
!      textbuf = hd_edge_para() // char(0)
!      textbuf = hd_fem_para() // char(0)
      call gz_read_domain_info_b(id_rank, bflag, comm_IO)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_connect() // char(0)
      call gz_read_number_of_element_b(bflag, ele_IO)
      if(bflag%ierr_IO .ne. 0) return
      call gz_read_element_info_b(bflag, ele_IO)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_on_surf() // char(0)
      call gz_read_surface_4_element_b(bflag, sfed_IO)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_on_ele() // char(0)
      call gz_read_edge_4_element_b(bflag, sfed_IO)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_import() // char(0)
      call gz_read_import_data_b(bflag, comm_IO)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_export() // char(0)
      call gz_read_export_data_b(bflag, comm_IO)
!
      end subroutine gz_read_edge_connection_b
!
!------------------------------------------------------------------
!
      subroutine gz_write_edge_connection_b                             &
     &         (id_rank, comm_IO, ele_IO, sfed_IO, bflag)
!
      use m_fem_mesh_labels
      use gz_domain_data_IO_b
      use gz_element_connect_IO_b
!
      integer, intent(in) :: id_rank
      type(communication_table), intent(in) :: comm_IO
      type(element_data), intent(in) :: ele_IO
      type(surf_edge_IO_data), intent(in) :: sfed_IO
!
      type(binary_IO_flags), intent(inout) :: bflag
!
!
!      textbuf = hd_edge_para() // char(0)
!      textbuf = hd_fem_para() // char(0)
      call gz_write_domain_info_b(id_rank, comm_IO, bflag)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_connect() // char(0)
      call gz_write_element_info_b(ele_IO, bflag)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_on_surf() // char(0)
      call gz_write_surface_4_element_b(sfed_IO, bflag)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_on_ele() // char(0)
      call gz_write_edge_4_element_b(sfed_IO, bflag)
      if(bflag%ierr_IO .ne. 0) return
!
!
!      textbuf = hd_edge_import() // char(0)
      call gz_write_import_data_b(comm_IO, bflag)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_export() // char(0)
      call gz_write_export_data_b(comm_IO, bflag)
      if(bflag%ierr_IO .ne. 0) return
!
      end subroutine gz_write_edge_connection_b
!
!------------------------------------------------------------------
!------------------------------------------------------------------
!
      subroutine gz_read_edge_geometry_b(bflag, nod_IO, sfed_IO)
!
      use gz_node_geometry_IO_b
!
      type(binary_IO_flags), intent(inout) :: bflag
      type(node_data), intent(inout) :: nod_IO
      type(surf_edge_IO_data), intent(inout) :: sfed_IO
!
!
!      textbuf = hd_edge_point() // char(0)
      call gz_read_number_of_node_b(bflag, nod_IO)
      if(bflag%ierr_IO .ne. 0) return
!
      call gz_read_geometry_info_b(bflag, nod_IO)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_dir() // char(0)
      call gz_read_vector_in_element_b(bflag, nod_IO, sfed_IO)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_length() // char(0)
      call gz_read_scalar_in_element_b(bflag, nod_IO, sfed_IO)
!
      end subroutine gz_read_edge_geometry_b
!
!------------------------------------------------------------------
!------------------------------------------------------------------
!
      subroutine gz_write_edge_geometry_b(nod_IO, sfed_IO, bflag)
!
      use gz_node_geometry_IO_b
!
      type(node_data), intent(in) :: nod_IO
      type(surf_edge_IO_data), intent(in) :: sfed_IO
      type(binary_IO_flags), intent(inout) :: bflag
!
!
!      textbuf = hd_edge_point() // char(0)
      call gz_write_geometry_info_b(nod_IO, bflag)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_dir() // char(0)
      call gz_write_vector_in_element_b(nod_IO, sfed_IO, bflag)
      if(bflag%ierr_IO .ne. 0) return
!
!      textbuf = hd_edge_length() // char(0)
      call gz_write_scalar_in_element_b(nod_IO, sfed_IO, bflag)
      if(bflag%ierr_IO .ne. 0) return
!
      end subroutine gz_write_edge_geometry_b
!
!------------------------------------------------------------------
!
      end module gz_edge_data_IO_b