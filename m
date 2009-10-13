Return-Path: <linux-kernel-owner+w=401wt.eu-S934325AbZJMVKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325AbZJMVKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934181AbZJMVKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:10:34 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41221 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934174AbZJMVKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:10:34 -0400
Date: Tue, 13 Oct 2009 16:09:41 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <200910132109.n9DL9fh8007576@stout.americas.sgi.com>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS bugfix update for 2.6.32
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 80f506918fdaaca6b574ba931536a58ce015c7be:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'master' of ssh://oss.sgi.com/oss/git/xfs/xfs into for-linus

Christoph Hellwig (1):
      xfs: fix double IRELE in xfs_dqrele_inode

 fs/xfs/quota/xfs_qm_syscalls.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
