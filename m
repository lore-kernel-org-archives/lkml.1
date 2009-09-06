Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbZIFS7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbZIFS7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbZIFS7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:59:07 -0400
Received: from mail.pxnet.com ([195.227.45.7]:51454 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131AbZIFS7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:59:04 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 0/4] ISDN patches for 2.6.32
To: davem@davemloft.net, Karsten Keil <keil@b1-systems.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20090906-patch-capi-0.tilman@imap.cc>
Date: Sun,  6 Sep 2009 20:58:52 +0200 (CEST)
X-Spam-Score: -1.489 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

following are four patches for the Kernel CAPI ISDN subsystem which arose as
by-products of my work on the Gigaset driver: one documentation update, two
bugfixes (acked by the ISDN maintainer), and a debugging aid. Would you please
take them into your net tree for merging in kernel release 2.6.32.

Thanks,
Tilman

