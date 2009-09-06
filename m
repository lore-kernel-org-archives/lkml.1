Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZIFS7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZIFS7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbZIFS7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:59:05 -0400
Received: from mail.pxnet.com ([195.227.45.7]:51451 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130AbZIFS7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:59:04 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 00/12] Gigaset driver patches for 2.6.32
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de
CC: Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090906-patch-gigaset-00.tilman@imap.cc>
Date: Sun,  6 Sep 2009 20:58:52 +0200 (CEST)
X-Spam-Score: -1.518 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

following is a series of patches for the Gigaset driver which I would
appreciate getting merged into kernel release 2.6.32.

The first one is a bugfix I had already submitted for 2.6.31 but which
seems to have fallen through the cracks. Please disregard if it's
already present your tree.

The next eight patches provide various small bugfixes, error handling
and documentation improvements.

The final three patches add an alternative interface to the driver,
connecting to the Kernel CAPI subsystem instead of the obsolescent
ISDN4Linux subsystem. They have been presented on the i4ldeveloper
mailing list and didn't draw any protests. (In fact, no comments at
all. I'm determined to take that as a positive sign.)

Would you please take these into your net tree for 2.6.32.

Thanks,
Tilman

