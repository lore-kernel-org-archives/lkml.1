Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167Ab0AZMSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0AZMSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178Ab0AZMSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:18:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40847
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772Ab0AZMSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:18:00 -0500
Date: Tue, 26 Jan 2010 04:18:12 -0800 (PST)
Message-Id: <20100126.041812.00806455.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc build fix
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this sparc64 UP build fix.

Thanks!

The following changes since commit 9a3cbe3265c7714e8ee423feb6e27a080af79608:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../tytso/ext4

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Fix UP build.

 arch/sparc/kernel/irq_64.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)
