Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbYBYWRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbYBYWRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbYBYWRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:17:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbYBYWRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:17:31 -0500
Subject: [GIT PULL] lockdep updates
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 23:17:08 +0100
Message-Id: <1203977828.6242.220.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull a few lockdep patches from:

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git v2.6.25-rc3-lockdep

---
Dale Farnsworth (1):
      Subject: lockdep: include all lock classes in all_lock_classes

Peter Zijlstra (1):
      lockdep: increase MAX_LOCK_DEPTH

 include/linux/sched.h |    2 +-
 kernel/lockdep.c      |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)


