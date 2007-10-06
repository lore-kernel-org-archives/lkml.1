Return-Path: <linux-kernel-owner+w=401wt.eu-S1763886AbXJFQAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763886AbXJFQAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 12:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760581AbXJFQAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 12:00:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760125AbXJFQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 12:00:09 -0400
Date: Sat, 6 Oct 2007 08:59:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Kyle McMartin <kyle@mcmartin.ca>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, airlied@linux.ie, arashi@sacredchao.net
Subject: Re: Revert "intel_agp: fix stolen mem range on G33"
In-Reply-To: <47076651.8020801@gmail.com>
Message-ID: <alpine.LFD.0.999.0710060858420.23684@woody.linux-foundation.org>
References: <4706D4B1.6050101@sacredchao.net> <20071006044221.GA14767@fattire.cabal.ca>
 <20071006053410.GB14767@fattire.cabal.ca> <20071006054234.GC14767@fattire.cabal.ca>
 <47076651.8020801@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Oct 2007, Jiri Slaby wrote:
> 
> I guess, this will break my graphics, no?
http://lkml.org/lkml/2007/9/20/447

Can you try it?

We do have a rule about "no regressions", so I think we'll have to do the 
revert, but it would be nice to hear what the consequences for the revert 
is for the affected hardware and new X.org..

		Linus
