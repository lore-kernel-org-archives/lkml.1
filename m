Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbXL2SId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbXL2SId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 13:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbXL2SIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 13:08:24 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:47669 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbXL2SIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:08:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YmAQtgQK3ZKf4Ovuc8F0h6W9d2t3rzzr5HGxAtiEYqEgChYJWsHkIqsTSEo1Zc6SCKROvsgM0OZwooSicre4AozCbacqaFxQrR9bliJUkalC0vuquuaxMb3bsR1d7t9FkpekKxYSq6+RihnnRVuAyqk1kS6hQA4K0qrVawbRTaE=
Message-ID: <ea9232d10712291008n5f37453eke796dfc2b423f33c@mail.gmail.com>
Date: Sat, 29 Dec 2007 19:08:22 +0100
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
In-Reply-To: <ea9232d10712221528v30f1bdf1sc6820678670555ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
	 <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
	 <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	 <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
	 <20071222100326.GF26157@elte.hu>
	 <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
	 <20071222194620.GA19350@one.firstfloor.org>
	 <ea9232d10712221528v30f1bdf1sc6820678670555ec@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/12/2007, Karol Swietlicki <magotari@gmail.com> wrote:
> On 22/12/2007, Andi Kleen <andi@firstfloor.org> wrote:
> > A manpage for slabinfo would be useful though. Anybody
> > volunteering to write one?
> >
> > -Andi
>
> That would be me.
> I'm a newbie and never wrote a man page before, so it will take a few
> days, but I'm bored and out of ideas for any new code for the moment
> being. Should be fun.
>
> Karol Swietlicki

I'm dropping out from this one.
I worked for a good while, and I really see no way of improving what
the usage information (slabinfo -h) already provides. It's a good
description, and I'm starting to think that adding a man page is
overkill. If I am misunderstanding something and what is desired is in
fact usage information in the man page format, I can provide such a
page, no problem.

At least now I know how to write man pages.

Karol Swietlicki
