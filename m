Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbXBDCWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbXBDCWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 21:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXBDCWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 21:22:51 -0500
Received: from imf25aec.mail.bellsouth.net ([205.152.59.73]:59783 "EHLO
	imf25aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbXBDCWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 21:22:50 -0500
Date: Sat, 3 Feb 2007 20:22:48 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: [PATCH netdev#atl1 0/3] atl1: fix whitespace, add maintainers and pci_ids
Message-ID: <20070204022248.GA4063@osprey.hogchain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches completes the final bit of tidying up in the Attansic
ethernet driver.  Sorry for nickel-and-diming you, Jeff, but this really
should be the end of it for awhile.

Summary:
1.  Clean up whitespace damage.
2.  Add a maintainers entry.
3.  Add a pci_ids entry.
---
 MAINTAINERS                     |   10 +++
 drivers/net/atl1/atl1.h         |   12 ++--
 drivers/net/atl1/atl1_ethtool.c |  120 +++++++++++++++++++++++++++-------
 drivers/net/atl1/atl1_hw.h      |   14 ++--
 drivers/net/atl1/atl1_main.c    |  137 +++++++++++++++++++--------------------
 drivers/net/atl1/atl1_param.c   |   22 +++---
 include/linux/pci_ids.h         |    2 +
 7 files changed, 200 insertions(+), 117 deletions(-)
