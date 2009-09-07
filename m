Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZIGCRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZIGCRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 22:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbZIGCRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 22:17:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:52418 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZIGCRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:17:35 -0400
Date: Mon, 7 Sep 2009 12:17:04 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Ciprian Docan <docan@eden.rutgers.edu>,
       "J.R. Okajima" <hooanon05@yahoo.co.jp>, Eric Paris <eparis@redhat.com>
Subject: [GIT] IMA regression fix
In-Reply-To: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.

The following changes since commit e07cccf4046978df10f2e13fe2b99b2f9b3a65db:
  Linus Torvalds (1):
        Linux 2.6.31-rc9

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Mimi Zohar (1):
      IMA: update ima_counts_put

 fs/namei.c                        |   22 +++++++++++++++-------
 security/integrity/ima/ima_main.c |    6 +++++-
 2 files changed, 20 insertions(+), 8 deletions(-)


-- 
James Morris
<jmorris@namei.org>
