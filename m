Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZA1QCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZA1QCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZA1QCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:02:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41977 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZA1QCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:02:00 -0500
Date: Wed, 28 Jan 2009 11:01:57 -0500
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk,
       linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Documentation/Changes: add required versions for new
	filesystems
Message-ID: <20090128160157.GA5598@nostromo.devel.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk,
	linux-btrfs@vger.kernel.org
References: <1233158441-5475-1-git-send-email-notting@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233158441-5475-1-git-send-email-notting@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Nottingham (notting@redhat.com) said: 
> btrfs requires version 0.18 of its tools, and squashfs requires
> 4.0.

This time, with a typo fix.

...

btrfs requires version 0.18 of its tools, and squashfs requires
4.0.

Signed-off-by: Bill Nottingham <notting@redhat.com>
---
 Documentation/Changes |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index cb2b141..011cc43 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -37,6 +37,8 @@ o  e2fsprogs              1.29                    # tune2fs
 o  jfsutils               1.1.3                   # fsck.jfs -V
 o  reiserfsprogs          3.6.3                   # reiserfsck -V 2>&1|grep reiserfsprogs
 o  xfsprogs               2.6.0                   # xfs_db -V
+o  squashfs-tools         4.0                     # mksquashfs -version
+o  btrfs-progs            0.18                    # btrfsck
 o  pcmciautils            004                     # pccardctl -V
 o  quota-tools            3.09                    # quota -V
 o  PPP                    2.4.0                   # pppd --version
-- 
1.6.1.1

