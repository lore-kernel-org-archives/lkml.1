Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZJ2IhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZJ2IhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZJ2IhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:37:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39622
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbZJ2IhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:37:14 -0400
Date: Thu, 29 Oct 2009 01:37:38 -0700 (PDT)
Message-Id: <20091029.013738.257529406.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, hjlipp@web.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 0/9] Gigaset driver patches for 2.6.33
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091023-patch-gigaset-00.tilman@imap.cc>
References: <20091023-patch-gigaset-00.tilman@imap.cc>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sun, 25 Oct 2009 20:29:27 +0100 (CET)

> David, Karsten,
> 
> here's a series of patches that should be applied on top of those
> currently in net-next. I'm sending them now to leave you enough time
> before the next merge window to decide who wants to handle them.
> In particular, patch 3 provides an important bugfix to the new CAPI
> interface which is necessary for using it with pppd capiplugin.

All of these patches look reasonable, so I've applied them
to net-next-2.6

Thanks!
