Return-Path: <linux-kernel-owner+w=401wt.eu-S1763595AbYJJTsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763595AbYJJTsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761579AbYJJTsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:48:16 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:43942 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760916AbYJJTsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:48:15 -0400
Date: Fri, 10 Oct 2008 20:48:12 +0100
From: Nick Warne <nick@ukfsn.org>
To: FD Cami <francois.cami@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alex Howells <alex@bytemark.co.uk>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] Remove Andrew Morton's old email accounts
Message-ID: <20081010204812.5ef36353@sauron.linicks.net>
In-Reply-To: <20081010212553.4c80d595@moria>
References: <20081010151539.6a2ff040@sauron.linicks.net>
	<48EF6B47.1080800@bytemark.co.uk>
	<20081010093427.31ddb955.randy.dunlap@oracle.com>
	<20081010192600.547eedcc@moria>
	<20081010111031.9518a142.akpm@linux-foundation.org>
	<20081010212553.4c80d595@moria>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 21:25:53 +0200
FD Cami <francois.cami@free.fr> wrote:

> On Fri, 10 Oct 2008 11:10:31 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 10 Oct 2008 19:26:00 +0200 FD Cami <francois.cami@free.fr>
> > wrote:
> > 
> > > Also, should we change all instances of your old email addresses
> > > to the current one ?
> > 
> > If they're there, please just delete any email address.  People can
> > use the real name an an index into MAINTAINERS to find the current
> > email address.
> 
> Remove Andrew Morton's email addresses.
> There is still one akpm@osdl.org living in
> linux-2.6.27/Documentation/zh_CN/SubmittingDrivers but I am not sure
> how not to break this file. Li Yang CC'ed for this reason.
> 
> Should we think about systematically removing maintainers' email
> addresses from the code and documentation ?

I guess the easiest thing to do is have a Documents/mail_addresses file
that gets referred to (and updated) as and when.

Nick
-- 
Free Software Foundation Associate Member 5508
