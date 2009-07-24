Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZGXWBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZGXWBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZGXWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:01:18 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3115 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbZGXWBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:01:13 -0400
Subject: [PATCH linux-next] treewide: remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
       David Miller <davem@davemloft.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 15:01:06 -0700
Message-Id: <1248472866.3498.79.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous discussion at: http://lkml.org/lkml/2009/6/28/288

Signed-off-by: Joe Perches <joe@perches.com>

 arch/arm/mach-at91/at91cap9_devices.c              |    2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    2 +-
 arch/arm/mach-w90x900/w90p910.c                    |    2 +-
 arch/arm/plat-mxc/irq.c                            |    2 +-
 arch/s390/hypfs/inode.c                            |    2 +-
 arch/s390/kvm/interrupt.c                          |    2 +-
 arch/sparc/kernel/irq_64.c                         |    2 +-
 arch/um/drivers/net_kern.c                         |    2 +-
 drivers/ata/pata_octeon_cf.c                       |    2 +-
 drivers/ata/sata_inic162x.c                        |    2 +-
 drivers/block/DAC960.c                             |    4 ++--
 drivers/block/swim3.c                              |    2 +-
 drivers/char/epca.c                                |    2 +-
 drivers/gpu/drm/i915/intel_dp.c                    |    2 +-
 drivers/gpu/drm/radeon/r300.c                      |    4 ++--
 drivers/ide/ide-probe.c                            |    2 +-
 drivers/ide/umc8672.c                              |    4 ++--
 drivers/isdn/capi/capiutil.c                       |    2 +-
 drivers/macintosh/rack-meter.c                     |    2 +-
 drivers/mmc/host/imxmmc.c                          |    2 +-
 drivers/net/arcnet/arc-rawmode.c                   |    1 -
 drivers/net/arcnet/capmode.c                       |    1 -
 drivers/net/bnx2x_link.c                           |    4 ++--
 drivers/net/gianfar_ethtool.c                      |    2 +-
 drivers/net/ibm_newemac/core.c                     |    8 ++++----
 drivers/net/igb/igb_main.c                         |    4 ++--
 drivers/net/ll_temac_main.c                        |    2 +-
 drivers/net/ni52.c                                 |    4 ++--
 drivers/net/qlge/qlge_main.c                       |    4 ++--
 drivers/net/skfp/pcmplc.c                          |    2 +-
 drivers/net/skfp/pmf.c                             |    8 ++++----
 drivers/net/skge.c                                 |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/vxge/vxge-config.h                     |    2 +-
 drivers/net/vxge/vxge-main.c                       |    4 ++--
 drivers/net/wireless/iwmc3200wifi/rx.c             |    8 ++++----
 drivers/pcmcia/pcmcia_resource.c                   |    2 +-
 drivers/rtc/rtc-omap.c                             |    2 +-
 drivers/s390/block/dasd_eckd.c                     |    2 +-
 drivers/s390/net/netiucv.c                         |    2 +-
 drivers/s390/scsi/zfcp_scsi.c                      |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |    2 +-
 drivers/spi/omap_uwire.c                           |    2 +-
 drivers/spi/spi_s3c24xx.c                          |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    2 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    2 +-
 drivers/staging/dream/smd/smd_rpcrouter_device.c   |    2 +-
 drivers/staging/go7007/go7007-driver.c             |    2 +-
 drivers/staging/hv/NetVsc.c                        |    2 +-
 drivers/staging/hv/StorVsc.c                       |    2 +-
 drivers/staging/otus/80211core/cmmsta.c            |    2 +-
 drivers/staging/otus/hal/hpmain.c                  |    2 +-
 drivers/staging/rt2860/common/cmm_data_2860.c      |    8 ++++----
 drivers/staging/rt2860/rt_linux.c                  |    2 +-
 drivers/staging/rt2860/rtmp.h                      |    3 +--
 drivers/staging/rt2860/sta/aironet.c               |    2 +-
 drivers/staging/rt3090/common/cmm_data_pci.c       |    4 ++--
 drivers/staging/rt3090/rt_linux.c                  |    2 +-
 drivers/staging/rt3090/rtmp.h                      |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |    2 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/vt6655/card.c                      |    2 +-
 drivers/staging/vt6655/iwctl.c                     |    2 +-
 drivers/staging/vt6655/wpa2.c                      |    4 ++--
 drivers/staging/vt6656/baseband.c                  |    2 +-
 drivers/staging/vt6656/iwctl.c                     |    2 +-
 drivers/staging/vt6656/mac.h                       |    2 +-
 drivers/staging/vt6656/main_usb.c                  |    2 +-
 drivers/staging/vt6656/power.c                     |    2 +-
 drivers/staging/vt6656/wpa2.c                      |    4 ++--
 drivers/usb/class/cdc-wdm.c                        |    2 --
 drivers/usb/serial/spcp8x5.c                       |    2 +-
 drivers/uwb/i1480/i1480u-wlp/netdev.c              |    2 +-
 drivers/video/cfbcopyarea.c                        |    2 +-
 drivers/video/imxfb.c                              |    2 +-
 drivers/video/s3c2410fb.c                          |    2 +-
 drivers/xen/balloon.c                              |    2 +-
 fs/autofs/dirhash.c                                |    2 +-
 fs/btrfs/tree-log.c                                |    2 +-
 fs/cifs/cifs_dfs_ref.c                             |    2 +-
 fs/nfs/callback_xdr.c                              |    2 +-
 fs/ocfs2/quota_global.c                            |    2 +-
 fs/ubifs/scan.c                                    |    2 +-
 include/scsi/fc/fc_fc2.h                           |    3 +--
 kernel/trace/trace_hw_branches.c                   |    2 +-
 net/wireless/wext-compat.c                         |    2 +-
 sound/oss/sys_timer.c                              |    3 ---
 sound/soc/codecs/wm8993.c                          |    2 +-
 sound/soc/codecs/wm9081.c                          |    2 +-
 sound/soc/pxa/pxa-ssp.c                            |    2 +-
 sound/soc/s3c24xx/s3c24xx_uda134x.c                |    2 +-
 97 files changed, 116 insertions(+), 125 deletions(-)

diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
index 412aa49..799c11e 100644
--- a/arch/arm/mach-at91/at91cap9_devices.c
+++ b/arch/arm/mach-at91/at91cap9_devices.c
@@ -171,7 +171,7 @@ void __init at91_add_device_usba(struct usba_platform_data *data)
 	 */
 	usba_udc_data.pdata.vbus_pin = -EINVAL;
 	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
