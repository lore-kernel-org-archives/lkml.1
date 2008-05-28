Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbYE1Cac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbYE1Cac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 22:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYE1CaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 22:30:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbYE1CaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 22:30:24 -0400
Date: Tue, 27 May 2008 19:29:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Artem.Bityutskiy@nokia.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can UBIFS be taken to linux-next?
Message-Id: <20080527192942.f4e3dd7b.akpm@linux-foundation.org>
In-Reply-To: <20080528114112.b8600074.sfr@canb.auug.org.au>
References: <483BA79F.9030100@nokia.com>
	<20080528114112.b8600074.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 11:41:12 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Artem,
> 
> On Tue, 27 May 2008 09:18:07 +0300 Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:
> >
> > we would like to ask for UBIFS mainline inclusion the next merge window.
> > Of course we cannot say for sure whether Linus will merge it or not,
> > but it would be helpful to have it in your tree for some time anyway.
> > UBIFS is already in -mm tree so I assume it should not have too many
> > build issues.
> 
> OK, my requirements are that you intend for it to be integrated in the
> next merge window, that it be reviewed and that it be unit tested (i.e.
> tested as well as you can in isolation).  You seem to have done all that,
> so I will add it.
> 
> I will put it at the end of the merge today.
> 
> Andrew, does that make sense to you?

I'm not aware of any issues which would block a 2.6.27 merge.

I haven't reviewed the filesystem myself.  Christoph Hellwig seems to
have had a good go through it and had numerous review comments, but it
is unclear what stage things are at with addressing them?
