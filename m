Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYHVMnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYHVMnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbYHVMmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:42:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986AbYHVMmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:42:14 -0400
Date: Fri, 22 Aug 2008 14:42:10 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng v2.14.1-rc2
Message-ID: <20080822124210.GF6029@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The second util-linux-ng 2.14.1 release candidate is available at

    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/

(Note that 2.14.1 is stable maintenance release.)

Feedback and bug reports, as always, are welcomed.


	Karel



Util-linux-ng 2.14.1 Release Notes
==================================

ChangeLog between v2.14 and v2.14.1
-----------------------------------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.14/

build-sys:
   - cleanup sys-utils/Makefile.am  [Karel Zak]
   - fix dmesg.1 installation  [Karel Zak]
   - release++ (v2.14.1-rc1)  [Karel Zak]
   - tgets is not in ncurses but in tinfo  [Arkadiusz Miskiewicz]
docs:
   - update AUTHORS file  [Karel Zak]
   - update v2.14.1 ReleaseNotes  [Karel Zak]
fdisk:
   - don't check for GPT when asked for disk size only  [Karel Zak]
hwclock:
   - omit warning about drift if --noadjfile given  [Matthias Koenig]
   - unshadow a diagnostic printf  [Kalev Soikonen]
ipcs:
   - ungettextize the spacing of the table headers  [Benno Schulenberg]
losetup:
   - remove unnecessary minor number check  [Karel Zak]
mount:
   - add docs about utf8=0 for vfat  [Karel Zak]
   - add fallback for versionsort()  [Karel Zak]
   - add info about tz=UTC option for FAT to mount.8  [Karel Zak]
   - add norealtime to mount.8  [Karel Zak]
po:
   - add zh_CN.po (from translationproject.org)  [Ray Wang]
   - merge changes  [Karel Zak]
   - update cs.po (from translationproject.org)  [Petr Pisar]
   - update nl.po (from translationproject.org)  [Benno Schulenberg]
rtcwake:
   - cleanup return codes  [Karel Zak]
   - prefer RTC_WKALM_SET over RTC_ALM_SET  [Gabriel Burt]
scriptreplay:
   - new implementation is out-of-sync  [Karel Zak]
selinux:
   - is_selinux_enabled() returns 0, 1 and -1  [Karel Zak]
sfdisk:
   - print version should end with a newline  [Denis ChengRq]
umount:
   - improve "-d" option for autoclear loops  [Karel Zak]
write:
   - doesn't check for tty group  [Karel Zak]
-- 
 Karel Zak  <kzak@redhat.com>
