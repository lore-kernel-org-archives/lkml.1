Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYB0HBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYB0HBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYB0HBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:01:14 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949AbYB0HBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:01:13 -0500
Date: Tue, 26 Feb 2008 23:00:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 27
Message-Id: <20080226230059.58cf3cfa.akpm@linux-foundation.org>
In-Reply-To: <20080227170300.25c50fe3.sfr@canb.auug.org.au>
References: <20080227170300.25c50fe3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 17:03:00 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> We are up to 35 trees, more are welcome (even if they are currently
> empty).

So who's missing now?

I have:

git-acpi
git-agpgart
git-alsa
git-arm
git-arm-master
git-audit-master
git-avr32
git-backlight
git-battery
git-block
git-bluetooth
git-cifs
git-cpufreq
git-cryptodev
git-drm
git-dvb
git-gfs2-nmw
git-hid
git-hrt
git-hwmon
git-ia64
git-ieee1394
git-infiniband
git-input
git-intelfb
git-jfs
git-jg-misc
git-kbuild
git-kvm
git-lblnet
git-leds
git-libata-all
git-m32r
git-md-accel
git-mips
git-mmc
git-mtd
git-net
git-nfs
git-nfsd
git-ntfs
git-ocfs2
git-parisc
git-pcmcia		(dead)
git-perfmon		(i don't actually include this)
git-powerpc
git-s390
git-sas			(might be dead)
git-sched
git-scsi-misc
git-scsi-rc-fixes
git-scsi-target
git-selinux
git-sh
git-slub
git-sparc64
git-ubi
git-unionfs
git-v9fs
git-watchdog
git-x86
git-xfs
git-xtensa


Plus quilt trees:

http://www.kernel.org/pub/linux/kernel/people/kristen/pci-hotplug (seems to be dead)
ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver-core
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-pci
http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/
ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
