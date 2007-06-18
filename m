Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbXFRPRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbXFRPRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763795AbXFRPRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:17:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763967AbXFRPRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:17:09 -0400
Subject: [GFS2/DLM] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <11821784703600-git-send-email-swhiteho@redhat.com>
References: y  <11821784703600-git-send-email-swhiteho@redhat.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 18 Jun 2007 16:13:15 +0100
Message-Id: <1182179595.8765.50.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patches from the GFS2 fixes git tree,

Steve.

------------------------------------------------------------------------

The following changes since commit 188e1f81ba31af1b65a2f3611df4c670b092bbac:
  Linus Torvalds (1):
        Linux 2.6.22-rc5

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git

Benjamin Marzinski (1):
      [GFS2] flush the glock completely in inode_go_sync

Josef Bacik (1):
      [DLM] keep dlm from panicing when traversing rsb list in debugfs

Nate Diller (1):
      [GFS2] use zero_user_page

Satyam Sharma (1):
      [DLM] fix a couple of races

 fs/dlm/config.c   |   15 +++++++++++----
 fs/dlm/debug_fs.c |    9 ++++++++-
 fs/gfs2/bmap.c    |    6 +-----
 fs/gfs2/glops.c   |    2 +-
 4 files changed, 21 insertions(+), 11 deletions(-)


