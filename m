Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0CIX0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:26:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36985 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0CIX0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:26:10 -0500
Date: Wed, 10 Mar 2010 10:26:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 9
Message-Id: <20100310102603.d400fb7b.sfr@canb.auug.org.au>
In-Reply-To: <20100309172050.28af0584.sfr@canb.auug.org.au>
References: <20100309172050.28af0584.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Mar_2010_10_26_03_+1100_/dUS+xpQi.=RZFyV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Mar_2010_10_26_03_+1100_/dUS+xpQi.=RZFyV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 9 Mar 2010 17:20:50 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Below is a summary of the state of the merge.

Which is forgot to include, sorry.  It is below.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master
Merging fixes/fixes
Merging arm-current/master
Merging m68k-current/for-linus
Merging powerpc-merge/merge
Merging sparc-current/master
Merging scsi-rc-fixes/master
Merging net-current/master
Applying: ar9170: fix for driver-core ABI change
Merging sound-current/for-linus
Merging pci-current/for-linus
Merging wireless-current/master
Merging kbuild-current/for-linus
Merging quilt/driver-core.current
Merging quilt/tty.current
Merging quilt/usb.current
Merging quilt/staging.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-linus
Merging audit-current/for-linus
Merging crypto-current/master
Merging ide-curent/master
Merging dwmw2/master
Merging arm/devel
Merging davinci/davinci-next
Merging i.MX/for-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging avr32/avr32-arch
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
CONFLICT (content): Merge conflict in arch/microblaze/include/asm/prom.h
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in arch/mips/alchemy/common/platform.c
CONFLICT (content): Merge conflict in arch/mips/alchemy/common/setup.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/db1200/pl=
atform.c
CONFLICT (content): Merge conflict in arch/mips/alchemy/devboards/db1x00/bo=
ard_setup.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/db1x00/pl=
atform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/pb1100/pl=
atform.c
CONFLICT (content): Merge conflict in arch/mips/alchemy/devboards/pb1200/pl=
atform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/pb1500/pl=
atform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/pb1550/pl=
atform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/platform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/platform.h
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/xxs1500/platform.c
CONFLICT (content): Merge conflict in arch/mips/cavium-octeon/octeon-irq.c
CONFLICT (content): Merge conflict in arch/mips/configs/db1200_defconfig
CONFLICT (content): Merge conflict in arch/mips/include/asm/mach-au1x00/au1=
000.h
CONFLICT (content): Merge conflict in drivers/i2c/busses/Kconfig
CONFLICT (content): Merge conflict in drivers/i2c/busses/Makefile
CONFLICT (content): Merge conflict in drivers/pcmcia/au1000_generic.h
CONFLICT (add/add): Merge conflict in drivers/pcmcia/db1xxx_ss.c
CONFLICT (add/add): Merge conflict in drivers/pcmcia/xxs1500_ss.c
CONFLICT (delete/modify): drivers/staging/sm7xx/smtc2d.c deleted in HEAD an=
d modified in mips/mips-for-linux-next. Version mips/mips-for-linux-next of=
 drivers/staging/sm7xx/smtc2d.c left in tree.
CONFLICT (delete/modify): drivers/staging/sm7xx/smtc2d.h deleted in HEAD an=
d modified in mips/mips-for-linux-next. Version mips/mips-for-linux-next of=
 drivers/staging/sm7xx/smtc2d.h left in tree.
