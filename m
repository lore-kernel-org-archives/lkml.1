Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZEZDvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZEZDvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 23:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZEZDvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 23:51:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:49203 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbZEZDvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 23:51:07 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 13:50:41 +1000
Message-Id: <1243309841.2858.60.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the first of two fixes for nasty brown paper bag bugs that went
in recently and are both my fault (I need to start buying those bags
in bulk I reckon...)

It's 2.6.30 material. I'll send the second one tomorrow or so after a
bit more review and testing happened as it's unfortunately more
invasive.

The following changes since commit b18f1e21993f73f072b1e0859f942fb11afddcb1:
  Linus Torvalds (1):
        Merge branch 'kvm-updates/2.6.30' of git://git.kernel.org/pub/scm/virt/kvm/kvm

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Hideo Saito (1):
      powerpc/mm: Fix broken MMU PID stealing on !SMP

 arch/powerpc/mm/mmu_context_nohash.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


