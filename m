Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0CHXGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:06:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab0CHXGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:06:21 -0500
Date: Tue, 9 Mar 2010 00:06:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1003090004340.17799@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive trivial patch queue contents for 2.6.34. Nothing earth-shaking 
there (what a surprise :) ).

Thanks!


Adam Buchbinder (7):
      Fix a grammar error (redundant "be") in comment
      Fix misspelling of "truly" in a label.
      Fix misspellings of "truly" in comments.
      Fix misspellings of "invocation" in comments.
      Fix misspellings of "separate" in strings.
      Fix misspelling of "successful" and variants in comments.
      Fix misspelling of "should" and "shouldn't" in comments.

Ali Gholami Rudi (1):
      doc: fix checking socket() in net tstamp example

Anton Blanchard (1):
      Remove reference to kthread_create_on_cpu

Baruch Siach (1):
      devres: typo fix s/dev/devm/

Daniel Mack (3):
      tree-wide: s/widht/width/g typo in comments
      tree-wide: fix 'lenght' typo in comments and code
      tree-wide: Assorted spelling fixes

Edward Z. Yang (1):
      Remove redundant trailing semicolons from macros

Geert Uytterhoeven (1):
      ataflop: Killl warning about unused variable flags

GeunSik Lim (1):
      doc: cpuset: Update the cpuset flag file

Jaak Ristioja (1):
      bio: Fix outdated comment about bio_alloc_bioset()

Jasper Spaans (1):
      arch/x86/kernel/apic/apic_flat_64.c: Make comment match the code

Jean Delvare (1):
      devres/irq: Fix devm_irq_match comment

Jiri Kosina (6):
      crypto: fix typo in Kconfig help text
      No need to patch AMD-provided drivers/gpu/drm/radeon/atombios.h
      Remove drivers/parport/ChangeLog
      Fix of spelling in arch/sparc/kernel/leon_kernel.c no longer needed
      Remove fs/ntfs/ChangeLog
      Merge branch 'for-next' into for-linus

Jonathan Corbet (1):
      Remove drivers/char/ChangeLog

Julia Lawall (1):
      fs/qnx4: decrement sizeof size in strncmp

Justin P. Mattock (2):
      fix comment typo in pci-dma.c
      fix comment typos in avc.c

Mulyadi Santosa (1):
      doc: typo - Table 1-2 should refer to "status", not "statm"

Nikanth Karthikesan (1):
      doc: fix typo in comment explaining rb_tree usage

Pavel Roskin (1):
      drm/kms: fix spelling in error message

Peter Huewe (5):
      uwb/i1480: add __init/__exit macros
      isdn/hardware: add __init/__exit macros to mISDNisar.c
      w1: add __init/__exit macros to w1.c
      media/dvb: add __init/__exit macros to bt878.c
      isdn/mISDN: add __init/__exit macros to dsp_core.c

Robert P. J. Day (1):
      xen: Fix misspelled CONFIG variable in comment.

Rudy Matela (1):
      Coding style correction of some wan drivers

Sebastian Andrzej Siewior (1):
      tree wide: remove execute flag from .c files

Shahar Havivi (1):
      vt: remove unused variables

Shaun Patterson (1):
      vmiclock: fix comment spelling mistake

Stefan Weil (2):
      Fix spelling of 'platform' in comments and doc
      Fix spelling of 'platform' in log messages

Thadeu Lima de Souza Cascardo (8):
      fix ext3/ext4 comment typo compain -> complain
      fix comment typo boo -> boot in ksysfs.c
      doc: fix leve -> level typo in pm-runtime doc
      fix comment typo leve -> level in powerpc
      doc: update 00-INDEX for Documentation/laptops/
      doc: fix Defaultd -> Defaults typo in EISA doc
      doc: capitalization and other minor fixes in pnp doc
      doc: fix console doc typo

