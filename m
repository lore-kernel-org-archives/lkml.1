Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab0BLLeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:34:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0BLLem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:34:42 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 12 Feb 2010 11:37:54 +0000
Message-ID: <1265974674.2508.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes,

Steve.

-----------------------------------------------------------------------------
The following changes since commit 676ad585531e965416fd958747894541dabcec96:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Abhijith Das (1):
      GFS2: Fix error code

Steven Whitehouse (1):
      GFS2: Fix bmap allocation corner-case bug

 fs/gfs2/bmap.c       |    2 +-
 fs/gfs2/ops_fstype.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


