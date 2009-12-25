Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZLYU5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZLYU5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 15:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZLYU5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 15:57:05 -0500
Received: from mail.crca.org.au ([67.207.131.56]:43204 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630AbZLYU5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 15:57:05 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B35272D.7040207@crca.org.au>
Date: Sat, 26 Dec 2009 07:57:17 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [RFC] Asynchronous suspend/resume - test results
References: <200912210140.19713.rjw@sisk.pl> <200912232146.29339.rjw@sisk.pl>	<4B32D2D6.3030707@crca.org.au> <200912242310.42615.rjw@sisk.pl>
In-Reply-To: <200912242310.42615.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 24 December 2009, Nigel Cunningham wrote:
>> Hi.
> 
> Hi, 
> 
>> I built the async branch of your tree and tested it, also running
>> 2.6.33-rc1 + TuxOnIce for comparison. Dmesg for both are attached. Is
>> there anything I can/should be doing for you on top of this?
> 
> No, thanks a lot.
> 
>> I'll try Dmitry's patch on top of this a little later - other things to do first.
> 
> No need for that, the patchset contains an equivalent of the Dmitry's patch.
> 
>> I noticed that you were doing standard deviations in your stats - how
>> many runs were you basing them on?
> 
> I usually run 10 iterations of suspend-resume for each configuration.
> The raw data are at http://www.sisk.pl/kernel/data/async-suspend-updated.pdf
> if you're interested.
> 
>> Not sure that I can be bothered to do too many - too much else to do!
> 
> Sure, thanks a lot anyway.  Your data confirn that there's a measurable gain
> from suspending and resuming devices asynchronously.

It did? I thought it showed no difference at all!

I'll see if I can find the time to do the other computers, then. We're
going away for a couple of weeks on Monday, though, so I'm not sure that
I'll get the time beforehand.

Nigel
