Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbZEVGLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbZEVGLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZEVGLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:11:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:42883 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZEVGLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:11:36 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 May 2009 16:11:26 +1000
Message-Id: <1242972686.26104.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a small fix for .30 that works around a regression caused by
enabling MSI support in the IPR driver.

Cheers,
Ben.

The following changes since commit 5805977e63a36ad56594a623f3bd2bebcb7db233:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Michael Ellerman (1):
      powerpc/maple: Add a quirk to disable MSI for IPR on Bimini

 arch/powerpc/platforms/maple/pci.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)


