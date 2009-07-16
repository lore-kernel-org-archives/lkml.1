Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZGPIBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZGPIBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZGPIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:01:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:34681 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbZGPIBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:01:12 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 18:00:58 +1000
Message-Id: <1247731258.27937.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a couple of fixes for powerpc for 2.6.31.

The following changes since commit e9e961c9a818a2f24711af493b907a8e40a69efc:
  Linus Torvalds (1):
        Merge branch 'i2c-for-2631-rc3' of git://aeryn.fluff.org.uk/bjdooks/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Andreas Schwab (1):
      powerpc: Fix another bug in move of altivec code to vector.S

Dave Kleikamp (1):
      powerpc: Fix booke user_disable_single_step()

 arch/powerpc/kernel/ptrace.c |   17 +++++++++--------
 arch/powerpc/kernel/vector.S |    6 +++---
 2 files changed, 12 insertions(+), 11 deletions(-)


