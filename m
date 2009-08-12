Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbZHLKgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbZHLKgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbZHLKgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:36:53 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43534 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbZHLKgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:36:52 -0400
Date: Wed, 12 Aug 2009 06:36:53 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, subrata@linux.vnet.ibm.com,
       Artem.Bityutskiy@nokia.com, David.Woodhouse@intel.com
Subject: [git patch] remove zero-length file
Message-ID: <20090812103653.GA5800@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'zerolen' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git zerolen

to receive the following updates:

 0 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 drivers/mtd/maps/sbc8240.c

Jeff Garzik (1):
      Remove zero-length file drivers/mtd/maps/sbc8240.c

diff --git a/drivers/mtd/maps/sbc8240.c b/drivers/mtd/maps/sbc8240.c
deleted file mode 100644
index e69de29..0000000
