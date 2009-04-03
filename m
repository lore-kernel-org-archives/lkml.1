Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbZDCQpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbZDCQpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbZDCQpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:45:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60574 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbZDCQpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:45:42 -0400
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] fuse updates for 2.6.30
Message-Id: <E1LpmWQ-0001NO-Q9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 03 Apr 2009 18:45:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull these fuse updates for 2.6.30 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos

---
Miklos Szeredi (2):
      fuse: allow kernel to access "direct_io" files
      fuse: allow private mappings of "direct_io" files

---
 fs/fuse/dir.c  |    1 +
 fs/fuse/file.c |   54 +++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 42 insertions(+), 13 deletions(-)
