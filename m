Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYJ1N3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYJ1N3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYJ1N2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:28:53 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:55794 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYJ1N2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:28:52 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 09:28:52 EDT
Message-ID: <4907116F.EA26D98A@users.sourceforge.net>
Date: Tue, 28 Oct 2008 15:19:43 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.2d file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Worked around minix mkfs regression in build-initrd.sh script. Fix from
  Boris Wesslowski.
- Added -f option to losetup. Patch from Max Vozeler.
- Worked around block layer interface breakage on linux-2.6.28-rc kernels.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.2d.tar.bz2
    md5sum 8fc224978ee1f53c07a3771e733b777c

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.2d.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
