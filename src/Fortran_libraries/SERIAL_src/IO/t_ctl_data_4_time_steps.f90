!>@file   t_ctl_data_4_time_steps.f90
!!        module t_ctl_data_4_time_steps
!!
!!@author H. Matsui
!!@date Programmed in Sep., 2006
!!@n    Modified in Nov., 2006
!!
!> @brief Control input routine for time step parameters
!!
!!@verbatim
!!
!!      subroutine read_control_time_step_data                          &
!!     &         (id_control, hd_block, tctl, c_buf)
!!        type(time_data_control), intent(inout) :: tctl
!!      subroutine write_control_time_step_data                         &
!!     &         (id_control, hd_block, tctl, level)
!!        type(time_data_control), intent(in) :: tctl
!!
!!      integer(kind = kint) function num_label_time_step_ctl()
!!      integer(kind = kint) function num_label_time_step_ctl_w_dep()
!!      subroutine set_label_time_step_ctl(names)
!! ------------------------------------------------------------------
!!      Example of control parameters for flexible time step
!!
!!    begin time_step_ctl
!!      elapsed_time_ctl      42500.
!!
!!      flexible_step_ctl        ON
!!      dt_ctl                   5.0e-5
!!      min_delta_t_ctl          1.0e-6
!!      max_delta_t_ctl          1.0e-5
!!      max_eps_to_shrink_ctl    1.0e-1
!!      min_eps_to_expand_ctl    1.0e-1
!!
!!      ratio_to_CFL_ctl    0.3
!!
!!      start_rst_step_ctl    10
!!      end_rst_step_ctl      20
!!
!!      delta_t_check_ctl        2.0e-5
!!      delta_t_rst_ctl          1.0e-2
!!      delta_t_sectioning_ctl   1.0e-3
!!      delta_t_isosurface_ctl   1.0e-3
!!      delta_t_pvr_ctl          1.0e-2
!!      delta_t_fline_ctl        1.0e-1
!!      delta_t_LIC_ctl          1.0e-1
!!      delta_t_field_ctl        1.0e-3
!!      delta_t_monitor_ctl      1.0e-4
!!      delta_t_sgs_coefs_ctl    2.0e-5
!!      delta_t_boundary_ctl     1.0e-4
!!    end time_step_ctl
!!
!! ------------------------------------------------------------------
!!
!!      Example of control parameters for fixed time step
!!
!!    begin time_step_ctl
!!      elapsed_time_ctl      42500.
!!
!!      flexible_step_ctl     OFF
!!
!!      i_step_init_ctl       0
!!      i_step_finish_ctl     2000
!!      i_step_number_ctl     2000
!!
!!      i_step_check_ctl         40
!!      i_step_rst_ctl          800
!!      i_step_sectioning_ctl   400
!!      i_step_isosurface_ctl   400
!!      i_step_pvr_ctl          400
!!      i_step_fline_ctl        400
!!      i_step_LIC_ctl          400
!!      i_step_snapshot_ctl     800
!!      i_step_field_ctl        800
!!      i_step_monitor_ctl       40
!!      i_step_sgs_coefs_ctl   2000
!!      i_step_boundary_ctl      40
!!
!!      dt_ctl              5.0e-5
!!      time_init_ctl       0.0e-8
!!    end time_step_ctl
!!
!! ------------------------------------------------------------------
!!@endverbatim
!>@n
!>@n@param      elapsed_time_ctl
!>                Simulation time on wall clock (sec.)
!
!>@n@param      flexible_step_ctl
!>                Flexible time step switch ('On' or 'Off')
!>@n@param      dt_ctl
!>                time step
!
!>@n@param      min_delta_t_ctl
!>                minimum time step length
!>@n@param      max_delta_t_ctl
!>                maximum time step length
!>@n@param      max_eps_to_shrink_ctl
!>                maximum threshold to shrink time step
!>@n@param      min_eps_to_expand_ctl
!>                minimum threshold to expand time step
!>@n@param      ratio_to_CFL_ctl
!>                Ratio to CFL condition
!
!>@n@param      start_rst_step_ctl
!>                Increment time for volume integrated data output
!>@n@param      end_rst_step_ctl
!>                Increment time for restart data output
!
!>@n@param      delta_t_check_ctl
!>                Increment time for volume integrated data output
!>@n@param      delta_t_rst_ctl
!>                Increment time for restart data output
!>@n@param      delta_t_psf_ctl
!>                Increment time for surface rendering data output
!>@n@param      delta_t_iso_ctl
!>                Increment time for isosurface rendering data output
!>@n@param      delta_t_pvr_ctl
!>                Increment time for volume rendering data output
!>@n@param      delta_t_fline_ctl
!>                Increment time for field line data output
!>@n@param      delta_t_lic_ctl
!>                Increment time for LIC rendering output
!>@n@param      delta_t_field_ctl
!>                Increment time for whole field data output
!>@n@param      delta_t_monitor_ctl
!>                Increment time for monotoring on nodes data output
!>@n@param      delta_t_sgs_coefs_ctl
!>                Increment time for SGS model parameters data output
!>@n@param      delta_t_boundary_ctl
!>                Increment time for boundary data output
!
!
!>@n@param      i_step_init_ctl
!>                start time step
!>@n@param      i_step_number_ctl or i_step_finish_ctl
!>                end time step
!
!>@n@param      i_step_check_ctl
!>                Increment step for volume integrated data output
!>@n@param      i_step_rst_ctl
!>                Increment step for restart data output
!>@n@param      i_step_sectioning_ctl
!>                Increment step for surface rendering data output
!>@n@param      i_step_pvr_ctl
!>                Increment step for volume rendering data output
!>@n@param      i_step_fline_ctl
!>                Increment step for field line data output
!>@n@param      i_step_lic_ctl
!>                Increment step for LIC rendering data output
!>@n@param      i_step_field_ctl or i_step_snapshot_ctl
!>                Increment step for whole field data output
!>@n@param      i_step_monitor_ctl
!>                Increment step for monotoring on nodes data output
!>@n@param      i_step_sgs_coefs_ctl
!>                Increment step for SGS model parameters data output
!>@n@param      i_step_boundary_ctl
!>                Increment step for boundary data output
!
!>@n@param      time_init_ctl
!>                Initial time
!
      module t_ctl_data_4_time_steps
