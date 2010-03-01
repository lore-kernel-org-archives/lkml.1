Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0CADVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 22:21:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50679
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966Ab0CADVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 22:21:04 -0500
Date: Sun, 28 Feb 2010 19:21:21 -0800 (PST)
Message-Id: <20100228.192121.244104789.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, joe@perches.com,
       hartleys@visionengravers.com
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100301142002.ee497fd8.sfr@canb.auug.org.au>
References: <20100301142002.ee497fd8.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Mar 2010 14:20:02 +1100

> Today's linux-next merge of the net tree got a conflict in
> drivers/firmware/iscsi_ibft.c between commit
> 00e7825b943f486e80ff1305cd0594d8791870f8 ("drivers/firmware/iscsi_ibft.c:
> remove NIPQUAD_FMT, use %pI4") from Linus' tree and commit
> 2c35294853b2e977bdfc9e401b7b6d881fcaa69b ("drivers/firmware/iscsi_ibft.c:
> use %pM to show MAC address") from the net tree.
> 
> Just a trivial context change.  I fixed it up and can carry the change as
> necessary.

Thanks Stephen, I'll fix this up.
