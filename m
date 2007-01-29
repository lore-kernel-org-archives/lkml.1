Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbXA2SkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbXA2SkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXA2Sj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:39:59 -0500
Received: from tim.rpsys.net ([194.106.48.114]:42298 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXA2Sj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:39:58 -0500
Subject: Re: [Ltt-dev] [PATCH 00/09] atomic.h : standardizing atomic
	primitives
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@osdl.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Thomas@maccavity.nachtwache.org, Christoph@maccavity.nachtwache.org,
       Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Greg@maccavity.nachtwache.org, "Martin J. Bligh" <mbligh@mbligh.org>,
       Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo@maccavity.nachtwache.org, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Paul Mackerras <paulus@samba.org>,
       Gleixner <tglx@linutronix.de>, Douglas Niehaus <niehaus@eecs.ku.edu>,
       Molnar <mingo@redhat.com>
In-Reply-To: <20070127120512.04a98fcd.akpm@osdl.org>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
	 <20070127021834.e26e955d.akpm@osdl.org> <20070127181116.GA5158@Krystal>
	 <20070127120512.04a98fcd.akpm@osdl.org>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 18:36:49 +0000
Message-Id: <1170095809.5833.72.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-01-27 at 12:05 -0800, Andrew Morton wrote:
> On Sat, 27 Jan 2007 13:11:16 -0500
> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > I am currently trying crosstool by Dan Kegel, it looks promising.
> > http://www.kegel.com/crosstool/
> 
> Yeah, I spent a frustrating two days with crosstool, managed to eke a
> number of cross-compilers out of it, but it took a *lot* of experimentation
> with gcc, glibc and binutils versions to get combinations which actually
> work.  Good luck ;)

FWIW, OpenEmbedded (http://www.openembedded.org/) is a very capable
toolchain builder amongst other things. I built an ARM toolchain for
Andrew a while back with it. I'm personally not sure of its support
outside ARM/i386 since I don't have hardware to test any other output
but others use it for a variety of targets and new ones are simple to
add due to its design.

I could probably arrange to share an ARM toolchain if there was
demand...

Richard