!
      use m_precision
      use m_machine_parameter
      use t_control_array_character
      use t_control_array_real
      use t_control_array_integer
      use t_read_control_elements
!
      implicit  none
!
!
!>   Structure of time stepping controls
      type time_data_control
!>   First step
        type(read_integer_item) :: i_step_init_ctl
!>   End step
        type(read_integer_item) :: i_step_number_ctl
!>   Elapsed time for finish
        type(read_real_item) :: elapsed_time_ctl
! 
!>   Monitoring inrement
        type(read_integer_item) :: i_step_check_ctl
!>   Increment for restart
        type(read_integer_item) :: i_step_rst_ctl
!
!>   Increment for volume rendering
        type(read_integer_item) :: i_step_pvr_ctl
!>   Increment for sectioning
        type(read_integer_item) :: i_step_psf_ctl
!>   Increment for isosurface
        type(read_integer_item) :: i_step_iso_ctl
!>   Increment for LIC rendering
        type(read_integer_item) :: i_step_lic_ctl
!>   Increment for field line
        type(read_integer_item) :: i_step_fline_ctl
!>   Increment for field data output
        type(read_integer_item) :: i_step_ucd_ctl
!
!>   Increment for monitoring point data
        type(read_integer_item) :: i_step_monitor_ctl
!
!>   Increment to evaluate model coefficients
        type(read_integer_item) :: i_step_sgs_coefs_ctl
!>   Increment to output boundary data
        type(read_integer_item) :: i_step_boundary_ctl
