Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZFSHIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZFSHIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZFSHIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:08:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34788
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbZFSHIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:08:11 -0400
Date: Fri, 19 Jun 2009 00:08:15 -0700 (PDT)
Message-Id: <20090619.000815.40596802.davem@davemloft.net>
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


Please pull to get this UP bootup failure fix.

Thanks!

The following changes since commit 0732f87761dbe417cb6e084b712d07e879e876ef:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../tytso/ext4

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git master

David S. Miller (1):
      sparc64: Fix UP bootup regression.

 arch/sparc/mm/init_64.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
