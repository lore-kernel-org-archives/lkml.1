Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752782AbYLRD5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYLRD5l (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 22:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYLRD5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 22:57:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32948
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbYLRD5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 22:57:30 -0500
Date: Wed, 17 Dec 2008 19:57:31 -0800 (PST)
Message-Id: <20081217.195731.135166724.davem@davemloft.net>
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


Please pull to get this ptrace handling bug fix.

Thanks!

The following changes since commit 410d2c8187ed969238ba98008c1d57307a56cfd8:
  Hong H. Pham (1):
        sparc64: Sync FPU state in VIS emulation handler.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc: We need to implement arch_ptrace_stop().

 arch/sparc/include/asm/ptrace_32.h |   10 ++++++++++
 arch/sparc/include/asm/ptrace_64.h |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)