! 
!>   Delta t
        type(read_real_item) :: dt_ctl
!>   Initial time (If there is no initial field data)
        type(read_real_item) :: time_init_ctl
!
        type(read_integer_item) :: i_diff_steps_ctl
!
!>     Flexible time step flag
        type(read_character_item) :: flexible_step_ctl
!
!>     Ratio to CFL condition
        type(read_real_item) :: ratio_to_cfl_ctl
!
!>     Start time
        type(read_integer_item) :: start_rst_step_ctl
!>     End  time
        type(read_integer_item) :: end_rst_step_ctl
!
!>     Minimum delta t
        type(read_real_item) :: min_delta_t_ctl
!>     Maximum delta t
        type(read_real_item) :: max_delta_t_ctl
!>     Maximum delta t
        type(read_real_item) :: max_eps_to_shrink_ctl
!>     Minimum delta t
        type(read_real_item) :: min_eps_to_expand_ctl
!
!>   Monitoring inrement
        type(read_real_item) :: delta_t_check_ctl
!>   time interval for restart
        type(read_real_item) :: delta_t_rst_ctl
!
!>   time interval for sectioning
        type(read_real_item) :: delta_t_psf_ctl
!>   time interval for isosurface
        type(read_real_item) :: delta_t_iso_ctl
!>   time interval for volume rendering
        type(read_real_item) :: delta_t_pvr_ctl
!>   time interval for field line
        type(read_real_item) :: delta_t_fline_ctl
!>   time interval for LIC rendering
        type(read_real_item) :: delta_t_lic_ctl
!
!>   time interval for field data output
        type(read_real_item) :: delta_t_field_ctl
!>   time interval for monitoring point data
        type(read_real_item) :: delta_t_monitor_ctl
!>   time interval to evaluate model coefficients
        type(read_real_item) :: delta_t_sgs_coefs_ctl
!>   time interval to output boundary data
        type(read_real_item) :: delta_t_boundary_ctl
!
        integer (kind=kint) :: i_tstep =      0
      end type time_data_control
!
!   4th level for time steps
!
      character(len=kchara), parameter, private                         &
     &       :: hd_elapsed_time =     'elapsed_time_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_dt =               'dt_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_time_init =        'time_init_ctl'
!
      character(len=kchara), parameter, private                         &
     &       :: hd_flexible_step =     'flexible_step_ctl'
!
      character(len=kchara), parameter, private                         &
     &       :: hd_min_delta_t =       'min_delta_t_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_max_delta_t =       'max_delta_t_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_max_eps_to_shrink = 'max_eps_to_shrink_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_min_eps_to_expand = 'min_eps_to_expand_ctl'
!
      character(len=kchara), parameter, private                         &
     &       :: hd_ratio_to_cfl =      'ratio_to_CFL_ctl'
!
      character(len=kchara), parameter, private                         &
     &       :: hd_start_rst_step =    'start_rst_step_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_end_rst_step =      'end_rst_step_ctl'
!
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_check =     'delta_t_check_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_rst =       'delta_t_rst_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_section =   'delta_t_sectioning_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_isosurf =   'delta_t_isosurface_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_pvr =       'delta_t_pvr_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_lic =       'delta_t_LIC_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_fline =     'delta_t_fline_ctl'
!
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_ucd =       'delta_t_field_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_monitor =   'delta_t_monitor_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_sgs_coefs = 'delta_t_sgs_coefs_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_delta_t_boundary =  'delta_t_boundary_ctl'
!
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_init =      'i_step_init_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_finish_number =  'i_step_finish_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_check =     'i_step_check_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_rst =       'i_step_rst_ctl'
!
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_section =   'i_step_sectioning_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_isosurf =   'i_step_isosurface_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_pvr =       'i_step_pvr_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_fline =     'i_step_fline_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_lic =       'i_step_LIC_ctl'
!
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_ucd =       'i_step_field_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_monitor =   'i_step_monitor_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_sgs_coefs = 'i_step_sgs_coefs_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_boundary =  'i_step_boundary_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_diff_steps =     'i_diff_steps_ctl'
!
!       Deplecated flags
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_number =    'i_step_number_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_psf =       'i_step_psf_ctl'
      character(len=kchara), parameter, private                         &
     &       :: hd_i_step_iso =       'i_step_iso_ctl'
