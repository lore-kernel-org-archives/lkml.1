Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbZFXN3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbZFXN3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZFXN3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:29:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:51098 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZFXN3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:29:35 -0400
Date: Wed, 24 Jun 2009 15:29:37 +0200
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] UDF changes for 2.6.31-rc1 (fwd)
Message-ID: <20090624132937.GA16373@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Forgot to add CC...

----- Forwarded message from Jan Kara <jack@suse.cz> -----

From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL REQUEST] UDF changes for 2.6.31-rc1

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get:

Jan Kara (1):
      udf: Use device size when drive reported bogus number of written blocks

Roel Kluin (1):
      udf: remove redundant tests on unsigned

The diffstat is

 fs/udf/balloc.c   |    9 ++++-----
 fs/udf/lowlevel.c |    7 ++++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

----- End forwarded message -----
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
