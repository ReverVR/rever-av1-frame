steam-frame-av1-lab-objs += iris_buffer.o \
             iris_common.o \
             iris_core.o \
             iris_ctrls.o \
             iris_firmware.o \
             iris_hfi_common.o \
             iris_hfi_gen1.o \
             iris_hfi_gen1_command.o \
             iris_hfi_gen1_response.o \
             iris_hfi_gen2.o \
             iris_hfi_gen2_command.o \
             iris_hfi_gen2_packet.o \
             iris_hfi_gen2_response.o \
             iris_hfi_queue.o \
             iris_platform_vpu2.o \
             iris_platform_vpu3x.o \
             iris_power.o \
             iris_probe.o \
             iris_resources.o \
             iris_state.o \
             iris_utils.o \
             iris_vidc.o \
             iris_vb2.o \
             iris_vdec.o \
             iris_venc.o \
             iris_vpu2.o \
             iris_vpu3x.o \
             iris_vpu4x.o \
             iris_vpu_buffer.o \
             iris_vpu_common.o \

obj-m += steam-frame-av1-lab.o

# Baseline Frame kernel has CONFIG_V4L2_MEM2MEM_DEV disabled (6.18 and 7.2 alike): the framework comes with the
# module, in the kernel series' own version (Rever lab v7.8: 7.2's v4l2_m2m_buf_copy_metadata has two arguments)
ifeq ($(VERSION),6)
steam-frame-av1-lab-objs += v4l2-mem2mem.o
else
steam-frame-av1-lab-objs += v4l2-mem2mem-k72.o
endif

ccflags-y += -include $(src)/frame_av1_compat.h
steam-frame-av1-lab-objs += frame_firmware_no_tz.o
