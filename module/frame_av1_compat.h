/* SPDX-License-Identifier: GPL-2.0-only */
#ifndef STEAM_FRAME_AV1_COMPAT_H
#define STEAM_FRAME_AV1_COMPAT_H
#include <linux/videodev2.h>
#define FRAME_AV1_LAB_DECODE_FPS 120
/* Stateful AV1 FourCC, upstream Linux 7.0. Absent in the Frame 6.18 ABI. */
#ifndef V4L2_PIX_FMT_AV1
#define V4L2_PIX_FMT_AV1 v4l2_fourcc('A', 'V', '0', '1')
#endif
/* Rever lab (2026-11-02): the UBWC config readers upstream v7.2 iris uses (include/linux/soc/qcom/ubwc.h gained them
 * after 6.18; the Frame's 6.18 has the same struct qcom_ubwc_cfg_data and exports qcom_ubwc_config_get_data). Copied
 * from v7.2's header; drop them if the Frame's headers ever carry them. */
#include <linux/printk.h>
#include <linux/soc/qcom/ubwc.h>
/* Rever lab v7.8 (2026-11-04): the Frame's 7.2 kernel (SteamOS 0.5.7) carries these readers, and UBWC_6_0, in its
 * own header - only a header without UBWC_6_0 (6.18) gets the copies below */
#ifndef UBWC_6_0
#define FRAME_AV1_UBWC_READERS
#define UBWC_6_0 0x60000000
#endif
#ifndef UBWC_3_1
#define UBWC_3_1 0x30010000
#endif
#ifdef FRAME_AV1_UBWC_READERS
static inline bool qcom_ubwc_min_acc_length_64b(const struct qcom_ubwc_cfg_data *cfg)
{
	return cfg->ubwc_enc_version == UBWC_1_0 &&
		(cfg->ubwc_dec_version == UBWC_2_0 || cfg->ubwc_dec_version == UBWC_3_0);
}
static inline bool qcom_ubwc_macrotile_mode(const struct qcom_ubwc_cfg_data *cfg)
{
	return cfg->macrotile_mode;
}
static inline bool qcom_ubwc_bank_spread(const struct qcom_ubwc_cfg_data *cfg)
{
	return cfg->ubwc_bank_spread;
}
static inline u32 qcom_ubwc_swizzle(const struct qcom_ubwc_cfg_data *cfg)
{
	return cfg->ubwc_swizzle;
}
static inline u32 qcom_ubwc_version_tag(const struct qcom_ubwc_cfg_data *cfg)
{
	if (cfg->ubwc_enc_version >= UBWC_6_0)
		return 5;
	if (cfg->ubwc_enc_version >= UBWC_5_0)
		return 4;
	if (cfg->ubwc_enc_version >= UBWC_4_3)
		return 3;
	if (cfg->ubwc_enc_version >= UBWC_4_0)
		return 2;
	if (cfg->ubwc_enc_version >= UBWC_3_0)
		return 1;
	return 0;
}
static inline bool qcom_ubwc_enable_amsbc(const struct qcom_ubwc_cfg_data *cfg)
{
	return cfg->ubwc_enc_version >= UBWC_3_0;
}
#endif /* FRAME_AV1_UBWC_READERS */
#endif
