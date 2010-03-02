Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab0CBQ7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 11:59:34 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33443 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0CBQ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 11:59:33 -0500
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [git pull] fuse updates for 2.6.34
Message-Id: <E1NmVRQ-0001E3-JX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 02 Mar 2010 17:59:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these fuse updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos
----

Fang Wenqi (1):
      fuse: fix large stack use

Miklos Szeredi (1):
      fuse: cleanup in fuse_notify_inval_...()

---
 fs/fuse/dev.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)
