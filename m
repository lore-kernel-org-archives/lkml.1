Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZBYHPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZBYHPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759765AbZBYHPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:15:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45613
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759661AbZBYHPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:15:35 -0500
Date: Tue, 24 Feb 2009 23:15:15 -0800 (PST)
Message-Id: <20090224.231515.26547714.davem@davemloft.net>
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


Please pull to get this crash fix.

Thanks!

The following changes since commit 694593e3374a67d95ece6a275a1f181644c2c4d8:
  Linus Torvalds (1):
        Merge branch 'proc-linus' of git://git.kernel.org/.../adobriyan/proc

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Fix crashes in jbusmc_print_dimm()

 arch/sparc/kernel/chmc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
