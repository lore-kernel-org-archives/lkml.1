Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYLSWxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYLSWxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYLSWwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:52:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:47748 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYLSWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:52:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KEjqoh8AKccPb0fvIgjihlQ2b6LuAN76o7HwG7QLcop7Y6C2LyA8gc6XPBQ5GcO0io
         IVEgvqvztAYHE121lakHXsKKFTeqHBxMLRNVvp1O4T53CVjKzfDfJzue7gJEqzFREsqk
         +mwmjgS5VL1Mtz3MMorPGe6MN/awIfzUJVxd4=
Message-ID: <a4e6962a0812191452s6fe0e887r1b09ed2561bed461@mail.gmail.com>
Date: Fri, 19 Dec 2008 16:52:51 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] v9fs changes for 2.6.28-rc9
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a1d1035631ad8b3edf301b273c30bdfc75de01e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../jejb/scsi-rc-fixes-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Duane Griffin (1):
      9p: Remove potentially bad parameter from function entry debug print.

Julia Lawall (1):
      fs/9p: change simple_strtol to simple_strtoul

Wu Fengguang (1):
      9p: convert d_iname references to d_name.name

 fs/9p/fid.c        |    4 ++--
 fs/9p/v9fs.c       |    2 +-
 fs/9p/vfs_dentry.c |    9 ++++++---
 fs/9p/vfs_inode.c  |    6 ++++--
 4 files changed, 13 insertions(+), 8 deletions(-)

    Happy Holidays,
             -eric
