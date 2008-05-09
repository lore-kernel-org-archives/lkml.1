Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYEIULo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYEIULo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYEIULJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:11:09 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37475 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbYEIULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:11:04 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/2 Unionfs updates/fixes/cleanups
Date: Fri,  9 May 2008 16:07:14 -0400
Message-Id: <12103636363945-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just two small changes.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (2):
      Unionfs: use new umount_begin prototype
      Unionfs: move fs/Makefile entry up to minimize merge conflicts

 Makefile        |    2 +-
 unionfs/super.c |   19 ++++---------------
 2 files changed, 5 insertions(+), 16 deletions(-)

Thanks.
---
Erez Zadok
ezk@cs.sunysb.edu
