Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYEZGSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYEZGSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 02:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYEZGSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 02:18:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59774
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbYEZGSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 02:18:31 -0400
Date: Sun, 25 May 2008 23:18:27 -0700 (PDT)
Message-Id: <20080525.231827.50332094.davem@davemloft.net>
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


Please pull to get this fix from Adrian Bunk.

Thanks!

The following changes since commit ada44a0430fdd00b3f38aad0aa518e97cb760bd0:
  David S. Miller (1):
        sparc64: Prevent stack backtrace false positives on trap frames.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Adrian Bunk (1):
      sparc64: global_reg_snapshot is not for userspace

 include/asm-sparc64/ptrace.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)
