Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbZD0OyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbZD0OyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZD0Oxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:53:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZD0Oxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:53:52 -0400
Date: Mon, 27 Apr 2009 16:53:48 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] Quota fixes for 2.6.30rc4
Message-ID: <20090427145347.GF7194@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git for_linus

  to get:

Christoph Hellwig (1):
      quota: remove obsolete comments in fs/quota/Makefile

Dan Carpenter (1):
      ext2: missing unlock in ext2_quota_write()

The diffstat is

 fs/ext2/super.c   |    4 +++-
 fs/quota/Makefile |    9 ---------
 2 files changed, 3 insertions(+), 10 deletions(-)

                                                        Thanks
                                                                Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
