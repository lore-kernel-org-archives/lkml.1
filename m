Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbYJXWV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbYJXWV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbYJXWVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:21:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbYJXWVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:21:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Date: Sat, 25 Oct 2008 00:25:34 +0200
User-Agent: KMail/1.9.9
Cc: Evgeniy Polyakov <s0mbre@tservice.net.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mike Galbraith <efault@gmx.de>
References: <20081009231759.GA8664@tservice.net.ru> <20081010115518.GA3159@tservice.net.ru> <20081010115725.GD19487@elte.hu>
In-Reply-To: <20081010115725.GD19487@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810250025.35734.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 of October 2008, Ingo Molnar wrote:
> 
> * Evgeniy Polyakov <s0mbre@tservice.net.ru> wrote:
> 
> > On Fri, Oct 10, 2008 at 01:42:45PM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> > > > vanilla 27: 347.222
> > > > no TSO/GSO: 357.331
> > > > no hrticks: 382.983
> > > > no balance: 389.802
> > > 
> > > okay. The target is 470 MB/sec, right? (Assuming the workload is sane 
> > > and 'fixing' it does not mean we have to schedule worse.)
> > 
> > Well, that's where I started/stopped, so maybe we will even move
> > further? :)
> 
> that's the right attitude ;)

Can anyone please tell me if there was any conclusion of this thread?

Thanks,
Rafael
