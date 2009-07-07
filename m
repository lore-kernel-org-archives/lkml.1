Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZGGOe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZGGOe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758251AbZGGOeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:34:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:42684 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758103AbZGGOeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:34:15 -0400
Subject: [GIT PULL] [PATCH 0/22] trivial fixes typo "foo foo"
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tony Luck <tony.luck@intel.com>,
       benh@kernel.crashing.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       mchehab@infradead.org, jbarnes@virtuousgeek.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Ungerer <gerg@snapgear.com>, Greg KH <greg@kroah.com>,
       David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>, tytso@mit.edu, sct@redhat.com,
       Gadiyar Anand <gadiyar@ti.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:33:47 +0530
Message-Id: <1246975428.3613.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit faf80d62e44dc627efb741f48db50c1858d1667c:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6.git master

Jaswinder Singh Rajput (22):
      trivial: fix typo "a a" in multiple files
      trivial: fix typo "and and" in multiple files
      trivial: fix typo "are are" in multiple files
      trivial: fix typo "as as" in multiple files
      trivial: fix typo "be be" in multiple files
      trivial: fix typo "bit bit" in multiple files
      trivial: fix typo "by by" in multiple files
      trivial: fix typo "can can"
      trivial: fix typo "could could" in multiple files
      trivial: fix typo "from from" in multiple files
      trivial: fix typo "has has" in multiple files
      trivial: fix typo "lock lock"
      trivial: fix typo "on on" in multiple files
      trivial: fix typo "should should" in multiple files
      trivial: fix typo "test test"
      trivial: fix typo "that that" in multiple files
      trivial: fix typo "this this" in multiple files
      trivial: fix typo "too too"
      trivial: fix typo "was was" in multiple files
      trivial: fix typo "we we" in multiple files
      trivial: fix typo "with with" in multiple files
      trivial: fix typo "you you"

 Documentation/DocBook/uio-howto.tmpl               |    2 +-
 Documentation/RCU/rcu.txt                          |    2 +-
 Documentation/block/as-iosched.txt                 |    2 +-
 Documentation/fb/fbcon.txt                         |    2 +-
 Documentation/fb/viafb.txt                         |    2 +-
 .../filesystems/autofs4-mount-control.txt          |    2 +-
 Documentation/filesystems/caching/operations.txt   |    2 +-
 Documentation/kernel-parameters.txt                |    2 +-
 Documentation/memory-barriers.txt                  |    2 +-
 Documentation/networking/ax25.txt                  |    2 +-
 Documentation/networking/ipvs-sysctl.txt           |    2 +-
 Documentation/scsi/advansys.txt                    |    2 +-
 Documentation/sysfs-rules.txt                      |    2 +-
 Documentation/trace/ftrace.txt                     |    2 +-
 arch/alpha/kernel/irq_i8259.c                      |    2 +-
 arch/arm/mm/abort-ev7.S                            |    2 +-
 arch/frv/kernel/sleep.S                            |    2 +-
 arch/ia64/hp/sim/simeth.c                          |    2 +-
 arch/ia64/include/asm/sn/pda.h                     |    2 +-
 arch/m68k/kernel/head.S                            |    6 +++---
 arch/m68k/mac/iop.c                                |    2 +-
 arch/microblaze/kernel/signal.c                    |    2 +-
 arch/mips/cavium-octeon/setup.c                    |    2 +-
 arch/mips/include/asm/octeon/octeon.h              |    2 +-
 arch/powerpc/kernel/ftrace.c                       |    4 ++--
 arch/powerpc/kernel/process.c                      |    4 ++--
 arch/powerpc/kernel/ptrace.c                       |    2 +-
 arch/s390/lib/delay.c                              |    2 +-
 arch/sparc/kernel/head_64.S                        |    2 +-
 arch/x86/boot/compressed/relocs.c                  |    2 +-
 arch/x86/include/asm/xen/hypercall.h               |    2 +-
 arch/x86/math-emu/reg_u_sub.S                      |    2 +-
 block/cfq-iosched.c                                |    2 +-
 crypto/testmgr.h                                   |   10 +++++-----
 crypto/twofish_common.c                            |    2 +-
 drivers/char/amiserial.c                           |    2 +-
 drivers/char/rio/riointr.c                         |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    2 +-
 drivers/gpu/drm/radeon/r300_reg.h                  |    2 +-
 drivers/ieee1394/ieee1394_transactions.c           |    4 ++--
 drivers/infiniband/hw/ipath/ipath_file_ops.c       |    2 +-
 drivers/input/serio/hp_sdc.c                       |    2 +-
 drivers/media/dvb/ttpci/av7110.c                   |    2 +-
 drivers/media/video/cx18/cx18-av-core.c            |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |    2 +-
 drivers/media/video/ov511.c                        |    2 +-
 drivers/media/video/ovcamchip/ov7x10.c             |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |    2 +-
 drivers/mtd/ubi/eba.c                              |    2 +-
 drivers/mtd/ubi/vmt.c                              |    4 ++--
 drivers/net/bonding/bond_alb.c                     |    2 +-
 drivers/net/fs_enet/fs_enet.h                      |    2 +-
 drivers/net/ixgbe/ixgbe_82598.c                    |    2 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |    2 +-
 drivers/net/ixgbe/ixgbe_common.c                   |    2 +-
 drivers/net/s2io.c                                 |    2 +-
 drivers/net/skfp/fplustm.c                         |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/tulip/xircom_cb.c                      |    4 ++--
 drivers/net/wireless/libertas/scan.c               |    2 +-
 drivers/net/wireless/orinoco/main.h                |    2 +-
 drivers/parisc/ccio-dma.c                          |    2 +-
 drivers/pci/hotplug/ibmphp.h                       |    2 +-
 drivers/pci/hotplug/shpchp_hpc.c                   |    2 +-
 drivers/rtc/rtc-m41t80.c                           |    2 +-
 drivers/s390/char/sclp.c                           |    2 +-
 drivers/s390/char/tape_34xx.c                      |    2 +-
 drivers/scsi/libfc/fc_fcp.c                        |    2 +-
 drivers/scsi/libiscsi_tcp.c                        |    2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |    4 ++--
 drivers/scsi/sym53c8xx_2/sym_hipd.h                |    2 +-
 drivers/serial/mpsc.c                              |    2 +-
 drivers/spi/amba-pl022.c                           |    4 ++--
 drivers/staging/android/binder.c                   |    2 +-
 drivers/staging/epl/EplObd.c                       |    2 +-
 drivers/staging/frontier/alphatrack.c              |    2 +-
 drivers/staging/frontier/tranzport.c               |    2 +-
 .../staging/rtl8192su/ieee80211/rtl819x_HTProc.c   |    2 +-
 drivers/staging/rtl8192su/r8192S_phy.c             |    2 +-
 drivers/staging/rtl8192su/r819xU_phy.c             |    2 +-
 drivers/staging/wlan-ng/prism2sta.c                |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/wusbcore/crypto.c                      |    2 +-
 drivers/usb/wusbcore/wa-xfer.c                     |    2 +-
 drivers/video/aty/mach64_cursor.c                  |    2 +-
 drivers/video/riva/fbdev.c                         |    2 +-
 drivers/watchdog/eurotechwdt.c                     |    2 +-
 drivers/watchdog/pc87413_wdt.c                     |    2 +-
 drivers/watchdog/w83977f_wdt.c                     |    2 +-
 drivers/watchdog/wdt.c                             |    2 +-
 drivers/watchdog/wdt977.c                          |    2 +-
 drivers/watchdog/wdt_pci.c                         |    2 +-
 fs/bio.c                                           |    2 +-
 fs/cifs/inode.c                                    |    2 +-
 fs/configfs/dir.c                                  |    2 +-
 fs/direct-io.c                                     |    2 +-
 fs/exec.c                                          |    2 +-
 fs/ext3/inode.c                                    |    2 +-
 fs/ext4/inode.c                                    |    2 +-
 fs/jbd/checkpoint.c                                |    2 +-
 fs/jbd/journal.c                                   |    2 +-
 fs/jbd2/checkpoint.c                               |    2 +-
 fs/jbd2/journal.c                                  |    2 +-
 fs/nfs/nfs4xdr.c                                   |    2 +-
 fs/ntfs/layout.h                                   |    2 +-
 fs/ocfs2/cluster/quorum.c                          |    2 +-
 fs/quota/dquot.c                                   |    2 +-
 fs/reiserfs/dir.c                                  |    8 ++++----
 fs/squashfs/cache.c                                |    2 +-
 fs/ubifs/io.c                                      |    2 +-
 fs/ubifs/misc.h                                    |    2 +-
 fs/ufs/super.c                                     |    2 +-
 fs/xfs/xfs_trans.c                                 |    2 +-
 fs/xfs/xfs_trans_ail.c                             |    2 +-
 include/linux/cgroup.h                             |    2 +-
 include/linux/dmaengine.h                          |    2 +-
 include/linux/exportfs.h                           |    2 +-
 include/linux/ieee80211.h                          |    2 +-
 include/linux/ipv6.h                               |    2 +-
 include/linux/mtd/pfow.h                           |    2 +-
 include/linux/security.h                           |    2 +-
 include/linux/usb/gadget.h                         |    2 +-
 include/linux/wimax/debug.h                        |    2 +-
 include/sound/soc-dai.h                            |    2 +-
 kernel/perf_counter.c                              |    2 +-
 net/atm/lec.c                                      |    2 +-
 net/dccp/ipv4.c                                    |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |    2 +-
 net/ipv4/tcp_scalable.c                            |    2 +-
 net/netfilter/nf_conntrack_pptp.c                  |    2 +-
 net/rds/ib_cm.c                                    |    2 +-
 net/rds/iw_cm.c                                    |    2 +-
 net/sctp/sm_make_chunk.c                           |    2 +-
 net/sunrpc/svcsock.c                               |    2 +-
 net/unix/af_unix.c                                 |    2 +-
 scripts/Kbuild.include                             |    2 +-
 scripts/checkpatch.pl                              |    2 +-
 scripts/namespace.pl                               |    2 +-
 sound/isa/cs423x/cs4236_lib.c                      |    2 +-
 sound/isa/es18xx.c                                 |    2 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |    2 +-
 tools/perf/Documentation/perf.txt                  |    2 +-
 143 files changed, 159 insertions(+), 159 deletions(-)


