Return-Path: <linux-kernel-owner+w=401wt.eu-S1760961AbYDYKZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961AbYDYKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYDYKZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:25:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35705
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754865AbYDYKZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:25:12 -0400
Date: Fri, 25 Apr 2008 03:25:11 -0700 (PDT)
Message-Id: <20080425.032511.194165274.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull, to get these two sparc bug fixes.

Thanks!

The following changes since commit b69d3987f4360a5e7e9e55465b3cdd0cc204b79e:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../x86/linux-2.6-x86-fixes

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      [SPARC64]: Fix args to 64-bit sys_semctl() via sys_ipc().
      [SPARC64]: Wrap SMP IPIs with irq_enter()/irq_exit().

 arch/sparc64/kernel/smp.c       |   27 ++++++++++++++++++++++-----
 arch/sparc64/kernel/sys_sparc.c |    4 ++--
 2 files changed, 24 insertions(+), 7 deletions(-)
