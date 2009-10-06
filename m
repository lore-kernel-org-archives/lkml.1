Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbZJFWTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbZJFWTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbZJFWTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:19:10 -0400
Received: from mail.pxnet.com ([195.227.45.7]:41005 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933549AbZJFWTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:19:08 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 00/11] Gigaset driver patches for 2.6.32 (v3)
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <isdn@linux-pingi.de>,
       Karsten Keil <keil@b1-systems.de>, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091006-patch-gigaset-00.tilman@imap.cc>
Date: Wed,  7 Oct 2009 00:18:21 +0200 (CEST)
X-Spam-Score: -1.556 () AWL,BAYES_05,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third release of the series of patches for the Gigaset
drivers I first submitted on 2009-09-06. I have dropped the first patch
"gigaset: really fix chars_in_buffer" because it has now been merged
through the tty tree, and folded into the last one the fixes I posted on
2009-09-25 and 2009-10-01. Apart from that, the series is unchanged from
the second submission on 2009-09-19. It would be great if this could
still make it into release 2.6.32 as one more step on the way to get rid
of the deprecated ISDN4Linux subsystem.

Thanks,
Tilman

