Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0BSH3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 02:29:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39469
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754631Ab0BSH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 02:29:13 -0500
Date: Thu, 18 Feb 2010 23:29:28 -0800 (PST)
Message-Id: <20100218.232928.193699814.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these sparc bug fixes.

Thanks!

The following changes since commit b0483e78e5c4c9871fc5541875b3bc006846d46b:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/tty-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (3):
      sparc64: Tighten checks in kstack_valid().
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      sparc64: Sync of_create_pci_dev() with drivers/pci/probe.c changes.

Kristoffer Glembo (1):
      sparc: Fix incorrect comparison in of_bus_ambapp_match()

 arch/sparc/kernel/kstack.h       |    4 ++++
 arch/sparc/kernel/of_device_32.c |    2 +-
 arch/sparc/kernel/pci.c          |    7 +++++++
 3 files changed, 12 insertions(+), 1 deletions(-)
