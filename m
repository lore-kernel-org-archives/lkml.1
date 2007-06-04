Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbXFDWC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbXFDWC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXFDWCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:02:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49748
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbXFDWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:02:50 -0400
Date: Mon, 04 Jun 2007 15:03:04 -0700 (PDT)
Message-Id: <20070604.150304.40589968.davem@davemloft.net>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [ATA]: Don't allow to enable this for SPARC64 without PCI.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070604215841.GK20299@havoc.gtf.org>
References: <20070604210952.GI20299@havoc.gtf.org>
	<20070604.142736.27799798.davem@davemloft.net>
	<20070604215841.GK20299@havoc.gtf.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 4 Jun 2007 17:58:41 -0400

> Should be easy enough to add dma_xxx wrappers that do nothing but
> return an error.
> 
> As long as this change is _temporary_, I'm happy.

Yes, I'll work to clear this up for sure.

> As you saw from my reply, apply a driver fix for a platform problem
> makes me twitch in a big way... :)

I totally agree.
