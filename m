Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbXFRPem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbXFRPem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763770AbXFRPeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:34:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763696AbXFRPef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:34:35 -0400
Subject: Re: [Cluster-devel] [GFS2/DLM] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1182179595.8765.50.camel@quoit>
References: y  <11821784703600-git-send-email-swhiteho@redhat.com>
	 <1182179595.8765.50.camel@quoit>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 18 Jun 2007 16:30:09 +0100
Message-Id: <1182180609.8765.55.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2007-06-18 at 16:13 +0100, Steven Whitehouse wrote:
> Hi,
> 
> Please consider pulling the following patches from the GFS2 fixes git tree,
> 
> Steve.
> 
Dave Teigland has just asked me not to push the fourth patch in the
series until later, so there are now only three patches in the set.
Sorry about that. An updated change log is below:

Steve.

--------------------------------------------------
The following changes since commit 188e1f81ba31af1b65a2f3611df4c670b092bbac:
  Linus Torvalds (1):
        Linux 2.6.22-rc5

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git

Benjamin Marzinski (1):
      [GFS2] flush the glock completely in inode_go_sync

Nate Diller (1):
      [GFS2] use zero_user_page

Satyam Sharma (1):
      [DLM] fix a couple of races

 fs/dlm/config.c |   15 +++++++++++----
 fs/gfs2/bmap.c  |    6 +-----
 fs/gfs2/glops.c |    2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)


