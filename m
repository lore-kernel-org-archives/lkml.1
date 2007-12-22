Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbXLVX2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbXLVX2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 18:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbXLVX2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 18:28:37 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:8270 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbXLVX2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 18:28:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gBIQyearK6aWdH3mtv2sbE74F7wkELqCODRs8JMFafrAhCGM/Gd13xCzT/7A1e9NRJXkN23gobUYiB1J/lLLpR6Ngu0vONm2zd2ZBWkRHMb2fOE29PzGZe3pAOwx4iTn8UPDqNeOzgfUA+mI/x/Q/YQcpyRwTKyb6Li7cMUKI2I=
Message-ID: <ea9232d10712221528v30f1bdf1sc6820678670555ec@mail.gmail.com>
Date: Sun, 23 Dec 2007 00:28:34 +0100
From: "Karol Swietlicki" <magotari@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: slabtop replacement was Re: Major regression on hackbench with SLUB (more numbers)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20071222194620.GA19350@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
	 <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
	 <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	 <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
	 <20071222100326.GF26157@elte.hu>
	 <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
	 <20071222194620.GA19350@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/12/2007, Andi Kleen <andi@firstfloor.org> wrote:
> A manpage for slabinfo would be useful though. Anybody
> volunteering to write one?
>
> -Andi

That would be me.
I'm a newbie and never wrote a man page before, so it will take a few
days, but I'm bored and out of ideas for any new code for the moment
being. Should be fun.

Karol Swietlicki
