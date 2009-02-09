Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbZBIBBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbZBIBBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZBIBBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:01:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55579
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbZBIBBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:01:41 -0500
Date: Sun, 08 Feb 2009 17:01:34 -0800 (PST)
Message-Id: <20090208.170134.255617349.davem@davemloft.net>
To: julia@diku.dk
Cc: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/6] drivers/isdn: introduce missing kfree
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0902082244180.25891@ask.diku.dk>
References: <Pine.LNX.4.64.0902082244180.25891@ask.diku.dk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 8 Feb 2009 22:44:47 +0100 (CET)

> Error handling code following a kmalloc should free the allocated data.
...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Also applied.

Please CC: ISDN patches to netdev as it is networking, and so
that the patch gets properly tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/

and therefore is less likely to be lost.

Thank you.
