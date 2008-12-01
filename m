Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489AbYLAH1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbYLAH1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 02:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYLAH1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:27:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50657
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbYLAH1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:27:19 -0500
Date: Sun, 30 Nov 2008 23:27:19 -0800 (PST)
Message-Id: <20081130.232719.56970907.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: chas@cmf.nrl.navy.mil, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add netdev to ATM
From: David Miller <davem@davemloft.net>
In-Reply-To: <1228033389-24415-1-git-send-email-jirislaby@gmail.com>
References: <20081129.204341.88799313.davem@davemloft.net>
	<1228033389-24415-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Sun, 30 Nov 2008 09:23:09 +0100

> David Miller wrote:
> > > One fail path in hrz_probe omitted device disable. Fix it.
> > > 
> > > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > 
> > Applied, but please post all networking patches to
> > netdev@vger.kernel.org, in particular so that they
> > get properly tracked at:
> > 
> > 	http://patchwork.ozlabs.org/project/netdev/list/
> > 
> > I feel like I type this in at least 10 times a day, so
> > people please start making sure netdev is on the CC: for
> > all networking patches.
> 
> Hmm, I didn't even think this is net related. I would expect such things to
> be in drivers/net/ then. Consider the patch below for applying.
> 
> --
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Applied, thanks Jiri!
