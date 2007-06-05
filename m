Return-Path: <linux-kernel-owner+w=401wt.eu-S932269AbXFEITl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbXFEITl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761054AbXFEITL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:19:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45103
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbXFEITH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:19:07 -0400
Date: Tue, 05 Jun 2007 01:19:22 -0700 (PDT)
Message-Id: <20070605.011922.102574871.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1HvU8y-0000xG-00@dorka.pomaz.szeredi.hu>
References: <E1HvTgf-0000sb-00@dorka.pomaz.szeredi.hu>
	<20070605.005521.28788982.davem@davemloft.net>
	<E1HvU8y-0000xG-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 05 Jun 2007 10:11:56 +0200

> > > I just want to win the "who's laziest?" league.  It would take me
> > > about 5 minutes to get the netdev tree and test compile the change.
> > > Of which 5 seconds would be actually updating the patch.  I was
> > > thought it was OK to pass that 5 seconds worth of hard work to you in
> > > order to save the rest ;)
> > 
> > That tradeoff is fine, if, in return you'll do the rest of the
> > networking subsystem maintainership work I need to to. :-)
> 
> Well, I _did_ save you quite a bit of time by tracking down these
> bugs.  That 5 sec of dedication in exchange would have really made me
> feel good ;(

The only reason I can process as many patches as I can every day is
that I depend upon the end-nodes (that's you) doing most of the
time intensive work so that I can concentrate on reviewing patches
for correctness and proper implementation.

In any event, thanks for respinning the patch, it's late here so
I'll review it tomorrow.