-	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
 
 	if (data && data->vbus_pin > 0) {
 		at91_set_gpio_input(data->vbus_pin, 0);
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index d746e86..0a0c32f 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -150,7 +150,7 @@ void __init at91_add_device_usba(struct usba_platform_data *data)
 {
 	usba_udc_data.pdata.vbus_pin = -EINVAL;
 	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
-	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
 
 	if (data && data->vbus_pin > 0) {
 		at91_set_gpio_input(data->vbus_pin, 0);
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 7281865..e87237b 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -99,7 +99,7 @@ void __init at91_add_device_usba(struct usba_platform_data *data)
 	 */
 	usba_udc_data.pdata.vbus_pin = -EINVAL;
 	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
-	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
 
 	if (data && data->vbus_pin > 0) {
 		at91_set_gpio_input(data->vbus_pin, 0);
diff --git a/arch/arm/mach-w90x900/w90p910.c b/arch/arm/mach-w90x900/w90p910.c
index 6ebf5cf..bc38dd6 100644
--- a/arch/arm/mach-w90x900/w90p910.c
+++ b/arch/arm/mach-w90x900/w90p910.c
@@ -65,7 +65,7 @@ static DEFINE_CLK(emc, 7);
 static DEFINE_SUBCLK(rmii, 2);
 static DEFINE_CLK(usbd, 8);
 static DEFINE_CLK(usbh, 9);
-static DEFINE_CLK(g2d, 10);;
+static DEFINE_CLK(g2d, 10);
 static DEFINE_CLK(pwm, 18);
 static DEFINE_CLK(ps2, 24);
 static DEFINE_CLK(kpi, 25);
diff --git a/arch/arm/plat-mxc/irq.c b/arch/arm/plat-mxc/irq.c
index 8aee763..c2106d5 100644
--- a/arch/arm/plat-mxc/irq.c
+++ b/arch/arm/plat-mxc/irq.c
@@ -53,7 +53,7 @@ int imx_irq_set_priority(unsigned char irq, unsigned char prio)
 	unsigned int mask = 0x0F << irq % 8 * 4;
 
 	if (irq >= MXC_INTERNAL_IRQS)
-		return -EINVAL;;
+		return -EINVAL;
 
 	temp = __raw_readl(avic_base + AVIC_NIPRIORITY(irq / 8));
 	temp &= ~mask;
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 5a805df..ad0a1dd 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -500,7 +500,7 @@ static int __init hypfs_init(void)
 	}
 	s390_kobj = kobject_create_and_add("s390", hypervisor_kobj);
 	if (!s390_kobj) {
-		rc = -ENOMEM;;
+		rc = -ENOMEM;
 		goto fail_sysfs;
 	}
 	rc = register_filesystem(&hypfs_type);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 5f2e144..851c142 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -478,7 +478,7 @@ int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code)
 	if (!inti)
 		return -ENOMEM;
 
-	inti->type = KVM_S390_PROGRAM_INT;;
+	inti->type = KVM_S390_PROGRAM_INT;
 	inti->pgm.code = code;
 
 	VCPU_EVENT(vcpu, 3, "inject: program check %d (from kernel)", code);
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index f0ee790..ea183b9 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -229,7 +229,7 @@ static unsigned int sun4u_compute_tid(unsigned long imap, unsigned long cpuid)
 				tid = ((a << IMAP_AID_SHIFT) |
 				       (n << IMAP_NID_SHIFT));
 				tid &= (IMAP_AID_SAFARI |
-					IMAP_NID_SAFARI);;
+					IMAP_NID_SAFARI);
 			}
 		} else {
 			tid = cpuid << IMAP_TID_SHIFT;
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 4c75409..9483c19 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -533,7 +533,7 @@ static int eth_parse(char *str, int *index_out, char **str_out,
 		     char **error_out)
 {
 	char *end;
-	int n, err = -EINVAL;;
+	int n, err = -EINVAL;
 
 	n = simple_strtoul(str, &end, 0);
 	if (end == str) {
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 8d9343a..fc50dec 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -213,7 +213,7 @@ static void octeon_cf_set_dmamode(struct ata_port *ap, struct ata_device *dev)
 	 * This is tI, C.F. spec. says 0, but Sony CF card requires
 	 * more, we use 20 nS.
 	 */
-	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, 20);;
+	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, 20);
 	dma_tim.s.dmack_h = ns_to_tim_reg(tim_mult, dma_ackh);
 
 	dma_tim.s.dmarq = dma_arq;
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 8d890cc..4406902 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -405,7 +405,7 @@ static irqreturn_t inic_interrupt(int irq, void *dev_instance)
 	struct ata_host *host = dev_instance;
 	struct inic_host_priv *hpriv = host->private_data;
 	u16 host_irq_stat;
-	int i, handled = 0;;
+	int i, handled = 0;
 
 	host_irq_stat = readw(hpriv->mmio_base + HOST_IRQ_STAT);
 
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index b839af1..26caa3f 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6653,7 +6653,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	else ErrorCode = get_user(ControllerNumber,
 			     &UserSpaceControllerInfo->ControllerNumber);
 	if (ErrorCode != 0)
-		break;;
+		break;
 	ErrorCode = -ENXIO;
 	if (ControllerNumber < 0 ||
 	    ControllerNumber > DAC960_ControllerCount - 1) {
@@ -6661,7 +6661,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	}
 	Controller = DAC960_Controllers[ControllerNumber];
 	if (Controller == NULL)
-		break;;
+		break;
 	memset(&ControllerInfo, 0, sizeof(DAC960_ControllerInfo_T));
 	ControllerInfo.ControllerNumber = ControllerNumber;
 	ControllerInfo.FirmwareType = Controller->FirmwareType;
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 80df93e..572ec61 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1062,7 +1062,7 @@ static int swim3_add_device(struct macio_dev *mdev, int index)
 		goto out_release;
 	}
 	fs->swim3_intr = macio_irq(mdev, 0);
