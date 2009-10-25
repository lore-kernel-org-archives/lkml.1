Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZJYT3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZJYT3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZJYT3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:29:36 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:43548 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbZJYT3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:29:35 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 0/9] Gigaset driver patches for 2.6.33
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091023-patch-gigaset-00.tilman@imap.cc>
Date: Sun, 25 Oct 2009 20:29:27 +0100 (CET)
X-Spam-Score: -2.162 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, Karsten,

here's a series of patches that should be applied on top of those
currently in net-next. I'm sending them now to leave you enough time
before the next merge window to decide who wants to handle them.
In particular, patch 3 provides an important bugfix to the new CAPI
interface which is necessary for using it with pppd capiplugin.

Thanks,
Tilman

