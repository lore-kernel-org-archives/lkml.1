Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbYIJJGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbYIJJGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYIJJGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:06:22 -0400
Received: from styx.suse.cz ([82.119.242.94]:57614 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751792AbYIJJGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:06:21 -0400
Date: Wed, 10 Sep 2008 11:06:20 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PATCH] UDF fix for 2.6.27-rc5
Message-ID: <20080910090620.GB19506@duck.suse.cz>
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

Christoph Hellwig (1):
      udf: add llseek method

 fs/udf/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

  Thanks.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
