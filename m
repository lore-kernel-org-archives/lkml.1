Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZCZJJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZCZJJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbZCZJIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:08:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57542
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756195AbZCZJI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:08:29 -0400
Date: Thu, 26 Mar 2009 02:08:15 -0700 (PDT)
Message-Id: <20090326.020815.59259688.davem@davemloft.net>
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


Just a bug fix for a TLB issue noticed by Ben H.

Please pull, thanks a lot!

The following changes since commit 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84:
  Linus Torvalds (1):
        Linux 2.6.29

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Flush TLB before releasing pages.

 arch/sparc/include/asm/tlb_64.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
