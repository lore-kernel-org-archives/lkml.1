Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbXBWSus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbXBWSus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbXBWSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:50:48 -0500
Received: from mail.tnnet.fi ([217.112.240.26]:38503 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596AbXBWSur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:50:47 -0500
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 13:50:46 EST
Message-ID: <45DF319E.3157C85A@users.sourceforge.net>
Date: Fri, 23 Feb 2007 20:25:34 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
Cc: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.1f file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Work around dash /bin/sh shell and make-3.81 incompatibilities.
- Work around block layer breakage in 2.6.20-rcX-mmX kernels.
- Added "cleartextkey=file" mount option to mount, and "-P file" command
  line option to losetup. These options help automounters.
- Added loop-aes-keygen script from Max Vozeler.

bzip2 compressed tarball is here:

    http://osdn.dl.sourceforge.net/sourceforge/loop-aes/loop-AES-v3.1f.tar.bz2
    md5sum 1020b93d723f1d573bacfe4a3362fc25

    http://osdn.dl.sourceforge.net/sourceforge/loop-aes/loop-AES-v3.1f.tar.bz2.sign


Additional ciphers package changes since previous release:
- Work around dash /bin/sh shell and make-3.81 incompatibilities.

bzip2 compressed tarball is here:

    http://osdn.dl.sourceforge.net/sourceforge/loop-aes/ciphers-v3.0e.tar.bz2
    md5sum 10aeb23387a1e2d635cfe9345c21b444

    http://osdn.dl.sourceforge.net/sourceforge/loop-aes/ciphers-v3.0e.tar.bz2.sign

Note: As of this writing, files at http://loop-aes.sourceforge.net/ have not
been updated yet.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
