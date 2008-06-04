Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbYFDX43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbYFDX43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757599AbYFDX4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:56:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39628
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756517AbYFDX4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:56:21 -0400
Date: Wed, 04 Jun 2008 16:56:21 -0700 (PDT)
Message-Id: <20080604.165621.84201273.davem@davemloft.net>
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


Please pull to get these sparc updates.

Thanks!

The following changes since commit 551dec47bb5964478db594385a896eb0d4ab2b0a:
  Adrian Bunk (1):
        sparc64: global_reg_snapshot is not for userspace

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Alexey Dobriyan (1):
      sparc: switch /proc/led to seq_file

Benjamin Herrenschmidt (1):
      sparc64: IO accessors fix

 arch/sparc/kernel/led.c  |   34 ++++++++++++++---------
 include/asm-sparc64/io.h |   66 ++++++++++++++++++++++++++++++---------------
 2 files changed, 65 insertions(+), 35 deletions(-)
