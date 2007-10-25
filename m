Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbXJYSst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbXJYSst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXJYSsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:48:41 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:32884 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbXJYSsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:48:40 -0400
X-Greylist: delayed 720 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 14:48:40 EDT
Message-ID: <4720E230.C05B9252@users.sourceforge.net>
Date: Thu, 25 Oct 2007 21:36:32 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
Cc: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.2b file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Fixed compatibility detection problem involving separate obj/source trees.
- Fixed request size problem on unencrypted device backed USB device.
- Added initramfs type initrd build option to build-initrd.sh script. Patch
  from Fix pr0gress0r AT ngs.ru
- Added gcc version override option to build-initrd.sh script.
- Fixed losetup -P cleartext key option which always failed to work and
  printed error message saying so.
- Added util-linux-ng patch.
- Worked around block layer interface breakage on linux-2.6.24-rc1 kernel.

bzip2 compressed tarball is here:

    http://dl.sourceforge.net/sourceforge/loop-aes/loop-AES-v3.2b.tar.bz2
    md5sum 2c5642ccfa1a780ef4bd76eb873076aa

    http://dl.sourceforge.net/sourceforge/loop-aes/loop-AES-v3.2b.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
