Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZKLJtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZKLJtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 04:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZKLJtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 04:49:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZKLJtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 04:49:08 -0500
Date: Thu, 12 Nov 2009 10:49:12 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: [PULL] Build fix when ext3 is a module
Message-ID: <20091112094912.GD14528@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  I'm wearing a brown paper bag for today... Could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Stefan Schmidt (1):
      fs/jbd: Export log_start_commit to fix ext3 build.

The diffstat is

 fs/jbd/journal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
