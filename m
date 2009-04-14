Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZDNOJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZDNOJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZDNOJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:09:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60125 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZDNOI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:08:59 -0400
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] fuse fixes for 2.6.30-rc2
Message-Id: <E1LtjJl-0005Kp-SR@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Apr 2009 16:08:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following fuse fixes for 2.6.30 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos

---
Miklos Szeredi (2):
      fuse: fix argument type in fuse_get_user_pages()
      fuse: fix "direct_io" private mmap

---
 fs/fuse/file.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)
