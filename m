Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZJ3S5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZJ3S5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbZJ3S5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:57:35 -0400
Received: from relay2.sgi.com ([192.48.179.30]:46233 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757342AbZJ3S5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:57:35 -0400
Date: Fri, 30 Oct 2009 13:57:35 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <200910301857.n9UIvZ6w009983@stout.americas.sgi.com>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS (2 regression fixes)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Christoph Hellwig sent a pull request for these patches from
the xfs-dev tree on kernel.org earlier today.  (Pointing this out to
hopefully avoid confusion.)

					-Alex

The following changes since commit 2e2ec952350f25242f2e0539db16b1e46f9eb01b:
  Linus Torvalds (1):
        Merge branch 'bugfix' of git://git.kernel.org/.../jeremy/xen

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (2):
      Merge branch 'master' of ssh://oss.sgi.com/oss/git/xfs/xfs into for-linus
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6 into for-linus

Eric Sandeen (1):
      xfs: free temporary cursor in xfs_dialloc

Ryota Yamauchi (1):
      xfs: fix xfs_quota remove error

 fs/xfs/linux-2.6/xfs_quotaops.c |    2 +-
 fs/xfs/xfs_ialloc.c             |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)
