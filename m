Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300Ab0AKQzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0AKQzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 11:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209Ab0AKQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 11:55:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:53625 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0AKQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:55:40 -0500
Subject: Re: [BUG?]Section mismatch dmar_ir_support()
From: David Woodhouse <dwmw2@infradead.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Simon Horman <horms@verge.net.au>, Marin Mitov <mitov@issp.bas.bg>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20100111084942.29900ef5@jbarnes-piketon>
References: <201001082127.22685.mitov@issp.bas.bg>
	 <20100111132022.GC5198@verge.net.au>
	 <20100111084942.29900ef5@jbarnes-piketon>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 16:55:03 +0000
Message-ID: <1263228903.3181.21755.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 08:49 -0800, Jesse Barnes wrote:
> On Tue, 12 Jan 2010 00:20:22 +1100
> Simon Horman <horms@verge.net.au> wrote:
> 
> > [ PCI list and maintainer CC added ]
> > 
> > On Fri, Jan 08, 2010 at 09:27:22PM +0200, Marin Mitov wrote:
> > > Hi all,
> > > 
> > > Please, look at how many times the same patch is proposed, 
> > > but still not fixed:-)
> > > 
> > > http://lkml.org/lkml/2009/10/3/3
> > > http://lkml.org/lkml/2009/11/13/271
> > > http://lkml.org/lkml/2009/12/4/462
> > > http://lkml.org/lkml/2009/12/16/424
> > > http://lkml.org/lkml/2009/12/20/21
> > > 
> > > Sure I could be missing some other postings :-)
> > > 
> > > Who could take care of it? And should we?
> > 
> > I've been wondering about that too.
> > The patch seems correct to me.
> 
> Oh I was thinking David would pick it up.

I did; it's been in my tree for a while.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