-	fs->dma_intr = macio_irq(mdev, 1);;
+	fs->dma_intr = macio_irq(mdev, 1);
 	fs->cur_cyl = -1;
 	fs->cur_sector = -1;
 	fs->secpercyl = 36;
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index ff647ca..9d589e3 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -2239,7 +2239,7 @@ static void do_softint(struct work_struct *work)
 	struct channel *ch = container_of(work, struct channel, tqueue);
 	/* Called in response to a modem change event */
 	if (ch && ch->magic == EPCA_MAGIC) {
-		struct tty_struct *tty = tty_port_tty_get(&ch->port);;
+		struct tty_struct *tty = tty_port_tty_get(&ch->port);
 
 		if (tty && tty->driver_data) {
 			if (test_and_clear_bit(EPCA_EVENT_HANGUP, &ch->event)) {
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 6770ae8..68d3f2c 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -211,7 +211,7 @@ intel_dp_aux_ch(struct intel_output *intel_output,
 	for (try = 0; try < 5; try++) {
 		/* Load the send data into the aux channel data registers */
 		for (i = 0; i < send_bytes; i += 4) {
-			uint32_t    d = pack_aux(send + i, send_bytes - i);;
+			uint32_t    d = pack_aux(send + i, send_bytes - i);
 	
 			I915_WRITE(ch_data + i, d);
 		}
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index e2ed5bc..e471a9c 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1276,11 +1276,11 @@ static int r300_packet0_check(struct radeon_cs_parser *p,
 	case 0x443C:
 		/* TX_FILTER0_[0-15] */
 		i = (reg - 0x4400) >> 2;
-		tmp = ib_chunk->kdata[idx] & 0x7;;
+		tmp = ib_chunk->kdata[idx] & 0x7;
 		if (tmp == 2 || tmp == 4 || tmp == 6) {
 			track->textures[i].roundup_w = false;
 		}
-		tmp = (ib_chunk->kdata[idx] >> 3) & 0x7;;
+		tmp = (ib_chunk->kdata[idx] >> 3) & 0x7;
 		if (tmp == 2 || tmp == 4 || tmp == 6) {
 			track->textures[i].roundup_h = false;
 		}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 1bb106f..20120fd 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1201,7 +1201,7 @@ static int ide_find_port_slot(const struct ide_port_info *d)
 {
 	int idx = -ENOENT;
 	u8 bootable = (d && (d->host_flags & IDE_HFLAG_NON_BOOTABLE)) ? 0 : 1;
-	u8 i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;;
+	u8 i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;
 
 	/*
 	 * Claim an unassigned slot.
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index 0608d41..60f936e 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -170,9 +170,9 @@ static int __init umc8672_init(void)
 		goto out;
 
 	if (umc8672_probe() == 0)
-		return 0;;
+		return 0;
 out:
-	return -ENODEV;;
+	return -ENODEV;
 }
 
 module_init(umc8672_init);
diff --git a/drivers/isdn/capi/capiutil.c b/drivers/isdn/capi/capiutil.c
index 16f2e46..26626ee 100644
--- a/drivers/isdn/capi/capiutil.c
+++ b/drivers/isdn/capi/capiutil.c
@@ -1019,7 +1019,7 @@ int __init cdebug_init(void)
 	if (!g_debbuf->buf) {
 		kfree(g_cmsg);
 		kfree(g_debbuf);
-		return -ENOMEM;;
+		return -ENOMEM;
 	}
 	g_debbuf->size = CDEBUG_GSIZE;
 	g_debbuf->buf[0] = 0;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index a98ab72..93fb320 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -274,7 +274,7 @@ static void __devinit rackmeter_init_cpu_sniffer(struct rackmeter *rm)
 
 		if (cpu > 1)
 			continue;
-		rcpu = &rm->cpu[cpu];;
+		rcpu = &rm->cpu[cpu];
 		rcpu->prev_idle = get_cpu_idle_time(cpu);
 		rcpu->prev_wall = jiffies64_to_cputime64(get_jiffies_64());
 		schedule_delayed_work_on(cpu, &rm->cpu[cpu].sniffer,
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index e0be21a..bf98d7c 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -652,7 +652,7 @@ static irqreturn_t imxmci_irq(int irq, void *devid)
 	set_bit(IMXMCI_PEND_STARTED_b, &host->pending_events);
 	tasklet_schedule(&host->tasklet);
 
-	return IRQ_RETVAL(handled);;
+	return IRQ_RETVAL(handled);
 }
 
 static void imxmci_tasklet_fnc(unsigned long data)
diff --git a/drivers/net/arcnet/arc-rawmode.c b/drivers/net/arcnet/arc-rawmode.c
index 646dfc5..8ea9c75 100644
--- a/drivers/net/arcnet/arc-rawmode.c
+++ b/drivers/net/arcnet/arc-rawmode.c
@@ -123,7 +123,6 @@ static void rx(struct net_device *dev, int bufnum,
 	BUGLVL(D_SKB) arcnet_dump_skb(dev, skb, "rx");
 
 	skb->protocol = cpu_to_be16(ETH_P_ARCNET);
-;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/arcnet/capmode.c b/drivers/net/arcnet/capmode.c
index 083e210..66bcbbb 100644
--- a/drivers/net/arcnet/capmode.c
+++ b/drivers/net/arcnet/capmode.c
@@ -149,7 +149,6 @@ static void rx(struct net_device *dev, int bufnum,
 	BUGLVL(D_SKB) arcnet_dump_skb(dev, skb, "rx");
 
 	skb->protocol = cpu_to_be16(ETH_P_ARCNET);
-;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/bnx2x_link.c b/drivers/net/bnx2x_link.c
index 1f17334..1e9d1f9 100644
--- a/drivers/net/bnx2x_link.c
+++ b/drivers/net/bnx2x_link.c
@@ -2424,7 +2424,7 @@ static u8 bnx2x_8726_read_sfp_module_eeprom(struct link_params *params,
 			      MDIO_PMA_REG_SFP_TWO_WIRE_CTRL, &val);
 		if ((val & MDIO_PMA_REG_SFP_TWO_WIRE_CTRL_STATUS_MASK) ==
 		    MDIO_PMA_REG_SFP_TWO_WIRE_STATUS_IDLE)
-			return 0;;
+			return 0;
 		msleep(1);
 	}
 	return -EINVAL;
@@ -2528,7 +2528,7 @@ static u8 bnx2x_8727_read_sfp_module_eeprom(struct link_params *params,
 			      MDIO_PMA_REG_SFP_TWO_WIRE_CTRL, &val);
 		if ((val & MDIO_PMA_REG_SFP_TWO_WIRE_CTRL_STATUS_MASK) ==
 		    MDIO_PMA_REG_SFP_TWO_WIRE_STATUS_IDLE)
-			return 0;;
+			return 0;
 		msleep(1);
 	}
 
diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
index dbf06e9..1c1790d 100644
--- a/drivers/net/gianfar_ethtool.c
+++ b/drivers/net/gianfar_ethtool.c
@@ -293,7 +293,7 @@ static int gfar_gcoalesce(struct net_device *dev, struct ethtool_coalesce *cvals
 	rxtime  = get_ictt_value(priv->rxic);
 	rxcount = get_icft_value(priv->rxic);
 	txtime  = get_ictt_value(priv->txic);
-	txcount = get_icft_value(priv->txic);;
+	txcount = get_icft_value(priv->txic);
 	cvals->rx_coalesce_usecs = gfar_ticks2usecs(priv, rxtime);
 	cvals->rx_max_coalesced_frames = rxcount;
 
diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index 5443558..635f122 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -2557,13 +2557,13 @@ static int __devinit emac_init_config(struct emac_instance *dev)
 	if (emac_read_uint_prop(np, "mdio-device", &dev->mdio_ph, 0))
 		dev->mdio_ph = 0;
 	if (emac_read_uint_prop(np, "zmii-device", &dev->zmii_ph, 0))
-		dev->zmii_ph = 0;;
+		dev->zmii_ph = 0;
 	if (emac_read_uint_prop(np, "zmii-channel", &dev->zmii_port, 0))
-		dev->zmii_port = 0xffffffff;;
+		dev->zmii_port = 0xffffffff;
 	if (emac_read_uint_prop(np, "rgmii-device", &dev->rgmii_ph, 0))
-		dev->rgmii_ph = 0;;
+		dev->rgmii_ph = 0;
 	if (emac_read_uint_prop(np, "rgmii-channel", &dev->rgmii_port, 0))
-		dev->rgmii_port = 0xffffffff;;
+		dev->rgmii_port = 0xffffffff;
 	if (emac_read_uint_prop(np, "fifo-entry-size", &dev->fifo_entry_size, 0))
 		dev->fifo_entry_size = 16;
 	if (emac_read_uint_prop(np, "mal-burst-size", &dev->mal_burst_size, 0))
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index adb09d3..8abc8e9 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -165,7 +165,7 @@ static inline void igb_set_rah_pool(struct e1000_hw *hw, int pool, int entry)
 
 	reg_data = rd32(E1000_RAH(entry));
 	reg_data &= ~E1000_RAH_POOL_MASK;
-	reg_data |= E1000_RAH_POOL_1 << pool;;
+	reg_data |= E1000_RAH_POOL_1 << pool;
 	wr32(E1000_RAH(entry), reg_data);
 }
 
@@ -3935,7 +3935,7 @@ static int igb_set_vf_multicasts(struct igb_adapter *adapter,
 	/* VFs are limited to using the MTA hash table for their multicast
 	 * addresses */
 	for (i = 0; i < n; i++)
-		vf_data->vf_mc_hashes[i] = hash_list[i];;
+		vf_data->vf_mc_hashes[i] = hash_list[i];
 
 	/* Flush and reset the mta with the new values */
 	igb_set_multi(adapter->netdev);
diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index da8d0a0..f2a197f 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -865,7 +865,7 @@ temac_of_probe(struct of_device *op, const struct of_device_id *match)
 	dcrs = dcr_resource_start(np, 0);
 	if (dcrs == 0) {
 		dev_err(&op->dev, "could not get DMA register address\n");
-		goto nodev;;
+		goto nodev;
 	}
 	lp->sdma_dcrs = dcr_map(np, dcrs, dcr_resource_len(np, 0));
 	dev_dbg(&op->dev, "DCR base: %x\n", dcrs);
diff --git a/drivers/net/ni52.c b/drivers/net/ni52.c
index a0ac5d4..fae0b2a 100644
--- a/drivers/net/ni52.c
+++ b/drivers/net/ni52.c
@@ -615,10 +615,10 @@ static int init586(struct net_device *dev)
 	/* addr_len |!src_insert |pre-len |loopback */
 	writeb(0x2e, &cfg_cmd->adr_len);
 	writeb(0x00, &cfg_cmd->priority);
-	writeb(0x60, &cfg_cmd->ifs);;
+	writeb(0x60, &cfg_cmd->ifs);
 	writeb(0x00, &cfg_cmd->time_low);
 	writeb(0xf2, &cfg_cmd->time_high);
-	writeb(0x00, &cfg_cmd->promisc);;
+	writeb(0x00, &cfg_cmd->promisc);
 	if (dev->flags & IFF_ALLMULTI) {
 		int len = ((char __iomem *)p->iscp - (char __iomem *)ptr - 8) / 6;
 		if (num_addrs > len) {
diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 5768af1..eb4257c 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -2659,7 +2659,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	    FLAGS_LI;		/* Load irq delay values */
 	if (rx_ring->lbq_len) {
 		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
-		tmp = (u64)rx_ring->lbq_base_dma;;
+		tmp = (u64)rx_ring->lbq_base_dma;
 		base_indirect_ptr = (__le64 *) rx_ring->lbq_base_indirect;
 		page_entries = 0;
 		do {
@@ -2683,7 +2683,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	}
 	if (rx_ring->sbq_len) {
 		cqicb->flags |= FLAGS_LS;	/* Load sbq values */
-		tmp = (u64)rx_ring->sbq_base_dma;;
+		tmp = (u64)rx_ring->sbq_base_dma;
 		base_indirect_ptr = (__le64 *) rx_ring->sbq_base_indirect;
 		page_entries = 0;
 		do {
diff --git a/drivers/net/skfp/pcmplc.c b/drivers/net/skfp/pcmplc.c
index f1df2ec..e6b33ee 100644
--- a/drivers/net/skfp/pcmplc.c
+++ b/drivers/net/skfp/pcmplc.c
@@ -960,7 +960,7 @@ static void pcm_fsm(struct s_smc *smc, struct s_phy *phy, int cmd)
 			/*PC88b*/
 			if (!phy->cf_join) {
 				phy->cf_join = TRUE ;
-				queue_event(smc,EVENT_CFM,CF_JOIN+np) ; ;
+				queue_event(smc,EVENT_CFM,CF_JOIN+np) ;
 			}
 			if (cmd == PC_JOIN)
 				GO_STATE(PC8_ACTIVE) ;
diff --git a/drivers/net/skfp/pmf.c b/drivers/net/skfp/pmf.c
index 79e665e..a320fdb 100644
--- a/drivers/net/skfp/pmf.c
+++ b/drivers/net/skfp/pmf.c
@@ -807,9 +807,9 @@ void smt_add_para(struct s_smc *smc, struct s_pcon *pcon, u_short para,
 				mib_p->fddiPORTLerFlag ;
 			sp->p4050_pad = 0 ;
 			sp->p4050_cutoff =
-				mib_p->fddiPORTLer_Cutoff ; ;
+				mib_p->fddiPORTLer_Cutoff ;
 			sp->p4050_alarm =
-				mib_p->fddiPORTLer_Alarm ; ;
+				mib_p->fddiPORTLer_Alarm ;
 			sp->p4050_estimate =
 				mib_p->fddiPORTLer_Estimate ;
 			sp->p4050_reject_ct =
@@ -829,7 +829,7 @@ void smt_add_para(struct s_smc *smc, struct s_pcon *pcon, u_short para,
 			sp->p4051_porttype =
 				mib_p->fddiPORTMy_Type ;
 			sp->p4051_connectstate =
-				mib_p->fddiPORTConnectState ; ;
+				mib_p->fddiPORTConnectState ;
 			sp->p4051_pc_neighbor =
 				mib_p->fddiPORTNeighborType ;
 			sp->p4051_pc_withhold =
@@ -853,7 +853,7 @@ void smt_add_para(struct s_smc *smc, struct s_pcon *pcon, u_short para,
 			struct smt_p_4053	*sp ;
 			sp = (struct smt_p_4053 *) to ;
 			sp->p4053_multiple =
-				mib_p->fddiPORTMultiple_P ; ;
+				mib_p->fddiPORTMultiple_P ;
 			sp->p4053_availablepaths =
 				mib_p->fddiPORTAvailablePaths ;
 			sp->p4053_currentpath =
diff --git a/drivers/net/skge.c b/drivers/net/skge.c
index 543af20..7b10fbb 100644
--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -215,7 +215,7 @@ static void skge_wol_init(struct skge_port *skge)
 	if (skge->wol & WAKE_MAGIC)
 		ctrl |= WOL_CTL_ENA_PME_ON_MAGIC_PKT|WOL_CTL_ENA_MAGIC_PKT_UNIT;
 	else
-		ctrl |= WOL_CTL_DIS_PME_ON_MAGIC_PKT|WOL_CTL_DIS_MAGIC_PKT_UNIT;;
+		ctrl |= WOL_CTL_DIS_PME_ON_MAGIC_PKT|WOL_CTL_DIS_MAGIC_PKT_UNIT;
 
 	ctrl |= WOL_CTL_DIS_PME_ON_PATTERN|WOL_CTL_DIS_PATTERN_UNIT;
 	skge_write16(hw, WOL_REGS(port, WOL_CTRL_STAT), ctrl);
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 3550c5d..e46f31e 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -749,7 +749,7 @@ static void sky2_wol_init(struct sky2_port *sky2)
 	if (sky2->wol & WAKE_MAGIC)
 		ctrl |= WOL_CTL_ENA_PME_ON_MAGIC_PKT|WOL_CTL_ENA_MAGIC_PKT_UNIT;
 	else
-		ctrl |= WOL_CTL_DIS_PME_ON_MAGIC_PKT|WOL_CTL_DIS_MAGIC_PKT_UNIT;;
+		ctrl |= WOL_CTL_DIS_PME_ON_MAGIC_PKT|WOL_CTL_DIS_MAGIC_PKT_UNIT;
 
 	ctrl |= WOL_CTL_DIS_PME_ON_PATTERN|WOL_CTL_DIS_PATTERN_UNIT;
 	sky2_write16(hw, WOL_REGS(port, WOL_CTRL_STAT), ctrl);
diff --git a/drivers/net/vxge/vxge-config.h b/drivers/net/vxge/vxge-config.h
index 224acea..ad41cf1 100644
--- a/drivers/net/vxge/vxge-config.h
+++ b/drivers/net/vxge/vxge-config.h
@@ -1539,7 +1539,7 @@ void vxge_hw_ring_rxd_1b_info_get(
 	rxd_info->l4_cksum_valid =
 		(u32)VXGE_HW_RING_RXD_L4_CKSUM_CORRECT_GET(rxdp->control_0);
 	rxd_info->l4_cksum =
-		(u32)VXGE_HW_RING_RXD_L4_CKSUM_GET(rxdp->control_0);;
+		(u32)VXGE_HW_RING_RXD_L4_CKSUM_GET(rxdp->control_0);
 	rxd_info->frame =
 		(u32)VXGE_HW_RING_RXD_ETHER_ENCAP_GET(rxdp->control_0);
 	rxd_info->proto =
diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
index 7b5402b..e55f86a 100644
--- a/drivers/net/vxge/vxge-main.c
+++ b/drivers/net/vxge/vxge-main.c
@@ -2138,7 +2138,7 @@ static irqreturn_t vxge_isr_napi(int irq, void *dev_id)
 	struct __vxge_hw_device *hldev;
 	u64 reason;
 	enum vxge_hw_status status;
-	struct vxgedev *vdev = (struct vxgedev *) dev_id;;
+	struct vxgedev *vdev = (struct vxgedev *) dev_id;
 
 	vxge_debug_intr(VXGE_TRACE, "%s:%d", __func__, __LINE__);
 
@@ -2338,7 +2338,7 @@ static int vxge_enable_msix(struct vxgedev *vdev)
 	enum vxge_hw_status status;
 	/* 0 - Tx, 1 - Rx  */
 	int tim_msix_id[4];
-	int alarm_msix_id = 0, msix_intr_vect = 0;;
+	int alarm_msix_id = 0, msix_intr_vect = 0;
 	vdev->intr_cnt = 0;
 
 	/* allocate msix vectors */
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 86079a1..581ad2e 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -785,28 +785,28 @@ static int iwm_mlme_mgt_frame(struct iwm_priv *iwm, u8 *buf,
 		    le16_to_cpu(mgt_frame->len));
 
 	if (ieee80211_is_assoc_req(mgt->frame_control)) {
-		ie = mgt->u.assoc_req.variable;;
+		ie = mgt->u.assoc_req.variable;
 		iwm->req_ie_len =
 				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
 		kfree(iwm->req_ie);
 		iwm->req_ie = kmemdup(mgt->u.assoc_req.variable,
 				      iwm->req_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_reassoc_req(mgt->frame_control)) {
-		ie = mgt->u.reassoc_req.variable;;
+		ie = mgt->u.reassoc_req.variable;
 		iwm->req_ie_len =
 				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
 		kfree(iwm->req_ie);
 		iwm->req_ie = kmemdup(mgt->u.reassoc_req.variable,
 				      iwm->req_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_assoc_resp(mgt->frame_control)) {
-		ie = mgt->u.assoc_resp.variable;;
+		ie = mgt->u.assoc_resp.variable;
 		iwm->resp_ie_len =
 				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
 		kfree(iwm->resp_ie);
 		iwm->resp_ie = kmemdup(mgt->u.assoc_resp.variable,
 				       iwm->resp_ie_len, GFP_KERNEL);
 	} else if (ieee80211_is_reassoc_resp(mgt->frame_control)) {
-		ie = mgt->u.reassoc_resp.variable;;
+		ie = mgt->u.reassoc_resp.variable;
 		iwm->resp_ie_len =
 				le16_to_cpu(mgt_frame->len) - (ie - (u8 *)mgt);
 		kfree(iwm->resp_ie);
diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index f5d0ba8..8c2db2a 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -489,7 +489,7 @@ int pcmcia_request_configuration(struct pcmcia_device *p_dev,
 	pccard_io_map iomap;
 
 	if (!(s->state & SOCKET_PRESENT))
-		return -ENODEV;;
+		return -ENODEV;
 
 	if (req->IntType & INT_CARDBUS) {
 		ds_dbg(p_dev->socket, 0, "IntType may not be INT_CARDBUS\n");
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index bd1ce8e..0587d53 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -430,7 +430,7 @@ fail:
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device	*rtc = platform_get_drvdata(pdev);;
+	struct rtc_device	*rtc = platform_get_drvdata(pdev);
 
 	device_init_wakeup(&pdev->dev, 0);
 
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index f15addf..554b83b 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -706,7 +706,7 @@ static int dasd_eckd_generate_uid(struct dasd_device *device,
 	       sizeof(uid->serial) - 1);
 	EBCASC(uid->serial, sizeof(uid->serial) - 1);
 	uid->ssid = private->gneq->subsystemID;
-	uid->real_unit_addr = private->ned->unit_addr;;
+	uid->real_unit_addr = private->ned->unit_addr;
 	if (private->sneq) {
 		uid->type = private->sneq->sua_flags;
 		if (uid->type == UA_BASE_PAV_ALIAS)
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 695b149..0f24822 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -2113,7 +2113,7 @@ static ssize_t remove_write (struct device_driver *drv,
 	IUCV_DBF_TEXT(trace, 3, __func__);
 
         if (count >= IFNAMSIZ)
-                count = IFNAMSIZ - 1;;
+                count = IFNAMSIZ - 1;
 
 	for (i = 0, p = buf; i < count && *p; i++, p++) {
 		if (*p == '\n' || *p == ' ')
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 967ede7..7db90da 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -101,7 +101,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 	if (unlikely((status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
 		     !(status & ZFCP_STATUS_COMMON_RUNNING))) {
 		zfcp_scsi_command_fail(scpnt, DID_ERROR);
-		return 0;;
+		return 0;
 	}
 
 	ret = zfcp_fsf_send_fcp_command_task(unit, scpnt);
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 906cef5..41e1b0e 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1340,7 +1340,7 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 	resp_hdr->opcode = login->op_code;
 	resp_hdr->flags = login->response_flags;
 	resp_hdr->max_version = login->version_max;
-	resp_hdr->active_version = login->version_active;;
+	resp_hdr->active_version = login->version_active;
 	resp_hdr->hlength = 0;
 
 	hton24(resp_hdr->dlength, login->data_length);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 0e532f0..4d935ba 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1205,7 +1205,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		vport->ct_flags &= ~FC_CT_RFF_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RFF_ID);
-		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);;
+		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);
 		CtReq->un.rff.fbits = FC4_FEATURE_INIT;
 		CtReq->un.rff.type_code = FC_FCP_DATA;
 		cmpl = lpfc_cmpl_ct_cmd_rff_id;
diff --git a/drivers/spi/omap_uwire.c b/drivers/spi/omap_uwire.c
index 8980a56..e75ba9b 100644
--- a/drivers/spi/omap_uwire.c
+++ b/drivers/spi/omap_uwire.c
@@ -213,7 +213,7 @@ static int uwire_txrx(struct spi_device *spi, struct spi_transfer *t)
 	unsigned	bits = ust->bits_per_word;
 	unsigned	bytes;
 	u16		val, w;
-	int		status = 0;;
+	int		status = 0;
 
 	if (!t->tx_buf && !t->rx_buf)
 		return 0;
diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index e0d44af..9253cab 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -385,7 +385,7 @@ static int __init s3c24xx_spi_probe(struct platform_device *pdev)
 
  err_no_iores:
  err_no_pdata:
-	spi_master_put(hw->master);;
+	spi_master_put(hw->master);
 
  err_nomem:
 	return err;
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
index 43198aa..7f28fe2 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
@@ -1008,7 +1008,7 @@ int i_APCI1710_InsnWriteEnableDisableTorCounter(struct comedi_device *dev,
 	b_ExternGate = (unsigned char) data[3];
 	b_CycleMode = (unsigned char) data[4];
 	b_InterruptEnable = (unsigned char) data[5];
-	i_ReturnValue = insn->n;;
+	i_ReturnValue = insn->n;
 	devpriv->tsk_Current = current;	/*  Save the current process task structure */
 	/**************************/
 	/* Test the module number */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 236b8a3..fb4db93 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -2834,7 +2834,7 @@ int i_APCI1500_Reset(struct comedi_device *dev)
 	i_Logic = 0;
 	i_CounterLogic = 0;
 	i_InterruptMask = 0;
-	i_InputChannel = 0;;
+	i_InputChannel = 0;
 	i_TimerCounter1Enabled = 0;
 	i_TimerCounter2Enabled = 0;
 	i_WatchdogCounter3Enabled = 0;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
index 3841635..fcd71ae 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
@@ -335,7 +335,7 @@ int i_APCI1516_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 			return -EINVAL;
 		}		/* if else data[3]==1) */
 	}			/* if else data[3]==0) */
-	return (insn->n);;
+	return (insn->n);
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index ef21f03..edd1fff 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -339,7 +339,7 @@ int i_APCI3501_ConfigAnalogOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI3501_WriteAnalogOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-	unsigned int ul_Command1 = 0, ul_Channel_no, ul_Polarity, ul_DAC_Ready = 0;;
+	unsigned int ul_Command1 = 0, ul_Channel_no, ul_Polarity, ul_DAC_Ready = 0;
 
 	ul_Channel_no = CR_CHAN(insn->chanspec);
 
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index c4d8c4c..48ccb81 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -935,7 +935,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (thisboard->ao_chans > 0) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-		s->n_chan = thisboard->ao_chans;;
+		s->n_chan = thisboard->ao_chans;
 		s->maxdata = (1 << thisboard->ao_bits) - 1;
 		s->range_table = &pci230_ao_range;
 		s->insn_write = &pci230_ao_winsn;
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index cf39a24..0ae66fa 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -407,7 +407,7 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 	void *devs_opened[COMEDI_NUM_BOARD_MINORS];
 
 	memset(devs_opened, 0, sizeof(devs_opened));
-	devpriv->name[0] = 0;;
+	devpriv->name[0] = 0;
 	/* Loop through all comedi devices specified on the command-line,
 	   building our device list */
 	for (i = 0; i < COMEDI_NDEVCONFOPTS && (!i || it->options[i]); ++i) {
diff --git a/drivers/staging/dream/smd/smd_rpcrouter_device.c b/drivers/staging/dream/smd/smd_rpcrouter_device.c
index cd3910b..8978ee8 100644
--- a/drivers/staging/dream/smd/smd_rpcrouter_device.c
+++ b/drivers/staging/dream/smd/smd_rpcrouter_device.c
@@ -272,7 +272,7 @@ int msm_rpcrouter_create_server_cdev(struct rr_server *server)
 		printk(KERN_ERR
 		       "rpcrouter: Unable to create device (%ld)\n",
 		       PTR_ERR(server->device));
-		return PTR_ERR(server->device);;
+		return PTR_ERR(server->device);
 	}
 
 	cdev_init(&server->cdev, &rpcrouter_server_fops);
diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index 77b1e76..98a4a00 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -647,7 +647,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	go->dvd_mode = 0;
 	go->interlace_coding = 0;
 	for (i = 0; i < 4; ++i)
-		go->modet[i].enable = 0;;
+		go->modet[i].enable = 0;
 	for (i = 0; i < 1624; ++i)
 		go->modet_map[i] = 0;
 	go->audio_deliver = NULL;
diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index b4b7010..a7baf67 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -791,7 +791,7 @@ NetVscOnDeviceAdd(
 	NETVSC_PACKET* packet;
 	LIST_ENTRY *entry;
 
-	NETVSC_DRIVER_OBJECT *netDriver = (NETVSC_DRIVER_OBJECT*) Device->Driver;;
+	NETVSC_DRIVER_OBJECT *netDriver = (NETVSC_DRIVER_OBJECT*) Device->Driver;
 
 	DPRINT_ENTER(NETVSC);
 
diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index 439c447..ff59d61 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -524,7 +524,7 @@ StorVscConnectToVsp(
 	int ret=0;
     VMSTORAGE_CHANNEL_PROPERTIES props;
 
-	STORVSC_DRIVER_OBJECT *storDriver = (STORVSC_DRIVER_OBJECT*) Device->Driver;;
+	STORVSC_DRIVER_OBJECT *storDriver = (STORVSC_DRIVER_OBJECT*) Device->Driver;
 
 	memset(&props, sizeof(VMSTORAGE_CHANNEL_PROPERTIES), 0);
 
diff --git a/drivers/staging/otus/80211core/cmmsta.c b/drivers/staging/otus/80211core/cmmsta.c
index b28a4e2..d6aa0a4 100644
--- a/drivers/staging/otus/80211core/cmmsta.c
+++ b/drivers/staging/otus/80211core/cmmsta.c
@@ -1426,7 +1426,7 @@ struct zsBssInfo* zfStaFindBssInfo(zdev_t* dev, zbuf_t* buf, struct zsWlanProbeR
                     if (zfHpIsAllowedChannel(dev, zfChNumToFreq(dev, channel, 0)) == 0) {
                         frequency = 0;
                     } else {
-                        frequency = zfChNumToFreq(dev, channel, 0);;
+                        frequency = zfChNumToFreq(dev, channel, 0);
                     }
                 } else {
                     frequency = 0;
diff --git a/drivers/staging/otus/hal/hpmain.c b/drivers/staging/otus/hal/hpmain.c
index 322585b..32f0b49 100644
--- a/drivers/staging/otus/hal/hpmain.c
+++ b/drivers/staging/otus/hal/hpmain.c
@@ -1455,7 +1455,7 @@ void zfHpSetFrequencyEx(zdev_t* dev, u32_t frequency, u8_t bw40,
        /* calibration that updates the pddac with the wrong polarity.  Fortunately    */
        /* the second loop can be disabled with a bit called en_pd_dc_offset_thr.      */
 #if 0
-        cmdB[0] = 8 | (ZM_CMD_BITAND << 8);;
+        cmdB[0] = 8 | (ZM_CMD_BITAND << 8);
         cmdB[1] = (0xa27c + 0x1bc000);
         cmdB[2] = 0xffefffff;
         ret = zfIssueCmd(dev, cmdB, 12, ZM_OID_INTERNAL_WRITE, 0);
diff --git a/drivers/staging/rt2860/common/cmm_data_2860.c b/drivers/staging/rt2860/common/cmm_data_2860.c
index fb17355..5a6349a 100644
--- a/drivers/staging/rt2860/common/cmm_data_2860.c
+++ b/drivers/staging/rt2860/common/cmm_data_2860.c
@@ -80,7 +80,7 @@ USHORT RtmpPCI_WriteTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = TXINFO_SIZE + TXWI_SIZE + hwHeaderLen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -139,7 +139,7 @@ USHORT RtmpPCI_WriteSingleTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = TXINFO_SIZE + TXWI_SIZE + hwHeaderLen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -218,7 +218,7 @@ USHORT RtmpPCI_WriteMultiTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = firstDMALen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -372,7 +372,7 @@ int RtmpPCIMgmtKickOut(
 	pTxD->LastSec1 = 1;
 	pTxD->DMADONE = 0;
 	pTxD->SDLen1 = 0;
-	pTxD->SDPtr0 = PCI_MAP_SINGLE(pAd, pSrcBufVA, SrcBufLen, 0, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr0 = PCI_MAP_SINGLE(pAd, pSrcBufVA, SrcBufLen, 0, PCI_DMA_TODEVICE);
 	pTxD->SDLen0 = SrcBufLen;
 
 	pAd->RalinkCounters.KickTxCount++;
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index 80176b2..b5a2050 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -934,7 +934,7 @@ void send_monitor_packets(
     ph->rssi.did = DIDmsg_lnxind_wlansniffrm_rssi;
 	ph->rssi.status = 0;
 	ph->rssi.len = 4;
-    ph->rssi.data = (u_int32_t)RTMPMaxRssi(pAd, ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI0, RSSI_0), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI1, RSSI_1), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI2, RSSI_2));;
+    ph->rssi.data = (u_int32_t)RTMPMaxRssi(pAd, ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI0, RSSI_0), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI1, RSSI_1), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI2, RSSI_2));
 
 	ph->signal.did = DIDmsg_lnxind_wlansniffrm_signal;
 	ph->signal.status = 0;
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index a8da4f2..1ebfc69 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -4507,8 +4507,7 @@ VOID IterateOnBssTab(
 	IN  PRTMP_ADAPTER   pAd);
 
 VOID IterateOnBssTab2(
-	IN  PRTMP_ADAPTER   pAd);;
-
+	IN  PRTMP_ADAPTER   pAd);
 VOID JoinParmFill(
 	IN  PRTMP_ADAPTER   pAd,
 	IN  OUT MLME_JOIN_REQ_STRUCT *JoinReq,
diff --git a/drivers/staging/rt2860/sta/aironet.c b/drivers/staging/rt2860/sta/aironet.c
index 4af4a19..07b0d51 100644
--- a/drivers/staging/rt2860/sta/aironet.c
+++ b/drivers/staging/rt2860/sta/aironet.c
@@ -367,7 +367,7 @@ VOID	ChannelLoadRequestAction(
 		if (NStatus	!= NDIS_STATUS_SUCCESS)
 			return;
 
-		pNullFrame = (PHEADER_802_11) pOutBuffer;;
+		pNullFrame = (PHEADER_802_11) pOutBuffer;
 		// Make the power save Null frame with PSM bit on
 		MgtMacHeaderInit(pAd, pNullFrame, SUBTYPE_NULL_FUNC, 1, pAd->CommonCfg.Bssid, pAd->CommonCfg.Bssid);
 		pNullFrame->Duration 	= 0;
diff --git a/drivers/staging/rt3090/common/cmm_data_pci.c b/drivers/staging/rt3090/common/cmm_data_pci.c
index 084f819..a155fd5 100644
--- a/drivers/staging/rt3090/common/cmm_data_pci.c
+++ b/drivers/staging/rt3090/common/cmm_data_pci.c
@@ -149,7 +149,7 @@ USHORT RtmpPCI_WriteSingleTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = TXINFO_SIZE + TXWI_SIZE + hwHeaderLen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -243,7 +243,7 @@ USHORT RtmpPCI_WriteMultiTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = firstDMALen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
diff --git a/drivers/staging/rt3090/rt_linux.c b/drivers/staging/rt3090/rt_linux.c
index 375d0b7..ee07cde 100644
--- a/drivers/staging/rt3090/rt_linux.c
+++ b/drivers/staging/rt3090/rt_linux.c
@@ -959,7 +959,7 @@ void send_monitor_packets(
     ph->rssi.did = DIDmsg_lnxind_wlansniffrm_rssi;
 	ph->rssi.status = 0;
 	ph->rssi.len = 4;
-    ph->rssi.data = (u_int32_t)RTMPMaxRssi(pAd, ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI0, RSSI_0), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI1, RSSI_1), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI2, RSSI_2));;
+    ph->rssi.data = (u_int32_t)RTMPMaxRssi(pAd, ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI0, RSSI_0), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI1, RSSI_1), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI2, RSSI_2));
 
 	ph->signal.did = DIDmsg_lnxind_wlansniffrm_signal;
 	ph->signal.status = 0;
diff --git a/drivers/staging/rt3090/rtmp.h b/drivers/staging/rt3090/rtmp.h
index 8ef6d0b..cafbea0 100644
--- a/drivers/staging/rt3090/rtmp.h
+++ b/drivers/staging/rt3090/rtmp.h
@@ -4609,7 +4609,7 @@ VOID IterateOnBssTab(
 	IN  PRTMP_ADAPTER   pAd);
 
 VOID IterateOnBssTab2(
-	IN  PRTMP_ADAPTER   pAd);;
+	IN  PRTMP_ADAPTER   pAd);
 
 VOID JoinParmFill(
 	IN  PRTMP_ADAPTER   pAd,
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index cd07059..b4cc7d2 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -2126,7 +2126,7 @@ SetRFPowerState(
 
 		default:
 			printk("SetRFPowerState8185(): unknown RFChipID: 0x%X!!!\n", priv->rf_chip);
-			break;;
+			break;
 }
 //	printk("<--------- SetRFPowerState(): bResult(%d)\n", bResult);
 
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
index 2312527..a7aa33f 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
@@ -771,7 +771,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		{
 			txb->queue_index = UP2AC(skb->priority);
 		} else {
-			txb->queue_index = WME_AC_BK;;
+			txb->queue_index = WME_AC_BK;
 		}
 
 
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 723f44e..8076cb9 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -2960,7 +2960,7 @@ BOOL CARDbSoftwareReset (PVOID pDeviceHandler)
 QWORD CARDqGetTSFOffset (BYTE byRxRate, QWORD qwTSF1, QWORD qwTSF2)
 {
     QWORD   qwTSFOffset;
-    WORD    wRxBcnTSFOffst= 0;;
+    WORD    wRxBcnTSFOffst= 0;
 
     HIDWORD(qwTSFOffset) = 0;
     LODWORD(qwTSFOffset) = 0;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 2ff8f24..1aa8c04 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -2105,7 +2105,7 @@ int iwctl_giwencodeext(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-		return -EOPNOTSUPP;;
+		return -EOPNOTSUPP;
 }
 
 int iwctl_siwmlme(struct net_device *dev,
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index e2fdb33..8828873 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -225,7 +225,7 @@ WPA2vParseRSN (
         m = *((PWORD) &(pRSN->abyRSN[4]));
 
         if (pRSN->len >= 10+m*4) { // ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2)
-            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             j = 0;
             pbyOUI = &(pRSN->abyRSN[8+4*m]);
             for (i = 0; (i < pBSSNode->wAKMSSAuthCount) && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(BYTE)); i++) {
@@ -244,7 +244,7 @@ WPA2vParseRSN (
             pBSSNode->wAKMSSAuthCount = (WORD)j;
             DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
 
-            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             if (pRSN->len >= 12+4*m+4*n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
                 pBSSNode->sRSNCapObj.bRSNCapExist = TRUE;
                 pBSSNode->sRSNCapObj.wRSNCap = *((PWORD) &(pRSN->abyRSN[8+4*m+4*n]));
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 7b43cea..39f14f4 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -988,7 +988,7 @@ BBvSetAntennaMode (PSDevice pDevice, BYTE byAntennaMode)
             break;
         case ANT_RXB:
             pDevice->byBBRxConf &= 0xFE;
-            pDevice->byBBRxConf |= 0x02;;
+            pDevice->byBBRxConf |= 0x02;
             break;
     }
 
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index e4fdb6f..bebcfdf 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -2012,7 +2012,7 @@ int iwctl_giwencodeext(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-		return -EOPNOTSUPP;;
+		return -EOPNOTSUPP;
 }
 
 int iwctl_siwmlme(struct net_device *dev,
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 78ba7fc..67fc413 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -434,7 +434,7 @@ extern "C" {                            /* Assume C declarations for C++ */
 
 void MACvSetMultiAddrByHash (PSDevice pDevice, BYTE byHashIdx);
 VOID MACvWriteMultiAddr (PSDevice pDevice, UINT uByteIdx, BYTE byData);
-BOOL MACbShutdown(PSDevice pDevice);;
+BOOL MACbShutdown(PSDevice pDevice);
 void MACvSetBBType(PSDevice pDevice,BYTE byType);
 void MACvSetMISCFifo (PSDevice pDevice, WORD wOffset, DWORD dwData);
 void MACvDisableKeyEntry(PSDevice pDevice, UINT uEntryIdx);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7e40ceb..385020c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -986,7 +986,7 @@ static BOOL device_alloc_bufs(PSDevice pDevice) {
         pDevice->apTD[ii] = pTxContext;
         pTxContext->pDevice = (PVOID) pDevice;
         //allocate URBs
-        pTxContext->pUrb = vntwusb_alloc_urb(0);;
+        pTxContext->pUrb = vntwusb_alloc_urb(0);
         if (pTxContext->pUrb == NULL) {
             DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "alloc tx urb failed\n");
             goto free_tx;
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index b522b21..835475d 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -248,7 +248,7 @@ PSbConsiderPowerDown(
     // check if already in Doze mode
     ControlvReadByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PSCTL, &byData);
     if ( (byData & PSCTL_PS) != 0 )
-        return TRUE;;
+        return TRUE;
 
     if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
         // check if in TIM wake period
diff --git a/drivers/staging/vt6656/wpa2.c b/drivers/staging/vt6656/wpa2.c
index 82c972d..12fb9fe 100644
--- a/drivers/staging/vt6656/wpa2.c
+++ b/drivers/staging/vt6656/wpa2.c
@@ -225,7 +225,7 @@ WPA2vParseRSN (
         m = *((PWORD) &(pRSN->abyRSN[4]));
 
         if (pRSN->len >= 10+m*4) { // ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2)
-            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             j = 0;
             pbyOUI = &(pRSN->abyRSN[8+4*m]);
             for (i = 0; (i < pBSSNode->wAKMSSAuthCount) && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(BYTE)); i++) {
@@ -244,7 +244,7 @@ WPA2vParseRSN (
             pBSSNode->wAKMSSAuthCount = (WORD)j;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
 
-            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             if (pRSN->len >= 12+4*m+4*n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
                 pBSSNode->sRSNCapObj.bRSNCapExist = TRUE;
                 pBSSNode->sRSNCapObj.wRSNCap = *((PWORD) &(pRSN->abyRSN[8+4*m+4*n]));
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index ba589d4..8c64c01 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -506,8 +506,6 @@ static int wdm_open(struct inode *inode, struct file *file)
 	desc = usb_get_intfdata(intf);
 	if (test_bit(WDM_DISCONNECTING, &desc->flags))
 		goto out;
-
-	;
 	file->private_data = desc;
 
 	rv = usb_autopm_get_interface(desc->intf);
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 3c249d8..26d2914 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -546,7 +546,7 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	}
 
 	/* Set Baud Rate */
-	baud = tty_get_baud_rate(tty);;
+	baud = tty_get_baud_rate(tty);
 	switch (baud) {
 	case 300:	buf[0] = 0x00;	break;
 	case 600:	buf[0] = 0x01;	break;
diff --git a/drivers/uwb/i1480/i1480u-wlp/netdev.c b/drivers/uwb/i1480/i1480u-wlp/netdev.c
index 7305553..b236e69 100644
--- a/drivers/uwb/i1480/i1480u-wlp/netdev.c
+++ b/drivers/uwb/i1480/i1480u-wlp/netdev.c
@@ -214,7 +214,7 @@ int i1480u_open(struct net_device *net_dev)
 
 	netif_wake_queue(net_dev);
 #ifdef i1480u_FLOW_CONTROL
-	result = usb_submit_urb(i1480u->notif_urb, GFP_KERNEL);;
+	result = usb_submit_urb(i1480u->notif_urb, GFP_KERNEL);
 	if (result < 0) {
 		dev_err(dev, "Can't submit notification URB: %d\n", result);
 		goto error_notif_urb_submit;
diff --git a/drivers/video/cfbcopyarea.c b/drivers/video/cfbcopyarea.c
index df03f37..79e5f40 100644
--- a/drivers/video/cfbcopyarea.c
+++ b/drivers/video/cfbcopyarea.c
@@ -114,7 +114,7 @@ bitcpy(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
 				d0 >>= right;
 			} else if (src_idx+n <= bits) {
 				// Single source word
-				d0 <<= left;;
+				d0 <<= left;
 			} else {
 				// 2 source words
 				d1 = FB_READL(src + 1);
diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index 15a0ee6..89e6f1e 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -677,7 +677,7 @@ static int __init imxfb_probe(struct platform_device *pdev)
 
 	fbi->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(fbi->clk)) {
-		ret = PTR_ERR(fbi->clk);;
+		ret = PTR_ERR(fbi->clk);
 		dev_err(&pdev->dev, "unable to get clock: %d\n", ret);
 		goto failed_getclock;
 	}
diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 7da0027..5ffca2a 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -1119,7 +1119,7 @@ int __init s3c2410fb_init(void)
 	int ret = platform_driver_register(&s3c2410fb_driver);
 
 	if (ret == 0)
-		ret = platform_driver_register(&s3c2412fb_driver);;
+		ret = platform_driver_register(&s3c2412fb_driver);
 
 	return ret;
 }
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index f5bbd9e..4d1b322 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -214,7 +214,7 @@ static int increase_reservation(unsigned long nr_pages)
 	page = balloon_first_page();
 	for (i = 0; i < nr_pages; i++) {
 		BUG_ON(page == NULL);
-		frame_list[i] = page_to_pfn(page);;
+		frame_list[i] = page_to_pfn(page);
 		page = balloon_next_page(page);
 	}
 
diff --git a/fs/autofs/dirhash.c b/fs/autofs/dirhash.c
index 2316e94..e947915 100644
--- a/fs/autofs/dirhash.c
+++ b/fs/autofs/dirhash.c
@@ -90,7 +90,7 @@ struct autofs_dir_ent *autofs_expire(struct super_block *sb,
 			DPRINTK(("autofs: not expirable (not a mounted directory): %s\n", ent->name));
 			continue;
 		}
-		while (d_mountpoint(path.dentry) && follow_down(&path));
+		while (d_mountpoint(path.dentry) && follow_down(&path))
 			;
 		umount_ok = may_umount(path.mnt);
 		path_put(&path);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c139222..ab326dd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2605,7 +2605,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 								extent);
 				cs = btrfs_file_extent_offset(src, extent);
 				cl = btrfs_file_extent_num_bytes(src,
-								extent);;
+								extent);
 				if (btrfs_file_extent_compression(src,
 								  extent)) {
 					cs = 0;
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 3bb11be..3f2c2a3 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -136,7 +136,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc != 0) {
 		cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
-			  __func__, *devname, rc));;
+			  __func__, *devname, rc));
 		goto compose_mount_options_err;
 	}
 	/* md_len = strlen(...) + 12 for 'sep+prefixpath='
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index e5a2dac..76b0aa0 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -222,7 +222,7 @@ static unsigned decode_sessionid(struct xdr_stream *xdr,
 
 	p = read_buf(xdr, len);
 	if (unlikely(p == NULL))
-		return htonl(NFS4ERR_RESOURCE);;
+		return htonl(NFS4ERR_RESOURCE);
 
 	memcpy(sid->data, p, len);
 	return 0;
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index cc8785c..9f7910c 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -144,7 +144,7 @@ static int ocfs2_get_quota_block(struct inode *inode, int block,
 		err = -EIO;
 		mlog_errno(err);
 	}
-	return err;;
+	return err;
 }
 
 /* Read data from global quotafile - avoid pagecache and such because we cannot
diff --git a/fs/ubifs/scan.c b/fs/ubifs/scan.c
index 892ebfe..3ab5837 100644
--- a/fs/ubifs/scan.c
+++ b/fs/ubifs/scan.c
@@ -321,7 +321,7 @@ struct ubifs_scan_leb *ubifs_scan(const struct ubifs_info *c, int lnum,
 
 	if (offs % c->min_io_size) {
 		ubifs_err("empty space starts at non-aligned offset %d", offs);
-		goto corrupted;;
+		goto corrupted;
 	}
 
 	ubifs_end_scan(c, sleb, lnum, offs);
diff --git a/include/scsi/fc/fc_fc2.h b/include/scsi/fc/fc_fc2.h
index cff8a8c..f87777d 100644
--- a/include/scsi/fc/fc_fc2.h
+++ b/include/scsi/fc/fc_fc2.h
@@ -92,8 +92,7 @@ struct fc_esb {
 	__u8	_esb_resvd[4];
 	__u8	esb_service_params[112]; /* TBD */
 	__u8	esb_seq_status[8];	/* sequence statuses, 8 bytes each */
-} __attribute__((packed));;
-
+} __attribute__((packed));
 
 /*
  * Define expected size for ASSERTs.
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index ca7d7c4..23b6385 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -155,7 +155,7 @@ static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 		    seq_print_ip_sym(seq, it->from, symflags) &&
 		    trace_seq_printf(seq, "\n"))
 			return TRACE_TYPE_HANDLED;
-		return TRACE_TYPE_PARTIAL_LINE;;
+		return TRACE_TYPE_PARTIAL_LINE;
 	}
 	return TRACE_TYPE_UNHANDLED;
 }
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index c7351a9..db6be00 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -808,7 +808,7 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 		return 0;
 	}
 
-	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);;
+	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwtxpower);
 
diff --git a/sound/oss/sys_timer.c b/sound/oss/sys_timer.c
index 1075344..8db6aef 100644
--- a/sound/oss/sys_timer.c
+++ b/sound/oss/sys_timer.c
@@ -100,9 +100,6 @@ def_tmr_open(int dev, int mode)
 	curr_tempo = 60;
 	curr_timebase = 100;
 	opened = 1;
-
-	;
-
 	{
 		def_tmr.expires = (1) + jiffies;
 		add_timer(&def_tmr);
diff --git a/sound/soc/codecs/wm8993.c b/sound/soc/codecs/wm8993.c
index f9c49b3..702ec47 100644
--- a/sound/soc/codecs/wm8993.c
+++ b/sound/soc/codecs/wm8993.c
@@ -1772,7 +1772,7 @@ static int wm8993_hw_params(struct snd_pcm_substream *substream,
 		       - wm8993->fs);
 	for (i = 1; i < ARRAY_SIZE(clk_sys_rates); i++) {
 		cur_val = abs((wm8993->sysclk_rate /
-			       clk_sys_rates[i].ratio) - wm8993->fs);;
+			       clk_sys_rates[i].ratio) - wm8993->fs);
 		if (cur_val < best_val) {
 			best = i;
 			best_val = cur_val;
diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 156f2a4..97f9231 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -1087,7 +1087,7 @@ static int wm9081_hw_params(struct snd_pcm_substream *substream,
 		       - wm9081->fs);
 	for (i = 1; i < ARRAY_SIZE(clk_sys_rates); i++) {
 		cur_val = abs((wm9081->sysclk_rate /
-			       clk_sys_rates[i].ratio) - wm9081->fs);;
+			       clk_sys_rates[i].ratio) - wm9081->fs);
 		if (cur_val < best_val) {
 			best = i;
 			best_val = cur_val;
diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index e22c5ce..e7ee83e 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -351,7 +351,7 @@ static int pxa_ssp_set_dai_pll(struct snd_soc_dai *cpu_dai,
 			do_div(tmp, freq_out);
 			val = tmp;
 
-			val = (val << 16) | 64;;
+			val = (val << 16) | 64;
 			ssp_write_reg(ssp, SSACDD, val);
 
 			ssacd |= (0x6 << 4);
diff --git a/sound/soc/s3c24xx/s3c24xx_uda134x.c b/sound/soc/s3c24xx/s3c24xx_uda134x.c
index 8e79a41..c215d32 100644
--- a/sound/soc/s3c24xx/s3c24xx_uda134x.c
+++ b/sound/soc/s3c24xx/s3c24xx_uda134x.c
@@ -67,7 +67,7 @@ static int s3c24xx_uda134x_startup(struct snd_pcm_substream *substream)
 {
 	int ret = 0;
 #ifdef ENFORCE_RATES
-	struct snd_pcm_runtime *runtime = substream->runtime;;
+	struct snd_pcm_runtime *runtime = substream->runtime;
 #endif
 
 	mutex_lock(&clk_lock);


