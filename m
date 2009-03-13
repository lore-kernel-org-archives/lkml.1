Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZCMROl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZCMROl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZCMROb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:14:31 -0400
Received: from ns.suse.de ([195.135.220.2]:49487 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZCMROa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:14:30 -0400
Date: Fri, 13 Mar 2009 10:14:27 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git patches] Ocfs2 fixes
Message-ID: <20090313171427.GL17410@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c    |    3 ++-
 fs/ocfs2/aops.c     |    7 +++++--
 fs/ocfs2/namei.c    |    3 ++-
 fs/ocfs2/ocfs2_fs.h |    6 ------
 fs/ocfs2/xattr.c    |   30 ++++++++++++++++++++++++------
 5 files changed, 33 insertions(+), 16 deletions(-)

Tao Ma (2):
      ocfs2: Fix a bug found by sparse check.
      ocfs2: Use xs->bucket to set xattr value outside

Tiger Yang (2):
      ocfs2: reserve xattr block for new directory with inline data
      ocfs2: tweak to get the maximum inline data size with xattr

--
Mark Fasheh
