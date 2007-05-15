Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXEOSDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXEOSDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXEOSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:03:17 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:48263 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXEOSDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:03:16 -0400
Message-ID: <4649F5DC.87043316@users.sourceforge.net>
Date: Tue, 15 May 2007 21:03:08 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
Cc: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.2a file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- loop_twofish.c loop_serpent.c loop_blowfish.c modules included. They are
  not built by default. Add EXTRA_CIPHERS=y make parameter to build them.
- Makefile rewritten to always use kbuild method on 2.6 kernels.
- Work around invalidate_bdev() changes on recent 2.6 kernels.

bzip2 compressed tarball is here:

    http://osdn.dl.sourceforge.net/sourceforge/loop-aes/loop-AES-v3.2a.tar.bz2
    md5sum d0b5b0f104ce0e1ee9e3ba9608f24ec4

    http://osdn.dl.sourceforge.net/sourceforge/loop-aes/loop-AES-v3.2a.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
