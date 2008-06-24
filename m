Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYFXVOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYFXVOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYFXVOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:14:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYFXVOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:14:42 -0400
Subject: [GFS2] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Tue, 24 Jun 2008 22:12:47 +0100
Message-Id: <1214341967.4266.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 bug fixes,

Steve.

-------------------------------------------------------------------------------------
The following changes since commit 62786b9e81a2dbe9c073a2ade52d33a2627d6d85:
  Linus Torvalds (1):
        Merge branch 'hotfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git

Benjamin Marzinski (1):
      [GFS2] fix gfs2 block allocation (cleaned up)

Bob Peterson (1):
      [GFS2] BUG: unable to handle kernel paging request at ffff81002690e000

 fs/gfs2/bmap.c |   23 +++++++++--------------
 fs/gfs2/rgrp.c |    2 +-
 2 files changed, 10 insertions(+), 15 deletions(-)


