Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbYGXG1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbYGXG1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 02:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYGXG12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 02:27:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52257
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbYGXG1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 02:27:17 -0400
Date: Wed, 23 Jul 2008 23:27:17 -0700 (PDT)
Message-Id: <20080723.232717.70515243.davem@davemloft.net>
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


Please pull to get these two sparc bug fixes.

Thanks!

The following changes since commit 4a0a088970a553e9f89d23eec688932f689d57f9:
  Stephen Rothwell (1):
        sparc32: pass -m32 when building vmlinux.lds

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc64: Fix lockdep issues in LDC protocol layer.
      sparc64: Fix cpufreq notifier registry.

 arch/sparc64/kernel/irq.c  |   10 +++++++++-
 arch/sparc64/kernel/ldc.c  |   38 +++++++++++++++++++-------------------
 arch/sparc64/kernel/time.c |   15 ++++++++++-----
 3 files changed, 38 insertions(+), 25 deletions(-)