!
      integer(kind = kint), parameter, private                          &
     &                      :: n_label_time_step_ctl =       36
      integer(kind = kint), parameter, private                          &
     &                      :: n_label_time_step_ctl_w_dep = 39
!
! -----------------------------------------------------------------------
!
      contains
!
! -----------------------------------------------------------------------
!
      subroutine read_control_time_step_data                            &
     &         (id_control, hd_block, tctl, c_buf)
!
      use t_read_control_elements
      use skip_comment_f
!
      integer(kind = kint), intent(in) :: id_control
      character(len=kchara), intent(in) :: hd_block
!
      type(time_data_control), intent(inout) :: tctl
      type(buffer_for_control), intent(inout)  :: c_buf
!
!
      if(check_begin_flag(c_buf, hd_block) .eqv. .FALSE.) return
      if(tctl%i_tstep .gt. 0) return
      do
        call load_one_line_from_control(id_control, c_buf)
        if(check_end_flag(c_buf, hd_block)) exit
!
!
        call read_real_ctl_type                                         &
     &     (c_buf, hd_elapsed_time, tctl%elapsed_time_ctl)
!
        call read_real_ctl_type(c_buf, hd_dt, tctl%dt_ctl)
        call read_real_ctl_type                                         &
     &     (c_buf, hd_time_init, tctl%time_init_ctl)
!
        call read_real_ctl_type(c_buf, hd_min_delta_t,                  &
     &      tctl%min_delta_t_ctl)
        call read_real_ctl_type(c_buf, hd_max_delta_t,                  &
     &      tctl%max_delta_t_ctl)
        call read_real_ctl_type(c_buf, hd_max_eps_to_shrink,            &
     &      tctl%max_eps_to_shrink_ctl)
        call read_real_ctl_type(c_buf, hd_min_eps_to_expand,            &
     &      tctl%min_eps_to_expand_ctl)
!
        call read_real_ctl_type(c_buf, hd_delta_t_check,                &
     &      tctl%delta_t_check_ctl)
        call read_real_ctl_type(c_buf, hd_delta_t_rst,                  &
     &      tctl%delta_t_rst_ctl)
!
        call read_real_ctl_type(c_buf, hd_delta_t_section,              &
     &      tctl%delta_t_psf_ctl)
        call read_real_ctl_type(c_buf, hd_delta_t_isosurf,              &
     &      tctl%delta_t_iso_ctl)
        call read_real_ctl_type(c_buf, hd_delta_t_pvr,                  &
     &      tctl%delta_t_pvr_ctl)
        call read_real_ctl_type(c_buf, hd_delta_t_fline,                &
     &      tctl%delta_t_fline_ctl)
        call read_real_ctl_type(c_buf, hd_delta_t_lic,                  &
     &      tctl%delta_t_lic_ctl)
!
        call read_real_ctl_type(c_buf, hd_delta_t_ucd,                  &
     &      tctl%delta_t_field_ctl)
        call read_real_ctl_type(c_buf, hd_delta_t_monitor,              &
     &      tctl%delta_t_monitor_ctl)
        call read_real_ctl_type(c_buf, hd_delta_t_sgs_coefs,            &
     &      tctl%delta_t_sgs_coefs_ctl)
        call read_real_ctl_type(c_buf, hd_delta_t_boundary,             &
     &      tctl%delta_t_boundary_ctl)
!
        call read_real_ctl_type(c_buf, hd_ratio_to_cfl,                 &
     &      tctl%ratio_to_cfl_ctl)
