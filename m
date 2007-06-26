Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbXFZFL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbXFZFL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXFZFLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:11:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbXFZFLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:11:19 -0400
Date: Mon, 25 Jun 2007 22:10:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] Documentation/HOWTO: update URLs of git trees
Message-Id: <20070625221047.be7a3181.akpm@linux-foundation.org>
In-Reply-To: <tkrat.896aa9f24e1427a2@s5r6.in-berlin.de>
References: <tkrat.eee40c572537b7ba@s5r6.in-berlin.de>
	<20070619211555.GG3457@sequoia.sous-sol.org>
	<tkrat.896aa9f24e1427a2@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 23:45:58 +0200 (CEST) Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> On 19 Jun, Chris Wright wrote:
> > * Stefan Richter (stefanr@s5r6.in-berlin.de) wrote:
> >> +  Other kernel trees can be found listed at http://kernel.org/git and in
> > 
> > Should be http://git.kernel.org/ these days
> 
> Right.
> 
> 
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Subject: Documentation/HOWTO: update URLs of git trees
> 
> Also, remove outdated 1394 tree and mention MAINTAINERS as pointer to
> development trees.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  Documentation/HOWTO |   28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6.22-rc5/Documentation/HOWTO
> ===================================================================
> --- linux-2.6.22-rc5.orig/Documentation/HOWTO
> +++ linux-2.6.22-rc5/Documentation/HOWTO
> @@ -322,39 +322,34 @@ kernel releases as described above.
>  Here is a list of some of the different kernel trees available:
>    git trees:
>      - Kbuild development tree, Sam Ravnborg <sam@ravnborg.org>
> -	kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
> +	git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
>  
>      - ACPI development tree, Len Brown <len.brown@intel.com>
> -	kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
> +	git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
>  
>      - Block development tree, Jens Axboe <axboe@suse.de>
> -	kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
> +	git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
>  
>      - DRM development tree, Dave Airlie <airlied@linux.ie>
> -	kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> +	git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
>  
>      - ia64 development tree, Tony Luck <tony.luck@intel.com>
> -	kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
> -
> -    - ieee1394 development tree, Jody McIntyre <scjody@modernduck.com>
> -	kernel.org:/pub/scm/linux/kernel/git/scjody/ieee1394.git
> +	git.kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
>  
>      - infiniband, Roland Dreier <rolandd@cisco.com>
> -	kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
> +	git.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
>  
>      - libata, Jeff Garzik <jgarzik@pobox.com>
> -	kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> +	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>  
>      - network drivers, Jeff Garzik <jgarzik@pobox.com>
> -	kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
> +	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
>  
>      - pcmcia, Dominik Brodowski <linux@dominikbrodowski.net>
> -	kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
> +	git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
>  
>      - SCSI, James Bottomley <James.Bottomley@SteelEye.com>
> -	kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> -
> -  Other git kernel trees can be found listed at http://kernel.org/git
> +	git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
>  

rofl.  You want git trees?  I got git trees:

