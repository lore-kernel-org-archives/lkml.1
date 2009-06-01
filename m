Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbZFAK0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbZFAK0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbZFAK0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:26:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46748
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340AbZFAK0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:26:16 -0400
Date: Mon, 01 Jun 2009 03:26:16 -0700 (PDT)
Message-Id: <20090601.032616.120144677.davem@davemloft.net>
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


Two small sparc fixes, please pull, thanks!

The following changes since commit 3218911f839b6c85acbf872ad264ea69aa4d89ad:
  Linus Torvalds (1):
        Merge git://git.infradead.org/~dwmw2/mtd-2.6.30

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc64: Fix SET_PERSONALITY to not clip bits outside of PER_MASK.
      sparc64: Fix section attribute warnings.

 arch/sparc/include/asm/elf_64.h      |    5 +++--
 arch/sparc/lib/csum_copy_from_user.S |    2 +-
 arch/sparc/lib/csum_copy_to_user.S   |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)
