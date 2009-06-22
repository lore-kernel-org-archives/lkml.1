Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZFVJmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZFVJmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbZFVJmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:42:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46148
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175AbZFVJmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:42:12 -0400
Date: Mon, 22 Jun 2009 02:42:16 -0700 (PDT)
Message-Id: <20090622.024216.03098051.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE fixes
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Update MAINTAINERS

2) Initial cmd64x regression fix, there are more funnies but
   we'll track it down.

Please pull, thanks!

The following changes since commit f234012f52a37e48f2330e1ca2df69800e797c3b:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../drzeus/mmc

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

David S. Miller (2):
      ide: Take over as maintainer.
      ide cmd64x: Remove serialize setting.

 MAINTAINERS          |    6 +++---
 drivers/ide/cmd64x.c |    3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)
