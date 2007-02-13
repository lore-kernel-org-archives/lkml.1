Return-Path: <linux-kernel-owner+w=401wt.eu-S1751334AbXBMWSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbXBMWSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXBMWSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:18:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44508 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbXBMWSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:18:13 -0500
Date: Tue, 13 Feb 2007 23:18:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: Please pull x86 updates
Message-ID: <20070213221809.GI29492@one.firstfloor.org>
References: <200702131340.57004.andi@firstfloor.org> <20070213140051.70de4b2c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213140051.70de4b2c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 02:00:51PM -0800, Andrew Morton wrote:
> > On Tue, 13 Feb 2007 13:40:56 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> > Linux please pull from
> > 
> >   git://one.firstfloor.org/home/andi/git/linux-2.6
> > 
> > This is not all, but I pruned lots of stuff that still wasn't
> > quite ready. Less is more I guess.
> 
> I guess this means that hrtimers&dynticks remains on hold.

Why? 

The far majority of patches are included. Which patch do hrtimers/dynticks need
which are missing?

> Do you have a feel
> for when batch #2 will be pushed?

I only removed things that had unresolved technical issues. It depends
on when they are resolved.

-Andi
