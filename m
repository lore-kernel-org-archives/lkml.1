Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZK3KaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZK3KaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZK3KaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:30:18 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51018 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZK3KaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:30:17 -0500
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [git pull] fuse bug fix
Message-Id: <E1NF3WO-0002e3-3i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Nov 2009 11:30:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following bugfix for fuse

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos
----

Csaba Henk (1):
      fuse: reject O_DIRECT flag also in fuse_create

---
 fs/fuse/dir.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
