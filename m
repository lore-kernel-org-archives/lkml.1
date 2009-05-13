Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbZEMJpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbZEMJpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 05:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbZEMJpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 05:45:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58448 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZEMJpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 05:45:24 -0400
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [git pull] fuse fix for 2.6.30-rc6
Message-Id: <E1M4B1e-00065l-SF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 13 May 2009 11:45:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fuse fix for 2.6.30 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks,
Miklos

---
Miklos Szeredi (1):
      fuse: destroy bdi on error

---
 fs/fuse/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
