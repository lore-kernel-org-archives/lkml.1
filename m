Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZIAWGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZIAWGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZIAWGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:06:21 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42271 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752527AbZIAWGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:06:21 -0400
Date: Tue, 01 Sep 2009 17:06:12 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.31
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090901220612.BED9AA23CA70@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 37d0892c5a94e208cf863e3b7bac014edee4346d:
  Ian Kent (1):
        autofs4 - fix missed case when changing to use struct path

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: actually enable the swapext compat handler

 fs/xfs/linux-2.6/xfs_ioctl32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
