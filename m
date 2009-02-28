Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZB1OoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZB1OoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 09:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZB1OoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 09:44:09 -0500
Received: from thunk.org ([69.25.196.29]:50288 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZB1OoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 09:44:08 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1LdQQ5-0004kd-OD@closure.thunk.org>
Date: Sat, 28 Feb 2009 09:44:01 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab two two more bug fixes for ext4.  Thanks!!

                                                - Ted

Theodore Ts'o (2):
      ext4: Remove duplicate call to ext4_commit_super() in ext4_freeze()
      ext4: Reorder fs/Makefile so that ext2 root fs's are mounted using ext2

 fs/Makefile     |    6 ++++--
 fs/ext4/super.c |    1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

