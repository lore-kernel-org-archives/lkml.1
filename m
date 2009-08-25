Return-Path: <linux-kernel-owner+w=401wt.eu-S1750913AbZHYMpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbZHYMpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 08:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZHYMpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 08:45:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:44177 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZHYMpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 08:45:43 -0400
Date: Tue, 25 Aug 2009 14:45:44 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: [PULL REQUEST] ext3 improvements for 2.6.31-rc8
Message-ID: <20090825124544.GD405@duck.novell.com>
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
      ext3: Improve error message that changing journaling mode on remount is not possible

Theodore Ts'o (1):
      ext3: Update Kconfig description of EXT3_DEFAULTS_TO_ORDERED

The diffstat is

 fs/ext3/Kconfig |   32 +++++++++++++++++---------------
 fs/ext3/super.c |   40 +++++++++++++++++++++++++++-------------
 2 files changed, 44 insertions(+), 28 deletions(-)

                                                        Thanks
                                                                Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
