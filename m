Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0CNGl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 01:41:56 -0500
Received: from sh.osrg.net ([192.16.179.4]:44566 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab0CNGlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 01:41:53 -0500
Date: Sun, 14 Mar 2010 15:41:46 +0900 (JST)
Message-Id: <20100314.154146.220052544.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.34
From: Ryusuke Konishi <ryusuke@osrg.net>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 14 Mar 2010 15:41:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive the following patches.  All of these are trivial fixes.

Thanks!

Ryusuke Konishi
--
The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

Ryusuke Konishi (6):
      nilfs2: fix discrepancy in use of static specifier
      nilfs2: fix function name typos in docbook comments
      nilfs2: fix typo "cout" -> "count" in error message
      nilfs2: fix various typos in comments
      nilfs2: remove spaces before tabs
      nilfs2: remove whitespaces before quoted newlines

 fs/nilfs2/alloc.h     |    2 +-
 fs/nilfs2/dat.c       |    2 +-
 fs/nilfs2/dir.c       |    2 +-
 fs/nilfs2/gcinode.c   |    4 ++--
 fs/nilfs2/page.c      |    4 ++--
 fs/nilfs2/segbuf.c    |   10 +++++-----
 fs/nilfs2/segment.c   |    8 ++++----
 fs/nilfs2/segment.h   |    4 ++--
 fs/nilfs2/sufile.c    |    2 +-
 fs/nilfs2/super.c     |    4 ++--
 fs/nilfs2/the_nilfs.c |    2 +-
 11 files changed, 22 insertions(+), 22 deletions(-)
