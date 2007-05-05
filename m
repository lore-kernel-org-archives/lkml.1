Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXEEUSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXEEUSb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbXEEUSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:18:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48849 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbXEEUSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:18:30 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL -mm] Unionfs updates
Date: Sat,  5 May 2007 16:18:22 -0400
Message-Id: <11783963052286-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches (also available though the git tree) fix few small
bugs in Unionfs.

You can pull from 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git

to receive the following:

Adrian Brunyate (2):
      Unionfs: Accept MS_SILENT during remount
      Unionfs: Check remount options for being NULL

Adrian Bunk (1):
      fix unionfs compilation

 fs/unionfs/super.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

Josef 'Jeff' Sipek.

jsipek@cs.sunysb.edu


