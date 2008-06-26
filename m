Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYFZK6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYFZK6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 06:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYFZK6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 06:58:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:53336 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757441AbYFZK62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 06:58:28 -0400
Date: Thu, 26 Jun 2008 12:58:27 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PATCH] UDF updates for 2.6.26-rc7
Message-ID: <20080626105827.GD19451@duck.suse.cz>
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

  to get a fix of a regression which caused that some media could not be
mounted. Thanks.

									Honza

Tomas Janousek (1):
      udf: Fix regression in UDF anchor block detection

 super.c |   57 +++++++++++++++++++++++----------------------------------
 1 file changed, 23 insertions(+), 34 deletions(-)

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
