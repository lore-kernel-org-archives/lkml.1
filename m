Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbZG3PlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbZG3PlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZG3PlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:41:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbZG3PlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:41:09 -0400
Date: Thu, 30 Jul 2009 17:41:08 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PULL] UDF fix for 2.6.31-rc4
Message-ID: <20090730154108.GE28556@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get:

Jan Kara (1):
      udf: Fix loading of VAT inode when drive wrongly reports number of recorded blocks

The diffstat is

 fs/udf/super.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
