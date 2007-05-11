Return-Path: <linux-kernel-owner+w=401wt.eu-S934197AbXEKUyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197AbXEKUyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760034AbXEKUx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:53:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:48474 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934107AbXEKUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:53:57 -0400
Message-ID: <11f674920705111353x39ec43a3taa2d05f706443e0a@mail.gmail.com>
Date: Fri, 11 May 2007 13:53:55 -0700
From: "Kevin Bowling" <lkml@kev009.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [patch] CFS scheduler, -v8
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Esben Nielsen" <nielsen.esben@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Con Kolivas" <kernel@kolivas.org>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Gene Heskett" <gene.heskett@gmail.com>, "Mark Lord" <lkml@rtr.ca>,
       "Zach Carter" <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070511193751.GC20383@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502111742.GA18132@elte.hu>
	 <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
	 <20070506082911.GA32644@elte.hu>
	 <alpine.LFD.0.98.0705061037390.25245@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0705071311040.14011@frodo.shire>
	 <463FC5D8.2090502@bigpond.net.au> <20070510130954.GC4052@ucw.cz>
	 <alpine.LFD.0.98.0705110932430.3986@woody.linux-foundation.org>
	 <20070511191824.GA7135@ucw.cz> <20070511193751.GC20383@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/07, Willy Tarreau <w@1wt.eu> wrote:
> On Fri, May 11, 2007 at 07:18:25PM +0000, Pavel Machek wrote:
> > Hi!
> >
> > > > Also notice that current cpus were not designed to work 300 years.
> > > > When we have hw designed for 50 years+, we can start to worry.
>
> On a related note, older technology is less sensible. My old VAX VLC4000
> from 1991 which received a small heatsink in exchange for its noisy fans
> is still doing well in an closed place. I'm more worried for the EPROMs
> which store the boot code. Also, I think that the RS6000 processed at
> half-micron which run the Mars rovers might run for hundreds of years
> at 30 MHz.

Not your typical RS/6000.  http://en.wikipedia.org/wiki/RAD6000

Without a doubt, decently built computers will easily last at least 10
years.  From what I can tell, the issue here was simply OS runtime?
