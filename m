Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbXCRJmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbXCRJmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 05:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXCRJmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 05:42:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34033 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753220AbXCRJmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 05:42:45 -0400
Date: Sun, 18 Mar 2007 10:42:48 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.44-rc2
Message-ID: <20070318094248.GP752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.43:
- CVE-2007-0005: Fix buffer overflow in Omnikey CardMan 4040 driver
- CVE-2007-1000: [IPV6]: Handle np->opt being NULL in ipv6_getsockopt_sticky().


Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git


Changes since 2.6.16.44-rc1:

Adrian Bunk (1):
      Linux 2.6.16.44-rc2

Hugh Dickins (1):
      pwc-uncompress.c shouldn't #include <asm/current.h>


 Makefile                               |    2 +-
 drivers/usb/media/pwc/pwc-uncompress.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

