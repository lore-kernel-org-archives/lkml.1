Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYITHYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYITHYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 03:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbYITHYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 03:24:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47990
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYITHYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 03:24:33 -0400
Date: Sat, 20 Sep 2008 00:24:20 -0700 (PDT)
Message-Id: <20080920.002420.267472325.davem@davemloft.net>
To: horms@verge.net.au
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080916020100.GA23389@verge.net.au>
References: <20080915.132716.267218808.davem@davemloft.net>
	<20080915.141159.181213705.davem@davemloft.net>
	<20080916020100.GA23389@verge.net.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Tue, 16 Sep 2008 12:01:18 +1000

> On Mon, Sep 15, 2008 at 02:11:59PM -0700, David Miller wrote:
> 
> [snip]
> > 
> > Not a 2.6.27 regression, this problem has been there forever.
> > 
> > 	Magnus Damm (2):
> > 	      smc91x: fix nowait printout
> > 
> > This one is good but the commit message needs to be fixed up.
> > It references a raw SHA1 ID but does not give the commit message
> > header line as well, which is a requirement.
> > 
> >       smc91x: SMC_IO_SHIFT platform data support for default case
> > 
> > Ok, but needs commit header line text for referenced commit.
> 
> can you confirm that the commit message requirement stands even
> if the SHA1 ID references Linus' tree? I personally think that is
> reasonable, I just want to confirm that is the requirement.

Yes, because the commit messages will propagate back usually
verbatim for changes backported into the -stable branches.
