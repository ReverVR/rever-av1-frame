# Rever's changes (GPL-2.0 section 2(a) notice)

The files below were changed by Rever VR (2026-11-02 to 2026-11-04) from Linux v7.2's
`drivers/media/platform/qcom/iris` (commit `8d3ae59288f1e7d58d76558a6ee96d533bc5019f`). The exact diff is
`patches/0001-rever-changes-to-linux-v7.2-iris.patch`; in the source each change is marked `Rever lab`.
Every other `iris_*` file is upstream v7.2 byte for byte (`module/provenance.json` holds their SHA-256).

Los archivos de abajo los cambió Rever VR (del 2026-11-02 al 2026-11-04) a partir del
`drivers/media/platform/qcom/iris` de Linux v7.2. El diff exacto está en
`patches/0001-rever-changes-to-linux-v7.2-iris.patch`; en el código, cada cambio lleva la marca `Rever lab`.

| File | Change | Date |
| --- | --- | --- |
| `Makefile` | Out-of-tree module `steam-frame-av1-lab`; the V4L2 mem2mem framework built in (the Frame kernel has it disabled), the 6.x or 7.x copy by kernel series; `frame_av1_compat.h` and the Frame firmware path. | 2026-11-02, 2026-11-04 (v7.8) |
| `iris_buffer.c` | `kzalloc_obj()` replaced with `kzalloc()` so the code also builds on 6.18. | 2026-11-02 |
| `iris_core.c`, `iris_core.h` | A power-collapsed core released without waking it; a late answer to a timed-out init ignored; a firmware that never answered released; error state left until teardown; the Frame firmware's device fields. | 2026-11-02 (v7.3, v7.5, v7.6) |
| `iris_firmware.c` | The Frame's no-TrustZone firmware load, boot, unload and suspend (`frame_firmware_no_tz.c`). | 2026-11-02 |
| `iris_hfi_gen1_command.c`, `iris_hfi_gen2_command.c`, `iris_venc.c` | `kzalloc_obj()` replaced with `kzalloc()` (builds on 6.18 too). | 2026-11-02 |
| `iris_instance.h` | `rever_peak_rate`: the highest frame rate measured in the session. | 2026-11-03 (v7.7) |
| `iris_platform_vpu3x.c` | SM8650 firmware name: the Frame's own `qcom/vpu/vpu33_4v.mbn`. | 2026-11-02 |
| `iris_vpu3x.c` | A timed-out controller power-off handshake logged (the clock is left on). | 2026-11-02 (v7.4/v7.5) |
| `iris_power.c` | Module parameters `max_clock`, `rever_clock_margin`, `rever_vr_fps`: the clock and DDR vote for VR bitrates. | 2026-11-02, 2026-11-03 |
| `iris_probe.c` | Module parameters `arm_av1_lab` (AV1 off unless set) and `rever_let_go`; probe limited to the Frame kernels it was checked on (6.18.0-g83913f38113c, 7.2.0-g9a8c8ea46950); no modalias, so it is never loaded automatically. | 2026-11-02, 2026-11-04 (v7.8) |
| `iris_resources.c` | A clock already enabled by the previous driver is not an error. | 2026-11-02 |
| `iris_vdec.c` | `rever_rate_floor_pct`: the measured rate never below a share of its peak; repeated `S_FMT` after `STREAMOFF` accepted. | 2026-11-03 (v7.7) |
| `iris_vidc.c` | V4L2 card names `iris_decoder` / `iris_encoder`, as the Frame's stock driver reports them. | 2026-11-02 |
| `iris_vpu_common.c` | Software control before power-on; `rever_vsp_factor` for the bitstream parser's cycles. | 2026-11-02 |

New files / archivos nuevos:

| File | Origin | Rever's change |
| --- | --- | --- |
| `frame_firmware_no_tz.c`, `frame_firmware_no_tz.h` | SteamFrame-Advanced-Options (elliotttate), `Frame/AV1/`, GPL-2.0-only | `frame_fw_hold_cpu()`: the firmware CPU held in reset before its image is written (2026-11-02). |
| `frame_av1_compat.h` | SteamFrame-Advanced-Options, GPL-2.0-only | The UBWC readers of v7.2 for 6.18 headers; skipped when the headers have `UBWC_6_0` (2026-11-02, 2026-11-04). |
| `frame-port.patch` | SteamFrame-Advanced-Options | Kept for reference: the board port as a patch. |
| `v4l2-mem2mem.c` | Linux v6.18, unchanged | - |
| `v4l2-mem2mem-k72.c` | Linux v7.2, unchanged | - |
| `provenance.json` | Rever | The list of upstream files and their hashes. |
