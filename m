Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab0BDKDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 05:03:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab0BDKDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 05:03:34 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 04 Feb 2010 10:06:19 +0000
Message-ID: <1265277979.2437.15.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following two changes,

Steve.

----------------------------------------------------------------------------
The following changes since commit 1a45dcfe2525e9432cb4aba461d4994fc2befe42:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (2):
      GFS2: Wait for unlock completion on umount
      GFS2: Extend umount wait coverage to full glock lifetime

 fs/gfs2/glock.c      |    4 ++++
 fs/gfs2/glock.h      |    2 +-
 fs/gfs2/incore.h     |    2 ++
 fs/gfs2/lock_dlm.c   |   11 ++++++++---
 fs/gfs2/ops_fstype.c |   12 +++++++++++-
 fs/gfs2/super.c      |    1 +
 6 files changed, 27 insertions(+), 5 deletions(-)