Uwe Kleine-König (5):
      fix typos "precidence" -> "precedence" in comments
      tree-wide: fix typos "ammount" -> "amount"
      grammar fix in comment
      fix typo "definetly" -> "definitely" in comment
      tree-wide: fix typos "ass?o[sc]iac?te" -> "associate" in comments

 Documentation/DocBook/mtdnand.tmpl                 |    6 +-
 Documentation/DocBook/v4l/common.xml               |    2 +-
 Documentation/DocBook/v4l/vidioc-g-parm.xml        |    2 +-
 Documentation/arm/Samsung-S3C24XX/CPUfreq.txt      |    4 +-
 Documentation/cgroups/cpusets.txt                  |  127 +-
 Documentation/console/console.txt                  |    2 +-
 Documentation/driver-model/platform.txt            |    2 +-
 Documentation/eisa.txt                             |    2 +-
 Documentation/filesystems/proc.txt                 |    2 +-
 Documentation/hwmon/abituguru                      |    2 +-
 Documentation/input/rotary-encoder.txt             |    2 +-
 Documentation/laptops/00-INDEX                     |    4 +
 Documentation/networking/skfp.txt                  |    2 +-
 .../networking/timestamping/timestamping.c         |    2 +-
 Documentation/pnp.txt                              |   13 +-
 Documentation/power/runtime_pm.txt                 |    2 +-
 Documentation/s390/kvm.txt                         |    2 +-
 Documentation/scsi/ChangeLog.lpfc                  |   10 +-
 Documentation/trace/ftrace.txt                     |    2 +-
 arch/arm/boot/bootp/init.S                         |    2 +-
 arch/arm/common/clkdev.c                           |    2 +-
 arch/arm/mach-at91/include/mach/at91_mci.h         |    2 +-
 arch/arm/mach-davinci/include/mach/i2c.h           |    2 +-
 arch/arm/mach-ep93xx/micro9.c                      |    2 +-
 arch/arm/mach-nomadik/board-nhk8815.c              |    2 +-
 arch/arm/mach-s3c2410/include/mach/spi-gpio.h      |    2 +-
 arch/arm/mach-s5pc100/setup-sdhci.c                |    4 +-
 arch/arm/mach-u300/core.c                          |    4 +-
 arch/arm/mach-u300/include/mach/debug-macro.S      |    2 +-
 arch/arm/plat-s3c/include/plat/gpio-cfg-helpers.h  |    2 +-
 arch/arm/plat-s3c/include/plat/nand.h              |    2 +-
 .../arm/plat-s3c/include/plat/regs-usb-hsotg-phy.h |    2 +-
 arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h |    2 +-
 arch/blackfin/include/asm/nand.h                   |    4 +-
 arch/cris/arch-v10/lib/old_checksum.c              |    2 +-
 arch/cris/arch-v32/mm/tlb.c                        |    2 +-
 arch/h8300/include/asm/io.h                        |    2 +-
 arch/ia64/sn/kernel/setup.c                        |    2 +-
 arch/m68k/atari/atakeyb.c                          |    2 +-
 arch/m68k/include/asm/fbio.h                       |    2 +-
 arch/m68k/include/asm/io_no.h                      |    2 +-
 arch/powerpc/boot/dts/kmeter1.dts                  |    2 +-
 arch/powerpc/kernel/legacy_serial.c                |    2 +-
 arch/powerpc/mm/init_32.c                          |    2 +-
 arch/s390/crypto/sha_common.c                      |    2 +-
 arch/s390/include/asm/cio.h                        |    2 +-
 arch/s390/kernel/sclp.S                            |    2 +-
 arch/sh/kernel/cpu/clock.c                         |    2 +-
 arch/sparc/include/asm/fbio.h                      |    2 +-
 arch/sparc/kernel/perf_event.c                     |    2 +-
 arch/x86/crypto/twofish-i586-asm_32.S              |   10 +-
 arch/x86/crypto/twofish-x86_64-asm_64.S            |   20 +-
 arch/x86/kernel/apic/apic_flat_64.c                |    2 +-
 arch/x86/kernel/head_64.S                          |    2 +-
 arch/x86/kernel/pci-calgary_64.c                   |    2 +-
 arch/x86/kernel/pci-dma.c                          |    2 +-
 arch/x86/kernel/ptrace.c                           |    2 +-
 arch/x86/kernel/tsc.c                              |    2 +-
 arch/x86/kernel/vmiclock_32.c                      |    2 +-
 arch/x86/xen/smp.c                                 |    2 +-
 arch/xtensa/kernel/entry.S                         |    4 +-
 block/bsg.c                                        |    2 +-
 crypto/Kconfig                                     |    4 +-
 drivers/acpi/dock.c                                |    2 +-
 drivers/acpi/proc.c                                |    2 +-
 drivers/ata/libata-core.c                          |    2 +-
 drivers/ata/libata-sff.c                           |    2 +-
 drivers/ata/pata_acpi.c                            |    2 +-
 drivers/ata/pata_hpt3x3.c                          |    2 +-
 drivers/ata/pata_pcmcia.c                          |    2 +-
 drivers/block/drbd/drbd_int.h                      |    4 +-
 drivers/block/drbd/drbd_req.h                      |    2 +-
 drivers/char/ChangeLog                             |  775 ---------
 drivers/char/agp/intel-agp.c                       |    2 +-
 drivers/char/applicom.c                            |    2 +-
 drivers/char/hvc_iseries.c                         |    2 +-
 drivers/char/hw_random/n2-drv.c                    |    2 +-
 drivers/char/ip2/i2hw.h                            |    2 +-
 drivers/char/pty.c                                 |    2 +-
 drivers/char/random.c                              |    2 +-
 drivers/char/serial167.c                           |    2 +-
 drivers/char/tty_io.c                              |    2 +-
 drivers/char/vt.c                                  |    6 +-
 drivers/crypto/hifn_795x.c                         |    2 +-
 drivers/dma/coh901318_lli.h                        |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h              |    2 +-
 drivers/gpu/drm/radeon/radeon_state.c              |    2 +-
 drivers/gpu/drm/via/via_irq.c                      |    4 +-
 drivers/i2c/algos/i2c-algo-pcf.c                   |    2 +-
 drivers/i2c/busses/i2c-pxa.c                       |    2 +-
 drivers/ieee1394/pcilynx.c                         |    2 +-
 drivers/infiniband/hw/ehca/ehca_qes.h              |    4 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c             |    2 +-
 drivers/input/misc/yealink.h                       |    2 +-
 drivers/input/serio/i8042.c                        |    2 +-
 drivers/input/tablet/aiptek.c                      |    2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c            |    4 +-
 drivers/isdn/i4l/isdn_common.c                     |    2 +-
 drivers/isdn/mISDN/dsp_core.c                      |    4 +-
 drivers/isdn/mISDN/l1oip_core.c                    |    4 +-
 drivers/isdn/sc/hardware.h                         |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    8 +-
 drivers/media/video/bt8xx/bttv-cards.c             |    4 +-
 drivers/media/video/gspca/ov519.c                  |    2 +-
 drivers/media/video/pwc/philips.txt                |    2 +-
 drivers/media/video/sn9c102/sn9c102_sensor.h       |    2 +-
 drivers/media/video/tea6420.c                      |    2 +-
 drivers/message/i2o/iop.c                          |    2 +-
 drivers/mfd/sm501.c                                |    8 +-
 drivers/mmc/card/sdio_uart.c                       |    2 +-
 drivers/mmc/host/mxcmmc.c                          |    2 +-
 drivers/mtd/chips/jedec_probe.c                    |    2 +-
 drivers/mtd/maps/plat-ram.c                        |    2 +-
 drivers/mtd/nand/bcm_umi_nand.c                    |    4 +-
 drivers/mtd/nand/mxc_nand.c                        |    2 +-
 drivers/net/atlx/atl2.h                            |    2 +-
 drivers/net/chelsio/sge.c                          |    2 +-
 drivers/net/cs89x0.c                               |    2 +-
 drivers/net/cxgb3/sge.c                            |    4 +-
 drivers/net/davinci_emac.c                         |    2 +-
 drivers/net/e1000e/82571.c                         |    2 +-
 drivers/net/e1000e/lib.c                           |    2 +-
 drivers/net/igb/igb_main.c                         |    2 +-
 drivers/net/irda/sa1100_ir.c                       |    2 +-
 drivers/net/ks8851.c                               |    2 +-
 drivers/net/qlge/qlge_ethtool.c                    |    2 +-
 drivers/net/qlge/qlge_main.c                       |    2 +-
 drivers/net/sfc/regs.h                             |    2 +-
 drivers/net/skfp/ess.c                             |    2 +-
 drivers/net/smsc9420.c                             |    2 +-
 drivers/net/spider_net.c                           |    4 +-
 drivers/net/sungem.c                               |    2 +-
 drivers/net/tehuti.c                               |    2 +-
 drivers/net/tokenring/tms380tr.c                   |    4 +-
 drivers/net/tun.c                                  |    2 +-
 drivers/net/typhoon.c                              |    6 +-
 drivers/net/ucc_geth.c                             |    2 +-
 drivers/net/wan/cosa.c                             |   10 +-
 drivers/net/wan/hdlc_cisco.c                       |    8 +-
 drivers/net/wan/hdlc_x25.c                         |    4 +-
 drivers/net/wimax/i2400m/fw.c                      |    2 +-
 drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
 drivers/net/wimax/i2400m/sdio.c                    |    4 +-
 drivers/net/wimax/i2400m/usb.c                     |    4 +-
 drivers/net/wireless/ath/ar9170/main.c             |    2 +-
 drivers/net/wireless/iwmc3200wifi/lmac.h           |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    6 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    2 +-
 drivers/parport/ChangeLog                          |  583 -------
 drivers/platform/x86/thinkpad_acpi.c               |    4 +-
 drivers/s390/char/raw3270.c                        |    2 +-
 drivers/s390/char/sclp.c                           |    2 +-
 drivers/scsi/a100u2w.c                             |    2 +-
 drivers/scsi/initio.c                              |    2 +-
 drivers/scsi/libfc/fc_fcp.c                        |    4 +-
 drivers/scsi/lpfc/lpfc_els.c                       |    4 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |    4 +-
 drivers/scsi/pcmcia/nsp_cs.h                       |    2 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |    2 +-
 drivers/scsi/pmcraid.h                             |    2 +-
 drivers/scsi/sd.c                                  |    2 +-
 drivers/serial/samsung.c                           |    2 +-
 drivers/spi/spi_s3c24xx.c                          |    2 +-
 drivers/usb/musb/davinci.c                         |    2 +-
 drivers/usb/musb/musb_regs.h                       |    2 +-
 drivers/usb/serial/cypress_m8.c                    |    2 +-
 drivers/usb/serial/opticon.c                       |    2 +-
 drivers/usb/serial/symbolserial.c                  |    2 +-
 drivers/usb/wusbcore/wusbhc.h                      |    2 +-
 drivers/uwb/i1480/i1480-est.c                      |    4 +-
 drivers/uwb/uwbd.c                                 |    2 +-
 drivers/video/68328fb.c                            |    2 +-
 drivers/video/mbx/mbxfb.c                          |    2 +-
 drivers/video/omap/lcdc.c                          |    2 +-
 drivers/video/pm2fb.c                              |    2 +-
 drivers/video/s1d13xxxfb.c                         |    4 +-
 drivers/video/sm501fb.c                            |    2 +-
 drivers/video/sstfb.c                              |    2 +-
 drivers/w1/w1.c                                    |    4 +-
 drivers/zorro/zorro.ids                            |    2 +-
 fs/affs/bitmap.c                                   |    2 +-
 fs/binfmt_elf_fdpic.c                              |    2 +-
 fs/bio.c                                           |    7 +-
 fs/buffer.c                                        |    2 +-
 fs/cifs/asn1.c                                     |    2 +-
 fs/cifs/cifs_dfs_ref.c                             |    2 +-
 fs/cifs/cifssmb.c                                  |    2 +-
 fs/dlm/member.c                                    |    2 +-
 fs/ext3/super.c                                    |    2 +-
 fs/ext4/mballoc.c                                  |    2 +-
 fs/ext4/super.c                                    |    2 +-
 fs/fuse/inode.c                                    |    2 +-
 fs/gfs2/ops_fstype.c                               |    2 +-
 fs/jbd/transaction.c                               |    2 +-
 fs/locks.c                                         |    2 +-
 fs/mpage.c                                         |    2 +-
 fs/namei.c                                         |    2 +-
 fs/nfsd/nfs4xdr.c                                  |    2 +-
 fs/ntfs/ChangeLog                                  | 1702 --------------------
 fs/ocfs2/dlmglue.c                                 |    2 +-
 fs/ocfs2/extent_map.c                              |    2 +-
 fs/qnx4/inode.c                                    |    3 +-
 fs/reiserfs/bitmap.c                               |    2 +-
 fs/udf/inode.c                                     |    2 +-
 include/linux/dm9000.h                             |    2 +-
 include/linux/hil.h                                |   16 +-
 include/linux/lru_cache.h                          |    2 +-
 include/linux/mmzone.h                             |    2 +-
 include/linux/rbtree.h                             |    8 +-
 include/linux/sched.h                              |    2 +-
 include/math-emu/op-common.h                       |    2 +-
 include/media/davinci/vpfe_capture.h               |    2 +-
 include/net/irda/irttp.h                           |    2 +-
 kernel/audit.c                                     |    2 +-
 kernel/irq/chip.c                                  |    2 +-
 kernel/irq/devres.c                                |    4 +-
 kernel/ksysfs.c                                    |    2 +-
 kernel/params.c                                    |    6 +-
 kernel/sched_cpupri.c                              |    2 +-
 kernel/trace/ring_buffer.c                         |    4 +-
 kernel/trace/trace.h                               |    2 +-
 mm/highmem.c                                       |    2 +-
 mm/slub.c                                          |    2 +-
 net/ipv4/tcp_timer.c                               |    2 +-
 net/mac80211/mesh_plink.c                          |    2 +-
 net/netfilter/nf_conntrack_sip.c                   |    4 +-
 net/netfilter/xt_hashlimit.c                       |    2 +-
 net/sctp/sm_sideeffect.c                           |    2 +-
 scripts/gfp-translate                              |    2 +-
 security/selinux/avc.c                             |    6 +-
 sound/pci/rme9652/hdspm.c                          |    2 +-
 sound/soc/codecs/wm8990.c                          |    2 +-
 tools/perf/perf.c                                  |    2 +-
 tools/perf/util/hist.c                             |    2 +-
 242 files changed, 396 insertions(+), 3454 deletions(-)
 mode change 100755 => 100644 arch/arm/mach-omap2/board-3630sdp.c
 mode change 100755 => 100644 arch/arm/mach-omap2/board-zoom-peripherals.c
 delete mode 100644 drivers/char/ChangeLog
 mode change 100755 => 100644 drivers/mtd/chips/cfi_util.c
 mode change 100755 => 100644 drivers/mtd/inftlcore.c
 delete mode 100644 drivers/parport/ChangeLog
 delete mode 100644 fs/ntfs/ChangeLog
