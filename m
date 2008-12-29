Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYL2EVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYL2EVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 23:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYL2EVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 23:21:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36647
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbYL2EVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 23:21:12 -0500
Date: Sun, 28 Dec 2008 20:21:15 -0800 (PST)
Message-Id: <20081228.202115.210807179.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: nhorman@tuxdriver.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: origin tree build warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081229151749.8dd82c02.sfr@canb.auug.org.au>
References: <20081229113525.89450db7.sfr@canb.auug.org.au>
	<20081228.200145.33502228.davem@davemloft.net>
	<20081229151749.8dd82c02.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Dec 2008 15:17:49 +1100

> On Sun, 28 Dec 2008 20:01:45 -0800 (PST) David Miller <davem@davemloft.net> wrote:
> >
> > I'll take care of all of these issues, along with the
> 
> Thanks.
> 
> > ibmveth et al. ones you reported seperately.
> 
> Linus already took my patches for cifs, ibmveth and ehea (probably
> assuming that they were trivial).

Yep I noticed that, thanks a lot Stephen.
