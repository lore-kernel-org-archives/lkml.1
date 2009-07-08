Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbZGHPpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbZGHPpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbZGHPox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:44:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:51206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbZGHPow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:44:52 -0400
Date: Wed, 8 Jul 2009 17:44:50 +0200
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org, Jiaying Zhang <jiayingz@google.com>
Subject: [PULL REQUEST] Quota changes for 2.6.31-rc3
Message-ID: <20090708154450.GA30616@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hit send too early...

----- Forwarded message from Jan Kara <jack@suse.cz> -----

From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL REQUEST] Quota changes for 2.6.31-rc3

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git
for_linus

  to get:

Jiaying Zhang (1):
      quota: Fix possible deadlock during parallel quotaon and quotaoff

The diffstat is

 fs/quota/dquot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

----- End forwarded message -----
