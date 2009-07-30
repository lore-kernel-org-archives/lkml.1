Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651AbZG3PkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbZG3PkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZG3PkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:40:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZG3PkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:40:11 -0400
Date: Thu, 30 Jul 2009 17:40:09 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PULL] Quota fix for 2.6.31-rc4
Message-ID: <20090730154009.GD28556@duck.suse.cz>
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

Jan Kara (1):
      quota: Silence lockdep on quota_on

The diffstat is

 fs/quota/dquot.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
