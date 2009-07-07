Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbZGGQce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbZGGQce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbZGGQcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:32:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46279 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbZGGQcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:32:24 -0400
Subject: [GIT PULL] V2 trivial fixes typo "foo foo"
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
       Gadiyar Anand <gadiyar@ti.com>, LKML <linux-kernel@vger.kernel.org>,
       Joe Perches <joe@perches.com>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 22:00:09 +0530
Message-Id: <1246984209.3613.46.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To stay on the safe side skipping following patches from V1 which can
raise confusions and objections:

      trivial: fix typo "and and" in multiple files 
      trivial: fix typo "are are" in multiple files
      trivial: fix typo "has has" in multiple files
      trivial: fix typo "on on" in multiple files
      trivial: fix typo "that that" in multiple files
      trivial: fix typo "this this" in multiple files


The following changes since commit faf80d62e44dc627efb741f48db50c1858d1667c:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6.git master

Jaswinder Singh Rajput (16):
      trivial: fix typo "a a" in multiple files
      trivial: fix typo "as as" in multiple files
      trivial: fix typo "be be" in multiple files
      trivial: fix typo "bit bit" in multiple files
      trivial: fix typo "by by" in multiple files
      trivial: fix typo "can can"
      trivial: fix typo "could could" in multiple files
      trivial: fix typo "from from" in multiple files
      trivial: fix typo "lock lock"
      trivial: fix typo "should should" in multiple files
      trivial: fix typo "test test"
      trivial: fix typo "too too"
      trivial: fix typo "was was" in multiple files
      trivial: fix typo "we we" in multiple files
      trivial: fix typo "with with" in multiple files
      trivial: fix typo "you you"

 Documentation/DocBook/uio-howto.tmpl               |    2 +-
 Documentation/fb/viafb.txt                         |    2 +-
 Documentation/filesystems/caching/operations.txt   |    2 +-
 Documentation/scsi/advansys.txt                    |    2 +-
 Documentation/sysfs-rules.txt                      |    2 +-
 arch/frv/kernel/sleep.S                            |    2 +-
 arch/ia64/include/asm/sn/pda.h                     |    2 +-
 arch/microblaze/kernel/signal.c                    |    2 +-
 arch/mips/cavium-octeon/setup.c                    |    2 +-
 arch/mips/include/asm/octeon/octeon.h              |    2 +-
 arch/sparc/kernel/head_64.S                        |    2 +-
 arch/x86/include/asm/xen/hypercall.h               |    2 +-
 arch/x86/math-emu/reg_u_sub.S                      |    2 +-
 crypto/testmgr.h                                   |   10 +++++-----
 drivers/char/amiserial.c                           |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    2 +-
 drivers/media/dvb/ttpci/av7110.c                   |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |    2 +-
 drivers/media/video/ov511.c                        |    2 +-
 drivers/media/video/ovcamchip/ov7x10.c             |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |    2 +-
 drivers/mtd/ubi/vmt.c                              |    4 ++--
 drivers/net/fs_enet/fs_enet.h                      |    2 +-
 drivers/net/ixgbe/ixgbe_82598.c                    |    2 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |    2 +-
 drivers/net/ixgbe/ixgbe_common.c                   |    2 +-
 drivers/net/s2io.c                                 |    2 +-
 drivers/net/skfp/fplustm.c                         |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/wireless/libertas/scan.c               |    2 +-
 drivers/parisc/ccio-dma.c                          |    2 +-
 drivers/pci/hotplug/ibmphp.h                       |    2 +-
 drivers/rtc/rtc-m41t80.c                           |    2 +-
 drivers/scsi/libfc/fc_fcp.c                        |    2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h                |    2 +-
 drivers/staging/android/binder.c                   |    2 +-
 drivers/staging/frontier/alphatrack.c              |    2 +-
 drivers/staging/frontier/tranzport.c               |    2 +-
 .../staging/rtl8192su/ieee80211/rtl819x_HTProc.c   |    2 +-
 drivers/staging/rtl8192su/r8192S_phy.c             |    2 +-
 drivers/staging/rtl8192su/r819xU_phy.c             |    2 +-
 drivers/staging/wlan-ng/prism2sta.c                |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/video/aty/mach64_cursor.c                  |    2 +-
 drivers/video/riva/fbdev.c                         |    2 +-
 drivers/watchdog/eurotechwdt.c                     |    2 +-
 drivers/watchdog/pc87413_wdt.c                     |    2 +-
 drivers/watchdog/w83977f_wdt.c                     |    2 +-
 drivers/watchdog/wdt.c                             |    2 +-
 drivers/watchdog/wdt977.c                          |    2 +-
 drivers/watchdog/wdt_pci.c                         |    2 +-
 fs/cifs/inode.c                                    |    2 +-
 fs/exec.c                                          |    2 +-
 fs/jbd/journal.c                                   |    2 +-
 fs/jbd2/journal.c                                  |    2 +-
 fs/ocfs2/cluster/quorum.c                          |    2 +-
 fs/squashfs/cache.c                                |    2 +-
 fs/ubifs/misc.h                                    |    2 +-
 fs/ufs/super.c                                     |    2 +-
 fs/xfs/xfs_trans_ail.c                             |    2 +-
 include/linux/exportfs.h                           |    2 +-
 include/linux/ipv6.h                               |    2 +-
 include/linux/mtd/pfow.h                           |    2 +-
 include/linux/usb/gadget.h                         |    2 +-
 include/linux/wimax/debug.h                        |    2 +-
 include/sound/soc-dai.h                            |    2 +-
 kernel/perf_counter.c                              |    2 +-
 net/atm/lec.c                                      |    2 +-
 net/dccp/ipv4.c                                    |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |    2 +-
 net/netfilter/nf_conntrack_pptp.c                  |    2 +-
 net/rds/ib_cm.c                                    |    2 +-
 net/rds/iw_cm.c                                    |    2 +-
 net/sctp/sm_make_chunk.c                           |    2 +-
 net/sunrpc/svcsock.c                               |    2 +-
 scripts/Kbuild.include                             |    2 +-
 scripts/namespace.pl                               |    2 +-
 sound/isa/cs423x/cs4236_lib.c                      |    2 +-
 sound/isa/es18xx.c                                 |    2 +-
 81 files changed, 86 insertions(+), 86 deletions(-)


