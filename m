Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYIVXSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYIVXSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYIVXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:18:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51476
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbYIVXSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:18:13 -0400
Date: Mon, 22 Sep 2008 16:18:01 -0700 (PDT)
Message-Id: <20080922.161801.193342191.davem@davemloft.net>
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


This fixes another missing PCI device bug on sparc64 which
was reported (and successfully tested) by Meelis Roos.

Please pull, thanks a lot!

The following changes since commit 7ee766d8fba9dfd93bf3eca7a8d84a25404a68dc:
  David S. Miller (1):
        sparc64: Fix disappearing PCI devices on e3500.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Fix missing devices due to PCI bridge test in of_create_pci_dev().

 arch/sparc64/kernel/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
