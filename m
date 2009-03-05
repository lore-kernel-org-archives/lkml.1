Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZCETDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZCETDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZCETCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:02:51 -0500
Received: from thunk.org ([69.25.196.29]:53034 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZCETCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:02:51 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1LfIqE-0002Q0-3J@closure.thunk.org>
Date: Thu, 05 Mar 2009 14:02:46 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab a regression fix for ext4.  Thanks!!

                                                - Ted


Eric Sandeen (1):
      ext4: fix ext4_free_inode() vs. ext4_claim_inode() race

 fs/ext4/ialloc.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)
