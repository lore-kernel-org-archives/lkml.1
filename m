Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbZGaGAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbZGaGAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 02:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZGaGAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 02:00:19 -0400
Received: from relay3.sgi.com ([192.48.156.57]:49640 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750865AbZGaGAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 02:00:18 -0400
Date: Fri, 31 Jul 2009 01:00:15 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.31-rc5
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090731060015.45A8FA23CA6C@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b592972493c38665efd7d429a01b23fcb21e331a:
  Linus Torvalds (1):
        Merge branch 'tracing-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Eric Sandeen (2):
      xfs: reduce bmv_count in xfs_vn_fiemap
      xfs: bump up nr_to_write in xfs_vm_writepage

 fs/xfs/linux-2.6/xfs_aops.c |    8 ++++++++
 fs/xfs/linux-2.6/xfs_iops.c |    4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)
