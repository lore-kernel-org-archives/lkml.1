Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZHJKGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZHJKGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 06:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZHJKGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 06:06:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbZHJKGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 06:06:02 -0400
Date: Mon, 10 Aug 2009 12:06:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: hwpoison merge for linux-next / 2.6.32
Message-ID: <20090810100602.GC6838@basil.fritz.box>
References: <20090807084902.GA14309@basil.fritz.box> <20090810194528.a3bc0cbc.sfr@canb.auug.org.au> <20090810095535.GB6838@basil.fritz.box> <20090810200025.a32000be.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810200025.a32000be.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 08:00:25PM +1000, Stephen Rothwell wrote:
> Hi Andi,
> 
> On Mon, 10 Aug 2009 11:55:35 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> >
> > > Basically, this should be just what you would send to Linus or in this
> > > case, Ingo, (or ask him to fetch).  It is allowed to be rebased if you
> > 
> > This is practially all generic MM or VFS code, nothing for Ingo.
> 
> Sorry, cut and paste error, it should have read:

I see you have a template for this.

> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).

Yes it is (unless someone finds a fatal bug in the current version)

It's still not clear if I should do that or let Andrew do it.

Andrew, what do you prefer?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
