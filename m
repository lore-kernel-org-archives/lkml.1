Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbYFLE3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbYFLE3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 00:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYFLE3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 00:29:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53695
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbYFLE33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 00:29:29 -0400
Date: Wed, 11 Jun 2008 21:29:29 -0700 (PDT)
Message-Id: <20080611.212929.71729484.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates for .27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080612133842.0dc472bc.sfr@canb.auug.org.au>
References: <20080612023046.GA25958@havoc.gtf.org>
	<20080612133842.0dc472bc.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 Jun 2008 13:38:42 +1000

> Hi Jeff,
> 
> On Wed, 11 Jun 2008 22:30:46 -0400 Jeff Garzik <jeff@garzik.org> wrote:
> >
> > Stephen Rothwell (1):
> >       [netdrvr] Fix 8390 build breakage
> 
> That patch is actually from Tony Breeds ..

Jeff, there is still time to fix this.  If you want, just
fix up that patch in your tree to get the attribution
and author field correct, and send me a new pull request.

Thanks.
