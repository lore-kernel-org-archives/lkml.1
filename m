Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbXFEIM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbXFEIM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbXFEIMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:12:12 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45756 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbXFEIML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:12:11 -0400
To: davem@davemloft.net
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20070605.005521.28788982.davem@davemloft.net> (message from
	David Miller on Tue, 05 Jun 2007 00:55:21 -0700 (PDT))
Subject: Re: [PATCH] fix race in AF_UNIX
References: <E1Hv980-0006gQ-00@dorka.pomaz.szeredi.hu>
	<20070605.000247.18308209.davem@davemloft.net>
	<E1HvTgf-0000sb-00@dorka.pomaz.szeredi.hu> <20070605.005521.28788982.davem@davemloft.net>
Message-Id: <E1HvU8y-0000xG-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 05 Jun 2007 10:11:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I just want to win the "who's laziest?" league.  It would take me
> > about 5 minutes to get the netdev tree and test compile the change.
> > Of which 5 seconds would be actually updating the patch.  I was
> > thought it was OK to pass that 5 seconds worth of hard work to you in
> > order to save the rest ;)
> 
> That tradeoff is fine, if, in return you'll do the rest of the
> networking subsystem maintainership work I need to to. :-)

Well, I _did_ save you quite a bit of time by tracking down these
bugs.  That 5 sec of dedication in exchange would have really made me
feel good ;(

Miklos
