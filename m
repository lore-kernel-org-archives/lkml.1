Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193Ab0AKQtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0AKQtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 11:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140Ab0AKQti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 11:49:38 -0500
Received: from outbound-mail-07.bluehost.com ([69.89.17.207]:44130 "HELO
	outbound-mail-07.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753054Ab0AKQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:49:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sRg/OhhcIwt8RUGinQWqPeRE5DmiPnaCzMtUZWfCSHrv7rycvSg0zMloLVeT/mv+qhKhmqQityHqRLP0vrG+r+sJjkbZ+tjDxOdcedCRBx0DKE9rnCC3JBLsGWhI7E/0;
Date: Mon, 11 Jan 2010 08:49:42 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Simon Horman <horms@verge.net.au>
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [BUG?]Section mismatch dmar_ir_support()
Message-ID: <20100111084942.29900ef5@jbarnes-piketon>
In-Reply-To: <20100111132022.GC5198@verge.net.au>
References: <201001082127.22685.mitov@issp.bas.bg>
	<20100111132022.GC5198@verge.net.au>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 00:20:22 +1100
Simon Horman <horms@verge.net.au> wrote:

> [ PCI list and maintainer CC added ]
> 
> On Fri, Jan 08, 2010 at 09:27:22PM +0200, Marin Mitov wrote:
> > Hi all,
> > 
> > Please, look at how many times the same patch is proposed, 
> > but still not fixed:-)
> > 
> > http://lkml.org/lkml/2009/10/3/3
> > http://lkml.org/lkml/2009/11/13/271
> > http://lkml.org/lkml/2009/12/4/462
> > http://lkml.org/lkml/2009/12/16/424
> > http://lkml.org/lkml/2009/12/20/21
> > 
> > Sure I could be missing some other postings :-)
> > 
> > Who could take care of it? And should we?
> 
> I've been wondering about that too.
> The patch seems correct to me.

Oh I was thinking David would pick it up.

-- 
Jesse Barnes, Intel Open Source Technology Center