!
        call read_integer_ctl_type(c_buf, hd_i_step_init,               &
     &      tctl%i_step_init_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_number,             &
     &      tctl%i_step_number_ctl)
        call read_integer_ctl_type(c_buf, hd_i_finish_number,           &
     &      tctl%i_step_number_ctl)
!
        call read_integer_ctl_type(c_buf, hd_i_step_check,              &
     &      tctl%i_step_check_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_rst,                &
     &      tctl%i_step_rst_ctl)
!
        call read_integer_ctl_type(c_buf, hd_i_step_section,            &
     &      tctl%i_step_psf_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_isosurf,            &
     &      tctl%i_step_iso_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_psf,                &
     &      tctl%i_step_psf_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_iso,                &
     &      tctl%i_step_iso_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_pvr,                &
     &      tctl%i_step_pvr_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_lic,                &
     &      tctl%i_step_lic_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_fline,              &
     &      tctl%i_step_fline_ctl)
!
        call read_integer_ctl_type(c_buf, hd_i_step_ucd,                &
     &      tctl%i_step_ucd_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_monitor,            &
     &      tctl%i_step_monitor_ctl)
!
        call read_integer_ctl_type(c_buf, hd_i_step_sgs_coefs,          &
     &      tctl%i_step_sgs_coefs_ctl)
        call read_integer_ctl_type(c_buf, hd_i_step_boundary,           &
     &      tctl%i_step_boundary_ctl)
!
        call read_integer_ctl_type(c_buf, hd_i_diff_steps,              &
     &      tctl%i_diff_steps_ctl)
!
        call read_integer_ctl_type(c_buf, hd_start_rst_step,            &
     &      tctl%start_rst_step_ctl)
        call read_integer_ctl_type(c_buf, hd_end_rst_step,              &
     &      tctl%end_rst_step_ctl)
!
!
        call read_chara_ctl_type(c_buf, hd_flexible_step,               &
     &      tctl%flexible_step_ctl)
      end do
      tctl%i_tstep = 1
!
      end subroutine read_control_time_step_data
!
!   --------------------------------------------------------------------
!
      subroutine write_control_time_step_data                           &
     &         (id_control, hd_block, tctl, level)
!
      use t_read_control_elements
      use write_control_elements
!
      integer(kind = kint), intent(in) :: id_control
      character(len=kchara), intent(in) :: hd_block
      type(time_data_control), intent(in) :: tctl
!
      integer(kind = kint), intent(inout) :: level
!
      integer(kind = kint) :: maxlen = 0
!
!
      maxlen = max(maxlen, len_trim(hd_elapsed_time))
      maxlen = max(maxlen, len_trim(hd_dt))
      maxlen = max(maxlen, len_trim(hd_time_init))
      maxlen = max(maxlen, len_trim(hd_min_delta_t))
      maxlen = max(maxlen, len_trim(hd_max_delta_t))
      maxlen = max(maxlen, len_trim(hd_max_eps_to_shrink))
      maxlen = max(maxlen, len_trim(hd_min_eps_to_expand))
      maxlen = max(maxlen, len_trim(hd_delta_t_check))
      maxlen = max(maxlen, len_trim(hd_delta_t_rst))
      maxlen = max(maxlen, len_trim(hd_delta_t_section))
      maxlen = max(maxlen, len_trim(hd_delta_t_isosurf))
      maxlen = max(maxlen, len_trim(hd_delta_t_pvr))
      maxlen = max(maxlen, len_trim(hd_delta_t_fline))
      maxlen = max(maxlen, len_trim(hd_delta_t_lic))
