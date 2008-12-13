Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbYLMXkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbYLMXkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYLMXj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:39:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:44238 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYLMXjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:39:45 -0500
Date: Sat, 13 Dec 2008 17:39:01 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Paul Mackerras <paulus@samba.org>
cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Please pull from 'merge' for 2.6.28
Message-ID: <Pine.LNX.4.64.0812131735290.5685@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ab44f4627e2160cddbddbe8aa8b1d2b2e1559790:
  Paul Mackerras (1):
        Merge branch 'merge' of master.kernel.org:/.../galak/powerpc into merge

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git merge

Kumar Gala (1):
      powerpc/fsl-booke: Fix problem with _tlbil_va being interrupted

 arch/powerpc/kernel/misc_32.S |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

--

Commit 0ba3418b8b1c85ee1771c63f1dd12041614e56ff that went into 2.6.28
introduced the bug that this patch fixes.

- k
