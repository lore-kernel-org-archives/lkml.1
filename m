Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbXEFRsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbXEFRsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 13:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXEFRsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 13:48:04 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60364 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbXEFRsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 13:48:01 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] [TRIVIAL] Small cleanups for do_path_lookup (V2)
Date: Sun,  6 May 2007 13:47:54 -0400
Message-Id: <11784736762516-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.20.g86b9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(For changes since V1, see the end of this email.)

The following 2 patches are trivial cleanups to do_path_lookup in namei.c.
Since these changes are trivial, they can go into 2.6.22-rc1 without any
problems.

Josef 'Jeff' Sipek (2):
      fs: Fix indentation in do_path_lookup
      fs: Use path_walk in do_path_lookup

diffstat for good measure:

 fs/namei.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

Josef 'Jeff' Sipek.

Changes since V1:

- Fixed up audit_inode condition (hch)


