Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYEPW2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYEPW2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYEPW2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:28:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49708
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753392AbYEPW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:28:04 -0400
Date: Fri, 16 May 2008 15:27:58 -0700 (PDT)
Message-Id: <20080516.152758.224883399.davem@davemloft.net>
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


This fixes the regression reported by Mikael Pettersson,
which is in the 2.6.26-rcX regression list.

Please pull, thanks a lot!

The following changes since commit f26a3988917913b3d11b2bd741601a2c64ab9204:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../paulus/powerpc

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc64: Fix lmb_reserve() args in find_ramdisk().
      sparc64: Update defconfig.

 arch/sparc64/defconfig |   40 +++++++++++++++++++++++++++++++---------
 arch/sparc64/mm/init.c |    2 +-
 2 files changed, 32 insertions(+), 10 deletions(-)
