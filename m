Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYGYWVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYGYWVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYGYWVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:21:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46190
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbYGYWVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:21:02 -0400
Date: Fri, 25 Jul 2008 15:21:00 -0700 (PDT)
Message-Id: <20080725.152100.193704807.davem@davemloft.net>
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


This just wires up the new system calls.

Please pull, thanks a lot!

The following changes since commit fb2e405fc1fc8b20d9c78eaa1c7fd5a297efde43:
  Adrian Bunk (1):
        fix fs/nfs/nfsroot.c compilation

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc: Wire up new system calls.

 arch/sparc/kernel/systbls.S   |    3 ++-
 arch/sparc64/kernel/systbls.S |    6 ++++--
 include/asm-sparc/unistd_32.h |    8 +++++++-
 include/asm-sparc/unistd_64.h |    8 +++++++-
 4 files changed, 20 insertions(+), 5 deletions(-)
