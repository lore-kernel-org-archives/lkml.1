Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZDUJTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZDUJTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZDUJTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:19:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32788 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbZDUJTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:19:35 -0400
Subject: GFS2: Pull request (small fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Tue, 21 Apr 2009 10:19:47 +0100
Message-Id: <1240305587.3080.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following two small fixes,

Steve.

-------------------------------------------------------------------------------
The following changes since commit 3ee8da87ba6151ec91b2b8bbd27633bb248ea0d5:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (2):
      GFS2: Clear dirty bit at end of inode glock sync
      GFS2: Fix page_mkwrite() return code

 fs/gfs2/glops.c    |    6 ++++++
 fs/gfs2/ops_file.c |    4 +++-
 2 files changed, 9 insertions(+), 1 deletions(-)


