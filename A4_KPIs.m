function KPIs = A4_KPIs(BUS, a_b_ref_sim, slip_ref_front_sim, slip_ref_rear_sim, start_distance, end_distance)

start_idx = find(BUS.States.x_b.Data >= start_distance, 1);
end_idx   = find(BUS.States.x_b.Data >= end_distance, 1);

        KPIs.RMSE_x_b_ddot      = ...
            rms(a_b_ref_sim.Data(start_idx:end_idx)-BUS.Accelerations.x_b_ddot.Data(start_idx:end_idx));
        KPIs.VDV_x_b_ddot       = ...
            (trapz(a_b_ref_sim.Time(start_idx:end_idx),(a_b_ref_sim.Data(start_idx:end_idx)-BUS.Accelerations.x_b_ddot.Data(start_idx:end_idx)).^4))^(1/4);
        KPIs.RMS_slip_viol_F    = ...
            rms(max(0,BUS.States.slip_F_L.Data(start_idx:end_idx)-slip_ref_front_sim.Data(start_idx:end_idx)));
        KPIs.RMS_slip_viol_R    = ...
            rms(max(0,BUS.States.slip_R_L.Data(start_idx:end_idx)-slip_ref_rear_sim.Data(start_idx:end_idx)));
        KPIs.max_delta_omega    = ...
            max(abs([BUS.States.omega_F_L.Data(start_idx:end_idx)-BUS.Differentials.theta_s_dot_F_L.Data(start_idx:end_idx); BUS.States.omega_R_L.Data(start_idx:end_idx)-BUS.Differentials.theta_s_dot_R_L.Data(start_idx:end_idx)]));
        KPIs.slip_viol_max      = ...
            max(max(0,[BUS.States.slip_F_L.Data(start_idx:end_idx)-slip_ref_front_sim.Data(start_idx:end_idx); BUS.States.slip_R_L.Data(start_idx:end_idx)-slip_ref_rear_sim.Data(start_idx:end_idx)]));        


disp(KPIs);