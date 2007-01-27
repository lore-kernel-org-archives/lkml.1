Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbXA0UKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbXA0UKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbXA0UKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:10:40 -0500
Received: from 1wt.eu ([62.212.114.60]:2181 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbXA0UKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:10:39 -0500
Date: Sat, 27 Jan 2007 21:09:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@osdl.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Ingo@maccavity.nachtwache.org, Christoph@maccavity.nachtwache.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Martin J. Bligh" <mbligh@mbligh.org>, Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@osdl.org>, Molnar <mingo@redhat.com>,
       ltt-dev@shafik.org, systemtap@sources.redhat.com,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@eecs.ku.edu>
Subject: Re: [Ltt-dev] [PATCH 00/09] atomic.h : standardizing atomic primitives
Message-ID: <20070127200910.GC24090@1wt.eu>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca> <20070127021834.e26e955d.akpm@osdl.org> <20070127181116.GA5158@Krystal> <20070127120512.04a98fcd.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127120512.04a98fcd.akpm@osdl.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 12:05:12PM -0800, Andrew Morton wrote:
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
> 
> There used to be someone who had a full suite, and who regularly published
> cross-compile results, but he stopped 6-12 months ago and I forget who that
> clever person was?

Wasn't it buildroot from Erik Andersen ?

   http://buildroot.uclibc.org/

Willy

