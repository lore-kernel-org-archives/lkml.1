Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0BBKEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 05:04:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab0BBKEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 05:04:24 -0500
Subject: [GFS2] Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 02 Feb 2010 10:07:27 +0000
Message-ID: <1265105247.2815.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patches,

Steve.

----------------------------------------------------------------------------
The following changes since commit 066000dd856709b6980123eb39b957fe26993f7b:
  Ananth N Mavinakayanahalli (1):
        Revert "x86, apic: Use logical flat on intel with <= 8 logical cpus"

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Benjamin Marzinski (1):
      GFS2: Don't withdraw on partial rindex entries

OGAWA Hirofumi (1):
      GFS2: Fix refcnt leak on gfs2_follow_link() error path

Steven Whitehouse (2):
      GFS2: Fix previous patch
      GFS2: Use GFP_NOFS for alloc structure

 fs/gfs2/ops_inode.c |    3 ++-
 fs/gfs2/rgrp.c      |    8 ++------
 2 files changed, 4 insertions(+), 7 deletions(-)


