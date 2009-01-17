Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbZAQEpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbZAQEpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 23:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbZAQEoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 23:44:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48133 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZAQEox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 23:44:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090116134930.68e783aa.sfr@canb.auug.org.au>
References: <20090116134930.68e783aa.sfr@canb.auug.org.au> <20090115200315.EBE3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090115093514.f3f6b8ff.akpm@linux-foundation.org> <20090116124949.7828a559.sfr@canb.auug.org.au> <20090115175917.8e0ae536.akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-next@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: linux-next: build problem with nfs tree (Was: Re: [mmotm][PATCH] fix ia64 build error)
Date: Sat, 17 Jan 2009 04:43:52 +0000
Message-ID: <24484.1232167432@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > > I have dropped the nfs tree from linux-next for today.
> > 
> > Just for this buglet?  That sounds a bit savage.
> 
> There was another problem with the fscache code as well.  Also, this was
> reported the day before yesterday and got no response.

I've been flying to Tasmania for LCA and spending much time sitting around in
too many different airports.

> Also, the other patch that added EXPORT_SYMBOL(copy_page) "recently" was
> from December, *2007* ... Also, this is 2.6.30 material and they have a long
> time to fix it.

The patch was required Tuesday morning for my patches to build on top of
Linus's vanilla kernel.  This may have changed, but I haven't checked - too
busy enjoying my pre-LCA hols in Tas:-)

David
