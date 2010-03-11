Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab0CKRmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:42:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361Ab0CKRmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:42:19 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 11 Mar 2010 17:41:51 +0000
Message-Id: <1268329311.727.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following small fixes,

Steve.

------------------------------------------------------------------------------
The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Benjamin Marzinski (1):
      GFS2: Allow the number of committed revokes to temporarily be negative

Christoph Hellwig (1):
      GFS2: do not select QUOTA

Sachin Prabhu (1):
      GFS2: Skip check for mandatory locks when unlocking

 fs/gfs2/Kconfig  |    1 -
 fs/gfs2/file.c   |    2 +-
 fs/gfs2/incore.h |    2 +-
 fs/gfs2/log.c    |    3 +--
 4 files changed, 3 insertions(+), 5 deletions(-)


