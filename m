Return-Path: <linux-kernel-owner+w=401wt.eu-S965072AbXBQI5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072AbXBQI5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 03:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965071AbXBQI5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 03:57:03 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33976 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069AbXBQI5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 03:57:01 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [GIT PULL -mm] Unionfs/eCryptfs cleanups
Date: Sat, 17 Feb 2007 03:56:54 -0500
Message-Id: <11717026161843-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.19.gddff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You can pull from 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git

to receive the following:

Josef 'Jeff' Sipek (1):
      fs/unionfs/: Remove unused structure members & macros

Michael Halcrow (1):
      eCryptfs: convert lookup_one_len() to lookup_one_len_nd()

 fs/ecryptfs/inode.c |   10 ++++++++--
 fs/unionfs/union.h  |    9 ---------
 2 files changed, 8 insertions(+), 11 deletions(-)

Josef 'Jeff' Sipek.


