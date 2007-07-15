Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbXGOQD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbXGOQD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbXGOQDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:03:32 -0400
Received: from imf18aec.mail.bellsouth.net ([205.152.59.66]:33954 "EHLO
	imf18aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759050AbXGOQDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:03:31 -0400
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: jacliburn@bellsouth.net, csnook@redhat.com,
       atl1-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] atl1: miscellaneous cleanup and code reorganization
Date: Sun, 15 Jul 2007 11:03:24 -0500
Message-Id: <11845154092908-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please accept the following patches for the atl1 driver.

atl1: remove irq_sem
atl1: header file cleanup
atl1: cleanup atl1_main
atl1: fix excessively indented code
atl1: reorder atl1_main functions

 drivers/net/atl1/atl1.h      |  156 ++--
 drivers/net/atl1/atl1_main.c | 2176 +++++++++++++++++++++---------------------
 2 files changed, 1172 insertions(+), 1160 deletions(-)

