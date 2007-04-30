Return-Path: <linux-kernel-owner+w=401wt.eu-S1161582AbXD3AFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161582AbXD3AFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161600AbXD3AFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:05:38 -0400
Received: from neon.samage.net ([85.17.153.66]:53318 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161582AbXD3AFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:05:36 -0400
Message-ID: <1182.81.207.0.53.1177891524.squirrel@secure.samage.net>
In-Reply-To: <20070429234102.GA13344@linuxtv.org>
References: <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
    <p73d51n1fup.fsf@bingen.suse.de>
    <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
    <20070429173500.GA30248@one.firstfloor.org>
    <20070429223649.GA12672@linuxtv.org>
    <2722.81.207.0.53.1177888737.squirrel@secure.samage.net>
    <20070429234102.GA13344@linuxtv.org>
Date: Mon, 30 Apr 2007 02:05:24 +0200 (CEST)
Subject: Re: Linux 2.6.21
From: "Indan Zupancic" <indan@nul.nu>
To: "Johannes Stezenbach" <js@linuxtv.org>
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Diego Calleja" <diegocg@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: a2d32f98be707cbcda8602d5fffa976a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, April 30, 2007 01:41, Johannes Stezenbach wrote:
> Developers are just humans and if they have no incentive to
> act on a bug report they will ignore it. I think this is a
> fact that you have to deal with.

Reporters are just humans too and if they have no incentive to
post bugs they won't. So it's a lose/lose situation, really.
With a group of people working together they should try to
motivate each other, not demoralize everyone.

(I know, each bug report is a pain, voicing someone's failure.
So ignoring it might make people feel better, but it doesn't
fix anything.)


> It's also not necessarily the fault of the reporter if
> a bug report gets ignored, but for every report a developer
> has to make a decision to handle it or not, and there are
> lots of reasons why he may decide to not handle it, or
> at least not now (and then forget about it).

True. There's also a difference between a bad bug report and
one that a specific developer won't handle. In the former case
anyone could recognize it and tell the reporter about it. The
latter is a bit trickier, but if the developer thinks about
looking at it later, he better can tell the reporter just that.
A short "I'll take a look at it, later, when I've more time."
is so much better than plain silence.


> But I'm quite sure that an important bug would be reported
> again until fixed.

I wouldn't be so sure about that. What's worse, why would the
reporter bother telling that the bug is fixed in version N+1?
No one cared about it anyway, so there's no one to tell it to.
That would explain a lot open bugs too.

Greetings,

Indan


