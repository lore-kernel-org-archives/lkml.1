Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbYETKHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbYETKHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762116AbYETKHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:07:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761646AbYETKHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:07:35 -0400
Subject: [GFS2] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1211274764371-git-send-email-swhiteho@redhat.com>
References: <1211274764371-git-send-email-swhiteho@redhat.com>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Tue, 20 May 2008 11:05:28 +0100
Message-Id: <1211277928.3458.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following bug fixes,

Steve.

----------------------------------------------------------------------------
The following changes since commit 492c2e476eac010962850006c49df326919b284c:
  Linus Torvalds (1):
        Linux 2.6.26-rc2

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git

Andrew Price (1):
      [GFS2] Fix cast from unsigned int to s64

Bob Peterson (1):
      [GFS2] filesystem consistency error from do_strip

Jean Delvare (1):
      [GFS2] Prefer strlcpy() over snprintf()

 fs/gfs2/glops.c      |    2 +-
 fs/gfs2/incore.h     |    1 +
 fs/gfs2/inode.c      |   10 +++++-----
 fs/gfs2/meta_io.c    |    6 ++++--
 fs/gfs2/ops_fstype.c |    4 ++--
 fs/gfs2/ops_super.c  |   16 +++++++++-------
 fs/gfs2/rgrp.c       |    2 +-
 7 files changed, 23 insertions(+), 18 deletions(-)