git://electric-eye.fr.zoreil.com/home/romieu/linux-2.6.git#8139cp
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git#test
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davej/agpgart.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/perex/alsa.git#mm
git+ssh://master.kernel.org/home/rmk/linux-2.6-arm.git#devel
git+ssh://master.kernel.org/home/rmk/linux-2.6-arm.git#master
git+ssh://master.kernel.org/home/rmk/linux-2.6-arm-smp.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git#audit.b37
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm
git://www.atmel.no/~hskinnemoen/linux/kernel/avr32.git#avr32-arch
git://git.o-hand.com/linux-rpurdie-backlight#for-mm
git://git.infradead.org/users/cbou/battery2-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#for-akpm
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/block.git#block-fixes
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#cfq
git://electric-eye.fr.zoreil.com/home/romieu/linux-2.6.git#chelsio
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
http://oss.oracle.com/git/ocfs2-dev.git/
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davej/x86.git
git://lost.foo-projects.org/~dwillia2/git/iop#md-accel-2.6.20-rc5
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git#drm-mm
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git#drm-initmap
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git#drm-via
git+ssh://master.kernel.org/home/rmk/linux-2.6-drvmodel.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git#devel
git://lost.foo-projects.org/~ahkok/git/netdev-2.6#mm
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git#gccbug
git://git.infradead.org/users/jcrouse/geode.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/gpu-2.6#gpu-branch
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/gregkh/linux-2.6.git/
git://git.infradead.org/hdrcleanup-2.6.git
git://git.infradead.org/hdrinstall2-2.6.git
git://git.infradead.org/hdrinstall-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git#mm
git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git#testing
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git#test
git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git#for-upstream/mm
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git#for-mm
git://www.mellanox.co.il/~git/infiniband#mst-for-2.6.18
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/intelfb-2.6#intelfb-mm
git://lost.foo-projects.org/~cleech/linux-2.6#master
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/herbert/ipsec-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git#ipw-devel
git://git.infradead.org/~dhowells/irq-2.6.git
git://lost.foo-projects.org/~aveerani/git/linux-2.6#ixgbe
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git#for-mm
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-klibc.git
git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git#master
git://git.o-hand.com/linux-rpurdie-leds#for-mm
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#adma
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#adma-mwi
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#ahci-msi
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#ALL
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#bridge-detect
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#chs-support
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#docs
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#ncq
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#passthru
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#pdc2027x
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#promise-sata-pata
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#svw
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#upstream
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#upstream-2.6.13
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-2.6.git#upstream-fixes
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/lxdialog.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git#magic
http://bu3sch.de/git/wireless-dev.git
git://lost.foo-projects.org/~dwillia2/git/iop#md-accel-linus
git://www.linux-mips.org/pub/scm/upstream.git#for-akpm
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git#for-andrew
git://git.infradead.org/mtd-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.23.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#8139cp
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#8139too-iomap
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#airo
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#ALL
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#amd8111
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#atmel
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#chelsio
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#dm9000
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#e100
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#e1000
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#forcedeth
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#for-linus
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#hdlc
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#ieee80211
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#ieee80211-wifi
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#iff-running
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#ixgb
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#janitor
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#master
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#natsemi
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#ns83820
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#orinoco
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#orinoco-hch
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#ppp
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#qeth
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#r8169
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#register-netdev
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#remove-drivers
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#sis190
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#sis900
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#skge
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#smc91x
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#smc91x-eeprom
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#starfire
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#tlan
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#upstream
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#upstream-fixes
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#veth
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#viro
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#we18
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#we18-ieee80211
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#we18-ieee80211-wifi
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git#wifi
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-newsetup.git
git://git.linux-nfs.org/pub/linux/nfs-2.6.git
git://git.linux-nfs.org/~bfields/linux.git#server-cluster-locking-api
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/dhowells/nommu-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6-devel.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git#ALL
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git#master
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git#pciseg
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git/
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git
git://electric-eye.fr.zoreil.com/home/romieu/linux-2.6.git#qla3xxx
git://electric-eye.fr.zoreil.com/home/romieu/linux-2.6.git#r8169
git://git.infradead.org/users/dwmw2/rbtree-2.6.git
git+ssh://master.kernel.org/home/rmk/linux-2.6-rmk.git
git://git390.osdl.marist.edu/pub/scm/linux-2.6.git#for-andrew
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jejb/aic94xx-sas-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/sas-2.6.git#ALL
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-block-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-iscsi-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-target.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-net-2.6.git
git+ssh://master.kernel.org/home/rmk/linux-2.6-serial.git#devel
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lethal/sh64-2.6.git
git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git#v2.6.18-rc5-mm1
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#splice
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git#stex
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/willy/sym2.git
git://git.infradead.org/~dedekind/ubi-2.6.git
git+ssh://master.kernel.org/home/rmk/linux-2.6-ucb.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git#v9fs-devel
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#endian.b22
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#fixes.b21
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#frv.b22
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#m32r.b14
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#m68k.b22
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#misc.b22
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#net.b14
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#net-endian.b18
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#uml.b21
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#upf.b14
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#volatile.b22
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/viro/bird.git#xfs.b14
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/chrisw/virt-2.6.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog-mm.git
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git#mm-master
git://oss.sgi.com:8090/xfs/xfs-2.6
git://git.linux-xtensa.org/kernel/xtensa-feed
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

A lot of them are dead (thankfully).

Probably a good way of finding all the live ones is to poke around in -mm's
git-*.patch.  But that doesn't include all the currently-empty trees.


