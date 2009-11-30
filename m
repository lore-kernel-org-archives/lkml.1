Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZK3WqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZK3WqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZK3WqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:46:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:53444 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZK3WqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:46:06 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@lists.ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 09:46:00 +1100
Message-ID: <1259621160.2076.155.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Please pull one patch from Becky to fix a build breakage in 2.6.32 with
CONFIG_DEBUG_HIGHMEM. This is, I believe, the same patch that went
into ARM to fix the same issue.

Cheers,
Ben.

The following changes since commit a8a8a669ea13d792296737505adc43ccacf3a648:
  Linus Torvalds (1):
        Merge branch 'i2c-pnx-fixes' of git://git.fluff.org/bjdooks/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Becky Bruce (1):
      powerpc: Fix DEBUG_HIGHMEM build break from d4515646699

 arch/powerpc/include/asm/kmap_types.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)


