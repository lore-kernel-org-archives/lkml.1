Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334Ab0AKMXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0AKMXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304Ab0AKMXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:23:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab0AKMXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:23:54 -0500
Date: Mon, 11 Jan 2010 13:23:56 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL] Quota fix for 2.6.33
Message-ID: <20100111122356.GB3184@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Jan Kara (1):
      quota: Fix dquot_transfer for filesystems different from ext4

The diffstat is

 fs/quota/dquot.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
