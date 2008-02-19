Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbYBSLLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbYBSLLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYBSLLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:11:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38614
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbYBSLLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:11:11 -0500
Date: Tue, 19 Feb 2008 03:11:47 -0800 (PST)
Message-Id: <20080219.031147.208077057.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: panther@balabit.hu, rjw@sisk.pl, jkosina@suse.cz, zdenek.kabelac@gmail.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: My system stops during startup with curretn git tree of
 2.6.25-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080219105419.GY23197@kernel.dk>
References: <47B9BA73.7020909@balabit.hu>
	<20080218.205134.15506436.davem@davemloft.net>
	<20080219105419.GY23197@kernel.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 19 Feb 2008 11:54:19 +0100

> On Mon, Feb 18 2008, David Miller wrote:
> > From: Laszlo Attila Toth <panther@balabit.hu>
> > Date: Mon, 18 Feb 2008 18:03:47 +0100
> > 
> > > Hello,
> > > 
> > > Rafael J. Wysocki wrote:
> > > > On Monday, 18 of February 2008, Laszlo Attila Toth wrote:
> > > >
> > > > 
> > > > All in all, I gather you wanted me to test the patch below. :-)
> > > > 
> > > > Yes, that helps.
> > > 
> > > Thanks for the testing. Dave already reverted the patch, also I don't 
> > > know I should resend it or leave it as is.
> > 
> > After this sits and gets testing and feedback for a few days
> > you'll need to resubmit the entire original patch with these
> > fixes added on top.
> > 
> > For now, it's staying reverted.
> 
> Can we please get the revert pushed out please? It renders my laptop
> unusable and I keep forgetting to revert that pesky change when testing
> new kernels.

I sent a push to Linus an hour or so ago, he should pick it up
in the morning.
