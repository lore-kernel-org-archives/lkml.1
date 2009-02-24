Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbZBXRUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbZBXRUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbZBXRT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:19:59 -0500
Received: from thunk.org ([69.25.196.29]:34839 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337AbZBXRT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:19:58 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Lc0wf-0002En-Ry@closure.thunk.org>
Date: Tue, 24 Feb 2009 12:19:49 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab two critical bug fixes for ext4.  Thanks!!

						- Ted

Jan Kara (1):
      ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()

Theodore Ts'o (1):
      ext4: Add fallback for find_group_flex

 fs/ext4/ialloc.c |    7 +++++++
 fs/ext4/inode.c  |    9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)


