Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZDWNP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZDWNP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZDWNPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:15:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50758 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZDWNPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:15:11 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 23 Apr 2009 14:13:17 +0100
Message-Id: <1240492397.29604.105.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 fixes,

Steve.

--------------------------------------------------------------------------------
The following changes since commit 091069740304c979f957ceacec39c461d0192158:
  Linus Torvalds (1):
        Linux 2.6.30-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (3):
      bitops: Add __ffs64 bitop
      GFS2: Fix bug in block allocation
      GFS2: Ensure that the inode goal block settings are updated

 fs/gfs2/rgrp.c         |   13 ++++++++++---
 include/linux/bitops.h |   19 +++++++++++++++++++
 2 files changed, 29 insertions(+), 3 deletions(-)


