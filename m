Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZCOSY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZCOSY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZCOSYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:24:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:42365 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZCOSYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:24:48 -0400
Date: Sun, 15 Mar 2009 11:23:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6.30] What's in the async boot tree
Message-ID: <20090315112345.764fc4ac@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 326d8519fc97be186c55ac605c3a7c957c758ae1:
  Linus Torvalds (1):
        Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-async-for-30.git master

Arjan van de Ven (2):
      async: remove the temporary (2.6.29) "async is off by default" code
      ide/net: flip the order of SATA and network init

Li, Shaohua (1):
      fastboot: remove duplicate unpack_to_rootfs()

 drivers/Makefile |    5 ++-
 init/initramfs.c |   71 ++++++++++++++++++++++++++++++++++++++++++-----------
 kernel/async.c   |   10 +-------
 3 files changed, 60 insertions(+), 26 deletions(-)


I will reply to this email with the three patches


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
