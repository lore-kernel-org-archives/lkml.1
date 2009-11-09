Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZKIE6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZKIE6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 23:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZKIE6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 23:58:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51271
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228AbZKIE6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 23:58:45 -0500
Date: Sun, 08 Nov 2009 20:59:11 -0800 (PST)
Message-Id: <20091108.205911.177751843.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, wg@grandegger.com, haas@ems-wuensche.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091109130323.5dcc7829.sfr@canb.auug.org.au>
References: <20091109130323.5dcc7829.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 9 Nov 2009 13:03:23 +1100

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/can/usb/ems_usb.c between commit
> 2b2072e902848a63168570f500a5726744b3873a ("ems_usb: Fix byte order issues
> on big endian machines") from the net-current tree and commit
> 7b6856a0296a8f187bb88ba31fa83a08abba7966 ("can: provide library functions
> for skb allocation") from the net tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix
> for a while.

I'll do a merge and resolve this, thanks Stephen!
