Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZKBRu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZKBRu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZKBRu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:50:26 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:41808 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbZKBRuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=fvJJJVuaOC3cMua64zJyVp61bevMTGEVRqvNBuyxAlVR35VoFiasMi09CeKUZ9WcxN
         rYacLO1JI2DNu2VvVlliPtrt30ZGK8pNaOFdjM3Hj35r9I+xqEXTpuE11RgE+h68SPQX
         laPsFfIvCNMEmgI3bHE8sVc3tB50kcEILx4A8=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 2 Nov 2009 15:49:49 -0200
Message-ID: <b8bf37780911020949t4bed5cb6g92230b59efc7923b@mail.gmail.com>
Subject: [PATCH] trivial: fix assorted typos all over the place
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes assorted typos all over the place.

That is "success", "unknown", "through", "performance", "[re|un]mapping"
, "access", "default", "reasonable", "[con]currently", "temperature"
, "channel", "[un]used", "application", "example","hierarchy" and others.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

---

 Documentation/ABI/testing/procfs-diskstats         |    2 +-
 Documentation/ABI/testing/sysfs-block              |    2 +-
 Documentation/DocBook/v4l/videodev2.h.xml          |    2 +-
 Documentation/dvb/README.dvb-usb                   |    2 +-
 Documentation/lguest/lguest.c                      |    2 +-
 Documentation/scsi/ChangeLog.megaraid_sas          |    2 +-
 Documentation/spi/spi-summary                      |    2 +-
 Documentation/sysctl/vm.txt                        |    2 +-
 Documentation/video4linux/gspca.txt                |    2 +-
 Documentation/vm/page-types.c                      |    2 +-
 arch/arm/common/scoop.c                            |    2 +-
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |    2 +-
 arch/arm/mach-bcmring/include/mach/dma.h           |    2 +-
 arch/arm/mach-orion5x/pci.c                        |    2 +-
 arch/arm/mach-pxa/include/mach/palmld.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmt5.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmtc.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmte2.h           |    2 +-
 arch/arm/mach-pxa/include/mach/palmtx.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmz72.h           |    2 +-
 arch/arm/mach-s3c6400/setup-sdhci.c                |    2 +-
 arch/arm/mach-s3c6410/setup-sdhci.c                |    2 +-
 arch/arm/mach-sa1100/dma.c                         |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mx3.h         |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mxc91231.h    |    2 +-
 arch/arm/plat-omap/dma.c                           |    2 +-
 arch/arm/plat-omap/include/mach/omap16xx.h         |    2 +-
 arch/arm/plat-s3c24xx/include/plat/map.h           |    2 +-
 arch/avr32/boards/hammerhead/Kconfig               |    2 +-
 arch/blackfin/kernel/cplb-mpu/cplbinit.c           |    2 +-
 arch/blackfin/kernel/traps.c                       |    2 +-
 arch/cris/mm/fault.c                               |    2 +-
 arch/ia64/ia32/ia32_entry.S                        |    2 +-
 arch/ia64/kernel/esi.c                             |    2 +-
 arch/ia64/kernel/perfmon.c                         |    2 +-
 arch/m68k/include/asm/bootinfo.h                   |    2 +-
 arch/microblaze/lib/memcpy.c                       |    2 +-
 arch/microblaze/lib/memmove.c                      |    2 +-
 arch/microblaze/lib/memset.c                       |    2 +-
 arch/mips/include/asm/mach-pnx833x/gpio.h          |    2 +-
 arch/mips/math-emu/dp_sub.c                        |    2 +-
 arch/mips/txx9/generic/smsc_fdc37m81x.c            |    2 +-
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/powerpc/oprofile/op_model_cell.c              |    4 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |    2 +-
 arch/powerpc/platforms/powermac/pci.c              |    2 +-
 arch/s390/include/asm/topology.h                   |    2 +-
 arch/s390/kernel/smp.c                             |   10 ++--
 arch/s390/kernel/topology.c                        |    2 +-
 arch/x86/include/asm/desc_defs.h                   |    4 +-
 arch/x86/kernel/acpi/boot.c                        |    2 +-
 arch/x86/kernel/amd_iommu.c                        |    4 +-
 arch/x86/kernel/cpu/perf_event.c                   |    2 +-
 arch/x86/kernel/kprobes.c                          |    4 +-
 arch/x86/mm/kmmio.c                                |    4 +-
 block/blk-iopoll.c                                 |    2 +-
 drivers/ata/ata_piix.c                             |    2 +-
 drivers/base/dd.c                                  |    2 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    2 +-
 drivers/bluetooth/hci_ldisc.c                      |    2 +-
 drivers/char/mem.c                                 |    2 +-
 drivers/char/mspec.c                               |    2 +-
 drivers/char/n_r3964.c                             |    2 +-
 drivers/char/nozomi.c                              |    2 +-
 drivers/char/rio/route.h                           |    2 +-
 drivers/crypto/hifn_795x.c                         |    2 +-
 drivers/dma/at_hdmac.c                             |    2 +-
 drivers/firewire/core-topology.c                   |    2 +-
 drivers/gpu/drm/drm_crtc.c                         |    4 +-
 drivers/gpu/drm/i915/i915_gem.c                    |    2 +-
 drivers/gpu/drm/i915/intel_fb.c                    |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |    2 +-
 drivers/gpu/drm/radeon/radeon_fb.c                 |    2 +-
 drivers/hwmon/adm1029.c                            |    2 +-
 drivers/hwmon/lm93.c                               |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_sd7220.c         |    2 +-
 drivers/input/serio/hp_sdc.c                       |    2 +-
 drivers/input/serio/hp_sdc_mlc.c                   |    2 +-
 drivers/input/touchscreen/atmel-wm97xx.c           |    2 +-
 drivers/isdn/capi/capidrv.c                        |    2 +-
 drivers/isdn/hardware/eicon/di.c                   |    2 +-
 drivers/isdn/hardware/eicon/maintidi.c             |    4 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |    2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.h              |    2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c            |    2 +-
 drivers/isdn/hisax/hfc_usb.c                       |    2 +-
 drivers/isdn/mISDN/dsp_core.c                      |    2 +-
 drivers/isdn/mISDN/tei.c                           |    2 +-
 drivers/macintosh/therm_windtunnel.c               |    2 +-
 drivers/media/common/saa7146_i2c.c                 |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    2 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |    2 +-
 drivers/media/dvb/dvb-usb/usb-urb.c                |    4 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |    2 +-
 drivers/media/dvb/frontends/cx24110.c              |    4 +-
 drivers/media/dvb/frontends/cx24113.c              |    2 +-
 drivers/media/dvb/frontends/dib3000mb.c            |    2 +-
 drivers/media/dvb/frontends/lgdt330x.c             |    4 +-
 drivers/media/dvb/frontends/stb0899_drv.c          |    2 +-
 drivers/media/radio/radio-mr800.c                  |    2 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |    8 ++-
 drivers/media/video/cx23885/cx23885-dvb.c          |    2 +-
 drivers/media/video/gspca/sonixb.c                 |    2 +-
 drivers/media/video/gspca/spca500.c                |    2 +-
 drivers/media/video/gspca/spca501.c                |    6 +-
 drivers/media/video/gspca/zc3xx.c                  |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +-
 drivers/media/video/s2255drv.c                     |    2 +-
 drivers/media/video/zoran/zoran.h                  |    2 +-
 drivers/message/fusion/lsi/mpi_cnfg.h              |    4 +-
 drivers/message/fusion/mptfc.c                     |    2 +-
 drivers/message/i2o/i2o_block.c                    |    2 +-
 drivers/message/i2o/iop.c                          |    4 +-
 drivers/misc/sgi-gru/grufile.c                     |    2 +-
 drivers/mmc/host/s3cmci.c                          |    2 +-
 drivers/mtd/nand/diskonchip.c                      |    2 +-
 drivers/mtd/nand/nand_ecc.c                        |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    2 +-
 drivers/net/82596.c                                |    2 +-
 drivers/net/amd8111e.c                             |    7 ++-
 drivers/net/appletalk/cops.c                       |    2 +-
 drivers/net/benet/be_cmds.h                        |    2 +-
 drivers/net/benet/be_main.c                        |    2 +-
 drivers/net/cxgb3/sge.c                            |    2 +-
 drivers/net/e1000e/82571.c                         |    4 +-
 drivers/net/e1000e/lib.c                           |    2 +-
 drivers/net/ehea/ehea_ethtool.c                    |    4 +-
 drivers/net/lasi_82596.c                           |    2 +-
 drivers/net/lib82596.c                             |    2 +-
 drivers/net/mlx4/en_rx.c                           |    2 +-
 drivers/net/mlx4/mlx4_en.h                         |    2 +-
 drivers/net/ps3_gelic_net.c                        |    2 +-
 drivers/net/sfc/falcon.c                           |    2 +-
 drivers/net/sis900.c                               |    2 +-
 drivers/net/skfp/skfddi.c                          |    2 +-
 drivers/net/smsc911x.c                             |    2 +-
 drivers/net/smsc911x.h                             |    2 +-
 drivers/net/spider_net.c                           |    2 +-
 drivers/net/ucc_geth.c                             |    2 +-
 drivers/net/ucc_geth.h                             |   20 +++---
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/net/wan/lmc/lmc_main.c                     |    2 +-
 drivers/net/wimax/i2400m/rx.c                      |    2 +-
 drivers/net/wireless/ath/ath5k/phy.c               |    6 +-
 drivers/net/wireless/ath/ath9k/rc.c                |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    4 +-
 drivers/net/wireless/iwmc3200wifi/commands.c       |   10 ++--
 drivers/net/wireless/iwmc3200wifi/hal.c            |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    2 +-
 drivers/net/wireless/libertas/if_sdio.c            |    2 +-
 drivers/net/wireless/prism54/isl_ioctl.c           |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |   16 +++---
 drivers/net/wireless/rt2x00/rt2800usb.h            |   18 +++---
 drivers/net/wireless/rt2x00/rt2x00usb.c            |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |    2 +-
 drivers/net/wireless/wavelan_cs.c                  |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    2 +-
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/pnp/pnpbios/rsparser.c                     |    8 +-
 drivers/ps3/ps3-sys-manager.c                      |    2 +-
 drivers/s390/char/fs3270.c                         |    2 +-
 drivers/s390/cio/chp.c                             |    2 +-
 drivers/s390/cio/cmf.c                             |    2 +-
 drivers/sbus/char/envctrl.c                        |    4 +-
 drivers/scsi/53c700.c                              |    2 +-
 drivers/scsi/FlashPoint.c                          |    6 +-
 drivers/scsi/aic7xxx/aic79xx.seq                   |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h   |    2 +-
 drivers/scsi/hptiop.c                              |    2 +-
 drivers/scsi/libfc/fc_lport.c                      |    2 +-
 drivers/scsi/libiscsi_tcp.c                        |    2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |    4 +-
 drivers/scsi/lpfc/lpfc_els.c                       |    4 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   62 ++++++++++----------
 drivers/scsi/lpfc/lpfc_sli.c                       |   10 ++--
 drivers/scsi/megaraid.h                            |    2 +-
 drivers/scsi/megaraid/mbox_defs.h                  |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    2 +-
 drivers/scsi/ncr53c8xx.c                           |    2 +-
 drivers/scsi/pmcraid.c                             |    6 +-
 drivers/scsi/scsi_netlink.c                        |    2 +-
 drivers/scsi/scsi_transport_sas.c                  |    6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h                |    2 +-
 drivers/serial/8250_pnp.c                          |    4 +-
 drivers/serial/pmac_zilog.h                        |    2 +-
 drivers/serial/ucc_uart.c                          |    2 +-
 drivers/staging/altpciechdma/altpciechdma.c        |    6 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/cb_pcidio.c         |    4 +-
 drivers/staging/comedi/drivers/me4000.c            |    2 +-
 drivers/staging/comedi/drivers/pcl812.c            |    6 +-
 drivers/staging/comedi/drivers/pcl816.c            |    4 +-
 drivers/staging/comedi/drivers/pcl818.c            |   10 ++--
 drivers/staging/dst/export.c                       |    2 +-
 drivers/staging/hv/hv_api.h                        |    4 +-
 drivers/staging/octeon/cvmx-pow.h                  |    2 +-
 drivers/staging/octeon/ethernet-tx.c               |    2 +-
 drivers/staging/otus/80211core/ccmd.c              |    4 +-
 drivers/staging/otus/80211core/cmm.c               |    4 +-
 drivers/staging/otus/80211core/cmmsta.c            |    4 +-
 drivers/staging/otus/80211core/pub_zfi.h           |    2 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |    2 +-
 drivers/staging/rar/rar_driver.c                   |    4 +-
 drivers/staging/rt2860/common/cmm_data.c           |    6 +-
 drivers/staging/rt2860/common/cmm_info.c           |   32 +++++-----
 drivers/staging/rt2860/common/mlme.c               |   10 ++--
 drivers/staging/rt2860/common/rtmp_init.c          |    4 +-
 drivers/staging/rt2860/common/spectrum.c           |    6 +-
 drivers/staging/rt2860/rtmp.h                      |    2 +-
 drivers/staging/rt2860/sta/connect.c               |    6 +-
 drivers/staging/rt2860/sta/rtmp_data.c             |    2 +-
 drivers/staging/rt2860/sta/wpa.c                   |    4 +-
 drivers/staging/rt2860/sta_ioctl.c                 |    6 +-
 drivers/staging/rt2870/common/rtusb_bulk.c         |    4 +-
 drivers/staging/rt3090/common/cmm_data.c           |    6 +-
 drivers/staging/rt3090/common/cmm_info.c           |   30 +++++-----
 drivers/staging/rt3090/common/igmp_snoop.c         |    4 +-
 drivers/staging/rt3090/common/mlme.c               |   10 ++--
 drivers/staging/rt3090/common/rtmp_init.c          |    4 +-
 drivers/staging/rt3090/common/spectrum.c           |   14 ++--
 drivers/staging/rt3090/rt_ate.c                    |    2 +-
 drivers/staging/rt3090/rtmp.h                      |    6 +-
 drivers/staging/rt3090/sta/connect.c               |    6 +-
 drivers/staging/rt3090/sta/rtmp_data.c             |    2 +-
 drivers/staging/rt3090/sta_ioctl.c                 |   11 ++--
 drivers/staging/rtl8187se/r8180_core.c             |    6 +-
 drivers/staging/rtl8187se/r8180_dm.c               |    8 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |    4 +-
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |    2 +-
 drivers/staging/rtl8192e/r8190_rtl8256.c           |    2 +-
 drivers/staging/rtl8192e/r8192E_core.c             |    6 +-
 drivers/staging/rtl8192e/r8192E_dm.c               |   10 ++--
 drivers/staging/rtl8192e/r819xE_cmdpkt.c           |    2 +-
 drivers/staging/rtl8192e/r819xE_phyreg.h           |    2 +-
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |    2 +-
 drivers/staging/rtl8192su/r8192S_phy.c             |    4 +-
 drivers/staging/rtl8192su/r8192S_phyreg.h          |    2 +-
 drivers/staging/rtl8192su/r8192U_dm.c              |   10 ++--
 drivers/staging/rtl8192su/r819xU_cmdpkt.c          |    2 +-
 drivers/staging/sep/sep_driver.c                   |    2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |    2 +-
 drivers/staging/vt6655/device_main.c               |    2 +-
 drivers/staging/vt6655/ioctl.c                     |    4 +-
 drivers/staging/vt6655/mib.h                       |    4 +-
 drivers/staging/vt6656/baseband.c                  |    2 +-
 drivers/staging/vt6656/channel.c                   |    2 +-
 drivers/staging/vt6656/ioctl.c                     |    4 +-
 drivers/staging/vt6656/iwctl.c                     |    2 +-
 drivers/staging/vt6656/main_usb.c                  |    2 +-
 drivers/staging/vt6656/mib.h                       |    4 +-
 drivers/staging/vt6656/wcmd.c                      |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/core/message.c                         |    2 +-
 drivers/usb/gadget/f_acm.c                         |    2 +-
 drivers/usb/gadget/pxa27x_udc.c                    |    2 +-
 drivers/usb/host/fhci-sched.c                      |    2 +-
 drivers/usb/wusbcore/crypto.c                      |    2 +-
 drivers/usb/wusbcore/wa-xfer.c                     |    4 +-
 drivers/uwb/i1480/dfu/usb.c                        |    2 +-
 drivers/uwb/wlp/txrx.c                             |    2 +-
 drivers/video/aty/atyfb_base.c                     |    4 +-
 drivers/video/aty/radeonfb.h                       |    2 +-
 drivers/video/backlight/atmel-pwm-bl.c             |    2 +-
 drivers/video/backlight/tosa_lcd.c                 |    2 +-
 drivers/video/console/sticore.c                    |    2 +-
 drivers/video/gbefb.c                              |    2 +-
 drivers/video/tdfxfb.c                             |    2 +-
 drivers/video/via/dvi.c                            |    4 +-
 drivers/watchdog/coh901327_wdt.c                   |    2 +-
 drivers/watchdog/machzwd.c                         |    2 +-
 drivers/watchdog/wdrtas.c                          |    6 +-
 fs/binfmt_elf.c                                    |    2 +-
 fs/bio.c                                           |    2 +-
 fs/btrfs/extent_map.c                              |    2 +-
 fs/cifs/README                                     |    2 +-
 fs/cifs/cifsglob.h                                 |    2 +-
 fs/cifs/inode.c                                    |    4 +-
 fs/cifs/smbdes.c                                   |    2 +-
 fs/dlm/plock.c                                     |    2 +-
 fs/jffs2/compr.c                                   |    2 +-
 fs/jffs2/readinode.c                               |    2 +-
 fs/jffs2/xattr.c                                   |    2 +-
 fs/jfs/jfs_dmap.c                                  |    2 +-
 fs/ncpfs/ioctl.c                                   |    2 +-
 fs/ntfs/compress.c                                 |    2 +-
 fs/ntfs/file.c                                     |    4 +-
 fs/ntfs/logfile.c                                  |    2 +-
 fs/ocfs2/alloc.c                                   |    2 +-
 fs/ocfs2/dlm/dlmmaster.c                           |    2 +-
 fs/ocfs2/dlmglue.c                                 |    2 +-
 fs/ocfs2/journal.c                                 |    2 +-
 fs/omfs/bitmap.c                                   |    2 +-
 fs/ubifs/recovery.c                                |    2 +-
 fs/xfs/quota/xfs_dquot.h                           |    2 +-
 include/linux/chio.h                               |    2 +-
 include/linux/mfd/ezx-pcap.h                       |    4 +-
 include/linux/pktcdvd.h                            |    2 +-
 include/linux/videodev2.h                          |    2 +-
 include/net/sctp/structs.h                         |    2 +-
 include/net/tcp.h                                  |    2 +-
 include/net/wimax.h                                |    2 +-
 kernel/perf_event.c                                |    4 +-
 lib/Kconfig.debug                                  |    2 +-
 lib/decompress_bunzip2.c                           |    2 +-
 mm/filemap.c                                       |    2 +-
 mm/memcontrol.c                                    |    4 +-
 mm/memory-failure.c                                |    2 +-
 net/irda/irlap.c                                   |   14 ++--
 net/irda/irlmp.c                                   |    4 +-
 net/mac80211/mesh_pathtbl.c                        |    4 +-
 net/netlabel/netlabel_domainhash.c                 |    2 +-
 net/sctp/sm_sideeffect.c                           |    2 +-
 net/wimax/op-reset.c                               |    2 +-
 security/selinux/netlabel.c                        |    2 +-
 security/selinux/ss/services.c                     |    2 +-
 sound/Kconfig                                      |    2 +-
 sound/isa/cs423x/cs4236.c                          |    2 +-
 sound/isa/opti9xx/miro.c                           |    2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |    2 +-
 sound/pci/ca0106/ca0106_proc.c                     |    2 +-
 sound/pci/cs46xx/imgs/cwcdma.asp                   |    9 ++-
 sound/pci/emu10k1/emu10k1x.c                       |    2 +-
 sound/pci/hda/patch_cmedia.c                       |    2 +-
 sound/pci/hda/patch_realtek.c                      |    2 +-
 sound/pci/rme9652/hdspm.c                          |    4 +-
 sound/soc/codecs/uda134x.c                         |    4 +-
 sound/soc/s3c24xx/s3c24xx_simtec.c                 |    2 +-
 sound/sound_core.c                                 |    2 +-
 344 files changed, 579 insertions(+), 570 deletions(-)
   3.1% arch/arm/
   6.4% arch/
   4.8% drivers/media/
   4.1% drivers/net/wireless/rt2x00/
   3.1% drivers/net/wireless/
   6.4% drivers/net/
   3.5% drivers/scsi/lpfc/
   4.4% drivers/scsi/
   6.2% drivers/staging/rt2860/common/
   7.1% drivers/staging/rt3090/common/
  20.7% drivers/staging/
  15.4% drivers/
   4.1% fs/

diff --git a/Documentation/ABI/testing/procfs-diskstats
b/Documentation/ABI/testing/procfs-diskstats
index 9923390..f91a973 100644
--- a/Documentation/ABI/testing/procfs-diskstats
+++ b/Documentation/ABI/testing/procfs-diskstats
@@ -8,7 +8,7 @@ Description:
 		 1 - major number
 		 2 - minor mumber
 		 3 - device name
-		 4 - reads completed succesfully
+		 4 - reads completed successfully
 		 5 - reads merged
 		 6 - sectors read
 		 7 - time spent reading (ms)
diff --git a/Documentation/ABI/testing/sysfs-block
b/Documentation/ABI/testing/sysfs-block
index 5f3beda..d2f9033 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -4,7 +4,7 @@ Contact:	Jerome Marchand <jmarchan@redhat.com>
 Description:
 		The /sys/block/<disk>/stat files displays the I/O
 		statistics of disk <disk>. They contain 11 fields:
