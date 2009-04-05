Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZDEO3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZDEO3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 10:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZDEO3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 10:29:22 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:58980 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZDEO3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 10:29:21 -0400
Date: Sun, 5 Apr 2009 16:27:51 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] CRIS updates
Message-ID: <20090405142750.GC29644@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The following changes since commit 15f7176eb1cccec0a332541285ee752b935c1c85:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://repo.or.cz/cris-mirror.git for-linus

Jesper Nilsson (2):
      CRISv32: Remove extraneous space between -I and the path.
      Merge branch 'master' of git://git.kernel.org/.../rusty/linux-2.6-cpumask-for-cris into for-next

Rusty Russell (3):
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: cris
      cpumask: Use accessors code.: cris
      cpumask: use mm_cpumask() wrapper: cris

Stoyan Gaydarov (1):
      BUG to BUG_ON changes

Thomas Gleixner (1):
      cris: convert obsolete hw_interrupt_type to struct irq_chip

 arch/cris/arch-v10/kernel/irq.c             |    2 +-
 arch/cris/arch-v32/boot/compressed/Makefile |    6 +++---
 arch/cris/arch-v32/kernel/irq.c             |    2 +-
 arch/cris/arch-v32/kernel/smp.c             |   10 +++++-----
 arch/cris/arch-v32/mm/tlb.c                 |    2 +-
 arch/cris/kernel/setup.c                    |    2 +-
 arch/cris/mm/init.c                         |    3 +--
 7 files changed, 13 insertions(+), 14 deletions(-)

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
