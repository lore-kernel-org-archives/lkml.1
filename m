Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZLAQpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZLAQpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZLAQpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:45:10 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:33177 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZLAQpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:45:09 -0500
Date: Tue, 1 Dec 2009 10:44:33 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] SLAB: Make synthetic benchmark output more readable
In-Reply-To: <4B14BA8C.3090500@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.0912011043430.8841@router.home>
References: <1259486553-4037-1-git-send-email-penberg@cs.helsinki.fi> <alpine.DEB.2.00.0911301333150.30639@chino.kir.corp.google.com> <4B14BA8C.3090500@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Pekka Enberg wrote:

> On Sun, 29 Nov 2009, Pekka Enberg wrote:
> > > This patch makes the synthetic SLAB benchmark output easier to read by
> > > hymans
> > > and easier to post-process with scripts. The output looks as follows:
>
> David Rientjes kirjoitti:
> > Pekka, are you looking to push slab_test.c through your tree?  If so, it
> > might make it easier to get the other tests (vmstat_test and pagealloc_test)
> > added through Andrew.
>
> Yes, I am. I'm just waiting for Christoph to ACK/NAK my readability updates
> before putting it in linux-next.

I looked at it and I see nothing negative. But there were some complaints
that my patches were a bit rough which is true. Should use proper percpu
variables and follow conventions.

