Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606Ab0AKWhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0AKWhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396Ab0AKWhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:37:23 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:49961 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab0AKWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:37:22 -0500
Date: Tue, 12 Jan 2010 09:37:21 +1100
From: Simon Horman <horms@verge.net.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Marin Mitov <mitov@issp.bas.bg>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG?]Section mismatch dmar_ir_support()
Message-ID: <20100111223720.GB8096@verge.net.au>
References: <201001082127.22685.mitov@issp.bas.bg>
 <20100111132022.GC5198@verge.net.au>
 <20100111084942.29900ef5@jbarnes-piketon>
 <1263228903.3181.21755.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263228903.3181.21755.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 04:55:03PM +0000, David Woodhouse wrote:
> On Mon, 2010-01-11 at 08:49 -0800, Jesse Barnes wrote:
> > On Tue, 12 Jan 2010 00:20:22 +1100
> > Simon Horman <horms@verge.net.au> wrote:
> > 
> > > [ PCI list and maintainer CC added ]
> > > 
> > > On Fri, Jan 08, 2010 at 09:27:22PM +0200, Marin Mitov wrote:
> > > > Hi all,
> > > > 
> > > > Please, look at how many times the same patch is proposed, 
> > > > but still not fixed:-)
> > > > 
> > > > http://lkml.org/lkml/2009/10/3/3
> > > > http://lkml.org/lkml/2009/11/13/271
> > > > http://lkml.org/lkml/2009/12/4/462
> > > > http://lkml.org/lkml/2009/12/16/424
> > > > http://lkml.org/lkml/2009/12/20/21
> > > > 
> > > > Sure I could be missing some other postings :-)
> > > > 
> > > > Who could take care of it? And should we?
> > > 
> > > I've been wondering about that too.
> > > The patch seems correct to me.
> > 
> > Oh I was thinking David would pick it up.
> 
> I did; it's been in my tree for a while.

My bad, I didn't check there.