!
      maxlen = max(maxlen, len_trim(hd_delta_t_ucd))
      maxlen = max(maxlen, len_trim(hd_delta_t_monitor))
      maxlen = max(maxlen, len_trim(hd_delta_t_sgs_coefs))
      maxlen = max(maxlen, len_trim(hd_delta_t_boundary))
      maxlen = max(maxlen, len_trim(hd_i_step_init))
      maxlen = max(maxlen, len_trim(hd_i_step_number))
      maxlen = max(maxlen, len_trim(hd_i_finish_number))
      maxlen = max(maxlen, len_trim(hd_i_step_check))
      maxlen = max(maxlen, len_trim(hd_i_step_rst))
      maxlen = max(maxlen, len_trim(hd_i_step_section))
      maxlen = max(maxlen, len_trim(hd_i_step_isosurf))
      maxlen = max(maxlen, len_trim(hd_i_step_psf))
      maxlen = max(maxlen, len_trim(hd_i_step_pvr))
      maxlen = max(maxlen, len_trim(hd_i_step_fline))
      maxlen = max(maxlen, len_trim(hd_i_step_lic))
      maxlen = max(maxlen, len_trim(hd_i_step_ucd))
      maxlen = max(maxlen, len_trim(hd_i_step_monitor))
      maxlen = max(maxlen, len_trim(hd_i_step_sgs_coefs))
      maxlen = max(maxlen, len_trim(hd_i_step_boundary))
      maxlen = max(maxlen, len_trim(hd_i_diff_steps))
      maxlen = max(maxlen, len_trim(hd_ratio_to_cfl))
      maxlen = max(maxlen, len_trim(hd_start_rst_step))
      maxlen = max(maxlen, len_trim(hd_end_rst_step))
      maxlen = max(maxlen, len_trim(hd_flexible_step))
!
      write(id_control,'(a1)') '!'
      level = write_begin_flag_for_ctl(id_control, level, hd_block)
!
!
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_elapsed_time, tctl%elapsed_time_ctl)
!
      write(id_control,'(a1)') '!'
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_init, tctl%i_step_init_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_finish_number, tctl%i_step_number_ctl)
!
      write(id_control,'(a1)') '!'
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_check, tctl%i_step_check_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_rst, tctl%i_step_rst_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_section, tctl%i_step_psf_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_isosurf,  tctl%i_step_iso_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_psf, tctl%i_step_psf_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_iso, tctl%i_step_iso_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_pvr, tctl%i_step_pvr_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_fline, tctl%i_step_fline_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_lic, tctl%i_step_lic_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_ucd, tctl%i_step_ucd_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_monitor, tctl%i_step_monitor_ctl)
!
      write(id_control,'(a1)') '!'
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_dt, tctl%dt_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_time_init, tctl%time_init_ctl)
!
      write(id_control,'(a1)') '!'
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_min_delta_t, tctl%min_delta_t_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_max_delta_t, tctl%max_delta_t_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_max_eps_to_shrink, tctl%max_eps_to_shrink_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_min_eps_to_expand, tctl%min_eps_to_expand_ctl)
!
      write(id_control,'(a1)') '!'
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_check, tctl%delta_t_check_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_rst, tctl%delta_t_rst_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_section, tctl%delta_t_psf_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_isosurf, tctl%delta_t_iso_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_pvr, tctl%delta_t_pvr_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_fline, tctl%delta_t_fline_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_lic, tctl%delta_t_lic_ctl)
!
!
      write(id_control,'(a1)') '!'
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_ucd, tctl%delta_t_field_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_monitor, tctl%delta_t_monitor_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_sgs_coefs, tctl%delta_t_sgs_coefs_ctl)
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_delta_t_boundary, tctl%delta_t_boundary_ctl)
!
      call write_real_ctl_type(id_control, level, maxlen,               &
     &    hd_ratio_to_cfl, tctl%ratio_to_cfl_ctl)
!
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_sgs_coefs, tctl%i_step_sgs_coefs_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_step_boundary, tctl%i_step_boundary_ctl)
!
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_i_diff_steps, tctl%i_diff_steps_ctl)
!
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_start_rst_step, tctl%start_rst_step_ctl)
      call write_integer_ctl_type(id_control, level, maxlen,            &
     &    hd_end_rst_step, tctl%end_rst_step_ctl)
