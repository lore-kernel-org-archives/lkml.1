Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbYK0RXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbYK0RXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYK0RXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:23:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:48375 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751706AbYK0RXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:23:15 -0500
Date: Thu, 27 Nov 2008 18:23:13 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tibor.tajti@gmail.com
Subject: [GIT PULL] UDF tree fixes
Message-ID: <20081127172313.GG32062@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Linus,

  would you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get the following fix:
Jan Kara (1):
      udf: Fix BUG_ON() in destroy_inode()

  with diffstat:

 fs/buffer.c    |    1 +
 fs/udf/inode.c |    1 +
 2 files changed, 2 insertions(+)

								Thanks
									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