$ git rm -f drivers/staging/sm7xx/smtc2d.c drivers/staging/sm7xx/smtc2d.h
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
Merging sh/master
Merging genesis/master
Merging sparc/master
Merging xtensa/master
Merging ceph/for-next
CONFLICT (content): Merge conflict in fs/gfs2/super.c
CONFLICT (content): Merge conflict in fs/nfs/inode.c
CONFLICT (content): Merge conflict in fs/ufs/inode.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_super.c
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
Merging ext3/for_next
Merging ext4/next
Merging fatfs/master
Merging fuse/for-next
Merging gfs2/master
Merging jfs/next
Merging logfs/master
Merging nfs/linux-next
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
Merging ubifs/linux-next
Merging xfs/master
Merging reiserfs-bkl/reiserfs/kill-bkl
Merging vfs/for-next
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/nfsd/nfs4xdr.c
CONFLICT (content): Merge conflict in security/tomoyo/realpath.c
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
CONFLICT (add/add): Merge conflict in drivers/media/dvb/dvb-usb/az6027.c
CONFLICT (add/add): Merge conflict in drivers/media/dvb/ngene/ngene-core.c
CONFLICT (content): Merge conflict in drivers/media/video/cx88/cx88-dvb.c
CONFLICT (add/add): Merge conflict in drivers/media/video/tlg2300/pd-dvb.c
CONFLICT (add/add): Merge conflict in drivers/media/video/tlg2300/pd-main.c
CONFLICT (add/add): Merge conflict in drivers/media/video/tlg2300/pd-radio.c
CONFLICT (add/add): Merge conflict in drivers/media/video/tlg2300/pd-video.c
CONFLICT (content): Merge conflict in drivers/mfd/Kconfig
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in drivers/acpi/processor_core.c
CONFLICT (content): Merge conflict in lib/vsprintf.c
Applying: cpufreq: merge fixup for processor_core.c rename
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/nand/sh_flctl.c
Applying: mtd: nand: fix name space clash
Applying: mtd: declare inline functions static
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/char/hvc_console.c
CONFLICT (content): Merge conflict in drivers/char/hvc_console.h
CONFLICT (content): Merge conflict in drivers/char/virtio_console.c
Merging mmc/next
Merging input/next
Merging lsm/for-next
Merging block/for-next
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging agp/agp-next
Merging uwb/for-upstream
Merging watchdog/master
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
CONFLICT (content): Merge conflict in Documentation/filesystems/proc.txt
CONFLICT (content): Merge conflict in arch/arm/mach-u300/include/mach/debug=
-macro.S
CONFLICT (content): Merge conflict in drivers/net/qlge/qlge_ethtool.c
CONFLICT (content): Merge conflict in drivers/net/qlge/qlge_main.c
CONFLICT (content): Merge conflict in drivers/net/typhoon.c
Merging audit/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging bluetooth/master
Merging fsnotify/for-next
CONFLICT (content): Merge conflict in fs/notify/inotify/inotify_user.c
CONFLICT (content): Merge conflict in include/linux/fsnotify.h
CONFLICT (content): Merge conflict in kernel/audit_tree.c
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging hwlat/for-linus
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging drbd/for-jens
Merging catalin/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
CONFLICT (content): Merge conflict in lib/Kconfig
Merging i7core_edac/linux_next
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging limits/writable_limits
CONFLICT (content): Merge conflict in arch/x86/ia32/ia32entry.S
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_32.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_64.h
CONFLICT (content): Merge conflict in arch/x86/kernel/syscall_table_32.S
Merging omap_dss2/for-next
Merging als/for-next
Merging tip/auto-latest
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/base/Kconfig
CONFLICT (content): Merge conflict in include/linux/device.h
Merging quilt/tty
Merging quilt/usb
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/ni_660=
x.c
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/ni_lab=
pc.c
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/pcmad.c
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/poc.c
CONFLICT (content): Merge conflict in drivers/staging/dream/camera/msm_came=
ra.c
CONFLICT (content): Merge conflict in drivers/staging/dream/camera/s5k3e2fx=
.c
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/hfa384x_usb.c
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/p80211conv.c
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/p80211metadef=
.h
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/p80211wext.c
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/prism2fw.c
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/prism2mib.c
Merging scsi-post-merge/master

--Signature=_Wed__10_Mar_2010_10_26_03_+1100_/dUS+xpQi.=RZFyV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuW2QsACgkQjjKRsyhoI8ziXQCfVcRnusAuOi1vp48xEDPaDR/G
COkAoJF6776AaW90mX7EI1n+34Ubb37X
=wHfQ
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Mar_2010_10_26_03_+1100_/dUS+xpQi.=RZFyV--