!
      write(id_control,'(a1)') '!'
      call write_chara_ctl_type(id_control, level, maxlen,              &
     &    hd_flexible_step, tctl%flexible_step_ctl)
!
      level =  write_end_flag_for_ctl(id_control, level, hd_block)
!
      end subroutine write_control_time_step_data
!
!  ---------------------------------------------------------------------
!  ---------------------------------------------------------------------
!
      integer(kind = kint) function num_label_time_step_ctl()
      num_label_time_step_ctl = n_label_time_step_ctl
      return
      end function num_label_time_step_ctl
!
! ----------------------------------------------------------------------
!
      integer(kind = kint) function num_label_time_step_ctl_w_dep()
      num_label_time_step_ctl_w_dep = n_label_time_step_ctl_w_dep
      return
      end function num_label_time_step_ctl_w_dep
!
! ----------------------------------------------------------------------
!
      subroutine set_label_time_step_ctl(names)
!
      character(len = kchara), intent(inout)                            &
     &                         :: names(n_label_time_step_ctl_w_dep)
!
!
      call set_control_labels(hd_elapsed_time,  names( 1))
      call set_control_labels(hd_time_init,     names( 2))
      call set_control_labels(hd_dt,            names( 3))
!
      call set_control_labels(hd_i_step_init,     names( 4))
      call set_control_labels(hd_i_finish_number, names( 5))
      call set_control_labels(hd_i_step_check,    names( 6))
      call set_control_labels(hd_i_step_rst,      names( 7))
!
      call set_control_labels(hd_i_step_section, names( 8))
      call set_control_labels(hd_i_step_isosurf, names( 9))
      call set_control_labels(hd_i_step_pvr,     names(10))
      call set_control_labels(hd_i_step_fline,   names(11))
      call set_control_labels(hd_i_step_lic,     names(12))
!
      call set_control_labels(hd_i_step_ucd,       names(13))
      call set_control_labels(hd_i_step_monitor,   names(14))
      call set_control_labels(hd_i_step_sgs_coefs, names(15))
      call set_control_labels(hd_i_step_boundary,  names(16))
      call set_control_labels(hd_i_diff_steps,     names(17))
!
!
      call set_control_labels(hd_flexible_step,      names(18))
      call set_control_labels(hd_min_delta_t,        names(19))
      call set_control_labels(hd_max_delta_t,        names(20))
      call set_control_labels(hd_max_eps_to_shrink,  names(21))
      call set_control_labels(hd_min_eps_to_expand,  names(22))
!
      call set_control_labels(hd_ratio_to_cfl,       names(23))
!
      call set_control_labels(hd_start_rst_step,     names(24))
      call set_control_labels(hd_end_rst_step,       names(25))
!
      call set_control_labels(hd_delta_t_check,   names(26))
      call set_control_labels(hd_delta_t_rst,     names(27))
!
      call set_control_labels(hd_delta_t_section, names(28))
      call set_control_labels(hd_delta_t_isosurf, names(29))
      call set_control_labels(hd_delta_t_pvr,     names(30))
      call set_control_labels(hd_delta_t_fline,   names(31))
      call set_control_labels(hd_delta_t_lic,     names(32))
!
      call set_control_labels(hd_delta_t_ucd,        names(33))
      call set_control_labels(hd_delta_t_monitor,    names(34))
      call set_control_labels(hd_delta_t_sgs_coefs,  names(35))
      call set_control_labels(hd_delta_t_boundary,   names(36))
!
!
      call set_control_labels(hd_i_step_number,     names(37))
      call set_control_labels(hd_i_step_psf,        names(38))
      call set_control_labels(hd_i_step_iso,        names(39))
!
      end subroutine set_label_time_step_ctl
!
!  ---------------------------------------------------------------------
!
      end module t_ctl_data_4_time_steps
