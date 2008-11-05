Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYKETaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYKETaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYKET3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:29:54 -0500
Received: from mail.tnnet.fi ([217.112.240.26]:51241 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbYKET3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:29:54 -0500
Message-ID: <4911F429.17BD536B@users.sourceforge.net>
Date: Wed, 05 Nov 2008 21:29:45 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.2e file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Fix null pointer dereference when loop was used to mount iso9660 CD-ROM
  image. This new bug was introduced in loop-AES-v3.2d, earlier versions are
  ok. Thanks to Peter Koek for reporting this issue.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.2e.tar.bz2
    md5sum bfc75a2bec78dbd5c8b5096bf06716d5

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.2e.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
