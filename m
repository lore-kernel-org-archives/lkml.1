Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbZJLWJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbZJLWJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933427AbZJLWJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:09:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355AbZJLWJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:09:28 -0400
Date: Tue, 13 Oct 2009 00:08:51 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext3 fixes for 2.6.32-rc4
Message-ID: <20091012220851.GD3965@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Jan Kara (1):
      ext3: Update documentation about ext3 quota mount options

Theodore Ts'o (1):
      ext3: Don't update superblock write time when filesystem is read-only

The diffstat is

 Documentation/filesystems/ext3.txt |   16 ++++++++++++----
 fs/ext3/super.c                    |   13 ++++++++++++-
 2 files changed, 24 insertions(+), 5 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
