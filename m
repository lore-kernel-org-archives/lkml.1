Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbZIOTzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbZIOTzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbZIOTzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:55:01 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57697 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbZIOTzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:55:00 -0400
Date: Tue, 15 Sep 2009 21:55:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block !CONFIG_BLOCK link problem
Message-ID: <20090915195503.GW23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This fixes a linkage problem with !CONFIG_BLOCK and iopoll.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      block: fix linkage problem with blk_iopoll and !CONFIG_BLOCK

 kernel/sysctl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

-- 
Jens Axboe

