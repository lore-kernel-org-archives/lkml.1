Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZDBIhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZDBIhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbZDBIho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:37:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35866
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755772AbZDBIhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:37:43 -0400
Date: Thu, 02 Apr 2009 01:37:31 -0700 (PDT)
Message-Id: <20090402.013731.128363320.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hawk@comx.dk,
       paulmck@linux.vnet.ibm.com
Subject: [GIT]: RCU documentation
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these RCU documentation fixes from
Jesper Dangaard Brouer.

Thanks!

The following changes since commit 833bb3046b6cb320e775ea2160ddca87d53260d5:
  Alexey Dobriyan (1):
        serial: fixup /proc/tty/driver/serial after proc_fops conversion

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/rcu-doc-2.6.git master

Jesper Dangaard Brouer (3):
      Doc: Fix missing whitespaces in RCU documentation.
      Doc: Fix wrong API example usage of call_rcu().
      Doc: Fix spelling in RCU/rculist_nulls.txt.

 Documentation/RCU/listRCU.txt       |    6 +++---
 Documentation/RCU/rcu.txt           |    2 +-
 Documentation/RCU/rculist_nulls.txt |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)
