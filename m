Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbZIYVaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbZIYVaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 17:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZIYVav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 17:30:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45367
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZIYVau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 17:30:50 -0400
Date: Fri, 25 Sep 2009 14:31:09 -0700 (PDT)
Message-Id: <20090925.143109.189133359.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this sparc bug fix.

Thanks!

The following changes since commit df58bee21ed218cb7dfb561a590b1bd2a99531cf:
  Linus Torvalds (1):
        Merge branch 'x86-mce-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: vio: Kill BUILD_BUG_ON() in vio_dring_avail().

 arch/sparc/include/asm/vio.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
