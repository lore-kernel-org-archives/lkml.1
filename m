Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbYEANDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbYEANDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758009AbYEANDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:03:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39308 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbYEANDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:03:12 -0400
Date: Wed, 30 Apr 2008 08:02:57 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080430080257.7e0e7a4b@infradead.org>
In-Reply-To: <1209645764.25560.547.camel@pmac.infradead.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
	<20080501011346.522f9846.akpm@linux-foundation.org>
	<20080430071526.1bce202c@infradead.org>
	<1209645764.25560.547.camel@pmac.infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2008 13:42:44 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2008-04-30 at 07:15 -0700, Arjan van de Ven wrote:
> > Maybe that's a "boggle" for you; but for me that's symptomatic of
> > where we are today: We don't make (effective) prioritization
> > decisions. Such decisions are hard, because it effectively means
> > telling people "I'm sorry but your bug is not yet important". 
> 
> It's not that clear-cut, either. Something which manifests itself as a
> build failure or an immediate test failure on m68k alone, might
> actually turn out to cause subtle data corruption on other platforms.
> 
> You can't always know that it isn't important, just because it only
> shows up in some esoteric circumstances. You only really know how
> important it was _after_ you've fixed it.
> 
> That obviously doesn't help us to prioritise.

absolutely. I'm not going to argue that prioritization is easy. Or 
that we'll be able to get it right all the time.
Doesn't mean we shouldn't try at least somewhat..

> 
