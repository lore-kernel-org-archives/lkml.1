Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYFRKNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYFRKNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYFRKNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:13:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:44804 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752251AbYFRKNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:13:02 -0400
Date: Wed, 18 Jun 2008 12:13:00 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PATCH] UDF fix for 2.6.26-rc7
Message-ID: <20080618101300.GE18994@duck.suse.cz>
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

  to get the one-liner fix below:

Paul Collins (1):
      udf: restore UDFFS_DEBUG to being undefined by default

 fs/udf/udfdecl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


								Thanks
									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
