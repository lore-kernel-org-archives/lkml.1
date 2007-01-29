Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbXA2S4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbXA2S4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXA2S4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:56:52 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:25553 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbXA2S4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:56:51 -0500
Date: Mon, 29 Jan 2007 10:49:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@osdl.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Thomas@maccavity.nachtwache.org, Christoph@maccavity.nachtwache.org,
       Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Greg@maccavity.nachtwache.org, "Martin J. Bligh" <mbligh@mbligh.org>,
       Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo@maccavity.nachtwache.org, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Paul Mackerras <paulus@samba.org>,
       Gleixner <tglx@linutronix.de>, Douglas Niehaus <niehaus@eecs.ku.edu>,
       Molnar <mingo@redhat.com>
Subject: Re: [Ltt-dev] [PATCH 00/09] atomic.h : standardizing atomic
 primitives
Message-Id: <20070129104943.a42f0c6c.randy.dunlap@oracle.com>
In-Reply-To: <1170095809.5833.72.camel@localhost.localdomain>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
	<20070127021834.e26e955d.akpm@osdl.org>
	<20070127181116.GA5158@Krystal>
	<20070127120512.04a98fcd.akpm@osdl.org>
	<1170095809.5833.72.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 18:36:49 +0000 Richard Purdie wrote:

> On Sat, 2007-01-27 at 12:05 -0800, Andrew Morton wrote:
> > On Sat, 27 Jan 2007 13:11:16 -0500
> > Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> > 
> > > I am currently trying crosstool by Dan Kegel, it looks promising.
> > > http://www.kegel.com/crosstool/
> > 
> > Yeah, I spent a frustrating two days with crosstool, managed to eke a
> > number of cross-compilers out of it, but it took a *lot* of experimentation
> > with gcc, glibc and binutils versions to get combinations which actually
> > work.  Good luck ;)
> 
> FWIW, OpenEmbedded (http://www.openembedded.org/) is a very capable
> toolchain builder amongst other things. I built an ARM toolchain for
> Andrew a while back with it. I'm personally not sure of its support
> outside ARM/i386 since I don't have hardware to test any other output
> but others use it for a variety of targets and new ones are simple to
> add due to its design.
> 
> I could probably arrange to share an ARM toolchain if there was
> demand...

I'd certainly like to see/use it.

---
~Randy
