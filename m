Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbZIFVNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbZIFVNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbZIFVN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:13:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53667
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758707AbZIFVN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:13:28 -0400
Date: Sun, 06 Sep 2009 14:13:44 -0700 (PDT)
Message-Id: <20090906.141344.140762454.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this device ID addition which fixes a
bugzilla.

Thanks!

The following changes since commit e07cccf4046978df10f2e13fe2b99b2f9b3a65db:
  Linus Torvalds (1):
        Linux 2.6.31-rc9

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Wolfram Sang (1):
      pcmcia: add CNF-CDROM-ID for ide

 drivers/ide/ide-cs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
