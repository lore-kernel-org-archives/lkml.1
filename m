Return-Path: <linux-kernel-owner+w=401wt.eu-S1761150AbZC1BTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150AbZC1BTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 21:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZC1BTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 21:19:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33263
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbZC1BSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 21:18:55 -0400
Date: Fri, 27 Mar 2009 18:18:43 -0700 (PDT)
Message-Id: <20090327.181843.208533325.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two bug fixes for sparc64.

Please pull, thanks a lot!

The following changes since commit 0b4d569de222452bcb55a4a536ade6cf4d8d1e30:
  Linus Torvalds (1):
        i915: fix wrong 'size_t' format string

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (3):
      sparc64: Fix MM refcount check in smp_flush_tlb_pending().
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      sparc64: We need to use compat_sys_ustat() as well.

 arch/sparc/kernel/smp_64.c     |    4 ++--
 arch/sparc/kernel/systbls_64.S |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)