-		 1 - reads completed succesfully
+		 1 - reads completed successfully
 		 2 - reads merged
 		 3 - sectors read
 		 4 - time spent reading (ms)
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml
b/Documentation/DocBook/v4l/videodev2.h.xml
index 9700206..26303e5 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -492,7 +492,7 @@ struct <link
linkend="v4l2-jpegcompression">v4l2_jpegcompression</link> {
                                  * you do, leave them untouched.
                                  * Inluding less markers will make the
                                  * resulting code smaller, but there will
-                                 * be fewer aplications which can read it.
+                                 * be fewer applications which can read it.
                                  * The presence of the APP and COM marker
                                  * is influenced by APP_len and COM_len
                                  * ONLY, not by this property! */
diff --git a/Documentation/dvb/README.dvb-usb b/Documentation/dvb/README.dvb-usb
index bf2a9cd..c8238e4 100644
--- a/Documentation/dvb/README.dvb-usb
+++ b/Documentation/dvb/README.dvb-usb
@@ -85,7 +85,7 @@ http://www.linuxtv.org/wiki/index.php/DVB_USB
 	     - moved transfer control (pid filter, fifo control) from usb
driver to frontend, it seems
 	       better settled there (added xfer_ops-struct)
 	     - created a common files for frontends (mc/p/mb)
-  2004-09-28 - added support for a new device (Unkown, vendor ID is
Hyper-Paltek)
+  2004-09-28 - added support for a new device (Unknown, vendor ID is
Hyper-Paltek)
   2004-09-20 - added support for a new device (Compro DVB-U2000), thanks
 	       to Amaury Demol for reporting
 	     - changed usb TS transfer method (several urbs, stopping transfer
diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index 098de5b..4220851 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -304,7 +304,7 @@ static void *map_zeroed_pages(unsigned int num)
 	addr = mmap(NULL, getpagesize() * num,
 		    PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, fd, 0);
 	if (addr == MAP_FAILED)
-		err(1, "Mmaping %u pages of /dev/zero", num);
+		err(1, "Mmapping %u pages of /dev/zero", num);

 	/*
 	 * One neat mmap feature is that you can close the fd, and it
diff --git a/Documentation/scsi/ChangeLog.megaraid_sas
b/Documentation/scsi/ChangeLog.megaraid_sas
index c851ef4..84524e0 100644
--- a/Documentation/scsi/ChangeLog.megaraid_sas
+++ b/Documentation/scsi/ChangeLog.megaraid_sas
@@ -185,7 +185,7 @@ ii.	FW enables WCE bit in Mode Sense cmd for
drives that are configured
 	Disks are exposed with WCE=1. User is advised to enable Write Back
 	mode only when the controller has battery backup. At this time
 	Synhronize cache is not supported by the FW. Driver will short-cycle
-	the cmd and return sucess without sending down to FW.
+	the cmd and return success without sending down to FW.

 1 Release Date    : Sun Jan. 14 11:21:32 PDT 2007 -
 		 Sumant Patro <Sumant.Patro@lsil.com>/Bo Yang
diff --git a/Documentation/spi/spi-summary b/Documentation/spi/spi-summary
index deab51d..4884cb3 100644
--- a/Documentation/spi/spi-summary
+++ b/Documentation/spi/spi-summary
@@ -538,7 +538,7 @@ SPI MESSAGE QUEUE
 The bulk of the driver will be managing the I/O queue fed by transfer().

 That queue could be purely conceptual.  For example, a driver used only
-for low-frequency sensor acess might be fine using synchronous PIO.
+for low-frequency sensor access might be fine using synchronous PIO.

 But the queue will probably be very real, using message->queue, PIO,
 often DMA (especially if the root filesystem is in SPI flash), and
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index a6e360d..fc5790d 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -370,7 +370,7 @@ The default is 1 percent.
 mmap_min_addr

 This file indicates the amount of address space  which a user process will
-be restricted from mmaping.  Since kernel null dereference bugs could
+be restricted from mmapping.  Since kernel null dereference bugs could
 accidentally operate based on the information in the first couple of pages
 of memory userspace processes should not be allowed to write to them.  By
 default this value is set to 0 and no protections will be enforced by the
diff --git a/Documentation/video4linux/gspca.txt
b/Documentation/video4linux/gspca.txt
index 3f61825..6b29555 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -6,7 +6,7 @@ The modules are:

 xxxx		vend:prod
 ----
-spca501		0000:0000	MystFromOri Unknow Camera
+spca501		0000:0000	MystFromOri Unknown Camera
 m5602		0402:5602	ALi Video Camera Controller
 spca501		040a:0002	Kodak DVC-325
 spca500		040a:0300	Kodak EZ200
diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
index 3ec4f2a..aa7f4d0 100644
--- a/Documentation/vm/page-types.c
+++ b/Documentation/vm/page-types.c
@@ -301,7 +301,7 @@ static char *page_flag_name(uint64_t flags)
 		present = (flags >> i) & 1;
 		if (!page_flag_names[i]) {
 			if (present)
-				fatal("unkown flag bit %d\n", i);
+				fatal("unknown flag bit %d\n", i);
 			continue;
 		}
 		buf[j++] = present ? page_flag_names[i][0] : '_';
diff --git a/arch/arm/common/scoop.c b/arch/arm/common/scoop.c
index 7713a08..37bda5f 100644
--- a/arch/arm/common/scoop.c
+++ b/arch/arm/common/scoop.c
@@ -82,7 +82,7 @@ static int scoop_gpio_get(struct gpio_chip *chip,
unsigned offset)
 {
 	struct scoop_dev *sdev = container_of(chip, struct scoop_dev, gpio);

-	/* XXX: I'm usure,  but it seems so */
+	/* XXX: I'm unsure, but it seems so */
 	return ioread16(sdev->base + SCOOP_GPRR) & (1 << (offset + 1));
 }

diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
index 375066a..1e24420 100644
--- a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
@@ -83,7 +83,7 @@ typedef struct {
 *  @brief   Get next available transaction width
 *
 *
-*  @return  On sucess  : Next avail able transaction width
+*  @return  On success  : Next avail able transaction width
 *           On failure : dmacHw_TRANSACTION_WIDTH_8
 *
 *  @note
diff --git a/arch/arm/mach-bcmring/include/mach/dma.h
b/arch/arm/mach-bcmring/include/mach/dma.h
index 847980c..1f2c531 100644
--- a/arch/arm/mach-bcmring/include/mach/dma.h
+++ b/arch/arm/mach-bcmring/include/mach/dma.h
@@ -651,7 +651,7 @@ int dma_map_add_region(DMA_MemMap_t *memMap,	/*
Stores state information about t
 /**
 *   Creates a descriptor ring from a memory mapping.
 *
-*   @return 0 on sucess, error code otherwise.
+*   @return 0 on success, error code otherwise.
 */
 /****************************************************************************/

diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
index 36dc541..bdf96eb 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -463,7 +463,7 @@ static void __init orion5x_setup_pci_wins(struct
mbus_dram_target_info *dram)
 	writel(win_enable, PCI_BAR_ENABLE);

 	/*
-	 * Disable automatic update of address remaping when writing to BARs.
+	 * Disable automatic update of address remapping when writing to BARs.
 	 */
 	orion5x_setbits(PCI_ADDR_DECODE_CTRL, 1);
 }
diff --git a/arch/arm/mach-pxa/include/mach/palmld.h
b/arch/arm/mach-pxa/include/mach/palmld.h
index 8721b80..ae536e8 100644
--- a/arch/arm/mach-pxa/include/mach/palmld.h
+++ b/arch/arm/mach-pxa/include/mach/palmld.h
@@ -91,7 +91,7 @@
 /* BATTERY */
 #define PALMLD_BAT_MAX_VOLTAGE		4000	/* 4.00V maximum voltage */
 #define PALMLD_BAT_MIN_VOLTAGE		3550	/* 3.55V critical voltage */
-#define PALMLD_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMLD_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMLD_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMLD_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMLD_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmt5.h
b/arch/arm/mach-pxa/include/mach/palmt5.h
index d15662a..6baf746 100644
--- a/arch/arm/mach-pxa/include/mach/palmt5.h
+++ b/arch/arm/mach-pxa/include/mach/palmt5.h
@@ -66,7 +66,7 @@
 /* BATTERY */
 #define PALMT5_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMT5_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMT5_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMT5_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMT5_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMT5_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMT5_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmtc.h
b/arch/arm/mach-pxa/include/mach/palmtc.h
index 3dc9b07..3f9dd3f 100644
--- a/arch/arm/mach-pxa/include/mach/palmtc.h
+++ b/arch/arm/mach-pxa/include/mach/palmtc.h
@@ -68,7 +68,7 @@
 /* BATTERY */
 #define PALMTC_BAT_MAX_VOLTAGE		4000	/* 4.00V maximum voltage */
 #define PALMTC_BAT_MIN_VOLTAGE		3550	/* 3.55V critical voltage */
-#define PALMTC_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMTC_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMTC_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMTC_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMTC_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmte2.h
b/arch/arm/mach-pxa/include/mach/palmte2.h
index 1236134..f89e989 100644
--- a/arch/arm/mach-pxa/include/mach/palmte2.h
+++ b/arch/arm/mach-pxa/include/mach/palmte2.h
@@ -59,7 +59,7 @@
 /* BATTERY */
 #define PALMTE2_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMTE2_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMTE2_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMTE2_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMTE2_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMTE2_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMTE2_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmtx.h
b/arch/arm/mach-pxa/include/mach/palmtx.h
index 1be0db6..10abc4f 100644
--- a/arch/arm/mach-pxa/include/mach/palmtx.h
+++ b/arch/arm/mach-pxa/include/mach/palmtx.h
@@ -94,7 +94,7 @@
 /* BATTERY */
 #define PALMTX_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMTX_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMTX_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMTX_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMTX_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMTX_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMTX_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmz72.h
b/arch/arm/mach-pxa/include/mach/palmz72.h
index 2806ef6..2bbcf70 100644
--- a/arch/arm/mach-pxa/include/mach/palmz72.h
+++ b/arch/arm/mach-pxa/include/mach/palmz72.h
@@ -49,7 +49,7 @@
 /* Battery */
 #define PALMZ72_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMZ72_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMZ72_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMZ72_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMZ72_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMZ72_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMZ72_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-s3c6400/setup-sdhci.c
b/arch/arm/mach-s3c6400/setup-sdhci.c
index b93dafb..1039937 100644
--- a/arch/arm/mach-s3c6400/setup-sdhci.c
+++ b/arch/arm/mach-s3c6400/setup-sdhci.c
@@ -30,7 +30,7 @@ char *s3c6400_hsmmc_clksrcs[4] = {
 	[0] = "hsmmc",
 	[1] = "hsmmc",
 	[2] = "mmc_bus",
-	/* [3] = "48m", - note not succesfully used yet */
+	/* [3] = "48m", - note not successfully used yet */
 };

 void s3c6400_setup_sdhci_cfg_card(struct platform_device *dev,
diff --git a/arch/arm/mach-s3c6410/setup-sdhci.c
b/arch/arm/mach-s3c6410/setup-sdhci.c
index 20666f3..816d2d9 100644
--- a/arch/arm/mach-s3c6410/setup-sdhci.c
+++ b/arch/arm/mach-s3c6410/setup-sdhci.c
@@ -30,7 +30,7 @@ char *s3c6410_hsmmc_clksrcs[4] = {
 	[0] = "hsmmc",
 	[1] = "hsmmc",
 	[2] = "mmc_bus",
-	/* [3] = "48m", - note not succesfully used yet */
+	/* [3] = "48m", - note not successfully used yet */
 };


diff --git a/arch/arm/mach-sa1100/dma.c b/arch/arm/mach-sa1100/dma.c
index cb4521a..ad66035 100644
--- a/arch/arm/mach-sa1100/dma.c
+++ b/arch/arm/mach-sa1100/dma.c
@@ -65,7 +65,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)


 /**
- *	sa1100_request_dma - allocate one of the SA11x0's DMA chanels
+ *	sa1100_request_dma - allocate one of the SA11x0's DMA channels
  *	@device: The SA11x0 peripheral targeted by this request
  *	@device_id: An ascii name for the claiming device
  *	@callback: Function to be called when the DMA completes
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx3.h
b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
index 446f867..0c7802b 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
@@ -112,7 +112,7 @@ enum iomux_gp_func {
  * setups a single pin:
  * 	- reserves the pin so that it is not claimed by another driver
  * 	- setups the iomux according to the configuration
- * 	- if the pin is configured as a GPIO, we claim it throug kernel gpiolib
+ * 	- if the pin is configured as a GPIO, we claim it through kernel gpiolib
  */
 int mxc_iomux_alloc_pin(const unsigned int pin, const char *label);
 /*
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
b/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
index 9f13061..3887f3f 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
@@ -48,7 +48,7 @@
  * setups a single pin:
  * 	- reserves the pin so that it is not claimed by another driver
  * 	- setups the iomux according to the configuration
- * 	- if the pin is configured as a GPIO, we claim it throug kernel gpiolib
+ * 	- if the pin is configured as a GPIO, we claim it through kernel gpiolib
  */
 int mxc_iomux_alloc_pin(const unsigned int pin_mode, const char *label);
 /*
diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index b53125f..0e30891 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -1232,7 +1232,7 @@ static void create_dma_lch_chain(int lch_head,
int lch_queue)
  * 					      OMAP_DMA_DYNAMIC_CHAIN
  * @params - Channel parameters
  *
- * @return - Succes : 0
+ * @return - Success : 0
  * 	     Failure: -EINVAL/-ENOMEM
  */
 int omap_request_dma_chain(int dev_id, const char *dev_name,
diff --git a/arch/arm/plat-omap/include/mach/omap16xx.h
b/arch/arm/plat-omap/include/mach/omap16xx.h
index 0e69b50..7560b4d 100644
--- a/arch/arm/plat-omap/include/mach/omap16xx.h
+++ b/arch/arm/plat-omap/include/mach/omap16xx.h
@@ -124,7 +124,7 @@
 #define TIPB_SWITCH_BASE		 (0xfffbc800)
 #define OMAP16XX_MMCSD2_SSW_MPU_CONF	(TIPB_SWITCH_BASE + 0x160)

-/* UART3 Registers Maping through MPU bus */
+/* UART3 Registers Mapping through MPU bus */
 #define UART3_RHR               (OMAP_UART3_BASE + 0)
 #define UART3_THR               (OMAP_UART3_BASE + 0)
 #define UART3_DLL               (OMAP_UART3_BASE + 0)
diff --git a/arch/arm/plat-s3c24xx/include/plat/map.h
b/arch/arm/plat-s3c24xx/include/plat/map.h
index c4d1334..bd534d3 100644
--- a/arch/arm/plat-s3c24xx/include/plat/map.h
+++ b/arch/arm/plat-s3c24xx/include/plat/map.h
@@ -64,7 +64,7 @@
 /* the calculation for the VA of this must ensure that
  * it is the same distance apart from the UART in the
  * phsyical address space, as the initial mapping for the IO
- * is done as a 1:1 maping. This puts it (currently) at
+ * is done as a 1:1 mapping. This puts it (currently) at
  * 0xFA800000, which is not in the way of any current mapping
  * by the base system.
 */
diff --git a/arch/avr32/boards/hammerhead/Kconfig
b/arch/avr32/boards/hammerhead/Kconfig
index fda2331..5c13d78 100644
--- a/arch/avr32/boards/hammerhead/Kconfig
+++ b/arch/avr32/boards/hammerhead/Kconfig
@@ -24,7 +24,7 @@ config BOARD_HAMMERHEAD_SND
 	bool "Atmel AC97 Sound support"
 	help
 	  This enables Sound support for the Hammerhead board. You may
-	  also go trough the ALSA settings to get it working.
+	  also go through the ALSA settings to get it working.

 	  Choose 'Y' here if you have ordered a Corona daugther board and
 	  want to make your board funky.
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 6b7325d..78cb3d3 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -619,7 +619,7 @@ asmlinkage notrace void trap_c(struct pt_regs *fp)

 /*
  * Similar to get_user, do some address checking, then dereference
- * Return true on sucess, false on bad address
+ * Return true on success, false on bad address
  */
 static bool get_instruction(unsigned short *val, unsigned short *address)
 {
diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index 4a7cdd9..380df1a 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -209,7 +209,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	/* Are we prepared to handle this kernel fault?
 	 *
 	 * (The kernel has valid exception-points in the source
-	 *  when it acesses user-memory. When it fails in one
+	 *  when it accesses user-memory. When it fails in one
 	 *  of those points, we find it in a table and do a jump
 	 *  to some fixup code that loads an appropriate error
 	 *  code)
diff --git a/arch/ia64/ia32/ia32_entry.S b/arch/ia64/ia32/ia32_entry.S
index af9405c..02d1fb7 100644
--- a/arch/ia64/ia32/ia32_entry.S
+++ b/arch/ia64/ia32/ia32_entry.S
@@ -79,7 +79,7 @@ GLOBAL_ENTRY(ia32_ret_from_clone)
 (p6)	br.cond.spnt .ia32_strace_check_retval
 	;;					// prevent RAW on r8
 END(ia32_ret_from_clone)
-	// fall thrugh
+	// fall through
 GLOBAL_ENTRY(ia32_ret_from_syscall)
 	PT_REGS_UNWIND_INFO(0)

diff --git a/arch/ia64/kernel/esi.c b/arch/ia64/kernel/esi.c
index d5764a3..b091111 100644
--- a/arch/ia64/kernel/esi.c
+++ b/arch/ia64/kernel/esi.c
@@ -84,7 +84,7 @@ static int __init esi_init (void)
 		      case ESI_DESC_ENTRY_POINT:
 			break;
 		      default:
-			printk(KERN_WARNING "Unkown table type %d found in "
+			printk(KERN_WARNING "Unknown table type %d found in "
 			       "ESI table, ignoring rest of table\n", *p);
 			return -ENODEV;
 		}
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index f178270..b3a1cb3 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -3523,7 +3523,7 @@ pfm_use_debug_registers(struct task_struct *task)
  * IA64_THREAD_DBG_VALID set. This indicates a task which was
  * able to use the debug registers for debugging purposes via
  * ptrace(). Therefore we know it was not using them for
- * perfmormance monitoring, so we only decrement the number
+ * performance monitoring, so we only decrement the number
  * of "ptraced" debug register users to keep the count up to date
  */
 int
diff --git a/arch/m68k/include/asm/bootinfo.h b/arch/m68k/include/asm/bootinfo.h
index fb8a06b..67e7a78 100644
--- a/arch/m68k/include/asm/bootinfo.h
+++ b/arch/m68k/include/asm/bootinfo.h
@@ -145,7 +145,7 @@ struct bi_record {

     /*
      *  Macintosh hardware profile data - unused, see macintosh.h for
-     *  resonable type values
+     *  reasonable type values
      */

 #define BI_MAC_VIA1BASE		0x8010	/* Mac VIA1 base address (always present) */
diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
index 6a907c5..cc2108b 100644
--- a/arch/microblaze/lib/memcpy.c
+++ b/arch/microblaze/lib/memcpy.c
@@ -9,7 +9,7 @@
  * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
  * http://www.embedded.com/showArticle.jhtml?articleID=19205567
  *
- * Attempts were made, unsuccesfully, to contact the original
+ * Attempts were made, unsuccessfully, to contact the original
  * author of this code (Michael Morrow, Intel).  Below is the original
  * copyright notice.
  *
diff --git a/arch/microblaze/lib/memmove.c b/arch/microblaze/lib/memmove.c
index d4e9f49..0929198 100644
--- a/arch/microblaze/lib/memmove.c
+++ b/arch/microblaze/lib/memmove.c
@@ -9,7 +9,7 @@
  * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
  * http://www.embedded.com/showArticle.jhtml?articleID=19205567
  *
- * Attempts were made, unsuccesfully, to contact the original
+ * Attempts were made, unsuccessfully, to contact the original
  * author of this code (Michael Morrow, Intel).  Below is the original
  * copyright notice.
  *
diff --git a/arch/microblaze/lib/memset.c b/arch/microblaze/lib/memset.c
index 941dc8f..4df851d 100644
--- a/arch/microblaze/lib/memset.c
+++ b/arch/microblaze/lib/memset.c
@@ -9,7 +9,7 @@
  * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
  * http://www.embedded.com/showArticle.jhtml?articleID=19205567
  *
- * Attempts were made, unsuccesfully, to contact the original
+ * Attempts were made, unsuccessfully, to contact the original
  * author of this code (Michael Morrow, Intel).  Below is the original
  * copyright notice.
  *
diff --git a/arch/mips/include/asm/mach-pnx833x/gpio.h
b/arch/mips/include/asm/mach-pnx833x/gpio.h
index 8de0eb9..ed3a88d 100644
--- a/arch/mips/include/asm/mach-pnx833x/gpio.h
+++ b/arch/mips/include/asm/mach-pnx833x/gpio.h
@@ -24,7 +24,7 @@

 /* BIG FAT WARNING: races danger!
    No protections exist here. Current users are only early init code,
-   when locking is not needed because no cuncurency yet exists there,
+   when locking is not needed because no concurrency yet exists there,
    and GPIO IRQ dispatcher, which does locking.
    However, if many uses will ever happen, proper locking will be needed
    - including locking between different uses
diff --git a/arch/mips/math-emu/dp_sub.c b/arch/mips/math-emu/dp_sub.c
index b30c5b1..a2127d6 100644
--- a/arch/mips/math-emu/dp_sub.c
+++ b/arch/mips/math-emu/dp_sub.c
@@ -110,7 +110,7 @@ ieee754dp ieee754dp_sub(ieee754dp x, ieee754dp y)

 	case CLPAIR(IEEE754_CLASS_DNORM, IEEE754_CLASS_DNORM):
 		DPDNORMX;
-		/* FAAL THOROUGH */
+		/* FALL THROUGH */

 	case CLPAIR(IEEE754_CLASS_NORM, IEEE754_CLASS_DNORM):
 		/* normalize ym,ye */
diff --git a/arch/mips/txx9/generic/smsc_fdc37m81x.c
b/arch/mips/txx9/generic/smsc_fdc37m81x.c
index a2b2d62..8ebc384 100644
--- a/arch/mips/txx9/generic/smsc_fdc37m81x.c
+++ b/arch/mips/txx9/generic/smsc_fdc37m81x.c
@@ -117,7 +117,7 @@ unsigned long __init smsc_fdc37m81x_init(unsigned long port)
 	if (chip_id == SMSC_FDC37M81X_CHIP_ID)
 		smsc_fdc37m81x_config_end();
 	else {
-		printk(KERN_WARNING "%s: unknow chip id 0x%02x\n", __func__,
+		printk(KERN_WARNING "%s: unknown chip id 0x%02x\n", __func__,
 		       chip_id);
 		g_smsc_fdc37m81x_base = 0;
 	}
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 641c74b..b6bd1ea 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -52,7 +52,7 @@ static struct hard_trap_info
 	{ 0x2030, 0x08 /* SIGFPE */  },		/* spe fp data */
 	{ 0x2040, 0x08 /* SIGFPE */  },		/* spe fp data */
 	{ 0x2050, 0x08 /* SIGFPE */  },		/* spe fp round */
-	{ 0x2060, 0x0e /* SIGILL */  },		/* performace monitor */
+	{ 0x2060, 0x0e /* SIGILL */  },		/* performance monitor */
 	{ 0x2900, 0x08 /* SIGFPE */  },		/* apu unavailable */
 	{ 0x3100, 0x0e /* SIGALRM */ },		/* fixed interval timer */
 	{ 0x3200, 0x02 /* SIGINT */  }, 	/* watchdog */
diff --git a/arch/powerpc/oprofile/op_model_cell.c
b/arch/powerpc/oprofile/op_model_cell.c
index ae06c62..3b581b0 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1594,7 +1594,7 @@ static void cell_handle_interrupt_spu(struct
pt_regs *regs,
 		 * to a latch.  The new values (interrupt setting bits, reset
 		 * counter value etc.) are not copied to the actual registers
 		 * until the performance monitor is enabled.  In order to get
-		 * this to work as desired, the permormance monitor needs to
+		 * this to work as desired, the performance monitor needs to
 		 * be disabled while writing to the latches.  This is a
 		 * HW design issue.
 		 */
@@ -1668,7 +1668,7 @@ static void cell_handle_interrupt_ppu(struct
pt_regs *regs,
 		 * to a latch.	The new values (interrupt setting bits, reset
 		 * counter value etc.) are not copied to the actual registers
 		 * until the performance monitor is enabled.  In order to get
-		 * this to work as desired, the permormance monitor needs to
+		 * this to work as desired, the performance monitor needs to
 		 * be disabled while writing to the latches.  This is a
 		 * HW design issue.
 		 */
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
index dd43114..da110bd 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
@@ -100,7 +100,7 @@ const struct of_device_id mpc52xx_pci_ids[] __initdata = {
 };

 /* ======================================================================== */
-/* PCI configuration acess                                                  */
+/* PCI configuration access                                                 */
 /* ======================================================================== */

 static int
diff --git a/arch/powerpc/platforms/powermac/pci.c
b/arch/powerpc/platforms/powermac/pci.c
index e81403b..ab2027c 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -302,7 +302,7 @@ static void __init setup_chaos(struct pci_controller *hose,
  *  1 -> Skip the device but act as if the access was successfull
  *       (return 0xff's on reads, eventually, cache config space
  *       accesses in a later version)
- * -1 -> Hide the device (unsuccessful acess)
+ * -1 -> Hide the device (unsuccessful access)
  */
 static int u3_ht_skip_device(struct pci_controller *hose,
 			     struct pci_bus *bus, unsigned int devfn)
diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index 6e7211a..842cf00 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -14,7 +14,7 @@ extern cpumask_t cpu_core_map[NR_CPUS];
 int topology_set_cpu_management(int fc);
 void topology_schedule_update(void);

-#define POLARIZATION_UNKNWN	(-1)
+#define POLARIZATION_UNKNOWN	(-1)
 #define POLARIZATION_HRZ	(0)
 #define POLARIZATION_VL		(1)
 #define POLARIZATION_VM		(2)
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index c932caa..608fb44 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -309,7 +309,7 @@ static int smp_rescan_cpus_sigp(cpumask_t avail)
 		if (cpu_known(cpu_id))
 			continue;
 		__cpu_logical_map[logical_cpu] = cpu_id;
-		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNWN;
+		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNOWN;
 		if (!cpu_stopped(logical_cpu))
 			continue;
 		cpu_set(logical_cpu, cpu_present_map);
@@ -343,7 +343,7 @@ static int smp_rescan_cpus_sclp(cpumask_t avail)
 		if (cpu_known(cpu_id))
 			continue;
 		__cpu_logical_map[logical_cpu] = cpu_id;
-		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNWN;
+		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNOWN;
 		cpu_set(logical_cpu, cpu_present_map);
 		if (cpu >= info->configured)
 			smp_cpu_state[logical_cpu] = CPU_STATE_STANDBY;
@@ -709,7 +709,7 @@ void __init smp_prepare_boot_cpu(void)
 	S390_lowcore.percpu_offset = __per_cpu_offset[0];
 	current_set[0] = current;
 	smp_cpu_state[0] = CPU_STATE_CONFIGURED;
-	smp_cpu_polarization[0] = POLARIZATION_UNKNWN;
+	smp_cpu_polarization[0] = POLARIZATION_UNKNOWN;
 }

 void __init smp_cpus_done(unsigned int max_cpus)
@@ -764,7 +764,7 @@ static ssize_t cpu_configure_store(struct sys_device *dev,
 			rc = sclp_cpu_deconfigure(__cpu_logical_map[cpu]);
 			if (!rc) {
 				smp_cpu_state[cpu] = CPU_STATE_STANDBY;
-				smp_cpu_polarization[cpu] = POLARIZATION_UNKNWN;
+				smp_cpu_polarization[cpu] = POLARIZATION_UNKNOWN;
 			}
 		}
 		break;
@@ -773,7 +773,7 @@ static ssize_t cpu_configure_store(struct sys_device *dev,
 			rc = sclp_cpu_configure(__cpu_logical_map[cpu]);
 			if (!rc) {
 				smp_cpu_state[cpu] = CPU_STATE_CONFIGURED;
-				smp_cpu_polarization[cpu] = POLARIZATION_UNKNWN;
+				smp_cpu_polarization[cpu] = POLARIZATION_UNKNOWN;
 			}
 		}
 		break;
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 3c72c9c..1bc2dcf 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -209,7 +209,7 @@ int topology_set_cpu_management(int fc)
 	if (rc)
 		return -EBUSY;
 	for_each_possible_cpu(cpu)
-		smp_cpu_polarization[cpu] = POLARIZATION_UNKNWN;
+		smp_cpu_polarization[cpu] = POLARIZATION_UNKNOWN;
 	return rc;
 }

diff --git a/arch/x86/include/asm/desc_defs.h b/arch/x86/include/asm/desc_defs.h
index 9d66848..278441f 100644
--- a/arch/x86/include/asm/desc_defs.h
+++ b/arch/x86/include/asm/desc_defs.h
@@ -12,9 +12,9 @@
 #include <linux/types.h>

 /*
- * FIXME: Acessing the desc_struct through its fields is more elegant,
+ * FIXME: Accessing the desc_struct through its fields is more elegant,
  * and should be the one valid thing to do. However, a lot of open code
- * still touches the a and b acessors, and doing this allow us to do it
+ * still touches the a and b accessors, and doing this allow us to do it
  * incrementally. We keep the signature as a struct, rather than an union,
  * so we can get rid of it transparently in the future -- glommer
  */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 87eee07..fb1035c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1123,7 +1123,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	if (!acpi_sci_override_gsi)
 		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0);

-	/* Fill in identity legacy mapings where no override */
+	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();

 	count =
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 98f230f..67e86b8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1635,7 +1635,7 @@ retry:
 			goto out;

 		/*
-		 * aperture was sucessfully enlarged by 128 MB, try
+		 * aperture was successfully enlarged by 128 MB, try
 		 * allocation again
 		 */
 		goto retry;
@@ -2394,7 +2394,7 @@ int __init amd_iommu_init_passthrough(void)
 	struct pci_dev *dev = NULL;
 	u16 devid, devid2;

-	/* allocate passthroug domain */
+	/* allocate passthrough domain */
 	pt_domain = protection_domain_alloc();
 	if (!pt_domain)
 		return -ENOMEM;
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2e20bca..ab02d21 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1286,7 +1286,7 @@ x86_perf_event_set_period(struct perf_event *event,
 		return 0;

 	/*
-	 * If we are way outside a reasoable range then just skip forward:
+	 * If we are way outside a reasonable range then just skip forward:
 	 */
 	if (unlikely(left <= -period)) {
 		left = period;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 1f3186c..5b8c750 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -481,7 +481,7 @@ static int __kprobes reenter_kprobe(struct kprobe
*p, struct pt_regs *regs,

 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
- * remain disabled thorough out this function.
+ * remain disabled throughout this function.
  */
 static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
@@ -818,7 +818,7 @@ no_change:

 /*
  * Interrupts are disabled on entry as trap1 is an interrupt gate and they
- * remain disabled thoroughout this function.
+ * remain disabled throughout this function.
  */
 static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 {
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 11a4ad4..07bcc30 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -203,7 +203,7 @@ static void disarm_kmmio_fault_page(struct
kmmio_fault_page *f)
  */
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate
- * and they remain disabled thorough out this function.
+ * and they remain disabled throughout this function.
  */
 int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 {
@@ -302,7 +302,7 @@ no_kmmio:

 /*
  * Interrupts are disabled on entry as trap1 is an interrupt gate
- * and they remain disabled thorough out this function.
+ * and they remain disabled throughout this function.
  * This must always get called as the pair to kmmio_handler().
  */
 static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
diff --git a/block/blk-iopoll.c b/block/blk-iopoll.c
index ca56420..58916af 100644
--- a/block/blk-iopoll.c
+++ b/block/blk-iopoll.c
@@ -28,7 +28,7 @@ static DEFINE_PER_CPU(struct list_head, blk_cpu_iopoll);
  * Description:
  *     Add this blk_iopoll structure to the pending poll list and trigger the
  *     raise of the blk iopoll softirq. The driver must already have gotten a
- *     succesful return from blk_iopoll_sched_prep() before calling this.
+ *     successful return from blk_iopoll_sched_prep() before calling this.
  **/
 void blk_iopoll_sched(struct blk_iopoll *iop)
 {
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9ac4e37..3aadded 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -599,7 +599,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1028, 0x02b0 },	/* ICH7 on unknown Dell */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
-	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unkown HP  */
+	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unknown HP  */
 	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
 	{ 0x27DF, 0x152D, 0x0778 },	/* ICH7 on unknown Intel */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 979d159..ee95c76 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -188,7 +188,7 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe);
  * @dev: device to try to bind to the driver
  *
  * This function returns -ENODEV if the device is not registered,
- * 1 if the device is bound sucessfully and 0 otherwise.
+ * 1 if the device is bound successfully and 0 otherwise.
  *
  * This function must be called with @dev->sem held.  When called for a
  * USB interface, @dev->parent->sem must be held as well.
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 5b33b85..63bfc54 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -535,7 +535,7 @@ static int btmrvl_sdio_card_to_host(struct
btmrvl_private *priv)
 		break;

 	default:
-		BT_ERR("Unknow packet type:%d", type);
+		BT_ERR("Unknown packet type:%d", type);
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, payload,
 						blksz * buf_block_len);

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 4895f0e..aa09193 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -214,7 +214,7 @@ static int hci_uart_send_frame(struct sk_buff *skb)
 	struct hci_uart *hu;

 	if (!hdev) {
-		BT_ERR("Frame for uknown device (hdev=NULL)");
+		BT_ERR("Frame for unknown device (hdev=NULL)");
 		return -ENODEV;
 	}

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index ad82ec9..30eff80 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -5,7 +5,7 @@
  *
  *  Added devfs support.
  *    Jan-11-1998, C. Scott Ananian <cananian@alumni.princeton.edu>
- *  Shared /dev/zero mmaping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
+ *  Shared /dev/zero mmapping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
  */

 #include <linux/mm.h>
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 1997270..ecb89d7 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -248,7 +248,7 @@ static const struct vm_operations_struct mspec_vm_ops = {
 /*
  * mspec_mmap
  *
- * Called when mmaping the device.  Initializes the vma with a fault handler
+ * Called when mmapping the device.  Initializes the vma with a fault handler
  * and private data structure necessary to allocate, track, and free the
  * underlying pages.
  */
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index 6934025..c1d8b54 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -602,7 +602,7 @@ static void receive_char(struct r3964_info *pInfo,
const unsigned char c)
 		}
 		break;
 	case R3964_WAIT_FOR_RX_REPEAT:
-		/* FALLTROUGH */
+		/* FALLTHROUGH */
 	case R3964_IDLE:
 		if (c == STX) {
 			/* Prevent rx_queue from overflow: */
diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index d3400b2..5b32992 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -193,7 +193,7 @@ enum card_type {

 /* Initialization states a card can be in */
 enum card_state {
-	NOZOMI_STATE_UKNOWN	= 0,
+	NOZOMI_STATE_UNKNOWN	= 0,
 	NOZOMI_STATE_ENABLED	= 1,	/* pci device enabled */
 	NOZOMI_STATE_ALLOCATED	= 2,	/* config setup done */
 	NOZOMI_STATE_READY	= 3,	/* flowcontrols received */
diff --git a/drivers/char/rio/route.h b/drivers/char/rio/route.h
index 20ed73f..46e9637 100644
--- a/drivers/char/rio/route.h
+++ b/drivers/char/rio/route.h
@@ -67,7 +67,7 @@
 typedef struct COST_ROUTE COST_ROUTE;
 struct COST_ROUTE {
 	unsigned char cost;	/* Cost down this link */
-	unsigned char route[NODE_BYTES];	/* Nodes thorough this route */
+	unsigned char route[NODE_BYTES];	/* Nodes through this route */
 };

 typedef struct ROUTE_STR ROUTE_STR;
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 5f753fc..09ad915 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -863,7 +863,7 @@ static int hifn_init_pubrng(struct hifn_device *dev)
 		dev->dmareg |= HIFN_DMAIER_PUBDONE;
 		hifn_write_1(dev, HIFN_1_DMA_IER, dev->dmareg);

-		dprintk("Chip %s: Public key engine has been sucessfully "
+		dprintk("Chip %s: Public key engine has been successfully "
 				"initialised.\n", dev->name);
 	}

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 7585c41..c52ac9e 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -99,7 +99,7 @@ static struct at_desc *atc_alloc_descriptor(struct
dma_chan *chan,
 }

 /**
- * atc_desc_get - get a unsused descriptor from free_list
+ * atc_desc_get - get an unused descriptor from free_list
  * @atchan: channel we want a new descriptor for
  */
 static struct at_desc *atc_desc_get(struct at_dma_chan *atchan)
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index fddf2b3..d373d17 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -183,7 +183,7 @@ static inline struct fw_node *fw_node(struct list_head *l)
  * This function builds the tree representation of the topology given
  * by the self IDs from the latest bus reset.  During the construction
  * of the tree, the function checks that the self IDs are valid and
- * internally consistent.  On succcess this function returns the
+ * internally consistent.  On success this function returns the
  * fw_node corresponding to the local card otherwise NULL.
  */
 static struct fw_node *build_tree(struct fw_card *card,
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 5cae0b3..3f7c500 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -272,7 +272,7 @@ EXPORT_SYMBOL(drm_mode_object_find);
  * functions & device file and adds it to the master fd list.
  *
  * RETURNS:
- * Zero on success, error code on falure.
+ * Zero on success, error code on failure.
  */
 int drm_framebuffer_init(struct drm_device *dev, struct drm_framebuffer *fb,
 			 const struct drm_framebuffer_funcs *funcs)
@@ -2328,7 +2328,7 @@ int drm_mode_connector_property_set_ioctl(struct
drm_device *dev,
 	} else if (connector->funcs->set_property)
 		ret = connector->funcs->set_property(connector, property, out_resp->value);

-	/* store the property value if succesful */
+	/* store the property value if successful */
 	if (!ret)
 		drm_connector_property_set_value(connector, property, out_resp->value);
 out:
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index abfc27b..a2a3fa5 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1309,7 +1309,7 @@ out_free_list:
  * i915_gem_release_mmap - remove physical page mappings
  * @obj: obj in question
  *
- * Preserve the reservation of the mmaping with the DRM core code, but
+ * Preserve the reservation of the mmapping with the DRM core code, but
  * relinquish ownership of the pages back to the system.
  *
  * It is vital that we remove the page mapping if we have mapped a tiled
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 2b0fe54..40fcf6f 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -70,7 +70,7 @@ static struct drm_fb_helper_funcs intel_fb_helper_funcs = {


 /**
- * Curretly it is assumed that the old framebuffer is reused.
+ * Currently it is assumed that the old framebuffer is reused.
  *
  * LOCKING
  * caller should hold the mode config lock.
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c
b/drivers/gpu/drm/i915/intel_sdvo.c
index 083bec2..e7fa327 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2726,7 +2726,7 @@ bool intel_sdvo_init(struct drm_device *dev, int
output_device)
 	/* Wrap with our custom algo which switches to DDC mode */
 	intel_output->ddc_bus->algo = &intel_sdvo_i2c_bit_algo;

-	/* In defaut case sdvo lvds is false */
+	/* In default case sdvo lvds is false */
 	intel_sdvo_get_capabilities(intel_output, &sdvo_priv->caps);

 	if (intel_sdvo_output_setup(intel_output,
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c
b/drivers/gpu/drm/radeon/radeon_fb.c
index b38c4c8..d10eb43 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -59,7 +59,7 @@ static struct fb_ops radeonfb_ops = {
 };

 /**
- * Curretly it is assumed that the old framebuffer is reused.
+ * Currently it is assumed that the old framebuffer is reused.
  *
  * LOCKING
  * caller should hold the mode config lock.
diff --git a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
index 3671815..e845b75 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -432,7 +432,7 @@ static int adm1029_remove(struct i2c_client *client)
 }

 /*
-function that update the status of the chips (temperature for exemple)
+function that update the status of the chips (temperature for example)
 */
 static struct adm1029_data *adm1029_update_device(struct device *dev)
 {
diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
index fc36cad..c48a284 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -928,7 +928,7 @@ static void lm93_update_client_common(struct
lm93_data *data,
 	data->prochot_interval = lm93_read_byte(client,
 			LM93_REG_PROCHOT_INTERVAL);

-	/* Fan Boost Termperature registers */
+	/* Fan Boost Temperature registers */
 	for (i = 0; i < 4; i++)
 		data->boost[i] = lm93_read_byte(client, LM93_REG_BOOST(i));

diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c
b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 4bd39c8..37d12e5 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -381,7 +381,7 @@ static const ipath_err_t infinipath_hwe_htclnkbbyte1crcerr =
 #define IPATH_GPIO_SCL \
 	(1ULL << (_IPATH_GPIO_SCL_NUM+INFINIPATH_EXTC_GPIOOE_SHIFT))

-/* keep the code below somewhat more readonable; not used elsewhere */
+/* keep the code below somewhat more readable; not used elsewhere */
 #define _IPATH_HTLINK0_CRCBITS (infinipath_hwe_htclnkabyte0crcerr |	\
 				infinipath_hwe_htclnkabyte1crcerr)
 #define _IPATH_HTLINK1_CRCBITS (infinipath_hwe_htclnkbbyte0crcerr |	\
diff --git a/drivers/infiniband/hw/ipath/ipath_sd7220.c
b/drivers/infiniband/hw/ipath/ipath_sd7220.c
index aa47eb5..cdd0b32 100644
--- a/drivers/infiniband/hw/ipath/ipath_sd7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_sd7220.c
@@ -614,7 +614,7 @@ static int epb_trans(struct ipath_devdata *dd, u16
reg, u64 i_val, u64 *o_vp)
  * @wd: Write Data - value to set in register
  * @mask: ones where data should be spliced into reg.
  *
- * Basic register read/modify/write, with un-needed acesses elided. That is,
+ * Basic register read/modify/write, with un-needed accesses elided. That is,
  * a mask of zero will prevent write, while a mask of 0xFF will prevent read.
  * returns current (presumed, if a write was done) contents of selected
  * register, or <0 if errors.
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 1c9410d..bcc2d30 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -955,7 +955,7 @@ static int __init hp_sdc_init_hppa(struct parisc_device *d)
 	INIT_DELAYED_WORK(&moduleloader_work, request_module_delayed);

 	ret = hp_sdc_init();
-	/* after sucessfull initialization give SDC some time to settle
+	/* after successfull initialization give SDC some time to settle
 	 * and then load the hp_sdc_mlc upper layer driver */
 	if (!ret)
 		schedule_delayed_work(&moduleloader_work,
diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
index 820e516..7d2b820 100644
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -125,7 +125,7 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 		break;

 	default:
-		printk(KERN_WARNING PREFIX "Unkown HIL Error status (%x)!\n", data);
+		printk(KERN_WARNING PREFIX "Unknown HIL Error status (%x)!\n", data);
 		break;
 	}

diff --git a/drivers/input/touchscreen/atmel-wm97xx.c
b/drivers/input/touchscreen/atmel-wm97xx.c
index 35377f5..a12242f 100644
--- a/drivers/input/touchscreen/atmel-wm97xx.c
+++ b/drivers/input/touchscreen/atmel-wm97xx.c
@@ -59,7 +59,7 @@
 #define ATMEL_WM97XX_AC97C_IRQ		(29)
 #define ATMEL_WM97XX_GPIO_DEFAULT	(32+16) /* Pin 16 on port B. */
 #else
-#error Unkown CPU, this driver only supports AT32AP700X CPUs.
+#error Unknown CPU, this driver only supports AT32AP700X CPUs.
 #endif

 struct continuous {
diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 1c3a371..2e411fe 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -830,7 +830,7 @@ static void handle_controller(_cmsg * cmsg)
 		      case 0: break;
 		      case 1: s = "unknown class"; break;
 		      case 2: s = "unknown function"; break;
-		      default: s = "unkown error"; break;
+		      default: s = "unknown error"; break;
 		   }
 		   if (s)
 	           printk(KERN_INFO "capidrv-%d: %s from controller 0x%x
function %d: %s\n",
diff --git a/drivers/isdn/hardware/eicon/di.c b/drivers/isdn/hardware/eicon/di.c
index b029d13..cb14ae3 100644
--- a/drivers/isdn/hardware/eicon/di.c
+++ b/drivers/isdn/hardware/eicon/di.c
@@ -806,7 +806,7 @@ static void xdi_xlog_request (byte Adapter, byte Id,
           DELIVERY - indication entered isdn_rc function
           RNR=...  - application had returned RNR=... after the
                      look ahead callback
-          RNum=0   - aplication had not returned any buffer to copy
+          RNum=0   - application had not returned any buffer to copy
                      this indication and will copy it self
           COMPLETE - XDI had copied the data to the buffers provided
                      bu the application and is about to issue the
diff --git a/drivers/isdn/hardware/eicon/maintidi.c
b/drivers/isdn/hardware/eicon/maintidi.c
index ac88242..df53451 100644
--- a/drivers/isdn/hardware/eicon/maintidi.c
+++ b/drivers/isdn/hardware/eicon/maintidi.c
@@ -385,7 +385,7 @@ static int SuperTraceMessageInput (void* hLib) {
                   }
                   break;
                 default:
-                  diva_mnt_internal_dprintf (0, DLI_ERR, "Unknon IDI
Ind (DMA mode): %02x", Ind);
+                  diva_mnt_internal_dprintf (0, DLI_ERR, "Unknown IDI
Ind (DMA mode): %02x", Ind);
               }
               p += (this_ind_length+1);
               total_length -= (4 + this_ind_length);
@@ -420,7 +420,7 @@ static int SuperTraceMessageInput (void* hLib) {
             }
             break;
           default:
-            diva_mnt_internal_dprintf (0, DLI_ERR, "Unknon IDI Ind:
%02x", Ind);
+            diva_mnt_internal_dprintf (0, DLI_ERR, "Unknown IDI Ind:
%02x", Ind);
         }
       }
     }
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c
b/drivers/isdn/hardware/mISDN/hfcsusb.c
index fc46a26..a64bb6c 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -721,7 +721,7 @@ hfcsusb_setup_bch(struct bchannel *bch, int protocol)
 	switch (protocol) {
 	case (-1):	/* used for init */
 		bch->state = -1;
-		/* fall trough */
+		/* fall through */
 	case (ISDN_P_NONE):
 		if (bch->state == ISDN_P_NONE)
 			return 0; /* already in idle state */
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.h
b/drivers/isdn/hardware/mISDN/hfcsusb.h
index 43efe73..369196a 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.h
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.h
@@ -150,7 +150,7 @@ symbolic(struct hfcusb_symbolic_list list[], const int num)
 	for (i = 0; list[i].name != NULL; i++)
 		if (list[i].num == num)
 			return list[i].name;
-	return "<unkown USB Error>";
+	return "<unknown USB Error>";
 }

 /* USB descriptor need to contain one of the following EndPoint combination: */
diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c
b/drivers/isdn/hardware/mISDN/mISDNisar.c
index de352a1..09095c7 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -860,7 +860,7 @@ isar_pump_statev_modem(struct isar_ch *ch, u8 devt) {
 		pr_debug("%s: pump stev GSTN CLEAR\n", ch->is->name);
 		break;
 	default:
-		pr_info("u%s: nknown pump stev %x\n", ch->is->name, devt);
+		pr_info("u%s: unknown pump stev %x\n", ch->is->name, devt);
 		break;
 	}
 }
diff --git a/drivers/isdn/hisax/hfc_usb.c b/drivers/isdn/hisax/hfc_usb.c
index 9de5420..ad5831f 100644
--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -1086,7 +1086,7 @@ hfc_usb_l2l1(struct hisax_if *my_hisax_if, int
pr, void *arg)
 			break;
 		default:
 			DBG(HFCUSB_DBG_STATES,
-			       "HFC_USB: hfc_usb_d_l2l1: unkown state : %#x", pr);
+			       "HFC_USB: hfc_usb_d_l2l1: unknown state : %#x", pr);
 			break;
 	}
 }
diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 77ee286..43ff4d3 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -110,7 +110,7 @@
  * crossconnections and conferences via software if not possible through
  * hardware. If hardware capability is available, hardware is used.
  *
- * Echo: Is generated by CMX and is used to check performane of hard and
+ * Echo: Is generated by CMX and is used to check performance of hard and
  * software CMX.
  *
  * The CMX has special functions for conferences with one, two and more
diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index e04bad6..6d4da60 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -725,7 +725,7 @@ tei_id_ver_tout_net(struct FsmInst *fi, int event,
void *arg)
 	if (tm->rcnt == 1) {
 		if (*debug & DEBUG_L2_TEI)
 			tm->tei_m.printdebug(fi,
-			    "check req for tei %d sucessful\n", tm->l2->tei);
+			    "check req for tei %d successful\n", tm->l2->tei);
 		mISDN_FsmChangeState(fi, ST_TEI_NOP);
 	} else if (tm->rcnt > 1) {
 		/* duplicate assignment; remove */
diff --git a/drivers/macintosh/therm_windtunnel.c
b/drivers/macintosh/therm_windtunnel.c
index 8b93644..3fbe41b 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -15,7 +15,7 @@
  *
  *	WARNING: This driver has only been testen on Apple's
  *	1.25 MHz Dual G4 (March 03). It is tuned for a CPU
- *	temperatur around 57 C.
+ *	temperature around 57 C.
  *
  *   Copyright (C) 2003, 2004 Samuel Rydh (samuel@ibrium.se)
  *
diff --git a/drivers/media/common/saa7146_i2c.c
b/drivers/media/common/saa7146_i2c.c
index 7e8f568..48cb154 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -98,7 +98,7 @@ static int saa7146_i2c_msg_cleanup(const struct
i2c_msg *m, int num, __le32 *op)

 		op_count++;

-		/* loop throgh all bytes of message i */
+		/* loop through all bytes of message i */
 		for(j = 0; j < m[i].len; j++) {
 			/* write back all bytes that could have been read */
 			m[i].buf[j] = (le32_to_cpu(op[op_count/3]) >> ((3-(op_count%3))*8));
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h
b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 810f07d..52e4ce4 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -160,7 +160,7 @@ struct tuner_state {
  * search callback possible return status
  *
  * DVBFE_ALGO_SEARCH_SUCCESS
- * The frontend search algorithm completed and returned succesfully
+ * The frontend search algorithm completed and returned successfully
  *
  * DVBFE_ALGO_SEARCH_ASLEEP
  * The frontend search algorithm is sleeping
diff --git a/drivers/media/dvb/dvb-usb/anysee.c
b/drivers/media/dvb/dvb-usb/anysee.c
index 2ae7f64..bb69f37 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -344,7 +344,7 @@ static int anysee_frontend_attach(struct
dvb_usb_adapter *adap)
 	if (ret)
 		return ret;

-	err("Unkown Anysee version: %02x %02x %02x. "\
+	err("Unknown Anysee version: %02x %02x %02x. "\
 	    "Please report the <linux-dvb@linuxtv.org>.",
 	    hw_info[0], hw_info[1], hw_info[2]);

diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c
b/drivers/media/dvb/dvb-usb/dibusb-mb.c
index eeef50b..5c0126d 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -242,7 +242,7 @@ static struct dvb_usb_device_properties
dibusb1_1_properties = {
 			{ &dibusb_dib3000mb_table[9],  &dibusb_dib3000mb_table[11], NULL },
 			{ &dibusb_dib3000mb_table[10], &dibusb_dib3000mb_table[12], NULL },
 		},
-		{	"Unkown USB1.1 DVB-T device ???? please report the name to the author",
+		{	"Unknown USB1.1 DVB-T device ???? please report the name to the author",
 			{ &dibusb_dib3000mb_table[13], NULL },
 			{ &dibusb_dib3000mb_table[14], NULL },
 		},
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index edde87c..6b5ded9 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -259,7 +259,7 @@ int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *d,
 			*state = REMOTE_KEY_REPEAT;
 			break;
 		default:
-			deb_err("unkown type of remote status: %d\n",keybuf[0]);
+			deb_err("unknown type of remote status: %d\n",keybuf[0]);
 			break;
 	}
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/usb-urb.c
b/drivers/media/dvb/dvb-usb/usb-urb.c
index 9da2cc9..f9702e3 100644
--- a/drivers/media/dvb/dvb-usb/usb-urb.c
+++ b/drivers/media/dvb/dvb-usb/usb-urb.c
@@ -56,7 +56,7 @@ static void usb_urb_complete(struct urb *urb)
 				stream->complete(stream, b, urb->actual_length);
 			break;
 		default:
-			err("unkown endpoint type in completition handler.");
+			err("unknown endpoint type in completition handler.");
 			return;
 	}
 	usb_submit_urb(urb,GFP_ATOMIC);
@@ -228,7 +228,7 @@ int usb_urb_init(struct usb_data_stream *stream,
struct usb_data_stream_properti
 		case USB_ISOC:
 			return usb_isoc_urb_init(stream);
 		default:
-			err("unkown URB-type for data transfer.");
+			err("unknown URB-type for data transfer.");
 			return -EINVAL;
 	}
 }
diff --git a/drivers/media/dvb/frontends/au8522_decoder.c
b/drivers/media/dvb/frontends/au8522_decoder.c
index 74981ee..7c6431f 100644
--- a/drivers/media/dvb/frontends/au8522_decoder.c
+++ b/drivers/media/dvb/frontends/au8522_decoder.c
@@ -315,7 +315,7 @@ static void setup_decoder_defaults(struct
au8522_state *state, u8 input_mode)
 	if (input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH13 ||
 	    input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH24) {
 		/* Despite what the table says, for the HVR-950q we still need
-		   to be in CVBS mode for the S-Video input (reason uknown). */
+		   to be in CVBS mode for the S-Video input (reason unknown). */
 		/* filter_coef_type = 3; */
 		filter_coef_type = 5;
 	} else {
diff --git a/drivers/media/dvb/frontends/cx24110.c
b/drivers/media/dvb/frontends/cx24110.c
index ffbcfab..00a4e8f 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -1,4 +1,4 @@
-	/*
+/*
     cx24110 - Single Chip Satellite Channel Receiver driver module

     Copyright (C) 2002 Peter Hettkamp <peter.hettkamp@htp-tel.de> based on
@@ -96,7 +96,7 @@ static struct {u8 reg; u8 data;} cx24110_regdata[]=
 	 {0x42,0x00}, /* @ middle bytes " */
 	 {0x43,0x00}, /* @ LSB          " */
 		      /* leave the carrier tracking loop parameters on default */
-		      /* leave the bit timing loop parameters at gefault */
+		      /* leave the bit timing loop parameters at default */
 	 {0x56,0x4d}, /* set the filtune voltage to 2.7V, as recommended by */
 		      /* the cx24108 data sheet for symbol rates above 15MS/s */
 	 {0x57,0x00}, /* @ Filter sigma delta enabled, positive */
diff --git a/drivers/media/dvb/frontends/cx24113.c
b/drivers/media/dvb/frontends/cx24113.c
index 075b2b5..e9ee555 100644
--- a/drivers/media/dvb/frontends/cx24113.c
+++ b/drivers/media/dvb/frontends/cx24113.c
@@ -589,7 +589,7 @@ struct dvb_frontend *cx24113_attach(struct dvb_frontend *fe,
 		info("detected CX24113 variant\n");
 		break;
 	case REV_CX24113:
-		info("sucessfully detected\n");
+		info("successfully detected\n");
 		break;
 	default:
 		err("unsupported device id: %x\n", state->rev);
diff --git a/drivers/media/dvb/frontends/dib3000mb.c
b/drivers/media/dvb/frontends/dib3000mb.c
index 136b9d2..ad4c8cf 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -154,7 +154,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 			case BANDWIDTH_AUTO:
 				return -EOPNOTSUPP;
 			default:
-				err("unkown bandwidth value.");
+				err("unknown bandwidth value.");
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/media/dvb/frontends/lgdt330x.c
b/drivers/media/dvb/frontends/lgdt330x.c
index 056387b..43971e6 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -479,7 +479,7 @@ static int lgdt3302_read_status(struct
dvb_frontend* fe, fe_status_t* status)
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
-		/* Need to undestand why there are 3 lock levels here */
+		/* Need to understand why there are 3 lock levels here */
 		if ((buf[0] & 0x07) == 0x07)
 			*status |= FE_HAS_CARRIER;
 		break;
@@ -520,7 +520,7 @@ static int lgdt3303_read_status(struct
dvb_frontend* fe, fe_status_t* status)
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
-		/* Need to undestand why there are 3 lock levels here */
+		/* Need to understand why there are 3 lock levels here */
 		if ((buf[0] & 0x07) == 0x07)
 			*status |= FE_HAS_CARRIER;
 		else
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c
b/drivers/media/dvb/frontends/stb0899_drv.c
index a04c782..1570669 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1571,7 +1571,7 @@ static enum dvbfe_search stb0899_search(struct
dvb_frontend *fe, struct dvb_fron
  * stb0899_track
  * periodically check the signal level against a specified
  * threshold level and perform derotator centering.
- * called once we have a lock from a succesful search
+ * called once we have a lock from a successful search
  * event.
  *
  * Will be called periodically called to maintain the
diff --git a/drivers/media/radio/radio-mr800.c
b/drivers/media/radio/radio-mr800.c
index a123908..5f79acb 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -28,7 +28,7 @@
  * http://av-usbradio.sourceforge.net/index.php
  * http://sourceforge.net/projects/av-usbradio/
  * Latest release of theirs project was in 2005.
- * Probably, this driver could be improved trough using their
+ * Probably, this driver could be improved through using their
  * achievements (specifications given).
  * Also, Faidon Liambotis <paravoid@debian.org> wrote nice driver for
this radio
  * in 2007. He allowed to use his driver to improve current mr800 radio driver.
diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c
b/drivers/media/video/cx231xx/cx231xx-avcore.c
index 28f48f4..c217441 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -2414,9 +2414,11 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 		cx231xx_info("No ACK after %d msec -GPIO I2C failed!",
 			     nInit * 10);

-	/* readAck
-	   throuth clock stretch ,slave has given a SCL signal,
-	   so the SDA data can be directly read.  */
+	/*
+	 * readAck
+	 * through clock stretch, slave has given a SCL signal,
+	 * so the SDA data can be directly read.
+	 */
 	status = cx231xx_get_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);

 	if ((dev->gpio_val & 1 << dev->board.tuner_sda_gpio) == 0) {
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c
b/drivers/media/video/cx23885/cx23885-dvb.c
index 45e13ee..16c6a92 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -940,7 +940,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 	int err, i;

 	/* Here we need to allocate the correct number of frontends,
-	 * as reflected in the cards struct. The reality is that currrently
+	 * as reflected in the cards struct. The reality is that currently
 	 * no cx23885 boards support this - yet. But, if we don't modify this
 	 * code then the second frontend would never be allocated (later)
 	 * and fail with error before the attach in dvb_register().
diff --git a/drivers/media/video/gspca/sonixb.c
b/drivers/media/video/gspca/sonixb.c
index cf3af8d..e39efb4 100644
--- a/drivers/media/video/gspca/sonixb.c
+++ b/drivers/media/video/gspca/sonixb.c
@@ -304,7 +304,7 @@ static const __u8 initOv6650[] = {
 };
 static const __u8 ov6650_sensor_init[][8] =
 {
-	/* Bright, contrast, etc are set througth SCBB interface.
+	/* Bright, contrast, etc are set through SCBB interface.
 	 * AVCAP on win2 do not send any data on this 	controls. */
 	/* Anyway, some registers appears to alter bright and constrat */

diff --git a/drivers/media/video/gspca/spca500.c
b/drivers/media/video/gspca/spca500.c
index fab7ef8..7dbd5ee 100644
--- a/drivers/media/video/gspca/spca500.c
+++ b/drivers/media/video/gspca/spca500.c
@@ -589,7 +589,7 @@ static void spca500_reinit(struct gspca_dev *gspca_dev)
 	int err;
 	__u8 Data;

-	/* some unknow command from Aiptek pocket dv and family300 */
+	/* some unknown command from Aiptek pocket dv and family300 */

 	reg_w(gspca_dev, 0x00, 0x0d01, 0x01);
 	reg_w(gspca_dev, 0x00, 0x0d03, 0x00);
diff --git a/drivers/media/video/gspca/spca501.c
b/drivers/media/video/gspca/spca501.c
index b74a342..66f9f00 100644
--- a/drivers/media/video/gspca/spca501.c
+++ b/drivers/media/video/gspca/spca501.c
@@ -1636,7 +1636,7 @@ static const __u16 spca501c_arowana_init_data[][3] = {
 	{}
 };

-/* Unknow camera from Ori Usbid 0x0000:0x0000 */
+/* Unknown camera from Ori Usbid 0x0000:0x0000 */
 /* Based on snoops from Ori Cohen */
 static const __u16 spca501c_mysterious_open_data[][3] = {
 	{0x02, 0x000f, 0x0005},
@@ -1945,7 +1945,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 			goto error;
 		break;
 	case MystFromOriUnknownCamera:
-		/* UnKnow Ori CMOS Camera data */
+		/* Unknown Ori CMOS Camera data */
 		if (write_vector(gspca_dev, spca501c_mysterious_open_data))
 			goto error;
 		break;
@@ -1978,7 +1978,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		write_vector(gspca_dev, spca501c_arowana_open_data);
 		break;
 	case MystFromOriUnknownCamera:
-		/* UnKnow  CMOS Camera data */
+		/* Unknown CMOS Camera data */
 		write_vector(gspca_dev, spca501c_mysterious_init_data);
 		break;
 	default:
diff --git a/drivers/media/video/gspca/zc3xx.c
b/drivers/media/video/gspca/zc3xx.c
index cdf3357..49c3c12 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -7065,7 +7065,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 				break;
 			default:
 				PDEBUG(D_PROBE,
-					"Sensor UNKNOW_0 force Tas5130");
+					"Sensor UNKNOWN_0 force Tas5130");
 				sd->sensor = SENSOR_TAS5130CXX;
 			}
 			break;
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
index 5b152ff..5fcad28 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
@@ -332,7 +332,7 @@ struct pvr2_hdw {

 	/* Bit mask of PVR2_CVAL_INPUT choices which are valid for the hardware */
 	unsigned int input_avail_mask;
-	/* Bit mask of PVR2_CVAL_INPUT choices which are currenly allowed */
+	/* Bit mask of PVR2_CVAL_INPUT choices which are currently allowed */
 	unsigned int input_allowed_mask;

 	/* Location of eeprom or a negative number if none */
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 9e3262c..a4c8436 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -1985,7 +1985,7 @@ static int save_frame(struct s2255_dev *dev,
struct s2255_pipeinfo *pipe_info)
 					wake_up(&dev->fw_data->wait_fw);
 					break;
 				default:
-					printk(KERN_INFO "s2255 unknwn resp\n");
+					printk(KERN_INFO "s2255 unknown resp\n");
 				}
 			default:
 				pdata++;
diff --git a/drivers/media/video/zoran/zoran.h
b/drivers/media/video/zoran/zoran.h
index d439c76..cb1de7e 100644
--- a/drivers/media/video/zoran/zoran.h
+++ b/drivers/media/video/zoran/zoran.h
@@ -106,7 +106,7 @@ struct zoran_params {
 	unsigned long jpeg_markers;	/* Which markers should go into the JPEG output.
 					 * Unless you exactly know what you do, leave them untouched.
 					 * Inluding less markers will make the resulting code
-					 * smaller, but there will be fewer aplications
+					 * smaller, but there will be fewer applications
 					 * which can read it.
 					 * The presence of the APP and COM marker is
 					 * influenced by APP0_len and COM_len ONLY! */
diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h
b/drivers/message/fusion/lsi/mpi_cnfg.h
index 013c7d8..7d17e13 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -1800,13 +1800,13 @@ typedef struct _CONFIG_PAGE_FC_PORT_0
 #define MPI_FCPORTPAGE0_SUPPORT_CLASS_2                 (0x00000002)
 #define MPI_FCPORTPAGE0_SUPPORT_CLASS_3                 (0x00000004)

-#define MPI_FCPORTPAGE0_SUPPORT_SPEED_UKNOWN            (0x00000000)
/* (SNIA)HBA_PORTSPEED_UNKNOWN 0   Unknown - transceiver incapable of
reporting */
+#define MPI_FCPORTPAGE0_SUPPORT_SPEED_UNKNOWN           (0x00000000)
/* (SNIA)HBA_PORTSPEED_UNKNOWN 0   Unknown - transceiver incapable of
reporting */
 #define MPI_FCPORTPAGE0_SUPPORT_1GBIT_SPEED             (0x00000001)
/* (SNIA)HBA_PORTSPEED_1GBIT   1   1 GBit/sec */
 #define MPI_FCPORTPAGE0_SUPPORT_2GBIT_SPEED             (0x00000002)
/* (SNIA)HBA_PORTSPEED_2GBIT   2   2 GBit/sec */
 #define MPI_FCPORTPAGE0_SUPPORT_10GBIT_SPEED            (0x00000004)
/* (SNIA)HBA_PORTSPEED_10GBIT  4  10 GBit/sec */
 #define MPI_FCPORTPAGE0_SUPPORT_4GBIT_SPEED             (0x00000008)
/* (SNIA)HBA_PORTSPEED_4GBIT   8   4 GBit/sec */

-#define MPI_FCPORTPAGE0_CURRENT_SPEED_UKNOWN
MPI_FCPORTPAGE0_SUPPORT_SPEED_UKNOWN
+#define MPI_FCPORTPAGE0_CURRENT_SPEED_UNKNOWN
MPI_FCPORTPAGE0_SUPPORT_SPEED_UNKNOWN
 #define MPI_FCPORTPAGE0_CURRENT_SPEED_1GBIT
MPI_FCPORTPAGE0_SUPPORT_1GBIT_SPEED
 #define MPI_FCPORTPAGE0_CURRENT_SPEED_2GBIT
MPI_FCPORTPAGE0_SUPPORT_2GBIT_SPEED
 #define MPI_FCPORTPAGE0_CURRENT_SPEED_10GBIT
MPI_FCPORTPAGE0_SUPPORT_10GBIT_SPEED
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index ebf6ae0..6302278 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -695,7 +695,7 @@ mptfc_display_port_link_speed(MPT_ADAPTER *ioc,
int portnum, FCPortPage0_t *pp0d
 	state = pp0dest->PortState;

 	if (state != MPI_FCPORTPAGE0_PORTSTATE_OFFLINE &&
-	    new_speed != MPI_FCPORTPAGE0_CURRENT_SPEED_UKNOWN) {
+	    new_speed != MPI_FCPORTPAGE0_CURRENT_SPEED_UNKNOWN) {

 		old = old_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_1GBIT ? "1 Gbps" :
 		       old_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_2GBIT ? "2 Gbps" :
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index d505b68..e39986a 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -940,7 +940,7 @@ static const struct block_device_operations
i2o_block_fops = {
  *	Allocate memory for the i2o_block_device struct, gendisk and request
  *	queue and initialize them as far as no additional information is needed.
  *
- *	Returns a pointer to the allocated I2O Block device on succes or a
+ *	Returns a pointer to the allocated I2O Block device on success or a
  *	negative error code on failure.
  */
 static struct i2o_block_device *i2o_block_device_alloc(void)
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 27cf4af..e5ab621 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -132,7 +132,7 @@ u32 i2o_cntxt_list_add(struct i2o_controller * c, void *ptr)
  *	Removes a previously added pointer from the context list and returns
  *	the matching context id.
  *
- *	Returns context id on succes or 0 on failure.
+ *	Returns context id on success or 0 on failure.
  */
 u32 i2o_cntxt_list_remove(struct i2o_controller * c, void *ptr)
 {
@@ -198,7 +198,7 @@ void *i2o_cntxt_list_get(struct i2o_controller *c,
u32 context)
  *	@c: controller to which the context list belong
  *	@ptr: pointer to which the context id should be fetched
  *
- *	Returns context id which matches to the pointer on succes or 0 on
+ *	Returns context id which matches to the pointer on success or 0 on
  *	failure.
  */
 u32 i2o_cntxt_list_get_ptr(struct i2o_controller * c, void *ptr)
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 41c8fe2..ce5eda9 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -92,7 +92,7 @@ static void gru_vma_close(struct vm_area_struct *vma)
 /*
  * gru_file_mmap
  *
- * Called when mmaping the device.  Initializes the vma with a fault handler
+ * Called when mmapping the device.  Initializes the vma with a fault handler
  * and private data structure necessary to allocate, track, and free the
  * underlying pages.
  */
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 99b74a3..941a4d3 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1360,7 +1360,7 @@ static struct mmc_host_ops s3cmci_ops = {

 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
 	/* This is currently here to avoid a number of if (host->pdata)
-	 * checks. Any zero fields to ensure reaonable defaults are picked. */
+	 * checks. Any zero fields to ensure reasonable defaults are picked. */
 };

 #ifdef CONFIG_CPU_FREQ
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index e51c1ed..b126cf8 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1056,7 +1056,7 @@ static struct nand_ecclayout doc200x_oobinfo = {
 };

 /* Find the (I)NFTL Media Header, and optionally also the mirror media header.
-   On sucessful return, buf will contain a copy of the media header for
+   On successful return, buf will contain a copy of the media header for
    further processing.  id is the string to scan for, and will presumably be
    either "ANAND" or "BNAND".  If findmirror=1, also look for the mirror media
    header.  The page #s of the found media headers are placed in mh0_page and
diff --git a/drivers/mtd/nand/nand_ecc.c b/drivers/mtd/nand/nand_ecc.c
index db7ae9d..92320a6 100644
--- a/drivers/mtd/nand/nand_ecc.c
+++ b/drivers/mtd/nand/nand_ecc.c
@@ -475,7 +475,7 @@ int __nand_correct_data(unsigned char *buf,
 		 *
 		 * The b2 shift is there to get rid of the lowest two bits.
 		 * We could also do addressbits[b2] >> 1 but for the
-		 * performace it does not make any difference
+		 * performance it does not make any difference
 		 */
 		if (eccsize_mult == 1)
 			byte_addr = (addressbits[b1] << 4) + addressbits[b0];
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 11dc7e6..68b5b3a 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -875,7 +875,7 @@ static void s3c2410_nand_init_chip(struct
s3c2410_nand_info *info,
  * @info: The controller instance.
  * @nmtd: The driver version of the MTD instance.
  *
- * This routine is called after the chip probe has succesfully completed
+ * This routine is called after the chip probe has successfully completed
  * and the relevant per-chip information updated. This call ensure that
  * we update the internal state accordingly.
  *
diff --git a/drivers/net/82596.c b/drivers/net/82596.c
index ea6b139..1663bc9 100644
--- a/drivers/net/82596.c
+++ b/drivers/net/82596.c
@@ -19,7 +19,7 @@
    TBD:
    * look at deferring rx frames rather than discarding (as per tulip)
    * handle tx ring full as per tulip
-   * performace test to tune rx_copybreak
+   * performance test to tune rx_copybreak

    Most of my modifications relate to the braindead big-endian
    implementation by Intel.  When the i596 is operating in
diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
index 4e6359f..0680251 100644
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -1633,8 +1633,13 @@ static int amd8111e_enable_link_change(struct
amd8111e_priv* lp)
 	readl(lp->mmio + CMD7);
 	return 0;
 }
-/* This function is called when a packet transmission fails to
complete within a  resonable period, on the assumption that an
interrupts have been failed or the  interface is locked up. This
function will reinitialize the hardware */

+/*
+ * This function is called when a packet transmission fails to complete
+ * within a reasonable period, on the assumption that an interrupts
+ * have been failed or the  interface is locked up. This function will
+ * reinitialize the hardware
+ */
 static void amd8111e_tx_timeout(struct net_device *dev)
 {
 	struct amd8111e_priv* lp = netdev_priv(dev);
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index b5dc7f5..9d828ae 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -120,7 +120,7 @@ static int irq = 5;		/* Default IRQ */
  *      DAYNA driver mode:
  *              Dayna DL2000/DaynaTalk PC (Half Length), COPS LT-95,
  *		Farallon PhoneNET PC III, Farallon PhoneNET PC II
- *	Other cards possibly supported mode unkown though:
+ *	Other cards possibly supported mode unknown though:
  *		Dayna DL2000 (Full length), COPS LT/M (Micro-Channel)
  *
  *	Cards NOT supported by this driver but supported by the ltpc.c
diff --git a/drivers/net/benet/be_cmds.h b/drivers/net/benet/be_cmds.h
index 4995378..f0bb62b 100644
--- a/drivers/net/benet/be_cmds.h
+++ b/drivers/net/benet/be_cmds.h
@@ -435,7 +435,7 @@ enum be_if_flags {
  * filtering capabilities. */
 struct be_cmd_req_if_create {
 	struct be_cmd_req_hdr hdr;
-	u32 version;		/* ignore currntly */
+	u32 version;		/* ignore currently */
 	u32 capability_flags;
 	u32 enable_flags;
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/benet/be_main.c b/drivers/net/benet/be_main.c
index 1f941f0..02a0908 100644
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -1876,7 +1876,7 @@ int be_load_fw(struct be_adapter *adapter, u8 *func)
 		goto fw_exit;
 	}

-	dev_info(&adapter->pdev->dev, "Firmware flashed succesfully\n");
+	dev_info(&adapter->pdev->dev, "Firmware flashed successfully\n");

 fw_exit:
 	release_firmware(fw);
diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index f866128..56ba872 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -1285,7 +1285,7 @@ netdev_tx_t t3_eth_xmit(struct sk_buff *skb,
struct net_device *dev)

 	/*
 	 * We do not use Tx completion interrupts to free DMAd Tx packets.
-	 * This is good for performamce but means that we rely on new Tx
+	 * This is good for performance but means that we rely on new Tx
 	 * packets arriving to run the destructors of completed packets,
 	 * which open up space in their sockets' send queues.  Sometimes
 	 * we do not get such new packets causing Tx to stall.  A single
diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index d1e0563..b7ce406 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -282,7 +282,7 @@ static s32 e1000_init_mac_params_82571(struct
e1000_adapter *adapter)

 	/*
 	 * Ensure that the inter-port SWSM.SMBI lock bit is clear before
-	 * first NVM or PHY acess. This should be done for single-port
+	 * first NVM or PHY access. This should be done for single-port
 	 * devices, and for one port only on dual-port devices so that
 	 * for those devices we can still use the SMBI lock to synchronize
 	 * inter-port accesses to the PHY & NVM.
@@ -1412,7 +1412,7 @@ static s32
e1000_check_for_serdes_link_82571(struct e1000_hw *hw)
 		case e1000_serdes_link_autoneg_progress:
 			/*
 			 * If the LU bit is set in the STATUS register,
-			 * autoneg has completed sucessfully. If not,
+			 * autoneg has completed successfully. If not,
 			 * try foring the link because the far end may be
 			 * available but not capable of autonegotiation.
 			 */
diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
index 99ba2b8..b065ba4 100644
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -571,7 +571,7 @@ s32 e1000e_check_for_serdes_link(struct e1000_hw *hw)
 				if (!(rxcw & E1000_RXCW_IV)) {
 					mac->serdes_has_link = true;
 					hw_dbg(hw, "SERDES: Link up - autoneg "
-					   "completed sucessfully.\n");
+					   "completed successfully.\n");
 				} else {
 					mac->serdes_has_link = false;
 					hw_dbg(hw, "SERDES: Link down - invalid"
diff --git a/drivers/net/ehea/ehea_ethtool.c b/drivers/net/ehea/ehea_ethtool.c
index d768852..75b099c 100644
--- a/drivers/net/ehea/ehea_ethtool.c
+++ b/drivers/net/ehea/ehea_ethtool.c
@@ -118,7 +118,7 @@ doit:
 	ret = ehea_set_portspeed(port, sp);

 	if (!ret)
-		ehea_info("%s: Port speed succesfully set: %dMbps "
+		ehea_info("%s: Port speed successfully set: %dMbps "
 			  "%s Duplex",
 			  port->netdev->name, port->port_speed,
 			  port->full_duplex == 1 ? "Full" : "Half");
@@ -134,7 +134,7 @@ static int ehea_nway_reset(struct net_device *dev)
 	ret = ehea_set_portspeed(port, EHEA_SPEED_AUTONEG);

 	if (!ret)
-		ehea_info("%s: Port speed succesfully set: %dMbps "
+		ehea_info("%s: Port speed successfully set: %dMbps "
 			  "%s Duplex",
 			  port->netdev->name, port->port_speed,
 			  port->full_duplex == 1 ? "Full" : "Half");
diff --git a/drivers/net/lasi_82596.c b/drivers/net/lasi_82596.c
index a0c5785..b77238d 100644
--- a/drivers/net/lasi_82596.c
+++ b/drivers/net/lasi_82596.c
@@ -47,7 +47,7 @@
    TBD:
    * look at deferring rx frames rather than discarding (as per tulip)
    * handle tx ring full as per tulip
-   * performace test to tune rx_copybreak
+   * performance test to tune rx_copybreak

    Most of my modifications relate to the braindead big-endian
    implementation by Intel.  When the i596 is operating in
diff --git a/drivers/net/lib82596.c b/drivers/net/lib82596.c
index 51e11c3..c0dbfc1 100644
--- a/drivers/net/lib82596.c
+++ b/drivers/net/lib82596.c
@@ -47,7 +47,7 @@
    TBD:
    * look at deferring rx frames rather than discarding (as per tulip)
    * handle tx ring full as per tulip
-   * performace test to tune rx_copybreak
+   * performance test to tune rx_copybreak

    Most of my modifications relate to the braindead big-endian
    implementation by Intel.  When the i596 is operating in
diff --git a/drivers/net/mlx4/en_rx.c b/drivers/net/mlx4/en_rx.c
index 03b781a..829b9ec 100644
--- a/drivers/net/mlx4/en_rx.c
+++ b/drivers/net/mlx4/en_rx.c
@@ -204,7 +204,7 @@ static void mlx4_en_free_rx_desc(struct mlx4_en_priv *priv,
 		en_dbg(DRV, priv, "Freeing fragment:%d\n", nr);
 		dma = be64_to_cpu(rx_desc->data[nr].addr);

-		en_dbg(DRV, priv, "Unmaping buffer at dma:0x%llx\n", (u64) dma);
+		en_dbg(DRV, priv, "Unmapping buffer at dma:0x%llx\n", (u64) dma);
 		pci_unmap_single(mdev->pdev, dma, skb_frags[nr].size,
 				 PCI_DMA_FROMDEVICE);
 		put_page(skb_frags[nr].page);
diff --git a/drivers/net/mlx4/mlx4_en.h b/drivers/net/mlx4/mlx4_en.h
index 4376147..82c3ebc 100644
--- a/drivers/net/mlx4/mlx4_en.h
+++ b/drivers/net/mlx4/mlx4_en.h
@@ -162,7 +162,7 @@ enum {
 #define MLX4_EN_DEF_RX_PAUSE	1
 #define MLX4_EN_DEF_TX_PAUSE	1

-/* Interval between sucessive polls in the Tx routine when polling is used
+/* Interval between successive polls in the Tx routine when polling is used
    instead of interrupts (in per-core Tx rings) - should be power of 2 */
 #define MLX4_EN_TX_POLL_MODER	16
 #define MLX4_EN_TX_POLL_TIMEOUT	(HZ / 4)
diff --git a/drivers/net/ps3_gelic_net.c b/drivers/net/ps3_gelic_net.c
index b211613..86fde1a 100644
--- a/drivers/net/ps3_gelic_net.c
+++ b/drivers/net/ps3_gelic_net.c
@@ -296,7 +296,7 @@ static void gelic_card_reset_chain(struct gelic_card *card,
  * @card: card structure
  * @descr: descriptor to re-init
  *
- * return 0 on succes, <0 on failure
+ * return 0 on success, <0 on failure
  *
  * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
  * Activate the descriptor state-wise
diff --git a/drivers/net/sfc/falcon.c b/drivers/net/sfc/falcon.c
index c049364..70c1232 100644
--- a/drivers/net/sfc/falcon.c
+++ b/drivers/net/sfc/falcon.c
@@ -1264,7 +1264,7 @@ int falcon_flush_queues(struct efx_nic *efx)
 		msleep(FALCON_FLUSH_INTERVAL);
 		falcon_poll_flush_events(efx);

-		/* Check if every queue has been succesfully flushed */
+		/* Check if every queue has been successfully flushed */
 		outstanding = false;
 		efx_for_each_tx_queue(tx_queue, efx)
 			outstanding |= !tx_queue->flushed;
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index c072f7f..69a62af 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -1775,7 +1775,7 @@ static int sis900_rx(struct net_device *net_dev)
 			}

 			/* This situation should never happen, but due to
-			   some unknow bugs, it is possible that
+			   some unknown bugs, it is possible that
 			   we are working on NULL sk_buff :-( */
 			if (sis_priv->rx_skbuff[entry] == NULL) {
 				if (netif_msg_rx_err(sis_priv))
diff --git a/drivers/net/skfp/skfddi.c b/drivers/net/skfp/skfddi.c
index b27156e..db216a7 100644
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -1002,7 +1002,7 @@ static int skfp_ioctl(struct net_device *dev,
struct ifreq *rq, int cmd)
 		}
 		break;
 	default:
-		printk("ioctl for %s: unknow cmd: %04x\n", dev->name, ioc.cmd);
+		printk("ioctl for %s: unknown cmd: %04x\n", dev->name, ioc.cmd);
 		status = -EOPNOTSUPP;

 	}			// switch
diff --git a/drivers/net/smsc911x.c b/drivers/net/smsc911x.c
index ccdd196..4a00940 100644
--- a/drivers/net/smsc911x.c
+++ b/drivers/net/smsc911x.c
@@ -816,7 +816,7 @@ static int smsc911x_mii_probe(struct net_device *dev)
 	SMSC_TRACE(HW, "Passed Loop Back Test");
 #endif				/* USE_PHY_WORK_AROUND */

-	SMSC_TRACE(HW, "phy initialised succesfully");
+	SMSC_TRACE(HW, "phy initialised successfully");
 	return 0;
 }

diff --git a/drivers/net/smsc911x.h b/drivers/net/smsc911x.h
index b5716bd..016360c 100644
--- a/drivers/net/smsc911x.h
+++ b/drivers/net/smsc911x.h
@@ -30,7 +30,7 @@
 #define SMSC_NAPI_WEIGHT	16

 /* implements a PHY loopback test at initialisation time, to ensure a packet
- * can be succesfully looped back */
+ * can be successfully looped back */
 #define USE_PHY_WORK_AROUND

 #define DPRINTK(nlevel, klevel, fmt, args...) \
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 90e663f..40b51e6 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -409,7 +409,7 @@ spider_net_free_rx_chain_contents(struct
spider_net_card *card)
  * @card: card structure
  * @descr: descriptor to re-init
  *
- * Return 0 on succes, <0 on failure.
+ * Return 0 on success, <0 on failure.
  *
  * Allocates a new rx skb, iommu-maps it and attaches it to the
  * descriptor. Mark the descriptor as activated, ready-to-use.
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index 4469f24..5e9adba 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -3798,7 +3798,7 @@ static int ucc_geth_probe(struct of_device*
ofdev, const struct of_device_id *ma
 		prop = of_get_property(np, "tx-clock", NULL);
 		if (!prop) {
 			printk(KERN_ERR
-				"ucc_geth: mising tx-clock-name property\n");
+				"ucc_geth: missing tx-clock-name property\n");
 			return -EINVAL;
 		}
 		if ((*prop < QE_CLK_NONE) || (*prop > QE_CLK24)) {
diff --git a/drivers/net/ucc_geth.h b/drivers/net/ucc_geth.h
index 03a6ca0..a007e2a 100644
--- a/drivers/net/ucc_geth.h
+++ b/drivers/net/ucc_geth.h
@@ -80,16 +80,16 @@ struct ucc_geth {
 				   frames) received that were between 128
 				   (Including FCS length==4) and 255 octets */
 	u32 txok;		/* Total number of octets residing in frames
-				   that where involved in succesfull
+				   that where involved in successfull
 				   transmission */
 	u16 txcf;		/* Total number of PAUSE control frames
 				   transmitted by this MAC */
 	u8 res4[0x2];
 	u32 tmca;		/* Total number of frames that were transmitted
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
 	u32 tbca;		/* Total number of frames transmitted
-				   succesfully that had destination address
+				   successfully that had destination address
 				   field equal to the broadcast address */
 	u32 rxfok;		/* Total number of frames received OK */
 	u32 rxbok;		/* Total number of octets received OK */
@@ -98,9 +98,9 @@ struct ucc_geth {
 				   HW because it includes octets in frames that
 				   never even reach the UCC */
 	u32 rmca;		/* Total number of frames that were received
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
-	u32 rbca;		/* Total number of frames received succesfully
+	u32 rbca;		/* Total number of frames received successfully
 				   that had destination address equal to the
 				   broadcast address */
 	u32 scar;		/* Statistics carry register */
@@ -759,15 +759,15 @@ struct ucc_geth_hardware_statistics {
 				   frames) received that were between 128
 				   (Including FCS length==4) and 255 octets */
 	u32 txok;		/* Total number of octets residing in frames
-				   that where involved in succesfull
+				   that where involved in successfull
 				   transmission */
 	u16 txcf;		/* Total number of PAUSE control frames
 				   transmitted by this MAC */
 	u32 tmca;		/* Total number of frames that were transmitted
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
 	u32 tbca;		/* Total number of frames transmitted
-				   succesfully that had destination address
+				   successfully that had destination address
 				   field equal to the broadcast address */
 	u32 rxfok;		/* Total number of frames received OK */
 	u32 rxbok;		/* Total number of octets received OK */
@@ -776,9 +776,9 @@ struct ucc_geth_hardware_statistics {
 				   HW because it includes octets in frames that
 				   never even reach the UCC */
 	u32 rmca;		/* Total number of frames that were received
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
-	u32 rbca;		/* Total number of frames received succesfully
+	u32 rbca;		/* Total number of frames received successfully
 				   that had destination address equal to the
 				   broadcast address */
 } __attribute__ ((packed));
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index c6c9222..0c3c738 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -748,7 +748,7 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 	mii_nway_restart(&dev->mii);

 	if (netif_msg_ifup(dev))
-		devdbg(dev, "phy initialised succesfully");
+		devdbg(dev, "phy initialised successfully");
 	return 0;
 }

diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 7ea71b3..ee784e0 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -927,7 +927,7 @@ static int __devinit lmc_init_one(struct pci_dev *pdev,
         sc->lmc_media = &lmc_t1_media;
         break;
     default:
-	printk(KERN_WARNING "%s: LMC UNKOWN CARD!\n", dev->name);
+	printk(KERN_WARNING "%s: LMC UNKNOWN CARD!\n", dev->name);
         break;
     }

diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
index 07c32e6..99d2747 100644
--- a/drivers/net/wimax/i2400m/rx.c
+++ b/drivers/net/wimax/i2400m/rx.c
@@ -1114,7 +1114,7 @@ error:
  * device. See the file header for the format. Run all checks on the
  * buffer header, then run over each payload's descriptors, verify
  * their consistency and act on each payload's contents.  If
- * everything is succesful, update the device's statistics.
+ * everything is successful, update the device's statistics.
  *
  * Note: You need to set the skb to contain only the length of the
  * received buffer; for that, use skb_trim(skb, RECEIVED_SIZE).
diff --git a/drivers/net/wireless/ath/ath5k/phy.c
b/drivers/net/wireless/ath/ath5k/phy.c
index 1a039f2..6f04cc7 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -117,7 +117,7 @@ static unsigned int ath5k_hw_rfb_op(struct ath5k_hw *ah,

 /*
  * This code is used to optimize rf gain on different environments
- * (temprature mostly) based on feedback from a power detector.
+ * (temperature mostly) based on feedback from a power detector.
  *
  * It's only used on RF5111 and RF5112, later RF chips seem to have
  * auto adjustment on hw -notice they have a much smaller BANK 7 and
@@ -2675,7 +2675,7 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 		/* Fill curves in reverse order
 		 * from lower power (max gain)
 		 * to higher power. Use curve -> idx
-		 * backmaping we did on eeprom init */
+		 * backmapping we did on eeprom init */
 		u8 idx = pdg_curve_to_idx[pdg];

 		/* Grab the needed curves by index */
@@ -2777,7 +2777,7 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 	/* Now we have a set of curves for this
 	 * channel on tmpL (x range is table_max - table_min
 	 * and y values are tmpL[pdg][]) sorted in the same
-	 * order as EEPROM (because we've used the backmaping).
+	 * order as EEPROM (because we've used the backmapping).
 	 * So for RF5112 it's from higher power to lower power
 	 * and for RF2413 it's from lower power to higher power.
 	 * For RF5111 we only have one curve. */
diff --git a/drivers/net/wireless/ath/ath9k/rc.c
b/drivers/net/wireless/ath/ath9k/rc.c
index 16a2717..2d3b4e7 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -969,7 +969,7 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 				 * Since this probe succeeded, we allow the next
 				 * probe twice as soon.  This allows the maxRate
 				 * to move up faster if the probes are
-				 * succesful.
+				 * successful.
 				 */
 				ath_rc_priv->probe_time =
 					now_msec - rate_table->probe_interval / 2;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c
b/drivers/net/wireless/ipw2x00/ipw2200.c
index 827824d..2eb4e44 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -7751,7 +7751,7 @@ static void ipw_rebuild_decrypted_skb(struct
ipw_priv *priv,
 	case SEC_LEVEL_0:
 		break;
 	default:
-		printk(KERN_ERR "Unknow security level %d\n",
+		printk(KERN_ERR "Unknown security level %d\n",
 		       priv->ieee->sec.level);
 		break;
 	}
@@ -10290,7 +10290,7 @@ static int ipw_tx_skb(struct ipw_priv *priv,
struct libipw_txb *txb,
 		case SEC_LEVEL_0:
 			break;
 		default:
-			printk(KERN_ERR "Unknow security level %d\n",
+			printk(KERN_ERR "Unknown security level %d\n",
 			       priv->ieee->sec.level);
 			break;
 		}
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c
b/drivers/net/wireless/iwmc3200wifi/commands.c
index 84158b6..8d154fa 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -49,7 +49,7 @@
 #include "commands.h"
 #include "debug.h"

-static int iwm_send_lmac_ptrough_cmd(struct iwm_priv *iwm,
+static int iwm_send_lmac_pthrough_cmd(struct iwm_priv *iwm,
 				     u8 lmac_cmd_id,
 				     const void *lmac_payload,
 				     u16 lmac_payload_size,
@@ -185,7 +185,7 @@ int iwm_send_prio_table(struct iwm_priv *iwm)
 	} else
 		IWM_WARN(iwm, "coexistense disabled\n");

-	return iwm_send_lmac_ptrough_cmd(iwm, COEX_PRIORITY_TABLE_CMD,
+	return iwm_send_lmac_pthrough_cmd(iwm, COEX_PRIORITY_TABLE_CMD,
 				&coex_table_cmd,
 				sizeof(struct iwm_coex_prio_table_cmd), 1);
 }
@@ -202,7 +202,7 @@ int iwm_send_init_calib_cfg(struct iwm_priv *iwm,
u8 calib_requested)
 	cal_cfg_cmd.ucode_cfg.flags =
 		cpu_to_le32(CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_AFTER_MSK);

-	return iwm_send_lmac_ptrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
+	return iwm_send_lmac_pthrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
 				sizeof(struct iwm_lmac_cal_cfg_cmd), 1);
 }

@@ -215,7 +215,7 @@ int iwm_send_periodic_calib_cfg(struct iwm_priv
*iwm, u8 calib_requested)
 	cal_cfg_cmd.ucode_cfg.periodic.enable = cpu_to_le32(calib_requested);
 	cal_cfg_cmd.ucode_cfg.periodic.start = cpu_to_le32(calib_requested);

-	return iwm_send_lmac_ptrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
+	return iwm_send_lmac_pthrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
 				sizeof(struct iwm_lmac_cal_cfg_cmd), 0);
 }

@@ -261,7 +261,7 @@ int iwm_send_calib_results(struct iwm_priv *iwm)
 			     &iwm->calib_done_map)) {
 			IWM_DBG_CMD(iwm, DBG,
 				    "Send calibration %d result\n", i);
-			ret |= iwm_send_lmac_ptrough_cmd(iwm,
+			ret |= iwm_send_lmac_pthrough_cmd(iwm,
 					REPLY_PHY_CALIBRATION_CMD,
 					iwm->calib_res[i].buf,
 					iwm->calib_res[i].size, 0);
diff --git a/drivers/net/wireless/iwmc3200wifi/hal.c
b/drivers/net/wireless/iwmc3200wifi/hal.c
index c430418..d13c885 100644
--- a/drivers/net/wireless/iwmc3200wifi/hal.c
+++ b/drivers/net/wireless/iwmc3200wifi/hal.c
@@ -411,7 +411,7 @@ static void iwm_build_lmac_hdr(struct iwm_priv
*iwm, struct iwm_lmac_hdr *hdr,
 /*
  * iwm_hal_send_host_cmd(): sends commands to the UMAC or the LMAC.
  * Sending command to the LMAC is equivalent to sending a
- * regular UMAC command with the LMAC passtrough or the LMAC
+ * regular UMAC command with the LMAC passthrough or the LMAC
  * wrapper UMAC command IDs.
  */
 int iwm_hal_send_host_cmd(struct iwm_priv *iwm,
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c
b/drivers/net/wireless/iwmc3200wifi/rx.c
index 771a301..8ddb51a 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1448,7 +1448,7 @@ static void iwm_rx_process_packet(struct iwm_priv *iwm,
 		kfree_skb(packet->skb);
 		break;
 	default:
-		IWM_ERR(iwm, "Unknow ticket action: %d\n",
+		IWM_ERR(iwm, "Unknown ticket action: %d\n",
 			le16_to_cpu(ticket_node->ticket->action));
 		kfree_skb(packet->skb);
 	}
diff --git a/drivers/net/wireless/libertas/if_sdio.c
b/drivers/net/wireless/libertas/if_sdio.c
index 485a8d4..afe6abe 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -934,7 +934,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	}

 	if (i == ARRAY_SIZE(if_sdio_models)) {
-		lbs_pr_err("unkown card model 0x%x\n", card->model);
+		lbs_pr_err("unknown card model 0x%x\n", card->model);
 		ret = -ENODEV;
 		goto free;
 	}
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c
b/drivers/net/wireless/prism54/isl_ioctl.c
index bc08464..f7f5c79 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1897,7 +1897,7 @@ prism54_get_mac(struct net_device *ndev, struct
iw_request_info *info,
 	return 0;
 }

-/* Setting policy also clears the MAC acl, even if we don't change the defaut
+/* Setting policy also clears the MAC acl, even if we don't change the default
  * policy
  */

@@ -2323,7 +2323,7 @@ prism54_process_trap_helper(islpci_private
*priv, enum oid_num_t oid,

 	case DOT11_OID_BEACON:
 		send_formatted_event(priv,
-				     "Received a beacon from an unkown AP",
+				     "Received a beacon from an unknown AP",
 				     mlme, 0);
 		break;

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h
b/drivers/net/wireless/rt2x00/rt2400pci.h
index ccd6441..aced057 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -35,7 +35,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		100

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h
b/drivers/net/wireless/rt2x00/rt2500pci.h
index 54d3795..3db9041 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -46,7 +46,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		121

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h
b/drivers/net/wireless/rt2x00/rt2500usb.h
index b01edca..d300082 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -46,7 +46,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c
b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9fe770f..409f4d4 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -924,17 +924,17 @@ static void rt2800usb_config_txpower(struct
rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS13, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS14, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS15, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN1, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN2, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN3, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN4, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UNKNOWN1, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UNKNOWN2, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UNKNOWN3, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UNKNOWN4, value);
 	rt2x00usb_register_write(rt2x00dev, TX_PWR_CFG_3, reg);

 	rt2x00usb_register_read(rt2x00dev, TX_PWR_CFG_4, &reg);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN5, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN6, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN7, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN8, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UNKNOWN5, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UNKNOWN6, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UNKNOWN7, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UNKNOWN8, value);
 	rt2x00usb_register_write(rt2x00dev, TX_PWR_CFG_4, reg);
 }

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h
b/drivers/net/wireless/rt2x00/rt2800usb.h
index 4d9991c..4cc7026 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -61,7 +61,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120 /* FIXME */

@@ -766,19 +766,19 @@
 #define TX_PWR_CFG_3_MCS13		FIELD32(0x000000f0)
 #define TX_PWR_CFG_3_MCS14		FIELD32(0x00000f00)
 #define TX_PWR_CFG_3_MCS15		FIELD32(0x0000f000)
-#define TX_PWR_CFG_3_UKNOWN1		FIELD32(0x000f0000)
-#define TX_PWR_CFG_3_UKNOWN2		FIELD32(0x00f00000)
-#define TX_PWR_CFG_3_UKNOWN3		FIELD32(0x0f000000)
-#define TX_PWR_CFG_3_UKNOWN4		FIELD32(0xf0000000)
+#define TX_PWR_CFG_3_UNKNOWN1		FIELD32(0x000f0000)
+#define TX_PWR_CFG_3_UNKNOWN2		FIELD32(0x00f00000)
+#define TX_PWR_CFG_3_UNKNOWN3		FIELD32(0x0f000000)
+#define TX_PWR_CFG_3_UNKNOWN4		FIELD32(0xf0000000)

 /*
  * TX_PWR_CFG_4:
  */
 #define TX_PWR_CFG_4			0x1324
-#define TX_PWR_CFG_4_UKNOWN5		FIELD32(0x0000000f)
-#define TX_PWR_CFG_4_UKNOWN6		FIELD32(0x000000f0)
-#define TX_PWR_CFG_4_UKNOWN7		FIELD32(0x00000f00)
-#define TX_PWR_CFG_4_UKNOWN8		FIELD32(0x0000f000)
+#define TX_PWR_CFG_4_UNKNOWN5		FIELD32(0x0000000f)
+#define TX_PWR_CFG_4_UNKNOWN6		FIELD32(0x000000f0)
+#define TX_PWR_CFG_4_UNKNOWN7		FIELD32(0x00000f00)
+#define TX_PWR_CFG_4_UNKNOWN8		FIELD32(0x0000f000)

 /*
  * TX_PIN_CFG:
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c
b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 5015448..422288b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -193,7 +193,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * Obtain the status about this packet.
 	 * Note that when the status is 0 it does not mean the
 	 * frame was send out correctly. It only means the frame
-	 * was succesfully pushed to the hardware, we have no
+	 * was successfully pushed to the hardware, we have no
 	 * way to determine the transmission status right now.
 	 * (Only indirectly by looking at the failed TX counters
 	 * in the register).
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h
b/drivers/net/wireless/rt2x00/rt61pci.h
index 93eb699..77b5116 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -37,7 +37,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120

diff --git a/drivers/net/wireless/rt2x00/rt73usb.h
b/drivers/net/wireless/rt2x00/rt73usb.h
index 81fe0be..e194332 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -37,7 +37,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120

diff --git a/drivers/net/wireless/wavelan_cs.c
b/drivers/net/wireless/wavelan_cs.c
index 431a20e..b3b0b5b 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -4011,7 +4011,7 @@ wavelan_interrupt(int		irq,
 #endif

   /* Prevent reentrancy. We need to do that because we may have
-   * multiple interrupt handler running concurently.
+   * multiple interrupt handler running concurrently.
    * It is safe because interrupts are disabled before aquiring
    * the spinlock. */
   spin_lock(&lp->spinlock);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6d66635..2b7f965 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -312,7 +312,7 @@ static void tx_status(struct ieee80211_hw *hw,
struct sk_buff *skb,
  * zd_mac_tx_failed - callback for failed frames
  * @dev: the mac80211 wireless device
  *
- * This function is called if a frame couldn't be succesfully be
+ * This function is called if a frame couldn't be successfully be
  * transferred. The first frame from the tx queue, will be selected and
  * reported as error to the upper layers.
  */
diff --git a/drivers/platform/x86/thinkpad_acpi.c
b/drivers/platform/x86/thinkpad_acpi.c
index b408189..7e7da18 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6535,7 +6535,7 @@ static struct ibm_struct volume_driver_data = {
  * 	The speeds are stored on handles
  * 	(FANA:FAN9), (FANC:FANB), (FANE:FAND).
  *
- * 	There are three default speed sets, acessible as handles:
+ * 	There are three default speed sets, accessible as handles:
  * 	FS1L,FS1M,FS1H; FS2L,FS2M,FS2H; FS3L,FS3M,FS3H
  *
  * 	ACPI DSDT switches which set is in use depending on various
diff --git a/drivers/pnp/pnpbios/rsparser.c b/drivers/pnp/pnpbios/rsparser.c
index 87b4f49..a5135eb 100644
--- a/drivers/pnp/pnpbios/rsparser.c
+++ b/drivers/pnp/pnpbios/rsparser.c
@@ -191,7 +191,7 @@ static unsigned char
*pnpbios_parse_allocated_resource_data(struct pnp_dev *dev,
 			return (unsigned char *)p;
 			break;

-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
@@ -405,7 +405,7 @@ pnpbios_parse_resource_option_data(unsigned char
*p, unsigned char *end,
 		case SMALL_TAG_END:
 			return p + 2;

-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
@@ -475,7 +475,7 @@ static unsigned char
*pnpbios_parse_compatible_ids(unsigned char *p,
 			return (unsigned char *)p;
 			break;

-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
@@ -744,7 +744,7 @@ static unsigned char
*pnpbios_encode_allocated_resource_data(struct pnp_dev
 			return (unsigned char *)p;
 			break;

-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
diff --git a/drivers/ps3/ps3-sys-manager.c b/drivers/ps3/ps3-sys-manager.c
index 88cb740..3cbaf18 100644
--- a/drivers/ps3/ps3-sys-manager.c
+++ b/drivers/ps3/ps3-sys-manager.c
@@ -46,7 +46,7 @@
 /**
  * struct ps3_sys_manager_header - System manager message header.
  * @version: Header version, currently 1.
- * @size: Header size in bytes, curently 16.
+ * @size: Header size in bytes, currently 16.
  * @payload_size: Message payload size in bytes.
  * @service_id: Message type, one of enum ps3_sys_manager_service_id.
  * @request_tag: Unique number to identify reply.
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 097d384..f54b1ee 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -74,7 +74,7 @@ fs3270_do_io(struct raw3270_view *view, struct
raw3270_request *rq)
 		}
 		rc = raw3270_start(view, rq);
 		if (rc == 0) {
-			/* Started sucessfully. Now wait for completion. */
+			/* Started successfully. Now wait for completion. */
 			wait_event(fp->wait, raw3270_request_final(rq));
 		}
 	} while (rc == -EACCES);
diff --git a/drivers/s390/cio/chp.c b/drivers/s390/cio/chp.c
index 8ab5160..c268a2e 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -65,7 +65,7 @@ static void set_chp_logically_online(struct chp_id
chpid, int onoff)
 	chpid_to_chp(chpid)->state = onoff;
 }

-/* On succes return 0 if channel-path is varied offline, 1 if it is varied
+/* On success return 0 if channel-path is varied offline, 1 if it is varied
  * online. Return -ENODEV if channel-path is not registered. */
 int chp_get_status(struct chp_id chpid)
 {
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 30f5161..2985eb4 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -462,7 +462,7 @@ static struct cmb_area cmb_area = {
  * block of memory, which can not be moved as long as any channel
  * is active. Therefore, a maximum number of subchannels needs to
  * be defined somewhere. This is a module parameter, defaulting to
- * a resonable value of 1024, or 32 kb of memory.
+ * a reasonable value of 1024, or 32 kb of memory.
  * Current kernels don't allow kmalloc with more than 128kb, so the
  * maximum is 4096.
  */
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index 58e583b..aa2b60a 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -92,11 +92,11 @@
 #define ENVCTRL_CPUTEMP_MON			1    /* cpu temperature monitor */
 #define ENVCTRL_CPUVOLTAGE_MON	  	2    /* voltage monitor         */
 #define ENVCTRL_FANSTAT_MON  		3    /* fan status monitor      */
-#define ENVCTRL_ETHERTEMP_MON		4    /* ethernet temperarture */
+#define ENVCTRL_ETHERTEMP_MON		4    /* ethernet temperature */
 					     /* monitor                     */
 #define ENVCTRL_VOLTAGESTAT_MON	  	5    /* voltage status monitor  */
 #define ENVCTRL_MTHRBDTEMP_MON		6    /* motherboard temperature */
-#define ENVCTRL_SCSITEMP_MON		7    /* scsi temperarture */
+#define ENVCTRL_SCSITEMP_MON		7    /* scsi temperature */
 #define ENVCTRL_GLOBALADDR_MON		8    /* global address */

 /* Child device type.
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f5a9add..07ce9bf 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1491,7 +1491,7 @@ NCR_700_intr(int irq, void *dev_id)
 	unsigned long flags;
 	int handled = 0;

-	/* Use the host lock to serialise acess to the 53c700
+	/* Use the host lock to serialise access to the 53c700
 	 * hardware.  Note: In future, we may need to take the queue
 	 * lock to enter the done routines.  When that happens, we
 	 * need to ensure that for this driver, the host lock and the
diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index b898d38..28a6143 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -730,7 +730,7 @@ typedef struct SCCBscam_info {
 #define  DI    0x13		/*Data Out */
 #define  DC    0x19		/*Disconnect Message */
 #define  ST    0x1D		/*Status Phase */
-#define  UNKNWN 0x24		/*Unknown bus action */
+#define  UNKNOWN 0x24		/*Unknown bus action */
 #define  CC    0x25		/*Command Completion failure */
 #define  TICK  0x26		/*New target reselected us. */
 #define  SELCHK 0x28		/*Select & Check SCSI ID latch reg */
@@ -4616,13 +4616,13 @@ static void FPT_autoLoadDefaultMap(unsigned long p_port)
 	map_addr += 2;
 	WRW_HARPOON(map_addr, (CRD_OP + SDATA + 0x04));	/*DISCONNECT MSG? */
 	map_addr += 2;
-	WRW_HARPOON(map_addr, (BRH_OP + NOT_EQ + UNKNWN));	/*UKNKNOWN MSG */
+	WRW_HARPOON(map_addr, (BRH_OP + NOT_EQ + UNKNOWN));	/*UNKNOWN MSG */
 	map_addr += 2;
 	WRW_HARPOON(map_addr, (MRR_OP + SDATA + D_BUCKET));	/*XFER DISCONNECT MSG */
 	map_addr += 2;
 	WRW_HARPOON(map_addr, (SSI_OP + SSI_ITAR_DISC));	/*STOP AND INTERRUPT */
 	map_addr += 2;
-	WRW_HARPOON(map_addr, (CPN_OP + ASTATUS + UNKNWN));	/*JUMP IF NOT
STATUS PHZ. */
+	WRW_HARPOON(map_addr, (CPN_OP + ASTATUS + UNKNOWN));	/*JUMP IF NOT
STATUS PHZ. */
 	map_addr += 2;
 	WRW_HARPOON(map_addr, (MRR_OP + SDATA + D_AR0));	/*GET STATUS BYTE */
 	map_addr += 2;
diff --git a/drivers/scsi/aic7xxx/aic79xx.seq b/drivers/scsi/aic7xxx/aic79xx.seq
index 58bc175..da2bcec 100644
--- a/drivers/scsi/aic7xxx/aic79xx.seq
+++ b/drivers/scsi/aic7xxx/aic79xx.seq
@@ -217,7 +217,7 @@ BEGIN_CRITICAL;
 scbdma_tohost_done:
 	test	CCSCBCTL, CCARREN jz fill_qoutfifo_dmadone;
 	/*
-	 * An SCB has been succesfully uploaded to the host.
+	 * An SCB has been successfully uploaded to the host.
 	 * If the SCB was uploaded for some reason other than
 	 * bad SCSI status (currently only for underruns), we
 	 * queue the SCB for normal completion.  Otherwise, we
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c
b/drivers/scsi/aic7xxx/aic79xx_core.c
index 63b521d..4d419c1 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2487,7 +2487,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int intstat)
 		/*
 		 * Although the driver does not care about the
 		 * 'Selection in Progress' status bit, the busy
-		 * LED does.  SELINGO is only cleared by a sucessfull
+		 * LED does.  SELINGO is only cleared by a successfull
 		 * selection, so we must manually clear it to insure
 		 * the LED turns off just incase no future successful
 		 * selections occur (e.g. no devices on the bus).
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c
b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 8dfb59d..45aa728 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1733,7 +1733,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int intstat)
 		/*
 		 * Although the driver does not care about the
 		 * 'Selection in Progress' status bit, the busy
-		 * LED does.  SELINGO is only cleared by a sucessfull
+		 * LED does.  SELINGO is only cleared by a successfull
 		 * selection, so we must manually clear it to insure
 		 * the LED turns off just incase no future successful
 		 * selections occur (e.g. no devices on the bus).
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
index a000bc4..bf32041 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
@@ -61,7 +61,7 @@ enum bfa_pport_speed {
  * 		Port operational type (in sync with SNIA port type).
  */
 enum bfa_pport_type {
-	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unkown */
+	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unknown */
 	BFA_PPORT_TYPE_TRUNKED = 2,	/*  Trunked mode */
 	BFA_PPORT_TYPE_NPORT   = 5,	/*  P2P with switched fabric */
 	BFA_PPORT_TYPE_NLPORT  = 6,	/*  public loop */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
b/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
index 31881d2..ade763d 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
@@ -25,7 +25,7 @@
  * Temperature sensor status values
  */
 enum bfa_tsensor_status {
-	BFA_TSENSOR_STATUS_UNKNOWN   = 1,   /*  unkown status */
+	BFA_TSENSOR_STATUS_UNKNOWN   = 1,   /*  unknown status */
 	BFA_TSENSOR_STATUS_FAULTY    = 2,   /*  sensor is faulty */
 	BFA_TSENSOR_STATUS_BELOW_MIN = 3,   /*  temperature below mininum */
 	BFA_TSENSOR_STATUS_NOMINAL   = 4,   /*  normal temperature */
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index a0e7e71..5be67a6 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -834,7 +834,7 @@ static int hptiop_reset_hba(struct hptiop_hba *hba)
 			atomic_read(&hba->resetting) == 0, 60 * HZ);

 	if (atomic_read(&hba->resetting)) {
-		/* IOP is in unkown state, abort reset */
+		/* IOP is in unknown state, abort reset */
 		printk(KERN_ERR "scsi%d: reset failed\n", hba->host->host_no);
 		return -1;
 	}
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index bd2f771..6486ae4 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -56,7 +56,7 @@
  * at the same time.
  *
  * When discovery succeeds or fails a callback is made to the lport as
- * notification. Currently, succesful discovery causes the lport to take no
+ * notification. Currently, successful discovery causes the lport to take no
  * action. A failure will cause the lport to reset. There is likely a circular
  * locking problem with this implementation.
  */
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e0746d..ca25ee5 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1004,7 +1004,7 @@ static struct iscsi_r2t_info
*iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
  * iscsi_tcp_task_xmit - xmit normal PDU task
  * @task: iscsi command task
  *
- * We're expected to return 0 when everything was transmitted succesfully,
+ * We're expected to return 0 when everything was transmitted successfully,
  * -EAGAIN if there's still data in the queue, or != 0 for any other kind
  * of error.
  */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e1a30a1..9bd19aa 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -654,7 +654,7 @@ lpfc_selective_reset(struct lpfc_hba *phba)
  * Notes:
  * Assumes any error from lpfc_selective_reset() will be negative.
  * If lpfc_selective_reset() returns zero then the length of the buffer
- * is returned which indicates succcess
+ * is returned which indicates success
  *
  * Returns:
  * -EINVAL if the buffer does not contain the string "selective"
@@ -3147,7 +3147,7 @@ sysfs_ctlreg_write(struct kobject *kobj, struct
bin_attribute *bin_attr,
  * sysfs_ctlreg_read - Read method for reading from ctlreg
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
- * @buf: if succesful contains the data from the adapter IOREG space.
+ * @buf: if successful contains the data from the adapter IOREG space.
  * @off: offset into buffer to beginning of data.
  * @count: bytes to transfer.
  *
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b31ff7f..30200ee 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -802,7 +802,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct
lpfc_iocbq *cmdiocb,

 	/* FLOGI completes successfully */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0101 FLOGI completes sucessfully "
+			 "0101 FLOGI completes successfully "
 			 "Data: x%x x%x x%x x%x\n",
 			 irsp->un.ulpWord[4], sp->cmn.e_d_tov,
 			 sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution);
@@ -4134,7 +4134,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport,
struct lpfc_iocbq *cmdiocb,
 	/* Indicate we are walking fc_rscn_id_list on this vport */
 	vport->fc_rscn_flush = 1;
 	spin_unlock_irq(shost->host_lock);
-	/* Get the array count after sucessfully have the token */
+	/* Get the array count after successfully have the token */
 	rscn_cnt = vport->fc_rscn_id_cnt;
 	/* If we are already processing an RSCN, save the received
 	 * RSCN payload buffer, cmdiocb->context2 to process later.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 562d8ce..82f8ab5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -645,7 +645,7 @@ lpfc_hba_down_prep(struct lpfc_hba *phba)
  * down the SLI Layer.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 static int
@@ -700,7 +700,7 @@ lpfc_hba_down_post_s3(struct lpfc_hba *phba)
  * down the SLI Layer.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 static int
@@ -755,7 +755,7 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
  * uninitialization after the HBA is reset when bring down the SLI Layer.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 int
@@ -1254,7 +1254,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
  * routine from the API jump table function pointer from the lpfc_hba struct.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 void
@@ -3124,7 +3124,7 @@ static void lpfc_log_intr_mode(struct lpfc_hba
*phba, uint32_t intr_mode)
  * PCI devices.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3220,7 +3220,7 @@ lpfc_reset_hba(struct lpfc_hba *phba)
  * support the SLI-3 HBA device it attached to.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3321,7 +3321,7 @@ lpfc_sli_driver_resource_unset(struct lpfc_hba *phba)
  * support the SLI-4 HBA device it attached to.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3642,7 +3642,7 @@ lpfc_init_api_table_setup(struct lpfc_hba *phba,
uint8_t dev_grp)
  * device specific resource setup to support the HBA device it attached to.
  *
  * Return codes
- *	0 - sucessful
+ *	0 - successful
  *	other values - error
  **/
 static int
@@ -3688,7 +3688,7 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
  * device specific resource setup to support the HBA device it attached to.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3753,7 +3753,7 @@ lpfc_free_iocb_list(struct lpfc_hba *phba)
  * list and set up the IOCB tag array accordingly.
  *
  * Return codes
- *	0 - sucessful
+ *	0 - successful
  *	other values - error
  **/
 static int
@@ -3872,7 +3872,7 @@ lpfc_free_active_sgl(struct lpfc_hba *phba)
  * list and set up the sgl xritag tag array accordingly.
  *
  * Return codes
- *	0 - sucessful
+ *	0 - successful
  *	other values - error
  **/
 static int
@@ -3986,7 +3986,7 @@ out_free_mem:
  * enabled and the driver is reinitializing the device.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -4146,7 +4146,7 @@ lpfc_sli4_remove_rpi_hdrs(struct lpfc_hba *phba)
  * PCI device data structure is set.
  *
  * Return codes
- *      pointer to @phba - sucessful
+ *      pointer to @phba - successful
  *      NULL - error
  **/
 static struct lpfc_hba *
@@ -4202,7 +4202,7 @@ lpfc_hba_free(struct lpfc_hba *phba)
  * host with it.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      other values - error
  **/
 static int
@@ -4365,7 +4365,7 @@ lpfc_post_init_setup(struct lpfc_hba *phba)
  * with SLI-3 interface spec.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -4662,7 +4662,7 @@ lpfc_sli4_bar2_register_memmap(struct lpfc_hba
*phba, uint32_t vf)
  * this routine.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - could not allocated memory.
  **/
 static int
@@ -4761,7 +4761,7 @@ lpfc_destroy_bootstrap_mbox(struct lpfc_hba *phba)
  * allocation for the port.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -4861,7 +4861,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
  * HBA consistent with the SLI-4 interface spec.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -4910,7 +4910,7 @@ lpfc_setup_endian_order(struct lpfc_hba *phba)
  * we just use some constant number as place holder.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5218,7 +5218,7 @@ out_error:
  * operation.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5286,7 +5286,7 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
  * operation.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5552,7 +5552,7 @@ out_error:
  * operation.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5599,7 +5599,7 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
  * Later, this can be used for all the slow-path events.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      -ENOMEM - No availble memory
  **/
 static int
@@ -5760,7 +5760,7 @@ lpfc_sli4_cq_event_release_all(struct lpfc_hba *phba)
  * all resources assigned to the PCI function which originates this request.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5923,7 +5923,7 @@ lpfc_sli4_fcfi_unreg(struct lpfc_hba *phba, uint16_t fcfi)
  * with SLI-4 interface spec.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -6052,7 +6052,7 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
  * will be left with MSI-X enabled and leaks its vectors.
  *
  * Return codes
- *   0 - sucessful
+ *   0 - successful
  *   other values - error
  **/
 static int
@@ -6184,7 +6184,7 @@ lpfc_sli_disable_msix(struct lpfc_hba *phba)
  * is done in this function.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  */
 static int
@@ -6243,7 +6243,7 @@ lpfc_sli_disable_msi(struct lpfc_hba *phba)
  * MSI-X -> MSI -> IRQ.
  *
  * Return codes
- *   0 - sucessful
+ *   0 - successful
  *   other values - error
  **/
 static uint32_t
@@ -6333,7 +6333,7 @@ lpfc_sli_disable_intr(struct lpfc_hba *phba)
  * enabled and leaks its vectors.
  *
  * Return codes
- * 0 - sucessful
+ * 0 - successful
  * other values - error
  **/
 static int
@@ -6443,7 +6443,7 @@ lpfc_sli4_disable_msix(struct lpfc_hba *phba)
  * which is done in this function.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -6508,7 +6508,7 @@ lpfc_sli4_disable_msi(struct lpfc_hba *phba)
  * MSI-X -> MSI -> IRQ.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static uint32_t
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 43cbe33..42d4f3d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1794,7 +1794,7 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 		 */
 		if (lpfc_sli_chk_mbx_command(pmbox->mbxCommand) ==
 		    MBX_SHUTDOWN) {
-			/* Unknow mailbox command compl */
+			/* Unknown mailbox command compl */
 			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 					"(%d):0323 Unknown Mailbox command "
 					"x%x (x%x) Cmpl\n",
@@ -4163,7 +4163,7 @@ lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba,
  * addition, this routine gets the port vpd data.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - could not allocated memory.
  **/
 static int
@@ -11091,7 +11091,7 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba)
  * sequential.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  *      EIO - The mailbox failed to complete successfully.
  * 	When this error occurs, the driver is not guaranteed
  *	to have any rpi regions posted to the device and
@@ -11129,7 +11129,7 @@ lpfc_sli4_post_all_rpi_hdrs(struct lpfc_hba *phba)
  * maps up to 64 rpi context regions.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No available memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -11191,7 +11191,7 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba,
struct lpfc_rpi_hdr *rpi_page)
  * PAGE_SIZE modulo 64 rpi context headers.
  *
  * Returns
- * 	A nonzero rpi defined as rpi_base <= rpi < max_rpi if sucessful
+ * 	A nonzero rpi defined as rpi_base <= rpi < max_rpi if successful
  * 	LPFC_RPI_ALLOC_ERROR if no rpis are available.
  **/
 int
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 512c2cc..d310f49 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -381,7 +381,7 @@ typedef struct {
 	u8	battery_status;	/*
 				 * BIT 0: battery module missing
 				 * BIT 1: VBAD
-				 * BIT 2: temprature high
+				 * BIT 2: temperature high
 				 * BIT 3: battery pack missing
 				 * BIT 4,5:
 				 *   00 - charge complete
diff --git a/drivers/scsi/megaraid/mbox_defs.h
b/drivers/scsi/megaraid/mbox_defs.h
index b25b747..ce2487a 100644
--- a/drivers/scsi/megaraid/mbox_defs.h
+++ b/drivers/scsi/megaraid/mbox_defs.h
@@ -497,7 +497,7 @@ typedef struct {
  * @inserted_drive		: channel:Id of inserted drive
  * @battery_status		: bit 0: battery module missing
  *				bit 1: VBAD
- *				bit 2: temprature high
+ *				bit 2: temperature high
  *				bit 3: battery pack missing
  *				bit 4,5:
  *					00 - charge complete
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c
b/drivers/scsi/megaraid/megaraid_mbox.c
index 234f0b7..f9ae803 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2704,7 +2704,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 	}
 	else {
 		con_log(CL_ANN, (KERN_NOTICE
-		"megaraid mbox: reset sequence completed sucessfully\n"));
+		"megaraid mbox: reset sequence completed successfully\n"));
 	}


diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 86ab32d..756e509 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2894,7 +2894,7 @@ _scsih_normalize_sense(char *sense_buffer,
struct sense_info *data)

 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 /**
- * _scsih_scsi_ioc_info - translated non-succesfull SCSI_IO request
+ * _scsih_scsi_ioc_info - translated non-successfull SCSI_IO request
  * @ioc: per adapter object
  * @scmd: pointer to scsi command object
  * @mpi_reply: reply mf payload returned from firmware
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 1366be1..7f96713 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -6495,7 +6495,7 @@ static void ncr_int_ma (struct ncb *np)
 	**	we force a SIR_NEGO_PROTO interrupt (it is a hack that avoids
 	**	bloat for such a should_not_happen situation).
 	**	In all other situation, we reset the BUS.
-	**	Are these assumptions reasonnable ? (Wait and see ...)
+	**	Are these assumptions reasonable ? (Wait and see ...)
 	*/
 unexpected_phase:
 	dsp -= 8;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index f7c70e2..d3d39f8 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3342,7 +3342,7 @@ static int pmcraid_chr_fasync(int fd, struct
file *filep, int mode)
  * @direction : data transfer direction
  *
  * Return value
- *  0 on sucess, non-zero error code on failure
+ *  0 on success, non-zero error code on failure
  */
 static int pmcraid_build_passthrough_ioadls(
 	struct pmcraid_cmd *cmd,
@@ -3401,7 +3401,7 @@ static int pmcraid_build_passthrough_ioadls(
  * @direction: data transfer direction
  *
  * Return value
- *  0 on sucess, non-zero error code on failure
+ *  0 on success, non-zero error code on failure
  */
 static void pmcraid_release_passthrough_ioadls(
 	struct pmcraid_cmd *cmd,
@@ -3429,7 +3429,7 @@ static void pmcraid_release_passthrough_ioadls(
  * @arg: pointer to pmcraid_passthrough_buffer user buffer
  *
  * Return value
- *  0 on sucess, non-zero error code on failure
+ *  0 on success, non-zero error code on failure
  */
 static long pmcraid_ioctl_passthrough(
 	struct pmcraid_instance *pinstance,
diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
index 723fdec..0fd6ae6 100644
--- a/drivers/scsi/scsi_netlink.c
+++ b/drivers/scsi/scsi_netlink.c
@@ -613,7 +613,7 @@ EXPORT_SYMBOL_GPL(scsi_nl_send_transport_msg);
  * @data_buf:		pointer to vendor unique data buffer
  *
  * Returns:
- *   0 on succesful return
+ *   0 on successful return
  *   otherwise, failing error code
  *
  * Notes:
diff --git a/drivers/scsi/scsi_transport_sas.c
b/drivers/scsi/scsi_transport_sas.c
index fd47cb1..f27e52d 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -666,7 +666,7 @@ EXPORT_SYMBOL(sas_phy_add);
  *
  * Note:
  *   This function must only be called on a PHY that has not
- *   sucessfully been added using sas_phy_add().
+ *   successfully been added using sas_phy_add().
  */
 void sas_phy_free(struct sas_phy *phy)
 {
@@ -896,7 +896,7 @@ EXPORT_SYMBOL(sas_port_add);
  *
  * Note:
  *   This function must only be called on a PORT that has not
- *   sucessfully been added using sas_port_add().
+ *   successfully been added using sas_port_add().
  */
 void sas_port_free(struct sas_port *port)
 {
@@ -1476,7 +1476,7 @@ EXPORT_SYMBOL(sas_rphy_add);
  *
  * Note:
  *   This function must only be called on a remote
- *   PHY that has not sucessfully been added using
+ *   PHY that has not successfully been added using
  *   sas_rphy_add() (or has been sas_rphy_remove()'d)
  */
 void sas_rphy_free(struct sas_rphy *rphy)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c
b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 45374d6..2b38f6a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1864,7 +1864,7 @@ static pci_ers_result_t sym2_io_slot_dump(struct
pci_dev *pdev)
  *
  * This routine is similar to sym_set_workarounds(), except
  * that, at this point, we already know that the device was
- * succesfully intialized at least once before, and so most
+ * successfully intialized at least once before, and so most
  * of the steps taken there are un-needed here.
  */
 static void sym2_reset_workarounds(struct pci_dev *pdev)
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c
b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 297deb8..a7bc8b7 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -2692,7 +2692,7 @@ static void sym_int_ma (struct sym_hcb *np)
 	 *  we force a SIR_NEGO_PROTO interrupt (it is a hack that avoids
 	 *  bloat for such a should_not_happen situation).
 	 *  In all other situation, we reset the BUS.
-	 *  Are these assumptions reasonnable ? (Wait and see ...)
+	 *  Are these assumptions reasonable ? (Wait and see ...)
 	 */
 unexpected_phase:
 	dsp -= 8;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h
b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 053e63c..5a80cba 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -54,7 +54,7 @@
  *
  *    SYM_OPT_LIMIT_COMMAND_REORDERING
  *        When this option is set, the driver tries to limit tagged
- *        command reordering to some reasonnable value.
+ *        command reordering to some reasonable value.
  *        (set for Linux)
  */
 #if 0
diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index d71dfe3..36ede02 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -361,9 +361,9 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{	"LTS0001",		0       },
 	/* Rockwell's (PORALiNK) 33600 INT PNP */
 	{	"WCI0003",		0	},
-	/* Unkown PnP modems */
+	/* Unknown PnP modems */
 	{	"PNPCXXX",		UNKNOWN_DEV	},
-	/* More unkown PnP modems */
+	/* More unknown PnP modems */
 	{	"PNPDXXX",		UNKNOWN_DEV	},
 	{	"",			0	}
 };
diff --git a/drivers/serial/pmac_zilog.h b/drivers/serial/pmac_zilog.h
index 570b0d9..f6e77f1 100644
--- a/drivers/serial/pmac_zilog.h
+++ b/drivers/serial/pmac_zilog.h
@@ -73,7 +73,7 @@ static inline struct uart_pmac_port
*pmz_get_port_A(struct uart_pmac_port *uap)
 }

 /*
- * Register acessors. Note that we don't need to enforce a recovery
+ * Register accessors. Note that we don't need to enforce a recovery
  * delay on PCI PowerMac hardware, it's dealt in HW by the MacIO chip,
  * though if we try to use this driver on older machines, we might have
  * to add it back
diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 0c08f28..46de564 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -313,7 +313,7 @@ static void qe_uart_stop_tx(struct uart_port *port)
  * This function will attempt to stuff of all the characters from the
  * kernel's transmit buffer into TX BDs.
  *
- * A return value of non-zero indicates that it sucessfully stuffed all
+ * A return value of non-zero indicates that it successfully stuffed all
  * characters from the kernel buffer.
  *
  * A return value of zero indicates that there are still characters in the
diff --git a/drivers/staging/altpciechdma/altpciechdma.c
b/drivers/staging/altpciechdma/altpciechdma.c
index e0c5ba4..2f07dd4 100644
--- a/drivers/staging/altpciechdma/altpciechdma.c
+++ b/drivers/staging/altpciechdma/altpciechdma.c
@@ -212,7 +212,7 @@ struct ape_dev {
 	int msi_enabled;
 	/* whether this driver could obtain the regions */
 	int got_regions;
-	/* irq line succesfully requested by this driver, -1 otherwise */
+	/* irq line successfully requested by this driver, -1 otherwise */
 	int irq_line;
 	/* board revision */
 	u8 revision;
@@ -336,7 +336,7 @@ static int __devinit map_bars(struct ape_dev *ape,
struct pci_dev *dev)
 		printk(KERN_DEBUG "BAR[%d] mapped at 0x%p with length %lu(/%lu).\n", i,
 		ape->bar[i], bar_min_len[i], bar_length);
 	}
-	/* succesfully mapped all required BAR regions */
+	/* successfully mapped all required BAR regions */
 	rc = 0;
 	goto success;
 fail:
@@ -911,7 +911,7 @@ static int __devinit probe(struct pci_dev *dev,
const struct pci_device_id *id)
 	/* perform DMA engines loop back test */
 	rc = dma_test(ape, dev);
 	(void)rc;
-	/* succesfully took the device */
+	/* successfully took the device */
 	rc = 0;
 	printk(KERN_DEBUG "probe() successful.\n");
 	goto end;
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h
b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index edd657b..3ab27cf 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -82,7 +82,7 @@ struct addi_board {

 	int i_NbrDiChannel;	/*  Number of DI channels */
 	int i_NbrDoChannel;	/*  Number of DO channels */
-	int i_DoMaxdata;	/*  data to set all chanels high */
+	int i_DoMaxdata;	/*  data to set all channels high */

 	int i_NbrTTLChannel;	/*  Number of TTL channels */
 	const struct comedi_lrange *pr_TTLRangelist;	/* rangelist for TTL */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 169cee4..be361f0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1468,7 +1468,7 @@ void v_APCI3120_Interrupt(int irq, void *d)
 	int_amcc = inl(devpriv->i_IobaseAmcc + AMCC_OP_REG_INTCSR);	/*  get
AMCC int register */

 	if ((!int_daq) && (!(int_amcc & ANY_S593X_INT))) {
-		comedi_error(dev, "IRQ from unknow source");
+		comedi_error(dev, "IRQ from unknown source");
 		return;
 	}

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index ef21f03..7b38d17 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -724,7 +724,7 @@ void v_APCI3501_Interrupt(int irq, void *d)
 		APCI3501_TCW_IRQ) & 0x1;

 	if ((!ui_Timer_AOWatchdog)) {
-		comedi_error(dev, "IRQ from unknow source");
+		comedi_error(dev, "IRQ from unknown source");
 		return;
 	}

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c
b/drivers/staging/comedi/drivers/cb_pcidio.c
index 09e6e3b..7daad0a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -109,12 +109,12 @@ MODULE_DEVICE_TABLE(pci, pcidio_pci_table);
    several hardware drivers keep similar information in this structure,
    feel free to suggest moving the variable to the struct
comedi_device struct.  */
 struct pcidio_private {
-	int data;		/*  curently unused */
+	int data;		/*  currently unused */

 	/* would be useful for a PCI device */
 	struct pci_dev *pci_dev;

-	/* used for DO readback, curently unused */
+	/* used for DO readback, currently unused */
 	unsigned int do_readback[4];	/* up to 4 unsigned int suffice to hold
96 bits for PCI-DIO96 */

 	unsigned long dio_reg_base;	/*  address of port A of the first 8255
chip on board */
diff --git a/drivers/staging/comedi/drivers/me4000.c
b/drivers/staging/comedi/drivers/me4000.c
index 6079913..8b9fa0f 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -840,7 +840,7 @@ static int xilinx_download(struct comedi_device *dev)
 		       "comedi%d: me4000: xilinx_download(): DONE flag is not set\n",
 		       dev->minor);
 		printk(KERN_ERR
-		       "comedi%d: me4000: xilinx_download(): Download not succesful\n",
+		       "comedi%d: me4000: xilinx_download(): Download not successful\n",
 		       dev->minor);
 		return -EIO;
 	}
diff --git a/drivers/staging/comedi/drivers/pcl812.c
b/drivers/staging/comedi/drivers/pcl812.c
index 0b51a48..0a5bc3d 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -51,7 +51,7 @@ Options for PCL-812:
         5=A/D input range is +/-0.3125V
   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
         1=D/A outputs 0-10V (internal reference -10V)
-        2=D/A outputs unknow (external reference)
+        2=D/A outputs unknown (external reference)

 Options for PCL-812PG, ACL-8112PG:
   [0] - IO Base
@@ -63,7 +63,7 @@ Options for PCL-812PG, ACL-8112PG:
         1=A/D have max +/-10V input
   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
         1=D/A outputs 0-10V (internal reference -10V)
-        2=D/A outputs unknow (external reference)
+        2=D/A outputs unknown (external reference)

 Options for ACL-8112DG/HG, A-822PGL/PGH, A-823PGL/PGH, ACL-8216, A-826PG:
   [0] - IO Base
@@ -75,7 +75,7 @@ Options for ACL-8112DG/HG, A-822PGL/PGH,
A-823PGL/PGH, ACL-8216, A-826PG:
         1=A/D channels are DIFF
   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
         1=D/A outputs 0-10V (internal reference -10V)
-        2=D/A outputs unknow (external reference)
+        2=D/A outputs unknown (external reference)

 Options for A-821PGL/PGH:
   [0] - IO Base
diff --git a/drivers/staging/comedi/drivers/pcl816.c
b/drivers/staging/comedi/drivers/pcl816.c
index fa24145..d7c0fde 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -112,7 +112,7 @@ struct pcl816_board {
 	int n_dichan;		/*  num of DI chans */
 	int n_dochan;		/*  num of DO chans */
 	const struct comedi_lrange *ai_range_type;	/*  default A/D rangelist */
-	const struct comedi_lrange *ao_range_type;	/*  dafault D/A rangelist */
+	const struct comedi_lrange *ao_range_type;	/*  default D/A rangelist */
 	unsigned int io_range;	/*  len of IO space */
 	unsigned int IRQbits;	/*  allowed interrupts */
 	unsigned int DMAbits;	/*  allowed DMA chans */
@@ -445,7 +445,7 @@ static irqreturn_t interrupt_pcl816(int irq, void *d)
 		comedi_error(dev, "bad IRQ!");
 		return IRQ_NONE;
 	}
-	comedi_error(dev, "IRQ from unknow source!");
+	comedi_error(dev, "IRQ from unknown source!");
 	return IRQ_NONE;
 }

diff --git a/drivers/staging/comedi/drivers/pcl818.c
b/drivers/staging/comedi/drivers/pcl818.c
index e95229b..a008d18 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -50,7 +50,7 @@ A word or two about DMA. Driver support DMA
operations at two ways:
           1, 10=A/D input -10V..+10V
     [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknow (external reference)
+	  2    =D/A output unknown (external reference)

    Options for PCL-818, PCL-818H:
     [0] - IO Base
@@ -60,7 +60,7 @@ A word or two about DMA. Driver support DMA
operations at two ways:
               1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknow (external reference)
+	  2    =D/A output unknown (external reference)

    Options for PCL-818HD, PCL-818HG:
     [0] - IO Base
@@ -71,7 +71,7 @@ A word or two about DMA. Driver support DMA
operations at two ways:
               1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
-   	  2    =D/A output unknow (external reference)
+   	  2    =D/A output unknown (external reference)

    Options for PCL-718:
     [0] - IO Base
@@ -92,7 +92,7 @@ A word or two about DMA. Driver support DMA
operations at two ways:
 	     10=	     user defined unipolar
     [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
           1, 10=D/A outputs 0-10V (internal reference -10V)
-	      2=D/A outputs unknow (external reference)
+	      2=D/A outputs unknown (external reference)
     [6] - 0, 60=max  60kHz A/D sampling
           1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)

@@ -876,7 +876,7 @@ static irqreturn_t interrupt_pcl818(int irq, void *d)
 		return IRQ_NONE;
 	}

-	comedi_error(dev, "IRQ from unknow source!");
+	comedi_error(dev, "IRQ from unknown source!");
 	return IRQ_NONE;
 }

diff --git a/drivers/staging/dst/export.c b/drivers/staging/dst/export.c
index 4fbd848..a4ed16c 100644
--- a/drivers/staging/dst/export.c
+++ b/drivers/staging/dst/export.c
@@ -202,7 +202,7 @@ err_out_exit:
  * so to play good with all cases we just queue BIO into the queue
  * and wake up processing thread, which gets completed request and
  * send (encrypting if needed) it back to the client (if it was a read
- * request), or sends back reply that writing succesfully completed.
+ * request), or sends back reply that writing successfully completed.
  */
 static int dst_export_process_request_queue(struct dst_state *st)
 {
diff --git a/drivers/staging/hv/hv_api.h b/drivers/staging/hv/hv_api.h
index 251e2d1..9eb818e 100644
--- a/drivers/staging/hv/hv_api.h
+++ b/drivers/staging/hv/hv_api.h
@@ -316,13 +316,13 @@

 /*
  * HV_STATUS_VMX_INSTRUCTION_FAILED
- * The requested VMX instruction failed to complete succesfully.
+ * The requested VMX instruction failed to complete successfully.
  */
 #define HV_STATUS_VMX_INSTRUCTION_FAILED		((u16)0x1011)

 /*
  * HV_STATUS_VMX_INSTRUCTION_FAILED_WITH_STATUS
- * The requested VMX instruction failed to complete succesfully indicating
+ * The requested VMX instruction failed to complete successfully indicating
  * status.
  */
 #define HV_STATUS_VMX_INSTRUCTION_FAILED_WITH_STATUS	((u16)0x1012)
diff --git a/drivers/staging/octeon/cvmx-pow.h
b/drivers/staging/octeon/cvmx-pow.h
index c5d66f2..bf9e069 100644
--- a/drivers/staging/octeon/cvmx-pow.h
+++ b/drivers/staging/octeon/cvmx-pow.h
@@ -1959,7 +1959,7 @@ static inline uint32_t
cvmx_pow_tag_get_hw_bits(uint64_t tag)
  * @buffer_size:
  *               The size of the supplied buffer
  *
- * Returns Zero on sucess, negative on failure
+ * Returns Zero on success, negative on failure
  */
 extern int cvmx_pow_capture(void *buffer, int buffer_size);

diff --git a/drivers/staging/octeon/ethernet-tx.c
b/drivers/staging/octeon/ethernet-tx.c
index 81a8513..5352941 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -624,7 +624,7 @@ int cvm_oct_transmit_qos(struct net_device *dev,
void *work_queue_entry,
 EXPORT_SYMBOL(cvm_oct_transmit_qos);

 /**
- * This function frees all skb that are currenty queued for TX.
+ * This function frees all skb that are currently queued for TX.
  *
  * @dev:    Device being shutdown
  */
diff --git a/drivers/staging/otus/80211core/ccmd.c
b/drivers/staging/otus/80211core/ccmd.c
index 83dd8ba..8da28ee 100644
--- a/drivers/staging/otus/80211core/ccmd.c
+++ b/drivers/staging/otus/80211core/ccmd.c
@@ -899,7 +899,7 @@ u16_t zfiWlanDisable(zdev_t *dev, u8_t ResetKeyCache)
 		zfStaDisableSWEncryption(dev);
 	}

-	/* Improve WEP/TKIP performace with HT AP,
+	/* Improve WEP/TKIP performance with HT AP,
 	detail information please look bug#32495 */
 	/* zfHpSetTTSIFSTime(dev, 0x8); */

@@ -1407,7 +1407,7 @@ u16_t zfWlanReset(zdev_t *dev)
 		zfStaDisableSWEncryption(dev);
 	}

-	/* 	Improve WEP/TKIP performace with HT AP,
+	/* 	Improve WEP/TKIP performance with HT AP,
 		detail information please look bug#32495
 	*/
 	/* zfHpSetTTSIFSTime(dev, 0x8); */
diff --git a/drivers/staging/otus/80211core/cmm.c
b/drivers/staging/otus/80211core/cmm.c
index bed16b5..a6c1b41 100644
--- a/drivers/staging/otus/80211core/cmm.c
+++ b/drivers/staging/otus/80211core/cmm.c
@@ -1428,7 +1428,7 @@ void zfProcessManagement(zdev_t* dev, zbuf_t*
buf, struct zsAdditionInfo* AddInf
         {
                 /* Beacon */
             case ZM_WLAN_FRAME_TYPE_BEACON :
-                /* if enable 802.11h and current chanel is silent but
receive beacon from other AP */
+                /* if enable 802.11h and current channel is silent
but receive beacon from other AP */
                 if
(((wd->regulationTable.allowChannel[wd->regulationTable.CurChIndex].channelFlags
                         & ZM_REG_FLAG_CHANNEL_CSA) != 0) && wd->sta.DFSEnable)
                 {
@@ -1469,7 +1469,7 @@ void zfProcessManagement(zdev_t* dev, zbuf_t*
buf, struct zsAdditionInfo* AddInf
                 break;
                 /* Probe response */
             case ZM_WLAN_FRAME_TYPE_PROBERSP :
-                /* if enable 802.11h and current chanel is silent but
receive probe response from other AP */
+                /* if enable 802.11h and current channel is silent
but receive probe response from other AP */
                 if
(((wd->regulationTable.allowChannel[wd->regulationTable.CurChIndex].channelFlags
                         & ZM_REG_FLAG_CHANNEL_CSA) != 0) && wd->sta.DFSEnable)
                 {
diff --git a/drivers/staging/otus/80211core/cmmsta.c
b/drivers/staging/otus/80211core/cmmsta.c
index b28a4e2..a11d559 100644
--- a/drivers/staging/otus/80211core/cmmsta.c
+++ b/drivers/staging/otus/80211core/cmmsta.c
@@ -216,7 +216,7 @@ void zfStaConnectFail(zdev_t* dev, u16_t reason,
u16_t* bssid, u8_t weight)
     /* Change internal state */
     zfChangeAdapterState(dev, ZM_STA_STATE_DISCONNECT);

-    /* Improve WEP/TKIP performace with HT AP, detail information
please look bug#32495 */
+    /* Improve WEP/TKIP performance with HT AP, detail information
please look bug#32495 */
     //zfHpSetTTSIFSTime(dev, 0x8);

     /* Notify wrapper of connection status changes */
@@ -4148,7 +4148,7 @@ void zfInfraConnectNetwork(zdev_t* dev)
             wd->sta.bIsSharedKey = 0;
         }

-        /* Improve WEP/TKIP performace with HT AP, detail information
please look bug#32495 */
+        /* Improve WEP/TKIP performance with HT AP, detail
information please look bug#32495 */
         /*
         if ( (pBssInfo->broadcomHTAp == 1)
              && (wd->sta.SWEncryptEnable != 0) )
diff --git a/drivers/staging/otus/80211core/pub_zfi.h
b/drivers/staging/otus/80211core/pub_zfi.h
index a35bd5d..17f3fe2 100644
--- a/drivers/staging/otus/80211core/pub_zfi.h
+++ b/drivers/staging/otus/80211core/pub_zfi.h
@@ -782,7 +782,7 @@ extern void zfiWlanSetDynamicSIFSParam(zdev_t*
dev, u8_t val);

 /***** End of section 2 *****/

-/***** section 3 performace evaluation *****/
+/***** section 3 performance evaluation *****/
 #ifdef ZM_ENABLE_PERFORMANCE_EVALUATION
 extern void zfiTxPerformanceMSDU(zdev_t* dev, u32_t tick);
 extern void zfiRxPerformanceMPDU(zdev_t* dev, zbuf_t* buf);
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c
b/drivers/staging/quatech_usb2/quatech_usb2.c
index 2acef94..81877e7 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -1670,7 +1670,7 @@ __func__);
 		dbg("%s(): failed resubmitting read urb, error %d",
 			__func__, result);
 	} else {
-		dbg("%s() sucessfully resumitted read urb", __func__);
+		dbg("%s() successfully resumitted read urb", __func__);
 		if (tty_st && RxCount) {
 			/* if some inbound data was processed, then
 			 * we need to push that through the tty layer
diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index 9805d74..24700b1 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -66,7 +66,7 @@ static int __init rar_init_handler(void);
 static void __exit rar_exit_handler(void);

 /*
-  function that is activated on the succesfull probe of the RAR device
+  function that is activated on the successfull probe of the RAR device
 */
 static int __devinit rar_probe(struct pci_dev *pdev, const struct
pci_device_id *ent);

@@ -319,7 +319,7 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 }

 /*
-  function that is activaed on the succesfull probe of the RAR device
+  function that is activaed on the successfull probe of the RAR device
 */
 static int __devinit rar_probe(struct pci_dev *pdev, const struct
pci_device_id *ent)
 {
diff --git a/drivers/staging/rt2860/common/cmm_data.c
b/drivers/staging/rt2860/common/cmm_data.c
index 774fabb..15994f1 100644
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -712,7 +712,7 @@ static UCHAR TxPktClassification(
 	IN RTMP_ADAPTER *pAd,
 	IN PNDIS_PACKET  pPacket)
 {
-	UCHAR			TxFrameType = TX_UNKOWN_FRAME;
+	UCHAR			TxFrameType = TX_UNKNOWN_FRAME;
 	UCHAR			Wcid;
 	MAC_TABLE_ENTRY	*pMacEntry = NULL;
 	BOOLEAN			bHTRate = FALSE;
@@ -1241,7 +1241,7 @@ VOID RTMPWriteTxWI(
 	pTxWI->txop= Txopmode;

 	pTxWI->NSEQ = NSeq;
-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 	BASize = pAd->CommonCfg.TxBASize;

 	if( BASize >7 )
@@ -1331,7 +1331,7 @@ VOID RTMPWriteTxWI_Data(
 	pTxWI->BW = (pTransmit->field.MODE <= MODE_OFDM) ? (BW_20) :
(pTransmit->field.BW);
 	pTxWI->AMPDU	= ((pTxBlk->TxFrameType == TX_AMPDU_FRAME) ? TRUE : FALSE);

-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 	BASize = pAd->CommonCfg.TxBASize;
 	if((pTxBlk->TxFrameType == TX_AMPDU_FRAME) && (pMacEntry))
 	{
diff --git a/drivers/staging/rt2860/common/cmm_info.c
b/drivers/staging/rt2860/common/cmm_info.c
index 019cc44..d4ae081 100644
--- a/drivers/staging/rt2860/common/cmm_info.c
+++ b/drivers/staging/rt2860/common/cmm_info.c
@@ -1736,7 +1736,7 @@ CHAR *GetEncryptType(CHAR enc)
 	if(enc == Ndis802_11Encryption4Enabled)
     	return "TKIPAES";
     else
-    	return "UNKNOW";
+    	return "UNKNOWN";
 }

 CHAR *GetAuthMode(CHAR auth)
@@ -1762,7 +1762,7 @@ CHAR *GetAuthMode(CHAR auth)
 	if(auth == Ndis802_11AuthModeWPA1PSKWPA2PSK)
     	return "WPA1PSKWPA2PSK";

-    	return "UNKNOW";
+    	return "UNKNOWN";
 }

 /*
@@ -1843,7 +1843,7 @@ VOID RTMPIoctlGetSiteSurvey(
 		sprintf(msg+strlen(msg),"%-8s",GetEncryptType(pAdapter->ScanTab.BssEntry[i].WepStatus));
 		//Authentication Mode
 		if (pAdapter->ScanTab.BssEntry[i].WepStatus == Ndis802_11WEPEnabled)
-			sprintf(msg+strlen(msg),"%-10s", "UNKNOW");
+			sprintf(msg+strlen(msg),"%-10s", "UNKNOWN");
 		else
 			sprintf(msg+strlen(msg),"%-10s",GetAuthMode(pAdapter->ScanTab.BssEntry[i].AuthMode));
 		// Rssi
@@ -1869,9 +1869,9 @@ VOID RTMPIoctlGetSiteSurvey(
 		else if (wireless_mode == Ndis802_11OFDM24)
 			sprintf(msg+strlen(msg),"%-7s", "11b/g");
 		else if (wireless_mode == Ndis802_11OFDM24_N)
-			sprintf(msg+strlen(msg),"%-7s", "11b/g/n");
+			sprintf(msg+strlen(msg),"%-8s", "11b/g/n");
 		else
-			sprintf(msg+strlen(msg),"%-7s", "unknow");
+			sprintf(msg+strlen(msg),"%-8s", "unknown");
 		//Network Type
 		if (pAdapter->ScanTab.BssEntry[i].BssType == BSS_ADHOC)
 			sprintf(msg+strlen(msg),"%-3s", " Ad");
@@ -2727,7 +2727,7 @@ PCHAR   RTMPGetRalinkAuthModeStr(
 		case Ndis802_11AuthModeWPANone:
 			return "WPANONE";
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 	}
 }

@@ -2751,7 +2751,7 @@ PCHAR   RTMPGetRalinkEncryModeStr(
 			return "TKIPAES";
 #if !defined(RT2860) && !defined(RT30xx)
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 #endif
 	}
 }
@@ -2834,7 +2834,7 @@ INT	Show_WirelessMode_Proc(
 			sprintf(pBuf, "\t11N only with 5G");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->CommonCfg.PhyMode);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->CommonCfg.PhyMode);
 			break;
 	}
 	return 0;
@@ -2865,7 +2865,7 @@ INT	Show_TxPreamble_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.TxPreamble);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.TxPreamble);
 			break;
 	}

@@ -2904,7 +2904,7 @@ INT	Show_BGProtection_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.UseBGProtection);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.UseBGProtection);
 			break;
 	}
 	return 0;
@@ -2962,7 +2962,7 @@ INT	Show_HtGi_Proc(
 			sprintf(pBuf, "\tGI_800");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
 			break;
 	}
 	return 0;
@@ -2981,7 +2981,7 @@ INT	Show_HtOpMode_Proc(
 			sprintf(pBuf, "\tMM");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
 			break;
 	}
 	return 0;
@@ -3000,7 +3000,7 @@ INT	Show_HtExtcha_Proc(
 			sprintf(pBuf, "\tAbove");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
 			break;
 	}
 	return 0;
@@ -3119,7 +3119,7 @@ INT	Show_NetworkType_Proc(
 			sprintf(pBuf, "\tMonitor");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->StaCfg.BssType);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->StaCfg.BssType);
 			break;
 	}
 	return 0;
@@ -3137,7 +3137,7 @@ INT	Show_AuthMode_Proc(
 		(AuthMode <= Ndis802_11AuthModeWPA1PSKWPA2PSK))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkAuthModeStr(AuthMode));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", AuthMode);
+		sprintf(pBuf, "\tUnknown Value(%d)", AuthMode);

 	return 0;
 }
@@ -3154,7 +3154,7 @@ INT	Show_EncrypType_Proc(
 		(WepStatus <= Ndis802_11Encryption4KeyAbsent))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkEncryModeStr(WepStatus));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", WepStatus);
+		sprintf(pBuf, "\tUnknown Value(%d)", WepStatus);

 	return 0;
 }
diff --git a/drivers/staging/rt2860/common/mlme.c
b/drivers/staging/rt2860/common/mlme.c
index 61a2a4e..63f8498 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -1632,14 +1632,14 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2S;
 					*pTableSize = RateSwitchTable11N2S[0];
 					*pInitTxRateIdx = RateSwitchTable11N2S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
2S AP \n"));
 				}
 			}
 			else
@@ -1649,18 +1649,18 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2SForABand;
 					*pTableSize = RateSwitchTable11N2SForABand[0];
 					*pInitTxRateIdx = RateSwitchTable11N2SForABand[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
2S AP \n"));
 				}
 			}

-			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode (SupRateLen=%d,
ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
+			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode (SupRateLen=%d,
ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
 				pAd->StaActive.SupRateLen, pAd->StaActive.ExtRateLen,
pAd->StaActive.SupportedPhyInfo.MCSSet[0],
pAd->StaActive.SupportedPhyInfo.MCSSet[1]));
 		}
 	} while(FALSE);
diff --git a/drivers/staging/rt2860/common/rtmp_init.c
b/drivers/staging/rt2860/common/rtmp_init.c
index 20c2ce2..1b93945 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -2691,7 +2691,7 @@ VOID NICUpdateFifoStaCounters(

 				pEntry->FIFOCount = 0;
 				pEntry->OneSecTxNoRetryOkCount++;
-				// update NoDataIdleCount when sucessful send packet to STA.
+				// update NoDataIdleCount when successful send packet to STA.
 				pEntry->NoDataIdleCount = 0;
 				pEntry->ContinueTxFailCnt = 0;
 			}
@@ -3344,7 +3344,7 @@ VOID	UserCfgInit(
 	pAd->CommonCfg.TxPower = 100; //mW
 	pAd->CommonCfg.TxPowerPercentage = 0xffffffff; // AUTO
 	pAd->CommonCfg.TxPowerDefault = 0xffffffff; // AUTO
-	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long
preamble on TX by defaut
+	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long
preamble on TX by default
 	pAd->CommonCfg.bUseZeroToDisableFragment = FALSE;
 	pAd->CommonCfg.RtsThreshold = 2347;
 	pAd->CommonCfg.FragmentThreshold = 2346;
diff --git a/drivers/staging/rt2860/common/spectrum.c
b/drivers/staging/rt2860/common/spectrum.c
index c658bf3..47cf224 100644
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -1773,7 +1773,7 @@ INT Set_MeasureReq_Proc(
 				MeasureReqType = simple_strtol(thisChar, 0, 16);
 				if (MeasureReqType > 3)
 				{
-					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n",
__func__, MeasureReqType));
+					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown MeasureReqType(%d)\n",
__func__, MeasureReqType));
 					return TRUE;
 				}
 				break;
@@ -1788,7 +1788,7 @@ INT Set_MeasureReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d
MeasureCh=%d\n", __func__, Aid, MeasureReqType, MeasureCh));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}

@@ -1816,7 +1816,7 @@ INT Set_TpcReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __func__, Aid));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}

diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 90fd40f..28a171d 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -3012,7 +3012,7 @@ typedef struct _RX_BLK_
 #define LENGTH_ARALINK_SUBFRAMEHEAD	14
 #define LENGTH_ARALINK_HEADER_FIELD	 2

-#define TX_UNKOWN_FRAME			0x00
+#define TX_UNKNOWN_FRAME		0x00
 #define TX_MCAST_FRAME			0x01
 #define TX_LEGACY_FRAME			0x02
 #define TX_AMPDU_FRAME			0x04
diff --git a/drivers/staging/rt2860/sta/connect.c
b/drivers/staging/rt2860/sta/connect.c
index 7bc75ab..e69e692 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -58,8 +58,8 @@ UCHAR	CipherSuiteWpaNoneAes[] = {
 		};
 UCHAR	CipherSuiteWpaNoneAesLen = (sizeof(CipherSuiteWpaNoneAes) /
sizeof(UCHAR));

-// The following MACRO is called after 1. starting an new IBSS, 2.
succesfully JOIN an IBSS,
-// or 3. succesfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
+// The following MACRO is called after 1. starting an new IBSS, 2.
successfully JOIN an IBSS,
+// or 3. successfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
 // All settings successfuly negotiated furing MLME state machines
become final settings
 // and are copied to pAd->StaActive
 #define COPY_SETTINGS_FROM_MLME_AUX_TO_ACTIVE_CFG(_pAd)
                  \
@@ -1423,7 +1423,7 @@ VOID LinkUp(
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
 			else
             {
-                DBGPRINT(RT_DEBUG_TRACE, ("Unknow Cipher (=%d), set
Cipher to AES\n", pAd->StaCfg.PairCipher));
+                DBGPRINT(RT_DEBUG_TRACE, ("Unknown Cipher (=%d), set
Cipher to AES\n", pAd->StaCfg.PairCipher));
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
             }

diff --git a/drivers/staging/rt2860/sta/rtmp_data.c
b/drivers/staging/rt2860/sta/rtmp_data.c
index f751ab6..6df1fe2 100644
--- a/drivers/staging/rt2860/sta/rtmp_data.c
+++ b/drivers/staging/rt2860/sta/rtmp_data.c
@@ -898,7 +898,7 @@ Arguments:
 	pPacket 	Pointer to send packet

 Return Value:
-	NDIS_STATUS_SUCCESS			If succes to queue the packet into TxSwQueue.
+	NDIS_STATUS_SUCCESS			If success to queue the packet into TxSwQueue.
 	NDIS_STATUS_FAILURE			If failed to do en-queue.

 Note:
diff --git a/drivers/staging/rt2860/sta/wpa.c b/drivers/staging/rt2860/sta/wpa.c
index 8c34e39..dc3e6e2 100644
--- a/drivers/staging/rt2860/sta/wpa.c
+++ b/drivers/staging/rt2860/sta/wpa.c
@@ -276,7 +276,7 @@ VOID WpaEAPOLKeyAction(
 			DBGPRINT(RT_DEBUG_TRACE, ("Receive EAPOL Key Group Message 1\n"));
 		}

-		// We will assume link is up (assoc suceess and port not secured).
+		// We will assume link is up (assoc success and port not secured).
 		// All state has to be able to process message from previous state
 		switch(pAd->StaCfg.WpaState)
 		{
@@ -366,7 +366,7 @@ VOID WpaEAPOLKeyAction(
 			DBGPRINT(RT_DEBUG_TRACE, ("Receive EAPOL Key Group Message 1\n"));
 		}

-		// We will assume link is up (assoc suceess and port not secured).
+		// We will assume link is up (assoc success and port not secured).
 		// All state has to be able to process message from previous state
 		switch(pAd->StaCfg.WpaState)
 		{
diff --git a/drivers/staging/rt2860/sta_ioctl.c
b/drivers/staging/rt2860/sta_ioctl.c
index c0e0425..29596f2 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -1835,7 +1835,7 @@ rt_private_show(struct net_device *dev, struct
iw_request_info *info,
 			}
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n",
__func__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknown subcmd = %d\n",
__func__, subcmd));
             break;
     }

@@ -1891,7 +1891,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __func__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknown Command\n", __func__));
 			break;
 	}

@@ -2464,7 +2464,7 @@ int rt_ioctl_siwpmksa(struct net_device *dev,
 			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - IW_PMKSA_ADD\n"));
 			break;
 		default:
-			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknow Command!!\n"));
+			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknown Command!!\n"));
 			break;
 	}

diff --git a/drivers/staging/rt2870/common/rtusb_bulk.c
b/drivers/staging/rt2870/common/rtusb_bulk.c
index a4244b5..b579292 100644
--- a/drivers/staging/rt2870/common/rtusb_bulk.c
+++ b/drivers/staging/rt2870/common/rtusb_bulk.c
@@ -290,7 +290,7 @@ VOID	RTUSBBulkOutDataPacket(
 			else if (((pAd->BulkOutMaxPacketSize < 512) &&
((ThisBulkSize&0xfffff800) != 0) ) /*|| ( (ThisBulkSize != 0)  &&
(pTxWI->AMPDU == 0))*/)
 			{
 				// For USB 1.1 or peer which didn't support AMPDU, limit the BulkOut size.
-				// For performence in b/g mode, now just check for USB 1.1 and
didn't care about the APMDU or not! 2008/06/04.
+				// For performance in b/g mode, now just check for USB 1.1 and
didn't care about the APMDU or not! 2008/06/04.
 				pHTTXContext->ENextBulkOutPosition = TmpBulkEndPos;
 				break;
 			}
@@ -305,7 +305,7 @@ VOID	RTUSBBulkOutDataPacket(
 			}
 			else if (((pAd->BulkOutMaxPacketSize < 512) &&
((ThisBulkSize&0xfffff800) != 0) ) /*|| ( (ThisBulkSize != 0)  &&
(pTxWI->AMPDU == 0))*/)
 			{	// For USB 1.1 or peer which didn't support AMPDU, limit the BulkOut size.
-				// For performence in b/g mode, now just check for USB 1.1 and
didn't care about the APMDU or not! 2008/06/04.
+				// For performance in b/g mode, now just check for USB 1.1 and
didn't care about the APMDU or not! 2008/06/04.
 				pHTTXContext->ENextBulkOutPosition = TmpBulkEndPos;
 				break;
 			}
diff --git a/drivers/staging/rt3090/common/cmm_data.c
b/drivers/staging/rt3090/common/cmm_data.c
index 6340071..992de77 100644
--- a/drivers/staging/rt3090/common/cmm_data.c
+++ b/drivers/staging/rt3090/common/cmm_data.c
@@ -569,7 +569,7 @@ static UCHAR TxPktClassification(
 	IN RTMP_ADAPTER *pAd,
 	IN PNDIS_PACKET  pPacket)
 {
-	UCHAR			TxFrameType = TX_UNKOWN_FRAME;
+	UCHAR			TxFrameType = TX_UNKNOWN_FRAME;
 	UCHAR			Wcid;
 	MAC_TABLE_ENTRY	*pMacEntry = NULL;
 #ifdef DOT11_N_SUPPORT
@@ -1159,7 +1159,7 @@ VOID RTMPWriteTxWI(
 	pTxWI->txop= Txopmode;

 	pTxWI->NSEQ = NSeq;
-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 #ifdef DOT11_N_SUPPORT
 	BASize = pAd->CommonCfg.TxBASize;
 	if (pAd->MACVersion == 0x28720200)
@@ -1283,7 +1283,7 @@ VOID RTMPWriteTxWI_Data(
 #endif // DOT11N_DRAFT3 //
 	pTxWI->AMPDU	= ((pTxBlk->TxFrameType == TX_AMPDU_FRAME) ? TRUE : FALSE);

-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 	BASize = pAd->CommonCfg.TxBASize;
 	if((pTxBlk->TxFrameType == TX_AMPDU_FRAME) && (pMacEntry))
 	{
diff --git a/drivers/staging/rt3090/common/cmm_info.c
b/drivers/staging/rt3090/common/cmm_info.c
index 3e51e98..743a1d6 100644
--- a/drivers/staging/rt3090/common/cmm_info.c
+++ b/drivers/staging/rt3090/common/cmm_info.c
@@ -1948,7 +1948,7 @@ PSTRING GetEncryptType(CHAR enc)
 	if(enc == Ndis802_11Encryption4Enabled)
 	return "TKIPAES";
     else
-	return "UNKNOW";
+	return "UNKNOWN";
 }

 PSTRING GetAuthMode(CHAR auth)
@@ -1974,7 +1974,7 @@ PSTRING GetAuthMode(CHAR auth)
 	if(auth == Ndis802_11AuthModeWPA1PSKWPA2PSK)
 	return "WPA1PSKWPA2PSK";

-	return "UNKNOW";
+	return "UNKNOWN";
 }


@@ -2146,9 +2146,9 @@ VOID	RTMPCommSiteSurveyData(
 		else if (wireless_mode == Ndis802_11OFDM24)
 			sprintf(msg+strlen(msg),"%-7s", "11b/g");
 		else if (wireless_mode == Ndis802_11OFDM24_N)
-			sprintf(msg+strlen(msg),"%-7s", "11b/g/n");
+			sprintf(msg+strlen(msg),"%-8s", "11b/g/n");
 		else
-			sprintf(msg+strlen(msg),"%-7s", "unknow");
+			sprintf(msg+strlen(msg),"%-8s", "unknown");
 		//Network Type
 		if (pBss->BssType == BSS_ADHOC)
 			sprintf(msg+strlen(msg),"%-3s", " Ad");
@@ -3172,7 +3172,7 @@ PSTRING RTMPGetRalinkAuthModeStr(
 		case Ndis802_11AuthModeWPANone:
 			return "WPANONE";
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 	}
 }

@@ -3192,7 +3192,7 @@ PSTRING RTMPGetRalinkEncryModeStr(
         case Ndis802_11Encryption4Enabled:
 			return "TKIPAES";
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 	}
 }

@@ -3280,7 +3280,7 @@ INT	Show_WirelessMode_Proc(
 			break;
 #endif // DOT11_N_SUPPORT //
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->CommonCfg.PhyMode);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->CommonCfg.PhyMode);
 			break;
 	}
 	return 0;
@@ -3311,7 +3311,7 @@ INT	Show_TxPreamble_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.TxPreamble);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.TxPreamble);
 			break;
 	}

@@ -3350,7 +3350,7 @@ INT	Show_BGProtection_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.UseBGProtection);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.UseBGProtection);
 			break;
 	}
 	return 0;
@@ -3413,7 +3413,7 @@ INT	Show_HtGi_Proc(
 			sprintf(pBuf, "\tGI_800");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
 			break;
 	}
 	return 0;
@@ -3432,7 +3432,7 @@ INT	Show_HtOpMode_Proc(
 			sprintf(pBuf, "\tMM");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
 			break;
 	}
 	return 0;
@@ -3451,7 +3451,7 @@ INT	Show_HtExtcha_Proc(
 			sprintf(pBuf, "\tAbove");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
 			break;
 	}
 	return 0;
@@ -3576,7 +3576,7 @@ INT	Show_NetworkType_Proc(
 			sprintf(pBuf, "\tMonitor");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->StaCfg.BssType);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->StaCfg.BssType);
 			break;
 	}
 	return 0;
@@ -3600,7 +3600,7 @@ INT	Show_AuthMode_Proc(
 		(AuthMode <= Ndis802_11AuthModeWPA1PSKWPA2PSK))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkAuthModeStr(AuthMode));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", AuthMode);
+		sprintf(pBuf, "\tUnknown Value(%d)", AuthMode);

 	return 0;
 }
@@ -3620,7 +3620,7 @@ INT	Show_EncrypType_Proc(
 		(WepStatus <= Ndis802_11Encryption4KeyAbsent))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkEncryModeStr(WepStatus));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", WepStatus);
+		sprintf(pBuf, "\tUnknown Value(%d)", WepStatus);

 	return 0;
 }
diff --git a/drivers/staging/rt3090/common/igmp_snoop.c
b/drivers/staging/rt3090/common/igmp_snoop.c
index 680658f..844bdc7 100644
--- a/drivers/staging/rt3090/common/igmp_snoop.c
+++ b/drivers/staging/rt3090/common/igmp_snoop.c
@@ -594,7 +594,7 @@ VOID IGMPSnooping(
 			break;

 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("unknow IGMP Type=%d\n", IgmpVerType));
+			DBGPRINT(RT_DEBUG_TRACE, ("unknown IGMP Type=%d\n", IgmpVerType));
 			break;
 		}
 	}
@@ -1353,7 +1353,7 @@ VOID MLDSnooping(
 				break;

 			default:
-				DBGPRINT(RT_DEBUG_TRACE, ("unknow MLD Type=%d\n", MldType));
+				DBGPRINT(RT_DEBUG_TRACE, ("unknown MLD Type=%d\n", MldType));
 				break;
 		}
 	}
diff --git a/drivers/staging/rt3090/common/mlme.c
b/drivers/staging/rt3090/common/mlme.c
index 1613c04..14966b0 100644
--- a/drivers/staging/rt3090/common/mlme.c
+++ b/drivers/staging/rt3090/common/mlme.c
@@ -1253,14 +1253,14 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2S;
 					*pTableSize = RateSwitchTable11N2S[0];
 					*pInitTxRateIdx = RateSwitchTable11N2S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
2S AP \n"));
 				}
 			}
 			else
@@ -1270,18 +1270,18 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2SForABand;
 					*pTableSize = RateSwitchTable11N2SForABand[0];
 					*pInitTxRateIdx = RateSwitchTable11N2SForABand[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
2S AP \n"));
 				}
 			}
 #endif // DOT11_N_SUPPORT //
-			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode (SupRateLen=%d,
ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
+			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode (SupRateLen=%d,
ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
 				pAd->StaActive.SupRateLen, pAd->StaActive.ExtRateLen,
pAd->StaActive.SupportedPhyInfo.MCSSet[0],
pAd->StaActive.SupportedPhyInfo.MCSSet[1]));
 		}
 #endif // CONFIG_STA_SUPPORT //
diff --git a/drivers/staging/rt3090/common/rtmp_init.c
b/drivers/staging/rt3090/common/rtmp_init.c
index 48b95b7..9c18528 100644
--- a/drivers/staging/rt3090/common/rtmp_init.c
+++ b/drivers/staging/rt3090/common/rtmp_init.c
@@ -2111,7 +2111,7 @@ VOID NICUpdateFifoStaCounters(
 #endif // DOT11_N_SUPPORT //
 				pEntry->FIFOCount = 0;
 				pEntry->OneSecTxNoRetryOkCount++;
-				// update NoDataIdleCount when sucessful send packet to STA.
+				// update NoDataIdleCount when successful send packet to STA.
 				pEntry->NoDataIdleCount = 0;
 				pEntry->ContinueTxFailCnt = 0;
 #ifdef WDS_SUPPORT
@@ -2677,7 +2677,7 @@ VOID	UserCfgInit(
 	pAd->CommonCfg.TxPower = 100; //mW
 	pAd->CommonCfg.TxPowerPercentage = 0xffffffff; // AUTO
 	pAd->CommonCfg.TxPowerDefault = 0xffffffff; // AUTO
-	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long
preamble on TX by defaut
+	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long
preamble on TX by default
 	pAd->CommonCfg.bUseZeroToDisableFragment = FALSE;
 	pAd->CommonCfg.RtsThreshold = 2347;
 	pAd->CommonCfg.FragmentThreshold = 2346;
diff --git a/drivers/staging/rt3090/common/spectrum.c
b/drivers/staging/rt3090/common/spectrum.c
index 12d2125..f0e5508 100644
--- a/drivers/staging/rt3090/common/spectrum.c
+++ b/drivers/staging/rt3090/common/spectrum.c
@@ -780,7 +780,7 @@ VOID InsertChannelRepIE(
 	{
 		if (RegulatoryClass >= USA_REGULATORY_INFO_SIZE)
 		{
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: USA Unknow Requlatory class (%d)\n",
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: USA Unknown Requlatory class (%d)\n",
 						__FUNCTION__, RegulatoryClass));
 			return;
 		}
@@ -792,7 +792,7 @@ VOID InsertChannelRepIE(
 	{
 		if (RegulatoryClass >= JP_REGULATORY_INFO_SIZE)
 		{
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: JP Unknow Requlatory class (%d)\n",
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: JP Unknown Requlatory class (%d)\n",
 						__FUNCTION__, RegulatoryClass));
 			return;
 		}
@@ -802,7 +802,7 @@ VOID InsertChannelRepIE(
 	}
 	else
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: Unknow Country (%s)\n",
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: Unknown Country (%s)\n",
 					__FUNCTION__, pCountry));
 		return;
 	}
@@ -1362,7 +1362,7 @@ VOID NotifyChSwAnnToPeerAPs(
 	if (!((pRA[0] & 0xff) == 0xff)) // is pRA a broadcase address.
 	{
 		INT i;
-		// info neighbor APs that Radar signal found throgh WDS link.
+		// info neighbor APs that Radar signal found through WDS link.
 		for (i = 0; i < MAX_WDS_ENTRY; i++)
 		{
 			if (ValidWdsEntry(pAd, i))
@@ -2138,7 +2138,7 @@ INT Set_MeasureReq_Proc(
 				MeasureReqType = simple_strtol(thisChar, 0, 16);
 				if (MeasureReqType > 3)
 				{
-					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n",
__FUNCTION__, MeasureReqType));
+					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown MeasureReqType(%d)\n",
__FUNCTION__, MeasureReqType));
 					goto END_OF_MEASURE_REQ;
 				}
 				break;
@@ -2153,7 +2153,7 @@ INT Set_MeasureReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d
MeasureCh=%d\n", __FUNCTION__, Aid, MeasureReqType, MeasureCh));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n",
__FUNCTION__, Aid));
 		goto END_OF_MEASURE_REQ;
 	}

@@ -2209,7 +2209,7 @@ INT Set_TpcReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __FUNCTION__, Aid));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n",
__FUNCTION__, Aid));
 		return TRUE;
 	}

diff --git a/drivers/staging/rt3090/rt_ate.c b/drivers/staging/rt3090/rt_ate.c
index 259aae4..fbc5838 100644
--- a/drivers/staging/rt3090/rt_ate.c
+++ b/drivers/staging/rt3090/rt_ate.c
@@ -3484,7 +3484,7 @@ static VOID ATEWriteTxWI(

 	pTxWI->NSEQ = NSeq;

-	// John tune the performace with Intel Client in 20 MHz performance
+	// John tune the performance with Intel Client in 20 MHz performance
 	if ( BASize >7 )
 		BASize =7;

diff --git a/drivers/staging/rt3090/rtmp.h b/drivers/staging/rt3090/rtmp.h
index 8ef6d0b..7e5ca11 100644
--- a/drivers/staging/rt3090/rtmp.h
+++ b/drivers/staging/rt3090/rtmp.h
@@ -2705,13 +2705,13 @@ typedef struct _RX_BLK_
 /***************************************************************************
   *	Tx Path software control block related data structures
   **************************************************************************/
-#define TX_UNKOWN_FRAME		0x00
-#define TX_MCAST_FRAME			0x01
+#define TX_UNKNOWN_FRAME	0x00
+#define TX_MCAST_FRAME		0x01
 #define TX_LEGACY_FRAME		0x02
 #define TX_AMPDU_FRAME		0x04
 #define TX_AMSDU_FRAME		0x08
 #define TX_RALINK_FRAME		0x10
-#define TX_FRAG_FRAME			0x20
+#define TX_FRAG_FRAME		0x20


 //	Currently the sizeof(TX_BLK) is 148 bytes.
diff --git a/drivers/staging/rt3090/sta/connect.c
b/drivers/staging/rt3090/sta/connect.c
index 4aa35ee..23a9e51 100644
--- a/drivers/staging/rt3090/sta/connect.c
+++ b/drivers/staging/rt3090/sta/connect.c
@@ -60,8 +60,8 @@ UCHAR	CipherSuiteWpaNoneAes[] = {
 		};
 UCHAR	CipherSuiteWpaNoneAesLen = (sizeof(CipherSuiteWpaNoneAes) /
sizeof(UCHAR));

-// The following MACRO is called after 1. starting an new IBSS, 2.
succesfully JOIN an IBSS,
-// or 3. succesfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
+// The following MACRO is called after 1. starting an new IBSS, 2.
successfully JOIN an IBSS,
+// or 3. successfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
 // All settings successfuly negotiated furing MLME state machines
become final settings
 // and are copied to pAd->StaActive
 #define COPY_SETTINGS_FROM_MLME_AUX_TO_ACTIVE_CFG(_pAd)
                  \
@@ -1516,7 +1516,7 @@ VOID LinkUp(
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
 			else
             {
-                DBGPRINT(RT_DEBUG_TRACE, ("Unknow Cipher (=%d), set
Cipher to AES\n", pAd->StaCfg.PairCipher));
+                DBGPRINT(RT_DEBUG_TRACE, ("Unknown Cipher (=%d), set
Cipher to AES\n", pAd->StaCfg.PairCipher));
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
             }

diff --git a/drivers/staging/rt3090/sta/rtmp_data.c
b/drivers/staging/rt3090/sta/rtmp_data.c
index 5591364..c1b83be 100644
--- a/drivers/staging/rt3090/sta/rtmp_data.c
+++ b/drivers/staging/rt3090/sta/rtmp_data.c
@@ -981,7 +981,7 @@ Arguments:
 	pPacket		Pointer to send packet

 Return Value:
-	NDIS_STATUS_SUCCESS			If succes to queue the packet into TxSwQueue.
+	NDIS_STATUS_SUCCESS			If success to queue the packet into TxSwQueue.
 	NDIS_STATUS_FAILURE			If failed to do en-queue.

 Note:
diff --git a/drivers/staging/rt3090/sta_ioctl.c
b/drivers/staging/rt3090/sta_ioctl.c
index b8ab84a..bd7c61c 100644
--- a/drivers/staging/rt3090/sta_ioctl.c
+++ b/drivers/staging/rt3090/sta_ioctl.c
@@ -2258,7 +2258,7 @@ rt_private_show(struct net_device *dev, struct
iw_request_info *info,
 			wrq->length = strlen(extra) + 1; // 1: size of '\0'
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n",
__FUNCTION__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknown subcmd = %d\n",
__FUNCTION__, subcmd));
             break;
     }

@@ -2315,7 +2315,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknown Command\n", __FUNCTION__));
 			break;
 	}

@@ -2909,7 +2909,7 @@ int rt_ioctl_siwpmksa(struct net_device *dev,
 			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - IW_PMKSA_ADD\n"));
 			break;
 		default:
-			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknow Command!!\n"));
+			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknown Command!!\n"));
 			break;
 	}

@@ -5000,7 +5000,7 @@ INT RTMPQueryInformation(
                 // add the most up-to-date h/w raw counters into
software counters
 			    NICUpdateRawCounters(pAd);

-                // Sanity check for calculation of sucessful count
+                // Sanity check for calculation of successful count
                 if
(pAd->WlanCounters.TransmittedFragmentCount.QuadPart <
pAd->WlanCounters.RetryCount.QuadPart)

pAd->WlanCounters.TransmittedFragmentCount.QuadPart =
pAd->WlanCounters.RetryCount.QuadPart;

@@ -7554,4 +7554,5 @@ INT	Set_Antenna_Proc(

 	return TRUE;
 }
-#endif // ANT_DIVERSITY_SUPPORT //
\ No newline at end of file
+#endif // ANT_DIVERSITY_SUPPORT //
+
diff --git a/drivers/staging/rtl8187se/r8180_core.c
b/drivers/staging/rtl8187se/r8180_core.c
index 53e654d..95674cf 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1919,8 +1919,8 @@ rate)
 	/*
 	* This function doesn't require lock because we make
 	* sure it's called with the tx_lock already acquired.
-	* this come from the kernel's hard_xmit callback (trought
-	* the ieee stack, or from the try_wake_queue (again trought
+	* this come from the kernel's hard_xmit callback (throught
+	* the ieee stack, or from the try_wake_queue (again throught
 	* the ieee stack.
 	*/
 	priority = AC2Q(skb->priority);
@@ -4144,7 +4144,7 @@ void rtl8180_tx_isr(struct net_device *dev, int
pri,short error)
 		}

 	/* we check all the descriptors between the head and the nic,
-	 * but not the currenly pointed by the nic (the next to be txed)
+	 * but not the currently pointed by the nic (the next to be txed)
 	 * and the previous of the pointed (might be in process ??)
 	*/
 	offs = (nic - nicbegin);
diff --git a/drivers/staging/rtl8187se/r8180_dm.c
b/drivers/staging/rtl8187se/r8180_dm.c
index b6eeeec..9acfbcd 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -36,7 +36,7 @@ bool CheckHighPower(struct net_device *dev)
 //
 //	Note:
 //		The reason why we udpate Tx power level here instead of DoRxHighPower()
-//		is the number of IO to change Tx power is much more than chane TR switch
+//		is the number of IO to change Tx power is much more than channel TR switch
 //		and they are related to OFDM and MAC registers.
 //		So, we don't want to update it so frequently in per-Rx packet base.
 //
@@ -1326,7 +1326,7 @@ SetAntenna8185(
 			break;

 		default:
-			printk("SetAntenna8185: unkown RFChipID(%d)\n", priv->rf_chip);
+			printk("SetAntenna8185: unknown RFChipID(%d)\n", priv->rf_chip);
 			break;
 		}
 		break;
@@ -1346,13 +1346,13 @@ SetAntenna8185(
 			break;

 		default:
-			printk("SetAntenna8185: unkown RFChipID(%d)\n", priv->rf_chip);
+			printk("SetAntenna8185: unknown RFChipID(%d)\n", priv->rf_chip);
 			break;
 		}
 		break;

 	default:
-		printk("SetAntenna8185: unkown u1bAntennaIndex(%d)\n", u1bAntennaIndex);
+		printk("SetAntenna8185: unknown u1bAntennaIndex(%d)\n", u1bAntennaIndex);
 		break;
 	}

diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index b648751..60ee3bc 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -1058,7 +1058,7 @@ bool SetZebraRFPowerState8185(struct net_device *dev,
 			break;
 		default:
 			bResult = false;
-			printk("SetZebraRFPowerState8185(): unknow state to set:
0x%X!!!\n", eRFPowerState);
+			printk("SetZebraRFPowerState8185(): unknown state to set:
0x%X!!!\n", eRFPowerState);
 			break;
 		}
 		break;
diff --git a/drivers/staging/rtl8187se/r8185b_init.c
b/drivers/staging/rtl8187se/r8185b_init.c
index cd07059..bdb66d8 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -2493,8 +2493,8 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	PhyConfig8185(dev);

 	// We assume RegWirelessMode has already been initialized before,
-	// however, we has to validate the wireless mode here and provide a reasonble
-	// initialized value if necessary. 2005.01.13, by rcnjko.
+	// however, we has to validate the wireless mode here and provide a
+	// reasonable initialized value if necessary. 2005.01.13, by rcnjko.
 	SupportedWirelessMode = GetSupportedWirelessMode8185(dev);
 	if(	(ieee->mode != WIRELESS_MODE_B) &&
 		(ieee->mode != WIRELESS_MODE_G) &&
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
index 16256a3..54ce8d7 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -164,7 +164,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
  	ieee->privacy_invoked = 0;
  	ieee->ieee802_1x = 1;
 	ieee->raw_tx = 0;
-	//ieee->hwsec_support = 1; //defalt support hw security. //use
module_param instead.
+	//ieee->hwsec_support = 1; //default support hw security. //use
module_param instead.
 	ieee->hwsec_active = 0; //disable hwsec, switch it on when necessary.

 	ieee80211_softmac_init(ieee);
diff --git a/drivers/staging/rtl8192e/r8190_rtl8256.c
b/drivers/staging/rtl8192e/r8190_rtl8256.c
index 0eaee3a..3d67fbb 100644
--- a/drivers/staging/rtl8192e/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192e/r8190_rtl8256.c
@@ -629,7 +629,7 @@ SetRFPowerState8190(

 			default:
 					bResult = false;
-					RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknow state to set:
0x%X!!!\n", eRFPowerState);
+					RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknown state to set:
0x%X!!!\n", eRFPowerState);
 					break;
 		}

diff --git a/drivers/staging/rtl8192e/r8192E_core.c
b/drivers/staging/rtl8192e/r8192E_core.c
index b0802a7..ff8fe7e 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -1041,7 +1041,7 @@ static void rtl8192_tx_isr(struct net_device
*dev, int prio)
         tx_desc_819x_pci *entry = &ring->desc[ring->idx];
         struct sk_buff *skb;

-        /* beacon packet will only use the first descriptor defautly,
+        /* beacon packet will only use the first descriptor defaultly,
          * and the OWN may not be cleared by the hardware
          * */
         if(prio != BEACON_QUEUE) {
@@ -2562,7 +2562,7 @@ static void rtl8192_read_eeprom_info(struct
net_device* dev)
 		priv->bTXPowerDataReadFromEEPORM = false;
 	}

-	// 2007/11/15 MH 8190PCI Default=2T4R, 8192PCIE dafault=1T2R
+	// 2007/11/15 MH 8190PCI Default=2T4R, 8192PCIE default=1T2R
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;

 	if(priv->card_8192_version > VERSION_8190_BD)
@@ -3554,7 +3554,7 @@ void rtl8192_prepare_beacon(struct r8192_priv *priv)
 	//spin_lock_irqsave(&priv->tx_lock,flags);
 	/* prepare misc info for the beacon xmit */
 	tcb_desc->queue_index = BEACON_QUEUE;
-	/* IBSS does not support HT yet, use 1M defautly */
+	/* IBSS does not support HT yet, use 1M defaultly */
 	tcb_desc->data_rate = 2;
 	tcb_desc->RATRIndex = 7;
 	tcb_desc->bTxDisableRateFallBack = 1;
diff --git a/drivers/staging/rtl8192e/r8192E_dm.c
b/drivers/staging/rtl8192e/r8192E_dm.c
index bf87632..23afca4 100644
--- a/drivers/staging/rtl8192e/r8192E_dm.c
+++ b/drivers/staging/rtl8192e/r8192E_dm.c
@@ -571,7 +571,7 @@ static u32 OFDMSwingTable[OFDM_Table_Length] = {
 	0x5a400169,	// 3, +3db
 	0x50800142,	// 4, +2db
 	0x47c0011f,	// 5, +1db
-	0x40000100,	// 6, +0db ===> default, upper for higher temprature,
lower for low temprature
+	0x40000100,	// 6, +0db ===> default, upper for higher temperature,
lower for low temperature
 	0x390000e4,	// 7, -1db
 	0x32c000cb,	// 8, -2db
 	0x2d4000b5,	// 9, -3db
@@ -932,14 +932,14 @@ static void
dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	RT_TRACE(COMP_POWER_TRACKING, "Readback ThermalMeterA = %d \n", tmpRegA);
 	if(tmpRegA < 3 || tmpRegA > 13)
 		return;
-	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temprature
+	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temperature
 		tmpRegA = 12;
 	RT_TRACE(COMP_POWER_TRACKING, "Valid ThermalMeterA = %d \n", tmpRegA);
 	priv->ThermalMeter[0] = ThermalMeterVal;	//We use fixed value by
Bryant's suggestion
 	priv->ThermalMeter[1] = ThermalMeterVal;	//We use fixed value by
Bryant's suggestion

-	//Get current RF-A temprature index
-	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temprature
+	//Get current RF-A temperature index
+	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temperature
 	{
 		tmpOFDMindex = tmpCCK20Mindex = 6+(priv->ThermalMeter[0]-(u8)tmpRegA);
 		tmpCCK40Mindex = tmpCCK20Mindex - 6;
@@ -953,7 +953,7 @@ static void
dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	else
 	{
 		tmpval = ((u8)tmpRegA - priv->ThermalMeter[0]);
-		if(tmpval >= 6)								// higher temprature
+		if(tmpval >= 6)								// higher temperature
 			tmpOFDMindex = tmpCCK20Mindex = 0;		// max to +6dB
 		else
 			tmpOFDMindex = tmpCCK20Mindex = 6 - tmpval;
diff --git a/drivers/staging/rtl8192e/r819xE_cmdpkt.c
b/drivers/staging/rtl8192e/r819xE_cmdpkt.c
index d6b7d2f..2aaa4e1 100644
--- a/drivers/staging/rtl8192e/r819xE_cmdpkt.c
+++ b/drivers/staging/rtl8192e/r819xE_cmdpkt.c
@@ -783,7 +783,7 @@ u32 cmpk_message_handle_rx(struct net_device *dev,
struct ieee80211_rx_stats *ps

 			default:

-			        RT_TRACE(COMP_EVENTS,
"---->cmpk_message_handle_rx():unknow CMD Element\n");
+			        RT_TRACE(COMP_EVENTS,
"---->cmpk_message_handle_rx():unknown CMD Element\n");
 				return 1;	/* This is a command packet. */
 		}
 		// 2007/01/22 MH Display received rx command packet info.
diff --git a/drivers/staging/rtl8192e/r819xE_phyreg.h
b/drivers/staging/rtl8192e/r819xE_phyreg.h
index d4a4392..37f0fee 100644
--- a/drivers/staging/rtl8192e/r819xE_phyreg.h
+++ b/drivers/staging/rtl8192e/r819xE_phyreg.h
@@ -294,7 +294,7 @@
 #define bR2RCCAMask               		0x00000f00
 #define bHSSI_R2TDelay            		0xf8000000
 #define bHSSI_T2RDelay            		0xf80000
-#define bContTxHSSI               		0x400     //chane gain at continue Tx
+#define bContTxHSSI               		0x400     //channel gain at continue Tx
 #define bIGFromCCK                		0x200
 #define bAGCAddress               		0x3f
 #define bRxHPTx                   			0x7000
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
index 68dc8fa..a764476 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
@@ -156,7 +156,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
  	ieee->privacy_invoked = 0;
  	ieee->ieee802_1x = 1;
 	ieee->raw_tx = 0;
-	//ieee->hwsec_support = 1; //defalt support hw security. //use
module_param instead.
+	//ieee->hwsec_support = 1; //default support hw security. //use
module_param instead.
 	ieee->hwsec_active = 0; //disable hwsec, switch it on when necessary.

 	ieee80211_softmac_init(ieee);
diff --git a/drivers/staging/rtl8192su/r8192S_phy.c
b/drivers/staging/rtl8192su/r8192S_phy.c
index 2c111d7..77ab026 100644
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -1728,7 +1728,7 @@ static bool phy_SetRFPowerState8192SU(struct
net_device* dev,RT_RF_POWER_STATE e

 			default:
 				bResult = FALSE;
-				//RT_ASSERT(FALSE, ("phy_SetRFPowerState8192SU(): unknow state to
set: 0x%X!!!\n", eRFPowerState));
+				//RT_ASSERT(FALSE, ("phy_SetRFPowerState8192SU(): unknown state
to set: 0x%X!!!\n", eRFPowerState));
 				break;
 		}
 		break;
@@ -2711,7 +2711,7 @@ u8 rtl8192_phy_SwChnl(struct net_device* dev, u8 channel)
 // However, this procedure is performed synchronously  which should
be running under
 // passive level.
 //
-//not understant it
+//not understand it
 void PHY_SwChnlPhy8192S(	// Only called during initialize
 	struct net_device* dev,
 	u8		channel
diff --git a/drivers/staging/rtl8192su/r8192S_phyreg.h
b/drivers/staging/rtl8192su/r8192S_phyreg.h
index 96c7cfa..1584378 100644
--- a/drivers/staging/rtl8192su/r8192S_phyreg.h
+++ b/drivers/staging/rtl8192su/r8192S_phyreg.h
@@ -453,7 +453,7 @@
 #define		bR2RCCAMask               			0x00000f00
 #define		bHSSI_R2TDelay            		0xf8000000
 #define		bHSSI_T2RDelay            		0xf80000
-#define		bContTxHSSI               			0x400     //chane gain at continue Tx
+#define		bContTxHSSI               			0x400     //channel gain at continue Tx
 #define		bIGFromCCK                			0x200
 #define		bAGCAddress               			0x3f
 #define		bRxHPTx                   			0x7000
diff --git a/drivers/staging/rtl8192su/r8192U_dm.c
b/drivers/staging/rtl8192su/r8192U_dm.c
index 5358ae8..7891e96 100644
--- a/drivers/staging/rtl8192su/r8192U_dm.c
+++ b/drivers/staging/rtl8192su/r8192U_dm.c
@@ -593,7 +593,7 @@ static u32 OFDMSwingTable[OFDM_Table_Length] = {
 	0x5a400169,	// 3, +3db
 	0x50800142,	// 4, +2db
 	0x47c0011f,	// 5, +1db
-	0x40000100,	// 6, +0db ===> default, upper for higher temprature,
lower for low temprature
+	0x40000100,	// 6, +0db ===> default, upper for higher temperature,
lower for low temperature
 	0x390000e4,	// 7, -1db
 	0x32c000cb,	// 8, -2db
 	0x2d4000b5,	// 9, -3db
@@ -912,14 +912,14 @@ static void
dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	RT_TRACE(COMP_POWER_TRACKING, "Readback ThermalMeterA = %d \n", tmpRegA);
 	if(tmpRegA < 3 || tmpRegA > 13)
 		return;
-	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temprature
+	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temperature
 		tmpRegA = 12;
 	RT_TRACE(COMP_POWER_TRACKING, "Valid ThermalMeterA = %d \n", tmpRegA);
 	priv->ThermalMeter[0] = ThermalMeterVal;	//We use fixed value by
Bryant's suggestion
 	priv->ThermalMeter[1] = ThermalMeterVal;	//We use fixed value by
Bryant's suggestion

-	//Get current RF-A temprature index
-	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temprature
+	//Get current RF-A temperature index
+	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temperature
 	{
 		tmpOFDMindex = tmpCCK20Mindex = 6+(priv->ThermalMeter[0]-(u8)tmpRegA);
 		tmpCCK40Mindex = tmpCCK20Mindex - 6;
@@ -933,7 +933,7 @@ static void
dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	else
 	{
 		tmpval = ((u8)tmpRegA - priv->ThermalMeter[0]);
-		if(tmpval >= 6)								// higher temprature
+		if(tmpval >= 6)								// higher temperature
 			tmpOFDMindex = tmpCCK20Mindex = 0;		// max to +6dB
 		else
 			tmpOFDMindex = tmpCCK20Mindex = 6 - tmpval;
diff --git a/drivers/staging/rtl8192su/r819xU_cmdpkt.c
b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
index e2ba93e..3ebfe79 100644
--- a/drivers/staging/rtl8192su/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
@@ -697,7 +697,7 @@ cmpk_message_handle_rx(

 			default:

-			        RT_TRACE(COMP_ERR, "---->cmpk_message_handle_rx():unknow
CMD Element\n");
+			        RT_TRACE(COMP_ERR, "---->cmpk_message_handle_rx():unknown
CMD Element\n");
 				return 1;	/* This is a command packet. */
 		}
 		// 2007/01/22 MH Display received rx command packet info.
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index f890a16..be19afe 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2447,7 +2447,7 @@ static void sep_configure_dma_burst(struct
sep_device *sep)
 #endif

 /*
-  Function that is activaed on the succesful probe of the SEP device
+  Function that is activaed on the successful probe of the SEP device
 */
 static int __devinit sep_probe(struct pci_dev *pdev, const struct
pci_device_id *ent)
 {
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c
b/drivers/staging/serqt_usb2/serqt_usb2.c
index 52af44c..060e9de 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -929,7 +929,7 @@ static int qt_open(struct tty_struct *tty,
 	dbg(__FILE__ "qt_setuart completed.\n");

 	/*
-	 * Put this here to make it responsive to stty and defauls set by
+	 * Put this here to make it responsive to stty and defaults set by
 	 * the tty layer
 	 */
 	/* FIXME: is this needed? */
diff --git a/drivers/staging/vt6655/device_main.c
b/drivers/staging/vt6655/device_main.c
index 53450b4..0db8d7b 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -661,7 +661,7 @@ else
    if(zonetype!=pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
       printk("zonetype in file[%02x] mismatch with in
EEPROM[%02x]\n",zonetype,pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
    else
-      printk("Read Zonetype file sucess,use default zonetype
setting[%02x]\n",zonetype);
+      printk("Read Zonetype file success,use default zonetype
setting[%02x]\n",zonetype);
  }
  	}
   else
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index fc9cbe0..d9a5fd2 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -159,7 +159,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	 else if(zonetype == 0x02) { //Europe
              sZoneTypeCmd.ZoneType = ZoneType_Europe;
 	 }
-	 else { //Unknow ZoneType
+	 else { //Unknown ZoneType
 	        printk("Error:ZoneType[%x] Unknown ???\n",zonetype);
 	         result = -EFAULT;
 		break;
@@ -692,7 +692,7 @@ if(wpa_Result.authenticated==TRUE) {
      wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, pItemSSID->abySSID);
    }
    #endif
-         pDevice->fWPA_Authened = TRUE;           //is sucessful peer
to wpa_Result.authenticated?
+         pDevice->fWPA_Authened = TRUE;           //is successful
peer to wpa_Result.authenticated?
 }

         //printk("get private wpa_supplicant announce WPA SM\n");
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index 69e04f7..2aa2b91 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -325,10 +325,10 @@ typedef struct tagSStatCounter {
    #ifdef Calcu_LinkQual
        //Tx count:
     ULONG TxNoRetryOkCount;         //success tx no retry !
-    ULONG TxRetryOkCount;              //sucess tx but retry !
+    ULONG TxRetryOkCount;              //success tx but retry !
     ULONG TxFailCount;                      //fail tx ?
       //Rx count:
-    ULONG RxOkCnt;                          //sucess rx !
+    ULONG RxOkCnt;                          //success rx !
     ULONG RxFcsErrCnt;                    //fail rx ?
       //statistic
     ULONG SignalStren;
diff --git a/drivers/staging/vt6656/baseband.c
b/drivers/staging/vt6656/baseband.c
index 820a7b8..49f419e 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1041,7 +1041,7 @@ else {
    if(pDevice->config_file.ZoneType !=pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
       printk("zonetype in file[%02x] mismatch with in
EEPROM[%02x]\n",pDevice->config_file.ZoneType,pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
    else
-      printk("Read Zonetype file sucess,use default zonetype
setting[%02x]\n",pDevice->config_file.ZoneType);
+      printk("Read Zonetype file success,use default zonetype
setting[%02x]\n",pDevice->config_file.ZoneType);
  }
 }

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index e49796f..f7136b0 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -19,7 +19,7 @@
  *
  * File: channel.c
  *
- * Purpose: Channel number maping
+ * Purpose: Channel number mapping
  *
  * Author: Lucas Lin
  *
diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index d94131f..6f33005 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -152,7 +152,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	 else if(zonetype == 0x02) { //Europe
              sZoneTypeCmd.ZoneType = ZoneType_Europe;
 	 }
-	 else { //Unknow ZoneType
+	 else { //Unknown ZoneType
 	        printk("Error:ZoneType[%x] Unknown ???\n",zonetype);
 	         result = -EFAULT;
 		break;
@@ -679,7 +679,7 @@ if(wpa_Result.authenticated==TRUE) {
      wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, pItemSSID->abySSID);
    }
    #endif
-         pDevice->fWPA_Authened = TRUE;           //is sucessful peer
to wpa_Result.authenticated?
+         pDevice->fWPA_Authened = TRUE;           //is successful
peer to wpa_Result.authenticated?
 }

         //printk("get private wpa_supplicant announce WPA SM\n");
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index aa8d1a2..b7c6a22 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1724,7 +1724,7 @@ int iwctl_siwauth(struct net_device *dev,
 	case IW_AUTH_WPA_ENABLED:
 		//pDevice->bWPADEVUp = !! wrq->value;
 		//if(pDevice->bWPADEVUp==TRUE)
-		  // printk("iwctl_siwauth:set WPADEV to enable sucessful*******\n");
+		  // printk("iwctl_siwauth:set WPADEV to enable successful*******\n");
 		//else
 		 //  printk("iwctl_siwauth:set WPADEV to enable fail?????\n");
 		break;
diff --git a/drivers/staging/vt6656/main_usb.c
b/drivers/staging/vt6656/main_usb.c
index 7f96bca..fefec79 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1546,7 +1546,7 @@ if(result!=0) {
   return buffer;
 }

-//return --->-1:fail;  >=0:sucessful
+//return --->-1:fail;  >=0:successful
 static int Read_config_file(PSDevice pDevice) {
   int result=0;
   UCHAR      tmpbuffer[100];
diff --git a/drivers/staging/vt6656/mib.h b/drivers/staging/vt6656/mib.h
index b806b4d..ac996d2 100644
--- a/drivers/staging/vt6656/mib.h
+++ b/drivers/staging/vt6656/mib.h
@@ -357,10 +357,10 @@ typedef struct tagSStatCounter {
    #ifdef Calcu_LinkQual
        //Tx count:
     ULONG TxNoRetryOkCount;         //success tx no retry !
-    ULONG TxRetryOkCount;              //sucess tx but retry !
+    ULONG TxRetryOkCount;              //success tx but retry !
     ULONG TxFailCount;                      //fail tx ?
       //Rx count:
-    ULONG RxOkCnt;                          //sucess rx !
+    ULONG RxOkCnt;                          //success rx !
     ULONG RxFcsErrCnt;                    //fail rx ?
       //statistic
     ULONG SignalStren;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 6912344..f0dfcd0 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -1332,7 +1332,7 @@ BSSvSecondTxData(
     }

   spin_lock_irq(&pDevice->lock);
-  //is wap_supplicant running sucessful OR only open && sharekey mode!
+  //is wap_supplicant running successful OR only open && sharekey mode!
   #if 1
   if(((pDevice->bLinkPass ==TRUE)&&(pMgmt->eAuthenMode <
WMAC_AUTH_WPA)) ||  //open && sharekey linking
       (pDevice->fWPA_Authened == TRUE)) {   //wpa linking
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 9df9242..30e49f3 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1958,7 +1958,7 @@ static void uea_dispatch_cmv_e1(struct uea_softc
*sc, struct intr_pkt *intr)
 		goto bad1;

 	/* FIXME : ADI930 reply wrong preambule (func = 2, sub = 2) to
-	 * the first MEMACESS cmv. Ignore it...
+	 * the first MEMACCESS cmv. Ignore it...
 	 */
 	if (cmv->bFunction != dsc->function) {
 		if (UEA_CHIP_VERSION(sc) == ADI930
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index da718e8..e80f1af 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1890,7 +1890,7 @@ static void cancel_async_set_config(struct
usb_device *udev)
  * routine gets around the normal restrictions by using a work thread to
  * submit the change-config request.
  *
- * Returns 0 if the request was succesfully queued, error code otherwise.
+ * Returns 0 if the request was successfully queued, error code otherwise.
  * The caller has no way to know whether the queued request will eventually
  * succeed.
  */
diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index 7953948..4e36578 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -432,7 +432,7 @@ static void acm_disable(struct usb_function *f)
  * @length: size of data
  * Context: irqs blocked, acm->lock held, acm_notify_req non-null
  *
- * Returns zero on sucess or a negative errno.
+ * Returns zero on success or a negative errno.
  *
  * See section 6.3.5 of the CDC 1.1 specification for information
  * about the only notification we issue:  SerialState change.
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 1937d8c..adda120 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -1524,7 +1524,7 @@ static int pxa_udc_get_frame(struct usb_gadget *_gadget)
  * pxa_udc_wakeup - Force udc device out of suspend
  * @_gadget: usb gadget
  *
- * Returns 0 if succesfull, error code otherwise
+ * Returns 0 if successfull, error code otherwise
  */
 static int pxa_udc_wakeup(struct usb_gadget *_gadget)
 {
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index 62a226b..00a2985 100644
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -627,7 +627,7 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd)


 /*
- * Process normal completions(error or sucess) and clean the schedule.
+ * Process normal completions(error or success) and clean the schedule.
  *
  * This is the main path for handing urbs back to drivers. The only other patth
  * is process_del_list(),which unlinks URBs by scanning EDs,instead of scanning
diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index 9ec7fd5..9579cf4 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -111,7 +111,7 @@ struct aes_ccm_b1 {
  *
  * CCM uses Ax blocks to generate a keystream with which the MIC and
  * the message's payload are encoded. A0 always encrypts/decrypts the
- * MIC. Ax (x>0) are used for the sucesive payload blocks.
+ * MIC. Ax (x>0) are used for the successive payload blocks.
  *
  * The x is the counter, and is increased for each block.
  */
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 613a5fc..489b478 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -558,7 +558,7 @@ static void wa_seg_dto_cb(struct urb *urb)
 /*
  * Callback for the segment request
  *
- * If succesful transition state (unless already transitioned or
+ * If successful transition state (unless already transitioned or
  * outbound transfer); otherwise, take a note of the error, mark this
  * segment done and try completion.
  *
@@ -1364,7 +1364,7 @@ segment_aborted:
 /*
  * Callback for the IN data phase
  *
- * If succesful transition state; otherwise, take a note of the
+ * If successful transition state; otherwise, take a note of the
  * error, mark this segment done and try completion.
  *
  * Note we don't access until we are sure that the transfer hasn't
diff --git a/drivers/uwb/i1480/dfu/usb.c b/drivers/uwb/i1480/dfu/usb.c
index c7080d4..0bb665a 100644
--- a/drivers/uwb/i1480/dfu/usb.c
+++ b/drivers/uwb/i1480/dfu/usb.c
@@ -229,7 +229,7 @@ void i1480_usb_neep_cb(struct urb *urb)
  * will verify it.
  *
  * Set i1480->evt_result with the result of getting the event or its
- * size (if succesful).
+ * size (if successful).
  *
  * Delivers the data directly to i1480->evt_buf
  */
diff --git a/drivers/uwb/wlp/txrx.c b/drivers/uwb/wlp/txrx.c
index 86a853b..7350ed6 100644
--- a/drivers/uwb/wlp/txrx.c
+++ b/drivers/uwb/wlp/txrx.c
@@ -282,7 +282,7 @@ EXPORT_SYMBOL_GPL(wlp_receive_frame);
  *         and transmission will be done by the calling function.
  * @dst:   On return this will contain the device address to which the
  *         frame is destined.
- * @returns: 0 on success no tx : WLP header sucessfully applied to skb buffer,
+ * @returns: 0 on success no tx : WLP header successfully applied to
skb buffer,
  *                                calling function can proceed with tx
  *           1 on success with tx : WLP will take over transmission of this
  *                                  frame
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 1fe5379..b380bf4 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -3278,7 +3278,7 @@ static void __devinit aty_init_lcd(struct
atyfb_par *par, u32 bios_base)
 				txtformat = "24 bit interface";
 				break;
 			default:
-				txtformat = "unkown format";
+				txtformat = "unknown format";
 			}
 		} else {
 			switch (format & 7) {
@@ -3301,7 +3301,7 @@ static void __devinit aty_init_lcd(struct
atyfb_par *par, u32 bios_base)
 				txtformat = "262144 colours (FDPI-2 mode)";
 				break;
 			default:
-				txtformat = "unkown format";
+				txtformat = "unknown format";
 			}
 		}
 		PRINTKI("%s%s %s monitor detected: %s\n",
diff --git a/drivers/video/aty/radeonfb.h b/drivers/video/aty/radeonfb.h
index 7351e66..c747660 100644
--- a/drivers/video/aty/radeonfb.h
+++ b/drivers/video/aty/radeonfb.h
@@ -35,7 +35,7 @@
  * Chip families. Must fit in the low 16 bits of a long word
  */
 enum radeon_family {
-	CHIP_FAMILY_UNKNOW,
+	CHIP_FAMILY_UNKNOWN,
 	CHIP_FAMILY_LEGACY,
 	CHIP_FAMILY_RADEON,
 	CHIP_FAMILY_RV100,
diff --git a/drivers/video/backlight/atmel-pwm-bl.c
b/drivers/video/backlight/atmel-pwm-bl.c
index 505c082..2cf7ba5 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -158,7 +158,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 			goto err_free_pwm;
 		}

-		/* Turn display off by defatult. */
+		/* Turn display off by default. */
 		retval = gpio_direction_output(pwmbl->gpio_on,
 				0 ^ pdata->on_active_low);
 		if (retval)
diff --git a/drivers/video/backlight/tosa_lcd.c
b/drivers/video/backlight/tosa_lcd.c
index 50ec17d..fa32b94 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -177,7 +177,7 @@ static int __devinit tosa_lcd_probe(struct spi_device *spi)
 	if (!data)
 		return -ENOMEM;

-	data->is_vga = true; /* defaut to VGA mode */
+	data->is_vga = true; /* default to VGA mode */

 	/*
 	 * bits_per_word cannot be configured in platform data
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index 857b366..6468a29 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -436,7 +436,7 @@ sti_init_glob_cfg(struct sti_struct *sti,
 			    (offs < PCI_BASE_ADDRESS_0 ||
 			     offs > PCI_BASE_ADDRESS_5)) {
 				printk (KERN_WARNING
-					"STI pci region maping for region %d (%02x) can't be mapped\n",
+					"STI pci region mapping for region %d (%02x) can't be mapped\n",
 					i,sti->rm_entry[i]);
 				continue;
 			}
diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index 1a83709..492e6e6 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -701,7 +701,7 @@ static int gbefb_set_par(struct fb_info *info)
 	   blocks of 512x128, 256x128 or 128x128 pixels, respectively for 8bit,
 	   16bit and 32 bit modes (64 kB). They cover the screen with partial
 	   tiles on the right and/or bottom of the screen if needed.
-	   For exemple in 640x480 8 bit mode the mapping is:
+	   For example in 640x480 8 bit mode the mapping is:

 	   <-------- 640 ----->
 	   <---- 512 ----><128|384 offscreen>
diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
index ff43c88..9805483 100644
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -52,7 +52,7 @@
  *
  * 0.1.3 (released 1999-11-02)	added Attila's panning support, code
  *				reorg, hwcursor address page size alignment
- *				(for mmaping both frame buffer and regs),
+ *				(for mmapping both frame buffer and regs),
  *				and my changes to get rid of hardcoded
  *				VGA i/o register locations (uses PCI
  *				configuration info now)
diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index c5c32b6..67b3693 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -467,7 +467,7 @@ static int dvi_get_panel_size_from_DDCv1(void)
 	default:
 		viaparinfo->tmds_setting_info->dvi_panel_size =
 			VIA_RES_1024X768;
-		DEBUG_MSG(KERN_INFO "Unknow panel size max resolution = %d !\
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d !\
 					 set default panel size.\n", max_h);
 		break;
 	}
@@ -534,7 +534,7 @@ static int dvi_get_panel_size_from_DDCv2(void)
 	default:
 		viaparinfo->tmds_setting_info->dvi_panel_size =
 			VIA_RES_1024X768;
-		DEBUG_MSG(KERN_INFO "Unknow panel size max resolution = %d!\
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d!\
 					set default panel size.\n", HSize);
 		break;
 	}
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 381026c..923cc68 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -508,7 +508,7 @@ void coh901327_watchdog_reset(void)
 	 * deactivating the watchdog before it is shut down by it.
 	 *
 	 * NOTE: on future versions of the watchdog, this restriction is
-	 * gone: the watchdog will be reloaded with a defaul value (1 min)
+	 * gone: the watchdog will be reloaded with a default value (1 min)
 	 * instead of last value, and you can conveniently set the watchdog
 	 * timeout to 10ms (value = 1) without any problems.
 	 */
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index b6b3f59..47d7197 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -21,7 +21,7 @@
  *      wd#1 - 2 seconds;
  *      wd#2 - 7.2 ms;
  *  After the expiration of wd#1, it can generate a NMI, SCI, SMI, or
- *  a system RESET and it starts wd#2 that unconditionaly will RESET
+ *  a system RESET and it starts wd#2 that unconditionally will RESET
  *  the system when the counter reaches zero.
  *
  *  14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 3bde56b..5bfb1f2 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -542,7 +542,7 @@ static struct notifier_block wdrtas_notifier = {
 /**
  * wdrtas_get_tokens - reads in RTAS tokens
  *
- * returns 0 on succes, <0 on failure
+ * returns 0 on success, <0 on failure
  *
  * wdrtas_get_tokens reads in the tokens for the RTAS calls used in
  * this watchdog driver. It tolerates, if "get-sensor-state" and
@@ -598,7 +598,7 @@ static void wdrtas_unregister_devs(void)
 /**
  * wdrtas_register_devs - registers the misc dev handlers
  *
- * returns 0 on succes, <0 on failure
+ * returns 0 on success, <0 on failure
  *
  * wdrtas_register_devs registers the watchdog and temperature watchdog
  * misc devs
@@ -630,7 +630,7 @@ static int wdrtas_register_devs(void)
 /**
  * wdrtas_init - init function of the watchdog driver
  *
- * returns 0 on succes, <0 on failure
+ * returns 0 on success, <0 on failure
  *
  * registers the file handlers and the reboot notifier
  */
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b9b3bb5..d15ea17 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -767,7 +767,7 @@ static int load_elf_binary(struct linux_binprm
*bprm, struct pt_regs *regs)
 	
 	current->mm->start_stack = bprm->p;

-	/* Now we do a little grungy work by mmaping the ELF image into
+	/* Now we do a little grungy work by mmapping the ELF image into
 	   the correct location in memory. */
 	for(i = 0, elf_ppnt = elf_phdata;
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
diff --git a/fs/bio.c b/fs/bio.c
index 402cb84..a82f389 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -272,7 +272,7 @@ EXPORT_SYMBOL(bio_init);
  *   for a &struct bio to become free. If a %NULL @bs is passed in, we will
  *   fall back to just using @kmalloc to allocate the required memory.
  *
- *   Note that the caller must set ->bi_destructor on succesful return
+ *   Note that the caller must set ->bi_destructor on successful return
  *   of a bio, to do the appropriate freeing of the bio once the reference
  *   count drops to zero.
  **/
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 2c726b7..6815d2a 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -256,7 +256,7 @@ out:
  * Insert @em into @tree or perform a simple forward/backward merge with
  * existing mappings.  The extent_map struct passed in will be inserted
  * into the tree directly, with an additional reference taken, or a
- * reference dropped if the merge attempt was sucessfull.
+ * reference dropped if the merge attempt was successfull.
  */
 int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em)
diff --git a/fs/cifs/README b/fs/cifs/README
index 79c1a93..a727b7c 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -423,7 +423,7 @@ A partial list of the supported mount options follows:
 		source name to use to represent the client netbios machine
 		name when doing the RFC1001 netbios session initialize.
   direct        Do not do inode data caching on files opened on this mount.
-		This precludes mmaping files on this mount. In some cases
+		This precludes mmapping files on this mount. In some cases
 		with fast networks and little or no caching benefits on the
 		client (e.g. when the application is doing large sequential
 		reads bigger than page size without rereading the same data)
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5d0fde1..4b35f7e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -39,7 +39,7 @@

 /*
  * MAX_REQ is the maximum number of requests that WE will send
- * on one socket concurently. It also matches the most common
+ * on one socket concurrently. It also matches the most common
  * value of max multiplex returned by servers.  We may
  * eventually want to use the negotiated value (in case
  * future servers can handle more) when we are more confident that
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 5e24925..3b861eb 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -917,8 +917,8 @@ undo_setattr:
 /*
  * If dentry->d_inode is null (usually meaning the cached dentry
  * is a negative dentry) then we would attempt a standard SMB delete, but
- * if that fails we can not attempt the fall back mechanisms on EACESS
- * but will return the EACESS to the caller.  Note that the VFS does not call
+ * if that fails we can not attempt the fall back mechanisms on EACCESS
+ * but will return the EACCESS to the caller.  Note that the VFS does not call
  * unlink on negative dentries currently.
  */
 int cifs_unlink(struct inode *dir, struct dentry *dentry)
diff --git a/fs/cifs/smbdes.c b/fs/cifs/smbdes.c
index 224a1f4..b6b6dcb 100644
--- a/fs/cifs/smbdes.c
+++ b/fs/cifs/smbdes.c
@@ -371,7 +371,7 @@ E_P24(unsigned char *p21, const unsigned char *c8,
unsigned char *p24)
 	smbhash(p24 + 16, c8, p21 + 14, 1);
 }

-#if 0 /* currently unsued */
+#if 0 /* currently unused */
 static void
 D_P16(unsigned char *p14, unsigned char *in, unsigned char *out)
 {
diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 16f682e..b540aa5 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -143,7 +143,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(dlm_posix_lock);

-/* Returns failure iff a succesful lock operation should be canceled */
+/* Returns failure iff a successful lock operation should be canceled */
 static int dlm_plock_callback(struct plock_op *op)
 {
 	struct file *file;
diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index f25e70c..f029441 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -177,7 +177,7 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c,
struct jffs2_inode_info *f,
 		spin_unlock(&jffs2_compressor_list_lock);
 		break;
 	default:
-		printk(KERN_ERR "JFFS2: unknow compression mode.\n");
+		printk(KERN_ERR "JFFS2: unknown compression mode.\n");
 	}
  out:
 	if (ret == JFFS2_COMPR_NONE) {
diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index 1a80301..378991c 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -931,7 +931,7 @@ static inline int read_unknown(struct
jffs2_sb_info *c, struct jffs2_raw_node_re
  * Helper function for jffs2_get_inode_nodes().
  * The function detects whether more data should be read and reads it if yes.
  *
- * Returns: 0 on succes;
+ * Returns: 0 on success;
  * 	    negative error code on failure.
  */
 static int read_more(struct jffs2_sb_info *c, struct jffs2_raw_node_ref *ref,
diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index 082e844..4b10788 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -31,7 +31,7 @@
  *   is used to release xattr name/value pair and detach from c->xattrindex.
  * reclaim_xattr_datum(c)
  *   is used to reclaim xattr name/value pairs on the xattr
name/value pair cache when
- *   memory usage by cache is over c->xdatum_mem_threshold.
Currentry, this threshold
+ *   memory usage by cache is over c->xdatum_mem_threshold.
Currently, this threshold
  *   is hard coded as 32KiB.
  * do_verify_xattr_datum(c, xd)
  *   is used to load the xdatum informations without name/value pair
from the medium.
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 93fcb6c..2cfd5f0 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -755,7 +755,7 @@ int dbAlloc(struct inode *ip, s64 hint, s64
nblocks, s64 * results)
 	 * allocation group.
 	 */
 	if ((blkno & (bmp->db_agsize - 1)) == 0)
-		/* check if the AG is currenly being written to.
+		/* check if the AG is currently being written to.
 		 * if so, call dbNextAG() to find a non-busy
 		 * AG with sufficient free space.
 		 */
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 0d58caf..ec8f45f 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -835,7 +835,7 @@ static int ncp_ioctl_need_write(unsigned int cmd)
 	case NCP_IOC_SETROOT:
 		return 0;
 	default:
-		/* unkown IOCTL command, assume write */
+		/* unknown IOCTL command, assume write */
 		return 1;
 	}
 }
diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 9669541..08f7530 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -927,7 +927,7 @@ lock_retry_remap:
 		return 0;

 	ntfs_debug("Failed. Returning error code %s.", err == -EOVERFLOW ?
-			"EOVERFLOW" : (!err ? "EIO" : "unkown error"));
+			"EOVERFLOW" : (!err ? "EIO" : "unknown error"));
 	return err < 0 ? err : -EIO;

 read_err:
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 663c0e3..43179dd 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -399,7 +399,7 @@ static inline void
ntfs_fault_in_pages_readable_iovec(const struct iovec *iov,
  * @cached_page: allocated but as yet unused page
  * @lru_pvec:	lru-buffering pagevec of caller
  *
- * Obtain @nr_pages locked page cache pages from the mapping @maping and
+ * Obtain @nr_pages locked page cache pages from the mapping @mapping and
  * starting at index @index.
  *
  * If a page is newly created, increment its refcount and add it to the
@@ -1281,7 +1281,7 @@ rl_not_mapped_enoent:

 /*
  * Copy as much as we can into the pages and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then clear the pages
+ * were successfully copied.  If a fault is encountered then clear the pages
  * out to (ofs + bytes) and return the number of bytes which were copied.
  */
 static inline size_t ntfs_copy_from_user(struct page **pages,
diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index 89b0298..4dadcdf 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -338,7 +338,7 @@ err_out:
  * copy of the complete multi sector transfer deprotected page.  On failure,
  * *@wrp is undefined.
  *
- * Simillarly, if @lsn is not NULL, on succes *@lsn will be set to the current
+ * Simillarly, if @lsn is not NULL, on success *@lsn will be set to the current
  * logfile lsn according to this restart page.  On failure, *@lsn is undefined.
  *
  * The following error codes are defined:
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 38a42f5..7c7198a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2398,7 +2398,7 @@ static int ocfs2_leftmost_rec_contains(struct
ocfs2_extent_list *el, u32 cpos)
  *
  * The array is assumed to be large enough to hold an entire path (tree depth).
  *
- * Upon succesful return from this function:
+ * Upon successful return from this function:
  *
  * - The 'right_path' array will contain a path to the leaf block
  *   whose range contains e_cpos.
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 83bcaf2..03ccf9a 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2586,7 +2586,7 @@ fail:
 	 * is complete everywhere.  if the target dies while this is
 	 * going on, some nodes could potentially see the target as the
 	 * master, so it is important that my recovery finds the migration
-	 * mle and sets the master to UNKNONWN. */
+	 * mle and sets the master to UNKNOWN. */


 	/* wait for new node to assert master */
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 0d38d67..c5e4a49 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1855,7 +1855,7 @@ int ocfs2_file_lock(struct file *file, int ex,
int trylock)
 		 * outstanding lock request, so a cancel convert is
 		 * required. We intentionally overwrite 'ret' - if the
 		 * cancel fails and the lock was granted, it's easier
-		 * to just bubble sucess back up to the user.
+		 * to just bubble success back up to the user.
 		 */
 		ret = ocfs2_flock_handle_signal(lockres, level);
 	} else if (!ret && (level > lockres->l_level)) {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 54c16b6..bf34c49 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -659,7 +659,7 @@ static int __ocfs2_journal_access(handle_t *handle,

 	default:
 		status = -EINVAL;
-		mlog(ML_ERROR, "Uknown access type!\n");
+		mlog(ML_ERROR, "Unknown access type!\n");
 	}
 	if (!status && ocfs2_meta_ecc(osb) && triggers)
 		jbd2_journal_set_triggers(bh, &triggers->ot_triggers);
diff --git a/fs/omfs/bitmap.c b/fs/omfs/bitmap.c
index e1c0ec0..0822345 100644
--- a/fs/omfs/bitmap.c
+++ b/fs/omfs/bitmap.c
@@ -85,7 +85,7 @@ out:
 }

 /*
- * Tries to allocate exactly one block.  Returns true if sucessful.
+ * Tries to allocate exactly one block.  Returns true if successful.
  */
 int omfs_allocate_block(struct super_block *sb, u64 block)
 {
diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index f94ddf7..868a55e 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -23,7 +23,7 @@
 /*
  * This file implements functions needed to recover from unclean un-mounts.
  * When UBIFS is mounted, it checks a flag on the master node to determine if
- * an un-mount was completed sucessfully. If not, the process of mounting
+ * an un-mount was completed successfully. If not, the process of mounting
  * incorparates additional checking and fixing of on-flash data structures.
  * UBIFS always cleans away all remnants of an unclean un-mount, so that
  * errors do not accumulate. However UBIFS defers recovery if it is mounted
diff --git a/fs/xfs/quota/xfs_dquot.h b/fs/xfs/quota/xfs_dquot.h
index 6533ead..a2c16bc 100644
--- a/fs/xfs/quota/xfs_dquot.h
+++ b/fs/xfs/quota/xfs_dquot.h
@@ -98,7 +98,7 @@ typedef struct xfs_dquot {
 #define dq_flags	q_lists.dqm_flags

 /*
- * Lock hierachy for q_qlock:
+ * Lock hierarchy for q_qlock:
  *	XFS_QLOCK_NORMAL is the implicit default,
  * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
  */
diff --git a/include/linux/chio.h b/include/linux/chio.h
index 519248d..d9bac7f 100644
--- a/include/linux/chio.h
+++ b/include/linux/chio.h
@@ -21,7 +21,7 @@
  *    query vendor-specific element types
  *
  *    accessing elements works by specifing type and unit of the element.
- *    for eample, storage elements are addressed with type = CHET_ST and
+ *    for example, storage elements are addressed with type = CHET_ST and
  *    unit = 0 .. cp_nslots-1
  *
  */
diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
index e5124ce..3402042 100644
--- a/include/linux/mfd/ezx-pcap.h
+++ b/include/linux/mfd/ezx-pcap.h
@@ -45,7 +45,7 @@ void pcap_set_ts_bits(struct pcap_chip *, u32);
 #define PCAP_CLEAR_INTERRUPT_REGISTER	0x01ffffff
 #define PCAP_MASK_ALL_INTERRUPT		0x01ffffff

-/* registers acessible by both pcap ports */
+/* registers accessible by both pcap ports */
 #define PCAP_REG_ISR		0x0	/* Interrupt Status */
 #define PCAP_REG_MSR		0x1	/* Interrupt Mask */
 #define PCAP_REG_PSTAT		0x2	/* Processor Status */
@@ -67,7 +67,7 @@ void pcap_set_ts_bits(struct pcap_chip *, u32);
 #define PCAP_REG_VENDOR_TEST1	0x1e
 #define PCAP_REG_VENDOR_TEST2	0x1f

-/* registers acessible by pcap port 1 only (a1200, e2 & e6) */
+/* registers accessible by pcap port 1 only (a1200, e2 & e6) */
 #define PCAP_REG_INT_SEL	0x3	/* Interrupt Select */
 #define PCAP_REG_SWCTRL		0x4	/* Switching Regulator Control */
 #define PCAP_REG_VREG1		0x5	/* Regulator Bank 1 Control */
diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index 6c0d7cf..4434453 100644
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -30,7 +30,7 @@

 /*
  * use drive write caching -- we need deferred error handling to be
- * able to sucessfully recover with this option (drive will return good
+ * able to successfully recover with this option (drive will return good
  * status as soon as the cdb is validated).
  */
 #if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b59e78c..dfd4745 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -490,7 +490,7 @@ struct v4l2_jpegcompression {
 				 * you do, leave them untouched.
 				 * Inluding less markers will make the
 				 * resulting code smaller, but there will
-				 * be fewer aplications which can read it.
+				 * be fewer applications which can read it.
 				 * The presence of the APP and COM marker
 				 * is influenced by APP_len and COM_len
 				 * ONLY, not by this property! */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 6e5f0e0..ca4789e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -988,7 +988,7 @@ struct sctp_transport {
 	int init_sent_count;

 	/* state       : The current state of this destination,
-	 *             : i.e. SCTP_ACTIVE, SCTP_INACTIVE, SCTP_UNKOWN.
+	 *             : i.e. SCTP_ACTIVE, SCTP_INACTIVE, SCTP_UNKNOWN.
 	 */
 	int state;

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 03a49c7..1827e7f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1260,7 +1260,7 @@ static inline struct sk_buff
*tcp_write_queue_prev(struct sock *sk, struct sk_bu
 	skb_queue_walk_from_safe(&(sk)->sk_write_queue, skb, tmp)

 /* This function calculates a "timeout" which is equivalent to the timeout of a
- * TCP connection after "boundary" unsucessful, exponentially backed-off
+ * TCP connection after "boundary" unsuccessful, exponentially backed-off
  * retransmissions with an initial RTO of TCP_RTO_MIN.
  */
 static inline bool retransmits_timed_out(const struct sock *sk,
diff --git a/include/net/wimax.h b/include/net/wimax.h
index 2af7bf8..3b07f6a 100644
--- a/include/net/wimax.h
+++ b/include/net/wimax.h
@@ -79,7 +79,7 @@
  * drivers have to only report state changes due to external
  * conditions.
  *
- * All API operations are 'atomic', serialized thorough a mutex in the
+ * All API operations are 'atomic', serialized through a mutex in the
  * `struct wimax_dev`.
  *
  * EXPORTING TO USER SPACE THROUGH GENERIC NETLINK
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a69d4ed..b1d0e10 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -420,7 +420,7 @@ static void perf_event_remove_from_context(struct
perf_event *event)
 	if (!task) {
 		/*
 		 * Per cpu events are removed via an smp call and
-		 * the removal is always sucessful.
+		 * the removal is always successful.
 		 */
 		smp_call_function_single(event->cpu,
 					 __perf_event_remove_from_context,
@@ -828,7 +828,7 @@ perf_install_in_context(struct perf_event_context *ctx,
 	if (!task) {
 		/*
 		 * Per cpu events are installed via an smp call and
-		 * the install is always sucessful.
+		 * the install is always successful.
 		 */
 		smp_call_function_single(cpu, __perf_install_in_context,
 					 event, 1);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6e23035..ff8ef5c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -117,7 +117,7 @@ config HEADERS_CHECK
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
 	# This option is on purpose disabled for now.
-	# It will be enabled when we are down to a resonable number
+	# It will be enabled when we are down to a reasonable number
 	# of section mismatch warnings (< 10 for an allyesconfig build)
 	help
 	  The section mismatch analysis checks if there are illegal
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 600f473..7607420 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -299,7 +299,7 @@ static int INIT get_next_block(struct bunzip_data *bd)
 		   again when using them (during symbol decoding).*/
 		base = hufGroup->base-1;
 		limit = hufGroup->limit-1;
-		/* Calculate permute[].  Concurently, initialize
+		/* Calculate permute[].  Concurrently, initialize
 		 * temp[] and limit[]. */
 		pp = 0;
 		for (i = minLen; i <= maxLen; i++) {
diff --git a/mm/filemap.c b/mm/filemap.c
index ef169f3..c3d3506 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1844,7 +1844,7 @@ static size_t __iovec_copy_from_user_inatomic(char *vaddr,

 /*
  * Copy as much as we can into the page and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then return
the number of
+ * were successfully copied.  If a fault is encountered then return
the number of
  * bytes which were copied.
  */
 size_t iov_iter_copy_from_user_atomic(struct page *page,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f99f599..5202299 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -209,7 +209,7 @@ struct mem_cgroup {
 	int	prev_priority;	/* for recording reclaim priority */

 	/*
-	 * While reclaiming in a hiearchy, we cache the last child we
+	 * While reclaiming in a hierarchy, we cache the last child we
 	 * reclaimed from.
 	 */
 	int last_scanned_child;
@@ -2466,7 +2466,7 @@ static int mem_cgroup_hierarchy_write(struct
cgroup *cont, struct cftype *cft,

 	cgroup_lock();
 	/*
-	 * If parent's use_hiearchy is set, we can't make any modifications
+	 * If parent's use_hierarchy is set, we can't make any modifications
 	 * in the child subtrees. If it is unset, then the change can
 	 * occur, provided the current cgroup has no children.
 	 *
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index dacc641..1ac49fe 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -174,7 +174,7 @@ static void kill_procs_ao(struct list_head
*to_kill, int doit, int trapno,
 	list_for_each_entry_safe (tk, next, to_kill, nd) {
 		if (doit) {
 			/*
-			 * In case something went wrong with munmaping
+			 * In case something went wrong with munmapping
 			 * make sure the process doesn't catch the
 			 * signal and then access the memory. Just kill it.
 			 * the signal handlers
diff --git a/net/irda/irlap.c b/net/irda/irlap.c
index 356e65b..783c5f3 100644
--- a/net/irda/irlap.c
+++ b/net/irda/irlap.c
@@ -450,10 +450,10 @@ void irlap_disconnect_request(struct irlap_cb *self)

 	/* Check if we are in the right state for disconnecting */
 	switch (self->state) {
-	case LAP_XMIT_P:        /* FALLTROUGH */
-	case LAP_XMIT_S:        /* FALLTROUGH */
-	case LAP_CONN:          /* FALLTROUGH */
-	case LAP_RESET_WAIT:    /* FALLTROUGH */
+	case LAP_XMIT_P:        /* FALLTHROUGH */
+	case LAP_XMIT_S:        /* FALLTHROUGH */
+	case LAP_CONN:          /* FALLTHROUGH */
+	case LAP_RESET_WAIT:    /* FALLTHROUGH */
 	case LAP_RESET_CHECK:
 		irlap_do_event(self, DISCONNECT_REQUEST, NULL, NULL);
 		break;
@@ -485,9 +485,9 @@ void irlap_disconnect_indication(struct irlap_cb
*self, LAP_REASON reason)
 		IRDA_DEBUG(1, "%s(), Sending reset request!\n", __func__);
 		irlap_do_event(self, RESET_REQUEST, NULL, NULL);
 		break;
-	case LAP_NO_RESPONSE:	   /* FALLTROUGH */
-	case LAP_DISC_INDICATION:  /* FALLTROUGH */
-	case LAP_FOUND_NONE:       /* FALLTROUGH */
+	case LAP_NO_RESPONSE:	   /* FALLTHROUGH */
+	case LAP_DISC_INDICATION:  /* FALLTHROUGH */
+	case LAP_FOUND_NONE:       /* FALLTHROUGH */
 	case LAP_MEDIA_BUSY:
 		irlmp_link_disconnect_indication(self->notify.instance, self,
 						 reason, NULL);
diff --git a/net/irda/irlmp.c b/net/irda/irlmp.c
index 7bf5b91..0e7d8bd 100644
--- a/net/irda/irlmp.c
+++ b/net/irda/irlmp.c
@@ -105,7 +105,7 @@ int __init irlmp_init(void)

 	init_timer(&irlmp->discovery_timer);

-	/* Do discovery every 3 seconds, conditionaly */
+	/* Do discovery every 3 seconds, conditionally */
 	if (sysctl_discovery)
 		irlmp_start_discovery_timer(irlmp,
 					    sysctl_discovery_timeout*HZ);
@@ -1842,7 +1842,7 @@ LM_REASON irlmp_convert_lap_reason( LAP_REASON lap_reason)
 		reason = LM_CONNECT_FAILURE;
 		break;
 	default:
-		IRDA_DEBUG(1, "%s(), Unknow IrLAP disconnect reason %d!\n",
+		IRDA_DEBUG(1, "%s(), Unknown IrLAP disconnect reason %d!\n",
 			   __func__, lap_reason);
 		reason = LM_LAP_DISCONNECT;
 		break;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 751c4d0..719ddbc 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -244,7 +244,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx,
struct ieee80211_sub_if_data
  * @addr: destination address of the path (ETH_ALEN length)
  * @sdata: local subif
  *
- * Returns: 0 on sucess
+ * Returns: 0 on success
  *
  * State: the initial state of the new path is set to 0
  */
@@ -530,7 +530,7 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
  * @addr: dst address (ETH_ALEN length)
  * @sdata: local subif
  *
- * Returns: 0 if succesful
+ * Returns: 0 if successful
  */
 int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/netlabel/netlabel_domainhash.c
b/net/netlabel/netlabel_domainhash.c
index 7a10bbe..c5d9f97 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -682,7 +682,7 @@ struct netlbl_domaddr6_map
*netlbl_domhsh_getentry_af6(const char *domain,
  * buckets and @skip_chain entries.  For each entry in the table call
  * @callback, if @callback returns a negative value stop 'walking' through the
  * table and return.  Updates the values in @skip_bkt and @skip_chain on
- * return.  Returns zero on succcess, negative values on failure.
+ * return.  Returns zero on success, negative values on failure.
  *
  */
 int netlbl_domhsh_walk(u32 *skip_bkt,
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 8674d49..29d8501 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -719,7 +719,7 @@ static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,

 	if (sctp_style(sk, TCP)) {
 		/* Change the sk->sk_state of a TCP-style socket that has
-		 * sucessfully completed a connect() call.
+		 * successfully completed a connect() call.
 		 */
 		if (sctp_state(asoc, ESTABLISHED) && sctp_sstate(sk, CLOSED))
 			sk->sk_state = SCTP_SS_ESTABLISHED;
diff --git a/net/wimax/op-reset.c b/net/wimax/op-reset.c
index ca26917..35f3700 100644
--- a/net/wimax/op-reset.c
+++ b/net/wimax/op-reset.c
@@ -62,7 +62,7 @@
  * Called when wanting to reset the device for any reason. Device is
  * taken back to power on status.
  *
- * This call blocks; on succesful return, the device has completed the
+ * This call blocks; on successful return, the device has completed the
  * reset process and is ready to operate.
  */
 int wimax_reset(struct wimax_dev *wimax_dev)
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index e688237..2534400 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -204,7 +204,7 @@ int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
  *
  * Description
  * Call the NetLabel mechanism to set the label of a packet using @sid.
- * Returns zero on auccess, negative values on failure.
+ * Returns zero on success, negative values on failure.
  *
  */
 int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index ff17820..5914eeb 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -741,7 +741,7 @@ int security_bounded_transition(u32 old_sid, u32 new_sid)
 		goto out;
 	}

-	/* type/domain unchaned */
+	/* type/domain unchanged */
 	if (old_context->type == new_context->type) {
 		rc = 0;
 		goto out;
diff --git a/sound/Kconfig b/sound/Kconfig
index 439e15c..b3e53e6 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -58,7 +58,7 @@ config SOUND_OSS_CORE_PRECLAIM
 	  Please read Documentation/feature-removal-schedule.txt for
 	  details.

-	  If unusre, say Y.
+	  If unsure, say Y.

 source "sound/oss/dmasound/Kconfig"

diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index a076a6c..a828baa 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -177,7 +177,7 @@ static struct pnp_card_device_id snd_cs423x_pnpids[] = {
 	{ .id = "CSC0437", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" } } },
 	/* Digital PC 5000 Onboard - CS4236B */
 	{ .id = "CSC0735", .devs = { { "CSC0000" }, { "CSC0010" } } },
-	/* some uknown CS4236B */
+	/* some unknown CS4236B */
 	{ .id = "CSC0b35", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" } } },
 	/* Intel PR440FX Onboard sound */
 	{ .id = "CSC0b36", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" } } },
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index 02e30d7..ddad60e 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -137,7 +137,7 @@ struct snd_miro {
 static void snd_miro_proc_init(struct snd_miro * miro);

 static char * snd_opti9xx_names[] = {
-	"unkown",
+	"unknown",
 	"82C928", "82C929",
 	"82C924", "82C925",
 	"82C930", "82C931", "82C933"
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c
b/sound/isa/opti9xx/opti92x-ad1848.c
index 5cd5553..8480075 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -185,7 +185,7 @@ MODULE_DEVICE_TABLE(pnp_card, snd_opti9xx_pnpids);
 #endif

 static char * snd_opti9xx_names[] = {
-	"unkown",
+	"unknown",
 	"82C928",	"82C929",
 	"82C924",	"82C925",
 	"82C930",	"82C931",	"82C933"
diff --git a/sound/pci/ca0106/ca0106_proc.c b/sound/pci/ca0106/ca0106_proc.c
index c62b7d1..8d13092 100644
--- a/sound/pci/ca0106/ca0106_proc.c
+++ b/sound/pci/ca0106/ca0106_proc.c
@@ -233,7 +233,7 @@ static void snd_ca0106_proc_dump_iec958( struct
snd_info_buffer *buffer, u32 val
 			snd_iprintf(buffer, "user-defined\n");
 			break;
 		default:
-			snd_iprintf(buffer, "unkown\n");
+			snd_iprintf(buffer, "unknown\n");
 			break;
 		}
 		snd_iprintf(buffer, "Sample Bits: ");
diff --git a/sound/pci/cs46xx/imgs/cwcdma.asp b/sound/pci/cs46xx/imgs/cwcdma.asp
index 09d24c7..a65e119 100644
--- a/sound/pci/cs46xx/imgs/cwcdma.asp
+++ b/sound/pci/cs46xx/imgs/cwcdma.asp
@@ -26,10 +26,11 @@
 //
 //
 // The purpose of this code is very simple: make it possible to tranfser
-// the samples 'as they are' with no alteration from a PCMreader SCB
(DMA from host)
-// to any other SCB. This is useful for AC3 throug SPDIF. SRC (source
rate converters)
-// task always alters the samples in some how, however it's from
48khz -> 48khz. The
-// alterations are not audible, but AC3 wont work.
+// the samples 'as they are' with no alteration from a PCMreader
+// SCB (DMA from host) to any other SCB. This is useful for AC3 through SPDIF.
+// SRC (source rate converters) task always alters the samples in somehow,
+// however it's from 48khz -> 48khz.
+// The alterations are not audible, but AC3 wont work.
 //
 //        ...
 //         |
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 36e08bd..360e380 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -184,7 +184,7 @@ MODULE_PARM_DESC(enable, "Enable the EMU10K1X soundcard.");
  * The hardware has 3 channels for playback and 1 for capture.
  *  - channel 0 is the front channel
  *  - channel 1 is the rear channel
- *  - channel 2 is the center/lfe chanel
+ *  - channel 2 is the center/lfe channel
  * Volume is controlled by the AC97 for the front and rear channels by
  * the PCM Playback Volume, Sigmatel Surround Playback Volume and
  * Surround Playback Volume. The Sigmatel 4-Speaker Stereo switch affects
diff --git a/sound/pci/hda/patch_cmedia.c b/sound/pci/hda/patch_cmedia.c
index 780e1a7..8917071 100644
--- a/sound/pci/hda/patch_cmedia.c
+++ b/sound/pci/hda/patch_cmedia.c
@@ -66,7 +66,7 @@ struct cmi_spec {

 	struct hda_pcm pcm_rec[2];	/* PCM information */

-	/* pin deafault configuration */
+	/* pin default configuration */
 	hda_nid_t pin_nid[NUM_PINS];
 	unsigned int def_conf[NUM_PINS];
 	unsigned int pin_def_confs;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c08ca66..6141ab4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6617,7 +6617,7 @@ static struct hda_input_mux
alc889A_mb31_capture_source = {
 		/* Front Mic (0x01) unused */
 		{ "Line", 0x2 },
 		/* Line 2 (0x03) unused */
-		/* CD (0x04) unsused? */
+		/* CD (0x04) unused? */
 	},
 };

diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 0dce331..a1b10d1 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -3017,7 +3017,7 @@ snd_hdspm_proc_read_madi(struct snd_info_entry * entry,
 		insel = "Coaxial";
 		break;
 	default:
-		insel = "Unkown";
+		insel = "Unknown";
 	}

 	switch (hdspm->control_register & HDSPM_SyncRefMask) {
@@ -3028,7 +3028,7 @@ snd_hdspm_proc_read_madi(struct snd_info_entry * entry,
 		syncref = "MADI";
 		break;
 	default:
-		syncref = "Unkown";
+		syncref = "Unknown";
 	}
 	snd_iprintf(buffer, "Inputsel = %s, SyncRef = %s\n", insel,
 		    syncref);
diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
index c33b92e..8ce1c9b 100644
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -101,7 +101,7 @@ static int uda134x_write(struct snd_soc_codec
*codec, unsigned int reg,
 	pr_debug("%s reg: %02X, value:%02X\n", __func__, reg, value);

 	if (reg >= UDA134X_REGS_NUM) {
-		printk(KERN_ERR "%s unkown register: reg: %u",
+		printk(KERN_ERR "%s unknown register: reg: %u",
 		       __func__, reg);
 		return -EINVAL;
 	}
@@ -552,7 +552,7 @@ static int uda134x_soc_probe(struct platform_device *pdev)
 					ARRAY_SIZE(uda1341_snd_controls));
 	break;
 	default:
-		printk(KERN_ERR "%s unkown codec type: %d",
+		printk(KERN_ERR "%s unknown codec type: %d",
 			__func__, pd->model);
 	return -EINVAL;
 	}
diff --git a/sound/soc/s3c24xx/s3c24xx_simtec.c
b/sound/soc/s3c24xx/s3c24xx_simtec.c
index 1966e0d..3c7ccb7 100644
--- a/sound/soc/s3c24xx/s3c24xx_simtec.c
+++ b/sound/soc/s3c24xx/s3c24xx_simtec.c
@@ -270,7 +270,7 @@ static int attach_gpio_amp(struct device *dev,
 		gpio_direction_output(pd->amp_gain[1], 0);
 	}

-	/* note, curently we assume GPA0 isn't valid amp */
+	/* note, currently we assume GPA0 isn't valid amp */
 	if (pdata->amp_gpio > 0) {
 		ret = gpio_request(pd->amp_gpio, "gpio-amp");
 		if (ret) {
diff --git a/sound/sound_core.c b/sound/sound_core.c
index 49c9981..dbca7c9 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -353,7 +353,7 @@ static struct sound_unit *chains[SOUND_STEP];
  *      @dev: device pointer
  *
  *	Allocate a special sound device by minor number from the sound
- *	subsystem. The allocated number is returned on succes. On failure
+ *	subsystem. The allocated number is returned on success. On failure
  *	a negative error code is returned.
  */
