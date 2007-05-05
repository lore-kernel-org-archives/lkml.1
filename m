Return-Path: <linux-kernel-owner+w=401wt.eu-S934237AbXEESGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbXEESGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934242AbXEESGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:06:53 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:42375 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934237AbXEESGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:06:52 -0400
Date: Sat, 5 May 2007 14:06:37 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMware, x86_64 and 2.6.21.
In-Reply-To: <20070505095609.GB9935@infradead.org>
Message-ID: <alpine.DEB.0.98.0705051359410.5496@sigma.j-a-k-j.com>
References: <1177998147.8981.16.camel@nigel.suspend2.net>
 <1178031475.3448.0.camel@laptopd505.fenrus.org> <1178032456.13953.12.camel@nigel.suspend2.net>
 <20070505095609.GB9935@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > if you want to ask questions about proprietary kernel stuff you're
> > > better off asking the vendor directly, not lkml
> > 
> > I did, but given that it the failure only appeared with a change of
> > vanilla kernel version, I didn't think it was out of place to ask here
> > too.
> 
> No, it's still totally offtopic here.

And a change of vanilla kernel version leading to breakage is not a 
sufficient condition to conclude the kernel's at fault. The entire history 
of computing is saturated with examples of coders doing stupid things with 
foolish assumptions and incidental interfaces of operating systems (early 
games on *-DOS being a prime example) that are subsequently broken by new 
versions of the operating system. That's programs being stupid, not the 
operating system.
