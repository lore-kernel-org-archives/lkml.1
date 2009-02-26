Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbZBZWeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbZBZWeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZBZWeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:34:10 -0500
Received: from gate.crashing.org ([63.228.1.57]:50631 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbZBZWeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:34:09 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 09:33:46 +1100
Message-Id: <1235687626.7388.26.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

And here's another little regression fix. For some reason, that one was
done and acked ages ago, marked "accepted" in patchwork and never
actually merged anywhere ... go figure.

The following changes since commit 64e71303e44f3697e4568147caa966de74bdb4fb:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../mason/btrfs-unstable

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      powerpc/44x: Fix address decoding setup of PCI 2.x cells

 arch/powerpc/sysdev/ppc4xx_pci.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)


